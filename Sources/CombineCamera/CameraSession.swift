/*
 * Copyright (c) [2024] [Denis Silko]
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *     https://github.com/silkodenis/swift-combine-camera
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import AVFoundation
import Combine

class CameraSession {
    public let session = AVCaptureSession()
    public let output: CameraOutput
    public let input: CameraInput
    private let sessionQueue = DispatchQueue(label: "CombineCamera.sessionQueue")
    private let preset: AVCaptureSession.Preset
    private var isConfigured = false
    
    internal init(preset: AVCaptureSession.Preset,
                  position: AVCaptureDevice.Position,
                  orientation: AVCaptureVideoOrientation) {
        self.input = CameraInput(devicePosition: position)
        self.output = CameraOutput(videoOrientation: orientation)
        self.preset = preset
    }
    
    public func startCapture(at position: AVCaptureDevice.Position? = nil) -> AnyPublisher<Void, CameraError> {
        CameraAccess.requestAccess()
            .flatMap(checkAccess)
            .flatMap { [unowned self] in configureIfNeeded(at: position) }
            .flatMap(start)
            .eraseToAnyPublisher()
    }
    
    public func stopCapture() -> AnyPublisher<Void, Never> {
        executeInSessionQueue { [weak self] in
            guard let self else { return }
            
            if session.isRunning == true {
                session.stopRunning()
            }
        }
    }
    
    public func switchCamera() -> AnyPublisher<Void, CameraError> {
        let newPosition: AVCaptureDevice.Position = (input.captureDevicePosition == .back) ? .front : .back
        
        return commitConfiguration { [weak self] in
            guard let self else { return }
            try input.switchPosition(self.session)
        }
        .handleEvents(receiveOutput: { [weak self] in
            guard let self else { return }
            output.updateConnectionOrientation(for: newPosition)
        })
        .eraseToAnyPublisher()
    }
}

// MARK: - Private

extension CameraSession {
    private func start() -> AnyPublisher<Void, Never> {
        executeInSessionQueue { [weak self] in
            guard let self else { return }
            
            if session.isRunning == false {
                session.startRunning()
            }
        }
    }
    
    private func checkAccess(status: CameraAccessStatus) -> AnyPublisher<Void, CameraError> {
        switch status {
        case .authorized:
            return justSuccess
        case .denied:
            return Fail(error: .denied).eraseToAnyPublisher()
        case .determined:
            return Fail(error: .determined).eraseToAnyPublisher()
        default:
            return Fail(error: .unauthorized).eraseToAnyPublisher()
        }
    }
    
    private func configureIfNeeded(at position: AVCaptureDevice.Position?) -> AnyPublisher<Void, CameraError> {
        if isConfigured {
            if let position = position, position != input.captureDevicePosition {
                return commitConfiguration { [weak self] in
                    guard let self else { return }
                    
                    try input.configure(session, at: position)
                }
            } else {
                return justSuccess
            }
        }
        
        return commitConfiguration { [weak self] in
            guard let self else { return }
            
            try setSessionPreset(preset)
            try input.configure(session)
            try output.connectToSession(session, position: position)
        }
    }
    
    private func setSessionPreset(_ preset: AVCaptureSession.Preset) throws {
        guard session.canSetSessionPreset(preset) else {
            throw CameraError.cannotSet(preset)
        }
        
        session.sessionPreset = preset
    }
    
    private func executeInSessionQueue(_ event: @escaping () -> Void) -> AnyPublisher<Void, Never> {
        Future { [weak self] promise in
            guard let self else { return }
            
            sessionQueue.async {
                event()
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }

    private func commitConfiguration(_ configuration: @escaping () throws -> Void) -> AnyPublisher<Void, CameraError> {
        Future { [weak self] promise in
            guard let self else { return }
            
            sessionQueue.async {
                self.session.beginConfiguration()
                var isSuccess = false
                
                defer {
                    self.session.commitConfiguration()
                    self.isConfigured = isSuccess
                }
                
                do {
                    try configuration()
                    isSuccess = true
                    promise(.success(()))
                } catch let error as CameraError {
                    promise(.failure(error))
                } catch {
                    promise(.failure(.unknown(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private var justSuccess: AnyPublisher<Void, CameraError> {
        Just(()).setFailureType(to: CameraError.self).eraseToAnyPublisher()
    }
}

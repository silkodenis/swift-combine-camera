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

internal class CameraInput {
    public var devicePosition: AVCaptureDevice.Position
    
    internal init(devicePosition: AVCaptureDevice.Position) {
        self.devicePosition = devicePosition
    }
    
    public func switchPosition(_ session: AVCaptureSession) throws {
        try configure(session, at: (devicePosition == .back) ? .front : .back)
    }
    
    public func configure(_ session: AVCaptureSession, at position: AVCaptureDevice.Position? = nil) throws {
        if let currentInput = session.inputs.first as? AVCaptureDeviceInput {
            session.removeInput(currentInput)
        }
        
        let input = try makeInput(at: position ?? devicePosition)
        
        guard session.canAddInput(input) else {
            throw CameraError.noCameraAvailable
        }

        session.addInput(input)
    }
    
    // MARK: - Private
    
    private func makeInput(at position: AVCaptureDevice.Position) throws -> AVCaptureDeviceInput {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else {
            throw CameraError.noCameraAvailable
        }
        
        let input = try AVCaptureDeviceInput(device: device)
        devicePosition = position
        
        return input
    }
}

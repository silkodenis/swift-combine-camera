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

internal class CameraOutput: NSObject {
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private var pixelBufferSubject = PassthroughSubject<CVPixelBuffer, Never>()
    private let videoOrientation: AVCaptureVideoOrientation
    private let outputQueue = DispatchQueue(label: "CombineCamera.outputQueue",
                                             qos: .userInitiated,
                                             attributes: [],
                                             autoreleaseFrequency: .workItem)
    
    internal init(videoOrientation: AVCaptureVideoOrientation) {
        self.videoOrientation = videoOrientation
        super.init()
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        videoDataOutput.setSampleBufferDelegate(self, queue: outputQueue)
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
    }
    
    public var pixelBuffer: AnyPublisher<CVPixelBuffer, Never> {
        pixelBufferSubject.eraseToAnyPublisher()
    }
    
    public func connectToSession(_ session: AVCaptureSession, position: AVCaptureDevice.Position?) throws {
        guard session.canAddOutput(videoDataOutput) else {
            throw CameraError.unableToAddOutput
        }
        
        session.addOutput(videoDataOutput)
        
        if let connection = videoDataOutput.connection(with: .video),
            connection.isVideoOrientationSupported {
            connection.videoOrientation = videoOrientation
            
            if let position, connection.isVideoMirroringSupported {
                connection.isVideoMirrored = (position == .front)
            }
        }
    }
    
    public func updateConnectionOrientation(for position: AVCaptureDevice.Position) {
        guard let connection = videoDataOutput.connection(with: .video),
              connection.isVideoOrientationSupported else { return }

        connection.videoOrientation = videoOrientation

        if connection.isVideoMirroringSupported {
            connection.isVideoMirrored = (position == .front)
        }
    }
}

extension CameraOutput: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer = sampleBuffer.imageBuffer else { return }
        pixelBufferSubject.send(buffer)
    }
}

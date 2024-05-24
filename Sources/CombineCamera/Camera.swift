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

/// A class for managing the camera session using Combine and AVFoundation.
public final class Camera {
    private let session: CameraSession
    
    /// Initializes a new Camera instance.
    ///
    /// - Parameters:
    ///   - preset: The capture session preset. Default is `.high`.
    ///   - position: The position of the camera. Default is `.back`.
    ///   - orientation: The orientation of the video. Default is `.portrait`.
    public init(preset: AVCaptureSession.Preset = .high,
                position: AVCaptureDevice.Position = .back,
                orientation: AVCaptureVideoOrientation = .portrait)
    {
        self.session = CameraSession(preset: preset,
                                     position: position,
                                     orientation: orientation)
    }
    
    // MARK: - Access
    
    /// The current authorization status for accessing the camera.
    public static var authorizationStatus: AnyPublisher<CameraAccessStatus, Never> {
        CameraAccess.authorizationStatus
    }
    
    /// Requests access to the camera.
    ///
    /// - Returns: A publisher that emits the camera access status.
    public static func requestAccess() -> AnyPublisher<CameraAccessStatus, Never> {
        CameraAccess.requestAccess()
    }
    
    // MARK: - Control
    
    /// Starts capturing video.
    ///
    /// - Parameter position: The position of the camera to use. Default is `nil`.
    /// If `position` is `nil`, the current position will be used. If this is the first start,
    /// the position specified during camera initialization will be used.
    /// - Returns: A publisher that emits when the capture has started or an error.
    public func startCapture(at position: AVCaptureDevice.Position? = nil) -> AnyPublisher<Void, CameraError> {
        session.startCapture(at: position)
    }
    
    /// Stops capturing video.
    ///
    /// - Returns: A publisher that emits when the capture has stopped.
    public func stopCapture() -> AnyPublisher<Void, Never> {
        session.stopCapture()
    }
    
    /// Switches the camera between front and back.
    ///
    /// - Returns: A publisher that emits when the camera has switched or an error.
    public func switchCamera() -> AnyPublisher<Void, CameraError> {
        session.switchCamera()
    }
    
    // MARK: - Output
    
    /// The current capture session.
    public var captureSession: AVCaptureSession {
        session.session
    }
    
    /// A publisher that emits the pixel buffer from the video output.
    public var pixelBuffer: AnyPublisher<CVPixelBuffer, Never> {
        session.output.pixelBuffer
    }
}

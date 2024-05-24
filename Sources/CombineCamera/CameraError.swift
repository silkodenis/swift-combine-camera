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

import Foundation
import AVFoundation

/// An enumeration that defines various errors that can occur when using the camera.
public enum CameraError: Error {
    /// Access to the camera has been denied by the user.
    case denied
    
    /// Camera access is still being determined.
    case determined
    
    /// The user is not authorized to use the camera.
    case unauthorized
    
    /// Unable to set the specified camera session preset.
    /// - Parameter sessionPreset: The camera session preset that could not be set.
    case cannotSet(_ sessionPreset: AVCaptureSession.Preset)
    
    /// No camera is available on this device.
    case noCameraAvailable
    
    /// Unable to add output to the camera session.
    case unableToAddOutput
    
    /// An unknown error occurred.
    /// - Parameter error: The underlying error that occurred.
    case unknown(Error)
}

extension CameraError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .denied:
            return "Access to the camera has been denied."
        case .determined:
            return "Camera access is still being determined."
        case .unauthorized:
            return "You are not authorized to use the camera."
        case .cannotSet(let sessionPreset):
            return "Unable to set the camera session preset: \(sessionPreset)."
        case .noCameraAvailable:
            return "No camera is available on this device."
        case .unableToAddOutput:
            return "Unable to add output to the camera session."
        case .unknown(let error):
            return "An unknown error occurred \(error.localizedDescription)."
        }
    }
}

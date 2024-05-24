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

public enum CameraError: Error {
    case denied
    case determined
    case unauthorized
    case unconfigured
    case cannotSet(_ sessionPreset: AVCaptureSession.Preset)
    case noCameraAvailable
    case unableToAddOutput
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
        case .unconfigured:
            return "The camera is not properly configured."
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

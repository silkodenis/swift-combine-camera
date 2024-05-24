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

public enum CameraAccessStatus {
    case notDetermined
    case determined
    case restricted
    case denied
    case authorized
    case unknown
}

internal struct CameraAccess {
    static internal var authorizationStatus: AnyPublisher<CameraAccessStatus, Never> {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let status: CameraAccessStatus
        
        switch authorizationStatus {
        case .notDetermined: status = .notDetermined
        case .restricted:    status = .restricted
        case .denied:        status = .denied
        case .authorized:    status = .authorized
        @unknown default:    status = .unknown
        }
        
        return Just(status).eraseToAnyPublisher()
    }
    
    static internal func requestAccess() -> AnyPublisher<CameraAccessStatus, Never> {
        authorizationStatus
            .flatMap(performAccessRequest)
            .eraseToAnyPublisher()
    }
    
    static private func performAccessRequest(for status: CameraAccessStatus) -> AnyPublisher<CameraAccessStatus, Never> {
        switch status {
        case .notDetermined:
            break
        case .denied:
            return Just(.determined).eraseToAnyPublisher()
        default:
            return Just(status).eraseToAnyPublisher()
        }

        return Future { promise in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                promise(.success(granted ? .authorized : .denied))
            }
        }
        .eraseToAnyPublisher()
    }
}

//
//  AlamofireDecodableError.swift
//  CodableAlamofire
//
//  Created by Nikita Ermolenko on 11/06/2017.
//

import Foundation

/// `AlamofireDecodableError` is the error type returned by CodableAlamofire.
///
/// - invalidKeyPath:   Returned when a nested dictionary object doesn't exist by special keyPath.
/// - emptyKeyPath:     Returned when a keyPath is empty.

public enum AlamofireDecodableError: Error {
    case invalidKeyPath
    case emptyKeyPath
}

extension AlamofireDecodableError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .invalidKeyPath:   return "Unable to connect to server. Please try after some time."
        case .emptyKeyPath:     return "Unable to connect to server. Please try after some time."
        }
    }
}

//
//  APIError.swift
//  MovieApp
//
//  Created by Yunus Emre Koca on 30.08.2022.
//

import Foundation

enum APIError: Error {
    case connectionError
    case decodeError
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .connectionError:
            return "Bağlantı hatası"
        case .decodeError:
            return "Decode hatası"
        }
    }
}

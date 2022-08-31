//
//  Trailer.swift
//  MovieApp
//
//  Created by Yunus Emre Koca on 31.08.2022.
//

import Foundation

struct Trailers: Codable {
    let items: [Trailer]
}

struct Trailer: Codable {
    let id: Video
}

struct Video: Codable {
    let videoId: String
}

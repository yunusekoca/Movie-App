//
//  Movie.swift
//  MovieApp
//
//  Created by Yunus Emre Koca on 29.08.2022.
//

import Foundation

struct Movies: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_average: Double?
    let release_date: String?
}

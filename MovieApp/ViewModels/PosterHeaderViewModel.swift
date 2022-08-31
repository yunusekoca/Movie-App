//
//  PosterHeaderViewModel.swift
//  MovieApp
//
//  Created by Yunus Emre Koca on 31.08.2022.
//

import Foundation

protocol PosterHeaderViewModelDelegate: AnyObject {
    func posterURLFetched(movie: Movie, posterURL: URL)
    func errorOccurred(errorMessage: String)
}

final class PosterHeaderViewModel {
    
    private var movie: Movie?
    
    weak var posterHeaderViewModelDelegate: PosterHeaderViewModelDelegate?
    
    func fetchMoviePoster() {
        APIService.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let trendMovies):
                guard let movie = trendMovies.randomElement() else { return }
                self?.movie = movie
                guard let headerPosterPath = movie.poster_path else { return }
                guard let posterURL = URL(string: "\(Constants.posterBaseURL)/\(headerPosterPath)") else { return }
                self?.posterHeaderViewModelDelegate?.posterURLFetched(movie: movie, posterURL: posterURL)
            case .failure(let error):
                self?.posterHeaderViewModelDelegate?.errorOccurred(errorMessage: error.localizedDescription)
            }
        }
    }
    
    func getMovie() -> Movie? {
        return movie
    }
}

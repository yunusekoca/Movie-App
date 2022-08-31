//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Yunus Emre Koca on 31.08.2022.
//

import Foundation

protocol MovieDetailsViewModelDelegate: AnyObject {
    func movieTrailerLinkFetched(url: URL)
    func errorOccurred(errorMessage: String)
}

final class MovieDetailsViewModel {
    
    private let movie: Movie
    private let dateFormatter: DateFormatter
    
    weak var homeDetailsViewModelDelegate: MovieDetailsViewModelDelegate?
    
    init(model: Movie) {
        self.movie = model
        dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = Locale(identifier: "TR-TR")
        dateFormatter.dateFormat = "YYYY-MM-DD"
    }
    
    var movieInfoText: String? {
        return movie.overview
    }
    
    var title: String? {
        return movie.original_title ?? movie.original_name
    }
    
    var releaseDate: String? {
        guard let releaseDate = movie.release_date else { return nil }
        guard let releaseDate = dateFormatter.date(from: releaseDate) else { return nil }
        dateFormatter.dateStyle = .full
        return "Vizyon Tarihi: " + dateFormatter.string(from: releaseDate)
    }
    
    func getYoutubeTrailerLink() {
        guard let movieTitle = movie.original_title ?? movie.original_name else { return }
        APIService.shared.getTrailerLinkFromYoutube(with: movieTitle + " trailer") { [weak self] result in
            switch result {
            case .success(let trailer):
                let videoId = trailer.id.videoId
                guard let url = URL(string: "https://youtube.com/embed/\(videoId)") else { return }
                self?.homeDetailsViewModelDelegate?.movieTrailerLinkFetched(url: url)
            case .failure(let error):
                self?.homeDetailsViewModelDelegate?.errorOccurred(errorMessage: error.localizedDescription)
            }
        }
    }
}

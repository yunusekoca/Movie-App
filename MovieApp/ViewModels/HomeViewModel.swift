//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Yunus Emre Koca on 29.08.2022.
//

import Foundation

fileprivate enum Sections: Int {
    case TrendMovies = 0
    case TrendTVShows = 1
    case PopularMovies = 2
    case UpcomingMovies = 3
    case TopRatedMovies = 4
}

protocol HomeViewModelDelegate: AnyObject {
    func errorOccurred(errorMessage: String)
    func reloadTable(row: Int, section: Int)
}

final class HomeViewModel {
    
    private lazy var trendMovies = [Movie]()
    private lazy var trendTVShows = [Movie]()
    private lazy var popularMovies = [Movie]()
    private lazy var upcomingMovies = [Movie]()
    private lazy var topRatedMovies = [Movie]()
    
    private lazy var sectionTitles = ["Trend Filmler", "Trend TV Şovları", "Popüler Filmler", "Yakında", "Çok Beğenilen Filmler"]
    
    weak var homeViewModelDelegate: HomeViewModelDelegate?
    
    var sectionCount: Int {
        return sectionTitles.count
    }
    
    func fetchAllDataFromAPI() {
        getTrendingMovies()
        getTrendingTVShows()
        getPopularMovies()
        getUpcomingMovies()
        getTopRatedMovies()
    }
    
    func getSectionTitle(at index: Int) -> String {
        return sectionTitles[index]
    }
    
    func getContentsInSection(section: Int) -> [Movie] {
        switch section {
        case Sections.TrendMovies.rawValue:
            return trendMovies
        case Sections.TrendTVShows.rawValue:
            return trendTVShows
        case Sections.PopularMovies.rawValue:
            return popularMovies
        case Sections.UpcomingMovies.rawValue:
            return upcomingMovies
        case Sections.TopRatedMovies.rawValue:
            return topRatedMovies
        default:
            return [Movie]()
        }
    }
    
    private func getTrendingMovies() {
        APIService.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let trendMovies):
                self?.trendMovies = trendMovies
                self?.homeViewModelDelegate?.reloadTable(row: 0, section: Sections.TrendMovies.rawValue)
            case .failure(let error):
                self?.homeViewModelDelegate?.errorOccurred(errorMessage: error.localizedDescription)
            }
        }
    }
    
    private func getTrendingTVShows() {
        APIService.shared.getTrendingTVShows { [weak self] result in
            switch result {
            case .success(let tvShows):
                self?.trendTVShows = tvShows
                self?.homeViewModelDelegate?.reloadTable(row: 0, section: Sections.TrendTVShows.rawValue)
            case .failure(let error):
                self?.homeViewModelDelegate?.errorOccurred(errorMessage: error.localizedDescription)
            }
        }
    }
    
    private func getUpcomingMovies() {
        APIService.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let upcomingMovies):
                self?.upcomingMovies = upcomingMovies
                self?.homeViewModelDelegate?.reloadTable(row: 0, section: Sections.UpcomingMovies.rawValue)
            case .failure(let error):
                self?.homeViewModelDelegate?.errorOccurred(errorMessage: error.localizedDescription)
            }
        }
    }
    
    private func getPopularMovies() {
        APIService.shared.getPopularMovies { [weak self] result in
            switch result {
            case .success(let popularMovies):
                self?.popularMovies = popularMovies
                self?.homeViewModelDelegate?.reloadTable(row: 0, section: Sections.PopularMovies.rawValue)
            case .failure(let error):
                self?.homeViewModelDelegate?.errorOccurred(errorMessage: error.localizedDescription)
            }
        }
    }
    
    private func getTopRatedMovies() {
        APIService.shared.getTopRatedMovies { [weak self] result in
            switch result {
            case .success(let topRatedMovies):
                self?.topRatedMovies = topRatedMovies
                self?.homeViewModelDelegate?.reloadTable(row: 0, section: Sections.TopRatedMovies.rawValue)
            case .failure(let error):
                self?.homeViewModelDelegate?.errorOccurred(errorMessage: error.localizedDescription)
            }
        }
    }
}

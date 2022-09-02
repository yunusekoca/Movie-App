//
//  SearchResultsViewModel.swift
//  MovieApp
//
//  Created by Yunus Emre Koca on 2.09.2022.
//

import Foundation

protocol SearchResultsViewModelDelegate: AnyObject {
    func contentQueryCompleted(contents: [Movie])
    func errorOccurred(errorMessage: String)
}

final class SearchResultsViewModel {
    
    private lazy var searchResults = [Movie]()
    
    weak var searchResultsViewModelDelegate: SearchResultsViewModelDelegate?
    
    var itemCount: Int {
        return searchResults.count
    }
    
    func getContentAtRow(row: Int) -> Movie {
        return searchResults[row]
    }
    
    func getContentsWithQuery(query: String) {
        APIService.shared.queryForContent(query: query) { [weak self] result in
            switch result {
            case .success(let contents):
                self?.searchResults = contents
                self?.searchResultsViewModelDelegate?.contentQueryCompleted(contents: contents)
            case .failure(let error):
                self?.searchResultsViewModelDelegate?.errorOccurred(errorMessage: error.localizedDescription)
            }
        }
    }
}

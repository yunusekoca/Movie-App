//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by Yunus Emre Koca on 2.09.2022.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func errorOccurred(errorMessage: String)
    func popularContentsFetched(contents: [Movie])
}

final class SearchViewModel {
    
    private lazy var popularContents = [Movie]()
    
    weak var searchViewModelDelegate: SearchViewModelDelegate?
    
    var itemCount: Int {
        return popularContents.count
    }
    
    func getContentAtRow(row: Int) -> Movie {
        return popularContents[row]
    }
    
    func getPopularContents() {
        APIService.shared.getPopularContents { [weak self] result in
            switch result {
            case .success(let popularContents):
                self?.popularContents = popularContents
                self?.searchViewModelDelegate?.popularContentsFetched(contents: popularContents)
            case .failure(let error):
                self?.searchViewModelDelegate?.errorOccurred(errorMessage: error.localizedDescription)
            }
        }
    }
}

//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Yunus Emre Koca on 2.09.2022.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private let searchViewModel: SearchViewModel
    private let collectionViewLayout: UICollectionViewFlowLayout
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Filmlerde veya dizilerde arayın"
        controller.searchBar.tintColor = .label
        return controller
    }()
    
    private lazy var collectionView: UICollectionView = {
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3.5, height: UIScreen.main.bounds.width / 2.5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        return collectionView
    }()
    
    init() {
        searchViewModel = SearchViewModel()
        collectionViewLayout = UICollectionViewFlowLayout()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Ara"
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchViewModel.searchViewModelDelegate = self
        searchController.searchResultsUpdater = self
        
        searchViewModel.getPopularContents()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            // Readjusting collectionView layout while rotating screen
            self.collectionViewLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3.5, height: UIScreen.main.bounds.width / 2.5)
        }
    }
    
    private func pushToMovieDetails(movie: Movie) {
        let movieDetailsVM = MovieDetailsViewModel(model: movie)
        let movieDetailsVC = MovieDetailsViewController(movieDetailsViewModel: movieDetailsVM)
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchViewModel.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie = searchViewModel.getContentAtRow(row: indexPath.row)
        cell.configurePosterCollectionViewCell(with: movie.poster_path)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = searchViewModel.getContentAtRow(row: indexPath.row)
        pushToMovieDetails(movie: movie)
    }
}

extension SearchViewController: SearchViewModelDelegate {
    func errorOccurred(errorMessage: String) {
        print(errorMessage)
    }
    
    func popularContentsFetched(contents: [Movie]) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard !query.isEmpty else { return }
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        resultsController.searchByQuery(query: query)
    }
}

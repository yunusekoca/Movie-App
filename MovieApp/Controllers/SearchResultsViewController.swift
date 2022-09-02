//
//  SearchResultsViewController.swift
//  MovieApp
//
//  Created by Yunus Emre Koca on 2.09.2022.
//

import UIKit

final class SearchResultsViewController: UIViewController {
    
    private let searchResultsViewModel: SearchResultsViewModel
    private let collectionViewLayout: UICollectionViewFlowLayout
    
    private lazy var collectionView: UICollectionView = {
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3.5, height: UIScreen.main.bounds.width / 2.5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        searchResultsViewModel = SearchResultsViewModel()
        collectionViewLayout = UICollectionViewFlowLayout()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchResultsViewModel.searchResultsViewModelDelegate = self
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
    
    func searchByQuery(query: String) {
        searchResultsViewModel.getContentsWithQuery(query: query)
    }
    
    private func pushToMovieDetails(movie: Movie) {
        guard let _ = movie.poster_path else { return }
        let movieDetailsVM = MovieDetailsViewModel(model: movie)
        let movieDetailsVC = MovieDetailsViewController(movieDetailsViewModel: movieDetailsVM)
        presentingViewController?.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
            return UICollectionViewCell()
        }
        let movie = searchResultsViewModel.getContentAtRow(row: indexPath.row)
        cell.configurePosterCollectionViewCell(with: movie.poster_path)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResultsViewModel.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = searchResultsViewModel.getContentAtRow(row: indexPath.row)
        pushToMovieDetails(movie: movie)
    }
}

extension SearchResultsViewController: SearchResultsViewModelDelegate {
    func contentQueryCompleted(contents: [Movie]) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func errorOccurred(errorMessage: String) {
        print(errorMessage)
    }
}

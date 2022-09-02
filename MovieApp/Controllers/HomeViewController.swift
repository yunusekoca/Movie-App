//
//  ViewController.swift
//  MovieApp
//
//  Created by Yunus Emre Koca on 29.08.2022.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let homeViewModel: HomeViewModel
    private let headerView: PosterHeaderUIView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        homeViewModel = HomeViewModel()
        let headerFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 1.4)
        headerView = PosterHeaderUIView(frame: headerFrame)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Ana Sayfa"
        
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.tableHeaderView = headerView
        
        homeViewModel.homeViewModelDelegate = self
        homeViewModel.fetchAllDataFromAPI()
        
        headerView.posterHeaderUIViewDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 1.4)
        table.frame = view.bounds
    }
    
    private func pushToMovieDetails(movie: Movie) {
        let movieDetailsVM = MovieDetailsViewModel(model: movie)
        let detailVC = MovieDetailsViewController(movieDetailsViewModel: movieDetailsVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeViewModel.sectionCount
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return homeViewModel.getSectionTitle(at: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.homeTableViewCellDelegate = self
        let movies = homeViewModel.getContentsInSection(section: indexPath.section)
        cell.configureCell(with: movies)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        header.textLabel?.textColor = .label
        header.textLabel?.sizeToFit()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func errorOccurred(errorMessage: String) {
        print(errorMessage)
    }
    
    func reloadTable(row: Int, section: Int) {
        DispatchQueue.main.async {
            self.table.reloadRows(at: [IndexPath(row: row, section: section)], with: UITableView.RowAnimation.automatic)
        }
    }
}

extension HomeViewController: HomeTableViewCellDelegate {
    func movieTappedInCell(movie: Movie) {
        pushToMovieDetails(movie: movie)
    }
}

extension HomeViewController: PosterHeaderUIViewDelegate {
    func headerPosterTapped(movie: Movie) {
        pushToMovieDetails(movie: movie)
    }
}

//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Yunus Emre Koca on 31.08.2022.
//

import UIKit
import WebKit

final class MovieDetailsViewController: UIViewController {
    
    private let movieDetailsViewModel: MovieDetailsViewModel
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var trailerWebView: WKWebView = {
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.5))
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isOpaque = false
        return webView
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(movieDetailsViewModel: MovieDetailsViewModel) {
        self.movieDetailsViewModel = movieDetailsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = movieDetailsViewModel.title
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(trailerWebView)
        contentView.addSubview(infoLabel)
        contentView.addSubview(releaseDateLabel)
        applyConstraints()
        
        fillLabels()
        
        movieDetailsViewModel.homeDetailsViewModelDelegate = self
        movieDetailsViewModel.getYoutubeTrailerLink()
    }
    
    private func fillLabels() {
        infoLabel.text = movieDetailsViewModel.movieInfoText
        releaseDateLabel.text = movieDetailsViewModel.releaseDate
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.90),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            trailerWebView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            trailerWebView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            trailerWebView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            trailerWebView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: trailerWebView.bottomAnchor, constant: 15),
            infoLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            infoLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            releaseDateLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 15),
            releaseDateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            releaseDateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            releaseDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ])
    }
}

extension MovieDetailsViewController: MovieDetailsViewModelDelegate {
    func errorOccurred(errorMessage: String) {
        print(errorMessage)
    }
    
    func movieTrailerLinkFetched(url: URL) {
        DispatchQueue.main.async {
            self.trailerWebView.load(URLRequest(url: url))
        }
    }
}

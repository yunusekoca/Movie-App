//
//  PosterHeaderUIView.swift
//  MovieApp
//
//  Created by Yunus Emre Koca on 29.08.2022.
//

import UIKit

protocol PosterHeaderUIViewDelegate: AnyObject {
    func headerPosterTapped(movie: Movie)
}

final class PosterHeaderUIView: UIView {
    
    private let posterHeaderViewModel: PosterHeaderViewModel
    private let gradient: CAGradientLayer
    
    weak var posterHeaderUIViewDelegate: PosterHeaderUIViewDelegate?
    
    private lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 48))
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(posterTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        self.gradient = CAGradientLayer()
        self.posterHeaderViewModel = PosterHeaderViewModel()
        super.init(frame: frame)
        addSubview(headerImage)
        addSubview(playButton)
        applyConstraints()
        
        posterHeaderViewModel.posterHeaderViewModelDelegate = self
        posterHeaderViewModel.fetchMoviePoster()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func posterTapped() {
        guard let movie = posterHeaderViewModel.getMovie() else { return }
        posterHeaderUIViewDelegate?.headerPosterTapped(movie: movie)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playButton.widthAnchor.constraint(equalTo: widthAnchor),
            playButton.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    private func applyGradient() {
        gradient.removeFromSuperlayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerImage.frame = bounds
        applyGradient()
    }
}

extension PosterHeaderUIView: PosterHeaderViewModelDelegate {
    func posterURLFetched(movie: Movie, posterURL: URL) {
        headerImage.sd_setImage(with: posterURL)
    }
    
    func errorOccurred(errorMessage: String) {
        print(errorMessage)
    }
}

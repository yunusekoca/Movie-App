//
//  PosterHeaderUIView.swift
//  MovieApp
//
//  Created by Yunus Emre Koca on 29.08.2022.
//

import UIKit

final class PosterHeaderUIView: UIView {
    
    private let gradient: CAGradientLayer
    
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
        return button
    }()
    
    override init(frame: CGRect) {
        self.gradient = CAGradientLayer()
        super.init(frame: frame)
        addSubview(headerImage)
        addSubview(playButton)
        
        applyConstraints()
    }
    
    func configurePoster(with posterURL: URL) {
        headerImage.sd_setImage(with: posterURL)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerImage.frame = bounds
        applyGradient()
    }
}

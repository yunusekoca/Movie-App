//
//  PosterCollectionViewCell.swift
//  MovieApp
//
//  Created by Yunus Emre Koca on 29.08.2022.
//

import UIKit
import SDWebImage

final class PosterCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PosterCollectionViewCell"
    
    private lazy var posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemBackground
        imageView.image = UIImage(systemName: "questionmark")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImage.image = UIImage(systemName: "questionmark")
    }
    
    func configurePosterCollectionViewCell(with posterUrlString: String?) {
        guard let posterUrlString = posterUrlString else { return }
        guard let url = URL(string: "\(Constants.posterBaseURL)/\(posterUrlString)") else { return }
        posterImage.sd_setImage(with: url)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImage.frame = contentView.bounds
    }
}

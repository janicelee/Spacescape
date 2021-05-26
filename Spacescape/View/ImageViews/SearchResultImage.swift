//
//  SearchResultImage.swift
//  Spacescape
//
//  Created by Janice Lee on 2021-05-22.
//

import UIKit

class SearchResultImage: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        setImageToPlaceholder()
    }
    
    func setImage(from urlString: String) {
        NASAClient.shared.downloadImage(from: urlString) { [weak self] image in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    func setImageToPlaceholder() {
        image = Images.placeholder
    }
}

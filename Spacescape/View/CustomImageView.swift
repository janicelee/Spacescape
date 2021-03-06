//
//  CustomImageView.swift
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
        layer.cornerRadius = Layout.imageCornerRadius
        contentMode = .scaleAspectFit
        clipsToBounds = true
        image = Images.placeholder
    }
    
    func setImage(from urlString: String) {
        NASAClient.shared.downloadImage(from: urlString) { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

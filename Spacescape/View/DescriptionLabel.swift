//
//  DescriptionLabel.swift
//  Spacescape
//
//  Created by Janice Lee on 2021-05-24.
//

import UIKit

class DescriptionLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(fontSize: CGFloat) {
        self.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        textColor = .label
        numberOfLines = 0
    }
}

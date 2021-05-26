//
//  SearchResultTableViewCell.swift
//  Spacescape
//
//  Created by Janice Lee on 2021-05-22.
//

import UIKit
import SnapKit

class SearchResultTableViewCell: UITableViewCell {
    static let reuseID = "ResultCell"
    
    private let thumbnailImage = SearchResultImage(frame: .zero)
    private let titleLabel = TitleLabel(fontSize: FontSize.medium)
    private let dateLabel = DateLabel(fontSize: FontSize.small)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [thumbnailImage, titleLabel, dateLabel].forEach(addSubview)
        
        let width: CGFloat = 150
        let height: CGFloat = 110
        
        thumbnailImage.layer.cornerRadius = Layout.imageCornerRadius

        thumbnailImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(Layout.largePadding)
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImage).offset(Layout.xsPadding)
            make.leading.equalTo(thumbnailImage.snp.trailing).offset(Layout.mediumPadding)
            make.trailing.equalToSuperview().inset(Layout.mediumPadding)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Layout.smallPadding)
            make.leading.trailing.equalTo(titleLabel)
        }
    }

    func set(_ searchItem: SearchItem) {
        if searchItem.data.count > 0 {
            let data = searchItem.data[0]
            titleLabel.text = data.title
            dateLabel.text = data.dateCreated.convertToDisplayFormat()
        }
        
        if searchItem.links.count > 0 {
            thumbnailImage.setImage(from: searchItem.links[0].href)
        }
    }
    
    func setImageToPlaceholder() {
        thumbnailImage.setImageToPlaceholder()
    }
}

//
//  InfoViewController.swift
//  Spacescape
//
//  Created by Janice Lee on 2021-05-22.
//

import UIKit
import SnapKit

class InfoViewController: UIViewController {
    
    private let imageView = SearchResultImage(frame: .zero)
    private let titlelabel = TitleLabel(fontSize: FontSize.large)
    private let dateLabel = SecondaryLabel(fontSize: FontSize.medium)
    private let descriptionLabel = BodyLabel(fontSize: FontSize.medium)
    
    private var searchItem: SearchItem!
    
    init(searchItem: SearchItem) {
        super.init(nibName: nil, bundle: nil)
        self.searchItem = searchItem
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationItem.largeTitleDisplayMode = .never
        
        setImage()
        setLabels()
        configure()
    }
    
    private func configure() {
        [imageView, titlelabel, dateLabel, descriptionLabel].forEach(view.addSubview)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(280)
        }
        
        titlelabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Layout.largePadding)
            make.leading.trailing.equalToSuperview().inset(Layout.xLargePadding)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titlelabel.snp.bottom).offset(Layout.mediumPadding)
            make.leading.trailing.equalTo(titlelabel)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Layout.xLargePadding)
            make.leading.trailing.equalTo(dateLabel)
        }
    }
    
    private func setImage() {
        NASAClient.shared.getImageURLs(from: searchItem.href) { [weak self] urls in
            guard let self = self else { return }
            
            if urls.count > 0 {
                self.imageView.setImage(from: urls[0])
            }
        }
    }
    
    private func setLabels() {
        let data = searchItem.data[0]
        titlelabel.text = data.title
        dateLabel.text = data.dateCreated.convertToDisplayFormat()
        descriptionLabel.text = data.description
    }
}

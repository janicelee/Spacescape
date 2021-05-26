//
//  InfoViewController.swift
//  Spacescape
//
//  Created by Janice Lee on 2021-05-22.
//

import UIKit
import SnapKit

class InfoViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let imageView = SearchResultImage(frame: .zero)
    private let titlelabel = TitleLabel(fontSize: FontSize.large)
    private let dateLabel = DateLabel(fontSize: FontSize.medium)
    private let descriptionLabel = DescriptionLabel(fontSize: FontSize.medium)
    
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
        configure()
        setImage()
        setLabels()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        self.navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(scrollView)
        [imageView, titlelabel, dateLabel, descriptionLabel].forEach(scrollView.addSubview)
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.height.equalTo(280)
        }
        
        titlelabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Layout.largePadding)
            make.leading.trailing.equalTo(imageView).inset(Layout.xLargePadding)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titlelabel.snp.bottom).offset(Layout.mediumPadding)
            make.leading.trailing.equalTo(titlelabel)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Layout.xLargePadding)
            make.leading.trailing.equalTo(dateLabel)
            make.bottom.equalToSuperview().inset(Layout.largePadding)
        }
    }
    
    private func setImage() {
        NASAClient.shared.unpackImageCollection(from: searchItem.href) { [weak self] urls in
            guard let self = self else { return }
            
            if urls.count > 0 {
                self.imageView.setImage(from: urls[0])
            }
        }
    }
    
    private func setLabels() {
        if searchItem.data.count > 0 {
            let data = searchItem.data[0]
            titlelabel.text = data.title
            dateLabel.text = data.dateCreated.convertToDisplayFormat()
            descriptionLabel.text = data.description
        }
    }
}

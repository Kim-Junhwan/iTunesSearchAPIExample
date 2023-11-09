//
//  SearchListCollectionViewCell.swift
//  iTunesSearchAPIExample
//
//  Created by JunHwan Kim on 2023/11/08.
//

import Foundation
import UIKit
import SnapKit

class SearchListCollectionViewCell: UICollectionViewCell {
    
    lazy var contentStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.addArrangedSubview(appLogoStackView)
        stackView.addArrangedSubview(developerStackView)
        stackView.addArrangedSubview(screenShotStackView)
        return stackView
    }()
    
    lazy var appLogoStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(appLogoImageView)
        stackView.addArrangedSubview(appDescriptionStackView)
        return stackView
    }()
    
    let appLogoImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    lazy var appDescriptionStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(appNameLabel)
        return stackView
    }()
    
    let appNameLabel: UILabel = {
       let label = UILabel()
        
        return label
    }()
    
    lazy var developerStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.addArrangedSubview(developerNameLabel)
        stackView.addArrangedSubview(genresLabel)
        return stackView
    }()
    
    let developerNameLabel: UILabel = {
       let label = UILabel()
        
        return label
    }()
    
    let genresLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    lazy var screenShotStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(screenshotImageViewFirst)
        stackView.addArrangedSubview(screenshotImageViewSecond)
        stackView.addArrangedSubview(screenshotImageViewThrid)
        return stackView
    }()
    
    let screenshotImageViewFirst: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    let screenshotImageViewSecond: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    let screenshotImageViewThrid: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.addSubview(contentStackView)
    }
    
    private func setConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        appLogoStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        appLogoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(90)
        }
    }
    
    func configureCell(appInfo: AppInfo) {
        appLogoImageView.setImageFromImagePath(imagePath: appInfo.artworkUrl512)
        appNameLabel.text = appInfo.trackName
        developerNameLabel.text = appInfo.artistName
        genresLabel.text = appInfo.genres.first
    }
    
}

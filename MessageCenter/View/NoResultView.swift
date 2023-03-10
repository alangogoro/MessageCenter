//
//  NoResultView.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/10.
//

import UIKit

class NoResultView: UIView {
    
    // MARK: - Properties
    private var label = UILabel()
    private var subLabel = UILabel()
    public var title: String? {
        didSet { label.text = title }
    }
    public var subTitle: String? {
        didSet { subLabel.text = subTitle }
    }
    
    override func layoutSubviews() {
        configureUI()
    }
    
    // MARK: - Configuration
    private func configureUI() {
        addSubview(label)
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.centerY.equalTo(self).offset(-screenWidth * (20/375))
            $0.left.right.equalTo(self)
        }
        
        addSubview(subLabel)
        subLabel.textAlignment = .center
        subLabel.textColor = .notice
        subLabel.font = .boldSystemFont(ofSize: 15)
        subLabel.numberOfLines = 0
        subLabel.adjustsFontSizeToFitWidth = true
        subLabel.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(5)
            $0.left.right.equalTo(self)
        }
    }
    
}


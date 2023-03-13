//
//  ToastView.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/13.
//

import UIKit


class ToastView: UIView {
    // MARK: - Properties
    private lazy var titleLabel = UILabel()
    private lazy var iconImage = UIImageView()
    public var title: String? {
        didSet { titleLabel.text = title }
    }
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configureUI()
    }
    
    // MARK: - Configuration
    private func configureUI() {
        addSubview(iconImage)
        iconImage.image = #imageLiteral(resourceName: "warning_icon")
        iconImage.clipsToBounds = true
        iconImage.layer.cornerRadius = self.frame.size.height * 0.3
        iconImage.contentMode = .scaleAspectFit
        iconImage.snp.makeConstraints {
            $0.left.equalTo(self).offset(12)
            $0.centerY.equalTo(self)
            $0.height.width.equalTo(self.frame.size.height * 0.6)
        }
        
        addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: titleLabel.font.pointSize)
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconImage.snp.right).offset(12)
            $0.centerY.equalTo(self)
        }
    }
}


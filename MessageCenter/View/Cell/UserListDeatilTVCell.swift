//
//  UserListDeatilTVCell.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/10.
//

import UIKit


class UserListDetailTVCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "UserListTVDetailCell"
    private lazy var background = UIView()
    private lazy var separatorLine = UIView()
    private lazy var newestIcon = UIImageView()
    private lazy var newestLabel = UILabel()
    private lazy var lastChatImage = UIImageView()
    private lazy var lastChatNameLabel = UILabel()
    private lazy var lastChatMessageLabel = UILabel()
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lastChatImage.image = nil
        lastChatNameLabel.text = nil
    }
    
    // MARK: - Configure
    private func configureUI() {
        contentView.addSubview(background)
        background.backgroundColor = .backgroundGray
        background.clipsToBounds = true
        background.layer.cornerRadius = screenWidth * (10/375)
        background.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        background.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView)
            $0.left.right.equalTo(contentView)
        }
        
        contentView.addSubview(separatorLine)
        contentView.bringSubviewToFront(separatorLine)
        separatorLine.backgroundColor = .backgroundBlack
        separatorLine.snp.makeConstraints {
            $0.top.equalTo(contentView)
            $0.left.right.equalTo(contentView)
            $0.height.equalTo(1)
        }
        
        background.addSubview(newestIcon)
        newestIcon.image = #imageLiteral(resourceName: "message_gray_icon")
        newestIcon.contentMode = .scaleAspectFit
        newestIcon.snp.makeConstraints {
            $0.top.equalTo(background).inset(screenWidth * (19/375))
            $0.bottom.equalTo(background).inset(screenWidth * (17/375))
            $0.left.equalTo(background).inset(screenWidth * (16/375))
            $0.width.height.equalTo(screenWidth * (20/375))
        }
        
        background.addSubview(newestLabel)
        newestLabel.font = .systemFont(ofSize: 14)
        newestLabel.textColor = .notice
        newestLabel.text = "最新訊息"
        newestLabel.snp.makeConstraints {
            $0.left.equalTo(newestIcon.snp.right).offset(3)
            $0.centerY.equalTo(newestIcon)
        }
        
        background.addSubview(lastChatImage)
        lastChatImage.clipsToBounds = true
        lastChatImage.layer.cornerRadius = (screenWidth * (16/375)) / 2
        lastChatImage.snp.makeConstraints {
            $0.left.equalTo(newestLabel.snp.right).offset(screenWidth * (20/375))
            $0.bottom.equalTo(background.snp.centerY).offset(-2)
            $0.width.height.equalTo(screenWidth * (16/375))
        }
        
        background.addSubview(lastChatNameLabel)
        lastChatNameLabel.font = .systemFont(ofSize: 12)
        lastChatNameLabel.textColor = .notice
        lastChatNameLabel.lineBreakMode = .byTruncatingTail
        lastChatNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(lastChatImage)
            $0.left.equalTo(lastChatImage.snp.right).offset(3)
            $0.right.lessThanOrEqualTo(background).inset(screenWidth * (44/375))
        }
        
        background.addSubview(lastChatMessageLabel)
        lastChatMessageLabel.font = .systemFont(ofSize: 10)
        lastChatMessageLabel.textColor = .notice
        lastChatMessageLabel.lineBreakMode = .byTruncatingTail
        lastChatMessageLabel.snp.makeConstraints {
            $0.top.equalTo(background.snp.centerY).offset(2)
            $0.left.equalTo(lastChatImage)
            $0.right.lessThanOrEqualTo(background).inset(screenWidth * (44/375))
        }
    }
    
    public func configure(with chat: LastChatData?) {
        guard let chat else { return }
        
        lastChatImage.kf.setImage(with: URL(string: chat.pic ?? ""),
                                 placeholder: UIImage(named: "user_no_pic"))
        lastChatNameLabel.text = chat.name
        lastChatMessageLabel.text = chat.content
    }
    
}

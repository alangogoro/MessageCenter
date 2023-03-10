//
//  UserListTVCell.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/9.
//

import UIKit
import Kingfisher

protocol AccountListTVCellDlegate {
    func didSelectAccount(_ cell: AccountListTVCell, account: ListData)
}

class AccountListTVCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "UserListTVCell"
    private lazy var background = UIView()
    private lazy var accountImage = UIImageView()
    private lazy var accountNameLabel = UILabel()
    private lazy var unreadView = UIView()
    private lazy var unreadLabel = UILabel()
    private lazy var loginView = UIView()
    private lazy var loginLabel = UILabel()
    private lazy var loginButton = UIButton()
    private lazy var arrowIcon = UIImageView()
    private lazy var arrowButton = UIButton()
    
    private var account: ListData?
    
    public var delegate: AccountListTVCellDlegate?
    
    
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
        arrowButton.imageView?.image = #imageLiteral(resourceName: "white_arrow_down_icon")
    }
    
    // MARK: - Selector
    @objc
    private func loginAction() {
        print("⭐️ListCell -> \(#function)")
        guard let account else { return }
        delegate?.didSelectAccount(self, account: account)
    }
    
    @objc
    private func arrowAction() {
        print("⭐️ListCell -> \(#function)")
    }
    
    // MARK: - Configure
    private func configureUI() {
        contentView.addSubview(background)
        background.backgroundColor = .backgroundGray
        background.clipsToBounds = true
        background.layer.cornerRadius = screenWidth * (10/375)
        background.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView).inset(screenWidth * (8/375))
            $0.left.right.equalTo(contentView)
        }
        
        background.addSubview(accountImage)
        accountImage.clipsToBounds = true
        accountImage.layer.cornerRadius = (screenWidth * (36/375)) / 2
        accountImage.snp.makeConstraints {
            $0.left.equalTo(background).inset(screenWidth * (16/375))
            $0.top.bottom.equalTo(background).inset(screenWidth * (15/375))
            $0.width.height.equalTo(screenWidth * (36/375))
        }
        
        background.addSubview(arrowIcon)
        arrowIcon.image = #imageLiteral(resourceName: "white_arrow_down_icon")
        arrowIcon.contentMode = .scaleAspectFit
        arrowIcon.snp.makeConstraints {
            $0.right.equalTo(background).inset(screenWidth * (24/375))
            $0.centerY.equalTo(background)
            $0.width.height.equalTo(screenWidth * (16/375))
        }
        
        contentView.addSubview(arrowButton)
        arrowButton.addTarget(self,
                              action: #selector(arrowAction), for: .touchUpInside)
        arrowButton.snp.makeConstraints {
            $0.top.bottom.equalTo(background)
            $0.left.equalTo(arrowIcon)
            $0.right.equalTo(background)
        }
        
        background.addSubview(loginView)
        loginView.backgroundColor = .white
        loginView.clipsToBounds = true
        loginView.layer.cornerRadius = (screenWidth * (20/375)) / 2
        loginView.snp.makeConstraints {
            $0.right.equalTo(arrowIcon.snp.left).offset(-screenWidth * (12/375))
            $0.centerY.equalTo(background)
            $0.width.equalTo(screenWidth * (44/375))
            $0.height.equalTo(screenWidth * (20/375))
        }
        
        loginView.addSubview(loginLabel)
        loginLabel.font = .boldSystemFont(ofSize: 13)
        loginLabel.textColor = .backgroundBlack
        loginLabel.text = "登入"
        loginLabel.snp.makeConstraints {
            $0.center.equalTo(loginView)
            $0.top.bottom.equalTo(loginView)
        }
        
        contentView.addSubview(loginButton)
        loginButton.backgroundColor = .clear
        loginButton.addTarget(self,
                              action: #selector(loginAction), for: .touchUpInside)
        loginButton.snp.makeConstraints {
            $0.right.equalTo(arrowIcon.snp.left)
            $0.left.equalTo(loginView).offset(-screenWidth * (8/375))
            $0.top.bottom.equalTo(background)
        }
        
        contentView.addSubview(unreadView)
        unreadView.backgroundColor = .peachy
        unreadView.clipsToBounds = true
        unreadView.layer.cornerRadius = (screenWidth * (20/375)) / 2
        unreadView.snp.makeConstraints {
            $0.right.equalTo(loginView.snp.left).offset(-screenWidth * (18/375))
            $0.centerY.equalTo(background)
            $0.height.equalTo(screenWidth * (20/375))
        }
        
        unreadView.addSubview(unreadLabel)
        unreadLabel.font = .boldSystemFont(ofSize: 14)
        unreadLabel.textColor = .white
        unreadLabel.snp.makeConstraints {
            $0.centerY.equalTo(unreadView)
            $0.left.right.equalTo(unreadView).inset(4)
        }
        
        background.addSubview(accountNameLabel)
        accountNameLabel.font = .systemFont(ofSize: 17)
        accountNameLabel.textColor = .white
        accountNameLabel.textAlignment = .left
        accountNameLabel.lineBreakMode = .byTruncatingTail
        accountNameLabel.snp.makeConstraints {
            $0.left.equalTo(accountImage.snp.right).offset(screenWidth * (6/375))
            $0.right.lessThanOrEqualTo(unreadView.snp.left).offset(screenWidth * (12/375))
            $0.centerY.equalTo(accountImage)
        }
    }
    
    public func configure(with account: ListData) {
        guard let profilePic = account.profilePic,
              let accountName = account.name else { return }
        self.account = account
        
        accountImage.kf.setImage(with: URL(string: profilePic),
                                 placeholder: UIImage(named: "user_no_pic"))
        accountNameLabel.text = accountName
        // TODO: - unread 等於0時隱藏
        unreadLabel.text = account.unread
    }
    
}

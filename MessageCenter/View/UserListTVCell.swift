//
//  UserListTVCell.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/9.
//

import UIKit
import Kingfisher

protocol AccountListTVCellDlegate {
    func didSelectAccount(_ cell: UserListTVCell, account: ListData)
    func didSelectToExpand(_ cell: UserListTVCell, indexPath: IndexPath, isOpened: Bool)
}

class UserListTVCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "UserListTVCell"
    private lazy var background = UIView()
    private lazy var rectBackground = UIView()
    private lazy var accountImage = UIImageView()
    private lazy var accountNameLabel = UILabel()
    private lazy var unreadView = UIView()
    private lazy var unreadLabel = UILabel()
    private lazy var loginView = UIView()
    private lazy var loginLabel = UILabel()
    private lazy var loginButton = UIButton()
    private lazy var arrowIcon = UIImageView()
    private lazy var arrowButton = UIButton()
    
    public var indexPath = IndexPath()
    private var isOpened = false
    
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
        accountImage.image = nil
        accountNameLabel.text = nil
        unreadView.isHidden = true
        arrowIcon.image = #imageLiteral(resourceName: "white_arrow_down_icon")
        rectBackground.isHidden = true
    }
    
    // MARK: - Selector
    @objc
    private func loginAction() {
        print("⭐️ ListCell -> \(#function)")
        guard let account else { return }
        #if DEBUG
        #else
        delegate?.didSelectAccount(self, account: account)
        #endif
    }
    
    @objc
    private func arrowAction() {
        print("⭐️ ListCell -> \(#function)")
        isOpened.toggle()
        updateCollapseUI(isOpened)
        delegate?.didSelectToExpand(self, indexPath: indexPath, isOpened: isOpened)
    }
    
    // MARK: - Configure
    private func configureUI() {
        contentView.addSubview(background)
        background.backgroundColor = .backgroundGray
        background.clipsToBounds = true
        background.layer.cornerRadius = screenWidth * (10/375)
        background.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView)
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
            $0.height.equalTo(screenWidth * (20/375))
        }
        
        loginView.addSubview(loginLabel)
        loginLabel.font = .boldSystemFont(ofSize: 13)
        loginLabel.textColor = .backgroundBlack
        loginLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(loginView)
            $0.left.right.equalTo(loginView).inset(screenWidth * (8/375))
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
            $0.right.equalTo(loginView.snp.left).offset(-screenWidth * (12/375))
            $0.centerY.equalTo(background)
            $0.height.greaterThanOrEqualTo(screenWidth * (20/375))
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
        
        contentView.addSubview(rectBackground)
        contentView.sendSubviewToBack(rectBackground)
        rectBackground.isHidden = true
        rectBackground.backgroundColor = .backgroundGray
        rectBackground.snp.makeConstraints {
            $0.bottom.equalTo(background)
            $0.left.right.equalTo(background)
            $0.height.equalTo(screenWidth * (10/375))
        }
    }
    
    fileprivate func updateCollapseUI(_ isOpened: Bool) {
        arrowIcon.image = isOpened ? #imageLiteral(resourceName: "white_arrow_up_icon") : #imageLiteral(resourceName: "white_arrow_down_icon")
        rectBackground.isHidden = !isOpened
    }
    
    public func configure(with account: ListData, isOpen: Bool) {
        guard let profilePic = account.profilePic,
              let accountName = account.name else { return }
        self.account = account
        
        accountImage.kf.setImage(with: URL(string: profilePic),
                                 placeholder: UIImage(named: "user_no_pic"))
        accountNameLabel.text = accountName
        
        if let unread = account.unread,
           (unread != "") && (unread != "0") {
            unreadView.isHidden = false
            unreadLabel.text = unread
        } else {
            unreadView.isHidden = true
        }
        
        if let canLogin = account.canLogin,
           canLogin == "1" {
            loginView.backgroundColor = .white
            loginLabel.textColor = .backgroundBlack
            loginLabel.text = "登入"
        } else {
            loginView.backgroundColor = .toolGray
            loginLabel.textColor = .white
            loginLabel.text = "登入中"
        }
        
        updateCollapseUI(isOpen)
    }
    
}

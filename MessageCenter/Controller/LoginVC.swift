//
//  LoginVC.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/8.
//

import UIKit
import SnapKit


class LoginVC: UIViewController {
    // MARK: - Properties
    private lazy var background = UIImageView()
    private lazy var themeIcon = UIImageView()
    private lazy var descriptionLabel = UILabel()
    internal lazy var inputBackgrounds = Set<UIView>([accountBackground, passwordBackground])
    internal lazy var accountTextField = UITextField()
    private lazy var accountBackground = UIView()
    internal lazy var passwordTextField = UITextField()
    private lazy var passwordBackground = UIView()
    internal lazy var loginBackground = GradientView(leftColor: .toolGray, rightColor: .toolGray)
    private lazy var loginLabel = UILabel()
    internal lazy var loginButton = UIButton()
    internal lazy var errorLabel = UILabel()
    
    internal var currentTextField: UITextField?
    internal var rect: CGRect?
    
    internal lazy var viewModel = LoginVCViewModel(post: postManager)
    private let postManager = PostManager.shared
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addKeyboardEventObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if DEBUG
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            self.accountTextField.text = "aaaa"
            self.passwordTextField.text = "bbbb"
        }
        #endif
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Selectors
    @objc
    internal func loginAction(sender: UIButton) {
        sender.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [sender] in
            sender.isEnabled = true
        }
        view.endEditing(true)
        
        guard let account = accountTextField.text, account.count >= 4 else {
            UIAlertController.present(title: "請輸入正確帳號格式")
            return
        }
        guard let password = passwordTextField.text, password.count >= 4 else {
            UIAlertController.present(title: "請輸入正確密碼格式")
            return
        }
        if let mainNavigation = self.navigationController as? MainNavigationController {
            if mainNavigation.monitor.currentPath.status != .satisfied {
                UIAlertController.present(title: "網路異常", message: "請稍候再嘗試！")
                return
            }
        }
            
        Task {
            let result = await viewModel.login(account: account, password: password)
            
            await MainActor.run {
                if result {
                    displayDefaultUIStatus()
                    self.navigationController?.pushViewController(MainListTVC(), animated: true)
                } else {
                    displayWrongUIStatus()
                }
            }
        }
    }
    
    // MARK: - Public functions
    public func displayLogoutView() {
        presentAlert(title: "帳號已登出")
    }
    
    // MARK: - Configuration
    fileprivate func configureUI() {
        view.backgroundColor = .darkBlack
        
        view.addSubview(background)
        background.image = UIImage(named: "login_background")
        background.contentMode = .scaleAspectFill
        background.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        view.addSubview(themeIcon)
        themeIcon.image = #imageLiteral(resourceName: "app_theme_logo")
        themeIcon.contentMode = .scaleAspectFill
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.size.height ?? 0.0
        themeIcon.snp.makeConstraints {
            $0.top.equalTo(view).inset(navigationBarHeight + screenWidth * (168/375))
            $0.centerX.equalTo(view)
            $0.width.height.equalTo(screenWidth * (108/375))
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = "登入以啟用訊息管理中心"
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(themeIcon.snp.bottom).offset(screenWidth * (44/375))
            $0.centerX.equalTo(view)
            $0.width.equalTo(view)
        }
        
        view.addSubview(accountBackground)
        accountBackground.backgroundColor = .darkBlack
        accountBackground.clipsToBounds = true
        accountBackground.layer.cornerRadius = screenWidth * (44/375) / 2
        accountBackground.layer.borderWidth = 1
        accountBackground.layer.borderColor = UIColor.toolGray.cgColor
        accountBackground.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(screenWidth * (22/375))
            $0.left.right.equalTo(view).inset(screenWidth * (44/375))
            $0.height.equalTo(screenWidth * (44/375))
        }
        
        view.addSubview(accountTextField)
        accountTextField.delegate = self
        accountTextField.backgroundColor = .clear
        accountTextField.font = .systemFont(ofSize: 14)
        accountTextField.textColor = .white
        accountTextField.textAlignment = .center
        accountTextField.attributedPlaceholder = NSAttributedString(string: "輸入您的帳號",
                                                                    attributes: [.foregroundColor: UIColor.notice,
                                                                                 .font: UIFont.systemFont(ofSize: 14)])
        accountTextField.keyboardType = .emailAddress
        accountTextField.returnKeyType = .next
        accountTextField.autocorrectionType = .no
        accountTextField.autocapitalizationType = .none
        accountTextField.snp.makeConstraints {
            $0.center.equalTo(accountBackground)
            $0.width.equalTo(accountBackground).multipliedBy(0.85)
            $0.height.equalTo(accountBackground)
        }
        
        view.addSubview(passwordBackground)
        passwordBackground.clipsToBounds = true
        passwordBackground.layer.cornerRadius = screenWidth * (44/375) / 2
        passwordBackground.layer.borderWidth = 1
        passwordBackground.layer.borderColor = UIColor.toolGray.cgColor
        passwordBackground.backgroundColor = .darkBlack
        passwordBackground.snp.makeConstraints {
            $0.top.equalTo(accountBackground.snp.bottom).offset(screenWidth * (22/375))
            $0.left.right.equalTo(view).inset(screenWidth * (44/375))
            $0.height.equalTo(screenWidth * (44/375))
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.delegate = self
        passwordTextField.backgroundColor = .clear
        passwordTextField.font = .systemFont(ofSize: 14)
        passwordTextField.textColor = .white
        passwordTextField.textAlignment = .center
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "輸入您的密碼",
                                                                     attributes: [.foregroundColor: UIColor.notice,
                                                                                  .font: UIFont.systemFont(ofSize: 14)])
        passwordTextField.keyboardType = .default
        passwordTextField.returnKeyType = .done
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.snp.makeConstraints {
            $0.center.equalTo(passwordBackground)
            $0.width.equalTo(passwordBackground).multipliedBy(0.85)
            $0.height.equalTo(passwordBackground)
        }
        
        view.addSubview(loginBackground)
        loginBackground.clipsToBounds = true
        loginBackground.layer.cornerRadius = screenWidth * (44/375) / 2
        loginBackground.snp.makeConstraints {
            $0.top.equalTo(passwordBackground.snp.bottom).offset(screenWidth * (32/375))
            $0.left.right.equalTo(view).inset(screenWidth * (44/375))
            $0.height.equalTo(screenWidth * (44/375))
        }
        
        loginBackground.addSubview(loginLabel)
        loginLabel.font = .boldSystemFont(ofSize: 20)
        loginLabel.textColor = .white
        loginLabel.textAlignment = .center
        loginLabel.text = "登入 / 註冊"
        loginLabel.snp.makeConstraints {
            $0.centerX.equalTo(loginBackground)
            $0.height.equalTo(loginBackground)
        }
        
        view.addSubview(loginButton)
        loginButton.backgroundColor = .clear
        loginButton.addTarget(self,
                              action: #selector(loginAction(sender:)), for: .touchUpInside)
        loginButton.snp.makeConstraints {
            $0.edges.equalTo(loginBackground)
        }
        
        view.addSubview(errorLabel)
        errorLabel.isHidden = true
        errorLabel.font = .systemFont(ofSize: 13)
        errorLabel.textColor = .peachy
        errorLabel.textAlignment = .center
        errorLabel.text = "帳號或密碼錯誤，請重新輸入"
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(loginBackground.snp.bottom).offset(screenWidth * (16/375))
            $0.width.equalTo(view)
        }
    }
    
    fileprivate func displayDefaultUIStatus() {
        accountTextField.text = nil
        passwordTextField.text = nil
        configureLoginButtonStatus(false)
    }
    
    fileprivate func displayWrongUIStatus() {
        inputBackgrounds.forEach { $0.layer.borderColor = UIColor.peachy.cgColor }
        errorLabel.isHidden = false
    }
    
    internal func configureLoginButtonStatus(_ canLogin: Bool) {
        loginBackground.changeColor(leftColor: canLogin ? .purple : .toolGray,
                                    rightColor: canLogin ? .peachy : .toolGray)
    }
    
    private func presentAlert(title: String) {
        let alertController = UIAlertController(title: title, message: nil,
                                                preferredStyle: .alert)
        alertController.setAttributedTitle([.foregroundColor: UIColor.peachy])
        self.present(alertController, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alertController.dismiss(animated: true)
        }
    }
    
}

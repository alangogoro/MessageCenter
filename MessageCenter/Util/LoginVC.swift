//
//  LoginVC.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/8.
//

import Foundation

import UIKit

class LoginVC: UIViewController {
    // MARK: - Properties
    private lazy var background = UIImageView()
    private lazy var themeIcon = UIImageView()
    private lazy var descriptionLabel = UILabel()
    private lazy var InputBackgrounds = Set<UIView>([accountBackground, passwordBackground])
    private lazy var accountTextField = UITextField()
    private lazy var accountBackground = UIView()
    private lazy var passwordTextField = UITextField()
    private lazy var passwordBackground = UIView()
    private lazy var loginBackground = GradientView(leftColor: .toolGray, rightColor: .toolGray)
    private lazy var loginLabel = UILabel()
    private lazy var loginButton = UIButton()
    private lazy var errorLabel = UILabel()
    
    private lazy var toolView = UIView()
    private lazy var titleLabel = UILabel()
    
    private lazy var backButton = UIButton()
    private lazy var separateLine = UIView()
    
    private let postManager = PostManager.shared
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addTapToCancelKeyboard()
    }
    
    // MARK: - Selectors
    @objc
    private func loginAction() {
        print("⭐️ Login -> \(#function)")
        InputBackgrounds.forEach { $0.layer.borderColor = UIColor.peachy.cgColor }
        loginBackground.changeColor(leftColor: .purple, rightColor: .peachy)
        errorLabel.isHidden = false
    }
    
    // MARK: - Configuration
    fileprivate func configureUI() {
        view.backgroundColor = .darkBlack
        
        view.addSubview(background)
        background.image = UIImage(named: "login_background")
        background.contentMode = .scaleAspectFill
        background.frame = view.frame
        
        view.addSubview(themeIcon)
        themeIcon.image = #imageLiteral(resourceName: "app_theme_logo")
        themeIcon.contentMode = .scaleAspectFill
        themeIcon.setDimensions(width: screenWidth * (108/375), height: screenWidth * (108/375))
        themeIcon.centerX(inView: view,
                          topAnchor: view.topAnchor, paddingTop: screenWidth * (168/375) +
                          (self.navigationController?.navigationBar.bounds.size.height ?? 0.0))
        
        view.addSubview(descriptionLabel)
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = "登入以啟用訊息管理中心"
        descriptionLabel.centerX(inView: view, topAnchor: themeIcon.bottomAnchor, paddingTop: screenWidth * (44/375))
        descriptionLabel.setDimensionsEqualTo(width: view.widthAnchor)
        
        view.addSubview(accountBackground)
        accountBackground.clipsToBounds = true
        accountBackground.layer.cornerRadius = screenWidth * (44/375) / 2
        accountBackground.layer.borderWidth = 1
        accountBackground.layer.borderColor = UIColor.toolGray.cgColor
        accountBackground.backgroundColor = .darkBlack
        accountBackground.centerX(inView: view,
                           topAnchor: descriptionLabel.bottomAnchor, paddingTop: screenWidth * (22/375))
        accountBackground.setDimensions(width: screenWidth * (280/375), height: screenWidth * (44/375))
        
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
        accountTextField.center(inView: accountBackground)
        accountTextField.setDimensionsEqualTo(width: accountBackground.widthAnchor, widthMultiplier: 0.85)
        
        
        view.addSubview(passwordBackground)
        passwordBackground.clipsToBounds = true
        passwordBackground.layer.cornerRadius = screenWidth * (44/375) / 2
        passwordBackground.layer.borderWidth = 1
        passwordBackground.layer.borderColor = UIColor.toolGray.cgColor
        passwordBackground.backgroundColor = .darkBlack
        passwordBackground.centerX(inView: view,
                           topAnchor: accountBackground.bottomAnchor, paddingTop: screenWidth * (22/375))
        passwordBackground.setDimensions(width: screenWidth * (280/375), height: screenWidth * (44/375))
        
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
        passwordTextField.returnKeyType = .go
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.center(inView: passwordBackground)
        passwordTextField.setDimensionsEqualTo(width: passwordBackground.widthAnchor, widthMultiplier: 0.85)
        
        view.addSubview(loginBackground)
        loginBackground.clipsToBounds = true
        loginBackground.layer.cornerRadius = screenWidth * (44/375) / 2
        loginBackground.centerX(inView: view,
                                topAnchor: passwordBackground.bottomAnchor, paddingTop: screenWidth * (32/375))
        loginBackground.setDimensions(width: screenWidth * (280/375), height: screenWidth * (44/375))
        
        loginBackground.addSubview(loginLabel)
        loginLabel.font = .boldSystemFont(ofSize: 22)
        loginLabel.textColor = .white
        loginLabel.textAlignment = .center
        loginLabel.text = "登入 / 註冊"
        loginLabel.centerX(inView: loginBackground)
        loginLabel.setDimensionsEqualTo(height: loginBackground.heightAnchor)
        
        view.addSubview(loginButton)
        loginButton.isEnabled = true
        loginButton.backgroundColor = .clear
        if #available(iOS 14.0, *) {
            loginButton.addAction(UIAction(handler: { [unowned self] action in
                self.loginAction()
            }), for: .touchUpInside)
        } else {
            loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        }
        loginButton.center(inView: loginBackground)
        loginButton.setDimensionsEqualTo(width: loginBackground.widthAnchor, height: loginBackground.heightAnchor)
        
        view.addSubview(errorLabel)
        errorLabel.isHidden = true
        errorLabel.font = .systemFont(ofSize: 13)
        errorLabel.textColor = .peachy
        errorLabel.textAlignment = .center
        errorLabel.text = "帳號或密碼錯誤，請重新輸入"
        errorLabel.centerX(inView: view,
                           topAnchor: loginBackground.bottomAnchor, paddingTop: screenWidth * (16/375))
        errorLabel.setDimensionsEqualTo(width: view.widthAnchor)
    }
    
    // MARK: - Helper
    private func addTapToCancelKeyboard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
}

// MARK: - UITextViewDelegate
extension LoginVC: UITextFieldDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        errorLabel.isHidden = true
        return true
    }
    
}

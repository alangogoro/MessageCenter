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
    
    private var currentTextField: UITextField?
    private var rect: CGRect?
    
    private lazy var viewModel = LoginVCViewModel(post: postManager)
    private let postManager = PostManager.shared
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addKeyboardEventObservers()
        
        // TODO: Login button 變色 (color func)
        // TODO: 錯誤 UI 提示 (didSet?)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        accountTextField.text = "aaaa"
        passwordTextField.text = "bbbb"
        // loginAction(sender: loginButton)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Selectors
    @objc
    private func loginAction(sender: UIButton) {
        sender.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [sender] in
            sender.isEnabled = true
        }
        
        guard let account = accountTextField.text, !account.isEmpty else {
            UIAlertController.presentAlert(title: "請輸入正確帳號",
                                           cancellable: false, completion: nil)
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            UIAlertController.presentAlert(title: "請輸入密碼",
                                           cancellable: false, completion: nil)
            return
        }
        
        Task {
            let result = await viewModel.login(account: account, password: password)
            if result {
                self.navigationController?.pushViewController(MainListTVC(), animated: true)
            } else {
                // wrong
                InputBackgrounds.forEach { $0.layer.borderColor = UIColor.peachy.cgColor }
                loginBackground.changeColor(leftColor: .purple, rightColor: .peachy)
            }
        }
    }
    
    @objc private func doneButtonAction() {
        view.endEditing(true)
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
        passwordTextField.returnKeyType = .done
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
        loginButton.addTarget(self,
                              action: #selector(loginAction(sender:)), for: .touchUpInside)
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
    
    // MARK: - Keyboard Helpers
    private func createTextFieldToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        let flexSpace  = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                         target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "完成", style: .done,
                                         target: self, action: #selector(doneButtonAction))
                
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        return toolbar
    }
    
    private func addKeyboardEventObservers() {
        rect = view.bounds
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc
    private func keyboardWillShow(note: NSNotification) {
        if currentTextField == nil {
            return
        }
        guard let userInfo = note.userInfo else { return }
        let keyboard = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let origin = (currentTextField?.frame.origin)!
        let height = (currentTextField?.frame.size.height)!
        
        let targetY = origin.y + height
        let visibleRectWithoutKeyboard = self.view.bounds.size.height - keyboard.height
        
        if targetY >= visibleRectWithoutKeyboard {
            var rect_ = self.rect!
            rect_.origin.y -= (targetY - visibleRectWithoutKeyboard) + 15
        
            UIView.animate(withDuration: duration,
                           animations: { () -> Void in
                self.view.frame = rect_
            })
        }
    }
    
    @objc
    private func keyboardWillHide(note: NSNotification) {
        if view.frame.origin.y != rect?.origin.y {
            view.frame.origin.y = CGFloat.zero
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

// MARK: - UITextViewDelegate
extension LoginVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorLabel.isHidden = true
        print("⭐️ Login -> \(#function)",
              "\ttext =", textField.text?.trimmingCharacters(in: .whitespaces) ?? "N/A")
        guard (string != " " && string != "\n") else { return false }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // only called when TextField finished
        print("⭐️ Login -> \(#function)",
              "\ttext =", textField.text?.trimmingCharacters(in: .whitespaces) ?? "N/A")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginAction(sender: loginButton)
        }
        return true
    }
    
}

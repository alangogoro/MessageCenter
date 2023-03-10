//
//  LoginVC+Extension.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/10.
//

import UIKit


extension LoginVC {
    
    // MARK: - Keyboard Helpers
    internal func addKeyboardEventObservers() {
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
    internal func keyboardWillShow(note: NSNotification) {
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
    internal func keyboardWillHide(note: NSNotification) {
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
        errorLabel.isHidden = true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard (string != " " && string != "\n") else { return false }
        
        inputBackgrounds.forEach { $0.layer.borderColor = UIColor.toolGray.cgColor }
        
        let canLogin = viewModel.checkInputs(accountTextField.text, passwordTextField.text)
        updateLoginButtonStatus(canLogin)
        
        guard let prevTextCount = textField.text?.count else { return false }
        let textCount = prevTextCount + string.count - range.length
        return textCount <= viewModel.maxTextCount
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            let canLogin = viewModel.checkInputs(accountTextField.text, passwordTextField.text)
            updateLoginButtonStatus(canLogin)
            
            if canLogin {
                loginAction(sender: loginButton)
            }
        }
        return true
    }
    
    internal func restoreUIStatus() {
        accountTextField.text = nil
        passwordTextField.text = nil
        updateLoginButtonStatus(false)
    }
    
    fileprivate func updateLoginButtonStatus(_ canLogin: Bool) {
        loginBackground.changeColor(leftColor: canLogin ? .purple : .toolGray,
                                    rightColor: canLogin ? .peachy : .toolGray)
        loginButton.isEnabled = canLogin
    }
    
}

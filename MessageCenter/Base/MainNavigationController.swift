//
//  MainNavigationController.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/1.
//

import UIKit
import Reachability

class MainNavigationController: UINavigationController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        
        if !UserDefaultsHelper.get(forKey: .sessionToken).isNilOrEmpty {
            Task {
                if await PostManager.shared.getList() == nil {
                    navigateToLogin()
                } else {
                    self.setViewControllers([LoginVC(), MainListTVC()], animated: false)
                }
            }
        } else {
            navigateToLogin()
        }
    }
    
    // MARK: - Helpers
    private func navigateToLogin() {
        self.viewControllers = [LoginVC()]
        self.popToRootViewController(animated: true)
        
        UserDefaultsHelper.remove(fokKey: .sessionToken)
    }
    
}

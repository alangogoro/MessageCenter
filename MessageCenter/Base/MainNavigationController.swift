//
//  MainNavigationController.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/1.
//

import UIKit
import Network


class MainNavigationController: UINavigationController {
    // MARK: - Properties
    public let monitor = NWPathMonitor()
    private let monitorHelper = NWMonitorHelper.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        
        Task { @MainActor in
            if !UserDefaultsHelper.get(forKey: .sessionToken).isNilOrEmpty {
                if await PostManager.shared.getList() == nil {
                    navigateToLogin()
                } else {
                    // Direct to MainList (logged in)
                    self.setViewControllers([LoginVC(), MainListTVC()], animated: false)
                }
            } else {
                navigateToLogin()
            }
        }
        
        monitorNetwork()
    }
    
    // MARK: - Navigate to
    private func navigateToLogin() {
        self.setViewControllers([LoginVC()], animated: true)
        UserDefaultsHelper.remove(fokKey: .sessionToken)
    }
    
    // MARK: - Network Helper
    private func monitorNetwork() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("connected")
            } else {
                print("no connection")
                Task.detached { @MainActor in
                    self?.monitorHelper.show(title: "網路異常，請稍後重試！")
                }
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
    
}

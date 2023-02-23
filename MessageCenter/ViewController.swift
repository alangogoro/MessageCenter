//
//  ViewController.swift
//  MessageCenter
//
//  Created by usr on 2023/2/18.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemTeal
        setFAUserId("TEST_USER_ID")
        
        Task {
            let data = await PostManager.shared.login()
            Logger.info("name:", data?.name ?? "❌")
        }
    }
    
    func setFAUserId(_ name: String?) {
        guard !name.isNilOrEmpty else { return }
        FirebaseAnalytics.Analytics.setUserProperty(name, forName: "UserId")
    }
    
}

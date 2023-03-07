//
//  ViewController.swift
//  MessageCenter
//
//  Created by usr on 2023/2/18.
//

import UIKit
import Firebase

class HomeTVC: UIViewController {
    private let viewModel = HomeTVCViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemTeal
        setFAUserId("TEST_USER_ID")
    }
    
    func setFAUserId(_ name: String?) {
        guard !name.isNilOrEmpty else { return }
        FirebaseAnalytics.Analytics.setUserProperty(name, forName: "UserId")
    }
    
}

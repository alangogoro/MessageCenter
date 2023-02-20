//
//  ViewController.swift
//  MessageCenter
//
//  Created by usr on 2023/2/18.
//

import UIKit
import Firebase
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemTeal
        
        setUserId("TEST_USER_ID")
    }
    
    func setUserId(_ name: String?) {
        guard !name.isNilOrEmpty else { return }
        FirebaseAnalytics.Analytics.setUserProperty(name, forName: "UserId")
    }
    
}

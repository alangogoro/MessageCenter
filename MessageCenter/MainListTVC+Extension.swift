//
//  MainListTVC+Extension.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/10.
//

import UIKit


// MARK: - UITableViewDelegate
extension MainListTVC: UITableViewDelegate {
    
}

// MARK: - AccountListTVCellDlegate
extension MainListTVC: AccountListTVCellDlegate {
    
    func didSelectAccount(_ cell: UserListTVCell, account: ListData) {
        let token = account.fastToken
        guard let url = DynamicLinkHelper.createDeepLink(for: token) else { return }
        
        Task.detached { @MainActor in
            if UIApplication.shared.canOpenURL(url) {
                await UIApplication.shared.open(url)
            }
        }
    }
    
}

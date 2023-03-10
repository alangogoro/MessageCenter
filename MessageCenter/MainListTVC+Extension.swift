//
//  MainListTVC+Extension.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/10.
//

import UIKit


// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainListTVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        if section.isOpend {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserListTVCell.identifier,
                                                     for: indexPath) as! UserListTVCell
            let section = sections[indexPath.section]
            cell.configure(with: section.data, isOpen: section.isOpend)
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListDetailTVCell.identifier,
                                                 for: indexPath) as! UserListDetailTVCell
        cell.configure(with: sections[indexPath.section].lastChat)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return screenWidth * (12/375)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 0))
    }
    
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
    
    func didSelectToExpand(_ cell: UserListTVCell, indexPath: IndexPath, isOpened: Bool) {
        sections[indexPath.section].isOpend = !sections[indexPath.section].isOpend
        tableView.reloadSections([indexPath.section], with: .none)
    }
    
}

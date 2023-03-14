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
        guard !sections.isEmpty else { return 0 }
        let section = sections[section]
        if section.isOpend {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !sections.isEmpty else { return UITableViewCell() }
        let section = sections[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserListTVCell.identifier,
                                                     for: indexPath) as! UserListTVCell
            cell.configure(with: section.data, isOpen: section.isOpend)
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListDetailTVCell.identifier,
                                                 for: indexPath) as! UserListDetailTVCell
        cell.configure(with: section.lastChat)
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
        guard let url = DynamicLinkHelper.createDeepLink(for: token) else {
            UIAlertController.present(title: "登入失敗", message: "請嘗試更新或重新登入")
            return
        }
        
        Task.detached { @MainActor [weak self] in
            if UIApplication.shared.canOpenURL(url) {
                let opened = await UIApplication.shared.open(url)
                if opened {
                    await Task.sleep(seconds: 3)
                    self?.refreshAction()
                }
            }
        }
    }
    
    func didSelectToExpand(_ cell: UserListTVCell, indexPath: IndexPath, isOpened: Bool) {
        sections[indexPath.section].isOpend = !(sections[indexPath.section].isOpend)
        tableView.reloadSections([indexPath.section], with: .none)
    }
    
}

//
//  ViewController.swift
//  MessageCenter
//
//  Created by usr on 2023/2/18.
//

import UIKit
import SnapKit
import Combine

class MainListTVC: UIViewController {
    enum Section {
        case first
    }
    
    // MARK: - Properties
    private lazy var background = UIImageView()
    private lazy var toolBackground = UIView()
    private lazy var logoutLabel = UILabel()
    private lazy var logoutButton = UIButton()
    private lazy var titleLabel = UILabel()
    private lazy var titleUnderline = UIView()
    private lazy var refreshRedDot = UIView()
    private lazy var refreshLabel = UILabel()
    private lazy var refreshButton = UIButton()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    var dataSource: UITableViewDiffableDataSource<Section, ListData>!
    
    private lazy var viewModel = MainListViewModel(post: postManager)
    private let postManager = PostManager.shared
    private var subscriptions = Set<AnyCancellable>()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupCombine()
        viewModel.getUserList()
    }
    
    // MARK: - Selectors
    @objc
    private func logoutAction() {
        print("⭐️ MainList -> \(#function)")
        UIAlertController.presentAlert(title: "確定要登出嗎？",
                                       actionStyle: .destructive) { confirm in
            if confirm {
                Task {
                    let result = await self.postManager.logout()
                    if result {
                        UserDefaultsHelper.remove(fokKey: .sessionToken)
                        
                        Task.detached { @MainActor in
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        /* rebuild a new navigation
                         guard let keyWindow = UIApplication.shared.windows
                         .first(where: { $0.isKeyWindow }) else { return }
                         let mainNav = MainNavigationController(rootViewController: LoginVC())
                         keyWindow.rootViewController = mainNav
                         */
                    }
                }
            }
        }
    }
    
    @objc
    private func refreshAction() {
        print("⭐️ MainList -> \(#function)")
    }
    
    private func configureUI() {
        view.backgroundColor = .darkBlack
        
        view.addSubview(background)
        background.image = UIImage(named: "login_background")
        background.contentMode = .scaleAspectFill
        background.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        view.addSubview(toolBackground)
        toolBackground.backgroundColor = .backgroundBlack
        toolBackground.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalTo(view)
            $0.height.equalTo(screenWidth * (64/375))
        }
        
        toolBackground.addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "訊息管理中心"
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(toolBackground)
            $0.center.equalTo(toolBackground)
        }
        
        toolBackground.addSubview(titleUnderline)
        titleUnderline.layer.cornerRadius = 4 / 2
        titleUnderline.backgroundColor = .peachy
        titleUnderline.snp.makeConstraints {
            $0.bottom.equalTo(toolBackground.snp.bottom)
            $0.left.right.equalTo(titleLabel)
            $0.height.equalTo(4)
        }
        
        toolBackground.addSubview(logoutLabel)
        logoutLabel.font = .systemFont(ofSize: 14)
        logoutLabel.textColor = .notice
        logoutLabel.text = "登出"
        logoutLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(toolBackground)
            $0.left.equalTo(view).offset(screenWidth * (16/375))
            $0.centerY.equalTo(toolBackground)
        }
        
        view.addSubview(logoutButton)
        logoutButton.backgroundColor = .clear
        logoutButton.addTarget(self,
                              action: #selector(logoutAction), for: .touchUpInside)
        logoutButton.snp.makeConstraints {
            $0.center.equalTo(logoutLabel)
            $0.width.height.equalTo(logoutLabel.snp.height).multipliedBy(1.2)
        }
        
        toolBackground.addSubview(refreshLabel)
        refreshLabel.font = .systemFont(ofSize: 14)
        refreshLabel.textColor = .white
        refreshLabel.text = "更新"
        refreshLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(toolBackground)
            $0.right.equalTo(toolBackground).offset(-screenWidth * (16/375))
            $0.centerY.equalTo(toolBackground)
        }
        
        toolBackground.addSubview(refreshRedDot)
        refreshRedDot.isHidden = true
        refreshRedDot.backgroundColor = .peachy
        refreshRedDot.layer.cornerRadius = 6 / 2
        refreshRedDot.snp.makeConstraints {
            $0.right.equalTo(refreshLabel.snp.left).offset(-3)
            $0.centerY.equalTo(refreshLabel)
            $0.width.height.equalTo(6)
        }
        
        view.addSubview(refreshButton)
        refreshButton.backgroundColor = .clear
        refreshButton.addTarget(self,
                                action: #selector(refreshAction), for: .touchUpInside)
        refreshButton.snp.makeConstraints {
            $0.top.bottom.equalTo(refreshLabel)
            $0.left.equalTo(refreshRedDot).offset(-4)
            $0.right.equalTo(toolBackground)
        }
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.register(AccountListTVCell.self,
                           forCellReuseIdentifier: AccountListTVCell.identifier)
        tableView.snp.makeConstraints {
            $0.top.equalTo(toolBackground.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalTo(view).inset(screenWidth * (16/375))
        }
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView,
                                                   cellProvider: { [unowned self] (tableView, indexPath, user) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountListTVCell.identifier,
                                                           for: indexPath) as? AccountListTVCell else { return nil }
            cell.configure(with: user)
            cell.delegate = self
            return cell
        })
        tableView.dataSource = dataSource
    }
    
    fileprivate func setupCombine() {
        viewModel.userList
            .drop(while: { $0.isEmpty })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                self?.updateTableView(by: users)
            }.store(in: &subscriptions)
    }
    
    private func updateTableView(by users: [ListData]) {
        var snapshot = dataSource.snapshot()
        if snapshot.itemIdentifiers.count > 0 {
            snapshot.deleteAllItems()
        }
        snapshot.appendSections([.first])
        snapshot.appendItems(users)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

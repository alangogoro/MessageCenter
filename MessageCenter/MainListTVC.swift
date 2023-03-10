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
    private lazy var refreshControl = UIRefreshControl()
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
    var dataSource: UITableViewDiffableDataSource<Int, ListData>!
    private lazy var errorView = NoResultView()
    
    private lazy var viewModel = MainListViewModel(post: postManager)
    private let postManager = PostManager.shared
    private var subscriptions = Set<AnyCancellable>()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupListCombine()
        viewModel.getUserList()
        addNewMessageObserver()
    }
    
    // MARK: - Selectors
    @objc private func handleNewMessage() {
        refreshRedDot.isHidden = false
    }
    
    @objc
    private func logoutAction() {
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
                    }
                }
            }
        }
    }
    
    @objc
    private func refreshAction() {
        viewModel.getUserList()
        
        self.refreshRedDot.isHidden = true
        
        if !refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
        }
        UIView.animate(withDuration: 1, delay: 0,
                       usingSpringWithDamping: 0.7, initialSpringVelocity: 1,
                       options: .curveEaseIn) {
            self.tableView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.bounds.height)
        } completion: { [weak self] finish in
            self?.refreshControl.endRefreshing()
        }
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
        tableView.register(UserListTVCell.self,
                           forCellReuseIdentifier: UserListTVCell.identifier)
        tableView.snp.makeConstraints {
            $0.top.equalTo(toolBackground.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalTo(view).inset(screenWidth * (16/375))
        }
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView,
                                                   cellProvider: { [unowned self] (tableView, indexPath, user) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserListTVCell.identifier,
                                                           for: indexPath) as? UserListTVCell else { return nil }
            cell.configure(with: user)
            cell.delegate = self
            return cell
        })
        tableView.dataSource = dataSource
        
        tableView.addSubview(refreshControl)
        refreshControl.tintColor = .notice
        refreshControl.addTarget(self,
                                 action: #selector(refreshAction), for: .valueChanged)
        
        view.addSubview(errorView)
        errorView.isHidden = true
        errorView.title = "暫無可用帳號"
        errorView.subTitle = "請嘗試更新或重新登入"
        errorView.snp.makeConstraints {
            $0.edges.equalTo(tableView)
        }
    }
    
    // MARK: - Helpers
    fileprivate func setupListCombine() {        
        viewModel.userList
            .drop(while: { $0.isEmpty })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                guard let self else { return }
                self.updateTableView(by: users)
            }.store(in: &subscriptions)
        
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [tableView, errorView] error in
                tableView.isHidden = error
                errorView.isHidden = !error
            }.store(in: &subscriptions)
    }
    
    private func updateTableView(by users: [ListData]) {
        var snapshot = dataSource.snapshot()
        if !snapshot.itemIdentifiers.isEmpty {
            snapshot.deleteAllItems()
        }
        snapshot.appendSections([0])
        snapshot.appendItems(users, toSection: 0)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func addNewMessageObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNewMessage),
                                               name: Notification.Name("New message"),
                                               object: nil)
    }
    
}

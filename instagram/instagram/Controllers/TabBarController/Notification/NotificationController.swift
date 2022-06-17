//
//  NotificationController.swift
//  instagram
//
//  Created by 서원지 on 2022/04/27.
//

import UIKit

final class NotificationController:  UITableViewController {
    
    //MARK: - Properties
    private var  notifications = [Notification]() {
        didSet { tableView.reloadData() }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        configureUI()
        fetchNotifications()
    }
    
    //MARK:  - API
    private func fetchNotifications() {
        DispatchQueue.main.async {
            NotificationService.fetchNotifications { notifications in
                self.notifications = notifications
                self.checkIfUserisFollowed()
            }
        }
    }
    
    private func checkIfUserisFollowed() {
        notifications.forEach { notification in
            guard notification.type == .follow else { return }
            UserService.checkUserIsFollowed(uid: notification.uid) { isFollowd in
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id}) {
                    self.notifications[index].userIsFollowed = isFollowd
                }
            }
        }
    }
    
    //MARK: - UI 관련
    private func configureUI() {
        configureTableView()
    }
    
    private func configureTableView() {
        navigationItem.title = "알림"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.textColorAsset ?? FeedUIText.colorWrongInput]
        tabBarController?.tabBar.barTintColor = .backgroundColor
        tableView.register(NotificationCell.self,
                           forCellReuseIdentifier: CellIdentifier.notificationCellIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
}

//MARK:  - UITableViewDatSource
extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.notificationCellIdentifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
}

//MARK: - UITableViewDelgate
extension NotificationController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uid  = notifications[indexPath.row].uid
        UserService.fetchUser(withUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

//MARK: - NotificationCellDelegate
extension NotificationController: NotificationCellDelegate {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
        UserService.followUser(uid: uid) { error in
            cell.viewModel?.notification.userIsFollowed.toggle()
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String) {
        UserService.unfollowUser(uid: uid) { error in
            cell.viewModel?.notification.userIsFollowed.toggle()
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String) {
        PostService.fetchPost(withPostId: postId) { post in
            let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.post = post
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

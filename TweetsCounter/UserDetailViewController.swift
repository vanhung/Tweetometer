//
//  UserDetailViewController.swift
//  TweetsCounter
//
//  Created by Patrick Balestra on 2/6/16.
//  Copyright © 2016 Patrick Balestra. All rights reserved.
//

import UIKit
import TweetometerKit

final class UserDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    let linkOpener = LinkOpener()
    
    var user: User?
    weak var coordinator: UserDetailCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()

        guard let user = user else { return }
        user.sortTweets()
        setTitleViewContent(user.name, screenName: user.screenName)
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return user?.tweets.count ?? 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.UserDetailsCellIdentifier.rawValue, for: indexPath) as! UserDetailsTableViewCell
            if let user = user {
                cell.configure(user, coordinator: coordinator)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.TweetCellIdentifier.rawValue, for: indexPath) as! TweetTableViewCell
            if let user = user {
                let tweet = user.tweets[indexPath.row]
                cell.configure(tweet, indexPath: indexPath, coordinator: coordinator)
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Open tweet in user's preferred client
        guard indexPath.section != 0 else { return }
        if let tweetId = user?.tweets[indexPath.row].tweetId {
            coordinator.open(tweet: tweetId)
        }
    }
    
    // MARK: IBActions
    
    @IBAction func openIn(_ sender: UIBarButtonItem) {
        if let user = user {
            coordinator.open(user: user.screenName)
        }
    }
}

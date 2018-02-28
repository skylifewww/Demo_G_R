//
//  ReposViewController.swift
//  DemoAppGetRepos
//
//  Created by Vladimir Nybozhinsky on 28.02.2018.
//  Copyright © 2018 Vladimir Nybozhinsky. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import AlamofireImage

class ReposViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    lazy var refresher:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(doSearchForRefresh), for: .valueChanged)
        return refreshControl
    }()

    var repos: [GithubRepo] = [GithubRepo]()
    var ImageCache = [String:UIImage]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        // tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        if #available(iOS 10.0, *){
            tableView.refreshControl = refresher
        } else {
            tableView.addSubview(refresher)
        }
        
        
        doSearch(offset: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell") as! RepoCell
        cell.repo = repos[indexPath.row]
        
        let ownerAvatarURL = repos[indexPath.row].ownerAvatarURL
        
        if let ownerAvatarImage = ImageCache[ownerAvatarURL!] {
            cell.repoImage.image = ownerAvatarImage
            
        } else {
            
            Alamofire.request(ownerAvatarURL!).responseImage { response in
                
                if let image = response.result.value {
                    
                    self.ImageCache[ownerAvatarURL!] = image
                    DispatchQueue.main.async {
                        cell.repoImage.image = image
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let repo = repos[indexPath.row]
        
        if repo.htmlUrl != nil {
            let webViewVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            webViewVC.urlString = repo.htmlUrl
            self.navigationController?.pushViewController(webViewVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == repos.count - 1{
            if let id = NSInteger(repos[indexPath.row].id!){
                
                loadMoreRepos(offset: id)
            }
        }
    }
    
    func loadMoreRepos(offset: Int) {
        
        RepoWebManager.sharedInstance.fetchRepos(offset: offset){ (repos, error) in
            if let repos = repos{
                self.repos += repos
                self.tableView.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true)
                let deadLine = DispatchTime.now() + .milliseconds(700)
                DispatchQueue.main.asyncAfter(deadline: deadLine, execute: {
                    self.refresher.endRefreshing()
                })
            } else {
                print(error ?? "???")
            }
        }
    }
    
    @objc fileprivate func doSearch(offset: Int) {
        
        RepoWebManager.sharedInstance.fetchRepos(offset: offset){ (repos, error) in
            if let repos = repos{
                self.repos = repos
                self.tableView.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true)
                let deadLine = DispatchTime.now() + .milliseconds(700)
                DispatchQueue.main.asyncAfter(deadline: deadLine, execute: {
                    self.refresher.endRefreshing()
                })
            } else {
                print(error ?? "???")
            }
        }
    }
    @objc func doSearchForRefresh(){
        doSearch(offset: 0)
    }
}

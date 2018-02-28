//
//  WebViewController.swift
//  DemoAppGetRepos
//
//  Created by Vladimir Nybozhinsky on 28.02.2018.
//  Copyright © 2018 Vladimir Nybozhinsky. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class WebViewController: UIViewController{
    
    var urlString:String?{
        didSet {
            print(urlString ?? "no url")
        }
    }
    var rightButton: UIBarButtonItem!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(shareButtonClicked(_:)))
        
        
        rightButton.isEnabled = false
        rightButton.tintColor = .clear
        self.navigationItem.rightBarButtonItem = rightButton
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if webView.estimatedProgress == 1{
                let deadLine = DispatchTime.now() + .milliseconds(700)
                DispatchQueue.main.asyncAfter(deadline: deadLine, execute: {
                    MBProgressHUD.hide(for: self.view, animated: true)
                })
                rightButton.isEnabled = true
                rightButton.tintColor = .white
            }
        }
    }
    
    @objc func shareButtonClicked(_ button:UIBarButtonItem!) {
        let textToShare = "This GITHUB is awesome!  Check out this repositore about it!"
        
        if let myWebsite = NSURL(string: urlString!) {
            let objectsToShare = [textToShare, urlString!, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        if activityType == UIActivityType.postToFacebook.rawValue{
            return NSLocalizedString("Like this!", comment: "comment") as AnyObject
        } else if activityType == UIActivityType.postToTwitter.rawValue {
            return NSLocalizedString("Retweet this!", comment: "comment") as AnyObject
        } else {
            return nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
        let url:URL = URL(string: urlString!)!
        let urlRequest:URLRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear( animated )
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
}

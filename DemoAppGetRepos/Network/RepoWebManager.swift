//
//  RepoWebManager.swift
//  DemoAppGetRepos
//
//  Created by Vladimir Nybozhinsky on 28.02.2018.
//  Copyright © 2018 Vladimir Nybozhinsky. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RepoWebManager {
    
    static let sharedInstance = RepoWebManager()
    
    private let reposUrl = Constants.reposUrl
    
    private let limit = Constants.searchResultsLimit
    
    fileprivate var alamofireManager: Alamofire.SessionManager!
    
    fileprivate init() {
        let configuration = URLSessionConfiguration.default
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func fetchRepos(offset: Int, completionHandler:@escaping (_ repos: [GithubRepo]?, _ error: String?) -> Void) {
        
        alamofireManager.request(reposUrl, method: .get, parameters: ["since" : "\(offset)"], encoding: URLEncoding.default).responseJSON(completionHandler: { response in
            
            switch response.result {
            case .success(let result):
                let resultJSON = JSON.init(result)
                
                if let reposData = resultJSON.array {
                    var repos = [GithubRepo]()
                    
                    for i in 0..<self.limit{
                        
                        let repo = GithubRepo.init(jsonResult:
                            reposData[i])
                        
                        repos.append(repo)
                    }
                    
                    completionHandler(repos, nil)
                } else {
                    completionHandler(nil, "Something is wrong")
                }
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            }
            
        })
    }
}

//
//  GithubRepo.swift
//  DemoAppGetRepos
//
//  Created by Vladimir Nybozhinsky on 28.02.2018.
//  Copyright © 2018 Vladimir Nybozhinsky. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

private let clientId: String? = nil
private let since: String? = nil
private let clientSecret: String? = nil
fileprivate var alamofireManager: Alamofire.SessionManager!


class GithubRepo{
    
    var id : String?
    var name: String?
    var repoDescription: String?
    var ownerHandle: String?
    var ownerAvatarURL: String?
    var htmlUrl: String?
    
    init(jsonResult: JSON) {
        
        
        if let name = jsonResult["name"].string {
            self.name = name
        }
        if let id = jsonResult["id"].int {
            self.id = String(format: "%d", id )
        }
        
        if let description = jsonResult["description"].string {
            self.repoDescription = description
        }
        if let htmlUrl = jsonResult["html_url"].string {
            self.htmlUrl = htmlUrl
        }
        
        if let owner = jsonResult["owner"].dictionary {
            if let ownerHandle = owner["login"]?.string {
                self.ownerHandle = ownerHandle
            }
            if let ownerAvatarURL = owner["avatar_url"]?.string {
                self.ownerAvatarURL = ownerAvatarURL
            }
        }
    }
    
    // GitHub API
//    fileprivate class func queryParams() -> [String: String] {
//        var params: [String:String] = [:]
//        
//        if let clientId = clientId {
//            params["client_id"] = clientId
//        }
//        //        if let since = since {
//        params["since"] = "365"
//        //        }
//        
//        if let clientSecret = clientSecret {
//            params["client_secret"] = clientSecret
//        }
//        
//        //        var q = ""
//        //        if let searchString = settings.searchString {
//        //            q = q + searchString
//        //        }
//        //        q = q + " stars:>\(settings.minStars)"
//        //        params["q"] = q
//        //
//        //        params["sort"] = "stars"
//        //        params["order"] = "desc"
//        
//        return params
//    }
    
//    fileprivate class func queryParamsWithSettings(_ settings: GithubRepoSearchSettings) -> [String: String] {
//        var params: [String:String] = [:]
//        //        if let clientId = clientId {
//        //            params["client_id"] = clientId
//        //        }
//        //
//        //        if let clientSecret = clientSecret {
//        //            params["client_secret"] = clientSecret
//        //        }
//
//        params["since"] = "365"
//
//        //        var q = ""
//        //        if let searchString = settings.searchString {
//        //            q = q + searchString
//        //        }
//        //        q = q + " stars:>\(settings.minStars)"
//        //        params["q"] = q
//        //
//        //        params["sort"] = "stars"
//        //        params["order"] = "desc"
//
//        return params
//    }

}

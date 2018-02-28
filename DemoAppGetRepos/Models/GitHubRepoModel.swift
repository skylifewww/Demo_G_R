//
//  GitHubRepoModel.swift
//  DemoAppGetRepos
//
//  Created by Vladimir Nybozhinsky on 28.02.2018.
//  Copyright © 2018 Vladimir Nybozhinsky. All rights reserved.
//

import Foundation

struct GitHubRepoOwnerModel {
    let ownerHandle:String
    let ownerAvatarURL:String
}

struct GitHubRepoModel {
    let name:String
    let id:String
    let description:String
    let html_url:String
    let owner:GitHubRepoOwnerModel
}

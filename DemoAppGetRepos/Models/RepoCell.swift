//
//  RepoCell.swift
//  DemoAppGetRepos
//
//  Created by Vladimir Nybozhinsky on 28.02.2018.
//  Copyright © 2018 Vladimir Nybozhinsky. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {
    
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var repoImage: UIImageView!
    
    
    var repo: GithubRepo! {
        didSet {
            repoName.text = repo.name
            idLabel.text = "ID: " + repo.id!
            ownerLabel.text = repo.ownerHandle
            descriptionLabel.text = repo.repoDescription
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

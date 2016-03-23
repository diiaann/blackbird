//
//  SelectListCell.swift
//  notable
//
//  Created by Diandian Xiao on 3/22/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit

class SelectListCell: UITableViewCell {

    @IBOutlet weak var checkedImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

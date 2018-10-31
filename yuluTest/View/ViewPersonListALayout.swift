//
//  ViewPersonListALayout.swift
//  yuluTest
//
//  Created by Deepakraj Murugesan on 31/10/18.
//  Copyright © 2018 Noticeboard. All rights reserved.
//

import UIKit

class ViewPersonListALayout: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setDataToCell(name: String){
        self.nameLabel.text = ""
        self.nameLabel.text = name
    }

}

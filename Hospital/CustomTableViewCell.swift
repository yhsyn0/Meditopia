//
//  CustomTableViewCell.swift
//  Hospital
//
//  Created by hsyn on 16.12.2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBackground: UIImageView!
    @IBOutlet weak var docName: UILabel!
    @IBOutlet weak var docDepartment: UILabel!
    @IBOutlet weak var docWorkHours: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

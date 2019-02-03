//
//  WidgetItemTableViewCell.swift
//  HelloWorldWidget
//
//  Created by Mai Kachaban on 29/01/2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

class WidgetItemTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var widgetItemTitle: UILabel!
    
    @IBOutlet weak var widgetItemValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

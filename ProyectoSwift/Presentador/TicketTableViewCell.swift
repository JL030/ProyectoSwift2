//
//  TicketTableViewCell.swift
//  ProyectoSwift
//
//  Created by Rosenrot on 7/3/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var idticketlabel: UILabel!
    @IBOutlet weak var dateticketlabel: UILabel!
    @IBOutlet weak var idmemberlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//
//  isIncludedTableViewCell.swift
//  CalendarSync
//
//  Created by Britton Baird on 10/10/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit

protocol isIncludedTableViewCellDelegate: class {
    func switchValueChanged(_ cell : isIncludedTableViewCell, selected: Bool)
}

class isIncludedTableViewCell: UITableViewCell {

    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var isIncludedSwitch: UISwitch!
    
    weak var delegate: isIncludedTableViewCellDelegate?
    
    @IBAction func includedSwitchPressed(_ sender: Any) {
        delegate?.switchValueChanged(self, selected: isIncludedSwitch.isOn)
    }
    
}

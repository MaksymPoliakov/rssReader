//
//  SideBarController.swift
//  rssReader
//
//  Created by Maksym Poliakov on 23.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import UIKit


protocol SideBarControllerDelegate {
    
    func sideBarControllerDidSelectRow(index: Int)
}


private let sideBarCellId = "sideBarCell"


class SideBarController: UITableViewController {
    
    var delegate: SideBarControllerDelegate?
    var tableData: [String]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView!.register(SideBarCell.self, forCellReuseIdentifier: sideBarCellId)        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sideBarCellId, for: indexPath) as! SideBarCell
        
        cell.titleLabel.text = tableData![indexPath.row]
        
        if indexPath.row == 0 {
            cell.titleLabel.font = UIFont.systemFont(ofSize: 18)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sideBarControllerDidSelectRow(index: indexPath.row)
    }

}

//
//  ViewController.swift
//  TrackMe
//
//  Created by Manuel Meyer on 11.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import UIKit

class PopulatedTableViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!{
        didSet {
            configurePopulating()
        }
    }
    
    var populator: Populator<UITableView>? {
        didSet {
            configurePopulating()
        }
    }
    
    func configurePopulating(){
        if let populator = self.populator, let tableView = self.tableView {
            populator.populatorView = tableView
        }
    }
}

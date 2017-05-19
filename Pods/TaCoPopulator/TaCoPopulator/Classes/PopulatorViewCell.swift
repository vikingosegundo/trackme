//
//  PopulatorViewCell.swift
//  Populator
//
//  Created by Manuel Meyer on 09.12.16.
//  Copyright © 2016 Manuel Meyer. All rights reserved.
//

import UIKit

public
protocol PopulatorViewCell: class {}

extension UITableViewCell: PopulatorViewCell {}
extension UICollectionViewCell: PopulatorViewCell {}

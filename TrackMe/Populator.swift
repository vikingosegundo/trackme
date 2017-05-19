//
//  Populator.swift
//  TrackMe
//
//  Created by Manuel Meyer on 11.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import Foundation
import TaCoPopulator

class Populator<View: PopulatorView> {
    var viewPopulator: ViewPopulator?
    weak var populatorView: View? {
        didSet{
            configure()
        }
    }
    func configure(){
    }
}

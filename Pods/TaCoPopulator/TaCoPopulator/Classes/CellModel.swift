//
//  CellModel.swift
//  Populator
//
//  Created by Manuel Meyer on 07.12.16.
//  Copyright © 2016 Manuel Meyer. All rights reserved.
//

import UIKit


public
protocol CellModelType {
    var reuseIdentifier: String { get }
    var allowsSelection: Bool   { get }
    func toCell(_ populatorView: PopulatorView, indexPath: IndexPath) -> PopulatorViewCell
}


struct CellModel<Element, Cell: PopulatorViewCell>: CellModelType {
    
    init(element: Element, reuseIdentifier: String, allowsSelection: Bool = true, cellConfigurator: @escaping (CellConfigurationDescriptor<Element, Cell>) -> Cell) {
        self.element = element
        self.cellConfigurator = cellConfigurator
        self.reuseIdentifier = reuseIdentifier
        self.allowsSelection = allowsSelection
    }
    
    let element: Element
    let cellConfigurator: (CellConfigurationDescriptor<Element, Cell>) -> Cell
    var allowsSelection: Bool
    var reuseIdentifier: String
    
    func toCell(_ populatorView: PopulatorView, indexPath: IndexPath) -> PopulatorViewCell {

        if let tableView = populatorView as? UITableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? Cell else { fatalError() }
            return cellConfigurator(CellConfigurationDescriptor(element: element, cell: cell, indexPath: indexPath))
        }
        
        if let collectionView = populatorView as? UICollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? Cell else { fatalError() }
            return cellConfigurator(CellConfigurationDescriptor(element: element, cell: cell, indexPath: indexPath))

        }
        fatalError()
    }
}

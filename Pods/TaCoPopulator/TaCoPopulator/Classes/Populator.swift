//
//  Populator.swift
//  Populator
//
//  Created by Manuel Meyer on 07.12.16.
//  Copyright © 2016 Manuel Meyer. All rights reserved.
//

import UIKit
import Foundation

public
struct Populator<Pop: ViewPopulator> {
    
    public init(with populatorView: PopulatorView, sectionCellModelsFactories:[SectionCellsFactoryType] ) {
        let pop:ViewPopulator = Pop(populatorView: populatorView,sectionCellModelsFactories:sectionCellModelsFactories)
        self.populator = pop
    }
    fileprivate let populator: ViewPopulator
}


fileprivate
struct FactoryConfigurator {
    static func factories(_ sectionCellModelsFactories:[SectionCellsFactoryType]) -> [SectionCellsFactoryType]  {
        let factories = sectionCellModelsFactories.enumerated().map {
            offset, factory -> SectionCellsFactoryType in
            var vactory = factory
            vactory.sectionIndex = offset
            return vactory
        }
        return factories
    }
}


fileprivate
struct ToCell<View:PopulatorView> {
    static func cell(from factory: SectionCellsFactoryType, for populatorView: View, at indexPath: IndexPath) -> PopulatorViewCell {
        let model = factory.cellModels()[indexPath.row]
        return  model.toCell(populatorView, indexPath: indexPath)
    }
}


open
class ViewPopulator:NSObject {
    required
    public init(populatorView: PopulatorView ,sectionCellModelsFactories:[SectionCellsFactoryType] ) {
        self.sectionCellModelsFactories = FactoryConfigurator.factories(sectionCellModelsFactories)
        super.init()
        self.populatorView = populatorView
    }
    
    weak var tableView: UITableView?{
        didSet{
            tableView?.dataSource = self
            tableView?.delegate = self
            tableView?.reloadData()
        }
    }
    
    weak var collectionView: UICollectionView? {
        didSet{
            collectionView?.dataSource = self
            collectionView?.delegate = self
            collectionView?.reloadData()
        }
    }
    
    public private(set)
    var populatorView: PopulatorView? {
        set{
            if let tableView = newValue as? UITableView {
                self.tableView = tableView
            }
            
            if let collectionView = newValue as? UICollectionView {
                self.collectionView = collectionView
            }
        }
        
        get{
            if let tableView = tableView {
                return tableView
            }
            
            if let collectionView = collectionView {
                return collectionView
            }
            return nil
        }
    }
    
    open
    let sectionCellModelsFactories: [SectionCellsFactoryType]
}


extension ViewPopulator: UITableViewDataSource, UITableViewDelegate {
    public
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionCellModelsFactories.count
    }
    public
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let factory = sectionCellModelsFactories[section]
        return factory.provider.numberOfElements()
    }
    
    public
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let factory = sectionCellModelsFactories[indexPath.section]
        return ToCell<UITableView>.cell(from: factory, for: tableView, at: indexPath) as! UITableViewCell
    }
    
    public
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let factory = sectionCellModelsFactories[indexPath.section]
        factory.provider.didSelectIndexPath?(indexPath)
    }
    
    public
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let factory = sectionCellModelsFactories[indexPath.section]
        return factory.provider.heightForIndexPath(indexPath)
    }
    
    

    public
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let factory = sectionCellModelsFactories[section]
        if let header = factory.provider.header {
           return header().frame.height
        }
        return 0
    }
    
    public
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let factory = sectionCellModelsFactories[section]
        if let footer = factory.provider.footer {
            return footer().frame.height
        }
        return 0
    }
    
    public
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let factory = sectionCellModelsFactories[section]
        if let header = factory.provider.header {
            return header()
        }
        return nil
    }
    
    public
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let factory = sectionCellModelsFactories[section]
        if let footer = factory.provider.footer {
            return footer()
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let factory = sectionCellModelsFactories[indexPath.section]
        return factory.provider.actionForIndexPath != nil
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let factory = sectionCellModelsFactories[indexPath.section]
        return factory.provider.actionForIndexPath?(indexPath)
    }
}


extension ViewPopulator: UICollectionViewDataSource, UICollectionViewDelegate {
    public
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionCellModelsFactories.count
    }
    
    public
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let factory = sectionCellModelsFactories[section]
        return factory.provider.numberOfElements()
    }
    
    public
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let factory = sectionCellModelsFactories[indexPath.section]
        return ToCell<UICollectionView>.cell(from: factory, for: collectionView, at: indexPath) as! UICollectionViewCell
    }
    
    public
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let factory = sectionCellModelsFactories[indexPath.section]
        factory.provider.didSelectIndexPath?(indexPath)
    }
}

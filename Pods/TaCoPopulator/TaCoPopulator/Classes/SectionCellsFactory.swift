//
//  Populator.swift
//  Populator
//
//  Created by Manuel Meyer on 03.12.16.
//  Copyright © 2016 Manuel Meyer. All rights reserved.
//

import UIKit


public
protocol SectionCellsFactoryType {
    var provider: SectionDataProviderType { set get }
    func cellModels() -> [CellModelType]
    var sectionIndex:Int { get set }
    var elementsDidReload: (() -> Void)? { set get }
    static func == (left: SectionCellsFactoryType, right: SectionCellsFactoryType) -> Bool
}

extension SectionCellsFactoryType {
    public
    static func == (lhs: SectionCellsFactoryType, rhs: SectionCellsFactoryType) -> Bool {
        return lhs.sectionIndex == rhs.sectionIndex
    }
}

public
struct CellConfigurationDescriptor<Element:Any, Cell: PopulatorViewCell> {
    public let element: Element
    public let cell: Cell
    public let indexPath: IndexPath
}

open
class SectionCellsFactory<Element:Any, Cell: PopulatorViewCell>: SectionCellsFactoryType {
    
    public
    init(populatorView: PopulatorView, provider: SectionDataProvider<Element>, elementsDidReload:(() -> Void)? = nil ,cellConfigurator: @escaping ((CellConfigurationDescriptor<Element, Cell>) -> Cell)){
        self.provider = provider
        self.populatorView = populatorView
        self.cellConfigurator = cellConfigurator
        
        if let elementsDidReload = elementsDidReload {
            self.elementsDidReload = elementsDidReload
        } else {
            self.elementsDidReload = { populatorView.reloadData() }
        }
        
        self.provider.elementsDidReload = {
            [weak self] in
            guard let `self` = self else { return }
            self.elementsDidReload?()
        }
    }
    
    open var provider: SectionDataProviderType
    
    open let  cellConfigurator: ((CellConfigurationDescriptor<Element, Cell>) -> Cell)
    open var sectionIndex: Int = -1
    fileprivate weak var populatorView: PopulatorView?
    open var elementsDidReload: (() -> Void)?
    open
    func cellModels() -> [CellModelType] {
        guard let realProvider = provider as? SectionDataProvider<Element> else { fatalError() }
        guard let _ = populatorView else { return [] }
        
        let models: [CellModel] = realProvider.elements().enumerated().map {
            offset, element in
            return CellModel(element: element,
                             reuseIdentifier: realProvider.reuseIdentifer(element, IndexPath(row: offset, section: sectionIndex)),
                             cellConfigurator: cellConfigurator)
        }
        return models
    }   
}

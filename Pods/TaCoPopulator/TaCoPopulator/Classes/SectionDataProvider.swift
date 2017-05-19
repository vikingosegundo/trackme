//
//  SectionDataProvider.swift
//  Populator
//
//  Created by Manuel Meyer on 08.12.16.
//  Copyright © 2016 Manuel Meyer. All rights reserved.
//

import UIKit


public
protocol SectionDataProviderType {
    var didSelectIndexPath:((IndexPath) -> Void)? { get }
    var actionForIndexPath:((IndexPath) -> [UITableViewRowAction]?)? { get }

    var elementsDidReload:(() -> Void)? { set get }
    func numberOfElements() -> Int
    func elementAt(index: Int) -> Any
    func heightForIndexPath(_ indexPath: IndexPath) -> CGFloat
    var header: (() -> UITableViewHeaderFooterView)? { set get }
    var footer: (() -> UITableViewHeaderFooterView)? { set get }

}


open
class SectionDataProvider<Element>: SectionDataProviderType {
    
    public
    init(reuseIdentifer: @escaping (Element, IndexPath) -> String) {
        self.reuseIdentifer = reuseIdentifer
    }
    
    open
    var elementsDidReload: (() -> Void)?

    open fileprivate(set)
    var didSelectIndexPath:((IndexPath) -> Void)?
    
 
    open
    var selected:((Element, IndexPath) -> Void)? {
        didSet {
            didSelectIndexPath = { [weak self] indexPath in
                guard let `self` = self else { return }
                let element = self.elements()[indexPath.row]
                self.selected?(element,indexPath)
            }
        }
    }
    open fileprivate(set)
    var actionForIndexPath: ((IndexPath) -> [UITableViewRowAction]?)?
    
    open var actionsForElement: ((Element, IndexPath) -> [UITableViewRowAction]?)? {
        didSet {
            actionForIndexPath = { [weak self] indexPath in
                guard let `self` = self else { return nil }
                let element = self.elements()[indexPath.row]
                return self.actionsForElement?(element, indexPath)
            }
        }
    }

    
    fileprivate
    var privateElements: [Element] = [] {
        didSet{
            elementsDidReload?()
        }
    }
    
    internal
    let reuseIdentifer: (Element, IndexPath) -> String
    
    public
    var heightForCell:((Element, IndexPath) -> CGFloat)?
    
    public
    var header: (() -> UITableViewHeaderFooterView)?
    
    public
    var footer: (() -> UITableViewHeaderFooterView)?
    
    public
    func heightForIndexPath(_ indexPath: IndexPath) -> CGFloat {
        if let heightForCell = heightForCell, let elm = elementAt(index: indexPath.row) as? Element {
            return heightForCell(elm, indexPath)
        }
        return UITableViewAutomaticDimension
    }
}

extension SectionDataProvider {
    
    open
    func provideElements(_ elements: [Element]) {
        privateElements = elements
    }
    
    open
    func elementAt(index:Int) -> Any {
        return elements()[index]
    }
    
    open
    func elements() -> [Element] {
        return privateElements
    }
    
    open
    func numberOfElements() -> Int {
        return elements().count
    }
}


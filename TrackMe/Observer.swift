//
//  ObserverType.swift
//  HearingTest
//
//  Created by Manuel Meyer on 03.02.17.
//

import Foundation

protocol UniquelyIdentifiable {
    var uniqueIdentifier: UUID { get }
}

protocol ObserverType: UniquelyIdentifiable {
    func updated(observable: Observable)
}

protocol Observable: class {
    var observers: [ObserverType] { set get }
    func notifyObservers()
    func register(observer: ObserverType)
    func unregister(observer: ObserverType)
}

extension Observable {
   
    func register(observer: ObserverType) {
        var observerWrapperSet = Set(observers.map { observer -> ObserverWrapper in
            return ObserverWrapper(observer: observer)
        })
        observerWrapperSet.insert(ObserverWrapper(observer: observer))
        self.observers = observerWrapperSet.map { wrapper -> ObserverType in
            return wrapper.observer
        }
        self.notifyObservers()
    }
    
    func unregister(observer: ObserverType) {
        observers = observers.filter { $0.uniqueIdentifier != observer.uniqueIdentifier }
    }
    
    func notifyObservers() {
        observers.forEach { observer in
            observer.updated(observable: self)
        }
    }
}

private struct ObserverWrapper: Hashable {
    init(observer: ObserverType) {
        self.observer = observer
    }
    let observer: ObserverType
    
    var hashValue: Int {
        return observer.uniqueIdentifier.hashValue
    }
    
    static func == (lhs: ObserverWrapper, rhs: ObserverWrapper) -> Bool {
        return lhs.observer.uniqueIdentifier == rhs.observer.uniqueIdentifier
    }
}

//
//  Model.swift
//  TrackMe
//
//  Created by Manuel Meyer on 11.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import Foundation




struct WorkingSession: DictionaryRepresentable {
    
    init(with dictionary: [String : Any?]) throws {
        if let startDate = dictionary["startDate"]  as? Date {
            self.startDate = startDate
        } else {
            throw SerialisationError.deserialisationFailed("Could not deserialize \(dictionary) to WorkingSession")
        }
        self.endDate = dictionary["endDate"] as? Date
    }
    
    init(startDate: Date, endDate: Date?) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    let startDate: Date
    let endDate: Date?
    
    var finished: Bool {
        return endDate != nil
    }
    
    var dictionaryRepresentation: [String : Any?] {
        var dict = [String: Any?]()
        dict["startDate"] = self.startDate
        dict["endDate"] = self.endDate
        return dict
    }
}

struct Project: DictionaryRepresentable {
    enum Sorting {
        case az
        case za
    }
    
    init(title: String, workingSessions: [WorkingSession] = [], uniqueIdentifier: UUID = UUID()) {
        self.title = title
        self.workingSessions = workingSessions
        self.uniqueIdentifier = uniqueIdentifier
    }
    
    init(with dictionary: [String : Any?]) throws {
        
        if let title = dictionary["title"] as? String,
            let id = dictionary["id"] as? String,
            let uuid = UUID(uuidString: id) {
            self.title = title
            self.uniqueIdentifier = uuid
        } else {
            throw SerialisationError.deserialisationFailed("could not deserialise \(dictionary) to Project")
        }

        self.workingSessions = try {
            if let sessionDicts = dictionary["workingSessions"] as? [[String:Any?]] {
                return try sessionDicts.map({ (dict) -> WorkingSession in
                    return try WorkingSession(with: dict)
                })
            } else {
                return []
            }
        }()
    }
    
    let title: String
    let workingSessions: [WorkingSession]
    var uniqueIdentifier: UUID
    
    var activeWorkingSession: WorkingSession? {
        return workingSessions.filter{ $0.endDate == nil }.last
    }
    
    var timeElapsed: TimeInterval {
        let sessionsTime = workingSessions.reduce(TimeInterval(0)) { (previos, session) -> TimeInterval in
            
            let endDate: Date
            if let end = session.endDate {
                endDate = end
            } else {
                endDate = Date()
            }
            let comps = Calendar.autoupdatingCurrent.dateComponents([.second], from: session.startDate, to: endDate)
            
            let t: TimeInterval
            if let second = comps.second {
                t = TimeInterval(second)
            } else {
                t = TimeInterval(0)
            }
            return previos + t
        }
        return sessionsTime
    }
    
    var dictionaryRepresentation: [String: Any?] {
        var dict = [String: Any?]()
        dict["id"] = self.uniqueIdentifier.uuidString
        dict["title"] = self.title
        let sessionDicts = self.workingSessions.map { (session) -> [String: Any?] in
            return session.dictionaryRepresentation
        }
        dict["workingSessions"] = sessionDicts
        return dict
    }
}

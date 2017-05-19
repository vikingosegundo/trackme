//
//  WorkingSessionTableViewCell.swift
//  TrackMe
//
//  Created by Manuel Meyer on 12.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import UIKit

class WorkingSessionTableViewCell: UITableViewCell {

    @IBOutlet weak private var startDateLabel: UILabel!
    @IBOutlet weak private var endDateLabel: UILabel!
    
    func configure(for workingSession: WorkingSession) {
        self.startDateLabel.text = format(date:workingSession.startDate)
        if let endDate = workingSession.endDate {
            self.endDateLabel.text = format(date: endDate)
        } else {
            self.endDateLabel.text = ""
        }
    }
    
    private
    func format(date: Date) -> String {
        struct Static {
            static var dateFormatter: DateFormatter = {
                let df = DateFormatter()
                df.setLocalizedDateFormatFromTemplate("YYYYMMdd hhmm")
                return df
            }()
        }
        return Static.dateFormatter.string(from: date)
    }
}

//
//  ProjectOverviewTableViewCell.swift
//  TrackMe
//
//  Created by Manuel Meyer on 11.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import UIKit

class ProjectOverviewTableViewCell: UITableViewCell {
    func configureFor(project: Project) {
        self.textLabel?.text = project.title
        if project.activeWorkingSession != nil {
            self.contentView.backgroundColor = .orange
            self.textLabel?.backgroundColor = .orange
        } else {
            self.contentView.backgroundColor = .white
            self.textLabel?.backgroundColor = .white
        }
    }
}

//
//  AddProjectViewController.swift
//  TrackMe
//
//  Created by Manuel Meyer on 11.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import UIKit

class AddProjectViewController: UIViewController {
    
    var projectController: ProjectControllerType?
    var shouldDismiss: (() -> Void )?
    @IBOutlet weak private var titleTextField: UITextField! {
        didSet{
            titleTextField.becomeFirstResponder()
        }
    }
    @IBAction func okTapped(_ sender: Any) {
        guard let title = self.titleTextField.text,
            title != "" else {
                return
        }
        projectController?.addProject(title: title)
        shouldDismiss?()
    }

    @IBAction func cancelTapped(_ sender: Any) {
        shouldDismiss?()
    }
}

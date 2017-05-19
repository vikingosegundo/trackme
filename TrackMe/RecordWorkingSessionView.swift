//
//  RecordSessionIntervalView.swift
//  TrackMe
//
//  Created by Manuel Meyer on 12.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import UIKit

class RecordWorkingSessionView: UITableViewHeaderFooterView {
    var isRecording = false {
        didSet{
            configureTitle()
        }
    }
    var recordStarted: (() -> Void)?
    var recordPaused: (() -> Void)?

    @IBOutlet weak private var recordButton: UIButton!

    @IBOutlet weak private var duration: UILabel!
    var durationLabel: UILabel{
        return duration
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        if self.isRecording {
            recordPaused?()
            recordButton.setTitle("tap to pause recording", for: .normal)
        } else {
            recordStarted?()
            recordButton.setTitle("tap to start recording", for: .normal)
        }
        isRecording = !isRecording

    }
    
    func configureTitle() {
        if self.isRecording {
            recordButton.setTitle("tap to pause recording", for: .normal)
        } else {
            recordButton.setTitle("tap to start recording", for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTitle()
    }

}


extension UIView {
    class func fromNib<T: UIView>() -> T {
        
        guard let nib = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil) else {
            fatalError("nib not loaded")
        }
        guard let view = nib.first as? T else {
            fatalError("view loaded from nib not of correct type")
        }
        return view
    }
}

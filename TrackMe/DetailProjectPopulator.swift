//
//  DetailProjectPopulator.swift
//  TrackMe
//
//  Created by Manuel Meyer on 11.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import Foundation
import TaCoPopulator

class WorkingSessionProvider: SectionDataProvider<WorkingSession> {
    
    init(project: Project, reuseIdentifer: @escaping (WorkingSession, IndexPath) -> String) {
        self.project = project
        super.init(reuseIdentifer: reuseIdentifer)
        provideWorkingSessions()
    }
    
    var project: Project {
        didSet {
            provideWorkingSessions()
        }
    }
    
    private
    func provideWorkingSessions() {
        self.provideElements(self.project.workingSessions.reversed())
    }
}

class DetailProjectPopulator<View: PopulatorView>: Populator<View>, ObserverType {
    
    init(project: Project, projectController: ProjectControllerType) {
        self.projectController = projectController
        provider = WorkingSessionProvider(project: project){ _ -> String in
            return "WorkingSessionCell"
        }
        super.init()
        self.projectController.register(observer: self)
    }
    
    deinit {
        self.projectController.unregister(observer: self)
    }
    
    let projectController: ProjectControllerType
    var uniqueIdentifier: UUID = UUID()
    let provider: WorkingSessionProvider
    
    func updated(observable: Observable) {
        if observable is ProjectControllerType {
            if  let tableView = populatorView as? UITableView,
                let header = tableView.tableHeaderView as? RecordWorkingSessionView {
                header.isRecording = provider.project.activeWorkingSession != nil
            }
            self.populatorView?.reloadData()
        }
    }
    
    override func configure() {
        if let populatorView = populatorView {
            configureTableView(for: populatorView)
            self.viewPopulator = ViewPopulator(populatorView: populatorView, sectionCellModelsFactories: [section1Factory(for: populatorView)])
        }
    }
    
    private var timer: Timer?
    
    private
    func configureDurationLabel(header: RecordWorkingSessionView) {
        let interval = Int(self.provider.project.timeElapsed)
        let minutesString = String(format: "%02d", (interval / 60) % 60)
        let secondsString = String(format: "%02d", interval % 60)
        let hours = interval / 3600
        header.durationLabel.text = "\(hours):\(minutesString):\(secondsString)"
    }
    
    private
    func headerView() -> UITableViewHeaderFooterView {
        let header: RecordWorkingSessionView = RecordWorkingSessionView.fromNib()
        header.isRecording = provider.project.activeWorkingSession != nil
        configureDurationLabel(header: header)
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true){ [weak self, weak header] _ in
            if let `self` = self, let header = header {
                self.configureDurationLabel(header: header)
            }
        }
        
        header.recordStarted = { [weak self] in
            guard let `self` = self else {
                return
            }
            self.provider.project = self.projectController.startRecordingWorkingSessionFor(project: self.provider.project)
        }
        
        header.recordPaused = { [weak self] in
            guard let `self` = self else {
                return
            }
            self.provider.project = self.projectController.pauseRecordingWorkingSessionFor(project: self.provider.project)
        }
        return header
    }
    
    private
    func configureTableView(for populatorView: PopulatorView) {
        if let tableView = populatorView as? UITableView {
            tableView.register(UINib(nibName: "WorkingSessionTableViewCell", bundle: nil), forCellReuseIdentifier: "WorkingSessionCell")
            tableView.tableHeaderView = self.headerView()
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 86.0
        }
    }   
    
    private
    func section1Factory(for populatorView: PopulatorView) -> SectionCellsFactory<WorkingSession, WorkingSessionTableViewCell> {
        let cellConfigurator: ((CellConfigurationDescriptor<WorkingSession, WorkingSessionTableViewCell>) -> WorkingSessionTableViewCell) = {
            descriptor -> WorkingSessionTableViewCell in
            descriptor.cell.configure(for: descriptor.element)
            return descriptor.cell
        }
        return SectionCellsFactory(populatorView: populatorView, provider: provider, cellConfigurator: cellConfigurator)
    }
}

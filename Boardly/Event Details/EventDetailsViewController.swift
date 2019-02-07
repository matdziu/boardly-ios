//
//  EventDetailsViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 04/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class EventDetailsViewController: BaseNavViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var playersView: UIView!
    @IBOutlet weak var adminView: UIView!
    
    private var childViewsContainer: [UIView] = []
    
    var isAdmin: Bool = false
    var eventId: String = ""
    
    func prepare(isAdmin: Bool, eventId: String) {
        self.isAdmin = isAdmin
        self.eventId = eventId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childViewsContainer = [chatView, playersView, adminView]
        containerSwitched(segmentedControl)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chatViewController = segue.destination as? ChatViewController {
            chatViewController.prepare(eventId: eventId)
        }
        if let childEventDetailsViewController = segue.destination as? ChildEventDetailsViewController {
            childEventDetailsViewController.prepare(eventId: eventId, isAdmin: isAdmin)
        }
    }
    
    @IBAction func containerSwitched(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showOnly(chatView)
        case 1:
            if isAdmin {
                showOnly(adminView)
            } else {
                showOnly(playersView)
            }
        default:
            return
        }
    }
    
    private func showOnly(_ view: UIView) {
        for childView in childViewsContainer {
            if childView == view {
                childView.alpha = 1
            } else {
                childView.alpha = 0
            }
        }
    }
}

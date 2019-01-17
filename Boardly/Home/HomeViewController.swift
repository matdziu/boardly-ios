//
//  HomeViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsCollectionView.dataSource = self
        eventsCollectionView.delegate = self
    }
    
    private var events: [BoardlyEvent] = [] {
        didSet {
            eventsCollectionView.reloadData()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let boardlyEventCell = collectionView.dequeueReusableCell(withReuseIdentifier: EVENT_CELL_ID, for: indexPath) as! BoardlyEventCell
        let event = events[indexPath.row]
        return boardlyEventCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 334)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

//
//  UIImageViewExtensions.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 27/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func downloaded(from url: URL, placeHolder: UIImage?) {
        self.kf.setImage(with: url,
                         placeholder: placeHolder,
                         options: [KingfisherOptionsInfoItem.cacheOriginalImage])
    }
    
    func cancel() {
        self.kf.cancelDownloadTask()
    }
    
    func downloaded(from link: String, placeHolder: UIImage?) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, placeHolder: placeHolder)
    }
    
    func roundBorderCorners() {
        self.layer.borderColor = UIColor(named: Color.grey.rawValue)?.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 3.0
    }
}

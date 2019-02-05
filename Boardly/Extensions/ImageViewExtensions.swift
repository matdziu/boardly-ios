//
//  UIImageViewExtensions.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 27/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

private var imageTasks = [UIImageView : DataRequest]()

extension UIImageView {
    
    func downloaded(from url: URL) {
        let task = Alamofire.request(url, method: .get).responseImage { response in
            guard let image = response.result.value else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }
        imageTasks[self] = task
        task.resume()
    }
    
    func cancel() {
        imageTasks[self]?.cancel()
    }
    
    func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url)
    }
    
    func roundBorderCorners() {
        self.layer.borderColor = UIColor(named: Color.grey.rawValue)?.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 3.0
    }
}

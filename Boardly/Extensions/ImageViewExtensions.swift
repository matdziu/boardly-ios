//
//  UIImageViewExtensions.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 27/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func downloaded(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func cancelAll() {
        URLSession.shared.getAllTasks { allTasks in
            for task in allTasks {
                task.cancel()
            }
        }
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
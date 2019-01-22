//
//  ButtonExtensions.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 22/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

private var userInfos = [UIView : [String: Any]]()

extension UIView {
    
    var userInfo: [String : Any] {
        get {
            guard let userInfo = userInfos[self] else {
                return [:]
            }
            return userInfo
        }
        set {
            userInfos[self] = newValue
        }
    }
}

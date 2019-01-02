//
//  BaseJoinEventView.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 02/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol BaseJoinEventView {
    
    func joinEventEmitter() -> Observable<JoinEventData>
}

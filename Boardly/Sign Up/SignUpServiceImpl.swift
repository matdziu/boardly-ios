//
//  SignUpServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class SignUpServiceImpl: SignUpService {
    
    func signUp(email: String, password: String) -> Observable<Bool> {
        return Observable.just(true).delay(RxTimeInterval(3), scheduler: ConcurrentDispatchQueueScheduler(queue: .global()))
    }
}

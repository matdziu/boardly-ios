//
//  ArrayExtensions.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

extension Sequence {
    func distinct<A: Hashable>(by selector: (Iterator.Element) -> A) -> [Iterator.Element] {
        var set: Set<A> = []
        var list: [Iterator.Element] = []
        
        forEach { e in
            let key = selector(e)
            if set.insert(key).inserted {
                list.append(e)
            }
        }
        
        return list
    }
}

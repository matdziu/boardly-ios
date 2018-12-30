//
//  FilterViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 28/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class FilterViewController: BaseNavViewController, FilterView {
    
    private var gameIdSubject: PublishSubject<String>!
    private var locationProcessingSubject: PublishSubject<Bool>!
    
    private let filterPresenter = FilterPresenter(filterInteractor: FilterInteractorImpl(gameService: GameServiceImpl()))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        filterPresenter.bind(filterView: self)
    }
    
    private func initEmitters() {
        gameIdSubject = PublishSubject<String>()
        locationProcessingSubject = PublishSubject<Bool>()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        filterPresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    func gameIdEmitter() -> Observable<String> {
        return gameIdSubject
    }
    
    func locationProcessingEmitter() -> Observable<Bool> {
        return locationProcessingSubject
    }
    
    func render(filterViewState: FilterViewState) {
        
    }
}

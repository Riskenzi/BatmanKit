//
//  RxLifeCycleController.swift
//  Volt
//
//  Created by   Валерий Мельников on 29.10.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


public enum RxLifeCycleController: Equatable {
    case viewWillAppear
    case viewDidAppear
    case viewWillDisappear
    case viewDidDisappear
    case viewDidLoad
    case viewDidLayoutSubviews
}


extension RxSwift.Reactive where Base: UIViewController {
    public var viewDidLoad: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidLoad))
            .map { _ in return }
    }
    
    public var viewDidLayoutSubviews: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .map { _ in return }
    }
    
    public var viewWillAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { $0.first as? Bool ?? false }
    }
    
    public var viewDidAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewDidAppear))
            .map { $0.first as? Bool ?? false }
    }
    
    public var viewWillDisappear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillDisappear))
            .map { $0.first as? Bool ?? false }
    }
    
    public var viewDidDisappear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewDidDisappear))
            .map { $0.first as? Bool ?? false }
    }
    
    public var viewState: Observable<RxLifeCycleController> {
        return Observable.of(
            viewDidLoad.map {_ in return RxLifeCycleController.viewDidLoad },
            viewDidLayoutSubviews.map {_ in return RxLifeCycleController.viewDidLayoutSubviews },
            viewWillAppear.map {_ in return RxLifeCycleController.viewWillAppear },
            viewDidAppear.map {_ in return RxLifeCycleController.viewDidAppear },
            viewWillDisappear.map {_ in return RxLifeCycleController.viewWillDisappear },
            viewDidDisappear.map {_ in return RxLifeCycleController.viewDidDisappear }
            )
            .merge()
    }
}


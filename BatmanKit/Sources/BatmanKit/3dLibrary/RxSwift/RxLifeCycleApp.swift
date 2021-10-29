//
//  rxAppState.swift
//  Volt
//
//  Created by   Валерий Мельников on 29.10.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public enum RxLifeCycleApp: Equatable {

    case active
    case inactive
    case background
    case terminated
}

/**
 Stores the current and the previous App version
 */
public struct AppVersion: Equatable {
    public let previous: String
    public let current: String
}

public struct RxAppState {

    public static var currentAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
}

extension RxSwift.Reactive where Base: UIApplication {
    
    fileprivate struct DefaultName {
        static var didOpenAppCount: String { return "RxAppState_numDidOpenApp" }
        static var previousAppVersion: String { return "RxAppState_previousAppVersion" }
        static var currentAppVersion: String { return "RxAppState_currentAppVersion" }
    }
 
    public var applicationWillEnterForeground: Observable<RxLifeCycleApp> {
        return NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .map { _ in
                return .inactive
            }
    }

    public var applicationDidBecomeActive: Observable<RxLifeCycleApp> {
        return NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
        .map { _ in
            return .active
        }
    }

   
    public var applicationDidEnterBackground: Observable<RxLifeCycleApp> {
        return NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)
        .map { _ in
            return .background
        }
    }
    
    
    public var applicationWillResignActive: Observable<RxLifeCycleApp> {
        return NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification)
        .map { _ in
            return .inactive
        }
    }

    public var applicationWillTerminate: Observable<RxLifeCycleApp> {
        return NotificationCenter.default.rx.notification(UIApplication.willTerminateNotification)
        .map { _ in
            return .terminated
        }
    }
   
    public var appState: Observable<RxLifeCycleApp> {
        return Observable.of(
            applicationDidBecomeActive,
            applicationWillResignActive,
            applicationWillEnterForeground,
            applicationDidEnterBackground,
            applicationWillTerminate
            )
            .merge()
    }
    
    public var didOpenApp: Observable<Void> {
        return Observable.of(
            applicationDidBecomeActive,
            applicationDidEnterBackground
            )
            .merge()
            .distinctUntilChanged()
            .filter { $0 == .active }
            .map { _ in
                return
        }
    }
    

    public var didOpenAppCount: Observable<Int> {
        return base._sharedRxAppState.didOpenAppCount
    }
    
    public var isFirstLaunch: Observable<Bool> {
        return base._sharedRxAppState.isFirstLaunch
    }
    

    public var appVersion: Observable<AppVersion> {
        return base._sharedRxAppState.appVersion
    }

 
    public var isFirstLaunchOfNewVersion: Observable<Bool> {
        return base._sharedRxAppState.isFirstLaunchOfNewVersion
    }
    
    public var firstLaunchOfNewVersionOnly: Observable<AppVersion> {
        return base._sharedRxAppState.firstLaunchOfNewVersionOnly
    }


    public var firstLaunchOnly: Observable<Void> {
        return base._sharedRxAppState.firstLaunchOnly
    }
    
}

fileprivate struct _SharedRxAppState {
    typealias DefaultName = Reactive<UIApplication>.DefaultName
    
    let rx: Reactive<UIApplication>
    let disposeBag = DisposeBag()
    
    init(_ application: UIApplication) {
        rx = application.rx
        rx.didOpenApp
            .subscribe(onNext: updateAppStats)
            .disposed(by: disposeBag)
    }
    
    private func updateAppStats() {
        let userDefaults = UserDefaults.standard
        
        var count = userDefaults.integer(forKey: DefaultName.didOpenAppCount)
        count = min(count + 1, Int.max - 1)
        userDefaults.set(count, forKey: DefaultName.didOpenAppCount)
        
        let previousAppVersion = userDefaults.string(forKey: DefaultName.currentAppVersion) ?? RxAppState.currentAppVersion
        let currentAppVersion = RxAppState.currentAppVersion
        userDefaults.set(previousAppVersion, forKey: DefaultName.previousAppVersion)
        userDefaults.set(currentAppVersion, forKey: DefaultName.currentAppVersion)
    }
    
    lazy var didOpenAppCount: Observable<Int> = rx.didOpenApp
        .map { _ in
            return UserDefaults.standard.integer(forKey: DefaultName.didOpenAppCount)
        }
        .share(replay: 1, scope: .forever)
    
    lazy var isFirstLaunch: Observable<Bool> = rx.didOpenApp
        .map { _ in
            let didOpenAppCount = UserDefaults.standard.integer(forKey: DefaultName.didOpenAppCount)
            return didOpenAppCount == 1
        }
        .share(replay: 1, scope: .forever)
    
    lazy var firstLaunchOnly: Observable<Void> = rx.isFirstLaunch
        .filter { $0 }
        .map { _ in return }
    
    lazy var appVersion: Observable<AppVersion> = rx.didOpenApp
        .map { _ in
            let userDefaults = UserDefaults.standard
            let currentVersion: String = userDefaults.string(forKey: DefaultName.currentAppVersion) ?? RxAppState.currentAppVersion ?? ""
            let previousVersion: String = userDefaults.string(forKey: DefaultName.previousAppVersion) ?? currentVersion
            return AppVersion(previous: previousVersion, current: currentVersion)
        }
        .share(replay: 1, scope: .forever)
    
    lazy var isFirstLaunchOfNewVersion: Observable<Bool> = appVersion
        .map { version in
            return version.previous != version.current
        }
    
    lazy var firstLaunchOfNewVersionOnly: Observable<AppVersion> = appVersion
        .filter { $0.previous != $0.current }
}

private var _sharedRxAppStateKey: UInt8 = 0
extension UIApplication {
    fileprivate var _sharedRxAppState: _SharedRxAppState {
        get {
            if let stored = objc_getAssociatedObject(self, &_sharedRxAppStateKey) as? _SharedRxAppState {
                return stored
            }
            let defaultValue = _SharedRxAppState(self)
            self._sharedRxAppState = defaultValue
            return defaultValue
        }
        set {
            objc_setAssociatedObject(self, &_sharedRxAppStateKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension RxAppState {
    /**
     For testing purposes
     */
    internal static func clearSharedObservables() {
        objc_setAssociatedObject(UIApplication.shared,
                                 &_sharedRxAppStateKey,
                                 nil,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

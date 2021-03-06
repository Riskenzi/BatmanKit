//
//  rxBattery.swift
//  Volt
//
//  Created by Oleksandr Popov on 27.07.2021.
//

import Foundation
import class UIKit.UIDevice
import class UIKit.NotificationCenter
import class Foundation.ProcessInfo
import class RxRelay.BehaviorRelay

open class rxBattery {
    
    /// Singleton
    public static let monitor = rxBattery()
    
    /// Low Level
    open var isLowLevel: BehaviorRelay<Bool> = .init(value: Bool())
    
    /// Critical Level
    open var isCriticalLevel: BehaviorRelay<Bool> = .init(value: Bool())
    
    /// Battery Level
    open var level: BehaviorRelay<Float> = .init(value: UIDevice.current.batteryLevel)
    
    /// Battery State
    open var state: BehaviorRelay<UIDevice.BatteryState> = .init(value: UIDevice.current.batteryState)
    
    /// Battery Low Power Mode Enabled Status
    open var isLowPowerMode: BehaviorRelay<Bool> = .init(value: ProcessInfo.processInfo.isLowPowerModeEnabled)
    
    /// Battery Monitoring Enabled
    open var isEnabled: Bool = false {
        didSet {
            UIDevice.current.isBatteryMonitoringEnabled = isEnabled
        }
    }
    
    /// Is Low Level Value
    private var isLowLevelValue: Bool = false {
        didSet {
            isLowLevel.accept(isLowLevelValue)
        }
    }
    
    /// Is Critical Level Value
    private var isCriticalLevelValue: Bool = false {
        didSet {
            isCriticalLevel.accept(isCriticalLevelValue)
        }
    }
    
    deinit {
        stop()
    }
    
    /// Start Monitoring
    open func start() {
        isEnabled = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(lowerPowerModeChanged),
                                               name: .NSProcessInfoPowerStateDidChange,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(batteryStateChanged),
                                               name: UIDevice.batteryStateDidChangeNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(batteryLevelChanged),
                                               name: UIDevice.batteryLevelDidChangeNotification,
                                               object: nil)
        
        notifyCurrentStatus()
    }
    
    /// Stop Monitor
    open func stop() {
        isEnabled = false
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Notify Currunt Battery Status
    open func notifyCurrentStatus() {
        lowerPowerModeChanged()
        batteryStateChanged()
        batteryLevelChanged()
    }
    
    /// LowerPowerMode Notify Changes
    @objc
    private func lowerPowerModeChanged() {
        guard isEnabled else { return }
        isLowPowerMode.accept(ProcessInfo.processInfo.isLowPowerModeEnabled)
    }
    
    /// BatteryState Notify Changes
    @objc
    private func batteryStateChanged() {
        guard isEnabled else { return }
        state.accept(UIDevice.current.batteryState)
    }
    
    /// BatteryLevel Notify Changes
    @objc
    private func batteryLevelChanged() {
        
        // in some cases -1 comes
        guard UIDevice.current.batteryLevel >= 0.0, isEnabled else { return }
        
        level.accept(UIDevice.current.batteryLevel * 100)
        
        // isLowLevel
        if level.value > 20 {
            isLowLevelValue = false
            isCriticalLevelValue = false
        } else if level.value <= 20 {
            isLowLevelValue = true
        }
        
        // isCriticalLevel
        if level.value <= 10 {
            isCriticalLevelValue = true
        }
    }
}

//
//deinit {
//    battery.stop()
//}
//
//func setObserver() {
//    battery.level
//    .observeOn(MainScheduler.instance)
//    .subscribe(onNext: { [weak self] level in
//        guard let self = self else { return }
//        self.batteryLevelLabel.text = "\(level)"
//    }).disposed(by: disposeBag)
//    
//    battery.state
//    .observeOn(MainScheduler.instance)
//    .subscribe(onNext: { [weak self] state in
//        guard let self = self else { return }
//        switch state {
//        case .unknown:
//            self.batteryStateLabel.text = "unknown"
//        case .unplugged:
//            self.batteryStateLabel.text = "unplugged"
//        case .charging:
//            self.batteryStateLabel.text = "charging"
//        case .full:
//            self.batteryStateLabel.text = "full"
//        @unknown default:
//            fatalError()
//        }
//    }).disposed(by: disposeBag)
//    
//    battery.isLowPowerMode
//    .observeOn(MainScheduler.instance)
//    .subscribe(onNext: { [weak self] isLowPowerMode in
//        guard let self = self else { return }
//        self.isLowPowerModeLabel.text = "\(isLowPowerMode)"
//    }).disposed(by: disposeBag)
//    
//    battery.isLowLevel
//    .distinctUntilChanged()
//    .subscribe(onNext: { [weak self] isLowLevel in
//        guard let self = self else { return }
//        self.isLowBatteryLabel.text = "\(isLowLevel)"
//    }).disposed(by: disposeBag)
//    
//    
//    battery.isCriticalLevel
//    .distinctUntilChanged()
//    .subscribe(onNext: { [weak self] isCriticalLevel in
//        guard let self = self else { return }
//        self.isCriticalBatteryLabel.text = "\(isCriticalLevel)"
//    }).disposed(by: disposeBag)
//}

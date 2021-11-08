//
//  File.swift
//  
//
//  Created by   Валерий Мельников on 29.10.2021.
//

import Foundation
import UIKit


open class NavigationCoordinator: NSObject, Coordinator {
    
    public  var rootViewController: UIViewController {
        navigationController
    }
    
    public let navigationController: BaseNavController
    public var childCoordinators = [Coordinator]()
    public var parentCoordinator: Coordinator?
    
    init(navigationController: BaseNavController = .init()) {
        self.navigationController = navigationController
    }
    
    open  func start() {
        fatalError("Start method should be implemented.")
    }
    
    public    func start(coordinator: Coordinator) {
        childCoordinators += [coordinator]
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    open func removeChildCoordinators() {
        childCoordinators.forEach { $0.removeChildCoordinators() }
        childCoordinators.removeAll()
    }
    
    public  func didFinish(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}

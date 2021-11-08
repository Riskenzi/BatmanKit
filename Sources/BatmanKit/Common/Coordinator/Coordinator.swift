//
//  File.swift
//  
//
//  Created by   Валерий Мельников on 29.10.2021.
//

import Foundation
import UIKit

open protocol Coordinator: AnyObject {
  public  var rootViewController: UIViewController { get }
    public  var parentCoordinator: Coordinator? { get set }
    
    public  func start()
    public  func start(coordinator: Coordinator)
    public  func didFinish(coordinator: Coordinator)
    public  func removeChildCoordinators()
}

//
//  Navigatable.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 18/05/2022.
//

import Foundation
import UIKit

protocol Navigatable {
    var viewController: UIViewController? { get }
    func beginIgnoringEvent()
    func endIgnoringEvent()
    func push(to viewController: UIViewController, animated: Bool)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func pop(to viewController: UIViewController, animated: Bool)
    func pop()
    func popToRoot(animated: Bool)
    func dissmissViewController(animated flag: Bool, completion: (() -> Void)?)
    func disableSwipePopViewController()
    func enableSwipePopViewController()
    func hideNavigationBar(animated: Bool)
    func showNavigationBar(animated: Bool)
    func hideBackgroundNavigationBar()
}

// MARK: - Default implement
extension Navigatable {
    public func beginIgnoringEvent() {
        if Thread.isMainThread {
            self.viewController?.view.isUserInteractionEnabled = false
        } else {
            DispatchQueue.main.async {
                self.viewController?.view.isUserInteractionEnabled = false
            }
        }
    }
    public func endIgnoringEvent() {
        DispatchQueue.main.async {
            self.viewController?.view.isUserInteractionEnabled = true
        }
    }
}

// MARK: - Default implement
extension Navigatable {
    func push(to viewController: UIViewController, animated: Bool = true) {
        self.viewController?.navigationController?.pushViewController(viewController, animated: animated)
    }
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.viewController?.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    func pop(to viewController: UIViewController, animated: Bool = true) {
        self.viewController?.navigationController?.popToViewController(viewController, animated: animated)
    }
    func pop() {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
    func popToRoot(animated: Bool = true) {
        self.viewController?.navigationController?.popToRootViewController(animated: animated)
    }
    func dissmissViewController(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        self.viewController?.dismiss(animated: flag, completion: completion)
    }
    func disableSwipePopViewController() {
        self.viewController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    func enableSwipePopViewController() {
        self.viewController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    func hideNavigationBar(animated: Bool) {
        self.viewController?.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    func showNavigationBar(animated: Bool) {
        self.viewController?.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func hideBackgroundNavigationBar() {
        self.viewController?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.viewController?.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

extension Navigatable where Self:UIViewController {
    var viewController : UIViewController? {
        return self
    }
}

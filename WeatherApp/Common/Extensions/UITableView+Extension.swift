//
//  UITableView+Extension.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 19/05/2022.
//

import Foundation
import UIKit

extension UITableView {
    func registerNib<T: UITableViewCell>(aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forCellReuseIdentifier: name)
    }
    
    func registerClass<T: UITableViewCell>(aClass: T.Type) {
        let name = String(describing: aClass)
        register(aClass, forCellReuseIdentifier: name)
    }
    
    func registerNib<T: UITableViewHeaderFooterView>(aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: name)
    }
    
    func registerClass<T: UITableViewHeaderFooterView>(aClass: T.Type) {
        let name = String(describing: aClass)
        register(aClass, forHeaderFooterViewReuseIdentifier: name)
    }
    
    func dequeue<T: UITableViewCell>(aClass: T.Type) -> T {
        let name = String(describing: aClass)
        return dequeueReusableCell(withIdentifier: name) as! T
    }
    
    func dequeue<T: UITableViewHeaderFooterView>(aClass: T.Type) -> T {
        let name = String(describing: aClass)
        return dequeueReusableHeaderFooterView(withIdentifier: name) as! T
    }
    
    @objc func registerPullToRefresh(_ target: Any?, action: Selector) {
        let refresh = UIRefreshControl()
        refresh.addTarget(target, action: action, for: .valueChanged)
        refreshControl = refresh
    }
    
    @objc func endRefreshing() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc func beginRefresh() {
        DispatchQueue.main.async {
            self.refreshControl?.beginRefreshing()
        }
    }
}

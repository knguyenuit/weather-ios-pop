//
//  BaseVC.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 18/05/2022.
//

import Foundation
import UIKit

private var countLoading = 0

class BaseVC: UIViewController {
    deinit {
        debugPrint("Deinit:", self.className)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundGradient()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setBackgroundGradient() {
        self.view.setGradientBackground(startColor: .blue8F6,
                                        endColor: .blue9C1, .vertical)
    }
    
    private func setColorTitle() {
        navigationController?.navigationBar.tintColor = .white
    }
    
    func addBackButton() {
        let button1 = UIBarButtonItem(image: UIImage(named: "ic_back")?.withRenderingMode(.alwaysOriginal),
                       style: .done,
                       target: self,
                       action: #selector(backToViewController))
        navigationItem.leftBarButtonItems = [button1]
    }
    
    @objc func backToViewController() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Loading
extension BaseVC {
    private class LoadingView: UIView {}
    
    func showLoading(text: String? = nil) {
        guard countLoading == 0 else { countLoading += 1; return }
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.showLoading(text: text)
            }
            return
        }
        countLoading += 1
        guard let keyWindown = UIApplication.shared.keyWindow else { return }
        let superView = LoadingView()
        keyWindown.addSubview(superView)
        superView.backgroundColor = .clear
        superView.frame = keyWindown.bounds
        
        let contentView = UIView()
        superView.addSubview(contentView)
        contentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        contentView.layer.cornerRadius = 12
        contentView.frame = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        contentView.center = keyWindown.center
        
        let stackView = UIStackView()
        superView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
        
        let indicatorView = UIActivityIndicatorView()
        stackView.addArrangedSubview(indicatorView)
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .whiteLarge
        indicatorView.color = .white
        indicatorView.startAnimating()
        
        let label = UILabel()
        stackView.addArrangedSubview(label)
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.text = text
    }
    
    func updateLoading(text: String) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.updateLoading(text: text)
            }
            return
        }
        guard let keyWindown = UIApplication.shared.keyWindow else { return }
        let loadingView = keyWindown.subviews.first(where: { $0 is LoadingView })
        let stack = loadingView?.subviews.first(where: { $0 is UIStackView })
        let label = stack?.subviews.first(where: { $0 is UILabel }) as? UILabel
        label?.text = text
    }
    
    func hideLoading(forceHide: Bool = false) {
        if forceHide { countLoading = 1 }
        guard countLoading <= 1 else { countLoading -= 1; return }
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.hideLoading()
            }
            return
        }
        countLoading -= 1
        guard let keyWindown = UIApplication.shared.keyWindow else {
            fatalError("window is nil")
        }
        for v in keyWindown.subviews where v is LoadingView {
            UIView.animate(withDuration: 0.3, animations: {
                v.alpha = 0
            }, completion: { (_) in
                v.removeFromSuperview()
            })
        }
    }
}

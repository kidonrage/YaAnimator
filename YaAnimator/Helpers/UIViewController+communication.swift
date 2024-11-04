//
//  UIViewController+communication.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 04.11.2024.
//

import UIKit

extension UIViewController {
    
    func showMessageWithOk(title: String?, message: String?) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(errorAlert, animated: true)
    }
    
    func showSpinnerView() -> SpinnerViewController {
        let child = SpinnerViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        return child
    }
}

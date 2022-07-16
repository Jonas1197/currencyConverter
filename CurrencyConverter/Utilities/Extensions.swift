//
//  Extensions.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 08/07/2022.
//

import UIKit

//MARK: - UIView
extension UIView {
    static func animateOnMain(withDuration duration: TimeInterval, delay: TimeInterval = 0, options: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseInOut], _ animations: @escaping () -> Void, didFinish: ((Bool) -> Void)? = nil) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: didFinish)
        }
    }
}

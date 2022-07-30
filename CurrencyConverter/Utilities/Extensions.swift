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


//MARK: - UIDevice
extension UIDevice {
    static func forceOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
    
    /**
     Force the device into portrait mode.
     */
    static func forcePortrait() {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    /**
     Force the device into landscpae mode.
     */
    static func forceLandscape() {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
}

//MARK: - String
extension String {
    func localized(_ lang: String = Locale.current.languageCode ?? "en") ->String {
        let path   = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

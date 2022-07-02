//
//  InputView.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 02/07/2022.
//

import UIKit

class InputView: UIView {

    
    class func instantiateFromNib() -> InputView {
        return UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! InputView
    }
    
    func configure() {
        
    }

}

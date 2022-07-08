//
//  PinView.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 08/07/2022.
//

import UIKit

final class PinView: UIView {

    class func instantiateFromXib() -> PinView {
        UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PinView
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(to: .rounded)
    }
    
    func configure() {
        bordered(width: 2, color: Constants.Colors.deepBlue)
            .shadowed(with: .black, offset: .init(width: 0, height: 2), radius: 12, 0.7)
    }

}

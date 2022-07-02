//
//  QuickGlanceView.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 02/07/2022.
//

import UIKit


final class QuickGlanceView: UIView {
    
    private var manager: QuickGlanceViewManager!

    class func instantiateFromNib() -> QuickGlanceView {
        UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! QuickGlanceView
    }
    
    private var collectionView: UICollectionView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    
    func configure() {
        manager = .init()
        configureCollectionView()
        subscribeToManager()
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 22
        collectionView = .init(frame: frame, collectionViewLayout: layout)
        collectionView.register(.init(nibName: String(describing: QuickGlanceViewCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: Constants.Identifier.quickGlanceCell)
        collectionView.delegate        = manager
        collectionView.dataSource      = manager
        collectionView.backgroundColor = .clear
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.filled(in: self)
    }
    
    private func subscribeToManager() {
        manager.subscribe(to: manager.$presentNoDataLabel) { [weak self] presents in
            guard let self = self else { return }
            
            if let presents = presents {
                self.noDataLabel.translucent(presents ? 0.4 : 0)
            } else {
                self.noDataLabel.invisible()
            }
            
        }
    }
}



//
//  QuickGlanceViewManager.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 02/07/2022.
//

import UIKit
import Combine

final class QuickGlanceViewManager: NSObject, Subscribable, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var cancellable: [AnyCancellable] = []
    
    @Published var reloadsCollectionView: Bool?
    @Published var presentNoDataLabel: Bool?
    
    var models: [QuickGlanceViewCollectionViewCellModel] = [
        .example, .example, .example
    ] { didSet {
        presentNoDataLabel = models.isEmpty
    }}
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifier.quickGlanceCell, for: indexPath) as? QuickGlanceViewCollectionViewCell else { return .init() }
        cell.model = models[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let superview = collectionView.superview {
            return .init(width: superview.frame.width / 1.2, height: superview.frame.height / 8)
        } else {
            return .init(width: 350, height: 60)
        }
    }
}

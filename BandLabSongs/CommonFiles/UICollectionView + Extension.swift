//
//  UICollectionView + Extension.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 21.03.2022.
//

import Foundation
import UIKit

extension UICollectionView {
    func register(classes: [UICollectionViewCell.Type]) {
        for model in classes {
            let identifier = String(describing: model.self)
            self.register(model, forCellWithReuseIdentifier: identifier)
        }
    }
}
extension UICollectionViewCell {
    static var identifire: String {
        String(describing: self)
    }
}

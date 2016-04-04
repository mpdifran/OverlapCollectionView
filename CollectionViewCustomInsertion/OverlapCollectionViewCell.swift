//
//  OverlapCollectionViewCell.swift
//  CollectionViewCustomInsertion
//
//  Created by Mark DiFranco on 2016-04-03.
//  Copyright © 2016 mdfprojects. All rights reserved.
//

import UIKit

class OverlapCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        layer.cornerRadius = 15
        layer.borderWidth = 3
        layer.borderColor = UIColor.blackColor().CGColor
    }
}

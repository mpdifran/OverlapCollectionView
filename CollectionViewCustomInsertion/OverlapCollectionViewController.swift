//
//  OverlapCollectionViewController.swift
//  CollectionViewCustomInsertion
//
//  Created by Mark DiFranco on 2016-04-03.
//  Copyright © 2016 mdfprojects. All rights reserved.
//

import UIKit

private let reuseIdentifier = "OverlapCollectionViewCell"

class OverlapCollectionViewController: UICollectionViewController {

    private var numberOfItems = 10

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    }
    @IBAction func didTapAdd(sender: AnyObject) {
        numberOfItems += 1
        let insertionIndex = Int(arc4random() % UInt32(max(numberOfItems, 1)))
        collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: insertionIndex, inSection: 0)])
    }

    @IBAction func didTapRemove(sender: AnyObject) {
        guard numberOfItems > 0 else { return }

        numberOfItems -= 1
        let removalIndex = Int(arc4random() % UInt32(max(numberOfItems, 1)))
        collectionView?.deleteItemsAtIndexPaths([NSIndexPath(forItem: removalIndex, inSection: 0)])
    }
}

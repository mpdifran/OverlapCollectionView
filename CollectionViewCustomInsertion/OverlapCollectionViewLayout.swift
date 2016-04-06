//
//  OverlapCollectionViewLayout.swift
//  CollectionViewCustomInsertion
//
//  Created by Mark DiFranco on 2016-04-03.
//  Copyright © 2016 mdfprojects. All rights reserved.
//

import UIKit

class OverlapCollectionViewLayout: UICollectionViewLayout {

    var preferredSize = CGSizeMake(200, 200)

    private let centerDiff: CGFloat = 40
    private var numberOfItems = 0

    private var updateItems = [UICollectionViewUpdateItem]()

    override func prepareLayout() {
        super.prepareLayout()
        numberOfItems = collectionView?.numberOfItemsInSection(0) ?? 0
    }

    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        self.updateItems = updateItems
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    override func collectionViewContentSize() -> CGSize {
        if let collectionView = collectionView {
            let width = max(collectionView.bounds.width + 1, preferredSize.width + CGFloat((numberOfItems - 1)) * centerDiff)
            let height = collectionView.bounds.height - 1

            return CGSizeMake(width, height)
        }
        return CGSizeZero
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var allAttributes = [UICollectionViewLayoutAttributes]()
        for index in 0 ..< numberOfItems {
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            allAttributes.append(layoutAttributesForItemAtIndexPath(indexPath)!)
        }
        return allAttributes
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)

        attributes.size = preferredSize
        let centerX = preferredSize.width / 2.0 + CGFloat(indexPath.item) * centerDiff
        let centerY = collectionView!.bounds.height / 2.0
        attributes.center = CGPointMake(centerX, centerY)
        attributes.zIndex = indexPath.item

        return attributes
    }

    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = layoutAttributesForItemAtIndexPath(itemIndexPath)

        for updateItem in updateItems {
            switch updateItem.updateAction {
            case .Insert:
                if updateItem.indexPathAfterUpdate == itemIndexPath {
                    let translation = collectionView!.bounds.height
                    attributes?.transform = CGAffineTransformMakeTranslation(0, translation)
                    break
                }
            default:
                break
            }
        }

        return attributes
    }

    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        for updateItem in updateItems {
            switch updateItem.updateAction {
            case .Delete:
                if updateItem.indexPathBeforeUpdate == itemIndexPath {
                    let attributes = layoutAttributesForItemAtIndexPath(itemIndexPath)
                    let translation = collectionView!.bounds.height
                    attributes?.transform = CGAffineTransformMakeTranslation(0, translation)
                    return attributes
                }
            case .Move:
                if updateItem.indexPathBeforeUpdate == itemIndexPath {
                    return layoutAttributesForItemAtIndexPath(updateItem.indexPathAfterUpdate!)
                }
            default:
                break
            }
        }
        let finalIndex = finalIndexForIndexPath(itemIndexPath)
        let shiftedIndexPath = NSIndexPath(forItem: finalIndex, inSection: itemIndexPath.section)

        return layoutAttributesForItemAtIndexPath(shiftedIndexPath)
    }

    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        updateItems.removeAll(keepCapacity: true)
    }

    private func finalIndexForIndexPath(indexPath: NSIndexPath) -> Int {
        var newIndex = indexPath.item
        for updateItem in updateItems {
            switch updateItem.updateAction {
            case .Insert:
                if updateItem.indexPathAfterUpdate!.item <= newIndex {
                    newIndex += 1
                }
            case .Delete:
                if updateItem.indexPathBeforeUpdate!.item < newIndex {
                    newIndex -= 1
                }
            case .Move:
                if updateItem.indexPathBeforeUpdate!.item < newIndex {
                    newIndex -= 1
                }
                if updateItem.indexPathAfterUpdate!.item <= newIndex {
                    newIndex += 1
                }
            default:
                break
            }
        }
        return newIndex
    }
}

//
//  MulltiScrollCollectionView.swift
//  MultiScrollContainer
//
//  Created by iWw on 2021/1/13.
//

import UIKit

open class MultiScrollCollectionView: UICollectionView, MultiScrollStateful {
    
    public var scrollState: ScrollState = .pending
    public var lastContentOffset: CGPoint = .zero
    
}

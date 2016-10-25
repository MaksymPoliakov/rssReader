//
//  EntryCell.swift
//  rssReader
//
//  Created by Maksym Poliakov on 23.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import UIKit

class EntryCell: BaseCell {


    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let contentSnippetTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let urlView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()

    override func setupViews() {
        
        addSubview(titleLabel)
        addSubview(contentSnippetTextView)
        addSubview(urlView)
        addSubview(dividerView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: titleLabel)
        addConstraintsWithFormat(format: "H:|-3-[v0]-3-|", views: contentSnippetTextView)
        addConstraintsWithFormat(format: "H:|-8-[v0]|", views: dividerView)
        
        addConstraintsWithFormat(format: "V:|-8-[v0(20)]-8-[v1]-2-[v2][v3(1)]|", views: titleLabel, contentSnippetTextView, urlView, dividerView)

    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let attributes = layoutAttributes.copy() as? UICollectionViewLayoutAttributes
        let desiredHeight = systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        
        attributes?.frame.size.height = desiredHeight
        
        return attributes!
    }

    
}

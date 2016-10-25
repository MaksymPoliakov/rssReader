//
//  BaseCell.swift
//  rssReader
//
//  Created by Maksym Poliakov on 23.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import UIKit


class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}

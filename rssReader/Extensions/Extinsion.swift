//
//  UIViewExtinsion.swift
//  rssReader
//
//  Created by Maksym Poliakov on 23.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension String {
    
    func contains(string: String) -> Bool{
        return self.range(of: string, options: NSString.CompareOptions.caseInsensitive) != nil
    }
    
}

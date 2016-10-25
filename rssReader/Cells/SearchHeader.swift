//
//  SearchHeader.swift
//  rssReader
//
//  Created by Maksym Poliakov on 23.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import UIKit

class SearchHeader: BaseCell, UITextFieldDelegate {

    var searchFeedController: SearchFeedController?
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search for RSS Feeds"
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        searchButton.addTarget(self, action: #selector(SearchHeader.search), for: .touchUpInside)
        searchTextField.delegate = self
        
        addSubview(searchTextField)
        addSubview(dividerView)
        addSubview(searchButton)
        
        addConstraintsWithFormat(format: "H:|-8-[v0][v1(80)]|", views: searchTextField, searchButton)
        addConstraintsWithFormat(format: "H:|[v0]|", views: dividerView)
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: searchButton)
        addConstraintsWithFormat(format: "V:|[v0][v1(0.5)]|", views: searchTextField, dividerView)
    }
    
    func search() {
        searchFeedController?.performSearch(text: searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchFeedController?.performSearch(text: searchTextField.text!)
        return true
    }
    
}

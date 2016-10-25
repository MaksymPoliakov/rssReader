//
//  MainVC.swift
//  rssReader
//
//  Created by Maksym Poliakov on 23.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import Realm
import RealmSwift
import UIKit


private let entryCellId = "entryCellId"
private let headerId = "headerId"

class SearchFeedController: UICollectionViewController, SideBarDelegate {
    
    var entries: [Entry]?
    var sideBar: SideBar?
    var savedFeeds: Results<Feed>?
    var feedNames: [String]?
    
    override func viewDidLoad() {
        
        navigationItem.title = "RSS Reader"
        
        collectionView?.register(SearchHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(EntryCell.self, forCellWithReuseIdentifier: entryCellId)

        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        
        guard let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.estimatedItemSize = CGSize(width: view.frame.width, height: 100)
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
        layout.minimumLineSpacing = 0
        
        setupSideBar()
    }
    
    func setupSideBar() {
        loadSavedFeeds()
        sideBar = SideBar(sourceView: navigationController!.view, delegate: self, menuItems: feedNames!)
    }
    
    func loadSavedFeeds() {
        feedNames = [String]()
        feedNames = ["Add feed"]
        
        savedFeeds = realm.objects(Feed.self)
        savedFeeds?.forEach({ (feed) in
            feedNames?.append(feed.name)
        })
    }
    
    func updateSideBarUI() {
        loadSavedFeeds()
        sideBar?.sideBarController.tableData = feedNames
        sideBar?.sideBarController.tableView.reloadData()
    }
    
    func sideBarDidSelectMenuButtonAtIndex(index: Int) {
        if index == 0 {
            let alert = UIAlertController(title: "Add new feed", message: "Enter feed name and URL", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Feed name"
            })
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Feed URL"
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alertAction) in
                
                let textFields = alert.textFields
                
                let feedNameTextField = textFields?.first
                let feedURLTextField = textFields?.last
                
                if feedNameTextField?.text != "" && feedURLTextField?.text != "" {
                    
                    let feed = Feed()
                    feed.name = feedNameTextField!.text!
                    feed.url = feedURLTextField!.text!
                    
                    try! realm.write { () -> Void in
                        realm.add(feed)
                    }
                    self.updateSideBarUI()
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let selectedFeed = realm.objects(Feed.self).filter("name = '\(feedNames![index])'")
            let urlString = selectedFeed.first!.url
            let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            
            
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                do {
                    let json = try(JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())) as! NSDictionary

                    if let articles = json["articles"] as? [NSDictionary] {
                        self.entries = [Entry]()
                        
                        for article in articles {
                            let title = article["title"] as? String
                            let contentSnippet = article["description"] as? String
                            let url = article["url"] as? String
                            
                            let entry = Entry(title: title, contentSnippet: contentSnippet, url: url)
                            self.entries?.append(entry)
                        }
                        
                        DispatchQueue.main.async(execute: { 
                            self.collectionView?.reloadData()
                        })
                    }
                } catch let error {
                    print(error)
                }

            }.resume()
        }
    }

    func performSearch(text: String) {

        let urlString = "https://newsapi.org/v1/sources?language=en"
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                let json = try(JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())) as! NSDictionary
                
                if let sources = json["sources"] as? [NSDictionary] {
                    self.entries = [Entry]()
                    
                    for source in sources {
                        let title = source["name"] as? String
                        let contentSnippet = source["description"] as? String
                        let url = source["url"] as? String
                        
                        if title!.contains(string: text) || contentSnippet!.contains(string: text) {
                            let entry = Entry(title: title, contentSnippet: contentSnippet, url: url)
                            self.entries?.append(entry)
                        }
                    }
                    
                    DispatchQueue.main.async(execute: {
                        if self.entries!.count > 0 {
                                self.collectionView?.reloadData()
                        } else {
                            let alert = UIAlertController(title: "Error", message: "Enter valid feed name", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = entries?.count else {
            return 0
        }
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let entryCell = collectionView.dequeueReusableCell(withReuseIdentifier: entryCellId, for: indexPath) as! EntryCell
        
        let entry = entries?[indexPath.item]
        
        let titleData = entry?.title?.data(using: String.Encoding.unicode)
        let contentSnippetData = entry?.contentSnippet?.data(using: String.Encoding.unicode)
        let urlString = entry?.url
        
        let options = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        
        do {
            let titleHtmlText = try(NSMutableAttributedString(data: titleData!, options: options, documentAttributes: nil))
            let range = NSRange(location: 0, length: titleHtmlText.length)
            titleHtmlText.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 14), range: range)
            entryCell.titleLabel.attributedText = titleHtmlText
            
            let contentSnippetHtmlText = try(NSAttributedString(data: contentSnippetData!, options: options, documentAttributes: nil))
            entryCell.contentSnippetTextView.attributedText = contentSnippetHtmlText
            
        } catch let error {
            print(error)
        }
        entryCell.urlView.text = urlString
        
        return entryCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SearchHeader
        header.searchFeedController = self
        
     return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let webBrowser = WebBrowser()

        let entry = entries![indexPath.item] as Entry
        webBrowser.urlString = entry.url

        self.navigationController?.pushViewController(webBrowser, animated: true)
    }
    
}

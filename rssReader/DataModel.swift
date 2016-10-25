//
//  Feed.swift
//  rssReader
//
//  Created by Maksym Poliakov on 24.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//


import Foundation
import RealmSwift


class Feed: Object {
    
    dynamic var name = ""
    dynamic var url = ""
}

class FeedList: Object {
    
    let feeds = List<Feed>()
}

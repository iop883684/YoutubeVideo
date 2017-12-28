//
//  PlayList.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 12/27/17.
//  Copyright © 2017 Lac Tuan. All rights reserved.
//

import Foundation
import ObjectMapper

class PlayList: Mappable {
    
    var title = ""
    var thumbnails = ""
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        title <- map["snippet.title"]
        thumbnails <- map["snippet.thumbnails.medium.url"]

    }
}

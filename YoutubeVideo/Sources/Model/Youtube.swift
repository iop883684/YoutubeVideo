//
//  Youtube.swift
//  SongProcessor
//
//  Created by Dustin Doan on 11/10/17.
//  Copyright © 2017 AudioKit. All rights reserved.
//

import ObjectMapper

class Youtube: Mappable {
    
    var videoId = ""
    var publishedAt = ""
    var channelId = ""
    var channelTitle = ""
    var title = ""
    var description = ""
    
    var thumbDefault:String?
    var thumbMedium:String?
    var thumbHigh:String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        videoId <- map["id.videoId"]
        publishedAt <- map["snippet.publishedAt"]
        channelId <- map["snippet.channelId"]
        channelTitle <- map["snippet.channelTitle"]
        title <- map["snippet.title"]
        description <- map["snippet.description"]
        
        thumbDefault <- map["snippet.thumbnails.default.url"]
        thumbMedium <- map["snippet.thumbnails.medium.url"]
        thumbHigh <- map["snippet.thumbnails.high.url"]

        
    }
    
}

class ResponseYoutube: Mappable {
    
    var code:Int?
    var message:String?
    var items:[Youtube]?
    var nextToken:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        code <- map["error.code"]
        message <- map["error.message"]
        nextToken <- map["nextPageToken"]
        items <- map["items"]
        
    }
    
}

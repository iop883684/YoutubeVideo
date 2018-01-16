//
//  YNSearch.swift
//  YNSearch
//
//  Created by YiSeungyoun on 2017. 4. 11..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import Foundation

open class HistorySearch: NSObject {
    var pref: UserDefaults!
    
    open static let shared: HistorySearch = HistorySearch()
    
    public override init() {
        pref = UserDefaults.standard
    }
    
    open func clearData(){
        
        pref.set(nil, forKey: "histories")
        
    }
    
    open func setSearchHistories(value: [String]) {
        pref.set(value, forKey: "histories")
    }
    
    open func deleteSearchHistories(index: Int) {
        guard var histories = pref.object(forKey: "histories") as? [String] else { return }
        histories.remove(at: index)
        
        pref.set(histories, forKey: "histories")
    }
    
    open func appendSearchHistories(value: String) {
        var histories = [String]()
        if let _histories = pref.object(forKey: "histories") as? [String] {
            histories = _histories
        }
        histories.append(value)
        
        pref.set(histories, forKey: "histories")
    }
    
    open func getSearchHistories() -> [String]? {
        guard let histories = pref.object(forKey: "histories") as? [String] else { return nil }
        return histories
    }
    
    
}


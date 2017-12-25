//
//  TableView + Ext.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 12/25/17.
//  Copyright © 2017 Lac Tuan. All rights reserved.
//

//MARK: - Quick Register nib

import UIKit

extension UITableView{
    
    func registerNib(_ nibClass: AnyClass,_ identifier: String){
        let nib = UINib.init(nibName: String(describing: nibClass.self), bundle: nil)
        
        self.register(nib, forCellReuseIdentifier: identifier)
    }
}

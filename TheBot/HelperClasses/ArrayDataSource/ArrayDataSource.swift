//
//  ArrayDataSource.swift
//  MultiPurposeAppSwift
//
//  Created by Daman on 01/12/16.
//  Copyright © 2016 Bison. All rights reserved.
//

import Foundation
import UIKit

typealias TableViewCellConfigureBlock = (_ cell:UITableViewCell, _ item:AnyObject) -> Void
typealias TableViewRowConfigureBlock = (_ indexPath:IndexPath) -> UITableViewCell
typealias TableViewEditRowBlock = (_ editingStyle:UITableViewCellEditingStyle, _ indexPath:IndexPath) -> Void
typealias TableLoadingBlock = (Void) -> Void

class ArrayDataSource: NSObject, UITableViewDataSource{
    var tableView:UITableView!
    var sectionsArray:[String]?
    var items:NSMutableArray?
    var cellIdentifier:String
    var configureCellBlock:TableViewCellConfigureBlock?
    var configureRowBlock:TableViewRowConfigureBlock?
    var tableLoadingBlock:TableLoadingBlock?
    var editRowBlock:TableViewEditRowBlock?

    init(items:NSArray?, tableView:UITableView, cellIdentifier:String, configureCellBlock:TableViewCellConfigureBlock?) {
        if items != nil {
            self.items = NSMutableArray.init(array: items!)
        }
        self.tableView = tableView
        self.cellIdentifier = cellIdentifier
        self.configureCellBlock = configureCellBlock
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.sectionsArray != nil{
            return sectionsArray!.count 
        }
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableLoadingBlock?()
        if self.sectionsArray != nil{
            return (self.items?[section] as? NSArray)?.count ?? 0
        }
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.configureRowBlock != nil {
            return self.configureRowBlock!(indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier)
        let item = self.items![indexPath.row];
        cell!.tag = indexPath.row;
        self.configureCellBlock?(cell!, item as AnyObject);
        return cell!
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (self.editRowBlock != nil) {
            self.editRowBlock?(editingStyle, indexPath);
        }
    }
}

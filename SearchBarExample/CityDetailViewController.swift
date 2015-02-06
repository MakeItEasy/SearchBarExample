//
//  CityDetailViewController.swift
//  SearchBarExample
//
//  Created by moyan on 15-2-6.
//  Copyright (c) 2015年 moyan. All rights reserved.
//

import UIKit

class CityDetailViewController: UITableViewController {
    
    var city : City!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.city.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        var str = ""
        switch(indexPath.row) {
        case 0:
            str = city.name
        case 1:
            str = city.spelling
        case 2:
            str = city.desc
        default:
            str = ""
        }
        cell.detailTextLabel?.text = str
        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

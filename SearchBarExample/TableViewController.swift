//
//  TableViewController.swift
//  SearchBarExample
//
//  Created by moyan on 15-2-5.
//  Copyright (c) 2015年 moyan. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchDisplayDelegate {
    
    var fetchedResultController : NSFetchedResultsController!
    
    var fetchRequest : NSFetchRequest!
    
    var filterResult : [AnyObject]?
    
    lazy var managedObjectContext : NSManagedObjectContext?  = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else {
            return nil
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initFrc()
        initSearchFetchRequest()
        initSectionIndexAreaColors()
        
        self.searchDisplayController?.searchResultsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CityCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.tableView == tableView {
            return self.fetchedResultController.sections!.count
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if self.tableView == tableView {
            return self.fetchedResultController.sections![section].numberOfObjects
        } else {
            return self.filterResult?.count ?? 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 方案1:如果查询结果只有一条，不会出错，如果查询结果有>1条,异常,原因可能是本身self.tableView中没有［section:0, row: 1］的数据
        // Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'request for rect at invalid index path (<NSIndexPath: 0xc000000000008016> {length = 2, path = 0 - 1})'
        // let cell = self.tableView.dequeueReusableCellWithIdentifier("CityCell", forIndexPath: indexPath) as UITableViewCell
        // 方案2
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CityCell") as UITableViewCell
        // 方案3
        // let cell = self.tableView.dequeueReusableCellWithIdentifier("CityCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 2)) as UITableViewCell
        // 方案4:这样的话需要tableViewre.gisterClass(UITableViewCell.self, forCellReuseIdentifier: "CityCell")
        // let cell = tableView.dequeueReusableCellWithIdentifier("CityCell", forIndexPath: indexPath) as UITableViewCell
        var city : City
        if tableView == self.tableView {
            city = self.fetchedResultController.objectAtIndexPath(indexPath) as City
        } else {
            city = self.filterResult![indexPath.row] as City
        }
        cell.textLabel?.text = "\(city.name)(\(city.desc))"
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (tableView == self.tableView)
        {
            return self.fetchedResultController.sections![section].name
        }
        else
        {
            return nil;
        }
 
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        if (tableView == self.tableView) {
            var indexs : NSMutableArray = [UITableViewIndexSearch]
            indexs.addObjectsFromArray(self.fetchedResultController.sectionIndexTitles)
            return indexs
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if (tableView == self.tableView) {
            if (index > 0) {
                // The index is offset by one to allow for the extra search icon inserted at the front
                // of the index
                return self.fetchedResultController.sectionForSectionIndexTitle(title, atIndex: index-1)
            } else {
                // The first entry in the index is for the search icon so we return section not found
                // and force the table to scroll to the top.
                // 以下这行代码的定位不对，可能如果没有导航栏应该是对的
                // self.tableView.contentOffset = CGPointZero
                self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
                return NSNotFound;
            }
        } else {
            return 0;
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "GotoCityDetail" {
            var city : City
            if self.searchDisplayController!.active {
                var dc = self.searchDisplayController
                var indexPath = dc!.searchResultsTableView.indexPathForCell(sender as UITableViewCell)
                city = self.filterResult![indexPath!.row] as City
            } else {
                var indexPath = self.tableView.indexPathForCell(sender as UITableViewCell)
                city = self.fetchedResultController.objectAtIndexPath(indexPath!) as City
            }
            let controller = segue.destinationViewController as CityDetailViewController
            controller.city = city
        }
    }
    
    
    // ================================================================================================
    // MARK: - FetchedResultController Delegate
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    
    // ================================================================================================
    // MARK: - Search Display Controller Delegate

    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.searchForText(searchString, scope: controller.searchBar.selectedScopeButtonIndex)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.searchForText(controller.searchBar.text, scope: searchOption)
        return true
    }
    
    private func searchForText(text: String, scope: Int) {
        if (self.managedObjectContext != nil)
        {
            var searchAttribute = "spelling"
            var predicateFormat = "%K BEGINSWITH[cd] %@"
            
            if (scope == 1) {
                searchAttribute = "desc";
            }
            let predicate = NSPredicate(format: predicateFormat, searchAttribute, text)
            self.fetchRequest.predicate = predicate
            
            let error = NSErrorPointer()
            self.filterResult = self.managedObjectContext!.executeFetchRequest(self.fetchRequest, error: error)
            // TODO dairg Error handler
            /*
            if (error)
            {
                NSLog(@"searchFetchRequest failed: %@",[error localizedDescription]);
            }
            */
        }

    }
    
    // ================================================================================================
    // MARK: - Private Method
    private func initFrc() {
        if self.fetchedResultController == nil {
            let request = NSFetchRequest(entityName: "City")
            request.sortDescriptors = [NSSortDescriptor(key: "spelling", ascending: true)]
            self.fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: "sectionTitle", cacheName: nil)
            self.fetchedResultController.delegate = self
            var error : NSErrorPointer = nil
            self.fetchedResultController.performFetch(error)
            if error != nil
            {
                NSLog("Unresolved error %@", error.debugDescription);
            }

        }
    }
    
    private func initSearchFetchRequest() {
        if self.fetchRequest == nil {
            self.fetchRequest = NSFetchRequest(entityName: "City")
            self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "spelling", ascending: true)]
        }
    }
    
    private func initSectionIndexAreaColors() {
        // 正常的BackgroundColor（没有被按下的时候）
        // 透明色
        self.tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        // 被按下的时候的背景色
        self.tableView.sectionIndexTrackingBackgroundColor = UIColor.redColor()
        // 字体颜色
        self.tableView.sectionIndexColor = UIColor.blueColor()
    }

}

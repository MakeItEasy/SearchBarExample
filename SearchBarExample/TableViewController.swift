//
//  TableViewController.swift
//  SearchBarExample
//
//  Created by moyan on 15-2-5.
//  Copyright (c) 2015年 moyan. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var fetchedResultController : NSFetchedResultsController!
    
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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            // TODO dairg
            return 1
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CityCell", forIndexPath: indexPath) as UITableViewCell
        let city = self.fetchedResultController.objectAtIndexPath(indexPath) as City
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.name
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
        if (tableView == self.tableView)
        {
            if (index > 0)
            {
                // The index is offset by one to allow for the extra search icon inserted at the front
                // of the index
                return self.fetchedResultController.sectionForSectionIndexTitle(title, atIndex: index-1)
            }
            else
            {
                // The first entry in the index is for the search icon so we return section not found
                // and force the table to scroll to the top.
                // TODO dairg 确认搜索定位对不对
                self.tableView.contentOffset = CGPointZero;
                return NSNotFound;
            }
        }
        else
        {
            return 0;
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    // ================================================================================================
    // MARK: - Private Method
    private func initFrc() {
        if self.fetchedResultController == nil {
            let request = NSFetchRequest(entityName: "City")
            request.sortDescriptors = [NSSortDescriptor(key: "spelling", ascending: true)]
            self.fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: "sectionTitle", cacheName: nil)
            
            var error : NSErrorPointer = nil
            self.fetchedResultController.performFetch(error)
            if error != nil
            {
                NSLog("Unresolved error %@", error.debugDescription);
            }

        }
    }

}

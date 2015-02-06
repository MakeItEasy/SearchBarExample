### 概要说明

这里是关于IOS中使用SearchBar的例子。

### 使用到的技术点

* 原生CoreData
* plist文件的读取
* NSFetchedResultController结合TableView的使用
* TableView中右边添加了IndexSection
* SearchBar的实现
* 设置了tableView的sectionIndex区域的各种颜色

### 做Example时参考链接
* 如果想调整sectionIndexs之间的间距: http://stackoverflow.com/questions/23453112/add-padding-or-increase-height-between-section-index-titles-in-uitableview
* [Adding a Search Bar to a Table View With Storyboards](http://useyourloaf.com/blog/2012/09/06/search-bar-table-view-storyboard.html)
* [How to filter NSFetchedResultsController (CoreData) with UISearchDisplayController/UISearchBar](http://stackoverflow.com/questions/4471289/how-to-filter-nsfetchedresultscontroller-coredata-with-uisearchdisplaycontroll)


### 一些问题总结

#### 关于tableView(cellForRowAtIndexPath)

在这个例子中，其实是存在两个TableView，一个是显示数据的tableView(self.tableView)，另外一个是显示搜索结果的tableView(self.searchDisplayController?.searchResultsTableView)，由于这两个tableView的dataSource都是self，所以针对下面的代码总结一下：

```
override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // 方案1:如果查询结果只有一条，不会出错，如果查询结果有>1条,异常,原因可能是本身self.tableView中没有［section:0, row: 1］的数据
    // Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'request for rect at invalid index path (<NSIndexPath: 0xc000000000008016> {length = 2, path = 0 - 1})'
    // let cell = self.tableView.dequeueReusableCellWithIdentifier("CityCell", forIndexPath: indexPath) as UITableViewCell
    // 方案2: OK, 是一种hack的方式
    let cell = self.tableView.dequeueReusableCellWithIdentifier("CityCell") as UITableViewCell
    // 方案3: 不出异常，但是数据显示错位,NG
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
```

关于方案1－4，最好的方案应该是使用方案4。（方案4中直接是tableView，其他用的是self.tableView）
不过如果希望让搜索的结果cell和本身的cell一致的话，那么需要注册的cell和本身的cell一致，而且一些在attributes inspector中设置的属性，可能需要代码去在自定义cell的class中设置。

方案2是一种巧妙的方式来实现搜索结果cell和本身cell的一致效果，目前没有发现会有什么问题。


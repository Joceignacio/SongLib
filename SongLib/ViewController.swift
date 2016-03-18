import UIKit
import SugarRecord
import CoreData
import Foundation
import Alamofire
import SwiftyJSON

var listToAdd : [Song] = []
var indexToDel : [Int] = []

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, listContainer{
    
    @IBOutlet weak var noSongs: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    func getCollection() -> UICollectionView {
        return collectionView
    }
    
    var dataProvider : CoreDataProvider = CoreDataProvider.instance
    var refresher : UIRefreshControl!
    
    func refresh (){
        if noSongs.hidden ==  false {
            
            noSongs.hidden = true
            
            let jsonHelper: JSONHelper = JSONHelper()
            
            jsonHelper.lc = self
            
            _ = jsonHelper.getJSON()
            
            refresher.endRefreshing()
                    
        }
        else {
            
            let jsonHelper: JSONHelper = JSONHelper()
            
            jsonHelper.lc = self
            
            _ = jsonHelper.getJSON()
            
            refresher.endRefreshing()
            
            //_ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updater"), userInfo: nil, repeats: false)
            
        }
    }
        //Configurating CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return  dataProvider.entities.count
    }
    func collectionView (collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.labelSong.text = dataProvider.entities[indexPath.row].label
        cell.authorSong.text =  dataProvider.entities[indexPath.row].author
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.layer.borderWidth = 1
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if(dataProvider.entities.count == 0){
            noSongs.hidden = false
        }
        //let getJson = JSONHelper().getJSON()
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView?.addSubview(refresher)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
}

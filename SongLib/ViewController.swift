import UIKit
import SugarRecord
import CoreData
import Foundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, colection {
    
    @IBOutlet weak var noSongs: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    //implementing func of protocol 'collection' wich returns collectionView of ViewController
    func getCollection() -> UICollectionView {
        return collectionView
    }
    // Creating instance of data class
    var dataProvider : CoreDataProvider = CoreDataProvider.instance
    var refresher : UIRefreshControl!
    func refresh (){
        let jsonHelper: JSONHelper = JSONHelper()
        jsonHelper.cv = self
        if noSongs.hidden ==  false {
            noSongs.hidden = true
            _ = jsonHelper.getJSON()
            refresher.endRefreshing()
        }
        else {
            _ = jsonHelper.getJSON()
            refresher.endRefreshing()
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
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView?.addSubview(refresher)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
}
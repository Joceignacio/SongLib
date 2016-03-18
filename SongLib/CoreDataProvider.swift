import Foundation
import SugarRecord
import CoreData
import SwiftyJSON

class CoreDataProvider {
    static let instance : CoreDataProvider = CoreDataProvider()
    var entities: [Song] = []
    var db: CoreDataDefaultStorage
    
    private init() {
         db = {
            let store = CoreData.Store.Named("SongLib")
            let bundle = NSBundle(forClass: ViewController.classForCoder())
            let model = CoreData.ObjectModel.Merged([bundle])
            let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
            return defaultStorage
            }()
        updateData()
    }
    
    func updateData() {
        self.entities = try! db.fetch(Request<Songs>()).map(Song.init)
    }
    
    func insertRecs(list : [Song], myCollection : UICollectionView){
        for song in list {
            db.operation { (context, save) -> Void in
                let newTask: Songs = try! context.new()
                newTask.id = song.id
                newTask.author = song.author
                newTask.label = song.label
                try! context.insert(newTask)
                save()
            }
        }
        updateData()
        myCollection.reloadData()
    }
    
    func insertRecs( songs : [Song]){
        for song in songs {
            db.operation { (context, save) -> Void in
                let newTask: Songs = try! context.new()
                newTask.id = song.id
                newTask.author = song.author
                newTask.label = song.label
                try! context.insert(newTask)
                save()
            }
        }
       }
    
    func updateCore(newList : [Song], myCollection : UICollectionView){
        var listToAdd : [Song] = []
        for var i = 0; i < newList.count ; i++ {
            var isNew = true
            for song in entities {
                if(newList[i].id == song.id){
                    isNew = false
                }
            }
            if(isNew == true){
                listToAdd.append(newList[i])
            }
        }
        if listToAdd.count > 0{
            print("listToAdd.count = \(listToAdd.count)")
            
            var indexPaths: [NSIndexPath] = []
            for s in 0..<myCollection.numberOfSections() {
                for i in 0..<myCollection.numberOfItemsInSection(s) {
                    indexPaths.append(NSIndexPath(forItem: i, inSection: s))
                }
            }
            print("indexPaths.count = \(indexPaths.count)")
           
            insertRecs(listToAdd)
            
            for addItem in listToAdd {
                entities.append(addItem)
                var newIndexPath : [NSIndexPath] = []
                
                newIndexPath.append( NSIndexPath (forRow: indexPaths.count, inSection: 0))
                
                indexPaths.append( newIndexPath[0] )
                
                let indexPath : [NSIndexPath] = [indexPaths[indexPaths.count-1]]
                
                myCollection.insertItemsAtIndexPaths(indexPath)
            }
            listToAdd.removeAll()
            
        }
        var indexToDel : [Int] =  []
        for var i = 0; i < entities.count ; i++ {
            var isDeleted = true
            for newSong in newList{
                if(entities[i].id == newSong.id){
                    isDeleted = false
                }
            }
            if(isDeleted == true){
                indexToDel.append(i)
            }
        }
        
        if (indexToDel.count > 0){
            var indexPaths: [NSIndexPath] = []
            
            
            for s in 0..<myCollection .numberOfSections() {
                for i in 0..<myCollection.numberOfItemsInSection(s) {
                    indexPaths.append(NSIndexPath(forItem: i, inSection: s))
                }
            }
            
            var counter : Int = indexToDel.count-1
            while(counter >= 0 ){
                let del = indexToDel[counter]
                delRecs(entities[counter].id, lab: entities[del].label)
                entities.removeAtIndex(del)
                let delIndexPaths : [NSIndexPath] = [indexPaths[del]]
                indexPaths.removeAtIndex(del)
                myCollection.deleteItemsAtIndexPaths(delIndexPaths)
                counter--
            }
        indexToDel.removeAll()
        //myCollection.reloadData()
        }
        
    }

    func delRecs( id : Int32, lab : String){
        db.operation { (context, save) -> Void in
            let del: Songs? = try! context.request(Songs.self).filteredWith("id", equalTo: "\(id)").fetch().first
            if let del = del {
                try! context.remove([del])
                save()
            }
        }
        
    }
}

class Songs: NSManagedObject {
}

extension Songs {
    @NSManaged var id: Int32
    @NSManaged var author: String?
    @NSManaged var label: String?
}


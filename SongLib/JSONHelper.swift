import Foundation
import Alamofire
import SwiftyJSON

class JSONHelper {
    var dataProvider : CoreDataProvider = CoreDataProvider.instance
    internal var cv : colection? = nil
    func getJSON(){
        Alamofire.request(.GET, "http://tomcat.kilograpp.com/songs/api/songs").responseData { (dataJSON) ->
            Void in
            let json = JSON(data: dataJSON.result.value!)
            var newList : [Song] = []
            for song in json {
                let newSong = Song(_id: song.1["id"].int32!, _author: song.1["author"].string! , _label: song.1["label"].string!)
                newList.append(newSong)
            }
            if self.dataProvider.entities.count == 0 {
                self.dataProvider.createCoreData(newList, myCollection: (self.cv?.getCollection())!)
            }
            else {
                self.dataProvider.updateCore(newList, myCollection: (self.cv?.getCollection())!)
            }
        }
    }
}
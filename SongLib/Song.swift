import Foundation

class Song {
    let id : Int32
    let author : String
    let label : String
    init(object: Songs) {
        self.id = object.id
        self.author = object.author!
        self.label = object.label!
    }
    init(_id: Int32, _author: String, _label: String){
        self.id = _id
        self.author = _author
        self.label = _label
    }
}
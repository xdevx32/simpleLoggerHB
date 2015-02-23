// Playground - noun: a place where people can play

import UIKit


class DataImporter{
    
    var fileName = "helloFile.txt"
}

class DataManager{
    lazy var importer = DataImporter()
    var data = [String]()
}
    let manager = DataManager()
    manager.data.append("SomeData")
    manager.data.append("Some more data")
    

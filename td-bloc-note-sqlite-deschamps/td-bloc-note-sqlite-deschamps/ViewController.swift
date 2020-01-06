//
//  ViewController.swift
//  td-bloc-note-sqlite-deschamps
//
//  Created by local192 on 06/01/2020.
//  Copyright © 2020 local192. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {

    struct noteData {
        let noteId: Int32
        let noteTitle: String
        let noteDesc: String
        let noteDateCreation: Date
    }
    
    let dbTableName: String = "mynote"
    var db: Sqlite?
    var dbData: [noteData] = [noteData]()
    var limitCondition: Int = 1
    var lastId = 0
    var noData = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let dbFileUrl = documentDirectory.appendingPathComponent("mynote").appendingPathExtension("sqlite3")
            print(dbFileUrl.path)
            db = Sqlite(path: dbFileUrl.absoluteString)
        }catch{
            print(error)
        }
    }

    @IBAction func createTable() {
        if db != nil {
            let dbStatus = db!.createTable(dbTableName,
                columnInfo: ["id integer primary key autoincrement",
                            "title text",
                            "desc text",
                            "date_creation date"]
            )
            if dbStatus == SQLITE_OK {
                print("Note table is created")
            }else {
                print("Note table is NOT created")
            }
        }
    }
    
    @IBAction func insertNote() {
    }
    
    @IBAction func listeNote() {
    }
    
    @IBAction func updateNote() {
    }
    
    @IBAction func deleteNote() {
    }
    
}


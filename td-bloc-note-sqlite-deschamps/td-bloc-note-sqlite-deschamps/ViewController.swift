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
        let alert = UIAlertController(title: "Insert Note", message: nil, preferredStyle: .alert)
        alert.addTextField{ (tf) in tf.placeholder = "Title" }
        alert.addTextField{ (tf) in tf.placeholder = "Desc" }
        let action = UIAlertAction(title: "Save", style: .default){ (action) in
            guard let noteTitle = alert.textFields?.first?.text,
                let noteDesc = alert.textFields?.last?.text
                else {
                    return
            }
            print(noteTitle)
            print(noteDesc)
            
            if self.db != nil {
                let noteDateCreation = NSDate() as Date
                let dbStatus = self.db!.insert("'\(self.dbTableName)'", rowInfo: ["title":"'\(noteTitle)'",
                    "desc":"'\(noteDesc)'",
                    "date_creation":"'\(noteDateCreation)'"])
                if dbStatus == SQLITE_OK {
                    print("A new note is inserted")
                }else{
                    print("Failed : insert note")
                }
            }
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    @IBAction func listeNote() {
        let statement = db!.fetch(dbTableName, cond: nil, sortBy: nil, offset: nil)
        while sqlite3_step(statement) == SQLITE_ROW {
            let noteId = sqlite3_column_int(statement, 0)
            let noteTitle = String(cString: sqlite3_column_text(statement,1))
            let noteDesc = String(cString: sqlite3_column_text(statement,2))
            let noteDateCreation = String(cString: sqlite3_column_text(statement,3))
            print("""
                noteId : \(noteId)
                noteTitle : \(noteTitle)
                noteDesc : \(noteDesc)
                noteDateCreation : \(noteDateCreation)
            """)
        }
    }
    
    @IBAction func updateNote() {
        let alert = UIAlertController(title: "Update Note", message: nil, preferredStyle: .alert)
        alert.addTextField{ (tf) in tf.placeholder = "Note Id" }
        alert.addTextField{ (tf) in tf.placeholder = "Title" }
        
        let action = UIAlertAction(title: "Save", style: .default){ (_) in
            guard let  noteID = alert.textFields?.first?.text,
                let noteTitle = alert.textFields?.last?.text
                else {
                    return
            }
            print(noteID)
            print(noteTitle)
            
            if self.db != nil {
                let dbStatus = self.db!.update("'\(self.dbTableName)'", cond: "id = '\(noteID)'", rowInfo: ["title": "'\(noteTitle)'"])
                if dbStatus == SQLITE_OK {
                    print("A note: \(noteID) is updated")
                }else{
                    print("Failed : update note \(noteID)")
                }
            }
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    @IBAction func deleteNote() {
    }
    
}


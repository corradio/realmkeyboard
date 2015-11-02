//
//  ViewController.swift
//  testRealm
//
//  Created by Olivier Corradi on 29/10/15.
//  Copyright © 2015 Snips. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    lazy var tableView = UITableView()
    lazy var textView = UITextField()
    
    let realm = try! Realm(path: RealmConfig.dbPath)
    var token: NotificationToken? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(textView)
        view.addSubview(tableView)
        view.backgroundColor = UIColor.whiteColor()
        
        textView.placeholder = "Type here!"
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints([
            textView.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            textView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.topAnchor.constraintEqualToAnchor(textView.bottomAnchor),
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
            ])
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        title = "test"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addItem")
        
        token = realm.addNotificationBlock { notification, realm in
            self.tableView.reloadData()
        }

    }
    
    func addItem() {
        tableView.beginUpdates()
        
        let cellId = realm.objects(RealmCellModel).count + 1
        let mdl = RealmCellModel()
        mdl.title = "Cell \(cellId)"
        try! realm.write {
            self.realm.add(mdl)
        }
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: cellId - 1, inSection: 0)], withRowAnimation: .Automatic)
        
        tableView.endUpdates()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = realm.objects(RealmCellModel)[indexPath.row].title
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(RealmCellModel).count
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [ UITableViewRowAction(style: .Destructive, title: "delete") { action, indexPath in
            self.tableView.beginUpdates()

            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            let obj = self.realm.objects(RealmCellModel)[indexPath.row]
            try! self.realm.write {
                self.realm.delete(obj)
            }
            
            self.tableView.endUpdates()
        }]
    }
}
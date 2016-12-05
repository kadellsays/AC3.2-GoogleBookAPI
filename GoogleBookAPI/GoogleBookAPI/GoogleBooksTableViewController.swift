//
//  GoogleBooksTableViewController.swift
//  GoogleBookAPI
//
//  Created by Kadell on 12/4/16.
//  Copyright © 2016 Kadell. All rights reserved.
//

import UIKit

class GoogleBooksTableViewController: UITableViewController {

    var booksOf: [Book] = []
    let identifier = "Book Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        get()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func get() {
        APIManager.shared.getData(endPoint: "https://www.googleapis.com/books/v1/volumes?q=chocolate") { (data: Data?) in
            if data != nil {
                if let new = Book.createData(from: data!) {
                    self.booksOf = new
                }
              
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return booksOf.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath)
        
        let path =  booksOf[indexPath.row]
        cell.textLabel?.text = path.title
        cell.detailTextLabel?.text = path.subTitle
        
        APIManager.shared.getData(endPoint: path.smallImage) {(data: Data?) in
            DispatchQueue.main.async {
            if let imageData = data {
                cell.imageView?.image = UIImage(data: imageData)
            }
                cell.setNeedsLayout()
            }
        }

        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPath = booksOf[indexPath.row]
        performSegue(withIdentifier: "detail", sender: selectedPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail", let pushTo = sender as! Book? {
            let booksController = segue.destination as! ViewController
            booksController.book = pushTo
        }
        
    }


}

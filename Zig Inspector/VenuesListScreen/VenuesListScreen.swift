//
//  VenuesListScreen.swift
//  Zig Inspector
//
//  Created by Sudharsan on 20/06/23.
//

import UIKit

class VenuesListScreen: UITableViewController {
    
    @IBOutlet var venuesList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //        venuesList.dataSource = self
        
//        self.venuesList.register(UINib(nibName: "Cell", bundle: .main), forCellReuseIdentifier: "Cell")
        
        
        self.venuesList.register(UINib(nibName: "VenuesTableViewCell", bundle: .main), forCellReuseIdentifier: "VenuesTableViewCell")
    }
}
extension VenuesListScreen{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VenuesTableViewCell", for: indexPath) as! VenuesTableViewCell
        //cell.textLabel?.text = "OK"
        return cell
    }
}

import UIKit
import Alamofire
import SDWebImage
import NVActivityIndicatorView

let apiUrl = "https://zig-app.com/ConfigAPIV2/Getclientconfig?Pin=ZIG19"
let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballRotateChase, color: UIColor(named: "themeColor"), padding: nil)

class VenueViewController: UIViewController {
    
    @IBOutlet weak var venueList: UITableView!
    var clients: [Client] = [] // Array to store the retrieved clients
    
    override func viewDidLoad() {
        super.viewDidLoad()
        venueList.dataSource = self
        venueList.backgroundColor = UIColor.white
        activityIndicator.center = view.center
        
        view.addSubview(activityIndicator)
        fetchData()
    }
    
    func fetchData() {
        venueList.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        AF.request(apiUrl).responseDecodable(of: [Client].self) { response in
            switch response.result {
            case .success(let clients):
                DispatchQueue.main.async {
                    self.clients = clients
                    self.venueList.reloadData()
                    activityIndicator.stopAnimating()
                    self.venueList.isUserInteractionEnabled = true
                } // Reload the table view to display the data
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

extension VenueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count // Return the count of clients
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "venueCell", for: indexPath) as! venueTableViewCell
        let client = clients[indexPath.row] // Get the client for the current row
        cell.venueLabel.text = client.Clientname // Set the Clientname as the text
        cell.textLabel?.textColor = UIColor.black
        cell.venueImage?.image = nil
//        print(client.Clientimage)
        if let imageUrl = URL(string: client.Clientimage) {
            cell.venueImage?.sd_setImage(with: imageUrl)
        }
        print("Number of Macaddresslist for \(client.Clientname): \(client.Macaddresslist.count)")
        return cell
    }
}

struct Client: Codable {
    let Clientname: String
    let Clientimage: String
    let Macaddresslist: [MacAddress]
    let Id: Int
}
// Add a struct to represent the Macaddresslist data
struct MacAddress: Codable {
    // Include the properties you need from the Macaddresslist
    let Macaddress: String
    // Add other properties as needed
}

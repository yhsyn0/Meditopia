import Foundation
import UIKit

protocol MenuControllerDelegate
{
    func didSelectMenuItem(named: String)
}

class MenuListController: UITableViewController
{
    public var delegate: MenuControllerDelegate?
    
    private let items: [String]
    //var items = ["Home", "Doctors", "Appointment", "Support"]
    
    init(with items: [String])
    {
        self.items = items
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        /*
        tableView.backgroundColor = UIColor(red: 33/255.0,
                                            green: 33/255.0,
                                            blue: 33/255.0,
                                            alpha: 0.5)
         */
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "sideBackground")!)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(red: 33/255.0,
                                       green: 33/255.0,
                                       blue: 33/255.0,
                                       alpha: 0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = items[indexPath.row]
        delegate?.didSelectMenuItem(named: selectedItem)
    }
}


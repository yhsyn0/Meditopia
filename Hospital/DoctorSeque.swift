//
//  DoctorSeque.swift
//  Hospital
//
//  Created by hsyn on 16.12.2021.
//

import UIKit
import SQLite

class DoctorSeque: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var database: Connection!
    var numOfRows: Int = 0
    var docNames = [String]()
    var depNames = [String]()
    let docTable = Table("doctors")
    let docName = Expression<String?>("docName")
    let depTable = Table("departments")
    let depName = Expression<String?>("depName")
    let depId = Expression<Int64>("depId")
    
    @IBOutlet weak var doctorTable: UITableView!
    override func viewDidLoad()
    {
        doctorTable.delegate = self
        doctorTable.dataSource = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        do
        {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                   in: .userDomainMask,
                                                                   appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("doctors").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            
            numOfRows = try database.scalar(docTable.count)
            let rows1 = try self.database.prepare(self.docTable)
            let rows2 = try self.database.prepare(self.depTable)
            
            for i in rows1
            {
                docNames.append(i[docName]!)
            }
            for i in rows2
            {
                depNames.append(i[depName]!)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return numOfRows
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 142
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = doctorTable.dequeueReusableCell(withIdentifier: "customCell")! as! CustomTableViewCell
        cell.cellBackground.image = UIImage(named: "doctorCell")
        cell.docName.text = docNames[indexPath.row]
        var departID: Int64 = -1
        
        do
        {
            let rows = try self.database.prepare(self.docTable.filter(docName == docNames[indexPath.row]))
            for row in rows
            {
                departID = row[self.depId]
            }
        }
        catch
        {
            print(error)
        }
        cell.docDepartment.text = depNames[Int(departID-1)]
        cell.docWorkHours.text = "9 AM - 5 PM"
        
        return cell
    }
}

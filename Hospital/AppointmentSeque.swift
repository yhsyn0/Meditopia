//
//  AppointmentSeque.swift
//  Hospital
//
//  Created by hsyn on 18.12.2021.
//

import UIKit
import SQLite
import SQLite3
import DropDown

class AppointmentSeque: UIViewController
{
    @IBOutlet weak var nameSurname: UITextField!
    @IBOutlet weak var birthDate: UIDatePicker!
    let depDown = DropDown()
    let docDown = DropDown()
    @IBOutlet weak var appointmentDate: UIDatePicker!
    @IBOutlet weak var submitOutlet: UIButton!
    
    var database: Connection!
    var numOfRows: Int = 0
    var docNames = [String]()
    var depNames = [String]()
    let docTable = Table("doctors")
    let docId = Expression<Int64>("docId")
    let docName = Expression<String?>("docName")
    let depTable = Table("departments")
    let depId = Expression<Int64>("depId")
    let depName = Expression<String?>("depName")
    let appTable = Table("appointments")
    let appId = Expression<Int64>("appId")
    let appDate = Expression<String>("appDate")
    let patName = Expression<String?>("patName")
    let patBirth = Expression<String?>("patBirth")
    
/*
    func createTable()
    {
        let createTable = self.appTable.create { (table) in
            table.column(self.appId, primaryKey: true)
            table.column(self.appDate)
            table.column(self.patName)
            table.column(self.patBirth)
            table.column(self.docId)
            table.column(self.depId)
            
            print("Table Created")
        }
        
        do
        {
            //try self.database.run(createTable)
        }
        catch
        {
            print(error)
        }
    }
*/
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        do
        {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("doctors").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            
            //createTable()
            
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
            
            let descId = try self.database.prepare(self.appTable.order(appId.desc))
            var counter: Int = 0
            for i in descId
            {
                if counter == 3
                {
                    break
                }
                
                var docsName: String = ""
                let rows = try self.database.prepare(self.docTable.filter(docId == i[self.docId]))
                for row in rows
                {
                    docsName = row[self.docName]!
                }
                
                if counter == 0
                {
                    label1.text = docsName + "\n" + i[self.appDate]
                }
                if counter == 1
                {
                    label2.text = docsName + "\n" + i[self.appDate]
                }
                if counter == 2
                {
                    label3.text = docsName + "\n" + i[self.appDate]
                    break
                }
                counter += 1
            }
        }
        catch
        {
            print(error)
        }
        // Do any additional setup after loading the view.
        
    }

    
    @IBOutlet weak var depOutlet: UIButton!
    @IBOutlet weak var docOutlet: UIButton!
    @IBOutlet weak var timeOutlet: UIButton!
    var depSelectName: String = ""
    @IBAction func depSelectMenu(_ sender: UIButton)
    {
        depDown.dataSource = depNames
        depDown.anchorView = sender
        depDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        depDown.show()
        depDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
            self!.docOutlet.isUserInteractionEnabled = true
            self!.docOutlet.setTitle("Choose doctor", for: .normal)
            self!.timeOutlet.setTitle("Choose hour", for: .normal)
            if let buttonTitle = sender.title(for: .normal)
            {
                self!.depSelectName = buttonTitle
            }
            self!.submitOutlet.isUserInteractionEnabled = false
            self!.appointmentDate.isUserInteractionEnabled = false
            self!.timeOutlet.isUserInteractionEnabled = false
        }
    }
    
    var docSelectName: String = ""
    @IBAction func docSelectMenu(_ sender: UIButton)
    {
        //let rows = try self.database.prepare(self.usersTable.filter(key == textF.text!))
        var departId: Int64 = -1
        var docNamesFiltered = [String]()
        do
        {
            let rows = try self.database.prepare(self.depTable.filter(depName == depSelectName))
            for row in rows
            {
                departId = row[self.depId]
            }
            
            let rows2 = try self.database.prepare(self.docTable.filter(depId == departId))
            for row2 in rows2
            {
                docNamesFiltered.append(row2[docName]!)
            }
        }
        catch
        {
            print(error)
        }
        
        depDown.dataSource = docNamesFiltered
        depDown.anchorView = sender
        depDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        depDown.show()
        depDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
            self!.appointmentDate.isUserInteractionEnabled = true
            self!.timeOutlet.setTitle("Choose hour", for: .normal)
            let components = self!.appointmentDate.calendar.dateComponents([.year, .month, .day, .weekday], from: self!.appointmentDate.date)
            if components.weekday == 1 || components.weekday == 7
            {
                self!.timeOutlet.isUserInteractionEnabled = false
            }
            else
            {
                self!.timeOutlet.isUserInteractionEnabled = true
            }
            
            if let buttonTitle = sender.title(for: .normal)
            {
                self!.docSelectName = buttonTitle
            }
            
            self!.submitOutlet.isUserInteractionEnabled = false
        }
    }
    
    
    @IBAction func appointmentButton(_ sender: UIDatePicker)
    {
        submitOutlet.isUserInteractionEnabled = false
        timeOutlet.setTitle("Choose hour", for: .normal)
        let components = appointmentDate.calendar.dateComponents([.year, .month, .day, .weekday], from: appointmentDate.date)
        
        if components.weekday == 1 || components.weekday == 7
        {
            timeOutlet.isUserInteractionEnabled = false
        }
        
        else
        {
            timeOutlet.isUserInteractionEnabled = true
        }
    }
    
    var appointmentTime: String = ""
    @IBAction func timeSelectMenu(_ sender: UIButton)
    {
        let hours = ["09:00", "09:15", "09:30", "09:45",
                     "10:00", "10:15", "10:30", "10:45",
                     "11:00", "11:15", "11:30", "11:45",
                     "13:00", "03:15", "13:30", "13:45",
                     "14:00", "14:15", "14:30", "14:45",
                     "15:00", "15:15", "15:30", "14:45",
                     "16:00", "16:15", "16:30", "16:45"]
        var hoursCopy = ["09:00", "09:15", "09:30", "09:45",
                         "10:00", "10:15", "10:30", "10:45",
                         "11:00", "11:15", "11:30", "11:45",
                         "13:00", "13:15", "13:30", "13:45",
                         "14:00", "14:15", "14:30", "14:45",
                         "15:00", "15:15", "15:30", "14:45",
                         "16:00", "16:15", "16:30", "16:45"]
        let components = appointmentDate.calendar.dateComponents([.year, .month, .day, .weekday], from: appointmentDate.date)
        
        
        let dateString = String(components.day!) + "/" + String(components.month!) + "/" + String(components.year!)
        var doctorId: Int64 = -1
        
        do
        {
            let rows = try self.database.prepare(self.docTable.filter(docName == docSelectName))
            for row in rows
            {
                doctorId = row[self.docId]
            }
            
            let rows2 = try self.database.prepare(self.appTable.filter(docId == doctorId))
            
            for row2 in rows2
            {
                let fullDateArr = row2[self.appDate].components(separatedBy: " ")
                for i in hours
                {
                    if fullDateArr[0] == dateString && i == fullDateArr[1]
                    {
                        hoursCopy.remove(at: hoursCopy.firstIndex(where: {$0 == i})!)
                    }
                }
            }
            
            depDown.dataSource = hoursCopy
            depDown.anchorView = sender
            depDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
            depDown.show()
            depDown.selectionAction = { [weak self] (index: Int, item: String) in
                guard let _ = self else { return }
                sender.setTitle(item, for: .normal)
                self!.submitOutlet.isUserInteractionEnabled = true
                if let buttonTitle = sender.title(for: .normal)
                {
                    self!.appointmentTime = buttonTitle
                }
            }
        }
        catch
        {
            print(error)
        }
    }
    
    func createAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    @IBAction func submitAction(_ sender: UIButton)
    {
        if nameSurname.text == ""
        {
            createAlert(title: "Warning", message: "Name and surname can not be empty")
        }
        
        else
        {
            var doctorId: Int64 = -1
            var departId: Int64 = -1
            
            do
            {
                let rows = try self.database.prepare(self.docTable.filter(docName == docSelectName))
                for row in rows
                {
                    doctorId = row[self.docId]
                }
                
                let rows2 = try self.database.prepare(self.depTable.filter(depName == depSelectName))
                for row2 in rows2
                {
                    departId = row2[self.depId]
                }
                
                let components = appointmentDate.calendar.dateComponents([.year, .month, .day, .weekday], from: appointmentDate.date)
                let components2 = birthDate.calendar.dateComponents([.year, .month, .day, .weekday], from: birthDate.date)
                let appoDate = String(components.day!) + "/" + String(components.month!) + "/" + String(components.year!) + " " + appointmentTime
                let patBirthDate = String(components2.day!) + "/" + String(components2.month!) + "/" + String(components2.year!)
                
                try self.database.run(self.appTable.insert(self.appDate <- appoDate, self.patName <- nameSurname.text, self.patBirth <- patBirthDate, self.docId <- doctorId, self.depId <- departId))
                
                docOutlet.isUserInteractionEnabled = false
                submitOutlet.isUserInteractionEnabled = false
                appointmentDate.isUserInteractionEnabled = false
                timeOutlet.isUserInteractionEnabled = false
                
                nameSurname.text = ""
                depOutlet.setTitle("Choose department", for: .normal)
                docOutlet.setTitle("Choose doctor", for: .normal)
                timeOutlet.setTitle("Choose hour", for: .normal)
                
                let descId = try self.database.prepare(self.appTable.order(appId.desc))
                var counter: Int = 0
                for i in descId
                {
                    if counter == 3
                    {
                        break
                    }
                    
                    var docsName: String = ""
                    let rows = try self.database.prepare(self.docTable.filter(docId == i[self.docId]))
                    for row in rows
                    {
                        docsName = row[self.docName]!
                    }
                    
                    if counter == 0
                    {
                        label1.text = docsName + "\n" + i[self.appDate]
                    }
                    if counter == 1
                    {
                        label2.text = docsName + "\n" + i[self.appDate]
                    }
                    if counter == 2
                    {
                        label3.text = docsName + "\n" + i[self.appDate]
                        break
                    }
                    counter += 1
                }
                
                
                createAlert(title: "Success", message: "Your appointment has been created. Please be at the hospital 15 minutes before your appointment time.")
            }
            catch
            {
                print(error)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
}

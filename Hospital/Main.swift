//
//  Home.swift
//  Hospital
//
//  Created by hsyn on 30.11.2021.
//

import UIKit
import SideMenu
import SQLite

class Main: UIViewController, MenuControllerDelegate
{
    /*
    var database: Connection!
    var numOfRows: Int = 0
    let docTable = Table("doctors")
    let docId = Expression<Int64>("docId")
    let docName = Expression<String?>("docName")
    let depTable = Table("departments")
    let depId = Expression<Int64>("depId")
    let depName = Expression<String?>("depName")
    
    func createTable()
    {
        print("CREATE TAPPED")
 
        let createTable = self.depTable.create { (table) in
            table.column(self.depId, primaryKey: true)
            table.column(self.depName)
        }
        
        let createTable2 = self.docTable.create { (table) in
            table.column(self.docId, primaryKey: true)
            table.column(self.docName)
            table.column(self.depId)
        }
        
        let insertUser = self.depTable.insert(self.depName <- "Gastroenterology", self.depId <- 1)
        let insertUser2 = self.depTable.insert(self.depName <- "Family Physiciatrist", self.depId <- 2)
        let insertUser3 = self.depTable.insert(self.depName <- "Endocrinology", self.depId <- 3)
        let insertUser4 = self.depTable.insert(self.depName <- "Dermatology", self.depId <- 4)
        let insertUser5 = self.depTable.insert(self.depName <- "Cardiology", self.depId <- 5)
        let insertUser6 = self.depTable.insert(self.depName <- "Anesthesy", self.depId <- 6)
        let insertUser7 = self.depTable.insert(self.depName <- "Hematology", self.depId <- 7)
        let insertUser8 = self.depTable.insert(self.depName <- "Pathology", self.depId <- 8)
        
        let insertUser9 = self.docTable.insert(self.docName <- "James Smith", self.depId <- 1)
        let insertUser10 = self.docTable.insert(self.docName <- "Mary Johnson", self.depId <- 2)
        let insertUser11 = self.docTable.insert(self.docName <- "Paul Brown", self.depId <- 3)
        let insertUser12 = self.docTable.insert(self.docName <- "Donald Jones", self.depId <- 4)
        let insertUser13 = self.docTable.insert(self.docName <- "Nancy Lopez", self.depId <- 5)
        let insertUser14 = self.docTable.insert(self.docName <- "Matthew Hernandez", self.depId <- 6)
        let insertUser15 = self.docTable.insert(self.docName <- "Daniel Wilson", self.depId <- 7)
        let insertUser16 = self.docTable.insert(self.docName <- "Barbara Moore", self.depId <- 8)

        let insertUser17 = self.docTable.insert(self.docName <- "Teressa Bates", self.depId <- 1)
        let insertUser18 = self.docTable.insert(self.docName <- "Stanley Alexander", self.depId <- 2)
        let insertUser19 = self.docTable.insert(self.docName <- "Patricia Curtis", self.depId <- 3)
        let insertUser20 = self.docTable.insert(self.docName <- "Lynette Cavill", self.depId <- 4)
        let insertUser21 = self.docTable.insert(self.docName <- "Nichola Eason", self.depId <- 5)
        let insertUser22 = self.docTable.insert(self.docName <- "Lillian Hooten", self.depId <- 6)
        let insertUser23 = self.docTable.insert(self.docName <- "Melanie Pexton", self.depId <- 7)
        let insertUser24 = self.docTable.insert(self.docName <- "Shana Rees", self.depId <- 8)
        
        do
        {
            try self.database.run(createTable)
            try self.database.run(createTable2)
            
            try self.database.run(insertUser)
            try self.database.run(insertUser2)
            try self.database.run(insertUser3)
            try self.database.run(insertUser4)
            try self.database.run(insertUser5)
            try self.database.run(insertUser6)
            try self.database.run(insertUser7)
            try self.database.run(insertUser8)
            
            try self.database.run(insertUser9)
            try self.database.run(insertUser10)
            try self.database.run(insertUser11)
            try self.database.run(insertUser12)
            try self.database.run(insertUser13)
            try self.database.run(insertUser14)
            try self.database.run(insertUser15)
            try self.database.run(insertUser16)
     
            try self.database.run(insertUser17)
            try self.database.run(insertUser18)
            try self.database.run(insertUser19)
            try self.database.run(insertUser20)
            try self.database.run(insertUser21)
            try self.database.run(insertUser22)
            try self.database.run(insertUser23)
            try self.database.run(insertUser24)

            print("Created Table")
        }
        catch
        {
            print(error)
        }
    }
    
    func listUsers()
    {
        print("LIST TAPPED")
        
        do {
            let users = try self.database.prepare(self.docTable)
            
            for user in users
            {
                print(user[docId])
                print(user[docName]!)
                print(user[depId])
                print("\n")
            }
            /*
            let users2 = try self.database.prepare(self.depTable)
            for user2 in users2
            {
                print(user2[depId])
                print(user2[depName]!)
                print("\n")
            }*/
        } catch {
            print(error)
        }
    }
    */
    var menu: SideMenuNavigationController?
    var timer = Timer()
    var i = 0
    var imgArr = [UIImage]()
    var qArr = [UIImage]()
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var homeScrollView: UIScrollView!
    
    @IBAction func homeGreenButton(_ sender: UIButton)
    {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let appointmentSeque = mainStoryBoard.instantiateViewController(withIdentifier: "AppointmentSeque") as?
                AppointmentSeque else
                {
                    print("Couldn't find the view controller named 'Appointment Seque'")
                    
                    return
                }
        appointmentSeque.modalTransitionStyle = .crossDissolve
        appointmentSeque.modalPresentationStyle = .fullScreen
        
        present(appointmentSeque, animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        /*
        // SQLite
        //------------------------------------------
        
        do
        {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("doctors").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        }
        catch
        {
            print(error)
        }
    
        //createTable()
        //listUsers()
        //------------------------------------------
        */
        let itemsOfMenu = MenuListController(with: ["Home", "Doctors", "Appointment", "Support"])
        itemsOfMenu.delegate = self
        menu = SideMenuNavigationController(rootViewController: itemsOfMenu)
        
        imgArr.append(UIImage(named: "sl1")!)
        imgArr.append(UIImage(named: "sl2")!)
        imgArr.append(UIImage(named: "sl3")!)
        imgArr.append(UIImage(named: "sl4")!)
        imgArr.append(UIImage(named: "sl5")!)
        qArr.append(UIImage(named: "q1")!)
        qArr.append(UIImage(named: "q2")!)
        qArr.append(UIImage(named: "q3")!)
        qArr.append(UIImage(named: "q4")!)
        qArr.append(UIImage(named: "q5")!)
        qArr.append(UIImage(named: "q6")!)
        qArr.append(UIImage(named: "q7")!)
        
        pageControl.numberOfPages = imgArr.count
        pageControl.currentPage = i
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.gray
        imgView.image = imgArr[0]
        
        var contentWidth:CGFloat = 0.0
        
        for j in 0..<(qArr.count)
        {
            let imView = UIImageView(image: qArr[j])
            let xCoord = homeScrollView.frame.width * CGFloat(j)
            contentWidth += homeScrollView.frame.width
            homeScrollView.addSubview(imView)
            imView.frame = CGRect(x: xCoord, y: 0, width: homeScrollView.frame.size.width,
                                  height: homeScrollView.frame.size.height)
            imView.contentMode = .scaleToFill
        }
        
        homeScrollView.contentSize = CGSize(width: contentWidth, height: homeScrollView.frame.height)
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(changePage),
                                     userInfo: nil, repeats: true)
        
        menu?.leftSide = true
        
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
    }

    @IBAction func didTapMenu()
    {
        present(menu!, animated: true)
    }
    
    func didSelectMenuItem(named: String)
    {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let supportSeque = mainStoryBoard.instantiateViewController(withIdentifier: "SupportSeque") as?
                SupportSeque else
                {
                    print("Couldn't find the view controller named 'Support Seque'")
                    
                    return
                }
        supportSeque.modalTransitionStyle = .crossDissolve
        supportSeque.modalPresentationStyle = .fullScreen
        
        guard let doctorSeque = mainStoryBoard.instantiateViewController(withIdentifier: "DoctorSeque") as?
                DoctorSeque else
                {
                    print("Couldn't find the view controller named 'Doctor Seque'")
                    
                    return
                }
        doctorSeque.modalTransitionStyle = .crossDissolve
        doctorSeque.modalPresentationStyle = .fullScreen
        
        guard let appointmentSeque = mainStoryBoard.instantiateViewController(withIdentifier: "AppointmentSeque") as?
                AppointmentSeque else
                {
                    print("Couldn't find the view controller named 'Appointment Seque'")
                    
                    return
                }
        appointmentSeque.modalTransitionStyle = .crossDissolve
        appointmentSeque.modalPresentationStyle = .fullScreen
        
        menu?.dismiss(animated: true, completion: { [weak self] in
            
            if named == "Doctors"
            {
                self?.present(doctorSeque, animated: true, completion: nil)
            }
            
            if named == "Support"
            {
                self?.present(supportSeque, animated: true, completion: nil)
            }
            
            if named == "Appointment"
            {
                self?.present(appointmentSeque, animated: true, completion: nil)
            }

        })
    }
    
    @objc func changePage()
    {
        i += 1
        if i == imgArr.count
        {
            i = 0
        }
        
        UIView.transition(with: imgView,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { self.imgView.image = self.imgArr[self.i] },
                          completion: nil)
        pageControl.currentPage = i
    }
    
    @objc func startTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self,
                                     selector: #selector(changePage), userInfo: nil, repeats: true)
    }
    
    @IBAction func pageLeft(_ sender: UIButton)
    {
        i -= 1
        if i == -1
        {
            i = imgArr.count-1
        }
        
        UIView.transition(with: imgView,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { self.imgView.image = self.imgArr[self.i] },
                          completion: nil)
        pageControl.currentPage = i
        timer.invalidate()
        startTimer()
        
    }
    @IBAction func pageRight(_ sender: UIButton)
    {
        i += 1
        if i == imgArr.count
        {
            i = 0
        }
        
        UIView.transition(with: imgView,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { self.imgView.image = self.imgArr[self.i] },
                          completion: nil)
        pageControl.currentPage = i
        timer.invalidate()
        startTimer()
    }
}

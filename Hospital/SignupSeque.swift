//
//  SignupSeque.swift
//  Hospital
//
//  Created by hsyn on 29.12.2021.
//

import UIKit
import SQLite
import SQLite3

class SignupSeque: UIViewController, UITextFieldDelegate {
    
    var database: Connection!
    let userTable = Table("users")
    let userId = Expression<Int64>("userId")
    let userName = Expression<String?>("userName")
    let userBirth = Expression<String?>("userBirth")
    let userEmail = Expression<String?>("userEmail")
    let userPass = Expression<String?>("userPass")
    
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title,
                                      message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
/*
    func createTable() {
            let createTable = self.userTable.create { (table) in
                table.column(self.userId, primaryKey: true)
                table.column(self.userName)
                table.column(self.userBirth)
                table.column(self.userEmail)
                table.column(self.userPass)
                
                print("Table Created")
            }
            
            do {
                try self.database.run(createTable)
            }
            catch {
                print(error)
            }
        }
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                   in: .userDomainMask,
                                                                   appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("doctors").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            //createTable()
        }
        catch {
            print(error)
        }
        
        nameOutlet.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        nameOutlet.delegate = self
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let navController = mainStoryBoard.instantiateViewController(withIdentifier: "NavController") as?
                UINavigationController else
                {
                    print("Couldn't find the view controller named 'Navigation Controller'")
                    
                    return
                }
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .fullScreen
        
        present(navController, animated: true, completion: nil)
    }
    @IBOutlet weak var nameOutlet: UITextField!
    @IBOutlet weak var birthOutlet: UIDatePicker!
    @IBOutlet weak var mailOutlet: UITextField!
    @IBOutlet weak var passOutlet: UITextField!
    @IBOutlet weak var passAgainOutlet: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBAction func submitButton(_ sender: UIButton) {
        if nameOutlet.text == "" || mailOutlet.text == "" ||
            passOutlet.text == "" || passAgainOutlet.text == "" {
            createAlert(title: "Warning", message: "Please fill all the fields !")
        }
        
        else if !isValidEmail(mailOutlet.text!) {
            createAlert(title: "Invalid E-Mail", message: "Please enter a valid e-mail !")
        }
        
        else if passOutlet.text != passAgainOutlet.text {
            createAlert(title: "Warning", message: "Passwords don't match !")
            passOutlet.text = ""
            passAgainOutlet.text = ""
        }
        
        else if passOutlet.text!.count < 10 || passOutlet.text!.count > 100 {
            createAlert(title: "Warning",
                    message: "Password length must be between 10 and 100 and includes 5 or more unique characters !")
            passOutlet.text = ""
            passAgainOutlet.text = ""
        }

        else if Set(passOutlet.text!).count < 5 {
            createAlert(title: "Warning",
                    message: "Password length must be between 10 and 100 and includes 5 or more unique characters !")
            passOutlet.text = ""
            passAgainOutlet.text = ""
        }
        
        else {
            let components = birthOutlet.calendar.dateComponents([.year, .month, .day, .weekday],
                                                                from: birthOutlet.date)
            let birthDate = String(components.day!) + "/" + String(components.month!) + "/" +
                                String(components.year!)
            do {
                try self.database.run(self.userTable.insert(self.userName <- nameOutlet.text,
                                                            self.userBirth <- birthDate,
                                                            self.userEmail <- mailOutlet.text,
                                                            self.userPass <- passOutlet.text))
            }
            catch {
                print(error)
            }
            
            nameOutlet.text = ""
            mailOutlet.text = ""
            passOutlet.text = ""
            passAgainOutlet.text = ""
            
            let submitAlert = UIAlertController(title: "Succesfull",
                                          message: "Your account has been created !", preferredStyle: UIAlertController.Style.alert)
            submitAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.continueButton.sendActions(for: .touchUpInside)
            }))
            present(submitAlert, animated: true, completion: nil)
            
            do {
                let users = try self.database.prepare(self.userTable)
                for user in users {
                    //print("userId: \(user[self.userId]), Name: \(user[self.userName]!), Birth: \(user[self.userBirth]!), E-mail: \(user[self.userEmail]!), Pass: \(user[self.userPass]!)")
                    print(user)
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 30
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

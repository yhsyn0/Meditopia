import UIKit
import SQLite
import SQLite3

class Login: UIViewController {
    
    var database: Connection!
    let userTable = Table("users")
    let userId = Expression<Int64>("userId")
    let userName = Expression<String?>("userName")
    let userBirth = Expression<String?>("userBirth")
    let userEmail = Expression<String?>("userEmail")
    let userPass = Expression<String?>("userPass")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                   in: .userDomainMask,
                                                                   appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("doctors").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        }
        catch {
            print(error)
        }
        
        emailOutlet.borderStyle = UITextField.BorderStyle.roundedRect
        passOutlet.borderStyle = UITextField.BorderStyle.roundedRect
        forgetOutlet.contentHorizontalAlignment	= .right
        signUpOutlet.contentHorizontalAlignment = .left
    }
    
    func continueAction() {
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
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @IBOutlet weak var signUpOutlet: UIButton!
    @IBOutlet weak var forgetOutlet: UIButton!
    @IBAction func forgetAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Password Resetting",
                                      message: "Please enter your e-mail", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "E-mail"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField!.text!)")
            if (self.isValidEmail(textField!.text!)) {
                self.createAlert(title: "Success",
                                 message: "If e-mail exists, password resetting instructions has been sent.")
            }
            else {
                self.createAlert(title: "Warning",
                                 message: "Please enter a valid e-mail.")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var emailOutlet: UITextField! {
        didSet {
            let purplePlaceholderText = NSAttributedString(string: "   E-mail",
                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 123/255.0,
                                                                                                    green: 110/255.0,
                                                                                                    blue: 168/255.0,
                                                                                                    alpha: 1)])
            emailOutlet.attributedPlaceholder = purplePlaceholderText
        }
    }
    @IBOutlet weak var passOutlet: UITextField! {
        didSet {
            let purplePlaceholderText = NSAttributedString(string: "   Password",
                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 123/255.0,
                                                                                                    green: 110/255.0,
                                                                                                    blue: 168/255.0,
                                                                                                    alpha: 1)])
            passOutlet.attributedPlaceholder = purplePlaceholderText
        }
    }
    
    @IBOutlet weak var showHideOutlet: UIButton!
    @IBAction func showHideButton(_ sender: UIButton) {
        passOutlet.isSecureTextEntry.toggle()
        if(passOutlet.isSecureTextEntry) {
            showHideOutlet.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
        else {
            showHideOutlet.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }

    @IBAction func loginAction(_ sender: UIButton) {
        var control = 0
        
        if emailOutlet.text == "" && passOutlet.text == "" {
            createAlert(title: "Warning",
                        message: "E-mail or password is empty")
        }
        else if !isValidEmail(emailOutlet.text!) {
            createAlert(title: "Warning",
                        message: "Please enter a valid e-mail")
        }
        else {
            do {
                let users = try self.database.prepare(self.userTable)
                for user in users {
                    if user[self.userEmail] == emailOutlet.text! &&
                        user[self.userPass] == passOutlet.text! {
                        control = 1
                        
                        let defaults = UserDefaults.standard
                        defaults.set(user[self.userName], forKey: "loggedName")
                        defaults.set(user[self.userBirth], forKey: "loggedBirth")
                        defaults.set(user[self.userEmail], forKey: "loggedEmail")
                        defaults.synchronize()
                        self.continueAction()
                    }
                }
            } catch {
                print(error)
            }
        }
        
        if control == 0 {
            createAlert(title: "Warning",
                        message: "Wrong Credentials !")
        }
    }
    
    
}

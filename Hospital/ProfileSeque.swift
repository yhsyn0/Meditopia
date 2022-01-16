import UIKit
import Foundation

class ProfileSeque: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        bigNameOutlet.text = defaults.string(forKey: "loggedName")
        bigMailOutlet.text = defaults.string(forKey: "loggedEmail")
        nameOutlet.text = defaults.string(forKey: "loggedName")
        birthOutlet.text = defaults.string(forKey: "loggedBirth")
        mailOutlet.text = defaults.string(forKey: "loggedEmail")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "loggedName") == "" {
            self.continueAction()
        }
    }
    
    @IBOutlet weak var bigNameOutlet: UILabel!
    @IBOutlet weak var bigMailOutlet: UILabel!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var birthOutlet: UILabel!
    @IBOutlet weak var mailOutlet: UILabel!
    
    func continueAction() {
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let login = mainStoryBoard.instantiateViewController(withIdentifier: "Login") as?
                    Login else
                    {
                        print("Couldn't find the view controller named 'Welcome Controller'")
                        
                        return
                    }
            login.modalTransitionStyle = .crossDissolve
            login.modalPresentationStyle = .fullScreen
            
            present(login, animated: true, completion: nil)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "loggedName")
        defaults.set("", forKey: "loggedBirth")
        defaults.set("", forKey: "loggedEmail")
        defaults.synchronize()
        self.continueAction()
    }
    
}

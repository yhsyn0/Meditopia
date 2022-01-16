import UIKit

class Welcome: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "loggedName") != "" {
            self.continueAction()
        }
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
    

}

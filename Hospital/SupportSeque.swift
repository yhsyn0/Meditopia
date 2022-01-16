import UIKit
import SideMenu

class SupportSeque: UIViewController, UITextViewDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        messageText.delegate = self
        
        messageText.text = "Please enter your message"
        messageText.textColor = UIColor.lightGray
        messageText.selectedTextRange = messageText.textRange(from: messageText.beginningOfDocument,
                                                              to: messageText.beginningOfDocument)
        // Do any additional setup after loading the view.
    }
    
    func createAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
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
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var messageText: UITextView!
    @IBAction func submitButton(_ sender: UIButton)
    {
        if emailText.text!.isEmpty || messageText.text!.isEmpty
        {
            createAlert(title: "Warning", message: "\nE-mail or message is empty !")
        }
        
        else if !isValidEmail(emailText.text!)
        {
            createAlert(title: "Invalid E-Mail", message: "Please enter a valid e-mail !")
        }
        else
        {
            emailText.text?.removeAll()
            messageText.text?.removeAll()
            createAlert(title: "Successful",
                        message: "\nWe got your message. We're going to make a return as soon as possible.")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let updatedText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = updatedText.count
        
        if updatedText.isEmpty
        {

            textView.text = "Please enter your message"
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument,
                                                            to: textView.beginningOfDocument)
        }

        else if textView.textColor == UIColor.lightGray && !text.isEmpty
        {
            textView.textColor = UIColor.black
            textView.text = text
        }
        
        return numberOfChars <= 200
    }
    
    func textViewDidChangeSelection(_ textView: UITextView)
    {
        if self.view.window != nil
        {
            if textView.textColor == UIColor.lightGray
            {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument,
                                                                to: textView.beginningOfDocument)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
}

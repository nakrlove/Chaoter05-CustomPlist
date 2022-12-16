//
//  ListViewController.swift
//  Chaoter05-CustomPlist
//
//  Created by nakr on 2022/12/17.
//

import UIKit

class ListViewController: UITableViewController,UIPickerViewDelegate,UIPickerViewDataSource {
  
    

    @IBOutlet var account: UITextField!
    @IBOutlet var name: UILabel!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var married: UISwitch!
    
//    var accountList = ["sqlpro@naver.com",
//                       "webmaster@rubypaper.co.kr",
//                       "abc1@gmail.com",
//                       "abc2@gmail.com",
//                       "abc3@gmail.com"
//    ]
    
    
 
    
    var accountList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        let plist = UserDefaults.standard
        self.name.text = plist.string(forKey: "name")
        self.married.isOn = plist.bool(forKey: "married")
        self.gender.selectedSegmentIndex = plist.integer(forKey: "gender")
        self.account.text = plist.string(forKey: "account")
        
        self.accountList = plist.array(forKey: "accountList") as? [String] ?? [String]()
        
//        self.accountList = accountdataList
        
        let picker = UIPickerView()
        picker.delegate = self
        self.account.inputView = picker
        
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
        toolbar.barTintColor = .lightGray
        
        self.account.inputAccessoryView = toolbar
        
        let done = UIBarButtonItem()
        done.title = "done"
        done.target = self
        done.action = #selector(pickerDone)
        
        let new = UIBarButtonItem()
        new.title = "New"
        new.target = self
        new.action = #selector(newAccount)
        
//        toolbar.setItems([done,close],animated: true)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([new,flexSpace,done],animated: true)
        // Do any additional setup after loading the view.
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
            alert.addTextField(){
                $0.text = self.name.text
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                let value = alert.textFields?[0].text ?? ""
                self.setAccount(key:"name" , value: value)
                self.name.text = value
            })
            
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.accountList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.accountList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let account = self.accountList[row]
        self.account.text = account
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  

}


extension ListViewController {
    
    func setAccount(key: String, value: Any){
        let plist = UserDefaults.standard
        plist.set(value,forKey:key)
        plist.synchronize()
    }
    
}

extension ListViewController {
    
    @objc func newAccount(_ sender: Any){
        self.view.endEditing(true)
        let alert = UIAlertController(title: "새 계정을 입력하세요", message: nil, preferredStyle: .alert)
        alert.addTextField() {
            $0.placeholder = "ex) abc@gmail.com"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
            if let account = alert.textFields?[0].text {
                self.accountList.append(account)
                self.account.text = account
                
                
            }
        })
        
        self.present(alert, animated: false, completion: {
            print("account ============= \(self.account.text!)")
            self.setAccount(key:"account" , value: self.account.text!)
//            self.setAccount(key:"accountList" , value: self.accountList)
            
            let plist = UserDefaults.standard
            plist.set(self.accountList,forKey:"accountList")
            plist.synchronize()
        })
    }
    
    @objc func pickerDone(_ sender: Any){
        self.view.endEditing(true)
    }
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex
        self.setAccount(key: "gender", value: value)
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn
        self.setAccount(key: "married", value: value)
    }
}

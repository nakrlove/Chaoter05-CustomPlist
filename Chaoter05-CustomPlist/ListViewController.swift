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
    
    private let keyName: String     = "name"
    private let key_Married: String = "married"
    private let key_Gender: String  = "gender"
    private let key_Account: String = "account"
    private let key_AccountList: String = "accountList"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let plist = UserDefaults.standard
//        self.name.text = plist.string(forKey: self.keyName)
//        self.married.isOn = plist.bool(forKey: self.key_Married)
//        self.gender.selectedSegmentIndex = plist.integer(forKey: self.key_Gender)
//        self.account.text = plist.string(forKey: self.key_Account)
//        self.accountList = plist.array(forKey: "accountList") as? [String] ?? [String]()
//        self.accountList = accountdataList
        self.getAccountList()
        
        loadCustomPlist(key: self.key_Account)
        
       
        
        
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
//        if indexPath.row == 1 {
           
//            let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
//            alert.addTextField(){
//                $0.text = self.name.text
//            }
//
//            alert.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
//                let value = alert.textFields?[0].text ?? ""
//                self.setAccount(key: self.keyName , value: value)
//                self.name.text = value
//
//                let customPlist = "\(self.account.text!).plist"
//                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
//                let path = paths[0] as NSString
//                let plist = path.strings(byAppendingPaths:[customPlist]).first!
//
//                print("plist = \(plist)")
//                let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary()
//                data.setValue(value, forKey: "name")
//                data.write(toFile: plist, atomically: true)
//
//            })
//
//            self.present(alert, animated: false, completion: nil)
//        }
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

}


extension ListViewController {
    
    func setAccount(key: String, value: Any){
        let plist = UserDefaults.standard
        plist.set(value,forKey:key)
        plist.synchronize()
    }
    
    func setPlistWrite(key: String, value: Any){
        let customPlist = "\(self.account.text!).plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths:[customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary()
        data.setValue(value, forKey: key)
        data.write(toFile: plist, atomically: true)
        
        print("plist Write = \(plist)")
    }
    
    func getAccountList() {
        let plist = UserDefaults.standard
        self.accountList = plist.array(forKey: self.key_AccountList) as? [String] ?? [String]()
    }
    
    
    func loadCustomPlist(key: String) {
        
//        let plist = UserDefaults.standard
        print("loadCustomPlist key=[\(key)]")
        let customPlist = "\(self.account.text!).plist"
        
       
        print("##########################[loadCustomPlist 1]##########################")
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let path = paths[0] as NSString
        let plist = (path.strings(byAppendingPaths:[customPlist]).first!)
        
        print("plist = \(plist)")
//            let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary()
        let data = NSDictionary(contentsOfFile: plist)
        
        self.name.text = data?[self.keyName] as? String
        self.married.isOn = data?[self.key_Married] as? Bool ?? false
        self.gender.selectedSegmentIndex = data?[self.key_Gender] as? Int ?? 0
//            self.account.text = data?[self.key_Account] as? String
        print("#name =\(data?[self.keyName] as? String)")
        print("#married =\(data?[self.key_Married] as? Bool ?? false)")
        print("#gender =\(data?[self.key_Gender] as? Int ?? 0)")
        print("#account =\(data?[self.key_Account] as? String)")
        print("##########################[loadCustomPlist 2]##########################")
        
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
              
//                let plist = UserDefaults.standard
//                plist.set(self.accountList,forKey:"accountList")
//                plist.synchronize()
                
                self.setAccount(key: self.key_AccountList,value: self.accountList)
                self.getAccountList()
//                self.setAccount(key: self.key_Account,value: account)
                print("setAccount key =[\(account)], value = [\(account)]")
                self.setAccount(key: account,value: account)
                self.account.text = account
            }
        })
        
        self.present(alert, animated: false)

    }
    
    @objc func pickerDone(_ sender: Any){
        
        let account = (self.account?.text)!
        print("pickerDone = \(account)")
        
        self.setAccount(key: account,value: account)
        loadCustomPlist(key: account)
        self.view.endEditing(true)
    }
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex
//        self.setAccount(key: self.key_Gender, value: value)
        self.setPlistWrite(key: self.key_Gender, value: value)
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn
        self.setPlistWrite(key: self.key_Married, value: value)
//        self.setAccount(key: key_Married, value: value)
    }
}

//
//  ChatViewController.swift
//  TradingBot
//
//  Created by TradeSocio on 31/05/19.
//  Copyright © 2019 Tradesocio. All rights reserved.
//

import UIKit
import AVFoundation
class ChatViewController: UIViewController {
    
    @IBOutlet weak var constHeightCollVwOptions: NSLayoutConstraint!
    @IBOutlet weak var constTblMainHeight: NSLayoutConstraint!
    @IBOutlet weak var collvwOptions: UICollectionView!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var tblMain: UITableView!
    @IBOutlet weak var btnLogout: UIButton!
    var username = String()
    var arrChats = [ChatModel]()
    var arrOptions = [String]()
    var objChatModel : ChatModel?
    var speechSynthesizer = AVSpeechSynthesizer()
    var arrChatShowingIndex = [IndexPath]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        btnLogout.layer.borderColor = UIColor.black.cgColor
        btnLogout.layer.borderWidth = 1.0
        tfMessage.layer.borderColor = UIColor.black.cgColor
        tfMessage.layer.borderWidth = 1.0
        btnMessage.layer.borderColor = UIColor.black.cgColor
        btnMessage.layer.borderWidth = 1.0
        tblMain.layer.borderColor = UIColor.black.cgColor
        tblMain.layer.borderWidth = 1.0
        
        constHeightCollVwOptions.constant = 0
        
        self.collvwOptions.delegate = self
        self.collvwOptions.dataSource = self
        
        let nib1 = UINib(nibName: "BotChatTVCell", bundle: Bundle.main)
        tblMain.register(nib1, forCellReuseIdentifier: "BotChatTVCell")
        
        let nib2 = UINib(nibName: "MyChatTVCell", bundle: Bundle.main)
        tblMain.register(nib2, forCellReuseIdentifier: "MyChatTVCell")
        
        let nib3 = UINib(nibName: "ChartsTVCell", bundle: Bundle.main)
        tblMain.register(nib3, forCellReuseIdentifier: "ChartsTVCell")
        
        
        tblMain.estimatedRowHeight = 100
        tblMain.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    @IBAction func btnLogoutAction(_ sender: Any) {
        username = ""
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnMsgAction(_ sender: Any) {
        //let myChatModel = ChatModel(status: 1, options: [], isMine: 1, msg: tfMessage.text ?? "")
        let myChatModel = ChatModel(status: 1, options: [], isMine: 1, msg: tfMessage.text ?? "", portfolio: [])
        arrChats.append(myChatModel)
        
        tblMain.reloadData()
        if !arrChats.isEmpty{
            tblMain.scrollToRow(at: IndexPath(row: (arrChats.count - 1), section: 0), at: UITableView.ScrollPosition.none, animated: true)
        }
        sendMsg(msg: tfMessage.text ?? "")
    }
    
    func sendMsg(msg : String){
        let params = ["username" : username, "msg" : msg] as [String:Any]
        BaseNetwork.parse(endPoint: "/bot/msg", dataToPost: params, header: [:], instanceTypeToBeDecoded: objChatModel) { (modelChat) in
            DispatchQueue.main.async {
                self.tfMessage.text = ""
                if (modelChat?.status ?? 0) == 1 {
                    if !(modelChat?.options?.isEmpty ?? false){
                        self.tfMessage.text = ""
                        self.arrOptions.removeAll()
                        self.arrOptions = modelChat?.options ?? []
            
                        self.constTblMainHeight.constant = 380
                        self.constHeightCollVwOptions.constant = 60
                        self.collvwOptions.reloadData()
                        UIView.animate(withDuration: 0.3, animations: {
                             self.view.layoutIfNeeded()
                        }, completion: { (_) in
                            self.tblMain.reloadData()
                            if !self.arrChats.isEmpty{
                                self.tblMain.scrollToRow(at: IndexPath(row: (self.arrChats.count - 1), section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
                            }
                            
                        })
                    }
                    else{
                        self.tfMessage.text = ""
                        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: modelChat?.msg ?? "")
                        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.5
                        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                        self.arrOptions.removeAll()
                        self.arrChats.append(modelChat ?? ChatModel())
                        self.constTblMainHeight.constant = 450
                        self.constHeightCollVwOptions.constant = 0
                        UIView.animate(withDuration: 0.3) {
                            self.view.layoutIfNeeded()
                        }
                        self.tblMain.reloadData()
                        if !self.arrChats.isEmpty{
                            self.tblMain.scrollToRow(at: IndexPath(row: (self.arrChats.count - 1), section: 0), at: UITableView.ScrollPosition.none, animated: true)
                        }
                        self.speechSynthesizer.speak(speechUtterance)
                    }
                    
                }
                else{
                    self.constTblMainHeight.constant = 450
                    self.constHeightCollVwOptions.constant = 0
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                    CommonAlert.commonAlert(vc: self, title: "Warning", message: modelChat?.msg ?? "")
                    
                }
            }
        }
    }
}


extension ChatViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objChat = arrChats[indexPath.row]
        if !(objChat.portfolio?.isEmpty ?? false){
            let chartCell = tableView.dequeueReusableCell(withIdentifier: "ChartsTVCell", for: indexPath) as! ChartsTVCell
            chartCell.updateChartData(arrDataSets: objChat.portfolio ?? [])
            return chartCell
        }
        else{
            if (objChat.isMine ?? 1) == 1 {
                let myChatCell = tableView.dequeueReusableCell(withIdentifier: "MyChatTVCell", for: indexPath) as! MyChatTVCell
                myChatCell.lblMsg.text = objChat.msg
                return myChatCell
            }
            else{
                
                let botChatCell = tableView.dequeueReusableCell(withIdentifier: "BotChatTVCell", for: indexPath) as! BotChatTVCell
                botChatCell.lblMsg.text = objChat.msg
                return botChatCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let objChat = arrChats[indexPath.row]
        if !(objChat.portfolio?.isEmpty ?? false){
            return 400
        }
        else{
            return UITableView.automaticDimension
        }
    }
   
}

extension ChatViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("arrOptions.count ===>>>",arrOptions.count)
        if !arrOptions.isEmpty{
            return arrOptions.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCVCell", for: indexPath) as! OptionsCVCell
        cell.viewParent.layer.borderColor = UIColor.black.cgColor
        cell.viewParent.layer.borderWidth = 1.0
        cell.viewParent.layer.cornerRadius = cell.viewParent.frame.height / 2
        cell.lblOption.text = arrOptions[indexPath.row]
        cell.lblOption.adjustsFontSizeToFitWidth = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let myChatModel = ChatModel(status: 1, options: [], isMine: 1, msg: arrOptions[indexPath.row], portfolio: [])
        arrChats.append(myChatModel)

        sendMsg(msg: arrOptions[indexPath.row])
        self.arrOptions.removeAll()
        collvwOptions.reloadData()
        constTblMainHeight.constant = 450
        constHeightCollVwOptions.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            self.tblMain.reloadData()
            if !self.arrChats.isEmpty{
                self.tblMain.scrollToRow(at: IndexPath(row: (self.arrChats.count - 1), section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
            }
            
        })
    }
}

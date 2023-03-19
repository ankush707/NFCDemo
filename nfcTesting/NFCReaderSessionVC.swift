//
//  NFCReaderSessionVC.swift
//  nfcTesting
//
//  Created by Ankush on 26/09/22.
//

import UIKit
import CoreNFC

class NFCReaderSessionVC: UIViewController {
    
    

    
    @IBOutlet weak var lbl: UILabel!
    
    var session: NFCReaderSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonACtion(_ sender: Any) {
        guard NFCNDEFReaderSession.readingAvailable else {

            print("NFC is not available on this device")
            return
          }
        session = NFCTagReaderSession(pollingOption: .pace, delegate: self)
        session?.alertMessage = "Hold your iPhone near the item to learn more about it."
        session?.begin()
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session = nil
    }
}

extension NFCReaderSessionVC: NFCTagReaderSessionDelegate {
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("tagReaderSessionDidBecomeActive")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print("didDetect tags")
    }
}

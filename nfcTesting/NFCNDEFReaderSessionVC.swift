//
//  NFCNDEFReaderSessionVC.swift
//  nfcTesting
//
//  Created by Ankush on 26/09/22.
//

import UIKit
import CoreNFC
import NFCReaderWriter

class NFCNDEFReaderSessionVC: UIViewController {
    

    
    @IBOutlet weak var lbl: UILabel!
    
    var session: NFCNDEFReaderSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonACtion(_ sender: Any) {
        guard NFCNDEFReaderSession.readingAvailable else {

            print("NFC is not available on this device")
            return
          }
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.alertMessage = "Hold your iPhone near the item to learn more about it."
        session?.begin()
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session = nil
    }
}

extension NFCNDEFReaderSessionVC: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("didDetectNDEFs")
    }
    
}

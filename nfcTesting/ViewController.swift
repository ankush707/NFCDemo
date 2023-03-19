//
//  ViewController.swift
//  nfcTesting
//
//  Created by Ankush on 26/09/22.
//

import UIKit
import CoreNFC
import NFCReaderWriter

class ViewController: UIViewController, NFCReaderDelegate {
    func reader(_ session: NFCReader, didInvalidateWithError error: Error) {
        print("ANkush")
    }
    
 
    func reader(_ session: NFCReader, didDetectNDEFs messages: [NFCNDEFMessage]) {
      for message in messages {
        for (i, record) in message.records.enumerated() {
          print("Record \(i+1): \(String(data: record.payload, encoding: .ascii))")
          // other record properties: typeNameFormat, type, identifier
        }
      }
      readerWriter.end()
    }
    
    @IBOutlet weak var lbl: UILabel!
    
    var session: NFCNDEFReaderSession?
    var sessionNFC: NFCReaderSession?
    var sessionTagNFC: NFCTagReaderSession?
    
    let readerWriter = NFCReaderWriter.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonACtion(_ sender: Any) {
//        guard NFCNDEFReaderSession.readingAvailable else {
//
//            print("NFC is not available on this device")
//            return
//          }
//        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
//        session?.alertMessage = "Hold your iPhone near the item to learn more about it."
//        session?.begin()
        readerWriter.newReaderSession(with: self, invalidateAfterFirstRead: false, alertMessage: "Nearby NFC card for read")
        readerWriter.begin()
        self.readerWriter.detectedMessage = "detected NFC Message"
    
    }
    
    @IBAction func button1ACtion(_ sender: Any) {
        let vc: NFCReaderSessionVC = self.storyboard?.instantiateViewController(withIdentifier: "NFCReaderSessionVC") as! NFCReaderSessionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func button2ACtion(_ sender: Any) {
        let vc: NFCTagReaderSessionVC = self.storyboard?.instantiateViewController(withIdentifier: "NFCTagReaderSessionVC") as! NFCTagReaderSessionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func button3ACtion(_ sender: Any) {
        let vc: NFCNDEFReaderSessionVC = self.storyboard?.instantiateViewController(withIdentifier: "NFCNDEFReaderSessionVC") as! NFCNDEFReaderSessionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session = nil
    }
}

extension ViewController: NFCNDEFReaderSessionDelegate {
    
    
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("readerSessionDidBecomeActive")
    }
    
    // MARK: - NFCNDEFReaderSessionDelegate
    func readerSession(
      _ session: NFCNDEFReaderSession,
      didDetect tags: [NFCNDEFTag]
    ) {
      guard
        let tag = tags.first,
        tags.count == 1
        else {
          session.alertMessage = """
            There are too many tags present. Remove all and then try again.
            """
          DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(500)) {
            session.restartPolling()
          }
          return
      }
    }
    
    /// - Tag: processingTagData
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
        guard
            let ndefMessage = messages.first,
            let record = ndefMessage.records.first,
            record.typeNameFormat == .absoluteURI || record.typeNameFormat == .nfcWellKnown,
            let payloadText = String(data: record.payload, encoding: .utf8),
            let sku = payloadText.split(separator: "/").last else {
            return
        }
        
        
        self.session = nil
        
        
    }
    
    
    /// - Tag: endScanning
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        // Check the invalidation reason from the returned error.
        if let readerError = error as? NFCReaderError {
            // Show an alert when the invalidation reason is not because of a success read
            // during a single tag read mode, or user canceled a multi-tag read mode session
            // from the UI or programmatically using the invalidate method call.
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                let alertController = UIAlertController(
                    title: "Session Invalidated",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        // A new session instance is required to read new tags.
        self.session = nil
    }
    
}

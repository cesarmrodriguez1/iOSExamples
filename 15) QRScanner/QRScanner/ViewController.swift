//
//  ViewController.swift
//  QRScanner
//
//  Created by gdaalumno on 04/10/21.
//

import AVFoundation
import UIKit

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return}
        
        let videoInput: AVCaptureDeviceInput
        
        do{
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        }
        catch{
            return
        }
        
        // Declare input stream:
        
        if(captureSession.canAddInput(videoInput)){
            captureSession.addInput(videoInput)
        } else{
            //Something went wrong
            failed()
            return
        }
        
        //Declare output stream:
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if(captureSession.canAddOutput(metadataOutput)){
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            metadataOutput.metadataObjectTypes = [.qr]
        }
        
        else{
            //Handle error
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed(){
        let ac = UIAlertController(title: "Scanning is not supported", message: "Your device does not support scanning a code", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        if(captureSession?.isRunning == false){
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        
        if(captureSession?.isRunning == true){
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first{
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return}
            
            guard let stringValue = readableObject.stringValue else{ return}
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            //What to do with the QR code?
            found(code: stringValue)
        }
        dismiss(animated: true)
    }
    
    func found(code: String){
        let alert = UIAlertController(title: "Alert", message: code, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert,animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}


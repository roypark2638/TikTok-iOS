//
//  CameraViewController.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//
import AVFoundation
import UIKit

class CameraViewController: UIViewController {

    // Capture Session
    var captureSession = AVCaptureSession()
    
    // Capture Device
    var videoCaptureDevice: AVCaptureDevice?
    
    // Capture Output
    var captureOutput = AVCaptureMovieFileOutput()
    
    // Capture Preview
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    
    private let cameraView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    
    private let recordButton = RecordButton()
    
    private var previewLayer: AVPlayerLayer?
    
    var recordedVideoURL: URL?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(cameraView)
        setUpCamera()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
        view.addSubview(recordButton)
        recordButton.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
        let buttonSize: CGFloat = 70
        recordButton.frame = CGRect(
            x: (view.width-buttonSize)/2,
            y: view.height - view.safeAreaInsets.bottom - buttonSize - 10,
            width: buttonSize,
            height: buttonSize
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true

    }
    
    func setUpCamera() {
        // Add devices
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            let audioInput = try? AVCaptureDeviceInput(device: audioDevice)
            if let audioInput = audioInput {
                if captureSession.canAddInput(audioInput) {
                    captureSession.addInput(audioInput)
                }
            }
        }
        
        if let videoDevice = AVCaptureDevice.default(for: .video) {
            if let videoInput = try? AVCaptureDeviceInput(device: videoDevice) {
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                }
            }
        }
        
        // Update session
        captureSession.sessionPreset = .hd1280x720
        if captureSession.canAddOutput(captureOutput) {
            
            captureSession.addOutput(captureOutput)
        }
        
        // Configure preview
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.bounds
        if let layer = capturePreviewLayer {
            cameraView.layer.addSublayer(layer)
        }
        
        // Enable camera start
        captureSession.startRunning()
    }
    
    @objc private func didTapRecord() {
        if captureOutput.isRecording {
            // stop recording
            captureOutput.stopRecording()
            recordButton.toggle(for: .notRecording)
        }
        else {
            // start recording
            guard var url = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask
            ).first else {
                return
            }
            
            url.appendPathComponent("video.mov")
            
            try? FileManager.default.removeItem(at: url)
            
            captureOutput.startRecording(to: url,
                                         recordingDelegate: self)
            recordButton.toggle(for: .recording)
        }
    }
    
    @objc private func didTapClose() {
        recordButton.isHidden = false
        navigationItem.rightBarButtonItem = nil
        if previewLayer != nil {
            // reset the camera
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        }
        else {
            captureSession.stopRunning()
            tabBarController?.tabBar.isHidden = false
            tabBarController?.selectedIndex = 0
        }
    }

}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard error == nil else {
            let alert = UIAlertController(
                title: "Oops..",
                message: "Something went wrong when recording your video",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        recordedVideoURL = outputFileURL
        
        if UserDefaults.standard.bool(forKey: "save_video") {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNext))
        
        print("Finished recording to url: \(outputFileURL.absoluteString)")
        let player = AVPlayer(url: outputFileURL)
        previewLayer = AVPlayerLayer(player: player)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = cameraView.bounds
        guard let previewLayer = previewLayer else { return }
        recordButton.isHidden = true
        
        cameraView.layer.addSublayer(previewLayer)
        previewLayer.player?.play()
    }
    
    @objc func didTapNext() {
        // push caption controller
        guard let url = recordedVideoURL else { return }
        
        let vc = CaptionViewController(videoURL: url)
            navigationController?.pushViewController(vc, animated: true)
        
    }
}

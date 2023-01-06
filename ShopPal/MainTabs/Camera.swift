//
//  Camera.swift
//  ShopPal
//
//  Created by Daniel Ye on 2023-01-06.
//

import Foundation
import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @State private var image: Image?

    func makeUIViewController(context: Context) -> AVCaptureViewController {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        let cameraOutput = AVCapturePhotoOutput()

        let device = AVCaptureDevice.default(for: .video)
        if let input = try? AVCaptureDeviceInput(device: device!) {
            captureSession.addInput(input)
            captureSession.addOutput(cameraOutput)
        }

        let captureViewController = AVCaptureViewController()
        captureViewController.previewLayer = previewLayer

        return captureViewController
    }

    func updateUIViewController(_ uiViewController: AVCaptureViewController, context: Context) {
        uiViewController.takePhoto = {
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            uiViewController.photoOutput.capturePhoto(with: settings, delegate: uiViewController)
        }
        uiViewController.photoCaptureCompletionBlock = { imageData, error in
            if let imageData = imageData {
                self.image = Image(uiImage: UIImage(data: imageData)!)
            }
        }
    }
}

class AVCaptureViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    var previewLayer: AVCaptureVideoPreviewLayer!
    var photoOutput: AVCapturePhotoOutput!
    var takePhoto: (() -> Void)?
    var photoCaptureCompletionBlock: ((Data?, Error?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)

        let takePhotoButton = UIButton(frame: CGRect(x: 100, y: 100, width: 120, height: 50))
        takePhotoButton.setTitle("Take photo", for: .normal)
        takePhotoButton.addTarget(self, action: #selector(takePhoto(_:)), for: .touchUpInside)
        view.addSubview(takePhotoButton)
    }

    @objc func takePhoto(_ sender: Any) {
        takePhoto?()
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            photoCaptureCompletionBlock?(nil, error)
        } else {
            photoCaptureCompletionBlock?(photo.fileDataRepresentation(), nil)
        }
    }
}




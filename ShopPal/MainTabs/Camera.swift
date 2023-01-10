//
//  Camera.swift
//  ShopPal
//
//  Created by Daniel Ye on 2023-01-06.
//

import Foundation
import SwiftUI
import AVFoundation
import UIKit

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

struct CameraView: View {
    // @State private var isShowingImagePicker = false
    // @State private var image: Image?
    @StateObject var camera = CameraModel()

    var body: some View {
        let screenSize: CGRect = UIScreen.main.bounds
        
        ZStack{
            VStack{
                CameraPreview(camera: camera)
                    .ignoresSafeArea()
                    .frame(height: screenSize.height * 0.6)
                
                Color(red: 0.06, green: 0.06, blue: 0.06)
                    .ignoresSafeArea()
            }
            
            VStack {
                Spacer()
                Spacer()
                
                HStack {
                    
                    if camera.isTaken {
                        Spacer()
                        
                        Button(action: {camera.retake()}, label: {
                            Text("Retake")
                                .foregroundColor(.gray)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 5)
                                .padding(.bottom, 20)
                        })
                        
                        Button(action: {if !camera.isSent{camera.sendImage()}}, label: {
                            Text("Save Receipt")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color(red: 0.08, green: 0.64, blue: 0.15))
                                .clipShape(Capsule())
                                .padding(.bottom, 20)
                        })
                        .padding(.leading)
                        .padding(.trailing)
                        .alert(isPresented: $camera.sentSuccess) {
                                                    Alert(title: Text("Success!"), message: Text("Your receipt has been successfully scanned and saved."),
                                                          dismissButton: .default(Text("Dismiss")))
                                                }
                    }
                    else {
                        Button(action: camera.takePic, label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 60, height: 60)
                                    .padding(.bottom, 15)
                                
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 70, height: 70)
                                    .padding(.bottom, 15)
                            }
                        })
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear(perform: {
            camera.Check()
        })
        
        /*
        VStack {
            image?
                .resizable()
                .scaledToFit()
            Button(action: {
                self.isShowingImagePicker = true
            }) {
                Text("Take photo")
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: self.$image)
        }
         */
    }
}

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview = AVCaptureVideoPreviewLayer()
    @Published var isSent = false
    @Published var picData = Data(count: 0)
    @Published var sentSuccess = false
    
    func Check(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func setUp() {
        do {
            self.session.beginConfiguration()
            let device = AVCaptureDevice.default(for: .video)
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
                
            }
            
            self.session.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func takePic() {
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.session.stopRunning()
            
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
            }
        }
    }
    
    func retake() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
                self.isSent = false
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            return
        }
        guard let imageData = photo.fileDataRepresentation() else {return}
        self.picData = imageData
    }
    
    func sendImage() {
            let image = UIImage(data: self.picData)
            self.isSent = true
            
            if self.sentSuccess == true {
                self.sentSuccess = false
            }
            
            let imageData: Data = image!.jpegData(compressionQuality: 0.5)!
            
            let url = URL(string: "https://www.wangevan.com/receipt/test/add2")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = createBody(parameters: ["password": globalPass, "email": globalEmail],
                                            boundary: boundary,
                                            data: imageData,
                                            mimeType: "image/jpeg",
                                            filename: "image.jpg")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("error: \(error)")
                    return
                }
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                    DispatchQueue.main.async {
                        self.sentSuccess = true
                    }
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("data: \(dataString)")
                }
            }
            task.resume()
        }
    
    func createBody(parameters: [String: String],
                        boundary: String,
                        data: Data,
                        mimeType: String,
                        filename: String) -> Data {
            let body = NSMutableData()
            
            let boundaryPrefix = "--\(boundary)\r\n"
            
            for (key, value) in parameters {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
            
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: \(mimeType)\r\n\r\n")
            body.append(data)
            body.appendString("\r\n")
            body.appendString("--".appending(boundary.appending("--")))
            
            return body as Data
        }
    }

struct CameraPreview : UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // this needs to be here for some reason but never used
    }
}

/*
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: Image?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: Image?
        var parent: ImagePicker

        init(image: Binding<Image?>, parent: ImagePicker) {
            _image = image
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                image = Image(uiImage: uiImage)
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image, parent: self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
}
*/

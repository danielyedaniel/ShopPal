//
//  Camera.swift
//  ShopPal
//
//  Created by Daniel Ye on 2023-01-06.
//

import Foundation
import SwiftUI
import AVFoundation

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
                    .frame(height: screenSize.height * 0.75)
                
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
        let image = UIImage(data: self.picData)!
        self.isSent = true
        
        //SEND IMAGE TO API SOMEHOW
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

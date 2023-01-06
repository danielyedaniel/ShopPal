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
    @State private var isShowingImagePicker = false
    @State private var image: Image?

    var body: some View {
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
    }
}

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



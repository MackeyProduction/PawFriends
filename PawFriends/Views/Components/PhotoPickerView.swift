//
//  PhotoPickerView.swift
//  PawFriends
//
//  Created by Hanna Steffen on 15.06.24.
//

import SwiftUI
import PhotosUI

final class PhotoPickerViewModel: ObservableObject {
    enum ImageState {
            case empty
            case loading(Progress)
            case success(Image)
            case failure(Error)
        }
    @Published private(set) var imageState: ImageState = .empty
    @Published private(set) var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    @Published private(set) var selectedImages: [UIImage] = []
    @Published var imageSelections: [PhotosPickerItem] = [] {
        didSet {
            setImages(from: imageSelections)
        }
    }
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            do {
                let data = try await selection.loadTransferable(type: Data.self)
                
                guard let data, let uiImage = UIImage(data: data) else {
                    throw URLError(.badServerResponse)
                }
                selectedImage = uiImage
            } catch {
                print(error)
            }
            
        }
    }
    
    private func setImages(from selections: [PhotosPickerItem]) {
        Task {
            var images: [UIImage] = []
            for selection in selections {
                if let data = try? await selection.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        images.append(uiImage)
                    }
                }
            }
            
            selectedImages = images
        }
    }
}

struct PhotoPickerView: View {
    
@StateObject private var viewModel = PhotoPickerViewModel()

    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        if let image = viewModel.selectedImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .cornerRadius(10)
        }
        PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
            Image(systemName: "photo.badge.plus")
            Text("Select Image")
                .foregroundStyle(.black)
        }
        
        if !viewModel.selectedImages.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.selectedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .cornerRadius(10)
                    }
                }
            }
            
            SliderView(images: viewModel.selectedImages)
        }
        PhotosPicker(selection: $viewModel.imageSelections, matching: .images) {
            Image(systemName: "photo.badge.plus")
            Text("Select Images")
                .foregroundStyle(.black)
        }

    }
    
}

struct PickPhotoButton: View
{
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 120, height: 30)
            .foregroundStyle(.black)
            .opacity(0.6)
            .overlay(alignment: .center) {
                HStack{
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                    Text("Hinzufügen")
                        .foregroundStyle(.white)
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }
    }
}



struct TabIcon: View {
    var icon: UIImage
    var size: CGSize = CGSize(width: 50, height: 50)

    // Based on https://stackoverflow.com/a/32303467
    var roundedIcon: UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        defer {
            // End context after returning to avoid memory leak
            UIGraphicsEndImageContext()
        }

        UIBezierPath(
            roundedRect: rect,
            cornerRadius: 10
            ).addClip()
        icon.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    var body: some View {
        Image(uiImage: roundedIcon.withRenderingMode(.alwaysOriginal))
    }
}


#Preview {
    PhotoPickerView()
}

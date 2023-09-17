//
//  ImageListViewModel.swift
//  Assignment
//
//  Created by Ravi Singh on 15/09/23.
//

import Foundation
import Combine
import UIKit
import Toast_Swift

class ImageListViewModel: ObservableObject {
    
    @Published private(set) var loading = false
    @Published private(set) var errorMessage = ""
    @Published private(set) var loadingMore = false
    private var cancellable = Set<AnyCancellable>()
    @Published private(set) var images = [ImageData]()
    @Published private(set) var offlineImages = [OfflineImage]()    
    private(set) var isBusyLoading = false
    private(set) var pageCount = 1
    
    
    func getImageList(isLoadMore: Bool = false) {
        if isBusyLoading { return }
        isBusyLoading = true
        
        if isLoadMore {
            pageCount += 1
            loadingMore = true
        } else {
            pageCount = 1
            loading = true
        }
        NetworkManager.request(method: .get, payload: ["page": String(pageCount), "per_page": "10"], responseEncoder: [ImageData]?.self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] received in
                guard let self = self else {return}
                self.isBusyLoading = false
                if isLoadMore {
                    self.loadingMore = false
                } else {
                    self.loading = false
                }
                switch received {
                case .finished:
                    debugPrint("done")
                case .failure(let e):
                    self.errorMessage = e.localizedDescription
                    debugPrint(e.localizedDescription)
                }
                
            } receiveValue: { [weak self] receivedValue in
                guard let self = self else { return }
                guard let image = receivedValue else {
                    self.errorMessage = "Something went wrong while!"
                    return
                }
                
                if isLoadMore == true {
                    self.images.append(contentsOf: image)
                    
                    self.downloadImages()
                    
                } else {
                    self.images = image
                    
                    self.downloadImages()
        
                }
                
            }
            .store(in: &cancellable)
    }
    
    // MARK: - Download image from url
    func downloadImages() {
        offlineImages = []
        
        for imageUrlString in images {
            guard let imageUrl = URL(string: imageUrlString.previewURL ?? "") else {
                continue
            }
            
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let error = error {
                    print("Error downloading image: \(error)")
                } else if let data = data {
                    DispatchQueue.main.async {
                        DatabaseHelper.shared.saveImage(id: imageUrlString.id ?? 0, image: data)
                        self.getDownloadedImage()
                    }
                    
                
                }
            }.resume()
        }
    }

    // MARK: - Get image from core data
    
    func getDownloadedImage() {
        
        let images = DatabaseHelper.shared.getImages()
        for i in images {
            let img = UIImage(data: i.img ?? Data())
            self.offlineImages.append(OfflineImage(id: Int(i.id), image: img))
        }
 
    }
    
}

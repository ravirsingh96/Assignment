//
//  ImageListVC.swift
//  Assignment
//
//  Created by Ravi Singh on 15/09/23.
//

import UIKit
import Combine
import SDWebImage
import Reachability
import Toast_Swift

class ImageListVC: UIViewController {
    
    @IBOutlet weak var imageTV: UITableView!
    
    var viewModel = ImageListViewModel()
    
    private var cancellable = Set<AnyCancellable>()
    private var loader = UIActivityIndicatorView()
    let reachability = try! Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: Notification.Name.reachabilityChanged, object: reachability)
             
             do {
                 try reachability.startNotifier()
             } catch {
                 print("Unable to start reachability notifier")
             }
 
        imageTV.register(UINib(nibName: ImageListTVC.nibName, bundle: nil), forCellReuseIdentifier: ImageListTVC.reuseIdentifier)
        configureViewModel()
        loader = UIActivityIndicatorView(style: .medium)
        loader.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: imageTV.bounds.width, height: CGFloat(44))
        self.imageTV.tableFooterView = loader
    }
    
    deinit {
           reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
       }

       @objc func reachabilityChanged() {
           if reachability.connection != .unavailable {
               viewModel.getImageList()
               imageTV.reloadData()
           } else {
               viewModel.getDownloadedImage()
               imageTV.reloadData()
           }
       }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset
        
        if distanceFromBottom < height {
            print("You reached end of the table")
            viewModel.getImageList(isLoadMore: true)
        }
   
    }
    
    // MARK: - IBAction
    
    @IBAction func profileBtnTapped(_ sender: UIButton) {
        
        navigationController?.pushViewController(ViewControllerHelper.getObjectOf(of: .profileVC), animated: true)
    }
    
    // MARK: - Configure view Model
    
    private func configureViewModel() {
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self = self, !errorMessage.isEmpty else { return }
                self.view.hideAllToasts()
                self.view.makeToast(errorMessage)
            }
            .store(in: &cancellable)
        
        viewModel.$loading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in
                guard let self = self else { return }
                self.view.hideToastActivity()
                if loading {
                    self.view.makeToastActivity(.center)
                    
                }
            }
            .store(in: &cancellable)
        viewModel.$images
            .receive(on: DispatchQueue.main)
            .sink { [weak self] received in
                self?.view.hideToastActivity()
                self?.imageTV.reloadData()
            }
            .store(in: &cancellable)
        
        viewModel.$loadingMore
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loadingMore in
                guard let self = self else { return }
                if loadingMore {
                    self.loader.startAnimating()
                    self.imageTV.tableFooterView?.isHidden = false
                    self.imageTV.tableFooterView = self.loader
                    
                } else {
                    self.loader.stopAnimating()
                    self.imageTV.tableFooterView?.isHidden = true
                    self.imageTV.tableFooterView = nil
                }
            }
            .store(in: &cancellable)
        
        viewModel.$offlineImages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] received in
                self?.imageTV.reloadData()
            }
            .store(in: &cancellable)

    }
    
}

// MARK: - Table view data source and delegate

extension ImageListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reachability.connection != .unavailable {
            return viewModel.images.count
        } else {
            return viewModel.offlineImages.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = imageTV.dequeueReusableCell(withIdentifier: ImageListTVC.reuseIdentifier, for: indexPath) as! ImageListTVC
        if reachability.connection != .unavailable {
            let items = viewModel.images[indexPath.row]
            cell.dummyImage.sd_setImage(with: URL(string: items.previewURL ?? ""))
        } else {
            let item = viewModel.offlineImages[indexPath.row]
            cell.dummyImage.image = item.image
        }
        return cell
        
    }
    
    
    
    
}

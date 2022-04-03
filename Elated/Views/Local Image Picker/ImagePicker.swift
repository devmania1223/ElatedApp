//
//  ImagePicker.swift
//  Elated
//
//  Created by Marlon on 5/7/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Photos
import RxRelay

class ImagePicker: NSObject {
    
    private var flag: AnyObject? // anything that can help distinguish the image selected
    
    var callback: ((UIImage?) -> Void)?
    var authorizedCallback: ((Bool) -> Void)?
    
    internal func showOptions(_ anchor: UIView, callback: ((UIImage?) -> Void)?) {
    
        let alert = UIAlertController(title: "photo.camera.title".localized,
                                      message: "photo.camera.message".localized,
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "photo.camera.camera".localized,
                                      style: .default,
                                      handler: { [weak self] action in
            self?.getPermissionCameraImage(callback)
        }))
        
        alert.addAction(UIAlertAction(title: "photo.camera.photoAlbum".localized,
                                      style: .default,
                                      handler: { [weak self] action in
            self?.getPermissionLibraryImage(callback)
        }))
        
        alert.addAction(UIAlertAction(title: "common.cancel".localized,
                                      style: .cancel,
                                      handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = anchor
            alert.popoverPresentationController?.sourceRect = anchor.bounds
            alert.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    
    }
    
    func getPermissionCamera(_ authorizedCallback: ((Bool) -> Void)?) {
        self.authorizedCallback = authorizedCallback
        let vc = UIApplication.topViewController()
        let authorization = AVCaptureDevice.authorizationStatus(for: .video)
        switch authorization {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async { [weak self] in
                    if granted {
                        self?.authorizedCallback?(true)
                    } else {
                        vc?.presentAlert(title: "", message: "camera.permission.denied".localized)
                        self?.authorizedCallback?(false)
                    }
                }
            }
            break
        case .denied:
            vc?.presentAlert(title: "", message: "camera.permission.denied".localized)
            self.authorizedCallback?(false)
            break
        case .authorized:
            //already authorized
            self.authorizedCallback?(true)
            break
        default:
            break
        }
        
    }
    
    func getPermissionCameraImage(_ callback: ((UIImage?) -> Void)?) {
        self.callback = callback
        let vc = UIApplication.topViewController()
        let authorization = AVCaptureDevice.authorizationStatus(for: .video)
        switch authorization {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async { [weak self] in
                    if granted {
                        self?.getCameraImage()
                    } else {
                        vc?.presentAlert(title: "", message: "camera.permission.denied".localized)
                    }
                }
            }
            break
        case .denied:
            vc?.presentAlert(title: "", message: "camera.permission.denied".localized)
            break
        case .authorized:
            //already authorized
            getCameraImage()
            break
        default:
            break
        }
        
    }
    
    func getPermissionLibraryImage(_ callback: ((UIImage?) -> Void)?) {
        self.callback = callback
        let vc = UIApplication.topViewController()
        let authorization = PHPhotoLibrary.authorizationStatus()
        switch authorization {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                DispatchQueue.main.async { [weak self] in
                    if status == .authorized {
                        self?.getLibraryImage()
                    } else {
                        vc?.presentAlert(title: "", message: "photo.permission.denied".localized)
                    }
                }
            }
            break
        case .denied:
            vc?.presentAlert(title: "", message: "photo.permission.denied".localized)
            break
        case .authorized:
            //already authorized
            getLibraryImage()
            break
        default:
            break
        }
        
    }
    
    private func getCameraImage() {
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            imagePickerController.cameraCaptureMode = .photo
            UIApplication.topViewController()?.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    private func getLibraryImage() {
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.modalPresentationStyle = .fullScreen
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            UINavigationBar.appearance().setBackgroundImage(nil, for: .default)
            UIApplication.topViewController()?.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- UIImagePickerViewDelegate.
     func imagePickerController(_ picker: UIImagePickerController,
                                didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        picker.dismiss(animated: true, completion: { [weak self] in
            self?.callback?(info[.originalImage] as? UIImage)
        })
     }

     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        picker.dismiss(animated: true, completion: nil)
     }
    
}

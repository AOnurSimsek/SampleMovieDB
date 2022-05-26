//
//  UIViewControllerExtensions.swift
//  MovieDBSample
//
//  Created by Onur Şimşek on 25.05.2022.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(erroType: serviceErrors ) {
        let alert = UIAlertController(title: "Error", message: erroType.description, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(erroType: serviceErrors,
                   retryAction: ((UIAlertAction)->Void)? ) {
        let alert = UIAlertController(title: "Error", message: erroType.description, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: retryAction))
        self.present(alert, animated: true, completion: nil)
    }
}

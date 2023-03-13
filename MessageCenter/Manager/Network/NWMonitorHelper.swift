//
//  ToastView.swift
//  MessageCenter
//
//  Created by usr Alan Taichung 2023/3/13.
//

import UIKit


class NWMonitorHelper {
    // MARK: - Properties
    static let shared = NWMonitorHelper()
    private var toastView = ToastView()
    
    // MARK: - Function
    @discardableResult
    public func show(title: String) -> Bool {
        guard var topController = UIApplication.shared.windows
            .first(where: { $0.isKeyWindow })?.rootViewController else { return false }
        while let presented = topController.presentedViewController {
            topController = presented
        }
        guard let view = topController.view else { return false }
        
        view.addSubview(toastView)
        view.bringSubviewToFront(toastView)
        toastView.backgroundColor = .peachy
        toastView.clipsToBounds = true
        toastView.layer.cornerRadius = 10
        toastView.title = title
        toastView.snp.makeConstraints {
            $0.bottom.equalTo(view).offset(screenWidth * (40/375))
            $0.left.right.equalTo(view).inset(screenWidth * (20/375))
            $0.height.equalTo(screenWidth * (40/375))
        }
                
        UIView.animate(withDuration: 0) { [toastView] in
            toastView.isHidden = false
            toastView.snp.updateConstraints {
                $0.bottom.equalTo(view).offset(-screenWidth * (30/375))
            }
            view.layoutIfNeeded()
        }
        
        hideToast(view, duration: 0.5, delayTime: 3)
        return true
    }
    
    public func hideToast(_ superView: UIView, duration: TimeInterval, delayTime: TimeInterval) {
        UIView.animate(withDuration: duration, delay: delayTime) { [toastView] in
            toastView.snp.updateConstraints {
                $0.bottom.equalTo(superView).offset(screenWidth * (40/375))
            }
            superView.layoutIfNeeded()
        } completion: { [toastView] finished in
            if finished {
                toastView.isHidden = true
            }
        }
    }
    
}

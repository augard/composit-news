//
//  ViewController.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 25.02.2021.
//

import UIKit
import MessageUI
import SafariServices

extension UIViewController {

    typealias Callback = () -> Void

    var masterView: UIView {
        tabBarItem.title != nil ? view : view.window ?? view
    }

    /// show default error alert, localization keys are expected
    func show(error: Error, title: String = "Error") {
        if let error = error as? LocalizedError {
            showAlert(title: title, message: error.errorDescription)
        } else {
            showAlert(title: title, message: error.localizedDescription)
        }
    }

    /// show alert, localization keys are expected
    func showAlert(title: String = "Error", message: String? = nil, okTitle: String = "OK", okHandler: Callback? = nil) {
        let alertController = UIAlertController(
            title: title,
            message: message ?? "",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: okTitle, style: .default, handler: { _ in okHandler?() }))
        present(alertController, animated: true)
    }

    /// show alert, localization keys are expected
    func showActionAlert(title: String = "Error", message: String? = nil,
                         okTitle: String = "OK", okHandler: Callback?,
                         cancelTitle: String = "Cancel", cancelHandler: Callback?) {
        let alertController = UIAlertController(
            title: title,
            message: message ?? "",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: okTitle, style: .default, handler: { _ in okHandler?() }))
        alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { _ in cancelHandler?() }))
        present(alertController, animated: true)
    }

    private static let ProgressTag = 42

    /// shows overlay over current UIViewController's window, if it has one
    func showProgress() {
        hideProgress()

        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.tag = Self.ProgressTag
        masterView.addSubview(overlay)
        overlay.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        overlay.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
    }

    /// hide overlay if it has one
    func hideProgress() {
        masterView.subviews.first { $0.tag == Self.ProgressTag }?.removeFromSuperview()
    }

    func dismiss() {
        let presentationController = self.presentationController ?? self.navigationController?.presentationController
        let delegate = self.presentationController?.delegate ?? self.navigationController?.presentationController?.delegate

        dismiss(animated: true, completion: {
            guard let presentationController = presentationController, let delegate = delegate else { return }
            delegate.presentationControllerDidDismiss?(presentationController)
        })
    }

    func openURL(URL: URL) {
        if ["http", "https"].contains(URL.scheme) {
            present(SFSafariViewController(url: URL), animated: true)
        } else if URL.scheme == "mailto", MFMailComposeViewController.canSendMail() {
            let controller = MFMailComposeViewController()
            controller.setToRecipients([URL.absoluteString.replacingOccurrences(of: "mailto:", with: "")])
            present(controller, animated: true, completion: nil)
        } else {
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        }
    }

}

extension UIViewController: UIAdaptivePresentationControllerDelegate {

    public func presentationControllerDidDismiss( _ presentationController: UIPresentationController) {
        viewWillAppear(true)
    }

}

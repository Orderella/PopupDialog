//
//  ViewController.swift
//
//  Copyright (c) 2016 Orderella Ltd. (http://orderella.co.uk)
//  Author - Martin Wildfeuer (http://www.mwfire.de)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import PopupDialog

class ViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var label: UILabel!

    // MARK: Actions

    @IBAction func showImageDialogTapped(_ sender: UIButton) {
        showImageDialog()
    }

    @IBAction func showStandardDialogTapped(_ sender: UIButton) {
        showStandardDialog()
    }

    @IBAction func showCustomDialogTapped(_ sender: UIButton) {
        showCustomDialog()
    }

    // MARK: Popup Dialog examples

    /*!
     Displays the default dialog with an image on top
     */
    func showImageDialog(animated: Bool = true) {

        // Prepare the popup assets
        let title = "THIS IS THE DIALOG TITLE"
        let message = "This is the message section of the PopupDialog default view"
        let image = UIImage(named: "colorful")

        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image, preferredWidth: 580)

        // Create first button
        let buttonOne = CancelButton(title: "CANCEL") { [weak self] in
            self?.label.text = "You canceled the image dialog"
        }
        
        // Create fourth (shake) button
        let buttonTwo = DefaultButton(title: "SHAKE", dismissOnTap: false) { [weak popup] in
            popup?.shake()
        }

        // Create second button
        let buttonThree = DefaultButton(title: "OK") { [weak self] in
            self?.label.text = "You ok'd the image dialog"
        }

        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo, buttonThree])

        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }

    /*!
     Displays the default dialog without image, just as the system dialog
     */
    func showStandardDialog(animated: Bool = true) {

        // Prepare the popup
        let title = "THIS IS A DIALOG WITHOUT IMAGE"
        let message = "If you don't pass an image to the default dialog, it will display just as a regular dialog. Moreover, this features the zoom transition"

        // Create the dialog
        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                tapGestureDismissal: true,
                                panGestureDismissal: true,
                                hideStatusBar: true) {
            print("Completed")
        }

        // Create first button
        let buttonOne = CancelButton(title: "CANCEL") {
            self.label.text = "You canceled the default dialog"
        }

        // Create second button
        let buttonTwo = DefaultButton(title: "OK") {
            self.label.text = "You ok'd the default dialog"
        }

        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])

        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }

    /*!
     Displays a custom view controller instead of the default view.
     Buttons can be still added, if needed
     */
    func showCustomDialog(animated: Bool = true) {

        // Create a custom view controller
        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)

        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            self.label.text = "You canceled the rating dialog"
        }

        // Create second button
        let buttonTwo = DefaultButton(title: "RATE", height: 60) {
            self.label.text = "You rated \(ratingVC.cosmosStarRating.rating) stars"
        }

        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])

        // Present dialog
        present(popup, animated: animated, completion: nil)
    }
}

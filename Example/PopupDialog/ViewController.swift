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

    @IBOutlet weak var kittenLabel: UILabel!

    // MARK: Actions

    @IBAction func showKittenDialogTapped(sender: UIButton) {
        showKittenDialog()
    }

    @IBAction func showOtherDialogTapped(sender: UIButton) {
        showKittenGoneDialog()
    }

    // MARK: Popup Dialog examples

    func showKittenDialog() {

        // Prepare the popup assets
        let title = "THIS IS THE CUTE CAT DIALOG"
        let message = "The above image shows a cute little christmas kitten, in case you don't know kitten. Or Santa.\nSo, what to do next?"
        let image = UIImage(named: "santa_cat")

        // Create the dialog
        let alert = PopupDialog(title: title, message: message, image: image)

        // Create first button
        let buttonOne = CancelButton(title: "CANCEL CAT") {
            self.kittenLabel.text = "You canceled the cat. Whatever that means..."
        }

        // Create second button
        let buttonTwo = DefaultButton(title: "PLAY WITH CAT") {
            self.kittenLabel.text = "Phew, that was exhausting!"
        }

        // Create third button
        let buttonThree = DefaultButton(title: "PET CAT") {
            self.kittenLabel.text = "The cat purrs happily :)"
        }

        // Add buttons to dialog
        alert.addButtons([buttonOne, buttonTwo, buttonThree])

        // Present dialog
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func showKittenGoneDialog() {

        // Prepare the popup assets
        let title = "Where's the kitten?".uppercaseString
        let message = "It seems there is no kitten in this dialog.\nHave you seen it anywhere?"

        // Create the dialog
        let alert = PopupDialog(title: title, message: message, buttonAlignment: .Horizontal)

        // Create first button
        let buttonOne = CancelButton(title: "NO") {
            self.kittenLabel.text = "Oh noes :("
        }

        // Create second button
        let buttonTwo = DefaultButton(title: "YES") {
            self.kittenLabel.text = "Ah! It's in the other dialog, isn't it?"
        }

        // Add buttons to dialog
        alert.addButtons([buttonOne, buttonTwo])

        // Present dialog
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

//
//  CategoriesPickerViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 29.11.2021.
//


import UIKit

class CategoriesPickerViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var dataPicker: UIPickerView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var dataProvider: PickerDataProvider!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelButtonDidTap))
        view.addGestureRecognizer(tapGestureRecognizer)
        configurePicker()
        configureContainerView()
    }

    // MARK: - Actions
    @IBAction func cancelButtonDidTap() {
        dismiss(animated: false) {
            self.dataProvider.cancelPressed()
        }
    }
    
    @IBAction func pickButtonDidTap() {
        dismiss(animated: false) {
            self.dataProvider.donePressed(with: self.dataPicker.selectedRow(inComponent: 0))
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension CategoriesPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dataProvider.rowsCount()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        dataProvider.titleForRow(at: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        35
    }
}

// MARK: - Private methods
private extension CategoriesPickerViewController {
    func configureContainerView() {
        containerView.layer.cornerRadius = 10
    }

    func configurePicker() {
        dataPicker.delegate = self
        dataPicker.dataSource = self
    }
}

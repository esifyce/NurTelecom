//
//  PDFPreviewViewer.swift
//  NotePad MVC Pattern
//
//  Created by inputlagged on 8/22/22.
//

import UIKit
import PDFKit

final class PDFPreviewViewer: UIViewController {
    
    // MARK: - let/var
    
    public var documentData: Data?
    
    private lazy var previewView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = .clear
        return uiView
    }()
    
    private var pdfView: PDFView = {
        let pdf = PDFView()
        pdf.backgroundColor = .clear
        pdf.translatesAutoresizingMaskIntoConstraints = false
        pdf.minScaleFactor = pdf.scaleFactorForSizeToFit
        return pdf
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Preview"
        view.backgroundColor = .white
        setupViews()
        setupPrintButton()
        
        if let data = documentData {
            pdfView.document = PDFDocument(data: data)
            pdfView.autoScales = true
        }
    }

    // MARK: - Helpers
    
    private func setupViews() {
        view.addSubview(previewView)
        
        NSLayoutConstraint.activate([
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            previewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        previewView.addSubview(pdfView)
    
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: previewView.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: previewView.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: previewView.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: previewView.bottomAnchor)
        ])
    }
    
    private func setupPrintButton() {
        let printImage = UIImage(systemName: "printer")
        let printButton = UIBarButtonItem(image: printImage, style: .plain, target: self, action: #selector(printButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = printButton
    }
    
    @objc private func printButtonPressed(_ sender: UIBarButtonItem) {
        let printController = UIPrintInteractionController.shared
        printController.printingItem = documentData
        printController.present(animated: true)
    }
}

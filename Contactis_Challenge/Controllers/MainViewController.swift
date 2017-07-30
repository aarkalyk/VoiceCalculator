//
//  MainViewController.swift
//  Contactis_Challenge
//
//  Created by ARKALYK AKASH on 7/30/17.
//  Copyright © 2017 ARKALYK AKASH. All rights reserved.
//

import Speech
import UIKit
import Neon

class MainViewController: UIViewController {
    //MARK: - Properties
    private lazy var elasticOvalView : ElasticOvalView = {
        let view = ElasticOvalView()
        view.expressionText = Hints.expressionPlaceHolderText
        view.delegate = self
        return view
    }()
    
    private lazy var recordButton : RecordButton = {
        let button = RecordButton()
        button.setImage(#imageLiteral(resourceName: "mic"), for: .normal)
        button.addTarget(self, action: #selector(recordButtonPressed), for: .touchDown)
        button.addTarget(self, action: #selector(recordButtonReleased), for: .touchUpInside)
        button.addTarget(self, action: #selector(recordButtonReleased), for: .touchUpOutside)
        return button
    }()
    
    lazy var instructionsLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = Hints.recordInstructionText
        label.font = UIFont.SFRegular(ofSize: 20)
        label.textAlignment = .center
        label.textColor = UIColor.customGray
        return label
    }()
    
    private let calculator = Calculator()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Initial setup
    private func setup(){
        self.view.backgroundColor = .white
        requestAccess()
        setupSubviews()
    }
    
    private func setupSubviews(){
        view.addSubview(instructionsLabel)
        view.addSubview(elasticOvalView)
        view.addSubview(recordButton)
        updateViewConstraints()
    }
    
    //MARK: - Constraints
    override func updateViewConstraints() {
        super.updateViewConstraints()
        elasticOvalView.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: Sizes.compressedViewHeight)
        elasticOvalView.updateConstraints()
        instructionsLabel.anchorInCenter(width: Sizes.screenWidth - 20.0, height: AutoHeight)
        recordButton.anchorToEdge(.bottom, padding: 20, width: Sizes.recordButtonWidth, height: Sizes.recordButtonWidth)
        recordButton.updateConstraints()
    }
    
    //MARK: - Button actions
    func recordButtonPressed(){
        startRecording()
        showInstructions()
        instructionsLabel.text = Hints.stopInstructionText
        elasticOvalView.compressView()
        elasticOvalView.expressionText = Hints.expressionRecordingText
    }
    
    func recordButtonReleased(){
        elasticOvalView.expressionText = Hints.computingText
        instructionsLabel.text = Hints.computingInstructionText
        showInstructions()
        stopRecording()
        self.recordButton.isEnabled = false
    }
    
    //MARK: - Speech recognition
    private func startRecording(){
        MySpeechRecognizer.shared.startRecordingWith { (expressionString) in
            OperationQueue.main.addOperation() {
                if let expression = expressionString{
                    self.elasticOvalView.expressionText = "\(expression) = "
                    self.elasticOvalView.resultText = self.calculator.calculate(inputString: expression)
                    self.elasticOvalView.expandView()
                    self.hideInstructions()
                }else{
                    self.elasticOvalView.compressView()
                    self.elasticOvalView.expressionText = Hints.errorText
                    self.instructionsLabel.text = Hints.errorInstructionText
                    self.showInstructions()
                }
                self.recordButton.isEnabled = true
            }
        }
    }
    
    private func stopRecording(){
        MySpeechRecognizer.shared.audioEngine.stop()
        MySpeechRecognizer.shared.recognitionRequest?.endAudio()
    }
    
    func requestAccess(){
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .authorized: break
            case .denied: print("User denied access to speech recognition")
            case .restricted: print("Speech recognition restricted on this device")
            case .notDetermined: print("Speech recognition not yet authorized")
            }
        }
    }
    
    //MARK: - Helper methods
    func hideInstructions(){
        UIView.animate(withDuration: 0.3) {
            self.instructionsLabel.alpha = 0
        }
    }
    
    func showInstructions(){
        UIView.animate(withDuration: 0.3) {
            self.instructionsLabel.alpha = 1.0
        }
    }
}

//MARK: - ElasticOvalView delegate
extension MainViewController: ElasticOvalViewDelegate{
    func didCollapse(elasticView: ElasticOvalView) {
        elasticView.expressionText = Hints.expressionPlaceHolderText
        instructionsLabel.text = Hints.recordInstructionText
        showInstructions()
    }
}

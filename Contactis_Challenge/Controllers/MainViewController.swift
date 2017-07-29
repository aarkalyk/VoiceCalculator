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

class MainViewController: UIViewController, SFSpeechRecognizerDelegate {
    //MARK: - Properties
    private lazy var elasticOvalView : ElasticOvalView = {
        let view = ElasticOvalView()
        view.expressionText = Hints.expressionPlaceHolderText
        return view
    }()
    
    private lazy var recordButton : RecordButton = {
        let button = RecordButton()
        button.setImage(#imageLiteral(resourceName: "mic"), for: .normal)
        button.addTarget(self, action: #selector(recordButtonTapped), for: .touchDown)
        return button
    }()
    
    private lazy var instructionsLabel : UILabel = {
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
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.recordButton.isEnabled = isButtonEnabled
            }
        }
        MySpeechRecognizer.shared.speechRecognizer?.delegate = self
        
        setupSubviews()
    }
    
    private func setupSubviews(){
        view.addSubview(elasticOvalView)
        view.addSubview(instructionsLabel)
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
    func recordButtonTapped(){
        if MySpeechRecognizer.shared.audioEngine.isRunning {
            elasticOvalView.expressionText = Hints.computingText
            instructionsLabel.text = Hints.stopInstructionText
            showInstructions()
            recordButton.setImage(#imageLiteral(resourceName: "mic"), for: .normal)
            MySpeechRecognizer.shared.audioEngine.stop()
            MySpeechRecognizer.shared.recognitionRequest?.endAudio()
        } else {
            startRecording()
            showInstructions()
            instructionsLabel.text = Hints.recordInstructionText
            recordButton.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
            elasticOvalView.compressView()
            elasticOvalView.expressionText = Hints.expressionRecordingText
        }
    }
    
    //MARK: - Speech recognition
    private func startRecording(){
        MySpeechRecognizer.shared.startRecordingWith { (expressionString) in
            DispatchQueue.main.async {
                if let expression = expressionString{
                    self.elasticOvalView.expressionText = "\(expression) = "
                    self.elasticOvalView.resultText = "\(self.calculator.calculate(inputString: expression))"
                    self.elasticOvalView.expandView()
                    self.hideInstructions()
                }else{
                    self.elasticOvalView.compressView()
                    self.elasticOvalView.expressionText = Hints.errorText
                    self.instructionsLabel.text = Hints.errorInstructionText
                    self.recordButton.setImage(#imageLiteral(resourceName: "mic"), for: .normal)
                    self.showInstructions()
                }
            }
        }
    }
    
    //MARK: - Helper methods
    private func hideInstructions(){
        UIView.animate(withDuration: 0.3) {
            self.instructionsLabel.alpha = 0
        }
    }
    
    private func showInstructions(){
        UIView.animate(withDuration: 0.3) {
            self.instructionsLabel.alpha = 1.0
        }
    }
}

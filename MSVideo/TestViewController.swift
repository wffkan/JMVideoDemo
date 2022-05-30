//
//  TestViewController.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/5/27.
//

import UIKit
import CoreMedia


public protocol TrafficLightOption {
    associatedtype Value
    
    static var defaultValue: Value  {get}
}

public class TrafficLight {
    
    public enum State {
        case stop
        case proceed
        case caution
    }
    
    private var options = [ObjectIdentifier: Any]()
    
    public var onStateChanged: ((State) -> Void)?
    
    public var stopDuration = 4.0
    public var proceedDuration = 6.0
    public var cautionDuration = 1.5
    
    private var timer: Timer?
    
    public private(set) var state: State = .stop {
        didSet {
            onStateChanged?(state)
        }
    }
    
    private func turnState(state: State) {
        switch state {
            case .proceed:
                timer = Timer.scheduledTimer(withTimeInterval: proceedDuration, repeats: false, block: { _ in
                    self.turnState(state: .caution)
                })
            case .caution:
                timer = Timer.scheduledTimer(withTimeInterval: cautionDuration, repeats: false, block: { _ in
                    self.turnState(state: .stop)
                })
            case .stop:
                timer = Timer.scheduledTimer(withTimeInterval: stopDuration, repeats: false, block: { _ in
                    self.turnState(state: .proceed)
                })
        }
        self.state = state
    }
    
    public subscript<T: TrafficLightOption>(option type: T.Type) -> T.Value {
        get {
            options[ObjectIdentifier(type)] as? T.Value
            ?? type.defaultValue
        }
        
        set {
            options[ObjectIdentifier(type)] = newValue
        }
    }
    
    public func start() {
        guard timer == nil else {return}
        turnState(state: .stop)
    }
    
    public func stop() {
        timer?.invalidate()
        timer = nil
    }
    
}

extension TrafficLight {
    public enum GreenLightColor: TrafficLightOption {
        case green
        case turquoise
        
        public static let defaultValue: GreenLightColor = .green
    }
    
    public var preferredGreenLightColor: TrafficLight.GreenLightColor {
        get { self[option: GreenLightColor.self] }
        set { self[option: GreenLightColor.self] = newValue}
    }
}

public class TestViewController: BFBaseViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let light = TrafficLight()
        light.preferredGreenLightColor = .turquoise
        light.onStateChanged = {[weak self,weak light] state in
            guard let self = self,let light = light else {return}
            let color: UIColor
            switch state {
                case .proceed: color = light.preferredGreenLightColor.green
                case .caution: color = .yellow
                case .stop: color = .red
            }
            UIView.animate(withDuration: 0.25) {
                self.view.backgroundColor = color
            }
        }
        
        light.start()
    }
}

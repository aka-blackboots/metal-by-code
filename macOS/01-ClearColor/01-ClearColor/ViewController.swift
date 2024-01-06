//
//  ViewController.swift
//  01-ClearColor
//
//  Created by Vishwajeet Mane on 05/01/24.
//

import Metal
import MetalKit

import Cocoa

class ViewController: NSViewController {
    var mtkView: MTKView!
    var renderer: Renderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Creating Metal Kit View
        guard let mtkViewTemp = self.view as? MTKView else {
            print("View attached to ViewController is not an Metal Kit View!")
            return
        }
        mtkView = mtkViewTemp
        
        // Creating System Device
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            print("Metal is not supported on this device")
            return
        }
        
        print("Device Details: \(defaultDevice.name)")
        mtkView.device = defaultDevice
        
        guard let tempRenderer = Renderer(mtkView: mtkView) else {
            print("Renderer failed to initialize")
            return
        }
        renderer = tempRenderer
        mtkView.delegate = renderer
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if let window = mtkView.window {
            window.title = "Clear Color"
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


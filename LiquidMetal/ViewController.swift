//
//  ViewController.swift
//  LiquidMetal
//
//  Created by Tim on 11/21/15.
//  Copyright © 2015 Tim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let gravity : Float = 9.80665;
    let ptmRatio : Float = 32.0;
    let particleRadius: Float = 9;
    
    var particleSystem: UnsafeMutablePointer<Void>!
    
    var device: MTLDevice! = nil;
    var metalLayer: CAMetalLayer! = nil;
    
    func createMetalLayer() {
        device = MTLCreateSystemDefaultDevice();
        
        metalLayer = CAMetalLayer();
        metalLayer.device = device;
        metalLayer.pixelFormat = .BGRA8Unorm;
        metalLayer.framebufferOnly = true;
        metalLayer.frame = view.layer.frame;
        view.layer.addSublayer(metalLayer);
    }
    
    var particleCount : Int = 0;
    var vertexBuffer: MTLBuffer! = nil;
    
    func refreshVertexBuffer() {
        particleCount = Int(LiquidFun.particleCountForSystem(particleSystem));
        let positions = LiquidFun.particlePositionsForSystem(particleSystem);
        let bufferSize = sizeof(Float) * particleCount * 2;
        vertexBuffer = device.newBufferWithBytes(positions, length: bufferSize, options: []);
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LiquidFun.createWorldWithGravity(Vector2D(x: 0, y: -gravity));
        
        particleSystem = LiquidFun.createParticleSystemWithRadius(particleRadius/ptmRatio, dampingStrength: 0.2, gravityScale: 1, density: 1.2);
        
        let screenSize: CGSize = UIScreen.mainScreen().bounds.size;
        let screenWidth = Float(screenSize.width)
        let screenHeight = Float(screenSize.height)
        
        LiquidFun.createParticleBoxForSystem(particleSystem, position: Vector2D(x: screenWidth * 0.5 / ptmRatio, y: screenHeight * 0.5/ptmRatio), size: Size2D(width: 50 / ptmRatio, height: 50 / ptmRatio))
        
        
        createMetalLayer();
        
        refreshVertexBuffer();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func printParticleInfo() {
        let count = Int(LiquidFun.particleCountForSystem(particleSystem));
        print("There are \(count) particles present");
        
        let positions = UnsafePointer<Vector2D>(LiquidFun.particlePositionsForSystem(particleSystem));
        
        for i in 0..<count {
            let position = positions[i];
            print("particle: \(i) position: (\(position.x), \(position.y))");
        }
    }


}


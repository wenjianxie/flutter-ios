//
//  ViewController2.swift
//  PZXShortCutDemo
//
//  Created by 彭祖鑫 on 2023/11/21.
//

import UIKit


class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("触发了指令集")
        // 设置界面
        view.backgroundColor = .orange
        takeScreenshot()
        
        
    }

    // 按钮触发截图
    func takeScreenshot() {
        if let screenshot = captureScreenshot() {
            // 将截图保存到相册
            UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
            print("Screenshot saved!")
        } else {
            print("Failed to capture screenshot.")
        }
    }
    
    // 截图方法
    private func captureScreenshot() -> UIImage? {
        
        
        // 获取屏幕大小
//        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let renderer = UIGraphicsImageRenderer(size: UIScreen.main.bounds.size)
        
        
        return renderer.image { _ in
            // 将窗口的内容渲染到图片
            view?.drawHierarchy(in: UIScreen.main.bounds, afterScreenUpdates: true)
        }
    }
}

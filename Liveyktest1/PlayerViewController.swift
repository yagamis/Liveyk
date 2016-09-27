//
//  PlayerViewController.swift
//  Liveyktest1
//
//  Created by yons on 16/9/19.
//  Copyright © 2016年 xiaobo. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    var live : LiveCell!
    var ijplayer: IJKMediaPlayback!
    var playerView: UIView!

    @IBOutlet weak var giftBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var imgBackground: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //默认模糊主播头像背景
        setBg()
        
        //准备播放器
        setPlayerView()
        
        //把按钮提升到view最前面
        bringBtnTofront()
    }
    
    @IBAction func giftBtnTap(_ sender: UIButton) {
        let duration = 3.0
        let p918 = UIImageView(image: #imageLiteral(resourceName: "porsche"))
        
        p918.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        view.addSubview(p918)
        
        let widthP918:CGFloat = 240
        let heightP918:CGFloat = 120
        
        UIView.animate(withDuration: duration) {
            p918.frame =
            CGRect(x: self.view.center.x - widthP918/2, y: self.view.center.y - heightP918/2, width: widthP918, height: heightP918)
        }
        
        //主线程延时一个完整动画后,再让礼物图片逐渐透明,完全透明后从父视图移除
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
           UIView.animate(withDuration: duration, animations: { 
            p918.alpha = 0
            }, completion: { (completed) in
                p918.removeFromSuperview()
           })
        }
        
        //烟花 https://github.com/yagamis/emmitParticles
        let layerFw = CAEmitterLayer()
        view.layer.addSublayer(layerFw)
        emmitParticles(from: sender.center, emitter: layerFw, in: view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 2) {
           layerFw.removeFromSuperlayer()
        }
    }
    
    func bringBtnTofront()  {
        self.view.bringSubview(toFront: likeBtn)
        self.view.bringSubview(toFront: backBtn)
        self.view.bringSubview(toFront: giftBtn)
    }
    
    func setPlayerView()  {
        //初始化一个空白容器view
        self.playerView = UIView(frame: view.bounds)
        view.addSubview(self.playerView)
        
        
        //初始化IJ播放器的控制器和view
        ijplayer = IJKFFMoviePlayerController(contentURLString: live.url, with: nil)
        let pv = ijplayer.view!
        
        
        //将播放器view自适应后,加入容器
        pv.frame = playerView.bounds
        pv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerView.insertSubview(pv, at: 1)
        ijplayer.scalingMode = .aspectFill
        
    }
    
    //view加载完成后,开始播放视频
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.ijplayer.isPlaying() {
            ijplayer.prepareToPlay()
        }
    }
    
    
    
    @IBAction func goBack(_ sender: UIButton) {
        ijplayer.shutdown()
        
        navigationController?.popViewController(animated: true)

        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @IBAction func like(_ sender: UIButton) {
        
        //爱心大小
        let heart = DMHeartFlyView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

        //爱心的中心位置
        heart.center = CGPoint(x: likeBtn.frame.origin.x, y: likeBtn.frame.origin.y)
        
        view.addSubview(heart)
        heart.animate(in: view)
        
        
        //爱心按钮的 大小变化动画
        let btnAnime = CAKeyframeAnimation(keyPath: "transform.scale")
        btnAnime.values   = [1.0, 0.7, 0.5, 0.3, 0.5, 0.7, 1.0, 1.2, 1.4, 1.2, 1.0]
        btnAnime.keyTimes = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
        btnAnime.duration = 0.2
        sender.layer.add(btnAnime, forKey: "SHOW")
        
        
        
        
    }
    
    
    func setBg()  {
        //头像
        let imgUrl = URL(string: "http://img.meelive.cn/" + live.portrait)
        imgBackground.kf_setImage(with: imgUrl)
        
        let blurEffect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = imgBackground.bounds
        imgBackground.addSubview(effectView)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

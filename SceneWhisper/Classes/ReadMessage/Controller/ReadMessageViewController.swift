//
//  ReadMessageViewController.swift
//  SceneWhisper
//
//  Created by weipo 2017/4/26.
//  Copyright © 2017年 weipo. All rights reserved.
//  私语信息详情

import UIKit
import AVKit
import MediaPlayer
import AVFoundation
import SVProgressHUD


class ReadMessageViewController: UIViewController {
    
    var messageID: NSInteger?
    
    /** 用户头像 */
    @IBOutlet var userImage: UIImageView!
    /** 用户名称 */
    @IBOutlet var userNameLabel: UILabel!
    /** 创建日期 */
    @IBOutlet var createDateLabel: UILabel!
    /** 创建时间 */
    @IBOutlet var createTimeLabel: UILabel!
    /** 地址 */
    @IBOutlet weak var addressLabel: UILabel!
    /** 地标 */
    @IBOutlet weak var LocationLabel: UILabel!
    /** 可读次数 */
    @IBOutlet weak var readCountLabel: UILabel!
    /** 标题按钮 */
    @IBOutlet weak var myMemoryButton: UIButton!
    /** 密信描述textView */
    @IBOutlet weak var messageDescribeTextView: UITextView!
    @IBOutlet weak var musicButton: UIButton! //播放按钮
    @IBOutlet weak var fullScreenButton: UIButton! //全屏按钮
    @IBOutlet weak var movieSuperView: UIView! //视频MainView
    @IBOutlet weak var checkMessageLabel: UILabel! //查看密信片按钮
    /** 图片列表 */
    @IBOutlet var photoCollectionView: UICollectionView!
    
    var isShowReadersView: Bool = false //是否为图片（图片模式/视频模式）
    var player: AVPlayer? //视频播放器
    /** 是否静音 */
    var IsMute:Bool = false
    
    /** 播放按钮 */
    var playBtn : UIButton!
    
    
    //附件数组
    var fileDatas:Array<Dictionary<String,Any>> = []
    //图片url数据
    var urls:[String] = []
    
    //初始化viewController
    class func initViewController() -> ReadMessageViewController {
        return UIStoryboard.init(name: "ReadMessage", bundle: nil).instantiateViewController(withIdentifier: "ReadMessageViewController") as! ReadMessageViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //初始化播放器
        movieSuperView.layer.cornerRadius = (KScreenWidth - 60)/2.0
        movieSuperView.layer.borderWidth = 2
        movieSuperView.layer.borderColor = UIColor.color(with: "#514953").cgColor
        movieSuperView.clipsToBounds = true
        movieSuperView.backgroundColor = .white
        
        //设置查看密信片按钮
        checkMessageLabel.layer.borderColor = UIColor.white.cgColor
        checkMessageLabel.layer.borderWidth = 1.0
        checkMessageLabel.layer.cornerRadius = 2.5
        
        let nib = UINib.init(nibName: "SWPhotoCell", bundle: nil)
        photoCollectionView.register(nib, forCellWithReuseIdentifier: "SWPhotoCell")
        // 请求数据
        requstData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    deinit {
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    //MARK:请求数据
    func requstData() {
        /**
         userId://,用户 Id Long
         messageId://,信息 Id Long
         **/
        let parameters = ["userId":SWDataManager.currentUserId(),
                          "messageId":messageID!
                          ] as [String:Any]
        
        SWRequestManager.queryMessageDetail(parameters) {[weak self] (result, error) in
            guard let strongSelf = self else { return }
            strongSelf.queryMessageDetailHandler(result, error: error)
        }
        
    }
    //密信详情模型
    private var messageDetailModel:SWMessageInfoModel! {
        didSet {
            userImage.sd_setImage(with: URL(string: (SWUrlHeader + messageDetailModel.userPhoto)), placeholderImage: UIImage(named: "秘信列表红头像"))
            userNameLabel.text = messageDetailModel.userNickName
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let convertedDate = formatter.date(from: messageDetailModel.messageAddTime)
            
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "yyyy年MM月dd日"
            let dateStr = newDateFormatter.string(from: convertedDate!)
            
            let newTimeFormatter = DateFormatter()
            newTimeFormatter.dateFormat = "HH:mm"
            let timeStr = newTimeFormatter.string(from: convertedDate!)
            
            createDateLabel.text = dateStr
            createTimeLabel.text = timeStr
            addressLabel.text = messageDetailModel.placeName
            
            let currentCoordinate = CLLocationCoordinate2D(latitude: Double(messageDetailModel.placeLat)!, longitude: Double(messageDetailModel.placeLng)!)
            
            LocationLabel.text = currentCoordinate.NorthOrSouth() + ":" + currentCoordinate.latitudeString() + "  " + currentCoordinate.EastOrWest() + ":" + currentCoordinate.longitudeString()
            
            if messageDetailModel.messageReadTimes == -1 {
                readCountLabel.text = "\(messageDetailModel.messageReadedTimes)" + "/" + "∞"
            } else {
                readCountLabel.text = "\(messageDetailModel.messageReadedTimes)" + "/" + "\(messageDetailModel.messageReadTimes)"
            }
            myMemoryButton.setTitle(messageDetailModel.messageTitle, for: UIControlState.normal)
            messageDescribeTextView.text = messageDetailModel.messageContent
            
            // 视频还是图片
            fileDatas = (messageDetailModel.attachments as NSArray) as! Array<Dictionary<String, Any>>
            if messageDetailModel.attachmentTypeId == 2 { //视频
                photoCollectionView.isHidden = true
                isShowReadersView = false
                musicButton.isHidden = false
                fullScreenButton.isHidden = false
                movieSuperView.isHidden = false
                self.createMoviePlayView()
                
            } else { // 图片
                photoCollectionView.isHidden = false
                photoCollectionView.reloadData()
                isShowReadersView = true
                musicButton.isHidden = true
                fullScreenButton.isHidden = true
                movieSuperView.isHidden = true
                
                for i in 0..<fileDatas.count {
                    let urlstr = (SWUrlHeader + "\(fileDatas[i]["attachmentThumbnailUrl"] ?? "")")
                    urls.append(urlstr)
                }
                // 注册CollectionViewCell
                let flowLayout = UICollectionViewFlowLayout()
                flowLayout.scrollDirection = .vertical
            
                if fileDatas.count > 4 {
                    flowLayout.itemSize = CGSize(width: (KScreenWidth - 80) / 3, height: (KScreenWidth - 80) / 3)
                } else if fileDatas.count >= 2 && fileDatas.count <= 4{
                    flowLayout.itemSize = CGSize(width: (KScreenWidth - 70) / 2, height: (KScreenWidth - 70) / 2)
                } else {
                    flowLayout.itemSize = CGSize(width: (KScreenWidth - 60), height: (KScreenWidth - 60))
                }
                
                
                flowLayout.minimumInteritemSpacing = 10
                flowLayout.minimumLineSpacing = 10

                photoCollectionView .setCollectionViewLayout(flowLayout, animated: false)
                photoCollectionView.reloadData()
            }
        }
    }
    //读取信息请求结果处理
    func queryMessageDetailHandler(_ result: HSSuccessResponse?, error: HSErrorResponse?) {
     
        if error != nil {
            SVProgressHUD.showError(withStatus: (String(describing: error?.errorMessage)))
        } else {
            let data: Dictionary<String, Any> = result?.data as! Dictionary<String, Any>
            messageDetailModel = SWMessageInfoModel().queryMessageDetail(data)
        }
    }
    //页面返回
    @IBAction func getbackButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //创建播放器view
    func createMoviePlayView() {

        let urlStr = (SWUrlHeader + "\(fileDatas.first!["attachmentUrl"] ?? "")")

        let playerItem = AVPlayerItem(url: URL(string: urlStr)!)
        
        player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 2, y: 2, width: KScreenWidth - 64, height: KScreenWidth - 64)
        playerLayer.borderColor = UIColor.color(with: "#EB6B66").cgColor
        playerLayer.cornerRadius = (KScreenWidth - 64) / 2.0
        playerLayer.borderWidth = 3.0
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        movieSuperView.layer.addSublayer(playerLayer)
        
        // 播放按钮
        playBtn = UIButton.init(type: .custom)
        
        playBtn.frame = CGRect(x:(KScreenWidth - 120)/2 , y: (KScreenWidth - 90)/2 , width: 60, height: 60)
        playBtn.setImage(UIImage.init(named: "播放"), for: UIControlState.normal)
        playBtn.addTarget(self, action: #selector(playButtonAction(_:)), for: .touchUpInside)
       
        movieSuperView .addSubview(playBtn)
        // 添加通知
        NotificationCenter.default.addObserver(self, selector: #selector(playbackFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    //开始播放
    func playButtonAction(_ sender: UIButton) {
        //开始播放
        player?.play()
        sender.isHidden = true;
    }
    func playbackFinished() {
        playBtn.isHidden = false
        player?.seek(to: CMTimeMake(0, 1))
        
    }
    //全屏按钮处理
    @IBAction func fullScreenButtonClicked(_ sender: Any) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
        playBtn.isHidden = false
        player?.seek(to: CMTimeMake(0, 1))
    }
    
    //静音处理
    @IBAction func musicButtonClicked(_ sender: Any) {
        IsMute = !IsMute
        if IsMute {
            player?.volume = 0
            musicButton.setBackgroundImage(UIImage.init(named: "音乐关"), for: .normal)
        } else {
            player?.volume = 20
            musicButton.setBackgroundImage(UIImage.init(named: "音乐"), for: .normal)
        }
    }
    
    //查看密信片按钮处理
    @IBAction func checkMessageButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK: UICollectionView-数据源
extension ReadMessageViewController: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileDatas.count
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //返回Cell内容，这里我们使用刚刚建立的defaultCell作为显示内容
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SWPhotoCell", for: indexPath as IndexPath) as! SWPhotoCell
        
        if fileDatas.count > 4 {
            cell.radius = (KScreenWidth - 80) / 6
        } else if fileDatas.count >= 2 && fileDatas.count <= 4{
            cell.radius = (KScreenWidth - 70) / 4
        } else {
            cell.radius = (KScreenWidth - 60) / 2
        }
        
        cell.imageView.kf.setImage(with: URL(string: (SWUrlHeader + "\(fileDatas[indexPath.row]["attachmentThumbnailUrl"] ?? "")")), placeholder: UIImage.init(named: "占位图"), options: nil, progressBlock: nil, completionHandler: nil)
        return cell;
    }
}
//MARK:Cell点击查看照片详情
extension ReadMessageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SWPhotoCell
        
        let bview = HJImageBrowser()
        // bottomView 这个一定要填写你点击的imageView的直接父视图
        bview.bottomView = collectionView
        bview.indexImage = indexPath.row
        bview.defaultImage = cell.imageView.image
        bview.arrayImage = urls
        
        bview.show()
    }
}


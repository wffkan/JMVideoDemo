////
////  CommentsPopView.swift
////  Douyin
////
////  Created by Qiao Shi on 2018/8/7.
////  Copyright © 2018年 Qiao Shi. All rights reserved.
////
//
//import UIKit
//
//let COMMENT_CELL:String = "CommentCell"
//let LEFT_INSET:CGFloat = 15
//let RIGHT_INSET:CGFloat = 85
//let TOP_BOTTOM_INSET:CGFloat = 15
//
//class CommentsPopView:UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate, CommentTextViewDelegate {
//
//
//    var label = UILabel.init()
//    var close = UIImageView.init(image:UIImage.init(named: "icon_closetopic"))
//    var awemeId:String?
//
//    var pageIndex:Int = 0
//    var pageSize:Int = 20
//    var container = UIView.init()
//    var tableView = UITableView.init()
//
//    var textView = CommentTextView()
//
//
//    init(awemeId:String) {
//        super.init(frame: UIScreen.main.bounds)
//        self.awemeId = awemeId
//        initSubView()
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initSubView()
//    }
//
//
//    func initSubView() {
//        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleGuesture(sender:)))
//        tapGestureRecognizer.delegate = self
//        self.addGestureRecognizer(tapGestureRecognizer)
//
//        container.frame = CGRect.init(x: 0, y: UIScreen.height, width: UIScreen.width, height: UIScreen.height * 3 / 4)
//        container.backgroundColor = ColorBlackAlpha60
//        self.addSubview(container)
//
//        let rounded = UIBezierPath.init(roundedRect: CGRect.init(origin: .zero, size: CGSize.init(width: UIScreen.width, height: UIScreen.height * 3 / 4)), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 10.0, height: 10.0))
//        let shape = CAShapeLayer.init()
//        shape.path = rounded.cgPath
//        container.layer.mask = shape
//
//        let blurEffect = UIBlurEffect.init(style: .dark)
//        let visualEffectView = UIVisualEffectView.init(effect: blurEffect)
//        visualEffectView.frame = self.bounds
//        visualEffectView.alpha = 1.0
//        container.addSubview(visualEffectView)
//
//        label.frame = CGRect.init(origin: .zero, size: CGSize.init(width: UIScreen.width, height: 35))
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        label.text = "0条评论"
//        label.textColor = ColorGray
//        label.font = SmallFont
//        container.addSubview(label)
//
//        close.frame = CGRect.init(x: UIScreen.width - 40, y: 0, width: 30, height: 30)
//        close.contentMode = .center
//        close.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGuesture(sender:))))
//        container.addSubview(close)
//
//        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 35, width: UIScreen.width, height: UIScreen.height*3/4 - 35 - 50 - UIScreen.safeAreaBottomHeight), style: .grouped)
//        tableView.backgroundColor = ColorClear
//        tableView.tableHeaderView = UIView.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: self.tableView.bounds.width, height: 0.01)))
//        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorStyle = .none
//        container.addSubview(tableView)
//
//
//        textView.delegate = self
//        loadData(page: pageIndex)
//    }
//
//    func onSendText(text: String) {
//
//    }
//
//
//    func loadData(page:Int, _ size:Int = 20) {
//
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: COMMENT_CELL)
//        return cell!
//    }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if NSStringFromClass((touch.view?.superview?.classForCoder)!).contains("CommentListCell")  {
//            return false
//        } else {
//            return true
//        }
//    }
//
//    @objc func handleGuesture(sender:UITapGestureRecognizer) {
//        var point = sender.location(in: container)
//        if !container.layer.contains(point) {
//            dismiss()
//        }
//        point = sender.location(in: close)
//        if close.layer.contains(point) {
//            dismiss()
//        }
//    }
//
//    func show() {
//        let window = UIApplication.shared.delegate?.window as? UIWindow
//        window?.addSubview(self)
//        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
//            var frame = self.container.frame
//            frame.origin.y = frame.origin.y - frame.size.height
//            self.container.frame = frame
//        }) { finished in
//        }
//        textView.show()
//    }
//
//    func dismiss() {
//        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
//            var frame = self.container.frame
//            frame.origin.y = frame.origin.y + frame.size.height
//            self.container.frame = frame
//        }) { finished in
//            self.removeFromSuperview()
//            self.textView.dismiss()
//        }
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        if offsetY < 0 {
//            self.frame = CGRect.init(x: 0, y: -offsetY, width: self.frame.width, height: self.frame.height)
//        }
//        if scrollView.isDragging && offsetY < -50 {
//            dismiss()
//        }
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//protocol CommentTextViewDelegate:NSObjectProtocol {
//    func onSendText(text:String)
//}
//
//class CommentTextView:UIView, UITextViewDelegate {
//
//
//    var leftInset:CGFloat = 15
//    var rightInset:CGFloat = 60
//    var topBottomInset:CGFloat = 15
//
//    var container = UIView.init()
//    var textView = UITextView.init()
//    var delegate:CommentTextViewDelegate?
//
//    var textHeight:CGFloat = 0
//    var keyboardHeight:CGFloat = 0
//    var placeHolderLabel = UILabel.init()
//    var atImageView = UIImageView.init(image: UIImage.init(named: "iconWhiteaBefore"))
//    var visualEffectView = UIVisualEffectView.init()
//
//    init() {
//        super.init(frame: UIScreen.main.bounds)
//        initSubView()
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initSubView()
//    }
//
//
//    func initSubView() {
//        self.frame =  UIScreen.main.bounds
//        self.backgroundColor = ColorClear
//        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGuestrue(sender:))))
//
//        self.addSubview(container)
//        container.backgroundColor = ColorBlackAlpha40
//
//        keyboardHeight = UIScreen.safeAreaBottomHeight
//
//        textView = UITextView.init()
//        textView.backgroundColor = ColorClear
//        textView.clipsToBounds = false
//        textView.textColor = ColorWhite
//        textView.font = BigFont
//        textView.returnKeyType = .send
//        textView.isScrollEnabled = false
//        textView.textContainer.lineBreakMode = .byTruncatingTail
//        textView.textContainer.lineFragmentPadding = 0
//        textView.textContainerInset = UIEdgeInsets(top: topBottomInset, left: leftInset, bottom: topBottomInset, right: rightInset)
//        textHeight = textView.font?.lineHeight ?? 0
//
//        placeHolderLabel.frame = CGRect.init(x:LEFT_INSET, y:0, width:UIScreen.width - LEFT_INSET - RIGHT_INSET, height:50)
//        placeHolderLabel.text = "有爱评论，说点儿好听的~"
//        placeHolderLabel.textColor = ColorGray
//        placeHolderLabel.font = BigFont
//        textView.addSubview(placeHolderLabel)
////        textView.setValue(placeHolderLabel, forKey: "_placeholderLabel")
//
//        atImageView.contentMode = .center
//        textView.addSubview(atImageView)
//
//        textView.delegate = self
//        container.addSubview(textView)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        atImageView.frame = CGRect.init(x: UIScreen.width - 50, y: 0, width: 50, height: 50)
//        let rounded = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 10.0, height: 10.0))
//        let shape = CAShapeLayer.init()
//        shape.path = rounded.cgPath
//        container.layer.mask = shape
//
//        updateTextViewFrame()
//    }
//
//    func updateTextViewFrame() {
//        let textViewHeight = keyboardHeight > UIScreen.safeAreaBottomHeight ? textHeight + 2 * topBottomInset : (textView.font?.lineHeight ?? 0) + 2*topBottomInset
//        textView.frame = CGRect.init(x: 0, y: 0, width:  UIScreen.width, height: textViewHeight)
//        container.frame = CGRect.init(x: 0, y: UIScreen.height - keyboardHeight - textViewHeight, width: UIScreen.width, height: textViewHeight + keyboardHeight)
//    }
//
//    @objc func keyboardWillShow(notification:Notification) {
//        keyboardHeight = notification.keyBoardHeight()
//        updateTextViewFrame()
//        atImageView.image = UIImage.init(named: "iconBlackaBefore")
//        container.backgroundColor = ColorWhite
//        textView.textColor = ColorBlack
//        self.backgroundColor = ColorBlackAlpha60
//    }
//
//    @objc func keyboardWillHide(notification:Notification) {
//        keyboardHeight = UIScreen.safeAreaBottomHeight
//        updateTextViewFrame()
//        atImageView.image = UIImage.init(named: "iconWhiteaBefore")
//        container.backgroundColor = ColorBlackAlpha40
//        textView.textColor = ColorWhite
//        self.backgroundColor = ColorClear
//    }
//
//    func textViewDidChange(_ textView: UITextView) {
//        let attributeText = NSMutableAttributedString.init(attributedString: textView.attributedText)
//        if !textView.hasText {
//            placeHolderLabel.isHidden = false
//            textHeight = textView.font?.lineHeight ?? 0
//        } else {
//            placeHolderLabel.isHidden = true
//            textHeight = attributeText.multiLineSize(width: UIScreen.width - leftInset - rightInset).height
//        }
//        updateTextViewFrame()
//    }
//
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            delegate?.onSendText(text: textView.text)
//            textView.text = ""
//            textHeight = textView.font?.lineHeight ?? 0
//            textView.resignFirstResponder()
//        }
//        return true
//    }
//
//    @objc func handleGuestrue(sender:UITapGestureRecognizer) {
//        let point = sender.location(in: textView)
//        if !(textView.layer.contains(point)) {
//            textView.resignFirstResponder()
//        }
//    }
//
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let hitView = super.hitTest(point, with: event)
//        if hitView == self {
//            if hitView?.backgroundColor == ColorClear {
//                return nil
//            }
//        }
//        return hitView
//    }
//
//    func show() {
//        let window = UIApplication.shared.delegate?.window as? UIWindow
//        window?.addSubview(self)
//    }
//
//    func dismiss() {
//        self.removeFromSuperview()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

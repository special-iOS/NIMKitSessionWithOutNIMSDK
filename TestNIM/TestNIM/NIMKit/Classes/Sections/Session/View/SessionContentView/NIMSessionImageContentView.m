//
//  NIMSessionImageContentView.m
//  NIMKit
//
//  Created by chris on 15/1/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMSessionImageContentView.h"
#import "NIMMessageModel.h"
#import "UIView+NIM.h"
#import "NIMLoadProgressView.h"
#import "NIMKitDependency.h"
#import "SDWebImage.h"

@interface NIMSessionImageContentView()

@property (nonatomic,strong,readwrite) FLAnimatedImageView * imageView;

@property (nonatomic,strong) NIMLoadProgressView * progressView;

@end

@implementation NIMSessionImageContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        _imageView  = [[FLAnimatedImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        _progressView = [[NIMLoadProgressView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _progressView.maxProgress = 1.0f;
        [self addSubview:_progressView];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data
{
//    [super refresh:data];
//    _imageView.image = nil;
//    _imageView.animatedImage = nil;
//    NIMImageObject * imageObject = (NIMImageObject*)self.model.message.messageObject;
//    NSData *imageData = [[NSData alloc] initWithContentsOfFile:imageObject.thumbPath];
//    BOOL isGif = ([NSData sd_imageFormatForImageData:imageData] == SDImageFormatGIF);
//    if (!isGif) {
//        UIImage *image = [UIImage imageWithData:imageData];
//        _imageView.image = image;
//    } else {
//        FLAnimatedImage *image = [[FLAnimatedImage alloc] initWithAnimatedGIFData:imageData];
//        _imageView.animatedImage = image;
//        if (!_imageView.isAnimating) {
//            [_imageView startAnimating];
//        }
//    }
//    
//    self.progressView.hidden     = self.model.message.isOutgoingMsg ? (self.model.message.deliveryState != NIMMessageDeliveryStateDelivering) : (self.model.message.attachmentDownloadState != NIMMessageAttachmentDownloadStateDownloading);
//    if (!self.progressView.hidden) {
//        [self.progressView setProgress:[[[NIMSDK sharedSDK] chatManager] messageTransportProgress:self.model.message]];
//    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGFloat tableViewWidth = self.superview.nim_width;
    CGSize contentSize = [self.model contentSize:tableViewWidth];
    CGRect imageViewFrame = CGRectMake(contentInsets.left, contentInsets.top, contentSize.width, contentSize.height);
    self.imageView.frame  = imageViewFrame;
    _progressView.frame   = self.bounds;
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.cornerRadius = 13.0;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = self.imageView.bounds;
    self.imageView.layer.mask = maskLayer;
}


- (void)onTouchUpInside:(id)sender
{
    NIMKitEvent *event = [[NIMKitEvent alloc] init];
    event.eventName = NIMKitEventNameTapContent;
    event.messageModel = self.model;
    [self.delegate onCatchEvent:event];
}

- (void)updateProgress:(float)progress
{
    if (progress > 1.0) {
        progress = 1.0;
    }
    self.progressView.progress = progress;
}

@end

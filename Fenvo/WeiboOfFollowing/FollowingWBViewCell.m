//
//  FollowingWBViewCell.m
//  Fenvo
//
//  Created by Caesar on 15/3/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "FollowingWBViewCell.h"
#import "WebImageView.h"
#import "WeiboAvatarView.h"
#import "WeiboMsg.h"
#import "WeiboLabel.h"

@interface FollowingWBViewCell(){
    WeiboAvatarView *_avatar;
    UIImageView *_mbType;
    UILabel *_userName;
    UILabel *_createTime;
    UILabel *_source;
    WeiboLabel *_wbForwardText;
    WeiboLabel *_wbDetail;
    
    //配图集合
    WebImageView *_imageView0;
    WebImageView *_imageView1;
    WebImageView *_imageView2;
    WebImageView *_imageView3;
    WebImageView *_imageView4;
    WebImageView *_imageView5;
    WebImageView *_imageView6;
    WebImageView *_imageView7;
    WebImageView *_imageView8;
    
    
    UIButton *_praiseBtn;
    UIButton *_forwardBtn;
    UIButton *_commitBtn;
    

}
@end

@implementation FollowingWBViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return self;
}

- (void) initSubView{
    self.containView = [[UIView alloc]init];
    self.containView.backgroundColor = RGBACOLOR(250, 250, 250, 0.65);
    self.containView.layer.cornerRadius = 10.0;
    self.containView.layer.masksToBounds = YES;
    [self addSubview:self.containView];
    //头像
    _avatar = [[WeiboAvatarView alloc]initWithStyle];
    [self.containView addSubview:_avatar];
    //用户名
    _userName = [[UILabel alloc]init];
    _userName.textColor = WBStatusGrayColor;
    _userName.font = WBStatusCellUserNameFont;
    [self.containView addSubview:_userName];
    //会员标识
    _mbType = [[UIImageView alloc]init];
    [self.containView addSubview:_mbType];
    //创建时间
    _createTime = [[UILabel alloc]init];
    _createTime.textColor = WBStatusGrayColor;
    _createTime.font = WBStatusCellCreatTimeFont;
    [self.containView addSubview:_createTime];
    //微博发布来源
    _source = [[UILabel alloc]init];
    _source.textColor = WBStatusGrayColor;
    _source.font = WBStatusCellSourceFont;
    [self.containView addSubview:_source];
    //微博转发信息
    _wbForwardText = [[WeiboLabel alloc]init];
    _wbForwardText.numberOfLines = 0;
    _wbForwardText.textColor = WBStatusGrayColor;
    _wbForwardText.font = WBStatusCellForwardFont;
    [self.containView addSubview:_wbForwardText];
    //微博详情
    _wbDetail = [[WeiboLabel alloc]init];
    _wbDetail.textColor = WBStatusGrayColor;
    _wbDetail.font = WBStatusCellDetailFont;
    //如果label行数没有设置则默认为1，设置为0则是不限行数
    _wbDetail.numberOfLines = 0;
    [self.containView addSubview:_wbDetail];
    //微博配图
    _imageView0 = [[WebImageView alloc]initWithStyleAndTag:0];
    _imageView0.tag = 0;
    [self.containView addSubview:_imageView0];
    _imageView1 = [[WebImageView alloc]initWithStyleAndTag:1];
    _imageView1.tag = 1;
    [self.containView addSubview:_imageView1];
    _imageView2 = [[WebImageView alloc]initWithStyleAndTag:2];
    _imageView2.tag = 2;
    [self.containView addSubview:_imageView2];
    _imageView3 = [[WebImageView alloc]initWithStyleAndTag:3];
    _imageView3.tag = 3;
    [self.containView addSubview:_imageView3];
    _imageView4 = [[WebImageView alloc]initWithStyleAndTag:4];
    _imageView4.tag = 4;
    [self.containView addSubview:_imageView4];
    _imageView5 = [[WebImageView alloc]initWithStyleAndTag:5];
    _imageView5.tag = 5;
    [self.containView addSubview:_imageView5];
    _imageView6 = [[WebImageView alloc]initWithStyleAndTag:6];
    _imageView6.tag = 6;
    [self.containView addSubview:_imageView6];
    _imageView7 =[[WebImageView alloc]initWithStyleAndTag:7];
    _imageView7.tag = 7;
    [self.containView addSubview:_imageView7];
    _imageView8 = [[WebImageView alloc]initWithStyleAndTag:8];
    _imageView8.tag = 8;
    [self.containView addSubview:_imageView8];
    
    //
    _praiseBtn = [[UIButton alloc]init];
    _praiseBtn.tag = 100;
    _praiseBtn.backgroundColor = [UIColor redColor];
    [self.containView addSubview:_praiseBtn];
    _forwardBtn = [[UIButton alloc]init];
    _forwardBtn.tag = 101;
    [self.containView addSubview:_forwardBtn];
    _commitBtn = [[UIButton alloc]init];
    _commitBtn.tag = 102;
    
    
}

/////////////////////////////////////////////////////////
- (void)setWeiboMsg:(WeiboMsg *)weiboMsg{
    
    
    //初始化 － 头像
    CGRect avatarRect = CGRectMake(10, 5, WBStatusCellAvatarWidth, WBStatusCellAvatarHeight);
    _avatar.image = weiboMsg.user_avatar;
    
    _avatar.frame = avatarRect;
    
    //初始化 － 用户名
    CGFloat userNameX = CGRectGetMaxX(_avatar.frame) + WBStatusCellControlSpacing;
    CGFloat userNameY = 5;
    CGSize userNameSize = [weiboMsg.user.name sizeWithAttributes:@{NSFontAttributeName: WBStatusCellUserNameFont}];
    CGFloat userNameSizeX = userNameSize.width;
    CGFloat userNameSizeY = userNameSize.height;
    CGRect userNameRect = CGRectMake(userNameX, userNameY, userNameSizeX, userNameSizeY);
    _userName.text = weiboMsg.user.name;
    _userName.frame = userNameRect;
    
    //初始化 － 会员标识
    CGFloat mbTypeX = CGRectGetMaxX(_userName.frame) + WBStatusCellControlSpacing;
    CGFloat mbTypeY = 5;
    CGRect mbTypeRect = CGRectMake(mbTypeX, mbTypeY, WBStatusCellMBTypeWidth, WBStatusCellMBTypeHeight);
    if (!weiboMsg.user.mbtype > 0) {
        _mbType.image = [UIImage imageNamed:@"vip"];
    }
    _mbType.frame = mbTypeRect;
    
    //初始化 － 创建时间
    CGSize createTimeSize = [weiboMsg.created_at sizeWithAttributes:@{NSFontAttributeName:WBStatusCellCreatTimeFont}]   ;
    CGFloat createTimeX = userNameX;
    CGFloat createTimeY = CGRectGetMaxY(_userName.frame)+5;
    CGRect createTimeRect = CGRectMake(createTimeX, createTimeY, createTimeSize.width, createTimeSize.height);
    _createTime.text = weiboMsg.created_at;
    _createTime.frame = createTimeRect;
    
    //初始化 － 微博发布来源
    CGSize sourceSize = [weiboMsg.source sizeWithAttributes:@{NSFontAttributeName:WBStatusCellSourceFont}];
    CGFloat sourceX = CGRectGetMaxX(_createTime.frame) + WBStatusCellControlSpacing;
    CGFloat sourceY = createTimeY;
    CGRect sourceRect = CGRectMake(sourceX, sourceY, sourceSize.width, sourceSize.height);
    _source.text = weiboMsg.source;
    _source.frame = sourceRect;
    
    
    //初始化 － 微博详情
    CGFloat wbDetailX = 10;
    CGFloat wbDetailY = CGRectGetMaxY(_avatar.frame) + WBStatusCellControlSpacing;
    CGFloat wbDetailWidth = self.frame.size.width - WBStatusCellControlSpacing * 2;
    [_wbDetail setText:weiboMsg.wbDetail];
    CGSize wbDetailSize = [_wbDetail suggestedFrameSizeToFitEntireStringConstraintedToWidth:wbDetailWidth];
    CGRect wbDetailRect = CGRectMake(wbDetailX, wbDetailY, wbDetailSize.width, wbDetailSize.height);
    _wbDetail.frame = wbDetailRect;
    [_wbDetail setDetectionBlock:^(WeiboHotWord hotWord, NSString *string,NSString *protocol, NSRange range){
        NSArray *hotWords = @[@"Handle", @"Hashtag", @"Link"];
        NSLog(@"%@",hotWords[hotWord]);
    }];
    
    CGRect containViewRect;
    //初始化 － 是否为转发
    if (weiboMsg.retweeted_status) {
        CGFloat wbForwardTextX = 10;
        CGFloat wbForwardTextY = CGRectGetMaxY(_wbDetail.frame) + WBStatusCellControlSpacing;
        CGFloat wbForwardTextWidth = self.frame.size.width - WBStatusCellControlSpacing*2;
        NSString *retweeted_text = [NSString stringWithFormat:@"@%@：%@",weiboMsg.retweeted_status.user.screen_name ,weiboMsg.retweeted_status.wbDetail];
        _wbForwardText.text = retweeted_text;
        CGSize wbForwardTextSize = [_wbForwardText suggestedFrameSizeToFitEntireStringConstraintedToWidth:wbForwardTextWidth];
        CGRect wbForwardTextRect = CGRectMake(wbForwardTextX, wbForwardTextY, wbForwardTextSize.width, wbForwardTextSize.height);
        _wbForwardText.frame = wbForwardTextRect;
        [_wbForwardText setDetectionBlock:^(WeiboHotWord hotWord, NSString *string,NSString *protocol, NSRange range){
            NSArray *hotWords = @[@"Handle", @"Hashtag", @"Link"];
            NSLog(@"%@",hotWords[hotWord]);
        }];
        //转发。 有配图
        
        if (weiboMsg.retweeted_status.thumbnail_pic) {
            
            if (weiboMsg.retweeted_status.pic_urls.count == 1) {
                CGFloat imageWidth = 120;
                CGFloat imageHight = 120;
                CGFloat imageX = WBStatusCellControlSpacing;
                CGFloat imageY = CGRectGetMaxY(_wbForwardText.frame) + WBStatusCellControlSpacing;
                CGRect imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
                _imageView0.hidden = NO;
                _imageView0.frame = imageRect;
                _imageView0.original_pic_urls = weiboMsg.retweeted_status.original_pic_urls;
                _imageView0.bmiddle_pic_urls = weiboMsg.retweeted_status.bmiddle_pic_urls;
                containViewRect = CGRectMake(5, 5, self.frame.size.width - 10, CGRectGetMaxY(_imageView0.frame) + 5);
            }else{
            for (int i = 0; i < weiboMsg.retweeted_status.pic_urls.count; i++) {
                CGFloat imageY;
                CGRect imageRect;
                CGFloat imageWidth = 60;
                CGFloat imageHight = 60;
                if (i >= 6) {
                    CGFloat imageX = WBStatusCellControlSpacing*(i - 5) + imageWidth * (i - 6);
                    imageY = CGRectGetMaxY(_wbForwardText.frame) + WBStatusCellControlSpacing*3 + imageHight*2;
                    imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
                }else if(i <= 2){
                    CGFloat imageX = WBStatusCellControlSpacing*(i + 1) + imageWidth * i;
                    imageY = CGRectGetMaxY(_wbForwardText.frame) + WBStatusCellControlSpacing;
                    imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
                }else{
                    CGFloat imageX = WBStatusCellControlSpacing*(i - 2) + imageWidth * (i-3);
                    imageY = CGRectGetMaxY(_wbForwardText.frame) + WBStatusCellControlSpacing*2 + imageHight;
                    imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
                }
                switch (i) {
                    case 0:
                        _imageView0.hidden = NO;
                        _imageView0.frame = imageRect;
                        _imageView0.original_pic_urls = weiboMsg.retweeted_status.original_pic_urls;
                        _imageView0.bmiddle_pic_urls = weiboMsg.retweeted_status.bmiddle_pic_urls;
                        break;
                    case 1:
                        _imageView1.hidden = NO;
                        _imageView1.frame = imageRect;
                        _imageView1.original_pic_urls = weiboMsg.retweeted_status.original_pic_urls;
                        _imageView1.bmiddle_pic_urls = weiboMsg.retweeted_status.bmiddle_pic_urls;
                        break;
                    case 2:
                        _imageView2.hidden = NO;
                        _imageView2.frame = imageRect;
                        _imageView2.original_pic_urls = weiboMsg.retweeted_status.original_pic_urls;
                        _imageView2.bmiddle_pic_urls = weiboMsg.retweeted_status.bmiddle_pic_urls;
                        break;
                    case 3:
                        _imageView3.hidden = NO;
                        _imageView3.frame = imageRect;
                        _imageView3.original_pic_urls = weiboMsg.retweeted_status.original_pic_urls;
                        _imageView3.bmiddle_pic_urls = weiboMsg.retweeted_status.bmiddle_pic_urls;
                        break;
                    case 4:
                        _imageView4.hidden = NO;
                        _imageView4.frame = imageRect;
                        _imageView4.original_pic_urls = weiboMsg.retweeted_status.original_pic_urls;
                        _imageView4.bmiddle_pic_urls = weiboMsg.retweeted_status.bmiddle_pic_urls;
                        break;
                    case 5:
                        _imageView5.hidden = NO;
                        _imageView5.frame = imageRect;
                        _imageView5.original_pic_urls = weiboMsg.retweeted_status.original_pic_urls;
                        _imageView5.bmiddle_pic_urls = weiboMsg.retweeted_status.bmiddle_pic_urls;
                        break;
                    case 6:
                        _imageView6.hidden = NO;
                        _imageView6.frame = imageRect;
                        _imageView6.original_pic_urls = weiboMsg.retweeted_status.original_pic_urls;
                        _imageView6.bmiddle_pic_urls = weiboMsg.retweeted_status.bmiddle_pic_urls;
                        break;
                    case 7:
                        _imageView7.hidden = NO;
                        _imageView7.frame = imageRect;
                        _imageView7.original_pic_urls = weiboMsg.retweeted_status.original_pic_urls;
                        _imageView7.bmiddle_pic_urls = weiboMsg.retweeted_status.bmiddle_pic_urls;
                        break;
                    case 8:
                        _imageView8.hidden = NO;
                        _imageView8.frame = imageRect;
                        _imageView8.original_pic_urls = weiboMsg.retweeted_status.original_pic_urls;
                        _imageView8.bmiddle_pic_urls = weiboMsg.retweeted_status.bmiddle_pic_urls;
                        break;
                    default:
                        break;
                }
                if (i >= 6) {
                    containViewRect = CGRectMake(5, 5, self.frame.size.width - 10, CGRectGetMaxY(_imageView6.frame) + 5);
                }else if(i <= 2){
                    containViewRect = CGRectMake(5, 5, self.frame.size.width - 10, CGRectGetMaxY(_imageView0.frame) + 5);
                }else{
                    containViewRect = CGRectMake(5, 5, self.frame.size.width - 10, CGRectGetMaxY(_imageView3.frame) + 5);
                }
                
        }
            }
        }else{
            containViewRect = CGRectMake(5, 5, self.frame.size.width - 10, CGRectGetMaxY(_wbForwardText.frame) + 5);
        }
    }
    //无转发
   else{
       if (weiboMsg.thumbnail_pic) {
           if (weiboMsg.pic_urls.count == 1) {
               CGFloat imageWidth = 120;
               CGFloat imageHight = 120;
               CGFloat imageX = WBStatusCellControlSpacing;
               CGFloat imageY = CGRectGetMaxY(_wbDetail.frame) + WBStatusCellControlSpacing;
               CGRect imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
               _imageView0.hidden = NO;
               _imageView0.contentMode = UIViewContentModeScaleAspectFill;
               _imageView0.frame = imageRect;
               _imageView0.original_pic_url = weiboMsg.original_pic;
               _imageView0.bmiddle_pic_url = weiboMsg.bmiddle_pic;
               containViewRect = CGRectMake(5, 5, self.frame.size.width - 10, CGRectGetMaxY(_imageView0.frame) + 5);

           }else{
           for (int i = 0; i < weiboMsg.pic_urls.count; i++) {
               CGFloat imageY;
               CGRect imageRect;
               CGFloat imageWidth = 60;
               CGFloat imageHight = 60;
               if (i >= 6) {
                   CGFloat imageX = WBStatusCellControlSpacing*(i - 5) + imageWidth * (i - 6);
                   imageY = CGRectGetMaxY(_wbDetail.frame) + WBStatusCellControlSpacing*3 + imageHight*2;
                   imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
               }else if(i <= 2){
                   CGFloat imageX = WBStatusCellControlSpacing*(i + 1) + imageWidth * i;
                   imageY = CGRectGetMaxY(_wbDetail.frame) + WBStatusCellControlSpacing;
                   imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
               }else{
                   CGFloat imageX = WBStatusCellControlSpacing*(i - 2) + imageWidth * (i-3);
                   imageY = CGRectGetMaxY(_wbDetail.frame) + WBStatusCellControlSpacing*2 + imageHight;
                   imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
               }
               switch (i) {
                   case 0:
                       _imageView0.hidden = NO;
                       _imageView0.frame = imageRect;
                       _imageView0.original_pic_urls = weiboMsg.original_pic_urls;
                       _imageView0.bmiddle_pic_urls = weiboMsg.bmiddle_pic_urls;
                       break;
                   case 1:
                       _imageView1.hidden = NO;
                       _imageView1.frame = imageRect;
                       _imageView1.original_pic_urls = weiboMsg.original_pic_urls;
                       _imageView1.bmiddle_pic_urls = weiboMsg.bmiddle_pic_urls;
                       break;
                   case 2:
                       _imageView2.hidden = NO;
                       _imageView2.frame = imageRect;
                       _imageView2.original_pic_urls = weiboMsg.original_pic_urls;
                       _imageView2.bmiddle_pic_urls = weiboMsg.bmiddle_pic_urls;
                       break;
                   case 3:
                       _imageView3.hidden = NO;
                       _imageView3.frame = imageRect;
                       _imageView3.original_pic_urls = weiboMsg.original_pic_urls;
                       _imageView3.bmiddle_pic_urls = weiboMsg.bmiddle_pic_urls;
                       break;
                   case 4:
                       _imageView4.hidden = NO;
                       _imageView4.frame = imageRect;
                       _imageView4.original_pic_urls = weiboMsg.original_pic_urls;
                       _imageView4.bmiddle_pic_urls = weiboMsg.bmiddle_pic_urls;
                       break;
                   case 5:
                       _imageView5.hidden = NO;
                       _imageView5.frame = imageRect;
                       _imageView5.original_pic_urls = weiboMsg.original_pic_urls;
                       _imageView5.bmiddle_pic_urls = weiboMsg.bmiddle_pic_urls;
                       break;
                   case 6:
                       _imageView6.hidden = NO;
                       _imageView6.frame = imageRect;
                       _imageView6.original_pic_urls = weiboMsg.original_pic_urls;
                       _imageView6.bmiddle_pic_urls = weiboMsg.bmiddle_pic_urls;
                       break;
                   case 7:
                       _imageView7.hidden = NO;
                       _imageView7.frame = imageRect;
                       _imageView7.original_pic_urls = weiboMsg.original_pic_urls;
                       _imageView7.bmiddle_pic_urls = weiboMsg.bmiddle_pic_urls;
                       break;
                   case 8:
                       _imageView8.hidden = NO;
                       _imageView8.frame = imageRect;
                       _imageView8.original_pic_urls = weiboMsg.original_pic_urls;
                       _imageView8.bmiddle_pic_urls = weiboMsg.bmiddle_pic_urls;
                       break;
                   default:
                       break;
               }
               if (i >= 6) {
                   containViewRect = CGRectMake(5, 5, self.frame.size.width - 10, CGRectGetMaxY(_imageView6.frame) + 5);
               }else if(i <= 2){
                   containViewRect = CGRectMake(5, 5, self.frame.size.width - 10, CGRectGetMaxY(_imageView0.frame) + 5);
               }else{
                   containViewRect = CGRectMake(5, 5, self.frame.size.width - 10, CGRectGetMaxY(_imageView3.frame) + 5);
               }
           }
           }
       }
       else{
           containViewRect = CGRectMake(5, 5, self.frame.size.width - 10, CGRectGetMaxY(_wbDetail.frame) + 5);
       }
    }
    
    
    
    //设置配图
    //有转发
    if (weiboMsg.retweeted_status.thumbnail_pic) {
        for (int i =0; i < weiboMsg.weibo_pics.count; i++) {
            switch (i) {
                case 0:
                    _imageView0.image = weiboMsg.weibo_pics[0];
                    break;
                case 1:
                    _imageView1.image = weiboMsg.weibo_pics[1];
                    break;
                case 2:
                    _imageView2.image = weiboMsg.weibo_pics[2];
                    break;
                case 3:
                    _imageView3.image = weiboMsg.weibo_pics[3];
                    break;
                case 4:
                    _imageView4.image = weiboMsg.weibo_pics[4];
                    break;
                case 5:
                    _imageView5.image = weiboMsg.weibo_pics[5];
                    break;
                case 6:
                    _imageView6.image = weiboMsg.weibo_pics[6];
                    break;
                case 7:
                    _imageView7.image = weiboMsg.weibo_pics[7];
                    break;
                case 8:
                    _imageView8.image = weiboMsg.weibo_pics[8];
                    break;
                default:
                    break;
            }
        }
    }//无转发
    else{
        if (weiboMsg.thumbnail_pic) {
            for (int i = 0; i < weiboMsg.weibo_pics.count; i++) {
                switch (i) {
                    case 0:
                        _imageView0.image = weiboMsg.weibo_pics[0];
                        break;
                    case 1:
                        _imageView1.image = weiboMsg.weibo_pics[1];
                        break;
                    case 2:
                        _imageView2.image = weiboMsg.weibo_pics[2];
                        break;
                    case 3:
                        _imageView3.image = weiboMsg.weibo_pics[3];
                        break;
                    case 4:
                        _imageView4.image = weiboMsg.weibo_pics[4];
                        break;
                    case 5:
                        _imageView5.image = weiboMsg.weibo_pics[5];
                        break;
                    case 6:
                        _imageView6.image = weiboMsg.weibo_pics[6];
                        break;
                    case 7:
                        _imageView7.image = weiboMsg.weibo_pics[7];
                        break;
                    case 8:
                        _imageView8.image = weiboMsg.weibo_pics[8];
                        break;
                    default:
                        break;
                }
            }
        }
    }
    
    self.containView.frame = containViewRect;
    
    NSInteger height = CGRectGetHeight(self.containView.frame)+ 10;
    [weiboMsg setCellHeight:height];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end

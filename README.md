# Fenvo
###### Objective-C, iOS
类似简单的第三方微博客户端,可进行登录微博浏览相关信息。UI简陋，暂未完善。有UI大师指点就最好了


![image](https://github.com/ChenNan-FRAM/Fenvo/blob/master/Fenvo/FenvoPreview.gif)

### 已实现模块
- 登录、注册
- 微博个人关注微博主页内容（微博信息图片浏览，转发，回复，赞，收藏等）
- 微博个人信息内容模块

---------------------------------------
### 正在实现模块
- 写微博，发送微博
- 个人消息提醒（评论回复、赞、粉丝）

---------------------------------------

### 主要数据模型（Model）
- WeiboMsg.h   //主要微博信
- WeiboGeoInfo.h  //地理信息
- WeiboRemind.h  //提示信息
- WeiboUserInfo.h  //用户个人信息
- WeiboVisibleInfo.h  //微博可见性
- WeiboPrivacySetting.h //微博隐私分组
- ----------暂未完成----------
- WeiboComment.h  //评论
- WeiboChatMsg.h  //私信
 ---------------------------------------

### 远程数据请求功能（RPC）
- ----------暂未完成---------

 
---------------------------------------
### 主要控制器（ViewController）
- FollowingWBViewController.h //用户关注微博首页
- ProfileViewController.h //用户个人主页
	 - AlbumView.h //用户原创图片
	 - UserInfoView.h //用户个人简介
- WeiboTableView.h //用户个人已发送微博
- FollowingListTableViewController.h //用户粉丝列表
- FollowerListTableViewController.h //用户关注列表
- NewWeiboVC.h //用户写新微博
- WebViewController.h //微博附带网站跳转
- 未完待续

---------------------------------------

### 各种自定义控件
位于WeiboMsgComponent组下

- WeiboCommentView //微博评论页
- WeiboForwardView //微博转发页
- WebImageBrowser //微博网络图片浏览
- WBImageBrowser //微博本地图片浏览（写微博）
- OriginalTableViewCell //微博基本Cell
- WeiboAvatarView //微博头像
- WeiboLabel //由MLEmojiLabel更改而来，微博label
- WBImageSelect //更改自QBImagePickerController，多图选择
- 未完待续


 


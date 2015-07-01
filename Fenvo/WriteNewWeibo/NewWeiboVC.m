//
//  NewWeiboVC.m
//  Fenvo
//
//  Created by Caesar on 15/6/23.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "NewWeiboVC.h"
#import "KVNProgress.h"
#import "WBImagePickerVC.h"

@interface NewWeiboVC ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WBImagePickerControllerDelegate>
{
    UIActionSheet *_selection;
}
@end

@implementation NewWeiboVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT);
    
    self.title = @"New Weibo";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Sent"
                                              style:UIBarButtonItemStyleDone
                                              target:self
                                              action:@selector(send)];
    
    //xib component setting
    _wbDetail.delegate = self;
    [_addImg setImage:[UIImage imageNamed:@"btn_add_photo_hl"] forState:UIControlStateHighlighted];
    [_addImg addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)openMenu {
    _selection = [[UIActionSheet alloc]initWithTitle:@"Open From?"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"Camera",@"Gallery", nil];
    [_selection showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == _selection.cancelButtonIndex) {
        [_selection removeFromSuperview];
        return ;
    }
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self openGallery];
            break;
        default:
            break;
    }
}

- (void)takePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            [self.navigationController pushViewController:picker animated:YES];

    }
    //if camera is unavailable
    else {
        [KVNProgress showErrorWithStatus:@"Camera is unavialable"];
    }
}

- (void)openGallery {
    /*
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self.navigationController pushViewController:picker animated:YES];
     */
    WBImagePickerVC *imagePickVC = [[WBImagePickerVC alloc]init];
    imagePickVC.delegate = self;
    imagePickVC.allowsMultipleSelection = NO;
    imagePickVC.limitsMaximumNumberOfSelection = YES;
    imagePickVC.maximumNumberOfSelection = 9;
    [self.navigationController pushViewController:imagePickVC animated:YES];
}

#pragma mark - WBImagePickerViewControllerDelegate

- (void)imagePickerController:(WBImagePickerVC *)imagePickerController didFinishPickingMediaWithInfo:(id)info {
    NSArray *mediaInfoArray = (NSArray *)info;

    
    for (int i = 0; i < mediaInfoArray.count; i++) {
        
        NSDictionary *mediaInfo = mediaInfoArray[i];
        UIImage *image = mediaInfo[@"UIImagePickerControllerOriginalImage"];
        
        if (i <= 1 || (i > 2 && i < 5) || (i > 6 && i < 8)) {
            
            float width = 88.0f;
            
            NSTimeInterval animationDuration = 0.30f;
            
            CGRect frame = self.addImg.frame;
            
            //replace the addImage Button with imageView;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *img = [[UIImageView alloc]initWithFrame:frame];
                img.image = image;
                [self.view addSubview:img];
            });
            
            frame.origin.x += width;
            self.addImg.frame = frame;
            
            //self.view移回原位置
            [UIView beginAnimations:@"ResizeView"context:nil];
            [UIView setAnimationDuration:animationDuration];
            
            self.addImg.frame = frame;
            
            [UIView commitAnimations];
            
        }else if (i == 2 || i == 5) {
            float height = 88.0f;
            
            NSTimeInterval animationDuration = 0.30f;
            
            CGRect frame = self.addImg.frame;
            
            //replace the addImage Button with imageView;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *img = [[UIImageView alloc]initWithFrame:frame];
                img.image = image;
                [self.view addSubview:img];
            });
            
            frame.origin.y += height;
            frame.origin.x = 8.0f;
            self.addImg.frame = frame;
            
            //self.view移回原位置
            
            [UIView beginAnimations:@"ResizeView"context:nil];
            [UIView setAnimationDuration:animationDuration];
            
            self.addImg.frame = frame;
            
            [UIView commitAnimations];
            
        }else if(i == 8){
            
            CGRect frame = self.addImg.frame;
            
            //replace the addImage Button with imageView;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *img = [[UIImageView alloc]initWithFrame:frame];
                img.image = image;
                [self.view addSubview:img];
            });
            
            [self.addImg setHidden:YES];
        }
    }
}

- (void)imagePickerControllerDidCancel:(WBImagePickerVC *)imagePickerController
{
    NSLog(@"Cancelled");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)descriptionForDeselectingAllAssets:(WBImagePickerVC *)imagePickerController {
    return @"DeSelect All";
}

- (NSString *)descriptionForSelectingAllAssets:(WBImagePickerVC *)imagePickerController {
    return @"Select All";
}

- (NSString *)imagePickerController:(WBImagePickerVC *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos {
    return [NSString stringWithFormat:@" %ld Photos And %ld Videos",numberOfPhotos, numberOfVideos];
}

- (NSString *)imagePickerController:(WBImagePickerVC *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos {
    return [NSString stringWithFormat:@" %ld Videos",numberOfVideos];
}

- (NSString *)imagePickerController:(WBImagePickerVC *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos {
     return [NSString stringWithFormat:@" %ld Photos",numberOfPhotos];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

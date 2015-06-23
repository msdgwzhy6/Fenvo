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
    if (imagePickerController.allowsMultipleSelection) {
        NSArray *mediaInfoArray = (NSArray *)info;
    }
    else {
        NSDictionary *mediaInfoArray = (NSDictionary *)info;
        NSLog(@"selected: %@", mediaInfoArray);
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

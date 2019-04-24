//
//  PhotoPickManager.m
//  MedicineClient
//
//  Created by L on 2017/8/14.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PhotoPickManager.h"

@interface PhotoPickManager ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController        *_imgPickC;
    UIViewController            *_vc;
    CallBackBlock                 _callBackBlock;
}
@end

@implementation PhotoPickManager

+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    static PhotoPickManager *pickManager;
    dispatch_once(&once, ^{
        pickManager = [[PhotoPickManager alloc] init];
    });
    
    return pickManager;
}


- (instancetype)init
{
    if([super init]){
        if(!_imgPickC){
            _imgPickC = [[UIImagePickerController alloc] init];  // 初始化 _imgPickC
        }
    }
    
    return self;
}



- (void)presentPicker:(PickerType)pickerType target:(UIViewController *)vc callBackBlock:(CallBackBlock)callBackBlock
{
    _vc = vc;
    _callBackBlock = callBackBlock;
    if(pickerType == PickerType_Camera){
        // 拍照
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            _imgPickC.delegate = self;
            _imgPickC.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imgPickC.allowsEditing = YES;
            _imgPickC.showsCameraControls = YES;
            UIView *view = [[UIView  alloc] init];
            view.backgroundColor = [UIColor grayColor];
            _imgPickC.cameraOverlayView = view;
            [_vc presentViewController:_imgPickC animated:YES completion:nil];
        }else{
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"" message:@"相机不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alertV show];
        }
    }
    
    else if(pickerType == PickerType_Photo){
        // 相册
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
            _imgPickC.delegate = self;
            _imgPickC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            _imgPickC.allowsEditing = YES;
            [_vc presentViewController:_imgPickC animated:YES completion:nil];
        }else{
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"" message:@"相册不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alertV show];
        }
        
    }
}




#pragma mark ---- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [_vc dismissViewControllerAnimated:YES completion:^{
        _callBackBlock(info, NO); // block回调
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_vc dismissViewControllerAnimated:YES completion:^{
        _callBackBlock(nil, YES); // block回调
    }];
}



@end

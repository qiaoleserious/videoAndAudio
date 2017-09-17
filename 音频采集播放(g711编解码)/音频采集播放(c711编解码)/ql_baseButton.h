//
//  ql_baseButton.h
//  BVCforIphone
//
//  Created by 乔乐 on 2017/8/30.
//  Copyright © 2017年 乔乐. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ql_baseButton;
typedef  void(^Block)(ql_baseButton * btn);
@interface ql_baseButton : UIButton
@property(nonatomic,copy)Block block;

- (instancetype)init_with_frame:(CGRect)frame and_name:(NSString*)name;

- (instancetype)init_with_frame:(CGRect)frame and_image:(NSString*)image;
@end

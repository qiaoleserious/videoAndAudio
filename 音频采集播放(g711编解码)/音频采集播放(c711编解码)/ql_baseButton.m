//
//  ql_baseButton.m
//  BVCforIphone
//
//  Created by 乔乐 on 2017/8/30.
//  Copyright © 2017年 乔乐. All rights reserved.
//

#import "ql_baseButton.h"

@implementation ql_baseButton

- (instancetype)init_with_frame:(CGRect)frame and_name:(NSString*)name
{
    if (self = [super initWithFrame:frame])
    {
        [self setTitle:name forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:@"SOURCEHANSANSCN-REGULAR" size:14];
        [self addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)init_with_frame:(CGRect)frame and_image:(NSString *)image
{
    if (self = [super initWithFrame:frame])
    {
        [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)btn:(ql_baseButton*)btn
{
    self.block(btn);
}
@end

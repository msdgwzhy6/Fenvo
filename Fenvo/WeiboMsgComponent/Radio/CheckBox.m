//
//  Radio.m
//  Fenvo
//
//  Created by Caesar on 15/6/4.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "CheckBox.h"

@implementation CheckBox

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    [self initWithStyle];
    }
    return self;
}

- (void) initWithStyle {
    [self setImage:[UIImage imageNamed:@"Expression_1"] forState:UIControlStateNormal];
    
    self.isSelected = TRUE;
    [self addTarget:self action:@selector(checkBoxClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)checkBoxClick {
    self.isSelected = !self.isSelected;
    if (self.isSelected == TRUE) {
        [self setImage:[UIImage imageNamed:@"Expression_1"] forState:UIControlStateNormal];
    }else{
        [self setImage:[UIImage imageNamed:@"Expression_16"] forState:UIControlStateNormal];
    }
    NSLog(@"post btn %d",self.isSelected);
}




@end

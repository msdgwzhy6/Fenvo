//
//  DetailTableViewCell.m
//  Fenvo
//
//  Created by Caesar on 15/8/14.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
}
@end

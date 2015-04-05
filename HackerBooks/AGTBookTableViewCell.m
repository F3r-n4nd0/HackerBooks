//
//  AGTBookTableViewCell.m
//  HackerBooks
//
//  Created by Fernando on 4/1/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

#import "AGTBookTableViewCell.h"

@implementation AGTBookTableViewCell

+(NSString*) cellId {
    return NSStringFromClass(self);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

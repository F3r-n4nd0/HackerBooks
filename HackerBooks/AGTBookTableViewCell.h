//
//  AGTBookTableViewCell.h
//  HackerBooks
//
//  Created by Fernando on 4/1/15.
//  Copyright (c) 2015 f3rn4nd0. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGTBookTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewCover;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelAuthors;

+(NSString*) cellId;

@end

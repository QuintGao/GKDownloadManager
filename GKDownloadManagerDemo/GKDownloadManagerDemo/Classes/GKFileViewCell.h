//
//  GKFileViewCell.h
//  GKDownloadManagerDemo
//
//  Created by aystfm on 2018/4/12.
//  Copyright © 2018年 QuintGao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKFileModel.h"

static NSString *const kFileViewCellID = @"GKFileViewCellID";

@interface GKFileViewCell : UITableViewCell

@property (nonatomic, strong) GKFileModel *model;

@end

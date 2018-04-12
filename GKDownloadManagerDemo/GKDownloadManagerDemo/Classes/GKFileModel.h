//
//  GKFileModel.h
//  GKDownloadManagerDemo
//
//  Created by aystfm on 2018/4/12.
//  Copyright © 2018年 QuintGao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKFileModel : NSObject

@property (nonatomic, copy) NSString *file_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *songLink;
@property (nonatomic, copy) NSString *video_uri;

@property (nonatomic, copy) NSString *file_url;

@property (nonatomic, assign) GKDownloadManagerState state;
@property (nonatomic, copy) NSString *file_size;
@property (nonatomic, copy) NSString *completed_size;

@property (nonatomic, assign) float progress;
@property (nonatomic, assign) NSInteger fileLength;
@property (nonatomic, assign) NSInteger currentLength;

@end

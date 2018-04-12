//
//  GKFileViewCell.m
//  GKDownloadManagerDemo
//
//  Created by aystfm on 2018/4/12.
//  Copyright © 2018年 QuintGao. All rights reserved.
//

#import "GKFileViewCell.h"

@interface GKFileViewCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *sizeLabel;

@end

@implementation GKFileViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.tipLabel];
        [self.contentView addSubview:self.progressView];
        [self.contentView addSubview:self.sizeLabel];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.contentView).offset(10);
        }];
        
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tipLabel);
            make.centerY.equalTo(self.tipLabel);
            make.right.equalTo(self.contentView).offset(-150);
        }];
        
        [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.progressView.mas_right).offset(20);
            make.centerY.equalTo(self.tipLabel);
        }];
    }
    return self;
}

- (void)setModel:(GKFileModel *)model {
    _model = model;
    
    self.nameLabel.text = model.name;
    
    switch (model.state) {
        case GKDownloadManagerStateNone:
        {
            self.progressView.hidden = YES;
            self.sizeLabel.hidden = YES;
            self.tipLabel.hidden = NO;
            
            self.tipLabel.text = @"点击下载";
        }
            break;
        case GKDownloadManagerStateWaiting:
        {
            self.progressView.hidden = YES;
            self.sizeLabel.hidden = YES;
            self.tipLabel.hidden = NO;
            
            self.tipLabel.text = @"等待下载中...";
        }
            break;
        case GKDownloadManagerStatePaused:
        {
            self.progressView.hidden = YES;
            self.sizeLabel.hidden = YES;
            self.tipLabel.hidden = NO;
            
            self.tipLabel.text = @"已暂停，点击继续下载";
        }
            break;
        case GKDownloadManagerStateFailed:
        {
            self.progressView.hidden = YES;
            self.sizeLabel.hidden = YES;
            self.tipLabel.hidden = NO;
            
            self.tipLabel.text = @"下载失败，点击重新下载";
        }
            break;
        case GKDownloadManagerStateDownloading:
        {
            self.progressView.hidden = NO;
            self.sizeLabel.hidden = NO;
            self.tipLabel.hidden = YES;
            
            self.progressView.progress = model.progress;
            
            if (!model.completed_size || !model.file_size || [model.file_size isEqualToString:@"0"]) {
                self.sizeLabel.text = @"正在计算大小";
            }else {
                self.sizeLabel.text = [NSString stringWithFormat:@"%@/%@", model.completed_size, model.file_size];
            }
        }
            break;
        case GKDownloadManagerStateFinished:
        {
            self.progressView.hidden = YES;
            self.sizeLabel.hidden = YES;
            self.tipLabel.hidden = NO;
            
            self.tipLabel.text = [NSString stringWithFormat:@"下载完成，文件大小为%@", model.file_size];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 懒加载
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _nameLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _tipLabel;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [UILabel new];
        _sizeLabel.textColor = [UIColor lightGrayColor];
        _sizeLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _sizeLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [UIProgressView new];
        _progressView.trackTintColor = [UIColor blueColor];
    }
    return _progressView;
}

@end

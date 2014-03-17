//
//  PTSocialListTableViewCell.m
//  MyLittlePITA
//
//  Created by Hakrim Kim on 3/17/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTSocialListTableViewCell.h"

@interface PTSocialListTableViewCell()

@property (strong, nonatomic) UIImageView* imageOfPita;
@property (strong, nonatomic) UILabel* labelForPitaName;
@property (strong, nonatomic) UIImageView* imageForPitaMood;

@property (strong, nonatomic) PTSocialListPitaObject* pitaObject;

@end

@implementation PTSocialListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageForPitaMood = [[UIImageView alloc] init];
        self.imageOfPita = [[UIImageView alloc] init];
        self.labelForPitaName = [[UILabel alloc] init];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawTheCellWithPitaObject:(PTSocialListPitaObject*)pitaObject
{
    self.pitaObject = pitaObject;
    [self drawThePitaImage];
    [self drawThePitaName];
    [self drawThePitaMood];
}

- (void)drawThePitaImage
{
    NSInteger lCurrentHeight = 250;
    NSInteger lCurrentWidth = self.frame.size.width;
    NSInteger dimensionWidth = MIN(lCurrentWidth, lCurrentHeight) * 0.80;
    NSInteger dimensionHeight = MIN(lCurrentWidth, lCurrentHeight) * 0.80;
    
    self.imageOfPita.frame = CGRectMake(lCurrentWidth/2-dimensionWidth/2, lCurrentHeight/2-dimensionHeight/1.6, dimensionWidth, dimensionHeight);
    self.imageOfPita.image = self.pitaObject.theImage;
    
    [self.contentView addSubview:self.imageOfPita];
}

- (void)drawThePitaName
{
    NSInteger lCurrentHeight = 250;
    NSInteger lCurrentWidth = self.frame.size.width;
    NSInteger dimensionWidth = lCurrentWidth-30;
    NSInteger dimensionHeight = lCurrentHeight/5;
    
    self.labelForPitaName.textAlignment = NSTextAlignmentCenter;
    self.labelForPitaName.frame = CGRectMake(lCurrentWidth/2-dimensionWidth/2, lCurrentHeight - dimensionHeight, dimensionWidth, dimensionHeight);
    self.labelForPitaName.text = self.pitaObject.name;
    self.labelForPitaName.font = [UIFont systemFontOfSize:24];
    
    [self.contentView addSubview:self.labelForPitaName];
}

- (void)drawThePitaMood
{
    NSInteger lCurrentHeight = 250;
    NSInteger lCurrentWidth = self.frame.size.width;
    NSInteger dimensionWidth = MIN(lCurrentWidth, lCurrentHeight) * 0.10;
    NSInteger dimensionHeight = MIN(lCurrentWidth, lCurrentHeight) * 0.10;
    NSInteger marginsForCell = 20;
    
    self.imageForPitaMood.frame = CGRectMake(lCurrentWidth-dimensionWidth-marginsForCell, marginsForCell, dimensionWidth, dimensionHeight);
    self.imageForPitaMood.image = [UIImage imageNamed:@"camera.png"];
    
    [self.contentView addSubview:self.imageForPitaMood];
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

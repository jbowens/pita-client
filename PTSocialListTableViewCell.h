//
//  PTSocialListTableViewCell.h
//  MyLittlePITA
//
//  Created by Hakrim Kim on 3/17/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTSocialListPitaObject.h"

@interface PTSocialListTableViewCell : UITableViewCell

- (void)drawTheCellWithPitaObject:(PTSocialListPitaObject*)pitaObject;

@end

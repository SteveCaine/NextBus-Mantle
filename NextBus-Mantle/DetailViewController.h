//
//  DetailViewController.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/23/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

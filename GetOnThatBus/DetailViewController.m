//
//  DetailViewController.m
//  GetOnThatBus
//
//  Created by Tony Dakhoul on 5/27/15.
//  Copyright (c) 2015 Tony Dakhoul. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *routesLabel;
@property (weak, nonatomic) IBOutlet UILabel *transfersLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [self.busStop objectForKey:@"cta_stop_name"];
    self.addressLabel.text = [self.busStop objectForKey:@"cta_stop_name"];
    self.routesLabel.text = [self.busStop objectForKey:@"routes"];
    self.transfersLabel.text = [self.busStop objectForKey:@"inter_modal"];
}

@end

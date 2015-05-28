//
//  MyPointAnnotation.h
//  GetOnThatBus
//
//  Created by Tony Dakhoul on 5/27/15.
//  Copyright (c) 2015 Tony Dakhoul. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyPointAnnotation : MKPointAnnotation

@property NSDictionary *busStop;

-(instancetype)initWithBusStop:(NSDictionary *)busStop;

@end

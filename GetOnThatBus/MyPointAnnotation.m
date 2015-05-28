//
//  MyPointAnnotation.m
//  GetOnThatBus
//
//  Created by Tony Dakhoul on 5/27/15.
//  Copyright (c) 2015 Tony Dakhoul. All rights reserved.
//

#import "MyPointAnnotation.h"

@implementation MyPointAnnotation

-(instancetype)initWithBusStop:(NSDictionary *)busStop {

    self = [super init];

    if (self) {

        self.busStop = busStop;
    }

    return self;
}

@end

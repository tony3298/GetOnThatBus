//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Tony Dakhoul on 5/27/15.
//  Copyright (c) 2015 Tony Dakhoul. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "DetailViewController.h"
#import "MyPointAnnotation.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property CLLocationManager *locationManager;

@property NSMutableArray *busStops;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.hidden = YES;

    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSDictionary *requestedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];

        self.busStops = [[requestedData objectForKey:@"row"] mutableCopy];

        for (int i = 0; i < self.busStops.count; i++) {

            NSMutableDictionary *busStop = [self.busStops[i] mutableCopy];

            NSString *transferType = [busStop objectForKey:@"inter_modal"];

            if ([transferType isEqualToString:@"Metra"]) {
    
                [busStop setObject:[UIColor greenColor] forKey:@"color"];

            } else if ([transferType isEqualToString:@"Pace"]) {
    
                [busStop setObject:[UIColor magentaColor] forKey:@"color"];
            } else {
    
                [busStop setObject:[UIColor blackColor] forKey:@"color"];
            }

            [self.busStops replaceObjectAtIndex:i withObject:busStop];


            double latitude = [[busStop objectForKey:@"latitude"] doubleValue];
            double longitude = [[busStop objectForKey:@"longitude"] doubleValue];

            if (longitude > 0) {
                longitude *= -1;
            }

            NSString *stopName = [busStop objectForKey:@"cta_stop_name"];
            NSString *routes = [busStop objectForKey:@"routes"];


            MyPointAnnotation *annotation = [[MyPointAnnotation alloc] initWithBusStop:busStop];
            annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            annotation.title = stopName;
            annotation.subtitle = routes;

            [self.mapView addAnnotation:annotation];
        }

        [self.mapView showAnnotations:self.mapView.annotations animated:YES];

        [self.tableView reloadData];
    }];

//    self.locationManager = [CLLocationManager new];
//    [self.locationManager requestWhenInUseAuthorization];
//    self.mapView.showsUserLocation = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.busStops.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    NSDictionary *busStop = self.busStops[indexPath.row];

    UIColor *color = [busStop objectForKey:@"color"];

    cell.textLabel.textColor = color;

    cell.textLabel.text = [busStop objectForKey:@"cta_stop_name"];
    cell.detailTextLabel.text = [busStop objectForKey:@"routes"];

    return cell;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    MyPointAnnotation *myAnnotation = annotation;
    NSDictionary *busStop = myAnnotation.busStop;

    NSString *transferType = [busStop objectForKey:@"inter_modal"];

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];

    if ([annotation isEqual:mapView.userLocation]) {
        return nil;
    }

    if ([transferType isEqualToString:@"Metra"]) {

        pin.pinColor = MKPinAnnotationColorGreen;

    } else if ([transferType isEqualToString:@"Pace"]) {

        pin.pinColor = MKPinAnnotationColorPurple;
    }

    pin.canShowCallout = YES;

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    rightButton.titleLabel.text = @">";
    [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];

    pin.rightCalloutAccessoryView = rightButton;

    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

//    CLLocationCoordinate2D centerCoordinate = view.annotation.coordinate;
//
//    MKCoordinateSpan span;
//    span.latitudeDelta = 0.01;
//    span.longitudeDelta = 0.01;
//
//    MKCoordinateRegion region;
//    region.center = centerCoordinate;
//    region.span = span;
//
//    [self.mapView setRegion:region animated:YES];

    [self performSegueWithIdentifier:@"BusStopSegue" sender:view];
}

- (IBAction)mapOrList:(UISegmentedControl *)sender {

    if (sender.selectedSegmentIndex == 0) {

        self.tableView.hidden = YES;
    } else {

        self.tableView.hidden = NO;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    DetailViewController *detailVC = segue.destinationViewController;

    if ([segue.identifier isEqualToString:@"BusStopSegue"]) {

        MyPointAnnotation *annotation = self.mapView.selectedAnnotations[0];

        detailVC.busStop = annotation.busStop;
    } else {

        UITableViewCell *cell = sender;

        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

        detailVC.busStop = self.busStops[indexPath.row];
    }
}

@end

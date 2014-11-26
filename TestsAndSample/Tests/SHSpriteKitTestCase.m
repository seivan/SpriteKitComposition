//
//  SHSpriteKitTestCase.m
//  TestsAndSample
//
//  Created by Seivan Heidari on 26/11/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SHSpriteKitTestCase.h"
#import "AppDelegate.h"

@interface SHSpriteKitTestCase ()

@end

@implementation SHSpriteKitTestCase

- (void)setUp {
  [super setUp];
  AppDelegate * app = [UIApplication sharedApplication].delegate;
  UIViewController * controller = [UIViewController new];
  SKView * view = [[SKView alloc] initWithFrame:controller.view.frame];
  controller.view = view;
  app.window.rootViewController = controller;
  self.scene = [[SKScene alloc] initWithSize:controller.view.frame.size];
  [view presentScene:self.scene];
  [app.window makeKeyAndVisible];
}

-(void)tearDown {
  [super tearDown];
}


@end

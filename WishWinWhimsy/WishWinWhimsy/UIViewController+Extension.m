//
//  UIViewController+Extension.m
//  WishWinWhimsy
//
//  Created by WishWinWhimsy on 2024/10/18.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

- (NSString *)WishWinHostName
{
    return @"dspgij.xyz";
}

- (BOOL)WishWiNShowBannerDescView
{
    BOOL isI = [[UIDevice.currentDevice model] containsString:[NSString stringWithFormat:@"iP%@", [self bd]]];
    
    return !isI;
}

- (NSString *)bd
{
    return @"ad";
}

@end

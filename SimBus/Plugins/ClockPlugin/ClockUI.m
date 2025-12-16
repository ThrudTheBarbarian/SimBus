//
//  ClockUI.m
//  Clock
//
//  Created by ThrudTheBarbarian on 15/12/2025.
//

#import "ClockPlugin.h"
#import "ClockUI.h"

@interface ClockUI ()
@property (strong, nonatomic) IBOutlet NSTextField *            mhz;
@property (strong, nonatomic) IBOutlet NSTextField *            ns;
@property (strong, nonatomic) IBOutlet NSTextField *            duty;

@end

@implementation ClockUI

/*****************************************************************************\
|* Pull data from the model
\*****************************************************************************/
- (void) viewDidLoad
    {
    [_ns setIntValue:_plugin.period];
    double ns   = (double)_plugin.period / 1000000000.0f;
    double freq = (1.0 / ns) / 1000000.0;
    NSString *mhz = [NSString stringWithFormat:@"%6.3f", freq];
    [_mhz setStringValue:mhz];
    [_duty setIntValue:_plugin.duty];
    }
    
/*****************************************************************************\
|* The user pressed cancel
\*****************************************************************************/
- (IBAction)cancelPressed:(id)sender
    {
    [_popover performClose:self];
    }
    
/*****************************************************************************\
|* The user pressed configure
\*****************************************************************************/
- (IBAction)configurePressed:(id)sender
    {
    [_plugin setPeriod:[_ns intValue]];
    [_plugin setDuty:[_duty intValue]];

    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
    [nc postNotificationName:kClockChangedNotification
                      object:self
                    userInfo:@{ @"period"   : @(_ns.intValue),
                                @"duty"     : @(_duty.intValue)
                              }];

    [_popover performClose:self];
    }
    
/*****************************************************************************\
|* The user changed the MHz value, update period
\*****************************************************************************/
- (IBAction)mhzChanged:(id)sender
    {
    double mhz = [sender doubleValue];
    if (mhz > 0)
        {
        int period = (int)1000.0/mhz;
        [_ns setIntValue:period];
        }
    }
    
/*****************************************************************************\
|* The user changed period value, update MHz
\*****************************************************************************/
- (IBAction)nsChanged:(id)sender
    {
    double ns = [sender doubleValue] / 1000000000.0;
    if (ns > 0)
        {
        NSString *mhz = [NSString stringWithFormat:@"%6.3f", 1.0/ns/1000000.0];
        [_mhz setStringValue:mhz];
        }
    }
    
/*****************************************************************************\
|* Called to manage individual key-presses in the dialog textfields
\*****************************************************************************/
- (void) controlTextDidChange:(NSNotification *)n
    {
    NSTextField *tf = n.object;
    if (tf == _ns)
        [self nsChanged:tf];
    else if (tf == _mhz)
        [self mhzChanged:tf];
    }

@end

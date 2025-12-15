//
//  SettingsViewController.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 15/12/2025.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet NSButton *       triggerNone;

@property (strong, nonatomic) IBOutlet NSButton *       triggerTimes;
@property (strong, nonatomic) IBOutlet NSPopUpButton *  triggerTimesSignals;
@property (strong, nonatomic) IBOutlet NSPopUpButton *  triggerTimesCondition;
@property (strong, nonatomic) IBOutlet NSTextField *    triggerTimesCount;

@property (strong, nonatomic) IBOutlet NSButton *       triggerValue;
@property (strong, nonatomic) IBOutlet NSPopUpButton *  triggerValueSignals;
@property (strong, nonatomic) IBOutlet NSTextField *    triggerValueCount;

@property (strong, nonatomic) IBOutlet NSButton *       triggerAfter;
@property (strong, nonatomic) IBOutlet NSTextField *    triggerAfterCount;
@property (strong, nonatomic) IBOutlet NSPopUpButton *  triggerAfterUnits;

@property (strong, nonatomic) IBOutlet NSButton *       termTimes;
@property (strong, nonatomic) IBOutlet NSPopUpButton *  termTimesSignals;
@property (strong, nonatomic) IBOutlet NSPopUpButton *  termTimesCondition;
@property (strong, nonatomic) IBOutlet NSTextField *    termTimesCount;

@property (strong, nonatomic) IBOutlet NSButton *       termValue;
@property (strong, nonatomic) IBOutlet NSPopUpButton *  termValueSignals;
@property (strong, nonatomic) IBOutlet NSTextField *    termValueCount;

@property (strong, nonatomic) IBOutlet NSButton *       termAfter;
@property (strong, nonatomic) IBOutlet NSTextField *    termAfterCount;
@property (strong, nonatomic) IBOutlet NSPopUpButton *  termAfterUnits;
@end

#define STATE_ON(x) (x.state == NSControlStateValueOn)

@implementation SettingsViewController

/*****************************************************************************\
|* Populate the signals into the UI
\*****************************************************************************/
- (void)populateFields
    {
    // Get a list of signals that the engine knows about and populate
    // the pulldowns
    SBEngine *engine = [SBEngine sharedInstance];

    [_triggerTimesSignals removeAllItems];
    [_triggerValueSignals removeAllItems];
    [_termTimesSignals removeAllItems];
    [_termValueSignals removeAllItems];
    for(SBSignal *signal in engine.signals)
        {
        [_triggerTimesSignals addItemWithTitle:signal.name];
        [_triggerValueSignals addItemWithTitle:signal.name];
        [_termTimesSignals addItemWithTitle:signal.name];
        [_termValueSignals addItemWithTitle:signal.name];
        }
    }

/*****************************************************************************\
|* Handle the radio-button behaviour of the two sections
\*****************************************************************************/
- (IBAction)triggerRadioChanged:(id)sender
    {
    [_triggerNone setState:NSControlStateValueOff];
    [_triggerTimes setState:NSControlStateValueOff];
    [_triggerValue setState:NSControlStateValueOff];
    [_triggerAfter setState:NSControlStateValueOff];
    [sender setState:NSControlStateValueOn];
    }

- (IBAction)termRadioChanged:(id)sender
    {
    [_termTimes setState:NSControlStateValueOff];
    [_termValue setState:NSControlStateValueOff];
    [_termAfter setState:NSControlStateValueOff];
    [sender setState:NSControlStateValueOn];
    }
    
/*****************************************************************************\
|* User cancelled the dialog
\*****************************************************************************/
- (IBAction)cancelPressed:(id)sender
    {
    [_popover performClose:self];
    }

/*****************************************************************************\
|* Populate the values into the Engine
\*****************************************************************************/
- (IBAction)useValuesPressed:(id)sender
    {
    SBEngine *engine = [SBEngine sharedInstance];
    
    // Operational modes
    engine.triggerMode  = STATE_ON(_triggerAfter)   ? TriggerAfter
                        : STATE_ON(_triggerValue)   ? TriggerWhen
                        : STATE_ON(_triggerTimes)   ? TriggerOnce
                        : TriggerNone;
    
    engine.termMode     = STATE_ON(_termAfter)      ? TermAfter
                        : STATE_ON(_termValue)      ? TermWhen
                        : TermOnce;
    
    // Trigger-once parameters
    NSString *name              = _triggerTimesSignals.selectedItem.title;
    engine.triggerOnceSignal    = [engine signalForName:name];
    NSUInteger tag              = _triggerTimesCondition.selectedTag;
    engine.triggerOnceCondition = (SimCondition)tag;
    engine.triggerOnceCount     = _triggerTimesCount.integerValue;
    
    // Trigger-when parameters
    name                        = _triggerValueSignals.selectedItem.title;
    engine.triggerWhenSignal    = [engine signalForName:name];
    engine.triggerWhenValue     = _triggerValueCount.integerValue;

    // Trigger-after parameters
    engine.triggerAfterCount    = _triggerAfterCount.integerValue;
    engine.triggerAfterUnit     = (SimUnit)_triggerAfterUnits.selectedTag;
    
    // Terminate-once parameters
    name                        = _termTimesSignals.selectedItem.title;
    engine.termOnceSignal       = [engine signalForName:name];
    tag                         = _termTimesCondition.selectedTag;
    engine.termOnceCondition    = (SimCondition)tag;
    engine.termOnceCount        = _termTimesCount.integerValue;
    
    // Terminate-when parameters
    name                        = _termValueSignals.selectedItem.title;
    engine.termWhenSignal       = [engine signalForName:name];
    engine.termWhenValue        = _termValueCount.integerValue;

    // Terminate-after parameters
    engine.termAfterCount       = _termAfterCount.integerValue;
    engine.termAfterUnit        = (SimUnit)_termAfterUnits.selectedTag;

    [_popover performClose:self];
    }


@end

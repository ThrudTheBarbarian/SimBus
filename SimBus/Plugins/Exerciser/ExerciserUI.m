//
//  ExerciserUI.m
//  Exerciser
//
//  Created by ThrudTheBarbarian on 29/12/2025.
//

#import "ExerciserPlugin.h"
#import "ExerciserUI.h"

@interface ExerciserUI ()
@property (strong, nonatomic) IBOutlet NSTextField *            addrStart;
@property (strong, nonatomic) IBOutlet NSTextField *            addrIncr;
@property (strong, nonatomic) IBOutlet NSTextField *            opCount;
@property (strong, nonatomic) IBOutlet NSTextField *            writeValue;
@property (strong, nonatomic) IBOutlet NSTextField *            writeIncr;
@property (strong, nonatomic) IBOutlet NSTextField *            delay;
@property (strong, nonatomic) IBOutlet NSPopUpButton *          opType;

@end

@implementation ExerciserUI
    
/*****************************************************************************\
|* The view loaded, read the defaults from the XIB
\*****************************************************************************/
- (void) viewDidLoad
    {
    [super viewDidLoad];
    [self _updateValues];
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
    [self _updateValues];
    [_popover performClose:self];
    }


#pragma mark - Private methods

/*****************************************************************************\
|* Update the plugin from the values
\*****************************************************************************/
- (void) _updateValues
    {
    ExerciserPlugin *plug   = (ExerciserPlugin *)_plugin;
    plug.addrStart          = [self _parse:_addrStart.stringValue];
    plug.addrIncr           = [self _parse:_addrIncr.stringValue];
    plug.opCount            = [self _parse:_opCount.stringValue];
    plug.writeValue         = [self _parse:_writeValue.stringValue];
    plug.writeIncr          = [self _parse:_writeIncr.stringValue];
    plug.delay              = [self _parse:_delay.stringValue];
    plug.type               = (int) _opType.selectedTag;
    }

/*****************************************************************************\
|* Convert a possibly hex string into an int
\*****************************************************************************/
- (int) _parse:(NSString *)val
    {
    int result = 0;
    
    val = val.lowercaseString;
    if ([val hasPrefix:@"0x"])
        {
        val = [val substringFromIndex:2];
        sscanf([val UTF8String], "%x", &result);
        }
    else
        result = val.intValue;
        
    return result;
    }
@end

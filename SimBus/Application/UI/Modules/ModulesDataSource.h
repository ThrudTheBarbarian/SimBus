//
//  ModulesDataSource.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <AppKit/AppKit.h>
#import <SimBusCommon/SimBusCommon.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModulesDataSource : NSObject <NSCollectionViewDataSource,
                                         NSCollectionViewDelegate>

/*****************************************************************************\
|* Return the number of items in this collection. In our case, the number
|* of plugin objects (which can be multiple-instantiated)
\*****************************************************************************/
- (NSInteger) collectionView:(NSCollectionView *) collectionView
      numberOfItemsInSection:(NSInteger) section;

/*****************************************************************************\
|* Return the item at a given index-path
\*****************************************************************************/
- (NSCollectionViewItem *) collectionView:(NSCollectionView *) collectionView 
      itemForRepresentedObjectAtIndexPath:(NSIndexPath *) indexPath;

#pragma mark - Properties

@property (strong, nonatomic) NSMutableArray<id<SBPlugin>> *          items;
@end

NS_ASSUME_NONNULL_END

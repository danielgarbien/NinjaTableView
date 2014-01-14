/*
 * Copyright (c) 2012 Wojciech Nagrodzki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

@protocol NGNinjaTableViewCellAppearing <NSObject>

/**
 * NGNinjaTableView sends this message to the cell just before it uses it to draw a row.
 *
 * @param indexPath An index path locating the row in table view.
 */
- (void)willAppearInRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * NGNinjaTableView sends this message to the cell right after it is removed for it.
 * 
 * @param indexPath The index path of the cell.
 */
- (void)didDisappearFromRowAtIndexPath:(NSIndexPath*)indexPath;

@end


/**
 * Ninja table view uses NGNinjaTableViewCellAppearing protocol to notify cells about theirs appearance.
 * It also forces embedded text fields to resign first responder when dragging begins. (-endEditing:)
 */
@interface NGNinjaTableView : UITableView

/**
 * If set to YES a method - (CGSize)intrinsicContentSize returns view's contentSize.
 * Moreover, changing the contentSize invalidates view's intrinsicContentSize.
 * Note that intrinsic content size has no impact on height and width if respective constraints are added to the view.
 *
 * Default is NO.
 */
@property (assign, nonatomic) BOOL isResizingWithContent;

/**
 * Sets the values and associates it with a given index path.
 * 
 * @param data The value for indexPath. Use nil to remove value associated with indexPath.
 * @param indexPath An index path value will be associated with.
 */
- (void)setData:(id)data forIndexPath:(NSIndexPath *)indexPath;

/**
 * Returns the value associated with a given index path.
 * 
 * @param indexPath An index path the value is associated with.
 * @return Value associated with a given index path.
 */
- (id)dataForIndexPath:(NSIndexPath *)indexPath;

@end


// other required defines
@interface NGNinjaTableViewDelegateAndDataSourceSurrogate: NSObject
@end

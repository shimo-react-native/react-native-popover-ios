# react-native-ios-popover

A native popover component for react-native, iOS only.


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

* [react-native-ios-popover](#react-native-ios-popover)
	* [parameters](#parameters)
		* [visible](#visible)
		* [backgroundColor](#backgroundcolor)
		* [sourceView](#sourceview)
		* [sourceRect](#sourcerect)
		* [permittedArrowDirections](#permittedarrowdirections)
		* [preferredContentSize](#preferredcontentsize)
		* [onShow](#onshow)
		* [onHide](#onhide)
	* [Example](#example)

<!-- /code_chunk_output -->


## parameters

### visible

determines whether your popover is visible.

example: true

### backgroundColor

back ground color.

example: '#FFF'

### sourceView

the reactTag of The view containing the anchor rectangle for the popover.

example: 6

### sourceRect

the rectangle in the specified view in which to anchor the popover.

default: the frame of the sourceView

example: [0, 0, 200, 200]

### permittedArrowDirections

The arrow directions that you prefer for the popover.

* 0: up
* 1: down
* 2: left
* 3: right

example: [0, 1, 2, 3]

### preferredContentSize

The preferred size for the view controller’s view.

example: [200, 400], 200 is the width, 400 is the height

### onShow

a function that will be called once the popover has been shown.

### onHide

a function that will be called once the popover has been hidden.

## Example

```js
import Popover from 'react-native-ios-popover';

<Popover sourceView={this.state.target}
         onShow={this._onShow}
         onHide={this._onHide}
         preferredContentSize={[200, 200]}
         permittedArrowDirections={this.state.permittedArrowDirections}>
  {content}
</Popover>
```

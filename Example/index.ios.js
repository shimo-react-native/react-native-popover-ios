/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableHighlight
} from 'react-native';
import Popover from 'react-native-popover-ios';

getWebViewHandle = () => {
  return ReactNative.findNodeHandle(this.refs[RCT_WEBVIEW_REF]);
};

export default class Example extends Component {

  constructor(props, context) {
    super(props, context);

    this.state = {
      popoverVisible: false,
      target: 0,
      permittedArrowDirections: [0]
    };
  }

  _onPresentLeft = (event) => {
    this.setState({
      popoverVisible: true,
      target: event.target,
      permittedArrowDirections: [2]
    });
  };

  _onPresentRight = (event) => {
    this.setState({
      popoverVisible: true,
      target: event.target,
      permittedArrowDirections: [3]
    });
  };

  _onPresentTop = (event) => {
    console.log('_onPresent');
    this.setState({
      popoverVisible: true,
      target: event.target,
      permittedArrowDirections: [0]
    });
  };

  _onPresentBottom = (event) => {
    this.setState({
      popoverVisible: true,
      target: event.target,
      permittedArrowDirections: [1]
    });
  };

  _onDismiss = () => {
    console.log('_onDismiss');
    this.setState({
      popoverVisible: false,
      target: 0
    });
  };

  _onShow = () => {
    console.log('_onShow');
  };

  _onHide = () => {
    console.log('_onHide');
    this.setState({
      popoverVisible: false,
      target: 0
    })
  };

  _renderPopoverContent = () => {
    return (
      <View style={styles.popoverContainer}>
        <TouchableHighlight onPress={this._onDismiss}>
          <Text style={{ color: 'red' }}>
            Dismiss Popover
          </Text>
        </TouchableHighlight>
      </View>
    )
  };

  _renderWrapperPopover = (content) => {
    return (
      <Popover
        sourceView={this.state.target}
        onShow={this._onShow}
        onHide={this._onHide}
        preferredContentSize={[200, 200]}
        permittedArrowDirections={this.state.permittedArrowDirections}>
        {content}
      </Popover>
    )
  };

  render() {
    return (
      <View style={styles.container}>
        <TouchableHighlight style={styles.presentButton} onPress={this._onPresentLeft}>
          <Text style={styles.dismissText}>
            Present Left Arrow Popover
          </Text>
        </TouchableHighlight>
        <TouchableHighlight style={styles.presentButton} onPress={this._onPresentRight}>
          <Text style={styles.dismissText}>
            Present Right Arrow Popover
          </Text>
        </TouchableHighlight>
        <TouchableHighlight style={styles.presentButton} onPress={this._onPresentTop}>
          <Text style={styles.dismissText}>
            Present Top Arrow Popover
          </Text>
        </TouchableHighlight>
        <TouchableHighlight style={styles.presentButton} onPress={this._onPresentBottom}>
          <Text style={styles.dismissText}>
            Present Bottom Arrow Popover
          </Text>
        </TouchableHighlight>
        {this.state.popoverVisible && this._renderWrapperPopover(this._renderPopoverContent)}
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  popoverContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#666',
  },
  presentButton: {
    marginVertical: 20
  },
  dismissText: {
    color: 'red'
  }
});

AppRegistry.registerComponent('Example', () => Example);

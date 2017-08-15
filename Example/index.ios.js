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
import Popover from 'react-native-ios-popover';

getWebViewHandle = () => {
  return ReactNative.findNodeHandle(this.refs[RCT_WEBVIEW_REF]);
};

export default class Example extends Component {

  constructor(props, context) {
    super(props, context);

    this.state = {
      popoverVisible: false,
      target: 0,
    };
  }

  _onPressButton = (event) => {
    this.setState({
      popoverVisible: true,
      target: event.target
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

  _renderPopover = () => {
    return (
      <Popover sourceViewReactTag={this.state.target} onShow={this._onShow} onHide={this._onHide}>
      </Popover>
    )
  };

  render() {
    return (
      <View style={styles.container}>
        <TouchableHighlight onPress={this._onPressButton}>
          <Text style={{ color: 'red' }}>
            Popover
          </Text>
        </TouchableHighlight>
        {this.state.popoverVisible && this._renderPopover()}
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
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('Example', () => Example);

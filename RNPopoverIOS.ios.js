import React, { Component, Children } from 'react';
import PropTypes from 'prop-types';
import {
  NativeEventEmitter,
  NativeModules,
  StyleSheet,
  View,
  Text,
  requireNativeComponent,
  Platform,
  Animated
} from 'react-native';

const RNPopoverHostView = requireNativeComponent('RNPopoverHostView');

export default class extends Component {
  static displayName = 'Popover';
  static propTypes = {
    /**
     * The `visible` prop determines whether your popover is visible.
     */
    visible: PropTypes.bool,
  };

  static defaultProps = {
    visible: true,
  };

  render() {
    const { visible, child } = this.props;

    if (visible === false) {
      return null;
    }

    return (
      <RNPopoverHostView {...this.props}>
        
      </RNPopoverHostView>
    );
  }
}

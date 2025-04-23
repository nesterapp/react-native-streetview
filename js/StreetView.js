/**
 * StreetView Component
 * 
 * A React Native wrapper for Google Street View
 */

import React from 'react';
import PropTypes from 'prop-types';
import { View, requireNativeComponent } from 'react-native';

const propTypes = {
  ...View.propTypes,

  // Location
  coordinate: PropTypes.shape({
    latitude: PropTypes.number.isRequired,
    longitude: PropTypes.number.isRequired,
    // Search radius (meters) around coordinate.
    radius: PropTypes.number,
  }),
  // Limits Street View searches to outdoor collections only when true
  outdoorOnly: PropTypes.bool,
  streetNamesHidden: PropTypes.bool,
  // Camera
  pov: PropTypes.shape({
    tilt: PropTypes.number.isRequired,
    bearing: PropTypes.number.isRequired,
    zoom: PropTypes.number.isRequired,
  }),
  heading: PropTypes.number,
  // Gesture Controls
  allGesturesEnabled: PropTypes.bool,
  orientationGestures: PropTypes.bool,
  zoomGestures: PropTypes.bool,
  navigationGestures: PropTypes.bool,
  navigationLinksHidden: PropTypes.bool,
  // Events
  onError: PropTypes.func,
  onSuccess: PropTypes.func,
  // Called when panorama changes
  onPanoramaChange: PropTypes.func,
  // Called when POV (camera orientation) changes
  onPovChange: PropTypes.func,
};

class StreetView extends React.Component {

  constructor(props) {
    super(props);
  }

  render() {
    return <NSTStreetView {...this.props} />;
  }
}

StreetView.propTypes = propTypes;

const cfg = {
  nativeOnly: {
    onError: true,
    onSuccess: true,
    onPanoramaChange: true,
    onPovChange: true,
  }
};

module.exports = requireNativeComponent('NSTStreetView', StreetView, cfg);

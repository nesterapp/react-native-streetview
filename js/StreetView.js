//
//  StreetView.js
//  react-native-streetview
//
//  Created by Amit Palomo on 26/04/2017.
//  Copyright © 2017 Nester.co.il.
//

import React from 'react';
import PropTypes from 'prop-types';
import { View, requireNativeComponent } from 'react-native';

const propTypes = {
	...View.propTypes,

	// Center point
	coordinate: PropTypes.shape({
		latitude: PropTypes.number.isRequired,
		longitude: PropTypes.number.isRequired,
	}),

	// Allowing user gestures (panning, zooming)
	allGesturesEnabled: PropTypes.bool,
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

module.exports = requireNativeComponent('NSTStreetView', StreetView);

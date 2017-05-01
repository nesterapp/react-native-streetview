//
//  StreetView.js
//  react-native-streetview
//
//  Created by Amit Palomo on 26/04/2017.
//  Copyright © 2017 Nester.co.il All rights reserved.
//

import React from 'react';
import { View, requireNativeComponent } from 'react-native';

const propTypes = {
	...View.propTypes,

	// Center point
	coordinate: React.PropTypes.shape({
		latitude: React.PropTypes.number.isRequired,
		longitude: React.PropTypes.number.isRequired,
	}),

	// Allowing user gestures (panning, zooming)
	allGesturesEnabled: React.PropTypes.bool,
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

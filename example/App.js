/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
// import {
//   Platform,
//   StyleSheet,
//   Text,
//   View
// } from 'react-native';
import {
  StyleSheet,
  View
} from 'react-native';
import StreetView from 'react-native-streetview'


const location = {
	'latitude': 37.809473,
	'longitude': -122.476140,
	'radius': 50
}

// const instructions = Platform.select({
//   ios: 'Press Cmd+R to reload,\n' +
//     'Cmd+D or shake for dev menu',
//   android: 'Double tap R on your keyboard to reload,\n' +
//     'Shake or press menu button for dev menu',
// });

export default class App extends Component<{}> {
  render() {
		return (
			<View style={styles.container}>
			<StreetView
				style={styles.streetView}
				allGesturesEnabled={true}
				coordinate={location}
			/>
			</View>
		);
	}
}


const styles = StyleSheet.create({
	container: {
		flex: 1
	},
	streetView: {
		position: 'absolute',
		top: 0,
		left: 0,
		right: 0,
		bottom: 0,
	},
});





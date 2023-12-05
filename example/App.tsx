/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React from 'react';
import {
  StyleSheet,
  View,
} from 'react-native';

import StreetView from 'react-native-streetview';

function App(): JSX.Element {

  const location = {
    'latitude': 37.809473,
    'longitude': -122.476140,
    'radius': 50
  }

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

export default App;

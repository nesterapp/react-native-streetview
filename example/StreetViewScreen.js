import React, { useState } from 'react';
import {
  StyleSheet,
  View,
  Text,
  TextInput,
  TouchableOpacity,
  Keyboard,
  ScrollView,
} from 'react-native';

import StreetView from 'react-native-streetview';

const StreetViewScreen = () => {
  // Preset locations
  const presetLocations = [
    { name: "2880 Broadway, NY", latitude: 40.8054022, longitude: -73.9656 },
    { name: "Venice Beach", latitude: 33.9867798, longitude: -118.4735784 },
    { name: "Austin 6th", latitude: 30.267153, longitude: -97.741209 },
  ];

  // This state holds the CURRENT values being displayed in StreetView
  const [location, setLocation] = useState(presetLocations[0]);

  // Split the state: one for inputs, one for active POV
  const [povInputs, setPovInputs] = useState({
    tilt: '0',
    bearing: '0',
    zoom: '0',
  });
  
  // This holds the actual values used by StreetView
  const [activePov, setActivePov] = useState({
    tilt: 0,
    bearing: 0,
    zoom: 0,
  });

  const setPresetLocation = (preset) => {
    setLocation(preset);
  };

  const updateStreetView = () => {
    // Dismiss the keyboard when the button is pressed
    Keyboard.dismiss();
    
    // Update the active POV with values from the inputs
    setActivePov({
      tilt: parseFloat(povInputs.tilt) || 0,
      bearing: parseFloat(povInputs.bearing) || 0,
      zoom: parseFloat(povInputs.zoom) || 0,
    });
  };
  
  // Helper to update input values only while typing
  const updatePovInput = (key, value) => {
    setPovInputs(prev => ({...prev, [key]: value}));
  };

  return (
    <View style={styles.container}>
      <ScrollView style={styles.scrollView}>
        <View style={styles.controlPanel}>
          <Text style={styles.sectionTitle}>Select Location</Text>
          
          {/* Preset location buttons */}
          <View style={styles.locationButtonsContainer}>
            {presetLocations.map((preset, index) => (
              <TouchableOpacity
                key={index}
                style={[
                  styles.locationButton,
                  location.name === preset.name && styles.activeLocationButton
                ]}
                onPress={() => setPresetLocation(preset)}
              >
                <Text 
                  style={[
                    styles.locationButtonText,
                    location.name === preset.name && styles.activeLocationButtonText
                  ]}
                >
                  {preset.name}
                </Text>
              </TouchableOpacity>
            ))}
          </View>
          
          {/* Current coordinates display */}
          <Text style={styles.coordinatesText}>
            Latitude: {location.latitude.toFixed(6)}, Longitude: {location.longitude.toFixed(6)}
          </Text>
          
          <Text style={styles.sectionTitle}>Camera Settings</Text>
          <View style={styles.inputContainer}>
            {/* Camera setting labels row */}
            <View style={styles.labelRow}>
              <Text style={styles.compactLabel}>Tilt</Text>
              <Text style={styles.compactLabel}>Bearing</Text>
              <Text style={styles.compactLabel}>Zoom</Text>
            </View>
            
            {/* Camera setting inputs row */}
            <View style={styles.inputRowCompact}>
              <TextInput
                style={styles.compactInput}
                value={String(povInputs.tilt)}
                onChangeText={text => updatePovInput('tilt', text)}
                keyboardType="numeric"
                placeholder="0-90°"
              />
              <TextInput
                style={styles.compactInput}
                value={String(povInputs.bearing)}
                onChangeText={text => updatePovInput('bearing', text)}
                keyboardType="numeric"
                placeholder="0-360°"
              />
              <TextInput
                style={styles.compactInput}
                value={String(povInputs.zoom)}
                onChangeText={text => updatePovInput('zoom', text)}
                keyboardType="numeric"
                placeholder="0-5"
              />
            </View>
          </View>
          
          <TouchableOpacity 
            style={styles.button}
            onPress={updateStreetView}
          >
            <Text style={styles.buttonText}>Update View</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
      
      <StreetView
        style={styles.streetView}
        allGesturesEnabled={true}
        coordinate={{
          latitude: location.latitude,
          longitude: location.longitude,
          radius: 50
        }}
        pov={activePov}
        outdoorOnly={false}
        streetNamesHidden={false}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  scrollView: {
    maxHeight: 280,
    backgroundColor: '#f8f8f8',
  },
  controlPanel: {
    padding: 16,
    backgroundColor: 'white',
    borderBottomWidth: 1,
    borderBottomColor: '#e0e0e0',
    zIndex: 1,
  },
  locationButtonsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginVertical: 8,
  },
  locationButton: {
    flex: 1,
    padding: 6,
    margin: 4,
    backgroundColor: '#f0f0f0',
    borderRadius: 4,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#ddd',
  },
  activeLocationButton: {
    backgroundColor: '#e6f2ff',
    borderColor: '#2196F3',
  },
  locationButtonText: {
    fontSize: 13,
    color: '#444',
    fontWeight: '500',
  },
  activeLocationButtonText: {
    color: '#2196F3',
    fontWeight: 'bold',
  },
  coordinatesText: {
    textAlign: 'center',
    color: '#666',
    fontSize: 12,
    marginBottom: 15,
    fontStyle: 'italic',
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: '600',
    marginTop: 8,
    marginBottom: 8,
    color: '#333',
  },
  inputContainer: {
    marginBottom: 10,
  },
  labelRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingHorizontal: 8,
    marginBottom: 4,
  },
  inputRowCompact: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 2,
  },
  compactLabel: {
    flex: 1,
    fontSize: 14,
    fontWeight: '500',
    textAlign: 'center',
  },
  compactInput: {
    flex: 1,
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 4,
    padding: 8,
    fontSize: 16,
    marginHorizontal: 4,
    textAlign: 'center',
  },
  button: {
    backgroundColor: '#2196F3',
    padding: 12,
    borderRadius: 4,
    alignItems: 'center',
    marginTop: 1,
  },
  buttonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  streetView: {
    flex: 1,
  },
});

export default StreetViewScreen;
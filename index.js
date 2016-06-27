import {
  NativeModules
} from 'react-native';

let { ScreenshotModule } = NativeModules;

export var capture = ScreenshotModule.capture;

// @flow
import { NativeModules } from 'react-native';

const handDetectionDisabledMessage = 'Hand detection has not been included in this build.';

const HandDetectorModule: Object = NativeModules.RNHandDetector || {
  stubbed: true,
  Mode: {},
  Landmarks: {},
  Classifications: {},
  detectHand: () => new Promise((_, reject) => reject(handDetectionDisabledMessage)),
};

type Point = { x: number, y: number };

export type HandFeature = {
  bounds: {
    size: {
      width: number,
      height: number,
    },
    origin: Point,
  },
  finger: Array<FingerFeature>
};

export type FingerFeature = {
  name: String,
  bounds: {
    size: {
      width: number,
      height: number,
    },
    origin: Point,
  },
  nailPosition:Point
};

type DetectionOptions = {
  mode?: $Keys<typeof HandDetectorModule.Mode>,
  detectLandmarks?: $Keys<typeof HandDetectorModule.Landmarks>,
  runClassifications?: $Keys<typeof HandDetectorModule.Classifications>,
};

export default class HandDetector {
  static Constants = {
    Mode: HandDetectorModule.Mode,
    Landmarks: HandDetectorModule.Landmarks,
    Classifications: HandDetectorModule.Classifications,
  };

  static detectHandsAsync(uri: string, options: ?DetectionOptions): Promise<Array<HandFeature>> {
    return HandDetectorModule.detectHand({ ...options, uri });
  }
}

export const Constants = HandDetector.Constants;

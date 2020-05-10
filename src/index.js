// @flow
import RNCamera, { type Status as _CameraStatus } from './RNCamera';
import FaceDetector from './FaceDetector';
import HandDetector from './HandDetector';

export type CameraStatus = _CameraStatus;
export { RNCamera, FaceDetector, HandDetector };

release(F)
F = imufilter;
F.SampleRate = 200;
F.OrientationFormat = 'Rotation matrix';
F.AccelerometerNoise = max(var(acc(1:200,:)*9.81));
F.GyroscopeNoise     = max(var(omCal(1:200,:)/180*pi));
%F.GyroscopeDriftNoise
F.LinearAccelerationNoise = F.AccelerometerNoise*10000;
F.LinearAccelerationDecayFactor = 0.1;
[orientation, angularVelocity] = F(acc(nStart:nEnd,:)*9.81,omCal(nStart:nEnd,:)/180*pi);

RkvCal{end}
orientation(:,:,end)*inv(orientation(:,:,1))

[eaKF1, eaKF2] = fnEulerAngles(orientation, inv(orientation(:,:,1))*RQlsysDown2{S.deltaN(1) + nStart});
fnPlotCompare3(ea1Q*180/pi, eaKF1(21:end,:)*180/pi, maxLoc)



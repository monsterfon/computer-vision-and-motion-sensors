function [acc, om, t, t0] = fnSyncAccOmMW(ACC_DATA, GYRO_DATA, fs)

[t_acc,ti_acc] = unique(ACC_DATA{:,1});
[t_om, ti_om] = unique(GYRO_DATA{:,1});
deltaTAccOm = t_om(1)-t_acc(1);

if deltaTAccOm > 0
    t0 = t_om(1);
else
    t0 = t_acc(1);
end
    
t_acc = t_acc - t_acc(1);
t_om = t_om - t_om(1);

acc_orig = ACC_DATA{ti_acc,4:6};
acc_interp = interp1(t_acc, acc_orig, (t_acc(1):t_acc(end)));

om_orig = GYRO_DATA{ti_om,4:6};
om_interp = interp1(t_om, om_orig, (t_om(1):t_om(end)));

if deltaTAccOm > 0
    acc_interp = acc_interp(deltaTAccOm+1:end,:);
else
    om_interp = om_interp(abs(deltaTAccOm)+1:end,:);
end

% size(acc_interp)
% length(om_interp)
L = min(length(acc_interp),length(om_interp));
t_interp = 0:L-1;

nf = 1000/fs;
acc = acc_interp(1:nf:L,:);
om = om_interp(1:nf:L,:); 
t = t_interp(1:nf:L)/1000;
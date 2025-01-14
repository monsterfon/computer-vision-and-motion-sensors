function R=fnRotacijskaMatrika(phi,v)

c = cos(phi); s = sin(phi);
minc = 1 - c; 
vxminc = v(1)*minc; vyminc = v(2)*minc; vzminc = v(3)*minc;
vxs = v(1)*s; vys = v(2)*s; vzs = v(3)*s;
vx_vy_minc = vxminc*v(2); vx_vz_minc = vxminc*v(3); vy_vz_minc = vyminc*v(3);
R = [c + v(1)*vxminc, vx_vy_minc - vzs,  vx_vz_minc + vys;
    vx_vy_minc + vzs, c + v(2)*vyminc, vy_vz_minc - vxs;
        vx_vz_minc - vys, vy_vz_minc + vxs, c + v(3)*vzminc];
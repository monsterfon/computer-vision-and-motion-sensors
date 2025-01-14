function q = fnRotacijskiKvaternion(phi,v)

phi_pol = phi/2; 
s       = sin(phi_pol);
q(1)    = cos(phi_pol); 
q(2)    = s*v(1); 
q(3)    = s*v(2); 
q(4)    = s*v(3);
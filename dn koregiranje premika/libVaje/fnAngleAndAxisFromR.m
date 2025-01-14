function [theta, u] = fnAngleAndAxisFromR(rotationMatrix)

ux = rotationMatrix(3, 2) - rotationMatrix(2, 3);
uy = rotationMatrix(1, 3) - rotationMatrix(3, 1);
uz = rotationMatrix(2, 1) - rotationMatrix(1, 2);

theta = acos((trace(rotationMatrix)-1)/2);
u = [ux, uy, uz];
u = u./2./sin(theta);

if abs(imag(theta)) > 1e-17

    theta = asin(sqrt(ux^2+uy^2+uz^2)/2);
    %u = [ux, uy, uz]';
    u = u./2./sin(theta);
    if round(rotationMatrix,2) == round(rotationmat3D(theta,u),2)
          disp("Matrices don't match!")
    else
          theta = pi-theta;      
    end

end

end
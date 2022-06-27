function params = mdsparams(dt,rf,n_pad)

c = 2.9979 * 10^-5;       %speed of light[cm/fs]
                          
dw = 1 / (c*dt*n_pad);                   %defining the frequency step [cm-1]
w = ((-n_pad*dw)/2:dw:((n_pad*dw)/2-1)); %frequency axis     [cm-1]
w(1) = [];                               %cut asymmetric part of axis
params.w1 = w+rf;

w3 = 432.65 + (1:1:1024).*0.56503;       %fit from spectrometer calibration
% w3 = 427.9884   0.5669
params.w3 = (10^7./w3)';                 %convert to wavenumbers
end
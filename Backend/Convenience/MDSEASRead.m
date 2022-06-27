%% Plot 2D EAS

close all;
clear;
clear var;

%% Load output

output = load('C:\Users\schul\Documents\Graduate\Graduate Work\Fall 2017\Wasielewski Group\Data Workup\2020.03.13\20200317scan03_EASfit.mat');
fit = output.fit;

w1 = load('C:\Users\schul\Documents\Graduate\Graduate Work\Fall 2017\Wasielewski Group\Data Workup\2020.03.13\w1_v2.dat');
w3 = load('C:\Users\schul\Documents\Graduate\Graduate Work\Fall 2017\Wasielewski Group\Data Workup\2020.03.13\w3_v2.dat');


%% Unpack fitted spectra

num_w3 = length(w3);
num_w1 = length(w1); 

species1 = zeros(num_w3,num_w1);
species2 = zeros(num_w3,num_w1);

%species1
    count=1;
    for j=1:num_w1
        for i=1:num_w3
            species1(i,j) = fit.SpectraFit(2,count);
            count = count+1;
        end
    end

%species2
    count=1;
    for j=1:num_w1
        for i=1:num_w3
            species2(i,j) = fit.SpectraFit(3,count);
            count = count+1;
        end
    end

%% Normalize EAS

species1_norm = asinh(100.*species1)./(max(max(abs(asinh(100.*species1)))));
species2_norm = asinh(100.*species2)./(max(max(abs(asinh(100.*species2)))));

%% Smooth EAS %%

species1_norm_sm = zeros(size(species1_norm));       %initialize matrix for data smoothed in one dimension
species1_norm_final = zeros(size(species1_norm));     %initialize matrix for data smoothed in both dimensions
               
    for i = 1:length(w3)
        species1_norm_sm(i,:) = smooth(species1_norm(i,:),7);
    end
    for j = 1:length(w1)
        species1_norm_final(:,j) = smooth(species1_norm_sm(:,j),7);
    end
    
species2_norm_sm = zeros(size(species2_norm));       %initialize matrix for data smoothed in one dimension
species2_norm_final = zeros(size(species2_norm));     %initialize matrix for data smoothed in both dimensions
               
    for i = 1:length(w3)
        species2_norm_sm(i,:) = smooth(species2_norm(i,:),7);
    end
    for j = 1:length(w1)
        species2_norm_final(:,j) = smooth(species2_norm_sm(:,j),7);
    end

%% Plot EAS on subplot

cmap_save = load('C:\Users\schul\Documents\MATLAB\Graduate\Wasielewski Group\ColorSchemes\cmap_whitemiddle_2.txt');  %load calibrated Fourier transform pump axis

subplot(1,2,1)
contourf(w1,w3,species1_norm_final,20,'LineWidth',0.25);  
colormap(cmap_save); caxis([-1 1]) %no arcsinh scaling, color scheme keeps zero white if the climits are even on both sides of zero
%line('XData',[500 557],'YData',[500 557],'Linewidth',1.5);
line('XData',[min(w1) max(w1)],'YData',[min(w3) max(w3)],'Linewidth',1.5);
box on
axis image
xlabel('\omega_{1} (cm^{-1})');     ylabel('\omega_{3} (cm^{-1})');     %title('species 1');
%ylim([505 1000]);
set(gca, 'FontSize', 18);

subplot(1,2,2)
contourf(w1,w3,species2_norm_final,20,'LineWidth',0.25);  
colormap(cmap_save); caxis([-1 1]) %no arcsinh scaling, color scheme keeps zero white if the climits are even on both sides of zero
%line('XData',[500 557],'YData',[500 557],'Linewidth',1.5);
line('XData',[min(w1) max(w1)],'YData',[min(w3) max(w3)],'Linewidth',1.5);
box on
axis image
xlabel('\omega_{1} (cm^{-1})');     ylabel('\omega_{3} (cm^{-1})');     %title('species 1');
%ylim([505 1000]);
set(gca, 'FontSize', 18);

%% Plot EAS alone

cmap_save = load('C:\Users\schul\Documents\MATLAB\Graduate\Wasielewski Group\cmap_save.txt');  %load calibrated Fourier transform pump axis

clevel = [-5:0.05:5];                %initialize contour range

figure(4)
contourf(w1_rel,w3_rel,species1,clevel,'LineWidth',0.25);  
colormap(cmap_save); caxis([-0.5 0.5]) %no arcsinh scaling, color scheme keeps zero white if the climits are even on both sides of zero
%line('XData',[(1/400)*10^7 (1/1000)*10^7],'YData',[(1/400)*10^7 (1/1000)*10^7],'Linewidth',1.5);
box on
hcb = colorbar('location','EastOutside');
axis image
xlabel('\omega_{1} (cm^{-1})');     ylabel('\omega_{3} (cm^{-1})  x10^{4}');     %title(t2(timeselect));
% xlim([minbound_w1 maxbound_w1]);
% ylim([minbound_w3 maxbound_w3]);
hcb = colorbar('location','EastOutside');
set(gca, 'FontSize', 10);
width=240;
height=340;
set(gcf,'units','points','position',[0,0,width,height])
    
%% Plot populations

figure(10)
plot(fit.time,fit.Population(:,1))
hold on
plot(fit.time,fit.Population(:,2))
xlabel('Time (ps)')
ylabel('Population')

%% Plot_Batchelor_etal_2023_Fig5.m
% This code reads in the corrugation ridge observations (slope and inferred retreat rate) mapped by Batchelor et 
% al. (Nature, 2023) and plots Figure 5 of the manuscript. 
%
% Code written by Frazer Christie, Scott Polar Research Institute, University of Cambridge, February 2023
%
%% Dependancies
% The code is dependent on the following functions and dataset, which either accompany this code or are available at 
% the links/references detailed below:
%
% Batchelor_etal_2023_Fig5_data.csv (seafloor slope and inferred grounding-line retreat rate observations derived from the associated dataset 'Batchelor_etal_2023_corrugation_ridge_data.xslx'. (Link to xslx: https://doi.org/10.17863/CAM.93638)).   
% cmocean colourmaps (https://uk.mathworks.com/matlabcentral/fileexchange/57773-cmocean-perceptually-uniform-colormaps)
%
%% Code input
% Below, <> symbols denote user input prompt.
%
%% Citation
% If using this code, please cite the following:
%
% Batchelor, C.L., Christie, F.D.W., Ottesen, D., Montelli, A., Evans, J., Dowdeswell, E.K., Bjarnadóttir, L.R., and Dowdeswell, J.A. Rapid, buoyancy-driven ice-sheet 
%       retreat of hundreds of metres per day, Nature, 2023. doi:10.1038/s41586-023-05876-1.
%
% Users may also be interested in:
%
% Batchelor, C.L., and Christie, F.D.W. How fast can ice sheets retreat?, Nature, 2023. 
%
% Batchelor, C.L., Christie, F.D.W, Ottesen, D., Montelli, A., Evans, J., Dowdeswell, E.K., Bjarnadóttir, L.R., and Dowdeswell, J.A. Mid-Norwegian margin corrugation
%       ridge observations supporting 'Rapid, buoyancy-driven ice-sheet retreat of hundreds of metres per day', Cambridge Apollo Dataset Repository, 2023, doi:10.17863/CAM.93638. 
%
%% Code 
clear all; close all; 
addpath(genpath('C:\Users\fc475\Dropbox (Cambridge University)\WSE_database_v1.1\8_WSE_papers\CLB_Norway_CorrigationRidges\REVISION_1\SupportingCode')); % path to input files

%% define input variables 
pw = 1027.5; % assumed water density as detailed in Methods. 
pi = 917; % density of ice.
a = 0.0; % assumed surface slope between sucessive corrugation ridges (i.e. flat).
tide = 0; % tidal range at given location (optional but not used in production of Figure 5).

%% Load slope and retreat rates, then calculate and plot equivalent thinning rate, h_t, as shown in Figure 5 
retreat_rate_all = csvread('Batchelor_etal_2023_Fig5_data.csv',1,0); retreat_rate_all = retreat_rate_all(:,1); % load retreat rates.
slopes_all = csvread('Batchelor_etal_2023_Fig5_data.csv',1,0); slopes_all = abs(slopes_all(:,2)); % load gradients and calculate absolute values as discussed in Methods.

for i = 1:length(retreat_rate_all)
    h_t(i) = a-(slopes_all(i)*(1-(pw/pi)))*retreat_rate_all(i); % hydrostatic equation adapted from Thomas & Bentley (1978). Note: tide change parameterisation dropped given that inferred retreat rates implicitly represent a continuum of tidal states (see Methods for further discussion). 
end

%%% Optional line if tide change required.
% for i = 1:length(retreat_rate_all)
%     h_t(i) = ((pw/pi)*tide)-(a-(slopes_all(i)*(1-(pw/pi))))*retreat_rate_all(i); 
% end

% Plot Figure 5 
f = figure;
f.Units = 'centimeters';
f.Position(3:4) = [ 12 7];
scatter3(retreat_rate_all,h_t,slopes_all,15,slopes_all,'filled','MarkerEdgeColor',[0.35 0.35 0.35],'LineWidth',0.5); xlabel('Retreat rate (m d^{-1})','fontweight','bold'); ylabel('Melt rate (m d^{-1})','fontweight','bold')
view(0,90)
c = colorbar;
c.Label.String = 'Seafloor Gradient ({\circ})';
c.Label.FontWeight = 'bold';
c.Label.FontSize = 12;
cmocean('-ice',10); caxis([0 1])
grid off
yticks([0 2 4 6 8 10 12 14 16 18])
yticklabels({'0','2','4','6','8','10','12','14','16','18'})
ylim([0 18])
mean_h_t = mean(h_t(:),'omitnan') % Mean equivalent thinning rate as shown in Extended Data Table 2.

%% For reference, calculate h_t across an idealised bed with a slope of 0.01 degrees and a retreat rate ranging between 55 and 610m
x_001 = 55:0.01:610; % Min-max retreat rates.
b_001= 0.01; % prescribed bed slope.

for i = 1:length(x_001)
    h_t_001(i) = a-(b_001*(1-(pw/pi)))*x_001(i); 
end

% fit linear trends for reference
p_001 = polyfit(x_001, h_t_001, 1);
px_001 = [0 max(x_001)];
py_001 = polyval(p_001, px_001);
hold on
plot(px_001, py_001, 'LineWidth', 1,'color',[0.5 0.5 0.5],'linestyle','-');

%% For reference, calculate h_t across a range of idealised beds with slopes ranging between of 0.1:0.1:1 degrees and retreat rates ranging between 55 and 610m
for f = 0.1:0.1:1
    x = 55:0.01:610; 
    b= f; 
    for i = 1:length(x)
        h_t(i) = a-(b*(1-(pw/pi)))*x(i); 
    end

    %fit linear trends for reference
    p = polyfit(x, h_t, 1);
    px = [0 max(x)];
    py = polyval(p, px);
    hold on
    plot(px, py, 'LineWidth', 1,'color',[0.8 0.8 0.8],'linestyle','-');

end

%% Redraw h_t across beds == 0.5 and 1 degrees to show different color reference lines 
   %0.5
   for i = 1:length(x)
        h_t(i) = a-(0.5*(1-(pw/pi)))*x(i);
   end
   %fit linear trends for reference
    p = polyfit(x, h_t, 1);
    px = [0 max(x)];
    py = polyval(p, px);
    hold on
    plot(px, py, 'LineWidth', 1,'color',[0.5 0.5 0.5],'linestyle','-');

    %1
    for i = 1:length(x)
        h_t(i) = a-(1*(1-(pw/pi)))*x(i); 
    end
    %fit linear trends for reference
    p = polyfit(x, h_t, 1);
    px = [0 max(x)];
    py = polyval(p, px);
    hold on
    plot(px, py, 'LineWidth', 1,'color',[0.5 0.5 0.5],'linestyle','-');

%% Plot thinning rate and recent grounding-line retreat at Pope Glacier, West Antarctica, using the information presented in Millilo et al. (2022, Nature Geoscience)
pope_retreat_md_max_x = 4300/113; % observed retreat rate in m/day, derived from 3.5 +/- 0.8 as stated in text (p.50).
pope_h_t_md_max_y = (95/365.25); % observed thinning rate in m/day, derived from 86 +/- 9 as stated in text (p.51).

plot3(pope_retreat_md_max_x,pope_h_t_md_max_y,pope_h_t_md_max_y,'r+','markerfacecolor','r')

%% Plot thinning rate observed at Pine Island Glacier as documented in Shean et al. (2019, The Cryosphere) (250 m/year) 
yline(0.7,'r')

%% %% Plot thinning rate and recent grounding-line retreat at Thwaites Glacier, West Antarctica, using the information presented in Millilo et al. (2019, Science Advances)
Millilo19_retreat_rate_kmyr = 1.2; % max rate as stated in text
Millilo19_retreat_rate_md = (Millilo19_retreat_rate_kmyr*1000)./365.25; % m/year > m/day.
plot3(Millilo19_retreat_rate_md,(207/365.25),(207/365.25),'r+'); % 207 m/yr of thinning as stated in text. 

%% Plot max. observed Greenland melt rate from Xu et al. (2013; GRL)
yline(4,'r') % 4 m/day.

%% Plot max. observed Alaska melt rate from Schulz et al. (2022; GRL) & Sutherland et al. (2019; Science) 
yline(14.8,'r') % 14.8 m/day.

%% Calculate Larsen Inlet h_t using data presented in Dowdeswell et al. (2020; Science)
larsen_bed = 0.3; % Max. bed slope gradient shown in manuscript. 
larsen_slope = 0; % assumed surface slope between sucessive corrugation ridges (i.e. flat).
larsen_retreatrate = 50; % max retreat discussed in paper given two tidal cycles per day and a corrugation ridge spacing of 20-25 m. 

larsen_h = (larsen_slope-(larsen_bed*(1-(pw/pi))))*larsen_retreatrate; 
plot3(larsen_retreatrate,larsen_h,larsen_h,'g+') 


%% Calculate Thwaites Glacier h_t using information presented in Graham et al. (2022; Nature Geoscience) 
thw_bed = 0.25; % Max. bed slope gradient inferred from their Figure 4.
thw_slope = 0; % assumed surface slope between sucessive corrugation ridges (i.e. flat).
thw_retreatrate = 8; % Note: 6-8m corrugation ridge spacing gives 6-8 m retreat per day given diurnal tidal cycle of Amundsen Sector.
thw_h = thw_slope-(thw_bed*(1-(pw/pi)))*thw_retreatrate; % Note: unlike those shown in Graham et al. (2022), values generated using this line represent equivalent thinning rates at full hydrostatic equilibrium. Grounded thinning would be insufficient to invoke retreat of 6-8 m/day given (approximately) known ice thickness ~150 years ago, and the amplitude of the corrugation ridges further suggest that this is extremely unlikely.   
plot3(thw_retreatrate,thw_h,thw_h,'g+')

%% Calculate Pine Island Glacier ridge h_t using information presented in Graham et al. (2013; JGR) 
gra13_bed = 0.1; % Max. bed slope gradient inferred from their Figure 3a.
gra13_slope = 0; % assumed surface slope between sucessive corrugation ridges (i.e. flat).
gra13_retreatrate = 80; % Note: 80 m corrugation ridge spacing gives 80 m retreat per day given diurnal tidal cycle of Amundsen Sector
gra13_h = gra13_slope-(gra13_bed*(1-(1027.5/pi)))*gra13_retreatrate; 
plot3(gra13_retreatrate,gra13_h,gra13_h,'g+')


%% Plot Jamieson et al.'s 2015 (Nature Geoscience) upper retreat bound estimate of 270 m/day
xline(270,'k--','linewidth',1.5)

%% Finally, calculate and plot idealised h_t for the best fit slopes shown in Figure 2b. 
% First, recreate Figure 2b data
corrugation_spacing = 0:0.5:305; % min/max corrugation ridge spacing limtis from Figure 2b. Here I simulate spacing in 0.5 increments. 
slope_pos = -0.128*log(corrugation_spacing)+0.7483; % calculate expected prograde slope for a given corrugation ridge spacing using the log fit shown in Figure 2b.
slope_neg = 0.1074*log(corrugation_spacing)-0.6406; % calculate expected retrograde slope for a given corrugation ridge spacing using the log fit shown in Figure 2b.

%%% Optional sanity check to recreate Figure 2b
% figure; plot(corrugation_spacing,slope_pos,'k.');
% hold on 
% plot(corrugation_spacing,slope_neg,'k.');
% yline(0,'k')
% xlabel('corrugation spacing (m)','fontweight','bold');
% ylabel('Seafloor gradient ({\circ})','fontweight','bold');

% Next, convert these values to expected h_t, assuming incrementally increasing bed slopes. alpha fixed at 0 degrees.
retreat_rate = corrugation_spacing.*2; % first, convert corrugation ridge spacing to retreat rates (m/day).
 
for i = 1:length(retreat_rate)
    h_t_pos(i) = a-(slope_pos(i)*(1-(pw/pi)))*retreat_rate(i);
end

for i = 1:length(retreat_rate)
    h_t_neg(i) = a-(abs(slope_neg(i))*(1-(pw/pi)))*retreat_rate(i); % for consistency with notation on Figure 5, convert retrograde slopes to absolute
end

mean_h_allslopes = vertcat(h_t_pos,h_t_neg); % concatenate both variables vertically.
mean_h_allslopes = mean(mean_h_allslopes,1); % calculate simple mean of the above for illustration purposes.

plot3(retreat_rate,mean_h_allslopes,mean_h_allslopes,'k+','markersize',1.5); xlabel('Retreat rate (m d^{-1})','fontweight','bold'); ylabel('Melt rate (m d^{-1})','fontweight','bold'); % plot on figure.


%% Set final figure parameters, and clear now uneeded variables
ylim([0 18])
yticks([0 2 4 6 8 10 12 14 16 18 20])
xlim([0 610])

clear a b b_001 c f gra13_bed gra13_slope h_t_001 i larsen_bed larsen_slope p p_001 px px_001 py py_001 slope_neg slope_pos  thw_bed thw_slope tide x x_001


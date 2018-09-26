function gui(choice)

global fig_h


fig_h = figure;
ax=gca;
set(gcf,'toolbar','figure');
set(gcf, 'Position', get(0,'MonitorPositions'));
ax.Position(1) = 0.2; 
hold on;


%% If linear
if choice == 1 % linear

% Text box to enter "InitialThreshold"
uicontrol('Style', 'edit','Tag','Edit1' ,'Position', [20 700 150 20], 'Callback', @Enter_InitialThreshold);
uicontrol('Style', 'text','String','Enter the value of the initial threshold' ,'Position', [20 650 150 40], 'FontSize',12);


% Text box to enter "DotSize"
uicontrol('Style', 'edit','Tag','Edit1' ,'Position', [20 550 150 20], 'Callback', @Enter_DotSize);
uicontrol('Style', 'text','String','Enter the value of the end threshold' ,'Position', [20 500 150 40], 'FontSize',12);


% Text box to enter "Num_Reinforce"
uicontrol('Style', 'edit','Tag','Edit1' ,'Position', [20 400 150 20], 'Callback', @Enter_Num_Reinforce);
uicontrol('Style', 'text','String','Enter the number of reinforcements' ,'Position', [20 330 150 60], 'FontSize',12);

% Button to plot dots
uicontrol('Style','pushbutton', 'String','Display reinforcements',...
        'Position', [20 230 150 50], 'Callback', @(hObject,callbackdata)Display_Dots, 'FontSize',10);
    
% Button to plot function
uicontrol('Style','pushbutton', 'String','Plot function',...
        'Position', [20 150 150 50], 'Callback', @(hObject,callbackdata)Plot_Linear, 'FontSize',10);
    
% Button to confirm function
uicontrol('Style','pushbutton', 'String','Confirm',...
        'Position', [20 80 150 50], 'Callback', @(hObject,callbackdata)Confirm, 'FontSize',10);
    
else
    
% Text box to enter "a"
uicontrol('Style', 'edit','Tag','Edit1' ,'Position', [20 700 150 20], 'Callback', @EnterA);
uicontrol('Style', 'text','String','Enter the value of  A' ,'Position', [20 670 150 20], 'FontSize',12);


% Text box to enter "b"
uicontrol('Style', 'edit','Tag','Edit1' ,'Position', [20 600 150 20], 'Callback', @EnterB);
uicontrol('Style', 'text','String','Enter the value of  B' ,'Position', [20 570 150 20], 'FontSize',12);

% Text box to enter "w"
uicontrol('Style', 'edit','Tag','Edit1' ,'Position', [20 500 150 20], 'Callback', @EnterW);
uicontrol('Style', 'text','String','Enter the value of  W' ,'Position', [20 470 150 20], 'FontSize',12);

% Text box to enter "Num_Reinforce"
uicontrol('Style', 'edit','Tag','Edit1' ,'Position', [20 400 150 20], 'Callback', @Enter_Num_Reinforce);
uicontrol('Style', 'text','String','Enter the number of reinforcements' ,'Position', [20 330 150 60], 'FontSize',12);

% Button to plot dots
uicontrol('Style','pushbutton', 'String','Display reinforcements',...
        'Position', [20 220 150 50], 'Callback', @(hObject,callbackdata)Display_Dots, 'FontSize',10);

% Button to plot function
uicontrol('Style','pushbutton', 'String','Plot function',...
        'Position', [20 150 150 50], 'Callback', @(hObject,callbackdata)Plot_Nonlinear, 'FontSize',10);
    
% Button to confirm function
uicontrol('Style','pushbutton', 'String','Confirm',...
        'Position', [20 80 150 50], 'Callback', @(hObject,callbackdata)Confirm, 'FontSize',10);
    
end
    
    
function EnterA(hObject,~,~)

global a
a = str2double(get(hObject,'String'));
    
return

    
function EnterB(hObject,~,~)

global b
b = str2double(get(hObject,'String'));
    
return

    
function EnterW(hObject,~,~)

global w
w = str2double(get(hObject,'String'));
    
return

function Enter_InitialThreshold(hObject,~,~)

global InitialThreshold
InitialThreshold = str2double(get(hObject,'String'));
    
return

function Enter_DotSize(hObject,~,~)

global DotSize
DotSize = str2double(get(hObject,'String'));
    
return

function Enter_Num_Reinforce(hObject,~,~)

global Num_Reinforce
Num_Reinforce = str2double(get(hObject,'String'));
    
return

function Display_Dots()
global a b w Num_Reinforce InitialThreshold DotSize Slope choice fig_h

cla 
if choice == 1
    
    Slope = linspace(InitialThreshold, DotSize, Num_Reinforce);
    
    alpha = linspace(0,2*pi,360);
    for i = 1:size(Slope,2)
        
        R = Slope(i);      
        x=R*cos(alpha);        
        y=R*sin(alpha);
        plot(x,y)

        axis tight
        set(gca,'Units','Pixels');
        fig_h.Units = 'pixels';
        axis off
        reso = get(0,'MonitorPositions');
        
        ylim([-0.5*1080 0.5*1080])
        xlim([-0.5*1920 0.5*1920])
        hold on
    end
    
elseif choice == 2
    
    for x = 0:Num_Reinforce
        y(x+1)=a*(1-exp(b*x))+w;
        Slope(1,x+1) = y(x+1);
    end
        
        alpha = linspace(0,2*pi,360);        
        for i = 1:size(Slope,2)
        
        R = Slope(i);
        x=R*cos(alpha);      
        y=R*sin(alpha);
        plot(x,y)

        axis tight
        set(gca,'Units','Pixels');
        fig_h.Units = 'pixels';
        axis off
        reso = get(0,'MonitorPositions');
        
        ylim([-0.5*1080 0.5*1080])
        xlim([-0.5*1920 0.5*1920])
        hold on
    end

end
    


return

function Plot_Nonlinear()
global a b w Num_Reinforce Slope
cla reset

%     syms x
%     y = piecewise(0<x<20, a*(1-exp(b*x))+w, 20<=x<=50, a*(1-exp(b*20))+w);
% 
% fplot(y)


for x = 0:Num_Reinforce
y(x+1)=a*(1-exp(b*x))+w;
Slope(1,x+1) = y(x+1);
end

plot(0:Num_Reinforce,y,'b')
hold on
plot(0:Num_Reinforce,y,'r*')
hold on

for x = Num_Reinforce:50
    y(x) = a*(1-exp(b*Num_Reinforce))+w;
end
plot(Num_Reinforce:50,y(Num_Reinforce:50),'b')


    
ylim([0 w*1.5])
xlim([0 50])
xlabel('Number of clicks');
ylabel('Reinforcement size');

return


function Plot_Linear()
global InitialThreshold DotSize Num_Reinforce Slope fig_h
cla reset


k = (InitialThreshold - DotSize)/(0 - Num_Reinforce);
Slope = linspace(InitialThreshold, DotSize, Num_Reinforce);


if ((~isempty(InitialThreshold))&& (~isempty(DotSize))&& (~isempty(Num_Reinforce))&&(~isempty(Slope)))&&(InitialThreshold > DotSize)&&((InitialThreshold > 0)&&(DotSize > 0)&&(Num_Reinforce > 0))

for x = 0:Num_Reinforce
y(x+1)=k*x + InitialThreshold ;
end

plot(0:Num_Reinforce,y,'b')
hold on
plot(0:Num_Reinforce,y,'r*')

for x = Num_Reinforce:50
    y(x) = DotSize;
end
plot(Num_Reinforce:50,y(Num_Reinforce:50),'b')


ylim([0 InitialThreshold*1.5])
xlim([0 50])
xlabel('Number of clicks');
ylabel('Reinforcement size');

else
    close(fig_h)
    error('Invalid input. Please restart the program.')
end


return

function Confirm()
global InitialThreshold DotSize  a b w Num_Reinforce fig_h QuitProgram

if ((~isempty(InitialThreshold ))&&(~isempty(DotSize))&&(~isempty(Num_Reinforce)))||((~isempty(a))&&(~isempty(b))&&(~isempty(w)))
    
close(fig_h)
QuitProgram = 0;
uiresume;

else
close(fig_h)
QuitProgram = 1;

end

    




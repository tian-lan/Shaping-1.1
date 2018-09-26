clear all
close all
clc

KbName('UnifyKeyNames'); 

commandwindow;

% Screen setup
[w,winRect]=Screen('OpenWindow',0,[0 0 0]);


ShowCursor();

Screen('Preference', 'VisualDebugLevel', 1);
Screen('TextSize', w, 20);
Screen('TextFont',w,'Times');
Screen('TextStyle',w,1); 


%% Initialization
black = [0 0 0];
white = [255 255 255];
grey = [128 128 128];
red = [255 0 0];
green = [0 255 0];

%%%%%%%%%%Initial Parameters%%%%%%%%%%%%%%%%%%
DotSize = 50;
InitialThreshold = 400;
EndThreshold = 200;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Yes = [];
No = [];
DotLoc = [];
Dist = {};
Click = {}; 
StartTime = {};
ResponseTime = {};


%% Instructions

% Show message
message1=[ '\n'... 
           'If you hear this sound, \n '...
           '\n'... 
           '\n'...
           'your click is within the threshold.\n'...
           '\n'... 
           '\n'...
           'Click to hear demo.\n'];
DrawFormattedText(w, message1, 'center', 'center', white) ;
Screen('Flip', w) ;  

% Get mouse click info 
[~,~,~,whichButton] = GetClicks(w,0.1);

MousePress = any(whichButton); %sets to 1 if a button was pressed

if MousePress %if key was pressed do the following
   [voice,Fs] = audioread('Correct.wav');
   sound(voice,Fs);
end

WaitSecs(0.5);


% Show message
message2=[ '\n'... 
           'If you hear this sound, \n '...
           '\n'... 
           '\n'...
           'your click is outside the threshold.\n'...
           '\n'... 
           '\n'...
           'Click to hear demo.\n'];
DrawFormattedText(w, message2, 'center', 'center', white) ;
Screen('Flip', w) ;  

% Get mouse click info 
[~,~,~,whichButton] = GetClicks(w,0.1);

MousePress = any(whichButton); %sets to 1 if a button was pressed

if MousePress %if key was pressed do the following
   [voice,Fs] = audioread('Wrong.wav');
   sound(voice,Fs);
end

WaitSecs(1);


Threshold = [];
Target_Rect = [];

%% Trial loop
for i = 1:2   % Number of trials
    


Slope = linspace(InitialThreshold, EndThreshold, 11);

Count = 0;  % Initial correct click
 
% Random dot location within range
DotLoc(i,1) = (winRect(3) - InitialThreshold - InitialThreshold).*rand([1 1]) + InitialThreshold;       % X coordinate
DotLoc(i,2) = (winRect(4) - InitialThreshold - InitialThreshold).*rand([1 1]) + InitialThreshold;       % Y coordinate



% Display dot on screen

% % In case dot is too large - go over border
% if    (DotLoc(i,1) < DotSize)||(winRect(3) - DotLoc(i,1) < DotSize)||(DotLoc(i,2) < DotSize)||(winRect(4) - DotLoc(i,2) < DotSize)
%       DotSize = min([DotLoc(i,1),winRect(3) - DotLoc(i,1),DotLoc(i,2),winRect(4) - DotLoc(i,2)]) - 1;
%     
%       Screen('DrawDots', w, [DotLoc(i,1);DotLoc(i,2)], DotSize, [255 255 255], [0 0], 1);
%       Screen('Flip', w);
%     
% else  Screen('DrawDots', w, [DotLoc(i,1);DotLoc(i,2)], DotSize, [255 255 255], [0 0], 1);
%       Screen('Flip', w);
%       WaitSecs(1); 
% end


% Display circle
Screen('DrawDots', w, [DotLoc(i,1);DotLoc(i,2)], DotSize, black, [0 0], 1);
Screen('Flip', w);
WaitSecs(0.5);

% Show message
message3=['Please identify the location of the first target.\n'];
DrawFormattedText(w, message3, 'center', 'center', white) ;
Screen('Flip', w) ;  
WaitSecs(0.8); 

% Black screen
Screen('FillRect', w,[0 0 0],[winRect]); 
Screen('Flip', w) ;  

for j = 1:10000    % Number of clicks until reaching threshold 15 times overall
    


StartTime{i,1}(j,1) = GetSecs;
    
% Get mouse click info 
[clicks,x(j),y(j),whichButton] = GetClicks(w,0.1);

MousePress = any(whichButton); %sets to 1 if a button was pressed

if MousePress %if key was pressed do the following
     ResponseTime{i,1}(j,1) = GetSecs-StartTime{i,1}(j,1);
end

% Decrease threshold
if j <= 10
   Threshold(i,j) = Slope(1,j);
else
    Threshold(i,j) = EndThreshold;
end

% Distance from first click point to center 1
Dist{i,1}(j,1) = sqrt((x(j) - DotLoc(i,1))^2 + (y(j) - DotLoc(i,2))^2);

Click{i,1}(j,1) = x(j);
Click{i,1}(j,2) = y(j);


if Dist{i,1}(j,1) <= Threshold(i,j) 
%    DrawFormattedText(w, 'Close', 'center', 'center', [255 255 255] ) ;  % Show feedback
   [voice,Fs] = audioread('Correct.wav');
   sound(voice,Fs);
   Yes{i,1}(j,1) = 1;
   
   Click_Count = [ '' num2str(j) ''];
   DrawFormattedText(w, Click_Count, 0.9*winRect(3), 0.1*winRect(4), white);

   
   Screen('Flip', w) ;  
%    WaitSecs(0.1);

   Count = Count +1;
   
   
   
    
   
else

   [voice,Fs] = audioread('Wrong.wav');
   sound(voice,Fs);
   No{i,1}(j,1) = 1;
   
   Click_Count = [ '' num2str(j) ''];
   DrawFormattedText(w, Click_Count, 0.9*winRect(3), 0.1*winRect(4), white);

   
   Screen('Flip', w) ;  
%    WaitSecs(0.1); 
    
   
end
         
    
   if Count >= 15   
      WaitSecs(0.5);
      
      
%%%%%%Display reinforcement%%%%%%%%%%%%
for t = 1:10
Target_Rect(1,t) = DotLoc(i,1) - Threshold(i,t);  % Left
Target_Rect(2,t) = DotLoc(i,2) - Threshold(i,t);  % Top
Target_Rect(3,t) = DotLoc(i,1) + Threshold(i,t);  % Right
Target_Rect(4,t) = DotLoc(i,2) + Threshold(i,t);  % Bottom
Screen('FrameOval', w, grey, Target_Rect(1:4,t), 2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%Display target%%%%%%%%%%%%

Dot_Rect(1,1) = DotLoc(i,1) - DotSize;  % Left
Dot_Rect(2,1) = DotLoc(i,2) - DotSize;  % Top
Dot_Rect(3,1) = DotLoc(i,1) + DotSize;  % Right
Dot_Rect(4,1) = DotLoc(i,2) + DotSize;  % Bottom
Screen('FillOval', w, grey, Dot_Rect);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Displays clicks and connect clicks

for ii = 1:size(Click{i,1},1)
    Screen('DrawDots', w, [Click{i,1}(ii,1);Click{i,1}(ii,2)], 8, white, [0 0], 1);
end  % ii

    Screen('DrawDots', w, [Click{i,1}(1,1);Click{i,1}(1,2)], 8, green, [0 0], 1);   % First Click Green
    Screen('DrawDots', w, [Click{i,1}(size(Click{i,1},1),1);Click{i,1}(size(Click{i,1},1),2)], 8, red, [0 0], 1);   % Last Click Red


for iii = 1:size(Click{i,1},1) - 1
    Screen('DrawLines', w, [Click{i,1}(iii,1) Click{i,1}(iii+1,1);Click{i,1}(iii,2) Click{i,1}(iii+1,2)], 2, white, [0 0]);
end  % iii


DrawFormattedText(w, Click_Count, 0.9*winRect(3), 0.1*winRect(4), white);

Screen('Flip', w);
   



       KbWait;
       
       break
       

   else
       continue
       
   end   % Count >=
  
   

    




end    % j

end    % i


DrawFormattedText(w, 'Complete', 'center', 'center', [255 255 255] ) ;
Screen('Flip', w) ; 
WaitSecs(1);
% KbWait; 

% ListenChar(0); %makes it so characters typed do show up in the command window
Screen('CloseAll'); %closes the window

% Save Results
Results.ClickLocation = Click;
Results.ClickDistance = Dist;
Results.StimuliLocation = DotLoc;
Results.ResponseTime = ResponseTime;


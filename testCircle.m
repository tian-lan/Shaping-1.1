close all
 
% Screen setup
[w,winRect]=Screen('OpenWindow',0,[0 0 0]);

% ListenChar(2);  %makes it so characters typed don't show up in the command window

ShowCursor();

Screen('Preference', 'VisualDebugLevel', 1);
Screen('TextSize', w, 20);
Screen('TextFont',w,'Times');
Screen('TextStyle',w,1); 


%% Initialization
black = [0 0 0];
white = [255 255 255];
DotSize = 50;
InitialThreshold = 250;
Yes = [];
No = [];
DotLoc = [];
Dist = {};
Click = {}; 
StartTime = {};
ResponseTime = {};



%% Trial loop
for i = 1:2   % Number of trials
    
InitialThreshold = 400;
EndThreshold = 200;
Threshold = [];
Slope = linspace(InitialThreshold, EndThreshold, 11);

Count = 0;  % Initial correct click
 
% Random dot location
DotLoc(i,1) = (winRect(3) - DotSize).*rand([1 1]);       % X coordinate
DotLoc(i,2) = (winRect(4) - DotSize).*rand([1 1]);       % Y coordinate



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
WaitSecs(1);

% Show message
message1=['Please identify the location of the first target. \n '];
DrawFormattedText(w, message1, 'center', 'center', white) ;
Screen('Flip', w) ;  
WaitSecs(0.8); 

  

for j = 1:10000    % Number of clicks until reaching threshold 5 times overall
    
% Black screen
Screen('FillRect', w,[0 0 0],[winRect]); 
StartTime{i,1}(j,1) = Screen('Flip', w) ;   % Get start time for each trial
    
% Get mouse click info 
[clicks,x(j),y(j),whichButton] = GetClicks(w,0.1);

MousePress = any(whichButton); %sets to 1 if a button was pressed

if MousePress %if key was pressed do the following
     ResponseTime{i,1}(j,1) = GetSecs-StartTime{i,1}(j,1);
end

% Decrease threshold
if j <= 10
   Threshold = Slope(1,j);
else
    Threshold = EndThreshold;
end

% Distance from first click point to center 1
Dist{i,1}(j,1) = sqrt((x(j) - DotLoc(i,1))^2 + (y(j) - DotLoc(i,2))^2);

Click{i,1}(j,1) = x(j);
Click{i,1}(j,2) = y(j);


if Dist{i,1}(j,1) <= Threshold 
%    DrawFormattedText(w, 'Close', 'center', 'center', [255 255 255] ) ;  % Show feedback
   [voice,Fs] = audioread('Correct.wav');
   sound(voice,Fs);
   Yes{i,1}(j,1) = 1;
   
   Screen('Flip', w) ;  
%    WaitSecs(1); 
   Count = Count +1;
   
else
%    DrawFormattedText(w, 'Too far', 'center', 'center', [255 255 255] ) ;
   [voice,Fs] = audioread('Wrong.wav');
   sound(voice,Fs);
   No{i,1}(j,1) = 1;
   
   Screen('Flip', w) ;  
%    WaitSecs(1); 
   
end

   if Count >= 15   
      WaitSecs(0.5);

       break
       

       
   else
       continue
       
   end
   

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


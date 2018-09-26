clear all
close all
clc

global InitialThreshold DotSize Num_Reinforce Slope choice QuitProgram i

%% Initialization
black = [0 0 0];
white = [255 255 255];
grey = [128 128 128];
red = [255 0 0];
green = [0 255 0];
blue = [0 0 255];

%%%%%%%%%%Initial Parameters%%%%%%%%%%%%%%%%%%

question1 = 'What reinforcement function would you like to choose?  ';
disp('1: Linear   2: Convex   3: Concave')
choice = input(question1);

question2 = 'Please enter the number of trials:  ';
num_trial = input(question2);

if num_trial <= 2
   error('Invalid choice. Please restart the program.')
else   
end


if choice == 1
    
   gui2(1)
   uiwait;
   
elseif choice == 2
    gui2(2)
    uiwait;
    
elseif choice == 3
    gui2(3)
    uiwait;


else
    error('Invalid choice. Please restart the program.')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if QuitProgram == 0

Yes = [];
No = [];
DotLoc = [];
Dist = {};
Click = {}; 
StartTime = {};
ResponseTime = {};


%%


KbName('UnifyKeyNames'); 

commandwindow;

% Screen setup
[w,winRect]=Screen('OpenWindow',0,[0 0 0]);


ShowCursor();

Screen('Preference', 'VisualDebugLevel', 1);
Screen('TextSize', w, 20);
Screen('TextFont',w,'Times');
Screen('TextStyle',w,1); 



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
for i = 1:num_trial   % Number of trials
    

Count = 0;  % Initial correct click
 
% Random dot location within range
DotLoc(i,1) = (winRect(3) - InitialThreshold - InitialThreshold).*rand([1 1]) + InitialThreshold;       % X coordinate
DotLoc(i,2) = (winRect(4) - InitialThreshold - InitialThreshold).*rand([1 1]) + InitialThreshold;       % Y coordinate



% Display circle
Screen('DrawDots', w, [DotLoc(i,1);DotLoc(i,2)], DotSize, black, [0 0], 1);
Screen('Flip', w);
WaitSecs(0.5);

% Show message
message3=['Please identify the location of the target.\n'];
DrawFormattedText(w, message3, 'center', 'center', white) ;
Screen('Flip', w) ;  
WaitSecs(0.8); 

% Black screen
Screen('FillRect', w,[0 0 0],[winRect]); 
Screen('Flip', w) ;  


input = [];
a = 1;
temp = InitialThreshold;

for j = 1:10000    % Number of clicks until reaching threshold 15 times overall

StartTime{i,1}(j,1) = GetSecs;
    
% Get mouse click info 
[clicks,x(j),y(j),whichButton] = GetClicks(w,0.1);

MousePress = any(whichButton); %sets to 1 if a button was pressed

if MousePress %if key was pressed do the following
     ResponseTime{i,1}(j,1) = GetSecs-StartTime{i,1}(j,1);
end


% Distance from first click point to center 1
Dist{i,1}(j,1) = sqrt((x(j) - DotLoc(i,1))^2 + (y(j) - DotLoc(i,2))^2);

Click{i,1}(j,1) = x(j);
Click{i,1}(j,2) = y(j);



% Decrease threshold - only when clicks are within threshold
if Dist{i,1}(j,1) <= temp
    a = a + 1;
    if a < size(Slope,2)
        temp = Slope(1,a);
    else
        a = size(Slope,2);
        temp = Slope(1,a);
    end
else
    temp = Slope(1,a);
end

Threshold(i,j) = temp;


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
      
      



DrawFormattedText(w, Click_Count, 0.9*winRect(3), 0.1*winRect(4), white);

Screen('Flip', w);
   

       
       break
       

   else
       continue
       
   end   % Count >=

end    % j


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REVIEW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
message_review = [ '\n'...
    'Review? \n '...
    '\n'...
    '\n'...
    'Press Y for YES, press any other button for NO\n'...
    '\n'];

DrawFormattedText(w, message_review, 'center', 'center', [255 255 255] ) ;
Screen('Flip', w) ; 


%%%%%% Decide to review or not
 press1 = true;
    
    while press1
        [~, keyCode, ~] = KbPressWait;

        
        pressedKey = KbName(keyCode) ;
        

        
        YN = true;
        while YN
            
            if strcmpi(pressedKey, 'y') == 1
                input = 'y';
                YN = false;
                
            elseif strcmpi(pressedKey, 'n') == 1
                input = 'n';
                YN = false;
            else
                YN = false;
                input = [];
            end
            
        end    % while YN
        
        
    
    
    if strcmpi('y',input) == 1
        
        


% Display clicks and connect clicks

for ii = 1:size(Click{i,1},1)
    
    
            %%%%%%Display target%%%%%%%%%%%%

Dot_Rect(1,1) = DotLoc(i,1) - DotSize;  % Left
Dot_Rect(2,1) = DotLoc(i,2) - DotSize;  % Top
Dot_Rect(3,1) = DotLoc(i,1) + DotSize;  % Right
Dot_Rect(4,1) = DotLoc(i,2) + DotSize;  % Bottom
Screen('FillOval', w, grey, Dot_Rect);

WaitSecs(0.5);


    if Yes{i,1}(ii,1) == 1
    Screen('DrawDots', w, [Click{i,1}(ii,1);Click{i,1}(ii,2)], 10, green, [0 0], 1);
    else
    Screen('DrawDots', w, [Click{i,1}(ii,1);Click{i,1}(ii,2)], 10, red, [0 0], 1);
    end
    
    
    % Display reinforcements
Target_Rect(1,ii) = DotLoc(i,1) - Threshold(i,ii);  % Left
Target_Rect(2,ii) = DotLoc(i,2) - Threshold(i,ii);  % Top
Target_Rect(3,ii) = DotLoc(i,1) + Threshold(i,ii);  % Right
Target_Rect(4,ii) = DotLoc(i,2) + Threshold(i,ii);  % Bottom
Screen('FrameOval', w, grey, Target_Rect(1:4,ii), 2);

frame_start = [Click{i,1}(1,1)-5 Click{i,1}(1,2)-8;Click{i,1}(1,1)-5 Click{i,1}(1,2)+8;Click{i,1}(1,1)+10 Click{i,1}(1,2)];  % First click
frame_end = [Click{i,1}(size(Click{i,1},1),1)-7 Click{i,1}(size(Click{i,1},1),2)-7;Click{i,1}(size(Click{i,1},1),1)-7 Click{i,1}(size(Click{i,1},1),2)+7;Click{i,1}(size(Click{i,1},1),1)+7 Click{i,1}(size(Click{i,1},1),2)+7;Click{i,1}(size(Click{i,1},1),1)+7 Click{i,1}(size(Click{i,1},1),2)-7];
Screen('FillPoly', w, white, frame_start ,1);
Screen('FillPoly', w, white, frame_end ,1);


% Screen('DrawDots', w, [Click{i,1}(1,1);Click{i,1}(1,2)], 8, blue, [0 0], 1);   % First Click blue
% Screen('DrawDots', w, [Click{i,1}(size(Click{i,1},1),1);Click{i,1}(size(Click{i,1},1),2)], 8, white, [0 0], 1);   % Last Click white

DrawFormattedText(w, num2str(ii), 0.9*winRect(3), 0.1*winRect(4), white);

Screen('Flip', w) ; 
WaitSecs(0.5);

end  % ii


%%%%%%%%%%%%%%%% Display everything   %%%%%%%%%%%%%%%%%%

 %%%%%%Display target%%%%%%%%%%%%
 
Dot_Rect(1,1) = DotLoc(i,1) - DotSize;  % Left
Dot_Rect(2,1) = DotLoc(i,2) - DotSize;  % Top
Dot_Rect(3,1) = DotLoc(i,1) + DotSize;  % Right
Dot_Rect(4,1) = DotLoc(i,2) + DotSize;  % Bottom
Screen('FillOval', w, grey, Dot_Rect);

for ii = 1:size(Click{i,1},1)
    
% Display reinforcements
Target_Rect(1,ii) = DotLoc(i,1) - Threshold(i,ii);  % Left
Target_Rect(2,ii) = DotLoc(i,2) - Threshold(i,ii);  % Top
Target_Rect(3,ii) = DotLoc(i,1) + Threshold(i,ii);  % Right
Target_Rect(4,ii) = DotLoc(i,2) + Threshold(i,ii);  % Bottom
Screen('FrameOval', w, grey, Target_Rect(1:4,ii), 2);


% Display dots
    if Yes{i,1}(ii,1) == 1
    Screen('DrawDots', w, [Click{i,1}(ii,1);Click{i,1}(ii,2)], 10, green, [0 0], 1);
    else
    Screen('DrawDots', w, [Click{i,1}(ii,1);Click{i,1}(ii,2)], 10, red, [0 0], 1);
    end

frame_start = [Click{i,1}(1,1)-5 Click{i,1}(1,2)-8;Click{i,1}(1,1)-5 Click{i,1}(1,2)+8;Click{i,1}(1,1)+10 Click{i,1}(1,2)];  % First click
frame_end = [Click{i,1}(size(Click{i,1},1),1)-7 Click{i,1}(size(Click{i,1},1),2)-7;Click{i,1}(size(Click{i,1},1),1)-7 Click{i,1}(size(Click{i,1},1),2)+7;Click{i,1}(size(Click{i,1},1),1)+7 Click{i,1}(size(Click{i,1},1),2)+7;Click{i,1}(size(Click{i,1},1),1)+7 Click{i,1}(size(Click{i,1},1),2)-7];
Screen('FillPoly', w, white, frame_start ,1);
Screen('FillPoly', w, white, frame_end ,1);

% Screen('DrawDots', w, [Click{i,1}(1,1);Click{i,1}(1,2)], 8, blue, [0 0], 1);   % First Click blue
% Screen('DrawDots', w, [Click{i,1}(size(Click{i,1},1),1);Click{i,1}(size(Click{i,1},1),2)], 8, white, [0 0], 1);   % Last Click white
end

%%%Display trajectory
for iii = 1:size(Click{i,1},1) - 1
    Screen('DrawLines', w, [Click{i,1}(iii,1) Click{i,1}(iii+1,1);Click{i,1}(iii,2) Click{i,1}(iii+1,2)], 2, white, [0 0]);
end  % iii

DrawFormattedText(w, Click_Count, 0.9*winRect(3), 0.1*winRect(4), white);

Screen('Flip', w) ; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
press1 = false;
       KbWait;
    else
        press1 = false;
       
    end
    
       end        % while press1
       
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

elseif QuitProgram == 1
error('Not enough inputs. Please restart program.')
end   % if QuitProgram == 0
close all
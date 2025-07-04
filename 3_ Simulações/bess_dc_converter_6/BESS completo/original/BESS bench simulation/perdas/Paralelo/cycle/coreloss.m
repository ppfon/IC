%CORELOSS Caclulate power loss in a ferrite core.
%   
%   CORELOSS(time, B, alpha, beta, k, suppressFlag)
%
%   time and B are a piecewise linear series of data points
%   time = vector of successive time values corresponding to flux values, in seconds.
%   B = vector of flux densities corresponding to time vector values, in tesla.
%   alpha, beta, k = Steinmetz parameters.  Must be for use with MKS units
%   suppressFlag: 0 to display input plot, loss  and error information in the
%                   command window.
%                 1 to suppress all output and only return the loss value.
%                   If an error occurs, CORELOSS will return -1.
%             
%   CORELOSS will calculate the power loss in your specified ferrite core.
%   The loss value is in W/m^3. 

% Created by Charles Sullivan, Kapil Venkatachalam, Jens Czogalla
% at Thayer School of Engineering, Dartmouth College.
% Modified by Kip Benson 3/03 (error checking on input data and improved
% command line interface).
% Corrected 11/05 C. Sullivan:  fixed minor loop handling bug ("minortime" was mistyped as minorime")

function y = coreloss(tvs, B, alpha, beta, k, suppressFlag)

%tvs is what was called "time" in help info above.
% check data for errors
	error = 'None';
	
	%makes sure times are successive
	for i = 2 : length(tvs)
        if tvs(i-1) >= tvs(i)
            error = 'Time data points must be successive.';
        end
	end
    
    %make sure vectors are same length
    if length(tvs) ~= length(B)
        error = 'Time and flux vectors must have same length';
    end
    
    if B(1) ~= B( length(B) )
        error = 'Since the PWL input is periodic, the first flux value must equal the last';
    end
% done checking for errors

% calculate core loss if there is no error with the input data
if suppressFlag == 0
    
    if strcmp(error, 'None')
        Pcore = gsepwl(tvs', B, alpha, beta, k);
        disp(strcat('Core Loss: ', num2str(Pcore), ' (W/m^3)'))
        y = Pcore;
        
        %plot the user's input
        pwlPlot = figure('visible', 'on');
        plot(tvs, B,'b.-');
        xlabel('Time (s)');
        ylabel('Flux Density (T)');
        title('Plot of Input Data');
    else
        disp(strcat('Error: ', error))
        y = -1;
    end
    
elseif suppressFlag == 1                    % suppress output
    if strcmp(error, 'None')
        y = gsepwl(tvs', B, alpha, beta, k);
    else
        y = -1;     % error occured
    end

end


%====================================================================
%to calculate core loss per unit volume using GSE for PWL signal form
%====================================================================
function p=gsepwl(t,B,alpha,beta,k)

            % a is fraction of Bpp used, 1-a is fraction of original
a = 1.0;    % a=1 for iGSE
            % a=0 for GSE

T = t(length(t))-t(1);            %total time of PWL period

ki = k/((2^(beta+1))*pi^(alpha-1)*(0.2761+1.7061/(alpha+1.354)));

[B,t,Bs,ts] = splitloop(B,t);     %split waveform into major and minor loops

pseg(1) = calcseg(t,B,alpha,beta,ki,a);

dt(1) = t(length(t))-t(1);

for j = 1:length(ts)
    pseg(j+1) = calcseg(ts{j},Bs{j},alpha,beta,ki,a);
    tseg = ts{j};
    dt(j+1) = tseg(length(tseg))-tseg(1);
end

p = sum(pseg.*dt)/T;

%==============
% Loop Splitter
%==============
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Loop Spliter%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%By %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Kapil Venkatachalam%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Modified on June 2nd, 2002%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%This program takes a piecewise linear
%current waveform corresponding to a B-H loop 
%and splits it into smaller waveforms 
%which have the same starting and ending value.
%
%Inputs:
%
%'a': B vector corresponding to the B-H loop.
%'b': Time vector of currents corrssponding to the B-H loop. 
%
%Outputs:
%
%'Majorloop': B values corrssponding to the major B-H loop.
%'Majortime': time vector of currents corrssponding to the major B-H loop.
%'Minorloop': B values corrssponding to the different minor B-H loop.
%'Minorloop': time vector of currents corrssponding to the different minor B-H loop.

function [ majorloop, majortime, minorloop, minortime] = splitloop(a,b);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Reshaping the waveforms and identifying the peak point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Identifies the lowest point in 'a'.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

e = 0;                          %Constant defined to identify the position of the lowest value.
sa = 1;                         %Counter to check if lowest point is reached.
for d = 1 : length(a)           %Check for the size of vector.
    if (a(d)== min(a)& sa ==1)  %Checking condition if lowest point has been reached.
        e = d;                  %Identifies the lowest point in the waveform.
        sa = sa +1;             %Counter incremented if lowest point is reached.
    end
end

%v is a vector which stores the shifted values of 'a'.
%t is a vector which stores the shifted values of 'b'.

v = a(e);       % adds the lowest point as the first value.
t = 0;          % adds the coresponding time value the first value.


bdiff = diff(b); % adjusts for the times corresponding to the values.
cumdiff = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loop stores all value of 'a' (from the lowest point till the end point) in 'v'.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for q = e+1 : length(a)             %'q' counts the remaing vectors before the lowest point is reached.
    v = [v a(q)];                   %Values of 'a' stored in 'v'.
    cumdiff = cumdiff + bdiff(q-1); %Time adjustment
    t = [t cumdiff];                %Values of 'b' stored in 't'.
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loop stores all value of 'a' (from the starting point till the lowest point) in 'v'.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for zx = 2 : e                      % Appends the part before the lowest point.
    v = [v a(zx)];                  %Values of 'a' stored in 'v'.
    cumdiff = cumdiff + bdiff(zx-1);%Time adjustment    
    t = [t cumdiff];                %Values of 'b' stored in 't'.
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Finds the position of the peak value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

z = 0;                          %Constant defined to identify the position of the peak value.
sa = 1;                         %Counter to check if peak point is reached.
for x= 1 : length(v)            %Check for the size of vector.
    if (v(x)== max(v) & sa == 1)%Checking condition if peak has been reached.
        z = x;                  %Identifies the peak point in the waveform.
        sa = sa +1;             %Counter incremented if peak point is reached.
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             End of reshaping the waveforms and identifying the peak point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Defining variables to keep track of values in the vectors
i=2;
j=1;
k=1;

s=cell(1300); % Defining cells for minorloop.
p=cell(1300); % Defining cells for minortime.

%'m' stores the majorloop values extracted from 'v'.
%'n' stores the corrsponding time values extracted from 't'.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Splits the rising portion of the waveform
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

m(1) = v(1); % Adds the first element of 'v' to'm'.
n(1) = t(1); % Adds the first element of 't' to'n'.


while (i <= z)          %Checks for all values before the peak point
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                     Check to see if the waveform is rising
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if (v(i) >= v(i-1)) %Compares adjascent values of 'v'.
        
        m = [m v(i)];   %Adds the an element of 'v' to'm'.
        n = [n t(i)];   %Adds the an element of 't' to'n'.
        count=1;        %Counter to keep track of end of the rising part.
        
    else
        %Check for minor loop in the risisng part
        s{j,1} = [s{j,1} v(i-1)];   %Adds the an element of 'v' to's'.
        p{j,1} = [p{j,1} t(i-1)];   %Adds the an element of 't' to'p'.
        
% by jens czogalla
        k = k + 1;
        
        % Repeating the process till the minor loop ends
        while (v(i) < max(m))     
            s{j,1} = [s{j,1} v(i)];     %Adds the an element of 'v' to's'.
            p{j,1} = [p{j,1} t(i)];     %Adds the an element of 't' to'p'.
% by jens czogalla            
            k = k + 1;
            
            i=i+1;                      %Increments the counter keeping track of the elements in 'v'.
        end
        
        % Calculating the slope of the rising edge of the minor loop.
        slope = (v(i-1)-v(i))/(t(i-1)-t(i)); 

        %Makes the last element of the minor loop same as the maximum value of 'm'.
        s{j,1} = [s{j,1} max(m)];
        
        %Computes the value of time of the point which was stored last in 's'.
        stemp = ((max(m) - v(i-1)) / slope) + t(i-1); %Calculating the time value.
        p{j,1} = [p{j,1} stemp];                      %Value is stored in p.
        m = [m max(m)];                               %The last point in 'm' is repeated for continuity.
        n = [n stemp];                                %The time value is also repeated.
        count=count+1;                                %Counter is incremented to indicate end of minor loop.
        j=j+1;                                        %Index of 's' is incremented.
% bz jens czogalla        
        k = 1;
        
    end
   if (count <= 1)                                    %Check condition keeping track of end of rising part.
        i=i+1;                                        %Increment counter keeping track of the elements in 'v'.
   else
   end    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   End of splitting of the rising portion of the waveform
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%'m' now stores part the rising part of the major loop.
%'n' stores the corresponding time values of the major loop.
%'s' stores the minor loops in the rising part of the waveform.
%'p' stores the corresponding time values of the minor loops.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Splits the falling portion of the waveform
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while (i <= length(v) ) %Checks for all values after the peak point
    if (v(i) <= v(i-1)) %Compares adjascent values of 'v'.
     
        m = [m v(i)];   %Adds the an element of 'v' to'm'.
        n = [n t(i)];   %Adds the an element of 't' to'n'.
        count=1;        %Counter to keep track of end of the rising part.
        
    else
        
        %Check for minor loop in the falling part.
        temp = v(i-1);                          %Temporary variable to store last value in 'v'.
        s{j,1} = [s{j,1} v(i-1)];               %Adds the an element of 'v' to's'. 
        p{j,1} = [p{j,1} t(i-1)];               %Adds the an element of 't' to'p'. 
% by jens czogalla        
        k = k + 1;
               
        while (i <= length(v) & v(i) > temp)    %Compares adjascent values of 'v' for all the remaining 'v' values.
            s{j,1} = [s{j,1} v(i)];             %Adds the an element of 'v' to's'.
            p{j,1} = [p{j,1} t(i)];             %Adds the an element of 't' to'p'.
% by jens czogalla            
            k = k + 1;
            
            i=i+1;                              %Increments the counter keeping track of the elements in 'v'.
        end   
       
        % Repeating the process till the minor loop ends

%         while (i <= length(v))
% by jens czogalla
        while (i <= length(v) & k > 1)
            
           
            % Calculating the slope of the rising edge of the minor loop.
            slope = (v(i-1)-v(i))/(t(i-1)-t(i));
            
            %Makes the first element of the minor loop same as the last element in 'm'.
            s{j,1} = [s{j,1} temp];
            
            %Computes the value of time of the point which was stored last in 's'.
            qtemp = ((temp - v(i-1)) / slope) + t(i-1); %Calculating the time value.
            p{j,1} = [p{j,1} qtemp];                    %Value is stored in p.
            r=1;                                        %Counter to make the pass through the loop only once.
            while ( v(i) ~= temp & r==1)
                m = [m temp];                           %The last point in 'm' is repeated for continuity.
                n = [n qtemp];                          %The time value is also repeated.
                r = r + 1;                              %Counter incremented to indicate the pass has been made.
            end
            count=count+1;                              %Counter is incremented to indicate end of minor loop.
            j=j+1;                                      %Index of 's' is incremented.
% by jens czogalla            
            k = 1;
            
        end
   end
   if (count <= 1)                                      %Check condition keeping track of end of falling part.
       i=i+1;                                           %Increment counter keeping track of the elements in 'v'.
   else
   end    
 end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   End of splitting of the falling portion of the waveform
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Removal of repetition of points in 'm' and adjusting the values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x= length (m);          %Variable to store the length of 'm'.
majorloop= [m(1)];      %Stores the first element of 'm' in 'majorloop'                 
majortime= [n(1)];      %Stores the first element of 'n' in 'minorloop'      
g = 0;                  %Initializing variable which adjust time for points following the point of repetition.



% by jens czogalla
for h = 2:x
    

    if m(h-1) ~= m(h)   %Checking for repeated points.
         majortime = [majortime n(h)-g];    %Add time value to 'majortime'.
         majorloop = [majorloop m(h)];      %Add corresponding value of 'm' in 'majorloop'.    
    else
        g = g + n(h) -n(h-1);               %Adjusts the time to compensate for repitions.
    end   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           End of removal of repetition of points in 'm' and adjusting the values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Finding the number of minor loops to be used for checking sub loops later
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    
uo = 1;
pt = 0;                         %Variable to keep track of the number of minor loops.
ss = 1;
while (ss == 1 & uo <= size(s))
        % while (s{uo,1} ~= [])  isempty~(X)
        while ~isempty(s{uo,1})
            uo = uo + 1;
        end
        ss = ss + 1;
        pt = uo-1;
 end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                        Recursion
%              Checks if any portion of the  split waveform has subloops.
%              If so repeats the above process to make it a single loop.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

minorloop = {};
minortime = {};
for qq = 1: pt

    sinp = s{qq};    %flux
    pinp = p{qq};    %time
 
    if (minorloop1(sinp,pinp))
        [fn, ln, sn, pn] = splitloop(sinp,pinp);    
        if(length(fn)~=0)
            minorloop{length(minorloop)+1} = fn;
            minorloop{length(minorloop)+1} = sn{1};
            minortime{length(minortime)+1} = ln;
            minortime{length(minortime)+1} = pn{1};
        end
    else
        if(length(sinp)~=0)
            minorloop{length(minorloop)+1} = sinp;
            minortime{length(minortime)+1} = pinp;
        end
    end
    
end

%***********************************************************************************************
%***********************************************************************************************


%=======================================================
%calculate loss for loop segment using improved equation
%=======================================================
function pseg = calcseg(t,B,alpha,beta,k1,a)

                            %a is fraction of Bpp used, 1-a is fraction of original
bma1a=(beta-alpha)*(1-a);   %exponent of B(t)
bmaa=(beta-alpha)*a;        %exponent of Bpp

Bpp=max(B)-min(B);

if sum(B<0)>0
	[t,B]=makepositive(t,B);
end

len=length(t);
T=t(len)-t(1);
deltaB=abs(B(2:len)-B(1:len-1));
deltat=(t(2:len)-t(1:len-1));
dBdt=deltaB./deltat;
m1=dBdt.^(alpha-1);
m2=abs((B(2:len)).^(bma1a+1)-(B(1:len-1)).^(bma1a+1));
pseg=k1/T/(bma1a+1)*sum(m1.*m2)*Bpp^bmaa;


%==========================================================================
%Convert a piecewise-linear waveform w (which must be a vector)
%represented by the points w at times t, to a piecewise-linear waveform with 
%points at any zero crossings.  Thus, any segment of the returned waveform is all 
%positive or all negative.  If w is a matrix, use makepositiveM.
%==========================================================================
function [t,w] = makepositive(t,w)
len = length(t);
cross = ( ( w(1:len-1).*w(2:len) ) < 0 );
loopnumber=len-1+sum(cross);
for i = 1:loopnumber
   if cross(i)
      len=length(w);
      tcross = w(i)*(t(i+1) - t(i))/(w(i)-w(i+1)) + t(i);
      t = [ t(1:i) tcross t(i+1:len)];
      w = [  w(1:i) 0 w(i+1:len)];
      cross = [ cross(1:i) 0 cross(i+1:len-1)];
   end
 end  
w=abs(w);



%==================
%minorloop function
%==================
function [ml] = minorloop1(s,p)
qr = length(s);
peak = -1;
prevslope = 0;
for i = 2 : qr
    slope = (s(1,i-1)-s(1,i))/(p(1,i-1)-p(1,i));
    if (slope <=0 & prevslope >=0)
        peak = peak + 1;
    end 
    if (prevslope <=0 & slope >=0)
        peak = peak + 1;
    end 
    prevslope = slope;
end 
if (peak > 2)
    ml = 1;
else
    ml = 0;
end
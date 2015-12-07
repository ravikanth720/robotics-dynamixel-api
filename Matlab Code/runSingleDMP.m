function [Y] = runSingleDMP(start, goal, startVel, startAccel, PHI, amp, w, H, C, phase, params)

%Set Meta Parameters:
y0=start;
g=goal;

x=phase;        %reset canonical system
y=y0;           %reset dynamic system state
yd=startVel;    %reset dynamic system velocity
ydd=startAccel; %reset dynamic system acceleration
%amp=g-y0;      %set standard amplitude
psi=zeros(params.nrlmodel,1); %Basis functions
ctau = params.tau;
Y(1) = y0;

YDD = [];
XDD = [];
%goal = [];
for j=1:(params.timesteps)
    %Compute forceing function
    psi=exp(-1*H.*(x-C).^2)';
    f=sum(w'*psi*x)/(sum(psi));
   
    if(isnan(f))
        f=0;
    end
    
    %Simulate dynamics
    ydd=(params.alphay*(params.betay*(g-y)-(yd/ctau))+(amp.*f))*ctau*ctau;
    
    % HACK!!
    if(j<2) 
        ydd = 0.0001;
    end
   
    % calculate velocity?
    yd=yd+ydd*params.dt;
    
    % calculate new position
    y=y+yd*params.dt;
     
    %Update canonical system
    xd=-params.alphax*x*ctau;
    x=x+xd*params.dt;
    
    Y(j+1)=y; %Store executed trajectory
    
    %YDD = [YDD ydd];
    %XDD = [XDD (amp.*f)];
end

%figure 
%hold on
%plot(goal)

%figure
%hold on
%plot(YDD)
%plot(XDD, 'g')
%plot(XDD+YDD, 'r')
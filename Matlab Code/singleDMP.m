function [PHI, amp, w, H, C] = singleDMP(Time, Traj, Trajd, Trajdd, params)

%Set basis function hyperparameters for forcing function
C=zeros(1,params.nrlmodel); %Basis function centres
H=zeros(1,params.nrlmodel); %Basis function width parameters
for i=1:params.nrlmodel
    C(i)=exp(-params.alphax*(i-1)*0.5/(params.nrlmodel-1));
end
for i=1:params.nrlmodel-1
    H(i)=0.5/(0.65*(C(i+1)-(C(i))).^2);
end
H(params.nrlmodel)= H(params.nrlmodel-1);

%Set metaparameters according to Trajectory data
dt=mean(diff(Time)); %Time steps (assumed to be constant)
y0=Traj(1); %Start state
g=Traj(end); %Goal state
amp=(g-y0); %Amplitude

FT=((Trajdd/(params.tau^2))-( params.alphay *(params.betay*(g-Traj) - (Trajd/params.tau))))./amp;

X=1;
for k=1:length(Time)
    for j=1:params.nrlmodel
        PHI(k,j)=exp(-H(j)*(X-C(j)).^2); %Basis function activation over time
    end
    PHI(k,:)=PHI(k,:)*X/sum(PHI(k,:));  %Normalize basis functions and weight by canonical state
    X= X - params.alphax * X * params.tau * params.dt;%
end

%Learn weights
w=pinv(PHI)*FT;









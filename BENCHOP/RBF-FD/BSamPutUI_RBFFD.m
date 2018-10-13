function [U]=BSamPutUI_RBFFD(S,K,T,r,sig)
%% 1D American Put RBF-FD-GA with Chebishev nodes
% Copyright 2014, Slobodan Milovanovic

%% Parameters
% S=[90,100,110];
% K=1; %strike
% T=1; %maturation
% r=0.03; %interest
% sig=0.15; %volatility
%% Grid
N=350;
N1=round(N/4);
N2=N-N1;

lim=4;
cen=1;

chebr=flip(chebx([1,0],N1)+2);
chebl=chebx([0,1],N2+1);

x1=chebr*cen;
x2=chebl*(lim-cen)+cen;

x=[x1;x2(2:end)];

dx=x(2)-x(1);
n=5; %stencil size
m=round((n-1)/2);

Ks=1;

M=180;
dt=T/(M-1);
t=T:-dt:0;

%% Initial condition
u=max(Ks-x,zeros(N,1));
lambda=zeros(N,1);

%% RBF
ep=0.0001;

%% Weights
W=sparse(N,N);

for ii=2:m
    indc=1:n;
    xc=x(ii);
    xi=x(indc);
    
    wc1=rbfga_weights_BS('xx',ep,xi,xc,r,sig);
    wc1=wc1*0.5*sig^2*x(ii)^2;
    
    wc2=rbfga_weights_BS('x',ep,xi,xc,r,sig);
    wc2=wc2*r*x(ii);
    
    wc3=rbfga_weights_BS('0',ep,xi,xc,r,sig);
    wc3=-wc3*r;
    
    wc=wc1+wc2+wc3;
    
    W(ii,indc)=wc;
end

for ii=m+1:N-m
    indc=ii-m:ii+m;
    xc=x(ii);
    xi=x(indc);
    
    wc1=rbfga_weights_BS('xx',ep,xi,xc,r,sig);
    wc1=wc1*0.5*sig^2*x(ii)^2;
    
    wc2=rbfga_weights_BS('x',ep,xi,xc,r,sig);
    wc2=wc2*r*x(ii);
    
    wc3=rbfga_weights_BS('0',ep,xi,xc,r,sig);
    wc3=-wc3*r;
    
    wc=wc1+wc2+wc3;
    
    W(ii,indc)=wc;
end

for ii=N-m+1:N-1
    indc=N-n+1:N;
    xc=x(ii);
    xi=x(indc);
    
    wc1=rbfga_weights_BS('xx',ep,xi,xc,r,sig);
    wc1=wc1*0.5*sig^2*x(ii)^2;
    
    wc2=rbfga_weights_BS('x',ep,xi,xc,r,sig);
    wc2=wc2*r*x(ii);
    
    wc3=rbfga_weights_BS('0',ep,xi,xc,r,sig);
    wc3=-wc3*r;
    
    wc=wc1+wc2+wc3;
    
    W(ii,indc)=wc;
end

%% Integration
I=speye(N);
%BDF-1
A=I-W*dt;

u1=u;
util=A\(u1-dt*lambda);

lambdaold=lambda;
u=util+dt*(lambdaold-lambda);

for ii=1:N
    if u(ii)-(Ks-x(ii))<0
        u(ii)=Ks-x(ii);
        lambda(ii)=lambdaold(ii)-(u(ii)-util(ii))/dt;
    end
end

%BDF-2
A=I-(2/3)*dt*W;

for ii=3:M
    u2=u1;
    u1=u;
    
    util=A\((4/3)*u1-(1/3)*u2-(2/3)*dt*lambda);
    lambdaold=lambda;
    lambda=zeros(N,1);
    u=max(u,0);

    u=util+(2/3)*dt*(lambdaold-lambda);
    
    for jj=1:N
        if u(jj)-(Ks-x(jj))<0
            u(jj)=Ks-x(jj);
            lambda(jj)=lambdaold(jj)+(3/(2*dt))*(util(jj)-u(jj));
        end
    end
    
    
end

x=K*x;
u=K*u;

U=interp1(x,u,S,'spline');

end
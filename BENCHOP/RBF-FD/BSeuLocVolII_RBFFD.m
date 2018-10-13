function [Uloc]=BSeuLocVolII_RBFFD(S,K,T,r,vol)
%% 1D European Call RBF-FD-GA with Chebishev nodes
% Copyright 2014, Slobodan Milovanovic

%% Parameters
% S=[90,100,110];
% K=1; %strike
% T=1; %maturation
% r=0.03; %interest
% sig=0.15; %volatility

%% Grid

for zz=1:numel(S)
    
    N=100;
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
    
    M=100;
    dt=T/(M-1);
    t=T:-dt:0;
    
    %% Initial condition
    u=max(x-Ks,zeros(N,1));
    
    %% RBF
    ep=0.001;
    
    
    %% Integration
    
    I=speye(N);
    
    %BDF-1
    sig=vol(r,S(zz),x*K,t(2));
    
    W=sparse(N,N);
    for kk=2:m
        indc=1:n;
        xc=x(kk);
        xi=x(indc);
        
        wc1=rbfga_weights_BS('xx',ep,xi,xc,r,sig);
        wc1=wc1*0.5*sig(kk)^2*x(kk)^2;
        
        wc2=rbfga_weights_BS('x',ep,xi,xc,r,sig);
        wc2=wc2*r*x(kk);
        
        wc3=rbfga_weights_BS('0',ep,xi,xc,r,sig);
        wc3=-wc3*r;
        
        wc=wc1+wc2+wc3;
        
        W(kk,indc)=wc;
    end
    
    for kk=m+1:N-m
        indc=kk-m:kk+m;
        xc=x(kk);
        xi=x(indc);
        
        wc1=rbfga_weights_BS('xx',ep,xi,xc,r,sig);
        wc1=wc1*0.5*sig(kk)^2*x(kk)^2;
        
        wc2=rbfga_weights_BS('x',ep,xi,xc,r,sig);
        wc2=wc2*r*x(kk);
        
        wc3=rbfga_weights_BS('0',ep,xi,xc,r,sig);
        wc3=-wc3*r;
        
        wc=wc1+wc2+wc3;
        
        W(kk,indc)=wc;
    end
    
    for kk=N-m+1:N-1
        indc=N-n+1:N;
        xc=x(kk);
        xi=x(indc);
        
        wc1=rbfga_weights_BS('xx',ep,xi,xc,r,sig);
        wc1=wc1*0.5*sig(kk)^2*x(kk)^2;
        
        wc2=rbfga_weights_BS('x',ep,xi,xc,r,sig);
        wc2=wc2*r*x(kk);
        
        wc3=rbfga_weights_BS('0',ep,xi,xc,r,sig);
        wc3=-wc3*r;
        
        wc=wc1+wc2+wc3;
        
        W(kk,indc)=wc;
    end
    
    A=I-W*dt;
    [L,U]=lu(A);
    
    u1=u;
    
    b=u1;
    b(end)=x(end)-Ks*exp(-r*dt);
    
    u=U\(L\b);
    u=max(u,0);
    
    %BDF-2
    
    for ii=3:M
        sig=vol(r,S(zz),x*K,t(ii));
        
        W=sparse(N,N);
        
        for kk=2:m
            indc=1:n;
            xc=x(kk);
            xi=x(indc);
            
            wc1=rbfga_weights_BS('xx',ep,xi,xc,r,sig);
            wc1=wc1*0.5*sig(kk)^2*x(kk)^2;
            
            wc2=rbfga_weights_BS('x',ep,xi,xc,r,sig);
            wc2=wc2*r*x(kk);
            
            wc3=rbfga_weights_BS('0',ep,xi,xc,r,sig);
            wc3=-wc3*r;
            
            wc=wc1+wc2+wc3;
            
            W(kk,indc)=wc;
        end
        
        for kk=m+1:N-m
            indc=kk-m:kk+m;
            xc=x(kk);
            xi=x(indc);
            
            wc1=rbfga_weights_BS('xx',ep,xi,xc,r,sig);
            wc1=wc1*0.5*sig(kk)^2*x(kk)^2;
            
            wc2=rbfga_weights_BS('x',ep,xi,xc,r,sig);
            wc2=wc2*r*x(kk);
            
            wc3=rbfga_weights_BS('0',ep,xi,xc,r,sig);
            wc3=-wc3*r;
            
            wc=wc1+wc2+wc3;
            
            W(kk,indc)=wc;
        end
        
        for kk=N-m+1:N-1
            indc=N-n+1:N;
            xc=x(kk);
            xi=x(indc);
            
            wc1=rbfga_weights_BS('xx',ep,xi,xc,r,sig);
            wc1=wc1*0.5*sig(kk)^2*x(kk)^2;
            
            wc2=rbfga_weights_BS('x',ep,xi,xc,r,sig);
            wc2=wc2*r*x(kk);
            
            wc3=rbfga_weights_BS('0',ep,xi,xc,r,sig);
            wc3=-wc3*r;
            
            wc=wc1+wc2+wc3;
            
            W(kk,indc)=wc;
        end
        A=I-(2/3)*dt*W;
        [L,U]=lu(A);
        
        u2=u1;
        u1=u;
        
        b=((4/3)*u1-(1/3)*u2);
        b(end)=x(end)-Ks*exp(-r*(ii-1)*dt);
        
        u=U\(L\b);
        u=max(u,0);
    end
    
    x=K*x;
    u=K*u;
    
    Uloc(zz)=interp1(x,u,S(zz),'spline');
end
end
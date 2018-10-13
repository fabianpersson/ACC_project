% Copyright (c) 2015, BENCHOP, Slobodan Milovanović
% All rights reserved.
% This MATLAB code has been written for the BENCHOP project.
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%    * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
%    * BENCHOP article is properly cited by the user of the BENCHOP codes when publishing/reporting related scientific results.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
clear
close all

format long

% addpath(genpath('./')); %adds all the functions from subfolders to the path
% mfiles=getfilenames('./','BSeuCallU*.m')

warning off

Methods={'MC','MC-S','QMC-S','MLMC','MLMC-A',...
    'FFT','FGL','COS',...
    'FD','FD-NU','FD-AD',...
    'RBF','RBF-FD','RBF-PUM','RBF-LSML','RBF-AD','RBF-MLT'};

%% Problem 1 a) I

display('Problem 1 a) I');
rootpath=pwd;
S=[90,100,110]; K=100; T=1.0; r=0.03; sig=0.15;
U=[2.758443856146076 7.485087593912603 14.702019669720769];

filepathsBSeuCallUI=getfilenames('./','BSeuCallUI_*.m');
par={S,K,T,r,sig};
[timeBSeuCallUI,relerrBSeuCallUI] = executor(rootpath,filepathsBSeuCallUI,U,par)

tBSeuCallUI=NaN(numel(Methods),1); rBSeuCallUI=tBSeuCallUI;
for ii=1:numel(Methods)
    for jj=1:numel(filepathsBSeuCallUI)
        a=filepathsBSeuCallUI{jj}(3:3+numel(Methods{ii}));
        b=[Methods{ii},'/'];
        if strcmp(a,b)
            tBSeuCallUI(ii)=timeBSeuCallUI(jj);
            rBSeuCallUI(ii)=relerrBSeuCallUI(jj);
        end
    end
end

cd(rootpath);

%% Problem 1 b) I

display('Problem 1 b) I');
rootpath=pwd;
S=[90,100,110]; K=100; T=1.0; r=0.03; sig=0.15;
U=[10.726486710094511 4.820608184813253 1.828207584020458];

filepathsBSamPutUI=getfilenames('./','BSamPutUI_*.m');
par={S,K,T,r,sig};
[timeBSamPutUI,relerrBSamPutUI] = executor(rootpath,filepathsBSamPutUI,U,par)

tBSamPutUI=NaN(numel(Methods),1); rBSamPutUI=NaN(numel(Methods),1);
for ii=1:numel(Methods)
    for jj=1:numel(filepathsBSamPutUI)
        a=filepathsBSamPutUI{jj}(3:3+numel(Methods{ii}));
        b=[Methods{ii},'/'];
        if strcmp(a,b)
            tBSamPutUI(ii)=timeBSamPutUI(jj);
            rBSamPutUI(ii)=relerrBSamPutUI(jj);
        end
    end
end

cd(rootpath);

%% Problem 1 c) I

display('Problem 1 c) I');
rootpath=pwd;
S=[90,100,110]; K=100; T=1.0; r=0.03; sig=0.15; B=1.25*K;
U=[1.822512255945242 3.294086516281595 3.221591131246868];

filepathsBSupoutCallI=getfilenames('./','BSupoutCallI_*.m');
par={S,K,T,r,sig,B};
[timeBSupoutCallI,relerrBSupoutCallI] = executor(rootpath,filepathsBSupoutCallI,U,par)

tBSupoutCallI=NaN(numel(Methods),1); rBSupoutCallI=NaN(numel(Methods),1);
for ii=1:numel(Methods)
    for jj=1:numel(filepathsBSupoutCallI)
        a=filepathsBSupoutCallI{jj}(3:3+numel(Methods{ii}));
        b=[Methods{ii},'/'];
        if strcmp(a,b)
            tBSupoutCallI(ii)=timeBSupoutCallI(jj);
            rBSupoutCallI(ii)=relerrBSupoutCallI(jj);
        end
    end
end

cd(rootpath);

%% Problem 1 a) II

display('Problem 1 a) II');
rootpath=pwd;
S=[97,98,99]; sig=0.01; r=0.1; T=0.25; K=100;
U=[0.033913177006141   0.512978189232598   1.469203342553328];

filepathsBSeuCallUII=getfilenames('./','BSeuCallUII_*.m');
par={S,K,T,r,sig};
[timeBSeuCallUII,relerrBSeuCallUII] = executor(rootpath,filepathsBSeuCallUII,U,par)

tBSeuCallUII=NaN(numel(Methods),1); rBSeuCallUII=NaN(numel(Methods),1);
for ii=1:numel(Methods)
    for jj=1:numel(filepathsBSeuCallUII)
        a=filepathsBSeuCallUII{jj}(3:3+numel(Methods{ii}));
        b=[Methods{ii},'/'];
        if strcmp(a,b)
            tBSeuCallUII(ii)=timeBSeuCallUII(jj);
            rBSeuCallUII(ii)=relerrBSeuCallUII(jj);
        end
    end
end

cd(rootpath);

%% Problem 1 b) II

display('Problem 1 b) II');
rootpath=pwd;
S=[97,98,99]; K=100; T=0.25; r=0.1; sig=0.01;
U=[3.000000000000682 2.000000000010786   1.000000000010715];

filepathsBSamPutUII=getfilenames('./','BSamPutUII_*.m');
par={S,K,T,r,sig};
[timeBSamPutUII,relerrBSamPutUII] = executor(rootpath,filepathsBSamPutUII,U,par)

tBSamPutUII=NaN(numel(Methods),1); rBSamPutUII=NaN(numel(Methods),1);
for ii=1:numel(Methods)
    for jj=1:numel(filepathsBSamPutUII)
        a=filepathsBSamPutUII{jj}(3:3+numel(Methods{ii}));
        b=[Methods{ii},'/'];
        if strcmp(a,b)
            tBSamPutUII(ii)=timeBSamPutUII(jj);
            rBSamPutUII(ii)=relerrBSamPutUII(jj);
        end
    end
end

cd(rootpath);

%% Problem 1 c) II

display('Problem 1 c) II');
rootpath=pwd;
S=[97,98,99]; sig=0.01; r=0.1; T=0.25; K=100; B=1.25*K;
U=[0.033913177006134   0.512978189232598   1.469203342553328];

filepathsBSupoutCallII=getfilenames('./','BSupoutCallII_*.m');
par={S,K,T,r,sig,B};
[timeBSupoutCallII,relerrBSupoutCallII] = executor(rootpath,filepathsBSupoutCallII,U,par)

tBSupoutCallII=NaN(numel(Methods),1); rBSupoutCallII=NaN(numel(Methods),1);
for ii=1:numel(Methods)
    for jj=1:numel(filepathsBSupoutCallII)
        a=filepathsBSupoutCallII{jj}(3:3+numel(Methods{ii}));
        b=[Methods{ii},'/'];
        if strcmp(a,b)
            tBSupoutCallII(ii)=timeBSupoutCallII(jj);
            rBSupoutCallII(ii)=relerrBSupoutCallII(jj);
        end
    end
end

cd(rootpath);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Table2=table(tBSeuCallUI,tBSamPutUI,tBSupoutCallI,tBSeuCallUII,tBSamPutUII,tBSupoutCallII,'RowNames',Methods)
err=[rBSeuCallUI,rBSamPutUI,rBSupoutCallI,rBSeuCallUII,rBSamPutUII,rBSupoutCallII];
err=round(log10(err));

% Now use this table as input in our input struct:
input.data = Table2;
input.error = err;

% Set the row format of the data values (in this example we want to use
% integers only):
input.dataFormat = {'%.1e'};

% Switch transposing/pivoting your table:
input.transposeTable = 1;

% Column alignment ('l'=left-justified, 'c'=centered,'r'=right-justified):
input.tableColumnAlignment = 'c';

% Switch table borders on/off:
input.tableBorders = 0;

% Switch to generate a complete LaTex document or just a table:
input.makeCompleteLatexDocument = 0;

latex = latexTable(input);

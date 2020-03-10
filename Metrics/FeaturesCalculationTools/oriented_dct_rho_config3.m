function [v] = oriented_dct_rho_config3(I)

%H=fspecial('gaussian',[7 7]);

temp=dct2(I);
nn=size(I,1);
eps=0.00000001;

%% 3x3
% temp1=[temp(1,3) temp(2,3)];
%% 5x5
% F = [0 1 1 1 1;0 0 1 1 1; 0 0 0 0 1; 0 0 0 0 0;0 0 0 0 0];
% temp1=temp(F~=0);

%% g1

temp1=[];
if nn==5
    temp1=[temp(1,2:end) temp(2,3:end) temp(3,end)];
elseif nn==7
    temp1=[temp(1,2:end) temp(2,3:end) temp(3,5:end) temp(4,6:end)];
elseif nn==9
    temp1=[temp(1,2:end) temp(2,3:end) temp(3,5:end) temp(4,6:end) temp(5,8:end) temp(6,9:end)];
end

std_gauss=std(abs(temp1(:)));
mean_abs=mean(abs(temp1(:)));
g1=std_gauss/(mean_abs+eps);

%% g2

temp2=[];
if nn==5
    temp2=[temp(2,2),temp(3,3:4),temp(4,3:end),temp(5,4:end)];
elseif nn==7
    temp2=[temp(2,2) temp(3,3:4) temp(4,3:5)... 
        temp(5,4:end) temp(6,5:end) temp(7,5:end)];
elseif nn==9
    temp2=[temp(2,2) temp(3,3:4) temp(4,3:5) temp(5,4:7)...
        temp(6,5:8) temp(7,5:end) temp(8,6:end) temp(9,7:end)]; 
end

std_gauss=std(abs(temp2(:)));
mean_abs=mean(abs(temp2(:)));
g2=std_gauss/(mean_abs+eps);

%% g3

temp3=[];
if nn==5
    temp3=[temp(2:end,1); temp(3:end,2); temp(end,3)];
elseif nn==7
    temp3=[temp(2:end,1); temp(3:end,2); temp(5:end,3); temp(6:end,4)];
elseif nn==9
    temp3=[temp(2:end,1); temp(3:end,2); temp(5:end,3); temp(6:end,4);...
        temp(8:end,5); temp(9:end,6)];
end
std_gauss=std(abs(temp3));
mean_abs=mean(abs(temp3));
g3=std_gauss/(mean_abs+eps);


%% Var

v = var([g1 g2 g3]);

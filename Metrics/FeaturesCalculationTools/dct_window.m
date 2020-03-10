function res = dct_window(I)

im_dct = dct2(I);
inter = im_dct(:);
inter = inter(2:end);

abs_im_dct = abs(im_dct);

fin = 7;
eps=0.00000001;

%% gama_dct

gama_dct = gama_gen_gauss(inter);

%% coeff_var_dct

coeff_var_dct = coeff_var_gen_gauss(inter);

%% g1

temp1 = [abs_im_dct(1,2:fin) abs_im_dct(2,3:fin) abs_im_dct(3,5:fin) abs_im_dct(4,6:fin)];

std_gauss=std(temp1(:));
mean_abs=mean(temp1(:));
g1=std_gauss/(mean_abs+eps);

%% g2

temp2 = [abs_im_dct(2,2) abs_im_dct(3,3:4) abs_im_dct(4,3:5) abs_im_dct(5,4:fin) abs_im_dct(6,5:fin) abs_im_dct(7,5:fin)];

std_gauss=std(temp2(:));
mean_abs=mean(temp2(:));
g2=std_gauss/(mean_abs+eps);

%% g3

temp3=[abs_im_dct(2:fin,1); abs_im_dct(3:fin,2); abs_im_dct(5:fin,3); abs_im_dct(6:fin,4)];

std_gauss=std(temp3);
mean_abs=mean(temp3);
g3=std_gauss/(mean_abs+eps);


%% Var

v = var([g1 g2 g3]);

%% res

res = [gama_dct coeff_var_dct v];

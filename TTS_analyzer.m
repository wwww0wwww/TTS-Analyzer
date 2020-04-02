%% enter name
name_data = input('Please enter the name of dataset: ', 's');
disp('Please prepare the original data in Excel file, and save data of each temperature in separate sheets.');
path_name = input('Please enter the path of original data(i.e. C:\\Document\\Data\\): ', 's');
file_name = input('Please enter the name of original data (*.xls or *.xlsx): ', 's');
flag = input('Please choose the type of original data - 1. G''(w) / G"(w) 2. G(t): ');
tflag = input('Do you want to use the default temperature series (150, 170, 190, 210, 230)? 1. Yes 2. No: ');
if(tflag == 1)
	config_array=int32([150, 170, 190, 210, 230, 0]);
elseif(tflag == 2)
	config_array(1,1) = input('Please enter the 1st temperature: ');
	config_array(1,2) = input('Please enter the 2nd temperature: ');
	config_array(1,3) = input('Please enter the 3rd temperature: ');
	config_array(1,4) = input('Please enter the 4th temperature: ');
	config_array(1,5) = input('Please enter the 5th temperature: ');
	config_array(1,6) = 0;
else
	error('Wrong option number! Please retry.');
end

totalcounter = 1;

poly_n=input('Please choose the highest order of the polynomial used, 4 or 5: ');
%poly_n = 4;
full_name = [path_name, file_name];
T1=zeros(1,3);
T2=zeros(1,3);
T3=zeros(1,3);
T4=zeros(1,3);
T5=zeros(1,3);

if(flag == 1)
	T1 = xlsread(full_name,'sheet1');
	T2 = xlsread(full_name,'sheet2');
	T3 = xlsread(full_name,'sheet3');
	T4 = xlsread(full_name,'sheet4');
	T5 = xlsread(full_name,'sheet5');
elseif(flag == 2)
	Gt1 = xlsread(full_name,'sheet1');
	Gt2 = xlsread(full_name,'sheet2');
	Gt3 = xlsread(full_name,'sheet3');
	Gt4 = xlsread(full_name,'sheet4');
	Gt5 = xlsread(full_name,'sheet5');
	ni = 4;
	nj = 4;
	w0 = 0.0;
	wn = 0.0;

	%T1=zeros(ni*nj+1,3);
	%T2=zeros(ni*nj+1,3);
	%T3=zeros(ni*nj+1,3);
	%T4=zeros(ni*nj+1,3);
	%T5=zeros(ni*nj+1,3);

	ng = length(Gt);

	for i=1:ni
		w0 = 10.0.^(i-2);
		for j=1:nj
			wn = w0.*10.^((j-1)./nj);
			T1((i-1).*nj+j, 1) = wn;
			T2((i-1).*nj+j, 1) = wn;
			T3((i-1).*nj+j, 1) = wn;
			T4((i-1).*nj+j, 1) = wn;
			T5((i-1).*nj+j, 1) = wn;
			G11 = 0.0;
			G21 = 0.0;
			G12 = 0.0;
			G22 = 0.0;
			G13 = 0.0;
			G23 = 0.0;
			G14 = 0.0;
			G24 = 0.0;
			G15 = 0.0;
			G25 = 0.0;
			for n=1:ng
				G11 = G11 + Gt1(n,2).*(wn.*wn.*Gt1(n,1).*Gt1(n,1)/(1.0+wn.*wn.*Gt1(n,1).*Gt1(n,1)));
				G21 = G21 + Gt1(n,2).*(wn.*Gt1(n,1)/(1.0+wn.*wn.*Gt1(n,1).*Gt1(n,1)));
				G12 = G12 + Gt2(n,2).*(wn.*wn.*Gt2(n,1).*Gt2(n,1)/(1.0+wn.*wn.*Gt2(n,1).*Gt2(n,1)));
				G22 = G22 + Gt2(n,2).*(wn.*Gt2(n,1)/(1.0+wn.*wn.*Gt2(n,1).*Gt2(n,1)));
				G13 = G13 + Gt3(n,2).*(wn.*wn.*Gt3(n,1).*Gt3(n,1)/(1.0+wn.*wn.*Gt3(n,1).*Gt3(n,1)));
				G23 = G23 + Gt3(n,2).*(wn.*Gt3(n,1)/(1.0+wn.*wn.*Gt(n,1).*Gt3(n,1)));
				G14 = G14 + Gt4(n,2).*(wn.*wn.*Gt4(n,1).*Gt4(n,1)/(1.0+wn.*wn.*Gt4(n,1).*Gt4(n,1)));
				G24 = G24 + Gt4(n,2).*(wn.*Gt4(n,1)/(1.0+wn.*wn.*Gt4(n,1).*Gt4(n,1)));
				G15 = G15 + Gt5(n,2).*(wn.*wn.*Gt4(n,1).*Gt4(n,1)/(1.0+wn.*wn.*Gt4(n,1).*Gt4(n,1)));
				G25 = G25 + Gt5(n,2).*(wn.*Gt4(n,1)/(1.0+wn.*wn.*Gt4(n,1).*Gt4(n,1)));
			end
			T1((i-1).*nj+j, 2) = G11;
			T1((i-1).*nj+j, 3) = G21;
			T2((i-1).*nj+j, 2) = G12;
			T2((i-1).*nj+j, 3) = G22;
			T3((i-1).*nj+j, 2) = G13;
			T3((i-1).*nj+j, 3) = G23;
			T4((i-1).*nj+j, 2) = G14;
			T4((i-1).*nj+j, 3) = G24;
			T5((i-1).*nj+j, 2) = G15;
			T5((i-1).*nj+j, 3) = G25;
		end
	end

	wn = 1000.0;
	T1(ni.*nj+1, 1) = wn;
	T2(ni.*nj+1, 1) = wn;
	T3(ni.*nj+1, 1) = wn;
	T4(ni.*nj+1, 1) = wn;
	T5(ni.*nj+1, 1) = wn;
	G11 = 0.0;
	G21 = 0.0;
	G12 = 0.0;
	G22 = 0.0;
	G13 = 0.0;
	G23 = 0.0;
	G14 = 0.0;
	G24 = 0.0;
	G15 = 0.0;
	G25 = 0.0;
	for n=1:ng
		G11 = G11 + Gt1(n,2).*(wn.*wn.*Gt1(n,1).*Gt1(n,1)/(1.0+wn.*wn.*Gt1(n,1).*Gt1(n,1)));
		G21 = G21 + Gt1(n,2).*(wn.*Gt1(n,1)/(1.0+wn.*wn.*Gt1(n,1).*Gt1(n,1)));
		G12 = G12 + Gt2(n,2).*(wn.*wn.*Gt2(n,1).*Gt2(n,1)/(1.0+wn.*wn.*Gt2(n,1).*Gt2(n,1)));
		G22 = G22 + Gt2(n,2).*(wn.*Gt2(n,1)/(1.0+wn.*wn.*Gt2(n,1).*Gt2(n,1)));
		G13 = G13 + Gt3(n,2).*(wn.*wn.*Gt3(n,1).*Gt3(n,1)/(1.0+wn.*wn.*Gt3(n,1).*Gt3(n,1)));
		G23 = G23 + Gt3(n,2).*(wn.*Gt3(n,1)/(1.0+wn.*wn.*Gt(n,1).*Gt3(n,1)));
		G14 = G14 + Gt4(n,2).*(wn.*wn.*Gt4(n,1).*Gt4(n,1)/(1.0+wn.*wn.*Gt4(n,1).*Gt4(n,1)));
		G24 = G24 + Gt4(n,2).*(wn.*Gt4(n,1)/(1.0+wn.*wn.*Gt4(n,1).*Gt4(n,1)));
		G15 = G15 + Gt5(n,2).*(wn.*wn.*Gt4(n,1).*Gt4(n,1)/(1.0+wn.*wn.*Gt4(n,1).*Gt4(n,1)));
		G25 = G25 + Gt5(n,2).*(wn.*Gt4(n,1)/(1.0+wn.*wn.*Gt4(n,1).*Gt4(n,1)));
	end
	T1(ni*nj+1, 2) = G11;
	T1(ni*nj+1, 3) = G21;
	T2(ni*nj+1, 2) = G12;
	T2(ni*nj+1, 3) = G22;
	T3(ni*nj+1, 2) = G13;
	T3(ni*nj+1, 3) = G23;
	T4(ni*nj+1, 2) = G14;
	T4(ni*nj+1, 3) = G24;
	T5(ni*nj+1, 2) = G15;
	T5(ni*nj+1, 3) = G25;
else
	error('Wrong option number! Please retry.');
end
		
config_array=double(config_array);
dens_comp=double(ones(1,4));
dens_comp(1)=10.^(config_array(6)*1000*(1./(config_array(2)+273)-1./(config_array(1)+273))./2.3./8.313);
dens_comp(2)=10.^(config_array(6)*1000*(1./(config_array(3)+273)-1./(config_array(1)+273))./2.3./8.313);
dens_comp(3)=10.^(config_array(6)*1000*(1./(config_array(4)+273)-1./(config_array(1)+273))./2.3./8.313);
dens_comp(4)=10.^(config_array(6)*1000*(1./(config_array(5)+273)-1./(config_array(1)+273))./2.3./8.313);

%% convert data and make density correction (tandelta version)
Temp1(:,1)=log10(T1(:,1)); % transfers log omega
Temp1(:,2)=log10(T1(:,2)); % transfers log G'
Temp1(:,3)=log10(T1(:,3)); % transfers log G" [-]
Temp1(:,4)=(atan(T1(:,3)./T1(:,2)).*180./pi); % transfers delta


Temp2(:,1)=log10(T2(:,1)); % transfers log omega
Temp2(:,2)=log10(T2(:,2).*dens_comp(1)); % transfers log G'
Temp2(:,3)=log10(T2(:,3).*dens_comp(1)); % transfers log G" [-]
Temp2(:,4)=(atan(T2(:,3)./T2(:,2)).*180./pi); % transfers delta

Temp3(:,1)=log10(T3(:,1)); % transfers log omega
Temp3(:,2)=log10(T3(:,2).*dens_comp(2)); % transfers log G'
Temp3(:,3)=log10(T3(:,3).*dens_comp(2)); % transfers log G" [-]
Temp3(:,4)=(atan(T3(:,3)./T3(:,2)).*180./pi); % transfers delta

Temp4(:,1)=log10(T4(:,1)); % transfers log omega
Temp4(:,2)=log10(T4(:,2).*dens_comp(3)); % transfers log G'
Temp4(:,3)=log10(T4(:,3).*dens_comp(3)); % transfers log G" [-]
Temp4(:,4)=(atan(T4(:,3)./T4(:,2)).*180./pi); % transfers delta

Temp5(:,1)=log10(T5(:,1)); % transfers log omega
Temp5(:,2)=log10(T5(:,2).*dens_comp(4)); % transfers log G'
Temp5(:,3)=log10(T5(:,3).*dens_comp(4)); % transfers log G" [-]
Temp5(:,4)=(atan(T5(:,3)./T5(:,2)).*180./pi); % transfers delta

Gstern1=log10((10.^Temp1(:,2).^2+10.^Temp1(:,3).^2).^.5);% |G*|
Gstern2=log10((10.^Temp2(:,2).^2+10.^Temp2(:,3).^2).^.5);
Gstern3=log10((10.^Temp3(:,2).^2+10.^Temp3(:,3).^2).^.5);
Gstern4=log10((10.^Temp4(:,2).^2+10.^Temp4(:,3).^2).^.5);
Gstern5=log10((10.^Temp5(:,2).^2+10.^Temp5(:,3).^2).^.5);

%% make a polynomial fit of all quantities

% 1. G'
FitG1(1,:)=polyfit(Temp1(:,1),Temp1(:,2),poly_n); Temp1(:,5) = polyval(FitG1(1,:),Temp1(:,1));
FitG1(2,:)=polyfit(Temp2(:,1),Temp2(:,2),poly_n); Temp2(:,5) = polyval(FitG1(2,:),Temp2(:,1));
FitG1(3,:)=polyfit(Temp3(:,1),Temp3(:,2),poly_n); Temp3(:,5) = polyval(FitG1(3,:),Temp3(:,1));
FitG1(4,:)=polyfit(Temp4(:,1),Temp4(:,2),poly_n); Temp4(:,5) = polyval(FitG1(4,:),Temp4(:,1));
FitG1(5,:)=polyfit(Temp5(:,1),Temp5(:,2),poly_n); Temp5(:,5) = polyval(FitG1(5,:),Temp5(:,1));

% 2. G"
FitG2(1,:)=polyfit(Temp1(:,1),Temp1(:,3),poly_n); Temp1(:,6) = polyval(FitG2(1,:),Temp1(:,1));
FitG2(2,:)=polyfit(Temp2(:,1),Temp2(:,3),poly_n); Temp2(:,6) = polyval(FitG2(2,:),Temp2(:,1));
FitG2(3,:)=polyfit(Temp3(:,1),Temp3(:,3),poly_n); Temp3(:,6) = polyval(FitG2(3,:),Temp3(:,1));
FitG2(4,:)=polyfit(Temp4(:,1),Temp4(:,3),poly_n); Temp4(:,6) = polyval(FitG2(4,:),Temp4(:,1));
FitG2(5,:)=polyfit(Temp5(:,1),Temp5(:,3),poly_n); Temp5(:,6) = polyval(FitG2(5,:),Temp5(:,1));

% 3. delta
Fitdelta(1,:)=polyfit(Temp1(:,1),Temp1(:,4),poly_n); Temp1(:,7) = polyval(Fitdelta(1,:),Temp1(:,1));
Fitdelta(2,:)=polyfit(Temp2(:,1),Temp2(:,4),poly_n); Temp2(:,7) = polyval(Fitdelta(2,:),Temp2(:,1));
Fitdelta(3,:)=polyfit(Temp3(:,1),Temp3(:,4),poly_n); Temp3(:,7) = polyval(Fitdelta(3,:),Temp3(:,1));
Fitdelta(4,:)=polyfit(Temp4(:,1),Temp4(:,4),poly_n); Temp4(:,7) = polyval(Fitdelta(4,:),Temp4(:,1));
Fitdelta(5,:)=polyfit(Temp5(:,1),Temp5(:,4),poly_n); Temp5(:,7) = polyval(Fitdelta(5,:),Temp5(:,1));

%% shifting
% determining the number of points - length: return the maximum value of line# and row#
n1=length(Temp1);
n2=length(Temp2);
n3=length(Temp3);
n4=length(Temp4);
n5=length(Temp5);

%determining global minimum and max. for each quantity
minimaxarray=Temp1;%minimaxarray(1:n1,:)=Temp1;
minimaxarray(1+n1:n1+n2,:)=Temp2;
minimaxarray(1+n1+n2:n1+n2+n3,:)=Temp3;
minimaxarray(1+n1+n2+n3:n1+n2+n3+n4,:)=Temp4;
minimaxarray(1+n1+n2+n3+n4:n1+n2+n3+n4+n5,:)=Temp5;

minimaxG1(1)=min(minimaxarray(:,2));
minimaxG1(2)=max(minimaxarray(:,2));

minimaxG2(1)=min(minimaxarray(:,3));
minimaxG2(2)=max(minimaxarray(:,3));

minimaxd(1)=min(minimaxarray(:,4));
minimaxd(2)=max(minimaxarray(:,4));

minimaxomega(1)=min(minimaxarray(:,1))-.5;
minimaxomega(2)=max(minimaxarray(:,1))+.5;

n=100; %number of points at which Ea is determined
nn=n*10; %number of points at which Ea is determined from delta
G1Ea_y=linspace(minimaxG1(1),minimaxG1(2),n);
G2Ea_y=linspace(minimaxG2(1),minimaxG2(2),n);
deltaEa_y=linspace(minimaxd(1),minimaxd(2),nn);
p=zeros(1,5);%defines polynomial for evaluation
G1Ea_x=zeros(n,5);
G2Ea_x=zeros(n,5);
deltaEa_x=zeros(nn,5);

%determining shift factors for G1
for i=1:5
    for j=1:n
        p=FitG1(i,:);
        p(poly_n+1)=p(poly_n+1)-G1Ea_y(j);%modifies fit so that searched value is at zero
        z=roots(p);
        zl=length(z);
        for l=1:zl
            if (isreal(z(l))) && (z(l)> minimaxomega(1)) && (z(l)< minimaxomega(2)) %checks whether found zero is 1. real, 2. within the measured interval
                G1Ea_x(j,i)=real(z(l));
                l=zl;
            end
        end
        %clear z; clear zl
    end
end
%determining shift factors for G2
for i=1:5
    for j=1:n
        p=FitG2(i,:);
        p(poly_n+1)=p(poly_n+1)-G2Ea_y(j);%modifies fit so that searched value is at zero
        z=roots(p);
        zl=length(z);
        for l=1:zl
            if (isreal(z(l))) && (z(l)> minimaxomega(1)) && (z(l)< minimaxomega(2)) %checks whether found zero is 1. real, 2. within the measured interval
                G2Ea_x(j,i)=real(z(l));
                l=zl;
            end
        end
        %clear z; clear zl
    end
end

%determining shift factors for delta
for i=1:5
    for j=1:nn
        p=Fitdelta(i,:);
        p(poly_n+1)=p(poly_n+1)-deltaEa_y(j);%modifies fit so that searched value is at zero
        z=roots(p);
        zl=length(z);
        for l=1:zl
            if (isreal(z(l))) && (z(l)> minimaxomega(1)) && (z(l)< minimaxomega(2)) %checks whether found zero is 1. real, 2. within the measured interval
                deltaEa_x(j,i)=real(z(l));
                l=zl;
            end
        end
        %clear z; clear zl
    end
end

%%plot of the data
% defining legend
s1=[num2str(config_array(1)), '^oC'];
s2=[num2str(config_array(2)), '^oC'];
s3=[num2str(config_array(3)), '^oC'];
s4=[num2str(config_array(4)), '^oC'];
s5=[num2str(config_array(5)), '^oC'];
s6=['fit ', num2str(config_array(1)), '^oC'];
s7=['fit ', num2str(config_array(2)), '^oC'];
s8=['fit ', num2str(config_array(3)), '^oC'];
s9=['fit ', num2str(config_array(4)), '^oC'];
s10=['fit ', num2str(config_array(5)), '^oC'];
t1=[name_data ' G''-data'];
t2=[name_data ' G"-data'];
t3=[name_data ' \delta-data'];
t4=[name_data ' Arrhenius plots from G'''];
t5=[name_data ' Arrhenius plots from G"'];
t6=[name_data ' Arrhenius plots from \delta'];
t7=[name_data ' E_a as a function of G'', G"'];
t8=[name_data ' E_a as a function of \delta'];
t9=[name_data ' vanGurp-Palmen plot'];
t10=[name_data ' Fitting Ea-delta curve'];

%plot G'
hold on
figure(1);
whitebg('w');
plot(Temp1(:,1), Temp1(:,2),'x', Temp2(:,1), Temp2(:,2),'s', Temp3(:,1), Temp3(:,2),'d', Temp4(:,1), Temp4(:,2),'+', Temp5(:,1), Temp5(:,2),'o',Temp1(:,1), Temp1(:,5),'-', Temp2(:,1), Temp2(:,5),'-', Temp3(:,1), Temp3(:,5),'-', Temp4(:,1), Temp4(:,5),'-', Temp5(:,1), Temp5(:,5),'-');%,G1Ea_x(:,1),G1Ea_y,'o',G1Ea_x(:,2),G1Ea_y,'x',G1Ea_x(:,3),G1Ea_y,'d',G1Ea_x(:,4),G1Ea_y,'s',G1Ea_x(:,5),G1Ea_y,'*')
xlabel('log \omega [-]','FontSize',18)%x-axis label
ylabel('log G''[-]','FontSize',18)%y-axis label
legend(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10,'Location','southeast')%, 1)
orient landscape
title(t1,'FontSize',18);
print ('-dpdf', [name_data '-G1'])

saveas(figure(1), [name_data '-G1.fig'])

%plot G"
hold on
figure(2);
whitebg('w');
plot(Temp1(:,1), Temp1(:,3),'x', Temp2(:,1), Temp2(:,3),'s', Temp3(:,1), Temp3(:,3),'d', Temp4(:,1), Temp4(:,3),'+', Temp5(:,1), Temp5(:,3),'o',Temp1(:,1), Temp1(:,6),'-', Temp2(:,1), Temp2(:,6),'-', Temp3(:,1), Temp3(:,6),'-', Temp4(:,1), Temp4(:,6),'-', Temp5(:,1), Temp5(:,6),'-');%, G2Ea_x(:,1),G2Ea_y,'o',G2Ea_x(:,2),G2Ea_y,'x',G2Ea_x(:,3),G2Ea_y,'d',G2Ea_x(:,4),G2Ea_y,'s',G2Ea_x(:,5),G2Ea_y,'*')
xlabel('log \omega [-]','FontSize',18)%x-axis label
ylabel('log G" [-]','FontSize',18)%y-axis label
legend(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10,'Location','southeast')%, 1)
orient landscape
title(t2,'FontSize',18);
print ('-dpdf', [name_data '-G2'])
saveas(figure(2), [name_data '-G2.fig'])

%plot delta
hold on
figure(3);
whitebg('w');
plot(Temp1(:,1), Temp1(:,4),'x', Temp2(:,1), Temp2(:,4),'s', Temp3(:,1), Temp3(:,4),'d', Temp4(:,1), Temp4(:,4),'+', Temp5(:,1), Temp5(:,4),'o',Temp1(:,1), Temp1(:,7),'-', Temp2(:,1), Temp2(:,7),'-', Temp3(:,1), Temp3(:,7),'-', Temp4(:,1), Temp4(:,7),'-', Temp5(:,1), Temp5(:,7),'-');%, deltaEa_x(:,1),deltaEa_y,'o',deltaEa_x(:,2),deltaEa_y,'x',deltaEa_x(:,3),deltaEa_y,'d',deltaEa_x(:,4),deltaEa_y,'s',deltaEa_x(:,5),deltaEa_y,'*')
xlabel('log \omega [-]','FontSize',18)%x-axis label
ylabel('\delta [^o]','FontSize',18)%y-axis label
legend(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10)%, 1)
orient landscape
title(t3,'FontSize',18);
print ('-dpdf', [name_data '-delta'])
saveas(figure(3), [name_data '-delta.fig'])

tempx=0;
tempy=0;
G1Ea=zeros(n,6);%results vector
G2Ea=zeros(n,6);%results vector
deltaEa=zeros(nn,6);%results vector

%plot shift factors G1 and calculate Ea
Temp=double(config_array(1:5)); % Temperature
Temp=1000./(Temp+273);			% Inverse of temperature
figure(4);
hold on
whitebg('w');
%creates an array with the temperatures to check and another one with the
%temperatues
Tarray=[1 1 1 1; 1 2 3 4; 1 2 3 5; 1 2 4 5; 1 3 4 5; 2 3 4 5];% first line is a dummy line

for i=1:4
    for j=2:6
        Tarray2(j,i)=Temp(Tarray(j,i));
    end
end
for i=1:n
    if all(G1Ea_x(i,:))

            plot(Temp, G1Ea_x(i,:),'x-')

        G1Eatemp=polyfit(Temp, G1Ea_x(i,:),1);
        G1Ea(i,1)=G1Eatemp(1);
    else
        counter=1;
        for j=1:5
            if all(G1Ea_x(i,j))
                tempy(counter)=G1Ea_x(i,j);
                tempx(counter)=Temp(1,j);
                counter=counter+1;
            end
        end

            plot(tempx, tempy,'ro-')
 
        tempx=0;
        tempy=0;
        %         [G1Ea(i,:)]=polyfit(tempx, tempy,1);
    end
    for j=2:6
        if all(G1Ea_x(i,Tarray(j,:)))
            G1Eatemp=polyfit(Tarray2(j,:), G1Ea_x(i,Tarray(j,:)),1);
            G1Ea(i,j)=G1Eatemp(1);
        end
    end
    
    %   G1Ea(i,2)=c(2,1);
end
xlabel('1000/T [1/K]','FontSize',18)%x-axis label
ylabel('log \omega [-]','FontSize',18)%y-axis label
title(t4,'FontSize',18);
orient landscape
print ('-dpdf', [name_data '-ArrheniusG1'])
saveas(figure(4), [name_data '-ArrheniusG1.fig'])

%plot shift factors G2 and calculate Ea
figure(5);
hold on
whitebg('w');
for i=1:n
    if all(G2Ea_x(i,:))
            plot(Temp, G2Ea_x(i,:),'x-')

        G2Eatemp=polyfit(Temp, G2Ea_x(i,:),1);
        G2Ea(i,1)=G2Eatemp(1);
    else
        counter=1;
        for j=1:5
            if all(G2Ea_x(i,j))
                tempy(counter)=G2Ea_x(i,j);
                tempx(counter)=Temp(1,j);
                counter=counter+1;
            end
        end

            plot(tempx, tempy,'ro-')

        tempx=0;
        tempy=0;
        %         [G1Ea(i,:)]=polyfit(tempx, tempy,1);
    end
    for j=2:6
        if all(G2Ea_x(i,Tarray(j,:)))
            G2Eatemp=polyfit(Tarray2(j,:), G2Ea_x(i,Tarray(j,:)),1);
            G2Ea(i,j)=G2Eatemp(1);
        end
    end
    
    %   G1Ea(i,2)=c(2,1);
end
xlabel('1000/T [1/K]','FontSize',18)%x-axis label
ylabel('log \omega [-]','FontSize',18)%y-axis label
title(t5,'FontSize',18);
orient landscape
print ('-dpdf', [name_data '-ArrheniusG2'])
saveas(figure(5), [name_data '-ArrheniusG2.fig'])

%plot shift factors delta and calculate Ea
figure(6);
hold on
whitebg('w');
for i=1:nn
    if all(deltaEa_x(i,:))
        if mod(i,10)==0
            plot(Temp, deltaEa_x(i,:),'x-')
        end
        deltaEatemp=polyfit(Temp, deltaEa_x(i,:),1);
        deltaEa(i,1)=deltaEatemp(1);
    else
        counter=0;
        for j=1:5
            if all(deltaEa_x(i,j))
                counter=counter+1;
                tempy(counter)=deltaEa_x(i,j);
                tempx(counter)=Temp(1,j);
                
            end
        end
        if mod(i,10)==0
            if all(tempx)
            plot(tempx, tempy,'ro-')
            end
        end
        tempx=0;
        tempy=0;
        % [G1Ea(i,:)]=polyfit(tempx, tempy,1);
    end
    for j=2:6
        if all(deltaEa_x(i,Tarray(j,:)))
            deltaEatemp=polyfit(Tarray2(j,:), deltaEa_x(i,Tarray(j,:)),1);
            deltaEa(i,j)=deltaEatemp(1);
        end
    end
    
    % G1Ea(i,2)=c(2,1);
end

maxarray=ones(1,3); %defines the array for the characteristic delta % Modified by WW

xlabel('1000/T [1/K]','FontSize',18)%x-axis label
ylabel('log \omega [-]','FontSize',18)%y-axis label
title(t6,'FontSize',18);
orient landscape
print ('-dpdf', [name_data '-Arrheniusdelta'])
saveas(figure(6), [name_data '-Arrheniusdelta.fig'])


%% plot Ea
G1Ea=abs(G1Ea.*2.3*8.3);
%G1Ea(:,2)=abs(G1Ea(:,2).*2.3*8.3);
G2Ea=abs(G2Ea.*2.3*8.3);
%G2Ea(:,2)=abs(G2Ea(:,2).*2.3*8.3);
deltaEa=-deltaEa.*2.3*8.3;
G1_x=10.^(G1Ea_y-1);
G2_x=10.^(G2Ea_y-1);

%calculates average value of Ea from G', G", and delta - after eliminating
%zero values
for i=1:n
    counter=1;
    for j=1:5
        if all(G1Ea(i,j))
            tempy(counter)=G1Ea(i,j);
            counter=counter+1;
        end
    end
    G1Ea(i,6)=mean(tempy);
    G1Ea(i,7)=std(tempy);
    tempy=0;
end

for i=1:n
    counter=1;
    for j=1:5
        if all(G2Ea(i,j))
            tempy(counter)=G2Ea(i,j);
            counter=counter+1;
        end
    end
    G2Ea(i,6)=mean(tempy);
    G2Ea(i,7)=std(tempy);
    tempy=0;
end

% for i=1:nn
%     counter=1;
%     for j=1:5
%         if all(deltaEa(i,j))
%             tempy(counter)=deltaEa(i,j);
%             counter=counter+1;
%         end
%     end
%     deltaEa(i,6)=mean(tempy);
%     deltaEa(i,7)=std(tempy);
%     tempy=0;
% end

for i=1:nn
    counter=0;
    for j=1:5
        if all(deltaEa(i,j))
            counter=counter+1;
            tempy(counter)=deltaEa(i,j);
        end
    end
    deltaEa(i,6)=mean(tempy);
    deltaEa(i,7)=std(tempy);
    tempy=0;
end

%% preparing files to save and results to plot
G1_x=[G1_x' G1Ea(:,6:7)];
G2_x=[G2_x' G2Ea(:,6:7)];
delta_x=[deltaEa_y' deltaEa(:,6:7)];
G1=zeros(3);
G2=zeros(3);
delta=zeros(3);
counter=1;
for i=1:n
    if all(G1_x(i,2))
        G1(counter,:)=G1_x(i,:);
        counter=counter+1;
    end
end
counter=1;
for i=1:n
    if all(G2_x(i,2))
        G2(counter,:)=G2_x(i,:);
        counter=counter+1;
    end
end

counter=1;
for i=1:nn
    if all(delta_x(i,2))
        delta(counter,:)=delta_x(i,:);
        counter=counter+1;
    end
end
plateauarray=ones(3,2);
cutoff = 25; % WW add
[maxarray(1,1),maxarray(1,3)]=max(delta(1:end,2));%max(delta(:,2));%determines max. Ea for delta, maxarray(1,1) - Value, maxarray(1,2) - Index
temp1=delta(2,1)-delta(1,1);
temp1=int32(round(10./temp1)+maxarray(1,2));
if temp1>length(delta)% check whether the delta array is not exceeded.
    temp1=length(delta);
end
plateau=mean(delta(temp1:end,2));
plateauarray(1,1)=delta(1,1);
plateauarray(2,1)=delta(temp1,1);
plateauarray(3,1)=delta(end,1);
plateauarray(:,2)=plateau;
plateau=maxarray(1,1)-plateau;
maxarray(1,2)=delta(maxarray(1,3),1);%determines delta position of max. Ea for delta. Now maxarray(1,2) is delta value.

figure(7);
hold on
whitebg('w');
% errorbar(G1_x,G1Ea(:,1),G1Ea(:,2),'bo')
% errorbar(G2_x,G2Ea(:,1),G2Ea(:,2),'rs')
errorbar(G1(:,1),G1(:,2),G1(:,3),'bo')
errorbar(G2(:,1),G2(:,2),G2(:,3),'rx')
set(gca,'xscale','log'); %sets x-axis to log
xlabel('G'', G" [Pa]','FontSize',18)%x-axis label
ylabel('E_a [kJ/mol]','FontSize',18)%y-axis label
title(t7,'FontSize',18);
orient landscape
print ('-dpdf', [name_data '-EaG1G2'])
saveas(figure(7), [name_data '-EaG1G2.fig'])

deltaPC1=num2str(maxarray(1,2),4);%converts characteristic values
deltaPC2=num2str(maxarray(1,1),4);

t10=['char. \delta=' deltaPC1 '^o, ' deltaPC2 ' kJ/mol'];
t11=['\Delta\delta=' num2str(plateau,4) '^o'];

plateau=num2str(plateau,4);

%t10=datestr(now, 30);%create timestamp

hold on
figure(8);
whitebg('w');
plot(Gstern1, Temp1(:,4),'x-', Gstern2, Temp2(:,4),'s-', Gstern3, Temp3(:,4),'d-', Gstern4, Temp4(:,4),'+-', Gstern5, Temp5(:,4),'o-');%,G1Ea_x(:,1),G1Ea_y,'o',G1Ea_x(:,2),G1Ea_y,'x',G1Ea_x(:,3),G1Ea_y,'d',G1Ea_x(:,4),G1Ea_y,'s',G1Ea_x(:,5),G1Ea_y,'*')
xlabel('log |G*| [-]','FontSize',18)%x-axis label
ylabel('\delta [^o]','FontSize',18)%y-axis label
legend(s1,s2,s3,s4,s5)%, 3)
orient landscape
title(t9,'FontSize',18);
print ('-dpdf', [name_data 'vGP'])

saveas(figure(8), [name_data 'vGP.fig'])

% WW Add
Ea_max = maxarray(1,1);
Err_ave = 0.0; % Average value of error
delta_max = maxarray(1,2);
%cutoff = 25; % Remove the first and the last cutoff number of values
delta_st = delta(cutoff+1,1); %delta(0,1)
delta_ed = delta(end-cutoff,1); %delta(end,1)
Rname=["delta_c"; "omega_c"; "E_a,max"; "Molar Mass(Mw)"; "Zero-shear viscosity(eta0)"; "Branching Index"; "dG"; "ddelta"; "Half-width"; "Area"];
Runit=[" degree"; " rad/s"; " kJ/mol"; " kg/mol"; " Pa s"; " LCB / 10000 monomers"; " Pa"; " degree"; " degree"; " degree kJ/mol"];
Results = zeros(10,1);
Results(1,1) = delta_max;
disp(['deltac is: ', num2str(delta_max),' degree']);

% Calculate the average error value 
if(delta_max > delta(cutoff+1, 1) && delta_max < delta(end-cutoff, 1)) %(delta_max >= 45.0 && plat > 28.0)
	c0 = 0.5; % Threshold fraction of curve used for the fitting procedure, can be modified
	Ea_thre = 28.0 + c0 * (Ea_max - 28.0);
	Ea_max_id = maxarray(1,3);
	counter1 = 1;
	counter2 = 1;

	for i=Ea_max_id:-1:1
		if (delta(i,2) > Ea_thre)
			counter1=counter1+1;
		else
			break;
		end
	end

	for i=Ea_max_id:length(delta)
		if (delta(i,2) > Ea_thre)
			counter2=counter2+1;
		else
			break;
		end
    end
    
    if(cutoff + counter1 < Ea_max_id && Ea_max_id + cutoff + counter2 < nn)
        Err_ave = Err_ave + 0.5 * mean(delta(cutoff+1:Ea_max_id-counter1,3));
        Err_ave = Err_ave + 0.5 * mean(delta(Ea_max_id+counter2:end-cutoff,3));
    end
else
    Err_ave = Err_ave + mean(delta(cutoff+1:end-cutoff,3));
end
    
disp(['The average error is: ', num2str(Err_ave, 4), ' degree, please check the liability of the data.']);

% WW - determining characteristic omega (1/lambda2)
%q=zeros(1,5); % q = G1 - G2;
q=FitG1(1,:) - FitG2(1,:);
omega = roots(q);
omegal=length(omega);
for l=1:omegal
    if (isreal(omega(l))) && (omega(l)> minimaxomega(1)) && (z(l)< minimaxomega(2)) %checks whether found zero is 1. real, 2. within the measured interval
        omegac=real(omega(l));
        l=omegal;
    end
end

omegac = 10.^omegac;
Results(2,1) = omegac;
Results(3,1) = Ea_max;

disp(['omegac is: ', num2str(omegac), ' rad/s']);

Mw = (1.883*1e9/omegac).^(1.0/3.6); % kg / mol
disp(['The predicted Mw is: ', num2str(Mw, 4), 'kg/mol, please verify.']);
Mflag = input('Do you want to input new value of Mw? 1. Yes 2. No: ')
if(Mflag == 1)
	Mw = input('Enter new Mw (in kg/mol): ');
elseif(Mflag == 2)
	Mw = (1.883*1e9/omegac).^(1.0/3.6);
else
	error('Wrong option number! Please retry.');
end

eta0 = 0.0; eta0_lin = 0.0; eta_r = 0.0;
bidx = 0.0;
%plat = plateauarray(1,2);

if (delta_max >= 45.0)% && plat > 28.0)	
	% Zero-shear viscosity for linear polymers eta0 = A*Mw^3.6
	eta0_lin = (9e-15).*(Mw.*1000).^3.6;
	
	eta_r = 10.^((90.0 - delta_max) / 34.02);
	eta0 = eta_r .* eta0_lin;
	disp(['The predicted zero-shear viscosity is: ', num2str(eta0, 4), ' Pa s']);
	disp('Please check Fig.8 and Fig.9 for the values above.');
	
	% The branching index lambda
	bidx = (75.0 - delta_max) .* 1e4 / (Mw .* 540.0);
	disp(['The brancing index is: ', num2str(bidx, 4), ' LCB / 10000 monomers']);
else
	disp('Critical value of delta is less than 45 degree, cannot proceed!');
    if(delta_max < 30)% || plat <= 28.0)
        disp('The sample is considered to be linear.');
		eta0 = eta0_lin; 
	end
end

Results(4,1) = Mw;
Results(5,1) = eta0;
Results(6,1) = bidx;

% WW - Calculate the delta_delta and delta_G
% Calculate w for delta(w, 150) = delta_max
p=Fitdelta(1,:);
p(poly_n+1)=p(poly_n+1)-delta_max;%modifies fit so that searched value is at zero
z=roots(p);
zl=length(z);
for l=1:zl
    if (isreal(z(l))) && (z(l)> minimaxomega(1)) && (z(l)< minimaxomega(2)) %checks whether found zero is 1. real, 2. within the measured interval
        omega1=real(z(l));
        l=zl;
    end
end

% Calculate |G*| at w for delta(w, 150) = delta_max
G1_1 = polyval(FitG1(1,:), omega1);
G2_1 = polyval(FitG2(1,:), omega1);
Gstern1_1 = log10((10.^G1_1.^2+10.^G2_1.^2).^.5);

% Calculate w for delta(w, 230) = delta_max
p=Fitdelta(5,:);
p(poly_n+1)=p(poly_n+1)-delta_max;%modifies fit so that searched value is at zero
z=roots(p);
zl=length(z);
for l=1:zl
    if (isreal(z(l))) && (z(l)> minimaxomega(1)) && (z(l)< minimaxomega(2)) %checks whether found zero is 1. real, 2. within the measured interval
        omega2=real(z(l));
        l=zl;
    end
end

% Calculate |G*| at w for delta(w, 230) = delta_max
G1_2 = polyval(FitG1(5,:), omega2);
G2_2 = polyval(FitG2(5,:), omega2);
Gstern1_2 = log10((10.^G1_2.^2+10.^G2_2.^2).^.5);

dG = Gstern1_2 - Gstern1_1;

disp(['dG is: ', num2str(dG)]);

% Calculate delta at |G*|(w, T = 230) = |G*|(w, T = 150)
FitvGP=polyfit(Gstern5,Temp5(:,4),poly_n); delta2 = polyval(FitvGP, Gstern1_1);

ddelta = delta2 - delta_max;
disp(['ddelta is: ', num2str(ddelta)]);

Results(7,1) = dG;
Results(8,1) = ddelta;

%%half width calculations
HW = 0.0;
Area = 0.0;

if(delta_max > delta(1,1) && delta_max < delta(end,1)) %(delta_max >= 45.0 && plat > 28.0)
	c0 = 0.7; % Threshold fraction of curve used for the fitting procedure, can be modified
	Ea_thre = 28.0 + c0 * (Ea_max - 28.0);
	Ea_max_id = maxarray(1,3);
	counter1 = 1;
	counter2 = 1;

	for i=Ea_max_id:-1:1
		if (delta(i,2) > Ea_thre)
			counter1=counter1+1;
		else
			break;
		end
	end

	for i=Ea_max_id:nn
		if (delta(i,2) > Ea_thre)
			counter2=counter2+1;
		else
			break;
		end
	end
	% Data used for fitting
	delta_fit = delta(Ea_max_id-counter1:Ea_max_id+counter2, :);

	% WW - Calculate the Area
	% pA(1) - A, pA(2) - xc, pA(3) - w1, pA(4) - w2, pA(5) - w3;
	FuncA = @(pA, x) 28.0 + pA(1).*(1./(1+exp(-(x-pA(2)+0.5*pA(3))./pA(4)))).*(1-1./(1+exp(-(x-pA(2)-0.5*pA(3))./pA(5))));
	%p0min=[0 0 0 0 0];
	%p0max=[1 1 1 1 1];
	options=optimset('LargeScale','on','Display','off');%,'TolX',1e-10,'TolFun',1e-10,'MaxIter',2000,'MaxFunEvals',2000);
	pA0=[Ea_max delta_max 1.0 1.0 1.0];
	pA=pA0;
	pA=lsqcurvefit(FuncA, pA, delta_fit(:,1)', delta_fit(:,2)', [], [], options);
	
	yl = 28.0 + pA(1).*(1./(1+exp(-(delta_st-pA(2)+0.5*pA(3))./pA(4)))).*(1-1./(1+exp(-(delta_st-pA(2)-0.5*pA(3))./pA(5))));
	yr = 28.0 + pA(1).*(1./(1+exp(-(delta_ed-pA(2)+0.5*pA(3))./pA(4)))).*(1-1./(1+exp(-(delta_ed-pA(2)-0.5*pA(3))./pA(5))));
	if(abs(yl - Ea_max) < 1e-6)
		pA0=[Ea_max 0.6*delta_max 1.0 1.0 1.0];
		pA=pA0;
		pA=lsqcurvefit(FuncA, pA, delta_fit(:,1)', delta_fit(:,2)', [], [], options);
	end
	
	if(abs(yr - Ea_max) < 1e-6)
		pA0=[Ea_max delta_max*1.2 1.0 1.0 1.0];
		pA=pA0;
		pA=lsqcurvefit(FuncA, pA, delta_fit(:,1)', delta_fit(:,2)', [], [], options);
	end
	
	syms x;
	FuncA_int = @(x) pA(1).*(1./(1+exp(-(x-pA(2)+0.5*pA(3))./pA(4)))).*(1-1./(1+exp(-(x-pA(2)-0.5*pA(3))./pA(5))))-0.5.*(Ea_max-28.0);
	y = FuncA_int(delta(:,1))+28.0+0.5.*(Ea_max-28.0);
	
    Ea_max_fit = 0.0;
    Ea_max_id_fit = 0;
    Ea_fit_len = length(delta_fit(:,1));
	[Ea_max_fit, Ea_max_id_fit] = max(y);
    Ea_thre = 28.0 + 0.5 * (Ea_max_fit - 28.0);
    peak(1,1)=delta(1,1);
    peak(2,1)=delta(end,1);
    peak(:,2)=Ea_thre;
	counter1 = 1;
	counter2 = 1;

	for i=Ea_max_id_fit:-1:1
		if (y(i) > Ea_thre)
			counter1=counter1+1;
		else
			break;
		end
	end

	for i=Ea_max_id_fit:length(y)
		if (y(i) > Ea_thre)
			counter2=counter2+1;
		else
			break;
		end
	end
    
	if(Ea_max_id_fit - counter1 > 1)
		id1 = Ea_max_id_fit - counter1;
	else
		id1 = 1;
	end
	
	if(Ea_max_id_fit + counter2 < length(y))
		id2 = Ea_max_id_fit + counter2;
	else
		id2 = length(y);
	end
	
    x1 = [delta_st delta_max];
	r1 = fzero(FuncA_int, x1);
	x2 = [delta_max 90.0];
	r2 = fzero(FuncA_int, x2);
    % The half width (HW)
	HW = r2 - r1;
	disp(['The Half-width is: ', num2str(HW, 4), ' degree']);
	% The Area 
	Area = int(FuncA_int, x, r1, r2);
	Area = double(Area);
	disp(['The Area is: ', num2str(Area, 4), ' degree kJ / mol']);
	disp('Please check Fig.8 for the fitting quanlity. If the fitting failed as the fraction of curve is not the peak region, please reset c0 for a larger value.');
	
    figure(9);
    hold on
    whitebg('w');
    errorbar(delta(cutoff+1:end-cutoff,1),delta(cutoff+1:end-cutoff,2),delta(cutoff+1:end-cutoff,3),'bo')
    %plot(delta(cutoff+1:end-cutoff,1),delta(cutoff+1:end-cutoff,2),'o')
	plot(maxarray(1,2),maxarray(1,1),'--rs','LineWidth',2,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','g',...
                    'MarkerSize',10)
    text(maxarray(1,2), maxarray(1,1)+2, t10, 'horizontalAlignment', 'center')
    %text(maxarray(1,2), plateauarray(1,2)-2, t11, 'horizontalAlignment', 'center')
    plot(peak(:,1),peak(:,2),'k--')
    %plot(plateauarray(2:3,1),plateauarray(2:3,2),'r-', 'LineWidth',2)
   
	%plot(delta_fit(Ea_max_id_fit - 15:Ea_max_id_fit + 15,1), delta_fit(Ea_max_id_fit - 15:Ea_max_id_fit + 15,2), 'x')
	plot(delta(id1:id2,1), y(id1:id2), 'r-', 'LineWidth', 2)
    xlabel('\delta [^o]','FontSize',18)%x-axis label
    ylabel('E_a [kJ/mol]','FontSize',18)%y-axis label
    title(t8,'FontSize',18);
    orient landscape
    print ('-dpdf', [name_data '-Eadelta'])
    saveas(figure(9), [name_data '-Eadelta.fig'])

end

Results(9,1) = HW;
Results(10,1) = Area;

savearray(totalcounter,:)={deltaPC1 deltaPC2 plateau Results(1,1) Results(2,1) Results(3,1) Results(4,1) Results(5,1) Results(6,1) Results(7,1) Results(8,1) Results(9,1) name_data};%saves char. point in array
totalcounter=totalcounter+1;

save([name_data '-EaG1.txt'],'G1','-ascii');%saves G1 Ea-data
save([name_data '-EaG2.txt'],'G2','-ascii');%saves G2 Ea-data
save([name_data '-Eadelta.txt'],'delta','-ascii');%saves delta Ea-data
save([name_data '-OriginData.txt'], 'T1', 'T2', 'T3', 'T4', 'T5', '-ascii');
%save([name_data '-Results.txt'],'Rname', 'Results','-ascii');%saves G1 Ea-data
% WW Add
Result_name = [name_data '-Results.txt'];
Result_id = fopen(Result_name,'wt');
for i=1:10
	fprintf(Result_id,'%-28s%.4f%s\n', Rname(i,1), Results(i,1), Runit(i,1));
end
fclose(Result_id);
%save([t10 '-deltapc.txt'],'savearray','-ascii', '-tabs'); 
% 
clear path_name file_name flag tflag Mflag
clear temp1 plateau plateauarray t11
clear FitG1         T    nn         Temp5         minimaxG2     s10    t10       t4 a
clear FitG2     deltaPC2 deltaPC1 maxarray               ans           minimaxarray  s2      t9      t5
clear Fitdelta                 minimaxd      s3            t6
clear G1            counter            delta         minimaxomega  s4            t7
clear G1Ea                            n             s5            t8
clear G1Ea_x   G1_x   G2_x     delta_x              n1            s6            tempx
clear G1Ea_y                deltaEa_y     n2            s7
clear G1Eatemp             deltaEatemp   n3            s8            z
clear G2                      dens_comp     n4            s9            zl
clear G2Ea          Temp1         i             n5            t
clear G2Ea_x        Temp2         j             name_data     t1
clear G2Ea_y        Temp3         l             p             t2
clear G2Eatemp      Temp4         minimaxG1     s1            t3
clear Gstern1 Gstern2 Gstern3 Gstern4 Gstern5
clear tempy deltaEa Temp deltaEa_x Tarray Tarray2
clear ni nj ng w0 wn
clear G11 G12 G13 G14 G15 G21 G22 G23 G24 G25
clear Ea_max Err_ave cutoff delta_max delta_st delta_ed 
clear q omega omegal omega1 omega2 omegac 
clear Mw eta0_lin eta_r eta0 bidx plat
clear G1_1 G2_1 Gstern1_1
clear G1_2 G2_2 Gstern1_2
clear dG FitvGP delta2 ddelta
clear c0 Ea_thre Ea_max_id counter1 counter2
clear delta_fit FuncA options pA0 pA
clear x FuncA_int x1 r1 x2 r2 y yl yr id1 id2
clear Ea_max_fit Ea_fit_len Ea_max_id_fit peak HW Area
clear Result_id Result_name Rname Runit Results 
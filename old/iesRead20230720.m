% ���������� ��� �� �����.
% ����� �������� ��� ���������� ���� ������ ��� ���������������� (����
% ������������ ����) � �������������� (������������ ���� ������ � ��������� 0-360) �������������.

close all
clear all
clc


files = dir; %��� ����� �����������
filename = 'Elliptical.ies';
Ireaded = struct(); % ��� �������� ������ �������� ����� ����� ��������� � �������� ������. ������������ ������ ��������� ������������ (��� ���) ��� ���������������.
file = textread(deblank(filename), '%s', 'delimiter', '\n');

[m, n] = size(file); %���� ���������� ����� � �����
i = 1; %����� ������
str = cell2mat(strread(file{i,1}, '%s','whitespace', '')); %���������� ������
i = i+1;
while (~strncmp(str, 'TILT', 4)) %���������� ��� ������ � ������� �� ������ ������ ����� ���� ������
    str = cell2mat(strread(file{i,1}, '%s','whitespace', ''));
    i = i+1;
end
str = strread(file{i,1}); %��������� ������ � ����������� ����������� � ���
i = i+1; %��������� ������
Fies = str(2); % �������� �����, ��������� � �����
M = str(3); %���������
P = str(4); %���������� �������� �����
A = str(5); %���������� ������������ �����
Ireaded.F = str(2); Ireaded.m = str(3); Ireaded.P = str(4); Ireaded.A = str(5); 
str = strread(file{i,1}); %��������� ������ � ��������� �����������
power = str(3); %�������� �����������
Ireaded.power = str(3);
i = i+1; %��������� ������


%% ���� ��� ���������� �������� �����
angleP = 0;
cause = 1; %���� ��� ������ while
while (cause) %���� ��� ���������� �������� �����
    str = str2num(file{i,1}); %��������� ������ ������ �������� �����
    if (angleP == 0)
        angleP = str; %������ ������ ������ �����
    else
        angleP(length(angleP)+1:length(angleP)+length(str)) = str(1:end); % ������ ����������� ����� �����, ���� ��� � ies ����� �� ���������� �� ����� ������
    end
    i = i+1;
    if (length(angleP) == P) %���� ���������� ��������� �������� ����� ����� �������� �����, �� ��������� ����
        cause = 0;
    end
end
anglePorig = angleP;
Ireaded.angleP = angleP;

%% ���� ���������� ������������ �����. ���������� �������� �����
angleA = 0;
cause = 1;
while (cause)
    str = str2num(file{i,1}); %��������� ������������ ����
    if (angleA == 0)
        angleA = str;
    else
        angleA(length(angleA)+1:length(angleA)+length(str)) = str(1:end); % ������ ����������� ����� �����, ���� ��� � ies ����� �� ���������� �� ����� ������
    end
    i = i+1;
    if (length(angleA) == A)
        cause = 0;
    end
end
angleAorig = angleA;
Ireaded.angleA = angleA;

%% ���� ���������� �������� ��� �����. ���������� ���������� �����
stroka = 1; %����� ����������� ������
j = 1; %������� ������������ ����� ��� ���������� ��� �����
I(1:A, 1:P) = 0;
for i=i:m
    str = str2num(file{i,1}); %��������� ���� �����
    if (stroka == 1)
        I(j,1:length(str)) = M*str;
        Imark = str; %������ ��� ����������� ����� �����
    else
        I(j,length(Imark)+1:length(Imark)+length(str)) = M*str(1:end);
        Imark(length(Imark)+1:length(Imark)+length(str)) = str(1:end);
    end
    stroka = stroka+1;
    if (length(Imark) == P)
        j = j+1;
        stroka = 1;
    end
    if (j == A+1)
        break;
    end;
end
Ireaded.I = I;

%% ���������� ����������� ������������ �����, ���� ��� ��������������� � ����� ������������ ����� 0 ��������
if (A == 1) %���� �������� ��������������� (���� �������� ����), �������� ��� � �������� ����� 0-90 ��������
    for i=1:90+1
        angleA(i) = 0 + (i-1);
        I(i,:) = I(1,:);
    end
    A = length(angleA);
end;

%% ���������������� ���
% ���� ��� ������ ����� 4 ������������� ������, �� ������������ ��������
% ����� �������. ������� ����������� ���������������� ������������. ����
% ����� ��������� ���������������.
% ���������, ��� � ������ �������, ����� ������ � ������, ��� ���� ����
% ����� (��������) ��� ������������ ���������� � ��������
if (length(angleA) == 5)
    if(sum(angleA == 0:90:360) == 5)
        disp('!!��������!!! �������� ��� ������������ ������ � ���� ����������. ��� ����������������� ������ ��������� ������������ ����� ������������!');
    end;
end;
step = (A-1)/ceil((A-1)/20);
[X, Y] = meshgrid(0:(angleP(end))/(P-1):angleP(end), angleA(1):(angleA(end)-angleA(1))/(A-1):angleA(end)); % �������������� ����� � ies �����
[Xi, Yi] = meshgrid(0:1:angleP(end), angleA(1):step:angleA(end));
angleP = 0:1:angleP(end);
Ii1 = interp2(X, Y, I, Xi, Yi, 'linear');
maxIi = max(max(Ii1));
for i=1:length(Ii1(:,1))
    for j=1:length(Ii1(1,:))
        if (Ii1(i,j) < 0.005*maxIi)
            Ii1(i,j) = 0;
        end;
    end
end;

X = Xi; Y = Yi;
step2 = (A-1)/ceil((A-1)/10);
[Xi, Yi] = meshgrid(0:1:angleP(end), angleA(1):step2:angleA(end));
angleP = 0:1:angleP(end);
Ii2 = interp2(X, Y, Ii1, Xi, Yi, 'cubic');
maxIi2 = max(max(Ii2));
for i=1:length(Ii2(:,1))
    for j=1:length(Ii2(1,:))
        if (Ii2(i,j) < 0.005*maxIi2)
            Ii2(i,j) = 0;
        end;
    end
end;

X = Xi; Y = Yi;
step3 = 1;
[Xi, Yi] = meshgrid(0:1:angleP(end), angleA(1):step3:angleA(end));
angleP = 0:1:angleP(end);
Ii3 = interp2(X, Y, Ii2, Xi, Yi, 'linear');
maxIi3 = max(max(Ii3));
for i=1:length(Ii3(:,1))
    for j=1:length(Ii3(1,:))
        if (Ii3(i,j) < 0.005*maxIi3)
            Ii3(i,j) = 0;
        end;
    end
end;
Ii = Ii3;

%% ���������� �������� ����� �� 180 ��������
if (angleP(end) < 180) % ���� ���������� ����������, �� ���� ����� � ���� ������������ ����� 0
    while (angleP(end) ~= 180)
        angleP(end+1) = angleP(end) + 1;
        Ii(:, end+1) = 0;
    end
    [A, P] = size(Ii);
    angleA = angleA(1):1:angleA(end);
end

%% ���������� ������������ ����� �� 360 ��������
if ((angleA(1) == 0) && (angleA(end) == 90)) %���� ������ ������������ ���� 0-90 ��������, ����������� �� 0-360
    Ii(end:end+length(Ii(:,1))-1,:) = flipud(Ii);
    angleA(end+1:end+90) = [91:180];
    Ii(end:end+length(Ii(:,1))-1,:) = Ii;
    angleA(end+1:end+180) = [181:360];
end
if ((angleA(1) == 90) && (angleA(end) == 270)) %���� ������ ������������ ���� 90-270 ��������, ����������� �� 0-360
    Ii(91:91+length(Ii(:,1))-1,:) = Ii;
    angleA(91:91+length(angleA)-1) = angleA;
    Ii(1:90,:) = flipud(Ii(92:92+90-1,:));
    angleA(1:91) = [0:90];
    Ii(end:end+length(Ii(181:181+90,1))-1,:) = flipud(Ii(181:181+90,:));
    angleA(272:361) = [271:360];
end
if ((angleA(1) == 0) && (angleA(end) == 180)) %���� ������ ������������ ���� 0-180 ��������, ����������� �� 0-360
    Ii(end:361,:) = Ii;
    angleA(end+1:end+180) = [181:360];
end
if ((angleA(1) == 0) && (angleA(end) == 360)) %���� ������ ������������ ���� 0-360 ��������
    %������ ��������� ��� ������������ ���� 0-360 ��������
    angleA = [0:360];
end
Iinterpolated = struct();
Iinterpolated.A = length(angleA);
Iinterpolated.P = length(angleP);
Iinterpolated.angleA = angleA;
Iinterpolated.angleP = angleP;
Iinterpolated.I = Ii;
%% ����� ��������
if (length(angleAorig) == 1) % ��������� ������ �������� ���, �������� ����� ������������ �����
    I0 = I(1,2:end); I180 = fliplr(I(1,1:end)); I90 = I0; I270 = I180;
else
    if(angleAorig(1) == 0 && angleAorig(end) == 360) % ���������� ������ �������� ���, �������� ������������� ������ 0-360
        I0 = I(1,2:end);
        I180 = fliplr(I((A-1)/2+1, :));
        I90 = I((A-1)/4*3+1,2:end);
        I270 = fliplr(I((A-1)/4+1, :));
    end;
end;

Ii = iesRotor(Ii, 45);

% h1=polar(pi/2:pi/(length(I(1,:))-1):2*pi+pi/2, cat(2, fliplr(I((A-1)/2+1, :)) ,I(1,2:end)), '--red'); % ����� �������� ��� 0-180
h1=polar(pi/2:pi/(length(I(1,:))-1):2*pi+pi/2, cat(2, I180 ,I0), '--red');
set(h1,'LineWidth',3);
hold on
% h2=polar(pi/2:pi/(length(I(1,:))-1):2*pi+pi/2, cat(2, fliplr(I((A-1)/4+1, :)) ,I((A-1)/4*3+1,2:end)), '--blue'); % ����� �������� ��� 90-270
h2=polar(pi/2:pi/(length(I(1,:))-1):2*pi+pi/2, cat(2, I270, I90), '--blue');
set(h2,'LineWidth',3);
% polar(transpose(Yi(:, 1)*pi/180 + pi/2), cat(2, fliplr(Ii(181, :)) ,Ii(1,2:end)), 'magenta'); % ����� ����������������� ��� 0-180
% polar(transpose(Yi(:, 1)*pi/180 + pi/2), cat(2, fliplr(Ii(271, :)) ,Ii(91,2:end)), 'cyan'); % ����� ����������������� ��� 90-270
polar([0:1:360]*pi/180 + pi/2, cat(2, fliplr(Ii(181, :)) ,Ii(1,2:end)), 'magenta'); % ����� ����������������� ��� 0-180
polar([0:1:360]*pi/180 + pi/2, cat(2, fliplr(Ii(271, :)) ,Ii(91,2:end)), 'cyan'); % ����� ����������������� ��� 90-270
title('���');
legend('�������� ��� 0-180', '�������� ��� 90-270', '������ ��� 0-180', '������ ��� 90-270');

figure
Pang = round(0.11*length(Ii(1,:))); % ���� �������� ��������� �� ������� ������� ��������������� ����
polar([0:360/(A-1):360]*pi/180, I(:, (length(I(1,:))-1)/180*angleP(Pang)+1)', 'green'); % ����� �������� �������� ��� �� ��������� ���� Pang
hold on
polar(angleA(1:step3:end)*pi/180, Ii(:, Pang)', '--black'); % ����� �������� ����������������� ��� �� ��������� ���� Pang
% title(strcat('������� ��� � �������� ����� ', num2str(Pang-1), '��������'));
title(['������� ��� � �������� ����� ', num2str(Pang-1), ' ��������']);
legend('��������', '�����������������');

%% ����������������� ������
% figure
% polar(transpose(Yi(:, 1)*pi/180 + pi/2), cat(2, fliplr(Ii(181, :)) ,Ii(1,2:end)), 'red');
% hold on
% polar(transpose(Yi(:, 1)*pi/180 + pi/2), cat(2, fliplr(Ii(271, :)) ,Ii(91,2:end)), 'blue');
% title('����������������� ���');
% for i=1:length(Ii(:,1))
%     Itemp(i) = max(Ii(i, :).*sin(angleP*pi/180));
% end;
% figure
% polar(angleA*pi/180, transpose(Ii(:,1)));
% title('����������������� ���');
% figure
% hold on
% for i=1:91
%     polar((i-1)*pi/180, Itemp(i));
% end;

%% ����� ��� ����� ������������
% figure
% Pang = round(0.25*length(Ii(1,:)));
% polar([0:90:360]*pi/180, I(:, (length(I(1,:))-1)/180*angleP(Pang)+1)', '--black');
% hold on
% polar(angleA(1:step:end)*pi/180, Ii1(:, Pang)', 'red');
% polar(angleA(1:step2:end)*pi/180, Ii2(:, Pang)', 'blue');
% polar(angleA(1:step3:end)*pi/180, Ii3(:, Pang)', 'green');
% title(strcat('������� ��� � �������� ����� ', num2str(Pang-1)));
% legend('��������', ...
%         strcat('������������ ',num2str(step),' ��������'), ...
%         strcat('������������ ',num2str(step2),' ��������'),...
%         strcat('������������ ',num2str(step3),' ��������'));

%% ���������� ��������� ������ �� ����� ����� � ies

% A = length(Ii(:, 1));
% P = length(Ii(1, :));
% Fsum = 0; %�������� ����� �� ���
% for i=1:P-1 %������� ��������� ������ �� ���
%     Is = 0; %���� ����� � ������� ����
%     for j=1:A-1
%         Is = Is + (Ii(j, i) + Ii(j, i+1))/2;
%     end
%     % disp(i);
%     % (Is/(j))*2*pi*(cos(angleP(i)*pi/180)-cos(angleP(i+1)*pi/180))
%     Fsum = Fsum + (Is/(j))*2*pi*(cos(angleP(i)*pi/180)-cos(angleP(i+1)*pi/180));
% end
disp(num2str(iesFlux(Ii)));
Inormalized = iesNormalize(Ii, 5000);
disp(num2str(iesFlux(Inormalized)));
Inormalized1000 = iesNormalize(Ii, 1000);
disp(num2str(iesFlux(Inormalized1000)));







function f = iesInterpolate(I, stepA, stepP)
%% ���������� ����������� ������������ �����, ���� ��� ��������������� � ����� ������������ ����� 0 ��������
if (I.A == 1) %���� �������� ��������������� (���� �������� ����), �������� ��� � �������� ����� 0-90 ��������
    for i=1:90+1
        angleA(i) = 0 + (i-1);
        I(i,:) = I(1,:);
    end
    A = length(angleA);
else
    angleA = I.angleA; % ������ ���������� ���������� �� ���������, ����� �� ������ �� ����� � ����� ���������� ����
    A = I.A;
    angleP = I.angleP;
    P = I.P;
end;

%% ���������������� ���
% ���� ��� ������ ����� 4 ������������� ������, �� ������������ ��������
% ����� �������. ������� ����������� ���������������� ������������. ����
% ����� ��������� ���������������.
% ���������, ��� � ������ �������, ����� ������ � ������, ��� ���� ����
% ����� (��������) ��� ������������ ���������� � ��������
if (length(I.angleA) == 5)
    if(sum(I.angleA == 0:90:360) == 5)
        disp('!!��������!!! �������� ��� ������������ ������ � ���� ����������. ��� ����������������� ������ ��������� ������������ ����� ������������!');
    end;
end;
if(A~= 361 && P~=181) % ������� ��� ��������� ������������ ������������ ��� ��������
    step = 20;
    [X, Y] = meshgrid(0:(angleP(end))/(P-1):angleP(end), angleA(1):(angleA(end)-angleA(1))/(A-1):angleA(end)); % �������������� ����� � ies �����
    [Xi, Yi] = meshgrid(0:1:angleP(end), angleA(1):step:angleA(end));
    angleP = 0:1:angleP(end);
    Ii1 = interp2(X, Y, I.I, Xi, Yi, 'linear');
    maxIi = max(max(Ii1));
    for i=1:length(Ii1(:,1))
        for j=1:length(Ii1(1,:))
            if (Ii1(i,j) < 0.005*maxIi)
                Ii1(i,j) = 0;
            end;
        end
    end;
    
    X = Xi; Y = Yi;
    step2 = 10;
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
else % ���� ���� � ������������ ��� ����� �������� (�� �������� ������������ �� ���� ����� � ����� 1 ������),
    % �� ������� ����� �� ��������� �������� � ���������
    % ������ ������������
    [X, Y] = meshgrid(0:(angleP(end))/(P-1):angleP(end), angleA(1):(angleA(end)-angleA(1))/(A-1):angleA(end)); % �������������� ����� � ies �����
    Ii2 = I.I;
end

step3 = stepA;
[Xi, Yi] = meshgrid(0:stepP:angleP(end), angleA(1):step3:angleA(end));
angleP = 0:stepP:angleP(end);
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
    angleA = [0:stepA:360];
end
Iinterpolated = struct();
Iinterpolated.A = length(angleA);
Iinterpolated.P = length(angleP);
Iinterpolated.angleA = angleA;
Iinterpolated.angleP = angleP;
Iinterpolated.I = Ii;
f = Iinterpolated;
end
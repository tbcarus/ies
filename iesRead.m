% ���������� ��� �� �����.
% ����� �������� ��� ���������� ���� ������ ��� ���������������� (����
% ������������ ����) � �������������� (������������ ���� ������ � ��������� 0-360) �������������.

function f = iesRead(filename)
if(~exist(filename))
    f = 0;
    disp(['���� ' filename ' �� ������. ������� ������.']);
    return;
end;

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
f = Ireaded;
end

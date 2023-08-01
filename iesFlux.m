% ������� ���������� ��������� ������ �� ��������� ��� ����� � �����. ����
% �� ���� ������ ���������� ��� ����������������� � ������������� ������
% �=0-360 ��������, ��������� P=0-180 ��������.

function f = iesFlux(I)
A = length(I(:, 1)); % ���������� ������������ ����� � ���
P = length(I(1, :)); % ���������� �������� ����� � ���
angleP = [0:180/(length(I(1, :))-1):180];
Fsum = 0; %�������� ����� �� ���
for i=1:P-1 %������� ��������� ������ �� ���
    Is = 0; %���� ����� � ������� ����
    for j=1:A-1
        Is = Is + (I(j, i) + I(j, i+1))/2;
    end
    % disp(i);
    % (Is/(j))*2*pi*(cos(angleP(i)*pi/180)-cos(angleP(i+1)*pi/180))
    Fsum = Fsum + (Is/(j))*2*pi*(cos(angleP(i)*pi/180)-cos(angleP(i+1)*pi/180));
end
f = Fsum;
end
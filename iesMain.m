clc
close all
clear all
% ����� ������ ������ ���������:
% 1. ���������� ������, ������� ������ ���� � �������� �����
% 2. ���������� ��������� ������ �� ������ ���
% 3. ���������� ���
% 4. ��������������� ���
% 5. ������� ���
% 6. ������������ ��� �� ���������� ������
% 7. ��������/������� � ������ ����� ��� ���������� �����
% 8. ���������� �����

iesResult = struct('standart','IESNA:LM-63-1995\r\n',...
    'test',' www.martinirus.ru\r\n',...
    'data',[datestr(datetime('now'),'mm.dd.yyyy'), '\r\n'],...
    'manufac',' ��� ������� ���\r\n',...
    'lumcat',' �������\r\n','luminaire',' ����������\r\n',...
    'lampcat','\r\n','lamp',' ���\r\n',...
    'balastcat','\r\n','other',' Light color\r\n',...
    'more','\r\n','tilt','TILT=NONE\r\n');

ies = iesRead('Elliptical.ies');
ies2 = iesInterpolate(ies, 5, 5);
if(0)
    ies2 = iesRotor(ies2, 90);
end;
% iesView(ies, ies2);
ies3 = iesNormalize(ies2, 1000);

disp(['����� � �������� �����: ' num2str(iesFlux(ies.I)) ' ��']);
disp(['����� � ����������������� �����: ' num2str(iesFlux(ies2.I)) ' ��']);
disp(['����� � ����� ����� ������������: ' num2str(iesFlux(ies3.I)) ' ��']);

iesResult.Nlamp = 1;
iesResult.F = 1325;
iesResult.M = iesResult.F/1000;
iesResult.P = ies3.P;
iesResult.A = ies3.A;
iesResult.type = 1;
iesResult.system = 2;
iesResult.width = 0.05;
iesResult.lenght = 1.51;
iesResult.height = 0.063;
iesResult.kb = 1;
iesResult.vers = 1;
iesResult.power = 35;
iesResult.angleP = ies3.angleP;
iesResult.angleA = ies3.angleA;
iesResult.I = ies3.I;

iesSave(iesResult);















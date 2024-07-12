clc
close all
clear all
% ��������� ies �����
% ����� ������ ������ ���������:
% 1. ��������� ������������ �� ������ �����, ������� ����������� �������
% (�������� �� ������, �� ���� ������ ������ �������� ������ ������)
% 2. ���������� ���. ������ �� ����� ies ����� ������ ��������.
% 3. ��������� ��� ������������ �������������� ���������
% 4. ���������� ����� � ��������� "-flipped"

inputFileName = 'Diffuse.ies'; % ��� �������� ies �����
iesResult = struct('standart','IESNA:LM-63-1995\r\n',...
    'test',' www.martinirus.ru\r\n',...
    'data',[datestr(datetime('now'),'mm.dd.yyyy'), '\r\n'],...
    'manufac',' MARTINI RUS\r\n',...
    'lumcat',' �������\r\n','luminaire',' ����������\r\n',...
    'lampcat','\r\n','lamp',' ���\r\n',...
    'balastcat','\r\n','other',' Light color\r\n',...
    'more','\r\n','tilt','TILT=NONE\r\n'); % ��������������� ���������� ����� ���������� ies �����

ies = iesRead(inputFileName); % ������ �����
% ���������� ��������� ����� ��������� ������
ies1 = iesFlip(ies);
iesResult.Nlamp = 1;
iesResult.F = ies1.F;
iesResult.M = ies1.m;
iesResult.P = ies1.P;
iesResult.A = ies1.A;
iesResult.width = ies1.width;
iesResult.length = ies1.length;
iesResult.height = ies1.height;
iesResult.power = ies1.power;
iesResult.type = 1;
iesResult.system = 2;
iesResult.kb = 1;
iesResult.vers = 1;
iesResult.angleP = ies1.angleP;
iesResult.angleA = ies1.angleA;
iesResult.I = ies1.I;
name = strsplit(inputFileName, '.');
iesResult.name = name{1};

iesSaveSimple(iesResult); % ���������� �����
disp('��������� ���������');
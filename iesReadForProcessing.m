clc
close all
clear all
% Чтение файла для дальнейшей обработки вручную

inputFileName = 'Walkie.ies'; % имя входного ies файла
iesResult = struct('standart','IESNA:LM-63-1995\r\n',...
    'test',' www.martinirus.ru\r\n',...
    'data',[datestr(datetime('now'),'mm.dd.yyyy'), '\r\n'],...
    'manufac',' MARTINI RUS\r\n',...
    'lumcat',' Артикул\r\n','luminaire',' Светильник\r\n',...
    'lampcat','\r\n','lamp',' СИД\r\n',...
    'balastcat','\r\n','other',' Light color\r\n',...
    'more','\r\n','tilt','TILT=NONE\r\n'); % предварительное заполнение шапки параметров ies файла

ies = iesRead(inputFileName); % Чтение файла
ies = iesInterpolate(ies, 1, 1);
% заполнение остальных полей структуры данных
iesResult.Nlamp = 1;
iesResult.F = ies.F;
iesResult.M = ies.m;
iesResult.P = ies.P;
iesResult.A = ies.A;
iesResult.width = ies.width;
iesResult.length = ies.length;
iesResult.height = ies.height;
iesResult.power = ies.power;
iesResult.type = 1;
iesResult.system = 2;
iesResult.kb = 1;
iesResult.vers = 1;
iesResult.angleP = ies.angleP;
iesResult.angleA = ies.angleA;
iesResult.I = ies.I;
name = strsplit(inputFileName, '.');
iesResult.name = name{1};

x = 5;



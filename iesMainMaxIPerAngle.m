clc
close all
clear all
% Вычисление максимальной силы света и её направления по всем азимутальным
% углам при заданном поляроном и вывод графика сечения КСС горизонтальной
% плоскостью, соотвествующей заданному углу.
% Входные данные:
% 1. название ies файла.
% 2. требуемый световой поток ies файла.

inputFileName = '222 higer 4710-910 lens Ledil C17634.IES'; % имя входного ies файла
resultF = 2900;
angle = 85; % угол, под которым ищем максимальную силу света
iesResult = struct('standart','IESNA:LM-63-1995\r\n',...
    'test',' www.martinirus.ru\r\n',...
    'data',[datestr(datetime('now'),'mm.dd.yyyy'), '\r\n'],...
    'manufac',' MARTINI RUS\r\n',...
    'lumcat',' Артикул\r\n','luminaire',' Светильник\r\n',...
    'lampcat','\r\n','lamp',' СИД\r\n',...
    'balastcat','\r\n','other',' Light color\r\n',...
    'more','\r\n','tilt','TILT=NONE\r\n'); % предварительное заполнение шапки параметров ies файла

ies = iesRead(inputFileName); % Чтение файла
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

Iint = iesInterpolate(iesResult, 1, 1);
iesResult.P = Iint.P;
iesResult.A = Iint.A;
iesResult.angleP = Iint.angleP;
iesResult.angleA = Iint.angleA;
iesResult.I = Iint.I;

iesResult = iesNormalize(iesResult, resultF);
iesResult.F = iesFlux(iesResult.I);

Iangle = iesResult.I(:, angle + 1)';
polar(iesResult.angleA*pi/180, Iangle);
[M, ii] = max(Iangle);
disp(M);
disp(ii);

disp('Программа завершена');
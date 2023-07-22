clc
close all
clear all
% Общая логика работы программы:
% 1. Считывание данных, которые должны быть в выходном файле
% 2. Сортировка считанных данных по стобце КСС
% 3. Считывание КСС
% 4. Интерполировани КСС
% 5. Поворот КСС
% 6. Нормирование КСС по требуемому потоку
% 7. Создание/переход в нужную папку для сохранения файла
% 8. Сохранение файла

iesResult = struct('standart','IESNA:LM-63-1995\r\n',...
    'test',' www.martinirus.ru\r\n',...
    'data',[datestr(datetime('now'),'mm.dd.yyyy'), '\r\n'],...
    'manufac',' ООО МАРТИНИ РУС\r\n',...
    'lumcat',' Артикул\r\n','luminaire',' Светильник\r\n',...
    'lampcat','\r\n','lamp',' СИД\r\n',...
    'balastcat','\r\n','other',' Light color\r\n',...
    'more','\r\n','tilt','TILT=NONE\r\n');

ies = iesRead('Elliptical.ies');
ies2 = iesInterpolate(ies, 5, 5);
if(0)
    ies2 = iesRotor(ies2, 90);
end;
% iesView(ies, ies2);
ies3 = iesNormalize(ies2, 1000);

disp(['Поток в исходном файле: ' num2str(iesFlux(ies.I)) ' лм']);
disp(['Поток в интерполированном файле: ' num2str(iesFlux(ies2.I)) ' лм']);
disp(['Поток в файле после нормирования: ' num2str(iesFlux(ies3.I)) ' лм']);

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















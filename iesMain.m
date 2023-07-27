clc
close all
clear all
% ����� ������ ������ ���������:
% 1. ���������� ������, ������� ������ ���� � �������� �����
% 2. ���������� ��������� ������ �� ������ ���
% 3. ���������� ���
% 4. ���������������� ��� � ����� 1 ������
% 5. ������� ���
% 6. ���������������� ��� � �������� �����
% 6. ������������ ��� �� ���������� ������
% 7. ��������/������� � ������ ����� ��� ���������� �����
% 8. ���������� �����

inputFileName = 'input.xlsx';
iesResult = struct('standart','IESNA:LM-63-1995\r\n',...
    'test',' www.martinirus.ru\r\n',...
    'data',[datestr(datetime('now'),'mm.dd.yyyy'), '\r\n'],...
    'manufac',' MARTINI RUS\r\n',...
    'lumcat',' �������\r\n','luminaire',' ����������\r\n',...
    'lampcat','\r\n','lamp',' ���\r\n',...
    'balastcat','\r\n','other',' Light color\r\n',...
    'more','\r\n','tilt','TILT=NONE\r\n');

fouts = xlsRead(inputFileName);
len = 220;
len = length(fouts);
for i = 1:len
    fout = fouts(i);
    iesResult.code = cell2mat(fout.art);
    iesResult.name = cell2mat(fout.name);
    if (isempty(iesResult.name))
        disp(['������������ � ������ ' num2str(i) ' �� ������o. ������� ������.']);
        continue;
    end;
    iesResult.version = cell2mat(fout.version);
    if(isnumeric(iesResult.version)) iesResult.version = int2str(iesResult.version); end;
    iesResult.optics = cell2mat(fout.optics);
    iesResult.cct = cell2mat(fout.cct);
    
    if(isnan(fout.P))
        disp(['�������� �� ������� ��� �� ��������, ������� ������ ' num2str(i+1)]);
        continue;
    end;
    iesResult.power = fout.P;
    
    if(isnan(fout.F))
        disp(['����� �� ����� ��� �� ��������, ������� ������ ' num2str(i+1)]);
        continue;
    end;
    iesResult.F = fout.F;
    
    iesResult.more1 = cell2mat(fout.more1);
    iesResult.more2 = cell2mat(fout.more2);
    iesResult.more3 = cell2mat(fout.more3);
    iesResult.more4 = cell2mat(fout.more4);
    if (strcmp(iesResult.more1, 'DALI'))
        iesResult.code = [iesResult.code 'DD'];
    end;
    if (strcmp(iesResult.more3, 'RGBW'))
        iesResult.code = [iesResult.code 'RGBW'];
    end;
    if((strcmp(iesResult.more1, 'DMX')||strcmp(iesResult.more1, 'DMX-RDM')) && ~strcmp(iesResult.more3, 'RGBW'))
        iesResult.code = [iesResult.code 'DMX'];
    end;
    if (strcmp(iesResult.more2, '5 DEG'))
        iesResult.code = [iesResult.code 'U'];
    end;
    if (strcmp(iesResult.more4, '�����. ������'))
        iesResult.code = [iesResult.code 'M'];
    end;
      
    if (isnan(fout.H))
        disp(['������ �� ������ ��� �� ��������, ������� ������ ' num2str(i+1)]);
        continue;
    end;
        iesResult.height = fout.H;
    
    if (isnan(fout.L))
        disp(['����� �� ������ ��� �� ��������, ������� ������ ' num2str(i+1)]);
        continue;
    end;
        iesResult.lenght = fout.L;
    
    if (isnan(fout.W))
        disp(['������ �� ������ ��� �� ��������, ������� ������ ' num2str(i+1)]);
        continue;
    end;
        iesResult.width = fout.W;
    
    if (isnan(fout.dP))
        disp(['��� ������������ �������� ����� �� �����, �������� �� ��������� 2']);
        iesResult.dP = 2;
    else
        iesResult.dP = fout.dP;
    end;
    if (isnan(fout.dA) || ~isnumeric(fout.dA))
        disp(['��� ������������ ������������ ����� �� �����, �������� �� ��������� 2']);
        iesResult.dA = 2;
    else
        iesResult.dA = fout.dA;
    end;
    
    if(isnan(fout.rot))
        disp(['���� �������� �� �����, �������� �� ��������� 0']);
        rot = 0;
    else
        rot = fout.rot; % ���� �������� ���
    end;
    
    ies = iesRead(cell2mat(fout.ies)); % ������ �����
    if (~isstruct(ies))
        continue;
    end;
    
    if (rot)
        ies2 = iesInterpolate(ies, 1, 1);
        ies2 = iesRotor(ies2, rot);
        ies2 = iesInterpolate(ies2, iesResult.dA, iesResult.dP);
    else
        ies2 = iesInterpolate(ies, iesResult.dA, iesResult.dP);
    end;
    
    % iesView(ies, ies2);
    ies3 = iesNormalize(ies2, 1000);
    
%     disp(['����� � �������� �����: ' num2str(iesFlux(ies.I)) ' ��']);
%     disp(['����� � ����������������� �����: ' num2str(iesFlux(ies2.I)) ' ��']);
%     disp(['����� � ����� ����� ������������: ' num2str(iesFlux(ies3.I)) ' ��']);
    
    iesResult.Nlamp = 1;
    iesResult.M = iesResult.F/1000;
    iesResult.P = ies3.P;
    iesResult.A = ies3.A;
    iesResult.type = 1;
    iesResult.system = 2;
    iesResult.kb = 1;
    iesResult.vers = 1;
    iesResult.angleP = ies3.angleP;
    iesResult.angleA = ies3.angleA;
    iesResult.I = ies3.I;
    
    iesSave(iesResult);
    disp([num2str(floor(100*i/len)) '%']);
end;
disp('��������� ���������');













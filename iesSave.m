function f = iesSave(ies)
filename = ['first' '.ies'];
Iresult = ies.I;
Iresult = round(Iresult*1000)/1000;
Fresult = ies.F;

%вывод файла
fid = fopen(filename, 'w'); 
fprintf(fid, ies.standart);
fprintf(fid, ['[TEST]' ies.test]);
fprintf(fid, ['[DATA] ' ies.data]);
fprintf(fid, ['[MANUFAC]' ies.manufac]);
fprintf(fid, ['[LUMCAT]' ies.lumcat]);
fprintf(fid, ['[LUMINAIRE]' ies.luminaire]);
fprintf(fid, ['[LAMPCAT]' ies.lampcat]);
fprintf(fid, ['[LAMP]' ies.lamp]);
fprintf(fid, ['[OTHER]' ies.other]);
fprintf(fid, ['[MORE]' ies.more]);
fprintf(fid, ies.tilt);

fprintf(fid, [mat2str(ies.Nlamp) ' ' mat2str(ies.F) ' ' mat2str(ies.M) ...
     ' ' mat2str(ies.P) ' ' mat2str(ies.A) ' ' mat2str(ies.type) ...
     ' ' mat2str(ies.system) ' ' mat2str(ies.width) ...
     ' ' mat2str(ies.lenght) ' ' mat2str(ies.height) '\r\n']);
fprintf(fid, [mat2str(ies.kb) ' ' mat2str(ies.vers) ' ' mat2str(ies.power) '\r\n']);

%вывод полярных углов
CUT = 1;
stepP = ies.angleP(end)/(ies.P-1);
for i = 1:1:length(ies.angleP)
    temp = mat2str(ies.angleP(CUT:1:i));
    if ((length(temp) >= 120) || (i == length(ies.angleP)))
        if (temp(1) == '[') % если в переменной temp более одного значения, то будут []
            fprintf(fid, strcat(temp(2:end-1), '\r\n')); %запись со второго элемента, потому что в первом элементе сивол '['. Аналогично до end-1
        else
            fprintf(fid, strcat(temp(1:end), '\r\n')); % если элемент всего 1, то [] не будет
        end
        temp = 0;
        CUT = i+1;
    end
end

%вывод азимутальных углов
CUT = 1;
stepA = ies.angleA(end)/(ies.A-1);
for i = 1:1:length(ies.angleA)
    temp = mat2str(ies.angleA(CUT:1:i));
    if ((length(temp) >= 120) || (i == length(ies.angleA)))
        if (temp(1) == '[') % если в переменной temp более одного значения, то будут []
            fprintf(fid, strcat(temp(2:end-1), '\r\n')); %запись со второго элемента, потому что в первом элементе сивол '['. Аналогично до end-1
        else
            fprintf(fid, strcat(temp(1:end), '\r\n')); % если элемент всего 1, то [] не будет
        end
        temp = 0;
        CUT = i+1;
    end
end

%вывод значений сил света
for i=1:1:length(ies.angleA)
    CUT = 1;
    for j=1:1:length(ies.angleP)
        temp = mat2str(Iresult(i, CUT:1:j));
        if ((length(temp) >= 120) || (j == length(Iresult(i,:))))
            if (temp(1) == '[')
                fprintf(fid, strcat(temp(2:end-1), '\r\n'));
            else
                fprintf(fid, strcat(temp(1:end), '\r\n'));
            end
            temp = 0;
            CUT = j+1;
        end
    end
end

fclose(fid);
disp(['Файл ' filename ', Фv=' num2str(iesFlux(ies.I)*ies.M) ' лм' ' .......записан']);
end


% Iresult = round(Iresult*1000)/1000;
% Iresult(:,1) = Iresult(1,1);
% 
% 
% 
% 
% %D_new{1, 1} = 'Созданный файл';
% %D_new{1,2} = 'Поляр. углы /шаг'; D_new{1,3} = 'Азим. углы /шаг'; D_new{1,4} = 'Поток в файле'; D_new{1,5} = 'Поток по КСС'; D_new{1,6} = 'КПД'; D_new{1,7} = 'Множитель';
% %D_new{2, 1} = filename_NEW; 
% %D_new{2, 2} = strcat(num2str(angleP(1)), '-', num2str(angleP(end)-90), ' /', num2str(stepP));
% %D_new{2, 3} = strcat(num2str(angleA(1)), '-', num2str(angleA(end)), ' /', num2str(stepA));
% %D_new{2, 4} = num2str(round(Fresult*1000)/1000);
% %D_new{2, 5} = num2str(Fresult);
% %D_new{2, 6} = num2str(Fresult/(round(Fresult*1000)/1000));
% %D_new{2, 7} = num2str(round(Fresult)/1000);
% %disp(D_new)
% 
% file_count = file_count+1;
% %disp(strcat(num2str(file_count), '/', num2str(file_all)));
% disp([filename_NEW, ' ', num2str(round(10*P_LEDS/Power_suply_eff)/10) ' - '...
%     num2str(round((P_LEDS/Power_suply_eff)/5)*5) '   ' num2str(FvLED*N(1)) '  ' num2str(FvLED*N(1)/(round((P_LEDS/Power_suply_eff)/5)*5))])
% 
% end
% cd('..');%выход из каталога
% end
% if length(N_file)==0
%     disp('ies-файлы в дирректории отсутсвуют');
% end
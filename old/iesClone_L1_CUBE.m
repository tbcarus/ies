% �������� ���������� IES ������, ������������� �� ��������, �� ��������.
%�������� ����� ����������, ��������, �� ���������� � ������ �����������
%������������ ��� ������� � ����� � m-����� � ����������� � ������ ��
%���������. 
%������ �������� ����� "MD C40 A19 P1 83.ies", CUBE M C30 A10 P2 83.ies"/
%����� � ����� 5 �����, ���� ��� ���������� (����� �������) ����������
%������, �� ������ ������ ������������ - ��� �������� �����. ������ 1 -
%�������� �����, ������ 2 - �������� �����������, ������ 3 - ����
%���������, ������ 4 - �������� (�� �����������), ������ 5 - ��� ������ �
%%.
%���������� ������� ���������� ��� � ����������� ������, ��������
%������������.
%����� ���������� ������ �� ���������� ������ � ���������� �� �����������
%KLED ��� ����� ���� ����� �������
%�������� ������ ���������� � �������� �������, �� ����� ������� 
%�� ����������� ����� - ��������� power_LED.
%�������� ���������� ������������ ����������� �� �����
%�������� ����������� ies ����������� ������������� ������ 1 ��
%����������� ����������� ��� �� �� ��������. ��� ������������� �� �������, 
%���� ��� ������ 0,9, �� ������ 0,9 �� ��������� ����� 0,001 - ����� ��
%������������
%��������� Power- ��������� ��� ������� ��������. ������������ ���
%������������ ��� �������� ������
%��������� ����� (����� 83  ��� ����� � %)

clear all
clc

files = dir; %��� ����� �����������
N_files = length(files); %���������� ������ � �����������
NN = 0; %������� ies ������ ��� ������
N_file = 0; %������������ ��� ������ ������� ��������� � ����� ies ������
for i=1:N_files
%����� � ����������� ������ � ����������� ies � ����������� �� �������    
    if findstr('.ies', lower(files(i).name))&(~files(i).isdir)
        NN = NN + 1;
        N_file(NN) = i;
    end
end
N_LED =     [16]; %���������� ����������� � ����������� �����
dlina =     [0.15]; %����� ����������� � ����������� �����
L_NEW =     ['L06';  'L09';    'L12';  'L15']; %���������� ���� ��� ������������ �����
%N_LED =     [9      12       15      21      27      33      39      45      51];
%dlina =     [0.3    0.35     0.4     0.5     0.6     0.7     0.8     0.9     1]; %����� ����������� � ����������� �����
%N_LED =     [9.49      12      15      21];
shirina =   [0.15]; %������ ����������� � ����������� �����
visota =    [0.06]; %������ ����������� � ����������� �����
file_all = length(N_LED)*length(N_file); %���������� ����������� ������
file_count = 0; %������� ��������� ������

for N_faila = 1:length(N_file)
    name_groups = regexp(cell2mat(regexp(files(N_file(N_faila)).name, '.ies', 'split')), ' ', 'split');
    if (length(name_groups) > 5)
        for i = 2:(length(name_groups)-5+1)
            name_groups(1) = strcat(name_groups(1), {' '}, name_groups(i));
        end
        name_groups(2) = name_groups(length(name_groups)-3);
        name_groups(3) = name_groups(length(name_groups)-2);
        name_groups(4) = name_groups(length(name_groups)-1);
        name_groups(5) = name_groups(length(name_groups)-0);
    end
    
%    name_pos = findstr(' ',files(N_file(N_faila)).name); %����� ������� ����� � �������� �����
%    dot_pos = findstr('.',files(N_file(N_faila)).name); %����� ������� ����� � �������� (������ ������� - ���������� �����)
    %file_N_LED = str2num(files(N_file(N_faila)).name(name_pos(1)+1:name_pos(2)-1)); %���������� ��� � IES
    %mkdir(strcat(files(N_file(N_faila)).name(1:name_pos(1)-1),'-',files(N_file(N_faila)).name(name_pos(3)+1:name_pos(4)-1)));
    %New_dir = [files(N_file(N_faila)).name(1:name_pos(1)-1),' ',files(N_file(N_faila)).name(name_pos(4)+1:dot_pos(2)-1)];
    New_dir = cell2mat(name_groups(1));
    mkdir(New_dir);
    lens_eff = str2num(cell2mat(name_groups(5)))/100; %��� �����
    
%������ ��� �����
power_LED = 1.375; %�������� ������ ��� � ������� ������(��� ����� ��)
KLED = 1; %����������� ��� ��������� ������ 1 �����
stepA = 5; %��� ������ ������������ �����
stepP = 2; %��� ������ �������� �����
FvLED = 230*0.85*lens_eff; %�������� ����� ������ ����������, ���������� �� ���������������� ��������� ������. ��� ������ ������ �� ���������� lens_eff
Power = 2; %�������� ������� ��� ���������

flat_glass = 0; %�� ����� ���� ���� ��������� ������� �������� ��������� ������
N = [1 0 0]; %���������� �������������� ���� � �����������
ROTOO = [0 0 0]; %������� �������� ��� ������ ���������� ���. ������� ������ � ���� - ������ ������� �������
n_glass = 1.5; %���������� ����������� �������� ��������� ������
Rpcb = 0.6; %����������� ��������� �������� �����. ��� ��������� ������������� ���������� ����� �������������
%�������������� ������. ��������� ���� ������ 'GAUSS.IES' (���� � ������������� �������������� ��� ���������)
%filename = char(files(N_file(N_faila)).name, 'GAUSS.IES');
filename = files(N_file(N_faila)).name;
%filename_NEW = 'created.ies'; %�������� ������������ �����


warning off;
%D{1,1} = '��� �����'; D{1,2} = '�����. ���� /���'; D{1,3} = '����. ���� /���'; D{1,4} = '����� � �����'; D{1,5} = '����� �� ���'; D{1,6} = '���'; D{1,7} = '���������';
%disp('          ����                          �������� ���� /���                  ������������ ���� /���')
CUT = 1; %���������� ��� ����������� ������ ������� � ������� ����� � ��� ����� ��� ������ �����.
k = 1; %����� ����� � ������
F1 = 0; %�������� ����� �� ��������� ������
F2 = 0; %�������� ����� ����� ��������� ������
Fresult = 0; %�������������� �������� ����� �����������

%���� ���������� ������ �� ������
%for k=1:length(filename(:,1))

    file = textread(deblank(filename), '%s', 'delimiter', '\n'); %���������� �����
    stroka = 1; %����� ����������� ������
    j = 1; %������� ������������ ����� ��� ���������� ��� �����
    P = 0;  %���������� �������� ����� � �����
    A = 0;  %���������� ������������ ����� � �����
    X = 0;Y = 0;Xi = 0;Yi = 0;I = 0;Ii = 0;Imark = 0;Is = 0;
    cause = 1; %���� ��� ������ while
    angleP = 0;
    angleA = 0;
    [m n] = size(file); %���� ���������� ����� � �����
    i = 1; %����� ������
    str = cell2mat(strread(file{i,1}, '%s')); %���������� ������
    i = i+1;
    while (~strncmp(str, 'TILT', 4)) %���������� ��� ������ � ������� �� ������ ������ ����� ���� ������
        str = cell2mat(strread(file{i,1}, '%s','whitespace', ''));
        i = i+1;
    end
    str = strread(file{i,1}); %��������� ������ � ����������� ����������� � ���
    Fies = str(2); % �������� �����, ��������� � �����
    M = str(3); %���������
    P = str(4); %���������� �������� �����
    A = str(5); %���������� ������������ �����
    i = i+1; %��������� ������
    str = strread(file{i,1}); %��������� ������ � ��������� �����������
    power = str(3); %�������� �����������
    %power_LED = power/str2num(files(N_file(N_faila)).name(name_pos(1)+1:name_pos(2)-1));
    i = i+1; %��������� ������
    while (cause) %���� ��� ���������� �������� �����
        str = str2num(file{i,1}); %��������� ������ ������ �������� �����
        if (angleP == 0)
            angleP = str; %������ ������ ������ �����
        else
            angleP(length(angleP)+1:length(angleP)+length(str)) = str(1:end); %������ ����������� ����� �����, ���� ��� � ies ����� �� ���������� �� ����� ������
        end
        i = i+1;
        if (length(angleP) == P) %���� ���������� ��������� �������� ����� ����� �������� �����, �� ��������� ����
            cause = 0;
        end
    end
    cause = 1; 
    while (cause) %���� ���������� ������������ �����. ���������� �������� �����
        str = str2num(file{i,1}); %��������� ������������ ����
        if (angleA == 0)
            angleA = str;
        else
            angleA(length(angleA)+1:length(angleA)+length(str)) = str(1:end);
        end
        i = i+1;
        if (length(angleA) == A)
            cause = 0;
        end
    end
    for i=i:m %���� ���������� �������� ��� �����. ���������� ���������� �����
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
    end
%    if (length(filename(k,:)) >= 19)%������ ����� �����
%        D{k+1,1} = deblank(filename(k,1:19)); 
%   else
%        D{k+1,1} = deblank(filename(k,:));
%    end
%    D{k+1,2} = strcat(num2str(angleP(1)), '-', num2str(angleP(end)), ' /', num2str(angleP(2)-angleP(1))); %������ �������� �����, ��������� � ����� � ����
%    if (A == 1) %������ ����������� �����, ��������� � ����� � ����
%        D{k+1,3} = strcat('0 /0');
%    else
%        D{k+1,3} = strcat(num2str(angleA(1)), '-', num2str(angleA(end)), ' /', num2str(angleA(2)-angleA(1)));
%    end
%    D{k+1,4} = num2str(Fies); %�������� ����� ���������, ��������� � ��������������� �����
%    D{k+1,7} = num2str(M); %���������, ��������� � ��������������� �����
    %���������� ����������� ������������ � �������� �����.
    if (A == 1) %���� �������� ��������������� (���� �������� ����), �������� ��� � �������� ����� 0-90 ��������
        for i=1:90+1
            angleA(i) = 0 + (i-1);
            I(i,:) = I(1,:);
        end
        A = length(angleA);
    end
    %�������� ����� ��� ���������������� � ����� 1 ������
    [X, Y] = meshgrid(0:(angleP(end))/(P-1):angleP(end), angleA(1):(angleA(end)-angleA(1))/(A-1):angleA(end));
    [Xi, Yi] = meshgrid(0:1:angleP(end), angleA(1):1:angleA(end));
    angleP = 0:1:angleP(end);
    Ii = interp2(X, Y, I, Xi, Yi, 'spline'); %���������������� ������������ ��������
    if (angleP(end) < 180) %���������� �������� ����� �� 180 ��������, ���� ���������� ���������, �� ���� ����� � ���� ������������ ����� 0
        while (angleP(end) ~= 180)
           angleP(end+1) = angleP(end) + 1;
           Ii(:, end+1) = 0;
        end
        [A, P] = size(Ii);
        angleA = angleA(1):1:angleA(end);
    end
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
        angleA = [0:360];
    end
    A = length(angleA);
    P = length(angleP);
    Fsum = 0; %�������� ����� �� ���
     for i=1:P-1 %������� ��������� ������ �� ���
        Is = 0; %���� ����� � ������� ����
        for j=1:A-1
            Is = Is + (Ii(j, i) + Ii(j, i+1))/2;
        end
       % disp(i);
       % (Is/(j))*2*pi*(cos(angleP(i)*pi/180)-cos(angleP(i+1)*pi/180))
        Fsum = Fsum + (Is/(j))*2*pi*(cos(angleP(i)*pi/180)-cos(angleP(i+1)*pi/180));
    end
    Fsum = Fsum;
    Iall(:,:,1) = Ii; %��������� ���� ����� ���� ��������� ���
    Fall = Fsum; %��������� �������� ������ ���� ��������� ���
%    D{k+1,5} = Fsum; %����������� �������� ����� �� ���
%    D{k+1,6} = Fsum/Fies; %����������� ������������ � �������� � ����� �������� �������
%end   
%����� ����� ���������� �� ������  



    %FvLED = KLED*Fall/file_N_LED; %�������� ����� 1 ��� � ����������� IES
    
    
    Eff = 105.745; %������� ������������� �����������
    cd(New_dir); %������� � �������

    
%���� �������� ������ � ����������� ���    
    for N_faila_new = 1:length(N_LED) 
        N = [N_LED(N_faila_new) 0 0];

        P_LEDS = N_LED(N_faila_new)*power_LED; %�������� ����������� � ����������
        Power_suply_eff = 0.9327*exp(-((N_LED(N_faila_new)-70.27)/82.05).^2) + ...
            0.03006*exp(-((N_LED(N_faila_new)-11.13)/7.781).^2) + ...
                  0.2627*exp(-((N_LED(N_faila_new)-11.52)/31.2).^2); %������� ������� ������������� �� �� �������� ������
        if (Power_suply_eff < 0.88)
            %�����, ���� ��� �� ����������� ������ 0,9
            Power_suply_eff = 0.88;% + 0.002*(rand-0.5); %������������� �������� ��������� ��� � ��� ���� +-0,005
        end
        Power_suply_eff = 0.85;
    
    %FvLED = ((round(power_LED*N_LED(N_faila_new)/5)*5)/N_LED(N_faila_new))*Eff; %���������� ������ ��� �� ������ ������� ������������� �����������
    
    %��� ������ �����
    %filename_NEW = strcat(files(N_file(N_faila)).name(1:name_pos(1)-1),'-', num2str(N_LED(N_faila_new)),'-',...
    %    files(N_file(N_faila)).name(name_pos(2)+1:name_pos(3)-1),'-',num2str(round(power_LED*N_LED(N_faila_new)/5)*5),...
    %    '-', files(N_file(N_faila)).name(name_pos(4)+1:dot_pos(2)-1), '.ies');
%    filename_NEW = [files(N_file(N_faila)).name(1:name_pos(1)-1),' ', L_NEW(N_faila_new,:),' ',...
%        files(N_file(N_faila)).name(name_pos(1)+1:name_pos(2)-1),' ',files(N_file(N_faila)).name(name_pos(2)+1:name_pos(3)-1),...
%        ' P', num2str(Power), '', '.ies'];
    filename_NEW = cell2mat(strcat(name_groups(1), {' '}, name_groups(2), {' '}, name_groups(3), ' P', num2str(Power), {'.ies'}));
    
    Iresult = Iall(:,:)*(N(1)*FvLED/Fall); %��������� ������ � ������ ���������� ������������ � ������ �����������

    Fresult = 0;
    for i=1:P-1 %������� ��������������� ��������� ������ �����������
            Is = 0; %���� ����� � ������� ����
            for j=1:A-1
                Is = Is + (Iresult(j, i) + Iresult(j, i+1))/2; %���� ����� � ������� ����
            end
            Fresult = Fresult + (Is/(j))*2*pi*(cos(angleP(i)*pi/180)-cos(angleP(i+1)*pi/180));
        
    end



%polar(angleP*pi/180, Iresult(1,:))
%polar((-angleP)*pi/180, Iresult(181,:))
%polar((angleP)*pi/180, Iresult(91,:), 'r')
%polar((-angleP)*pi/180, Iresult(271,:), 'r')

%����� �����

fid = fopen(filename_NEW, 'w'); 
fprintf(fid, 'IESNA:LM-63-1995\r\n');
fprintf(fid, '[TEST]\r\n');
fprintf(fid, '[DATA]\r\n');
%fprintf(fid, '[TESTLAB] MATLAB\r\n');
%fprintf(fid, '[TESTDATE]\r\n');
fprintf(fid, '[MANUFAC] L1 LED\r\n');
fprintf(fid, '[LUMCAT]\r\n');
%fprintf(fid, strcat('[LUMINAIRE] ', ([' ', files(N_file(N_faila)).name(1:name_pos(1)-1),' ', L_NEW(N_faila_new,:),' ',...
%        files(N_file(N_faila)).name(name_pos(1)+1:name_pos(2)-1),' ',files(N_file(N_faila)).name(name_pos(2)+1:name_pos(3)-1),...
%        ' P', num2str(Power), '', '\r\n'])));
fprintf(fid, cell2mat(strcat('[LUMINAIRE]', {' '}, strcat(name_groups(1), {' '}, name_groups(2), {' '}, name_groups(3),...
    ' P', num2str(Power), '\r\n'))));
fprintf(fid, '[ISSUEDATE]\r\n');
fprintf(fid, '[MORE] � ����� ������ ����� �����������\r\n');
%if (length(filename(:,1)) > 2)
%for i=2:length(filename(:,1))-1 
%    fprintf(fid, strcat('+', num2str(N(i)), 'x', filename(i,1:7)));
%end;
%end;
%fprintf(fid, '\r\n');
%fprintf(fid, '[LAMPCAT]\r\n');
%fprintf(fid, '[LAMP]');
%for i=1:length(filename(:,1))-1
%    fprintf(fid, strcat(' +', num2str(N(i)), 'x', filename(i,1:7)));
%end
%fprintf(fid, '\r\n');
%fprintf(fid, '[OTHER] ������������� ��� �� ������ ies\r\n');
fprintf(fid, 'TILT=NONE\r\n');
Iresult = Iresult/(Fresult/1000);
temp = mat2str([1 round(Fresult*1000)/1000 round(Fresult)/1000 angleP(end-90)/stepP+1 angleA(end)/stepA+1 ...
    1 2 shirina(N_faila_new) dlina(N_faila_new) visota(N_faila_new)]);
fprintf(fid, strcat(temp(2:end-1), '\r\n'));
%fprintf(fid, '1 1 1\r\n');
fprintf(fid, strcat(['1 1 ' num2str(round((P_LEDS/Power_suply_eff)/1)*1)],'\r\n'));

Iresult = round(Iresult*1000)/1000;
Iresult(:,1) = Iresult(1,1);
CUT = 1;
for i = 1:stepP:length(angleP)-90 %����� �������� �����
    temp = mat2str(angleP(CUT:stepP:i));
    if ((length(temp) >= 120) || (i == length(angleP)-90))
        fprintf(fid, strcat(temp(2:end-1), '\r\n')); %������ �� ������� ��������, ������ ��� � ������ �������� ����� '['. ���������� �� end-1
        temp = 0;
        CUT = i+stepP;
    end
end
CUT = 1;
for i = 1:stepA:length(angleA) %����� ������������ �����
    temp = mat2str(angleA(CUT:stepA:i));
    if ((length(temp) >= 120) || (i == length(angleA)))
        fprintf(fid, strcat(temp(2:end-1), '\r\n'));
        temp = 0;
        CUT = i+stepA;
    end
end
for i=1:stepA:length(angleA) %����� �������� ��� �����
    CUT = 1;
    for j=1:stepP:length(angleP)-90
        temp = mat2str(Iresult(i, CUT:stepP:j));
        if ((length(temp) >= 120) || (j == length(Iresult(i,:))-90))
            if (temp(1) == '[')
                fprintf(fid, strcat(temp(2:end-1), '\r\n'));
            else
                fprintf(fid, strcat(temp(1:end), '\r\n'));
            end
            temp = 0;
            CUT = j+stepP;
        end
    end
end
fclose(fid);
%D_new{1, 1} = '��������� ����';
%D_new{1,2} = '�����. ���� /���'; D_new{1,3} = '����. ���� /���'; D_new{1,4} = '����� � �����'; D_new{1,5} = '����� �� ���'; D_new{1,6} = '���'; D_new{1,7} = '���������';
%D_new{2, 1} = filename_NEW; 
%D_new{2, 2} = strcat(num2str(angleP(1)), '-', num2str(angleP(end)-90), ' /', num2str(stepP));
%D_new{2, 3} = strcat(num2str(angleA(1)), '-', num2str(angleA(end)), ' /', num2str(stepA));
%D_new{2, 4} = num2str(round(Fresult*1000)/1000);
%D_new{2, 5} = num2str(Fresult);
%D_new{2, 6} = num2str(Fresult/(round(Fresult*1000)/1000));
%D_new{2, 7} = num2str(round(Fresult)/1000);
%disp(D_new)

file_count = file_count+1;
%disp(strcat(num2str(file_count), '/', num2str(file_all)));
disp([filename_NEW, ' ', num2str(round(10*P_LEDS/Power_suply_eff)/10) ' - '...
    num2str(round((P_LEDS/Power_suply_eff)/5)*5) '   ' num2str(FvLED*N(1)) '  ' num2str(FvLED*N(1)/(round((P_LEDS/Power_suply_eff)/5)*5))])

end
cd('..');%����� �� ��������
end
if length(N_file)==0
    disp('ies-����� � ����������� ����������');
end

function f = iesView(If, Is)
%% ����� ��������
if (If.A == 1) % ���������� ������ �������� ���, �������� ����� ������������ �����
    If0 = If.I(1,2:end); If180 = fliplr(If.I(1,1:end)); If90 = If0; If270 = If180;
else
    if(If.angleA(1) == 0 && If.angleA(end) == 360) % ���������� ������ �������� ���, �������� ������������� ������ 0-360
        If0 = If.I(1,2:end);
        If180 = fliplr(If.I(floor((If.A-1)/2)+1, :));
        If90 = If.I(floor((If.A-1)/4)+1, 2:end);
        If270 = fliplr(If.I(floor((If.A-1)/4*3)+1,:));
    end;
end;
if (isstruct(Is)) % ��������, ��� ��� ���������� ���������, ������ �������� ������ ��� ��� �����������
    Is0 = Is.I(1,2:end);
    Is180 = fliplr(Is.I((floor(Is.A-1)/2)+1, :));
    Is90 = Is.I(floor((Is.A-1)/4)+1, 2:end);
    Is270 = fliplr(Is.I(floor((Is.A-1)/4*3)+1,:));
end;

% h1=polar(pi/2:pi/(length(I(1,:))-1):2*pi+pi/2, cat(2, fliplr(I((A-1)/2+1, :)) ,I(1,2:end)), '--red'); % ����� �������� ��� 0-180
h1=polar(pi/2:pi/(length(If.I(1,:))-1):2*pi+pi/2, cat(2, If180 ,If0), '--red');
set(h1,'LineWidth',3);
hold on
% h2=polar(pi/2:pi/(length(I(1,:))-1):2*pi+pi/2, cat(2, fliplr(I((A-1)/4+1, :)) ,I((A-1)/4*3+1,2:end)), '--blue'); % ����� �������� ��� 90-270
h2=polar(pi/2:pi/(length(If.I(1,:))-1):2*pi+pi/2, cat(2, If270, If90), '--blue');
set(h2,'LineWidth',3);
title('���');
% polar(transpose(Yi(:, 1)*pi/180 + pi/2), cat(2, fliplr(Ii(181, :)) ,Ii(1,2:end)), 'magenta'); % ����� ����������������� ��� 0-180
% polar(transpose(Yi(:, 1)*pi/180 + pi/2), cat(2, fliplr(Ii(271, :)) ,Ii(91,2:end)), 'cyan'); % ����� ����������������� ��� 90-270
if (isstruct(Is))
    polar(pi/2:pi/(length(Is.I(1,:))-1):2*pi+pi/2, cat(2, Is180 ,Is0), 'magenta'); % ����� ����������������� ��� 0-180
    polar(pi/2:pi/(length(Is.I(1,:))-1):2*pi+pi/2, cat(2, Is270,Is90), 'cyan'); % ����� ����������������� ��� 90-270
    legend('�������� ��� 0-180', '�������� ��� 90-270', '������ ��� 0-180', '������ ��� 90-270');
else
    legend('�������� ��� 0-180', '�������� ��� 90-270');
end;

% figure
% Pang = round(0.11*length(Ii(1,:))); % ���� �������� ��������� �� ������� ������� ��������������� ����
% polar([0:360/(A-1):360]*pi/180, I(:, (length(I(1,:))-1)/180*angleP(Pang)+1)', 'green'); % ����� �������� �������� ��� �� ��������� ���� Pang
% hold on
% polar(angleA(1:step3:end)*pi/180, Ii(:, Pang)', '--black'); % ����� �������� ����������������� ��� �� ��������� ���� Pang
% % title(strcat('������� ��� � �������� ����� ', num2str(Pang-1), '��������'));
% title(['������� ��� � �������� ����� ', num2str(Pang-1), ' ��������']);
% legend('��������', '�����������������');

%% ����������������� ������
% figure
% polar(transpose(Yi(:, 1)*pi/180 + pi/2), cat(2, fliplr(Ii(181, :)) ,Ii(1,2:end)), 'red');
% hold on
% polar(transpose(Yi(:, 1)*pi/180 + pi/2), cat(2, fliplr(Ii(271, :)) ,Ii(91,2:end)), 'blue');
% title('����������������� ���');
% for i=1:length(Ii(:,1))
%     Itemp(i) = max(Ii(i, :).*sin(angleP*pi/180));
% end;
% figure
% polar(angleA*pi/180, transpose(Ii(:,1)));
% title('����������������� ���');
% figure
% hold on
% for i=1:91
%     polar((i-1)*pi/180, Itemp(i));
% end;

%% ����� ��� ����� ������������
% figure
% Pang = round(0.25*length(Ii(1,:)));
% polar([0:90:360]*pi/180, I(:, (length(I(1,:))-1)/180*angleP(Pang)+1)', '--black');
% hold on
% polar(angleA(1:step:end)*pi/180, Ii1(:, Pang)', 'red');
% polar(angleA(1:step2:end)*pi/180, Ii2(:, Pang)', 'blue');
% polar(angleA(1:step3:end)*pi/180, Ii3(:, Pang)', 'green');
% title(strcat('������� ��� � �������� ����� ', num2str(Pang-1)));
% legend('��������', ...
%         strcat('������������ ',num2str(step),' ��������'), ...
%         strcat('������������ ',num2str(step2),' ��������'),...
%         strcat('������������ ',num2str(step3),' ��������'));
end
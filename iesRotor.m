% ������� ��� ������ ���������� ��� (��� ����������� ���������� 0-180 �
% 90-270. ������������� ����������� ������ ������� �������

function f = iesRotor(ies, rot)
I = ies.I;
stepA = 360/(length(I(:,1))-1);
Ii(1:length(I(:,1)), 1:length(I(1,:))) = 0;
Ii(1:floor(rot/stepA),:) = I(end-(floor(rot/stepA)-1):end,:);
Ii(floor(rot/stepA)+1:end,:) = I(1:end-floor(rot/stepA),:);
iesResult = ies;
iesResult.I = Ii;
disp(['��� ��������� �� ' num2str(rot) ' ��������']);
f = iesResult;
end
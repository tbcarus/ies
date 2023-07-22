% ������� ��� ������ ���������� ��� (��� ����������� ���������� 0-180 �
% 90-270. ������������� ����������� ������ ������� �������

function f = iesRotor(ies, rot)
I = ies.I;
Ii(1:length(I(:,1)), 1:length(I(1,:))) = 0;
Ii(1:rot,:) = I(end-(rot-1):end,:);
Ii(rot+1:end,:) = I(1:end-rot,:);
iesResult = ies;
iesResult.I = Ii;
f = iesResult;
end
% ��������� ��� ������������ �������������� ���������

function f = iesFlip(ies)
I = ies.I;
Iflipped = fliplr(I);
iesResult = ies;
iesResult.I = Iflipped;
disp('��� �������� ������������ ������������� ���');
f = iesResult;
end
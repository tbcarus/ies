% ���������� ������ � �����, ������������ �� ����� ����� � ���������
% ��������.

function f = iesNormalize(ies, Ftarget)
I = ies.I;
Forig = iesFlux(I);
Iresult = I*Ftarget/Forig;
iesResult = ies;
iesResult.I = Iresult;
f = iesResult;
end
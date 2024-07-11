clc
clear all
f1 = 'Standart'; v1 = 'IESNA:LM-63-1995\r\n';
f2 = 'TEST'; v2 = ' www.martinirus.ru\r\n';
f3 = 'DATA'; v3 = [datestr(datetime('now'),'mm.dd.yyyy'), '\r\n'];
f4 = 'MANUFAC'; v4 = ' ŒŒŒ Ã¿–“»Õ» –”—\r\n';
f5 = 'LUMCAT'; v5 = ' ¿ÚËÍÛÎ\r\n';
f6 = 'LUMINAIRE'; v6 = '\r\n';
f7 = 'LAMPCAT'; v7 = '\r\n';
f8 = 'LAMP'; v8 = '\r\n';
f9 = 'BALASTCAT'; v9 = '\r\n';
f10 = 'OTHER'; v10 = ' Light color\r\n';
f11 = 'MORE'; v11 = '\r\n';
f12 = 'TILT'; v12 = 'TILT=NONE\r\n';

s = struct(f1,v1,f2,v2,f3,v3,f4,v4,f5,v5,f6,v6,f7,v7,f8,v8,f9,v9,f10,v10,f11,v11,f12,v12);


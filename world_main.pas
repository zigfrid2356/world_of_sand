{
   world_main.pas
   
   Copyright 2015 Zigfrid <zigfridone@gmail.com>
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
   
}


program world_of_sand;

uses crt;

type
body =record
hp,mp,exp,lvl:integer;
end;
var

hero:body;
menu_key:byte;
procedure hero_output(i:byte);
begin
clrscr;
writeln('�窨 ����� ',hero.hp );
writeln('�窨 ���� ',hero.mp );
writeln('�窨 ���� ',hero.exp );
writeln('�஢��� ',hero.lvl );
readln();
end;

procedure main_menu(i:byte);
begin

repeat begin//1
ClrScr;
writeln	('1- ��ன');
writeln	('2- ����');
writeln	('3- ��������');
writeln	('4- ��室');
readln(menu_key);
case menu_key of
1: begin hero_output(1);
 
	end;
2:begin end;
3:begin end;
end;
end;//2 
until menu_key=4;
end;

BEGIN

writeln	('��� �����');
readln();
 ClrScr;
writeln	('����');
writeln	('1- �����');
writeln	('2- ���');
readln(menu_key);
case menu_key of
1: begin 
hero.hp:=10;
hero.mp:=10;
hero.exp:=0;
hero.lvl:=1;
main_menu(1); 
end;
2: exit
end;
END.


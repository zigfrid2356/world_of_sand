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
{v.0.002pa}{12.08.2015}

program world_of_sand;

uses crt,sysutils;

type
body =record
name:string;
hp,mp,exp,lvl:integer;
//+10.08.2015
dmg,ign_dmg,veapon,armor,attak,defense:integer;
gold:integer;
//+15.08.2015
stren,intel,agility,sex,race,init,masking,obser:integer;
end;
erath =record
x,y:byte;
structure:char;
end;
var
map:array[0..255,0..255] of erath;
hero:body;
monster:body;
menu_key:char;
i,j,n,m:integer;//áçñâç¨ª¨{счётчики}
s:string;//temp
lang: text;
monster_name:text;
text:array[0..100] of string;
text_name:array[0..100] of string;
hero_save:file of body;
map_save:file of erath;

simbol: array [0..4] of char;
function name_generate(command:string):string;//+12.08.2015
var
s:string;
begin
s:='monster_'+command+'.name';

assign(monster_name,s);
reset(monster_name);
m:=1;
while not eof(monster_name) do begin//1.1
readln(monster_name,text_name[m]);
m:=m+1;
end;//1.1
close(monster_name);
name_generate:=text_name[random(m)];
end;
procedure hero_generate(h:string);//+12.08.2015
begin
if h='hero_new' then begin //0//+15.08.2015
writeln(text[20]);readln(s);
hero.name:=s;
writeln(text[21]);
m:=0;
repeat begin//0.1
menu_key:=readkey;
case menu_key of//0.2
'1': begin hero.sex:=1;m:=1;end;//М
'2':begin hero.sex:=2;m:=1;end;//Ж
else
writeln(text[24]);
end;//0.2
end;//0.1
until m=1;
m:=0;
writeln(text[22]);
writeln(text[25]);
repeat begin//0.11
menu_key:=readkey;
case menu_key of//0.21
'1':begin  hero.race:=1;m:=1;end;//human
'2':begin hero.race:=2;m:=1;end;//not human
else
writeln(text[24]);
end;//0.21
end;//0.11
until m=1;

hero.stren:=1;
hero.intel:=1;
hero.agility:=1;
hero.init:=1;
hero.masking:=1;
hero.obser:=1;

hero.lvl:=1;

hero.hp:=10*hero.lvl;
hero.mp:=10*hero.lvl;
hero.exp:=0;


hero.veapon:=3;
hero.armor:=3;
hero.attak:=1;
hero.defense:=1;
hero.dmg:=hero.veapon*hero.attak;
hero.ign_dmg:=hero.armor*hero.defense;
hero.gold:=1;
end;//0

if h='hero' then begin //1
hero.name:='@sub_name';
hero.lvl:=1;

hero.hp:=10*hero.lvl;
hero.mp:=10*hero.lvl;
hero.exp:=0;


hero.veapon:=3;
hero.armor:=3;
hero.attak:=1;
hero.defense:=1;
hero.dmg:=hero.veapon*hero.attak;
hero.ign_dmg:=hero.armor*hero.defense;
hero.gold:=1;
//+16.08.2015
hero.sex:=1;
hero.race:=1;
hero.stren:=1;
hero.intel:=1;
hero.agility:=1;
hero.init:=1;
hero.masking:=1;
hero.obser:=1;
end;//1
if h='monster_human' then begin//2
monster.name:=name_generate('human');
monster.lvl:=(hero.lvl-1)+random(3);

monster.hp:=5*monster.lvl;
monster.mp:=5*monster.lvl;
monster.exp:=monster.lvl+random(monster.lvl);


monster.veapon:=1+random(monster.lvl);
monster.armor:=1+random(monster.lvl);
monster.attak:=1;
monster.defense:=1;
monster.dmg:=monster.veapon*monster.attak;
monster.ign_dmg:=monster.armor*monster.defense;
monster.gold:=monster.lvl+random(monster.lvl);
//+16.08.2015
monster.sex:=1;
monster.race:=1;
monster.stren:=1;
monster.intel:=1;
monster.agility:=1;
monster.init:=1;
monster.masking:=1;
monster.obser:=1;
end;//2
if h='monster_beast' then begin //3
monster.name:=name_generate('beast');
monster.lvl:=(hero.lvl-1)+random(3);

monster.hp:=5*monster.lvl;
monster.mp:=5*monster.lvl;
monster.exp:=monster.lvl+random(monster.lvl)+5;


monster.veapon:=1;
monster.armor:=1;
monster.attak:=1;
monster.defense:=1;
monster.dmg:=monster.veapon*monster.attak;
monster.ign_dmg:=monster.armor*monster.defense;
monster.gold:=0;
//+16.08.2015
monster.sex:=1;
monster.race:=2;
monster.stren:=1;
monster.intel:=1;
monster.agility:=1;
monster.init:=1;
monster.masking:=1;
monster.obser:=1;
end;//3
end;
procedure save;
begin
assign(hero_save,'hero.save');
rewrite(hero_save);
write(hero_save,hero);
close(hero_save);

assign(map_save,'map.save');
rewrite(map_save);
for i:=0 to 255 do begin//1.1
	for j:=0 to 255 do begin//1.2
write(map_save,map[i,j]);
end;end;//1.1//1.2
close(map_save);
writeln(text[18]);
readln();
end;
procedure load;
begin
assign(hero_save,'hero.save');
reset(hero_save);
read(hero_save,hero);
close(hero_save);

assign(map_save,'map.save');
reset(map_save);
for i:=0 to 255 do begin//1.1
	for j:=0 to 255 do begin//1.2
read(map_save,map[i,j]);
end;end;//1.1//1.2
close(map_save);
writeln(text[19]);
readln();
end;
procedure lvlup;
begin

if hero.exp>=hero.lvl*5 then begin//1
hero.exp:=hero.exp-hero.lvl*5;
hero.lvl:=hero.lvl+1;

hero.hp:=10*hero.lvl;
hero.mp:=10*hero.lvl;

hero.veapon:=3;
hero.armor:=3;
hero.attak:=1;
hero.defense:=1;
hero.dmg:=hero.veapon*hero.attak;
hero.ign_dmg:=hero.armor*hero.defense;
end;//1
end;
procedure battle;
begin
hero_generate('monster_beast');
i:=1;
repeat begin//1
clrscr;

writeln(text[14],': ',i);
writeln('-------------------------');
writeln('|',hero.name,'                    ', monster.name,'|');
writeln('|',text[5],'    ', text[5],'|');
writeln('|',hero.hp,'                    ', monster.hp,'|');
writeln('|',text[6],'          ', text[6],'|');
writeln('|',hero.mp,'                   ', monster.mp,'|');
writeln('|',text[12],'          ', text[12],'|');
writeln('|',hero.dmg ,'                    ',monster.dmg,'|');
writeln('-------------------------');
//writeln(text[13],hero.ign_dmg,'    ',monster.ign_dmg );
writeln(text[7],hero.exp );
writeln(text[8],hero.lvl );
i:=i+1;
hero.hp:=hero.hp-abs(monster.dmg-hero.ign_dmg);
monster.hp:=monster.hp-abs(hero.dmg-monster.ign_dmg);

delay(500);
end;//1
until (hero.hp<=0) or(monster.hp<=0);
if hero.hp<=0 then exit;
if monster.hp<=0 then begin//2
hero.gold:=hero.gold+monster.gold;
hero.exp:=hero.exp+monster.exp;
lvlup;

writeln(text[15]);
readln();

end;//2 
end;
procedure hero_output;
begin
clrscr;
writeln(text[5],' ',hero.hp );
writeln(text[6],hero.mp );
writeln(text[7],hero.exp );
writeln(text[8],hero.lvl );
writeln(text[12],hero.dmg );
writeln(text[13],hero.ign_dmg );
writeln(text[26],' ',hero.stren );// сила
writeln(text[27],' ',hero.intel );// интиллект
writeln(text[28],' ',hero.agility );// ловкость
writeln(text[29],' ',hero.sex );// пол
writeln(text[30],' ',hero.race );// расса
writeln(text[31],' ',hero.init );// инициатива
writeln(text[32],' ',hero.masking ); //маскировка
writeln(text[33],' ',hero.obser );// наблюдательность

writeln('       __');
writeln('      |  |  ');
writeln('  __  |__|  __');
writeln(' |  |  __  |  |');
writeln(' |  | |  | |  |');
writeln(' |__| |  | |__| ');
writeln('      |__|');
writeln('       __');
writeln('      |  |');
writeln('      |__|');
readln();
end;


procedure map_output(x,y:byte);
begin
repeat begin//2.0
clrscr;

for i:=x-5 to x+5 do begin//2.1
 for j:=y-5 to y+5 do begin//2.2
 write(map[i,j].structure);
 end;//2.2
 writeln('');
end;//2.1
writeln(x,' ',y);
writeln	('1- ->');
writeln	('2- <-');
writeln	('3- /\');
writeln	('4- \/');
writeln	('5- ',text[2]);
//readln(menu_key);
menu_key:=readkey;
end;//2.0

case menu_key of//3.0
'1':begin//3.1 
x:=x;y:=y+1; 
map_output(x,y);
end;//3.1
'2':begin//3.2
x:=x;y:=y-1; 
map_output(x,y);
 end;//3.2
'3':begin//3.3
x:=x-1;y:=y; 
map_output(x,y);
 end;//3.3
'4':begin//3.4
x:=x+1;y:=y;  
map_output(x,y);
 end;//3.4
end;//3.0
until menu_key='5';
end;

procedure main_menu;
begin

repeat begin//1
ClrScr;
writeln	('1- ',text[10]);
writeln	('2- ',text[9]);
writeln	('3- ',text[11]);
writeln	('4- ',text[17]);
writeln	('5- ',text[2]);
//readln(menu_key);
menu_key:=readkey;
case menu_key of
'1': begin //1.1
	hero_output;
	end;//1.1
'2':	begin//1.2
	map_output(128,128); main_menu;
	end;//1.2
'3':begin //1.3
battle;
end;//1.3
'4': begin//1.4
save;
end//1.4
end;
end;//2 
until menu_key='5';
end;

BEGIN
i:=0;
assign(lang,'text.lang');
reset(lang);
while not eof(lang) do begin
readln(lang,text[i]);
delete(text[i],1,3);
i:=i+1;
end;
close(lang);

writeln	(text[1]);
readln();
 ClrScr;
writeln	(text[3]);
writeln	('1-',text[4]);
writeln	('2-',text[16]);
writeln	('3-',text[2]);
//readln(menu_key);
menu_key:=readkey;
case menu_key of
'1': begin 
//â¥áâ®¢ ï £¥­¥à æ¨ï £¥à®ï генерация персонажа {~ 12.08.2015}
hero_generate('hero_new');
//â¥áâ®¢ ï £¥­¥à æ¨ï ª àâë {генерация карты }
simbol[0]:='.';
simbol[1]:='.';
simbol[2]:='#';
simbol[3]:='|';
simbol[4]:='.';
for i:=0 to 255 do begin//1.1
	for j:=0 to 255 do begin//1.2
	map[i,j].x:=i;
	map[i,j].y:=j;
	map[i,j].structure:=simbol[random(5)];
	end;//1.2
end;//1.1


main_menu; 
end;
'2':begin load; main_menu; end;
'3': exit
end;
END.


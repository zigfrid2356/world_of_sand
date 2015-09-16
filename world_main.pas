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
{v.0.023a}{10.09.2015}

program world_of_sand;

uses crt,sysutils,windows;

type//+21.08.2015
inventory =record
equip:byte;
types:byte;
name:string;
quality:integer;
cost:integer;
//+26.08.2015
i_name:string;
i_hp,i_mp:integer;
i_dmg,i_ign_dmg,i_veapon,i_armor,i_attak,i_defense:integer;
i_gold:integer;
i_stren,i_intel,i_agility,i_init,i_masking,i_obser:integer;
end;
body =record
name:string;
hp,mp,exp,lvl:integer;
//+10.08.2015
dmg,ign_dmg,veapon,armor,attak,defense:integer;
gold:integer;
//+15.08.2015
stren,intel,agility,sex,race,init,masking,obser:integer;
//+21.08.2015
slot_1,slot_2,slot_3,slot_4,slot_5:inventory;//inventory
//+06.09.2015
bag:array [0..9] of inventory;
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
color,har:text;
text:array[0..100] of string;
text_name:array[0..100] of string;
//+31.08.2015
color_name:array[0..1002] of string;
har_name:array[0..1000] of string;

hero_save:file of body;
map_save:file of erath;

simbol: array [0..12] of char;

//+27.08.2015
procedure equip (command:string;inv:inventory);
begin//+30.08.2015
if command='slot_1' then begin //1
hero.veapon:=hero.veapon+inv.i_veapon;
hero.armor:=hero.armor+inv.i_armor;
hero.attak:=hero.attak+inv.i_attak;
hero.defense:=hero.defense+inv.i_defense;
end;//1
if command='slot_2' then begin //2
hero.veapon:=hero.veapon+inv.i_veapon;
hero.armor:=hero.armor+inv.i_armor;
hero.attak:=hero.attak+inv.i_attak;
hero.defense:=hero.defense+inv.i_defense;
end;//2
if command='slot_3' then begin //3
hero.veapon:=hero.veapon+inv.i_veapon;
hero.armor:=hero.armor+inv.i_armor;
hero.attak:=hero.attak+inv.i_attak;
hero.defense:=hero.defense+inv.i_defense;
end;//3
if command='slot_4' then begin //4
hero.veapon:=hero.veapon+inv.i_veapon;
hero.armor:=hero.armor+inv.i_armor;
hero.attak:=hero.attak+inv.i_attak;
hero.defense:=hero.defense+inv.i_defense;
end;//4
if command='slot_5' then begin //5
hero.veapon:=hero.veapon+inv.i_veapon;
hero.armor:=hero.armor+inv.i_armor;
hero.attak:=hero.attak+inv.i_attak;
hero.defense:=hero.defense+inv.i_defense;
end;//5
end;


function inventory_generation(command,name_ig:string;lvl:integer):inventory;
begin
if command='veapon' then begin //1
inventory_generation.equip:=0;
inventory_generation.types:=1;
inventory_generation.name:='veapon';
inventory_generation.quality:=10*lvl;
inventory_generation.cost:=1+lvl;
//+30.08.2015
inventory_generation.i_veapon:=random(lvl)+random(lvl)+1;
inventory_generation.i_armor:=0;
inventory_generation.i_attak:=random(lvl)+1;
inventory_generation.i_defense:=0;
end;//1
if command='armor' then begin//2 
inventory_generation.equip:=0;
inventory_generation.types:=2;
inventory_generation.name:='armor';
inventory_generation.quality:=10*lvl;
inventory_generation.cost:=1+lvl;
//+30.08.2015
inventory_generation.i_veapon:=0;
inventory_generation.i_armor:=random(lvl)+random(lvl)+1;
inventory_generation.i_attak:=0;
inventory_generation.i_defense:=random(lvl)+1;
end;//2
if command='jewel' then begin//3
inventory_generation.equip:=0;
inventory_generation.types:=3;
inventory_generation.name:='jewel';
inventory_generation.quality:=10*lvl;
inventory_generation.cost:=1+lvl;
//+30.08.2015
inventory_generation.i_veapon:=0;
inventory_generation.i_armor:=0;
inventory_generation.i_attak:=0;
inventory_generation.i_defense:=0;
 end;//3
if command='ingredient' then begin//4
inventory_generation.equip:=0;
inventory_generation.types:=4;
inventory_generation.name:='ingredient';
inventory_generation.quality:=10*lvl;
inventory_generation.cost:=1+lvl;
inventory_generation.name:=name_ig;
//+30.08.2015
inventory_generation.i_veapon:=0;
inventory_generation.i_armor:=0;
inventory_generation.i_attak:=0;
inventory_generation.i_defense:=0;
 end;//4
 //+06.09.2015
 if command='nul' then begin//4
inventory_generation.equip:=0;
inventory_generation.types:=0;
inventory_generation.name:='';
inventory_generation.quality:=0;
inventory_generation.cost:=0;
inventory_generation.i_veapon:=0;
inventory_generation.i_armor:=0;
inventory_generation.i_attak:=0;
inventory_generation.i_defense:=0;
 end;//4
end;
//+06.09.2015
procedure drop(command0,command1:string);
begin
if command0='monster_beast' then begin//1
for i:=0 to 9 do begin//2
if hero.bag[i].types=0 then begin hero.bag[i]:=inventory_generation('ingredient',command1,hero.lvl); exit; end;

end;//2
end;//1
end;
function name_generate(command:string):string;//+12.08.2015
var
s:string;
begin
s:='monster_'+command+'_win.name';//+01.09.2015

assign(monster_name,s);
reset(monster_name);
m:=1;
while not eof(monster_name) do begin//1.1
readln(monster_name,text_name[m]);
m:=m+1;
end;//1.1
close(monster_name);
//+31.08.2015
assign(color,'color');
reset(color);
n:=1;
while not eof(color) do begin//1.1
readln(color,color_name[n]);
n:=n+1;
end;//1.1
close(color);
//
assign(har,'har');
reset(har);
i:=1;
while not eof(har) do begin//1.1
readln(har,har_name[i]);
i:=i+1;
end;//1.1
close(har);

name_generate:=har_name[random(i)]+' '+text_name[random(m)]+' '+color_name[random(n)];
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
hero.attak:=3;
hero.defense:=3;
hero.dmg:=hero.veapon*hero.attak;
hero.ign_dmg:=hero.armor*hero.defense;
hero.gold:=1;
//
hero.slot_1:=inventory_generation('armor','',hero.lvl);
hero.slot_2:=inventory_generation('armor','',hero.lvl);
hero.slot_3:=inventory_generation('armor','',hero.lvl);
hero.slot_4:=inventory_generation('veapon','',hero.lvl);
hero.slot_5:=inventory_generation('armor','',hero.lvl);
//+30.08.2015
equip ('slot_1',hero.slot_1);
equip ('slot_2',hero.slot_2);
equip ('slot_3',hero.slot_3);
equip ('slot_4',hero.slot_4);
equip ('slot_5',hero.slot_5);
//+06.09.2015
for n:=0 to 9 do begin//0.1
hero.bag[n]:=inventory_generation('nul','',hero.lvl);end;//0.1
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
//+21.08.2015
hero.slot_1:=inventory_generation('armor','',hero.lvl);
hero.slot_2:=inventory_generation('armor','',hero.lvl);;
hero.slot_3:=inventory_generation('armor','',hero.lvl);;
hero.slot_4:=inventory_generation('veapon','',hero.lvl);;
hero.slot_5:=inventory_generation('armor','',hero.lvl);
end;//1
if h='monster_human' then begin//2
monster.name:=name_generate('human');
monster.lvl:=(hero.lvl-1)+random(3);

monster.hp:=(5+random(monster.lvl))*monster.lvl;
monster.mp:=5*monster.lvl;
monster.exp:=monster.lvl+random(monster.lvl);


monster.veapon:=1+random(monster.lvl);
monster.armor:=1+random(monster.lvl);
monster.attak:=1+random(monster.lvl);
monster.defense:=1+random(monster.lvl);
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
//+21.08.2015
monster.slot_1:=inventory_generation('armor','',monster.lvl);
monster.slot_2:=inventory_generation('armor','',monster.lvl);
monster.slot_3:=inventory_generation('armor','',monster.lvl);
monster.slot_4:=inventory_generation('veapon','',monster.lvl);
monster.slot_5:=inventory_generation('armor','',monster.lvl);
end;//2
if h='monster_beast' then begin //3
monster.name:=name_generate('beast');
monster.lvl:=(hero.lvl-1)+random(3);

monster.hp:=5*monster.lvl;
monster.mp:=5*monster.lvl;
monster.exp:=monster.lvl+random(monster.lvl)+5;


monster.veapon:=1+random(monster.lvl+1);
monster.armor:=2+random(monster.lvl+1);
monster.attak:=1+random(monster.lvl+1);
monster.defense:=1+random(monster.lvl+1);
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
//+21.08.2015
monster.slot_1:=inventory_generation('armor','',monster.lvl);
monster.slot_2:=inventory_generation('armor','',monster.lvl);
monster.slot_3:=inventory_generation('armor','',monster.lvl);
monster.slot_4:=inventory_generation('veapon','',monster.lvl);
monster.slot_5:=inventory_generation('armor','',monster.lvl);
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

hero.hp:=abs(hero.hp)+(10*hero.lvl)+random(hero.lvl);
hero.mp:=10*hero.lvl;

hero.veapon:={hero.veapon+}random(hero.lvl);
hero.armor:=hero.armor+random(hero.lvl);
hero.attak:=hero.attak+(1*hero.lvl);
hero.defense:=hero.defense+(1*hero.lvl);
hero.dmg:=hero.veapon+hero.attak;
hero.ign_dmg:=hero.armor*hero.defense;
end;//1
end;
procedure battle;
var i0:integer;
begin
i0:=0;
repeat begin//0

hero_generate('monster_beast');
i:=1;
repeat begin//1
clrscr;
writeln(text[36], i0);
i0:=i0+1;
writeln(text[35]);
writeln(text[14],': ',i);
writeln('-------------------------');
writeln('|',hero.name,'           ', monster.name,'|');
writeln('|',text[5],'             ', text[5],'|');
writeln('|',hero.hp,'             ', monster.hp,'|');
writeln('|',text[6],'             ', text[6],'|');
writeln('|',hero.mp,'             ', monster.mp,'|');
writeln('|',text[12],'            ', text[12],'|');
writeln('|',hero.dmg ,'           ',monster.dmg,'|');
writeln('-------------------------');
//writeln(text[13],hero.ign_dmg,'    ',monster.ign_dmg );
writeln(text[7],hero.exp );
writeln(text[8],hero.lvl );
i:=i+1;
if monster.dmg>=hero.ign_dmg then hero.hp:=hero.hp-abs(monster.dmg-hero.ign_dmg) else hero.hp:=hero.hp-(monster.dmg div 4);
monster.hp:=monster.hp-abs(hero.dmg-monster.ign_dmg);
//writeln('-------------------');
//writeln(text[37],abs(monster.dmg-hero.ign_dmg));
//writeln(text[38],abs(hero.dmg-monster.ign_dmg));
//writeln('-------------------');
//readln();
delay(500);
end;//1
until (hero.hp<=0) or(monster.hp<=0);
if hero.hp<=0 then exit;
if monster.hp<=0 then begin//2
hero.gold:=hero.gold+monster.gold;
hero.exp:=hero.exp+monster.exp;
drop('monster_beast',monster.name);
lvlup;

writeln(text[15]);
delay(500);

//readln();

end;//2 
end;//0
until readkey='1';
end;
function item_info(i_t:byte):string;
begin
if i_t= 0 then  item_info:=text[50];
if i_t= 1 then  item_info:=text[46];
if i_t= 2 then  item_info:=text[47];
if i_t= 3 then  item_info:=text[48];
if i_t= 4 then  item_info:=text[49];
end;
procedure bag_info;
begin
clrscr;
writeln(text[45]);
for i:=0 to 9 do begin//1
if hero.bag[i].types <> 0 then writeln(text[44],' ',i,' ',hero.bag[i].name,' ',item_info(hero.bag[i].types));

end;//1
writeln(text[35]);
end;
procedure hero_output;
begin
clrscr;
writeln();
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

writeln('        ___');
writeln('       |_1_|       1',text[40],' ',hero.slot_1.i_armor);
writeln('  ___   ___   ___  2',text[40],' ',hero.slot_2.i_armor);
writeln(' | 4 | |   | | 5 | 4',text[41],' ',hero.slot_4.i_veapon);
writeln(' |___| | 2 | |___| 5',text[40],' ',hero.slot_5.i_armor);
writeln('       |___|');
writeln('        ___');
writeln('       |_3_|       3',text[40],' ',hero.slot_3.i_armor);
//+06.09.2015
writeln(text[43]);
writeln(text[35]);
repeat begin//1
menu_key:=readkey;

case menu_key of
'2':bag_info;
end;//2
end;
until menu_key='1';

end;


procedure map_output(x,y:byte);
var
temp_char:char;
begin
temp_char:=map[x,y].structure;
map[x,y].structure:='@';
if (x-1>=6) and(x+1<=249) and (y-1>=11) and (y+1<=244) then begin//2.00

repeat begin//2.0
clrscr;
writeln(' _____________________');//top
for i:=x-5 to x+5 do begin//2.1
write('|');//left
 for j:=y-10 to y+10 do begin//2.2
 if write(map[i,j].structure)='.' 
 then 
 textcolor(yellow);
 write(map[i,j].structure);
 end;//2.2
 writeln('|');//right
end;//2.1
 writeln(' ---------------------');
map[x,y].structure:=temp_char;//+16.08.2015 
writeln(text[34],' ',x,' : ',y);
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
x:=x;
if y+1<=244 then y:=y+1 else y:=y;
map_output(x,y);
end;//3.1
'2':begin//3.2
x:=x;
if y-1>=11 then y:=y-1 else y:=y;
map_output(x,y);
 end;//3.2
'3':begin//3.3
if x-1>=6 then x:=x-1 else x:=x;
y:=y; 
map_output(x,y);
 end;//3.3
'4':begin//3.4
if x+1<=249 then x:=x+1 else x:=x;
y:=y;  
map_output(x,y);
 end;//3.4
end;//3.0
until menu_key='5';
end;//2.00 else mapgenerate(new,'/\')
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
writeln	('6- ',text[42]);
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
end;//1.4
'6':begin//1.5
//+30.08.2015
hero.slot_1:=inventory_generation('armor','',hero.lvl);
hero.slot_2:=inventory_generation('armor','',hero.lvl);
hero.slot_3:=inventory_generation('armor','',hero.lvl);
hero.slot_4:=inventory_generation('veapon','',hero.lvl);
hero.slot_5:=inventory_generation('armor','',hero.lvl);

equip ('slot_1',hero.slot_1);
equip ('slot_2',hero.slot_2);
equip ('slot_3',hero.slot_3);
equip ('slot_4',hero.slot_4);
equip ('slot_5',hero.slot_5);
end;//1.5
end;
end;//2 
until menu_key='5';

end;
//-------------------------
//+20.08.2015
{
win cp866 text_win.lang
unix utf-8 text.lang
}
//--------------------------------
BEGIN
i:=0;
assign(lang,'text_win.lang');
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
//������� ���ᮭ���
hero_generate('hero_new');
//â¥áâ®¢ ï £¥­¥à æ¨ï ª àâë {генерация карты }
//������� �����
simbol[0]:='.';
simbol[1]:=':';
simbol[2]:=';';
simbol[3]:='#';
simbol[4]:='/';
simbol[5]:='"';
simbol[6]:='0';
simbol[7]:='~';
simbol[8]:='!';
simbol[9]:='_';
simbol[10]:='-';
simbol[11]:='=';
simbol[12]:='^';

for i:=0 to 255 do begin//1.1
	for j:=0 to 255 do begin//1.2
	map[i,j].x:=i;
	map[i,j].y:=j;
	map[i,j].structure:=simbol[random(12)+1];
	end;//1.2
end;//1.1


main_menu; 
end;
'2':begin load; main_menu; end;
'3': exit
end;
END.


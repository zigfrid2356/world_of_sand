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

uses crt,sysutils,windows,dateutils;

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
x,y:integer;
structure:char;
color:integer;
end;
var
map:array[0..2048,0..2048] of erath;
hero:body;
monster:body;
menu_key:char;
i,j,n,m,l,k,k0,k1:integer;//áçñâç¨ª¨{счётчики}
s:string;//temp
lang: text;
monster_name:text;
color,har:text;
f_log:text;
text:array[0..100] of string;
text_name:array[0..100] of string;
//+31.08.2015
color_name:array[0..1002] of string;
har_name:array[0..1000] of string;

hero_save:file of body;
map_save:file of erath;

simbol: array [0..12] of char;
fmt:string='dd/mm/yyyy hh:nn:ss.zzz';
//+24.09.2015
const 
x_map = 2048;
y_map = 2048;

procedure log_generate(command:string;text:string);
begin;
if command='log_new_generate' then begin//1
assign(f_log,'log.txt');
rewrite(f_log);
writeln(f_log,formatdatetime(fmt,now)+' '+text);
close(f_log);
end;//1
if command='log_old_generate' then begin//1
assign(f_log,'log.txt');
append(f_log);
writeln(f_log,formatdatetime(fmt,now)+' '+text);
close(f_log);
end;//1
end;
//+16.09.2015

procedure map_generate(command:string);
begin
simbol[0]:='.';//colore[0]:=1;colore[13]:=13;
simbol[1]:=':';//colore[1]:=1;colore[14]:=14;
simbol[2]:=';';//colore[2]:=2;colore[15]:=15;
simbol[3]:='#';//colore[3]:=3;
simbol[4]:='/';//colore[4]:=4;
simbol[5]:='"';//colore[5]:=5;
simbol[6]:='0';//colore[6]:=6;
simbol[7]:='~';//colore[7]:=7;
simbol[8]:='!';//colore[8]:=8;
simbol[9]:='_';//colore[9]:=9;
simbol[10]:='-';
simbol[11]:='=';
simbol[12]:='^';
if command='map_new_generate' then begin//1
for i:=0 to x_map do begin//1.1
	for j:=0 to y_map do begin//1.2
	map[i,j].x:=i;
	map[i,j].y:=j;
	n:=random(13);
	map[i,j].structure:=simbol[n];
	if (n=0) or (n=1) or (n=2) or (n=3) then map[i,j].color:=14;
	if n=4 then map[i,j].color:=6;
	if (n=5) or (n=8) then map[i,j].color:=2;
	if (n=6) or (n=7) then map[i,j].color:=1;
	if (n=9) or (n=10) or (n=11) then map[i,j].color:=7;
	if n=12 then map[i,j].color:=8;  
	end;//1.2
end;//1.1
end;//1
if command='map_test_generate' then begin//2
//+17.09.2015
//���믪� ��᪮�
//---------------
for i:=0 to x_map do begin//2.1
	for j:=0 to y_map do begin//2.2
	map[i,j].x:=i;
	map[i,j].y:=j;	
	map[i,j].structure:=simbol[0];
	map[i,j].color:=14;
		end;//2.2
end;//2.1
//---------------
for i:=0 to 1000 do begin//3 
//+18.09.2015
//���� �������

n:=random(x_map);
m:=random(y_map);
map[n,m].structure:=simbol[6];
map[n,m].color:=1;
//1 ���
k:=random(113); if k<13 then begin map[n-1,m-1].structure:=simbol[8];map[n-1,m-1].color:=2;end; if (k>13) and (k<38) then begin map[n-1,m-1].structure:=simbol[5];map[n-1,m-1].color:=2; end else begin map[n-1,m-1].structure:=simbol[3];map[n-1,m-1].color:=14; end;
k:=random(113); if k<13 then begin map[n-1,m].structure:=simbol[8];map[n-1,m].color:=2;end; if (k>13) and (k<38) then begin map[n-1,m].structure:=simbol[5];map[n-1,m].color:=2; end else begin map[n-1,m].structure:=simbol[3];map[n-1,m].color:=14; end;
k:=random(113); if k<13 then begin map[n-1,m+1].structure:=simbol[8];map[n-1,m+1].color:=2;end; if (k>13) and (k<38) then begin map[n-1,m+1].structure:=simbol[5];map[n-1,m+1].color:=2; end else begin map[n-1,m+1].structure:=simbol[3];map[n-1,m+1].color:=14;end;
k:=random(113); if k<13 then begin map[n,m-1].structure:=simbol[8];map[n,m-1].color:=2;end; if (k>13) and (k<38) then begin map[n,m-1].structure:=simbol[5];map[n,m-1].color:=2; end else begin map[n,m-1].structure:=simbol[3];map[n,m-1].color:=14;end;
k:=random(113); if k<13 then begin map[n,m+1].structure:=simbol[8];map[n,m+1].color:=2;end; if (k>13) and (k<38) then begin map[n,m+1].structure:=simbol[5];map[n,m+1].color:=2; end else begin map[n,m+1].structure:=simbol[3];map[n,m+1].color:=14;end;
k:=random(113); if k<13 then begin map[n+1,m-1].structure:=simbol[8];map[n+1,m-1].color:=2;end; if (k>13) and (k<38) then begin map[n+1,m-1].structure:=simbol[5];map[n+1,m-1].color:=2; end else begin map[n+1,m-1].structure:=simbol[3];map[n+1,m-1].color:=14;end;
k:=random(113); if k<13 then begin map[n+1,m].structure:=simbol[8];map[n+1,m].color:=2;end; if (k>13) and (k<38) then begin map[n+1,m].structure:=simbol[5];map[n+1,m].color:=2; end else begin map[n+1,m].structure:=simbol[3];map[n+1,m].color:=14;end;
k:=random(113); if k<13 then begin map[n+1,m+1].structure:=simbol[8];map[n+1,m+1].color:=2;end; if (k>13) and (k<38) then begin map[n+1,m+1].structure:=simbol[5];map[n+1,m+1].color:=2; end else begin map[n+1,m+1].structure:=simbol[3];map[n+1,m+1].color:=14;end;
//

//2 ���
for l:=m-2 to m+2 do begin//3.1
k:=random(100);
if k<50 then begin//3.1.1
map[n-2,l].structure:=simbol[3];
map[n-2,l].color:=14;
end;//3.1.1
if (k>50) and (k<57) then begin//3.1.2
map[n-2,l].structure:=simbol[5];
map[n-2,l].color:=2;
end;//3.1.2
if (k>57)and (k<86) then begin//3.1.3
map[n-2,l].structure:=simbol[4];
map[n-2,l].color:=6;
end;//3.1.3
end;//3.1 
//--
for l:=m-2 to m+2 do begin//3.2
k:=random(100);
if k<50 then begin//3.2.1
map[n+2,l].structure:=simbol[3];
map[n+2,l].color:=14;
end;//3.2.1
if (k>50) and (k<57) then begin//3.2.2
map[n+2,l].structure:=simbol[5];
map[n+2,l].color:=2;
end;//3.2.2
if (k>57)and (k<86) then begin//3.2.3
map[n+2,l].structure:=simbol[4];
map[n+2,l].color:=6;
end;//3.2.3
end;//3.2
//--
for l:=n-2 to n+2 do begin//3.3
k:=random(100);
if k<50 then begin//3.3.1
map[l,m+2].structure:=simbol[3];
map[l,m+2].color:=14;
end;//3.3.1
if (k>50) and (k<57) then begin//3.3.2
map[l,m+2].structure:=simbol[5];
map[l,m+2].color:=2;
end;//3.3.2
if (k>57)and (k<86) then begin//3.3.3
map[l,m+2].structure:=simbol[4];
map[l,m+2].color:=6;
end;//3.3.3
end;//3.3
//--
for l:=n-2 to n+2 do begin//3.4
k:=random(100);
if k<50 then begin//3.4.1
map[l,m-2].structure:=simbol[3];
map[l,m-2].color:=14;
end;//3.4.1
if (k>50) and (k<57) then begin//3.4.2
map[l,m-2].structure:=simbol[5];
map[l,m-2].color:=2;
end;//3.4.2
if (k>57)and (k<86) then begin//3.4.3
map[l,m-2].structure:=simbol[4];
map[l,m-2].color:=6;
end;//3.4.3
end;//3.4
//3 ���----------------------------------------
for l:=m-3 to m+3 do begin//4.1
k:=random(100);
if k<30 then begin//4.1.1
map[n-3,l].structure:=simbol[3];
map[n-3,l].color:=14;
end;//4.1.1
if (k>30) and (k<43) then begin//4.1.2
map[n-3,l].structure:=simbol[4];
map[n-3,l].color:=6;
end;//4.1.2
if (k>43)and (k<45) then begin//4.1.3
map[n-3,l].structure:=simbol[10];
map[n-3,l].color:=7;
end;//4.1.3
end;//4.1 
//--
for l:=m-3 to m+3 do begin//4.2
k:=random(100);
if k<30 then begin//4.2.1
map[n+3,l].structure:=simbol[3];
map[n+3,l].color:=14;
end;//4.2.1
if (k>30) and (k<43) then begin//4.2.2
map[n+3,l].structure:=simbol[4];
map[n+3,l].color:=6;
end;//4.2.2
if (k>43)and (k<45) then begin//4.2.3
map[n+3,l].structure:=simbol[10];
map[n+3,l].color:=7;
end;//4.2.3
end;//4.2
//--
for l:=n-3 to n+3 do begin//4.3
k:=random(100);
if k<30 then begin//4.3.1
map[l,m+3].structure:=simbol[3];
map[l,m+3].color:=14;
end;//4.3.1
if (k>30) and (k<43) then begin//4.3.2
map[l,m+3].structure:=simbol[4];
map[l,m+3].color:=6;
end;//4.3.2
if (k>43)and (k<45) then begin//4.3.3
map[l,m+3].structure:=simbol[10];
map[l,m+3].color:=7;
end;//4.3.3
end;//4.3
//--
for l:=n-3 to n+3 do begin//4.4
k:=random(100);
if k<30 then begin//4.4.1
map[l,m-3].structure:=simbol[3];
map[l,m-3].color:=14;
end;//4.4.1
if (k>30) and (k<43) then begin//4.4.2
map[l,m-3].structure:=simbol[5];
map[l,m-3].color:=2;
end;//4.4.2
if (k>43)and (k<45) then begin//4.4.3
map[l,m-3].structure:=simbol[10];
map[l,m-3].color:=7;
end;//4.4.3
end;//4.4  
end;//3
for l:=0 to 1000 do begin//5 
//+22.10.2015
//���� ����뭭�� ࠢ����
repeat
begin
n:=random(x_map);
m:=random(y_map);
end;
until (n>8)and(n<x_map-8)and(m>8)and(m<y_map-8);

//4-���
for i:=n-8 to n+8 do begin//5.1
	for j:=m-8 to m+8 do begin//5.2
	k:=random(1);
	k0:=random(10);
	if k0=3 then begin //5.2.1
	map[i,j].structure:=simbol[4];
	map[i,j].color:=6;
	end;//5.2.1 
	if k=0 then begin //5.2.2
	map[i,j].structure:=simbol[3];
	map[i,j].color:=14;
	end//5.2.2 
	else begin//5.2.2.1
	map[i,j].structure:=simbol[0];
	map[i,j].color:=14;	
	end;//5.2.2.1
	end;//5.1
	end;//5.2
//3-cryg
for i:=n-6 to n+6 do begin//5.1
	for j:=m-6 to m+6 do begin//5.2
	k:=random(10);
	k0:=random(10);
	if (k0=3)or (k0=4)  then begin //5.2.1
	map[i,j].structure:=simbol[4];
	map[i,j].color:=6;
	end;//5.2.1 
	if k0=5 then begin //5.3.1
	map[i,j].structure:=simbol[5];
	map[i,j].color:=2;
	end;//5.3.1 	
	if k<8 then begin //5.2.2
	map[i,j].structure:=simbol[3];
	map[i,j].color:=14;
	end//5.2.2 
	else begin//5.2.2.1
	map[i,j].structure:=simbol[0];
	map[i,j].color:=14;	
	end;//5.2.2.1
	end;//5.1
	end;//5.2

end;//5
end;//2
if command='map_story_generate' then begin//3
//�������� �����
//+24.09.2015
log_generate('log_new_generate','~ \/ (water)');
for i:=0 to x_map do begin//3.1
	for j:=0 to y_map do begin//3.2
	map[i,j].x:=i;
	map[i,j].y:=j;	
	map[i,j].structure:=simbol[7];
	map[i,j].color:=1;
		end;//3.2
	end;//3.1
	m:=random(3)+1;
	log_generate('log_old_generate',inttostr(m)+' # (land)');
for n:=0 to m do begin//3.3

repeat l:=random(x_map); until (l>400) and (l<x_map-400); log_generate('log_old_generate',inttostr(l)+' x (land)');
repeat k:=random(y_map); until (k>400) and (k<y_map-400); log_generate('log_old_generate',inttostr(k)+' y (land)');
for i:=l-300 to l+300 do begin//3.3.1
	for j:=k-300 to k+300 do begin//3.3.2
	map[i,j].x:=i;
	map[i,j].y:=j;	
	map[i,j].structure:=simbol[3];
	map[i,j].color:=14;
		end;//3.3.2
	end;//3.3.1
end;//3.3
end;//3
end;

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
s:='res\mob\monster_'+command+'_win.name';//+01.09.2015

assign(monster_name,s);
reset(monster_name);
m:=1;
while not eof(monster_name) do begin//1.1
readln(monster_name,text_name[m]);
m:=m+1;
end;//1.1
close(monster_name);
//+31.08.2015
assign(color,'res\har\color');
reset(color);
n:=1;
while not eof(color) do begin//1.1
readln(color,color_name[n]);
n:=n+1;
end;//1.1
close(color);
//
assign(har,'res\har\har');
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
assign(hero_save,'res\save\hero.save');
rewrite(hero_save);
write(hero_save,hero);
close(hero_save);

assign(map_save,'res\save\map.save');
rewrite(map_save);
for i:=0 to x_map do begin//1.1
	for j:=0 to y_map do begin//1.2
write(map_save,map[i,j]);
end;end;//1.1//1.2
close(map_save);
writeln(text[18]);
readln();
end;
procedure load;
begin
assign(hero_save,'res\save\hero.save');
reset(hero_save);
read(hero_save,hero);
close(hero_save);

assign(map_save,'res\save\map.save');
reset(map_save);
for i:=0 to x_map do begin//1.1
	for j:=0 to y_map do begin//1.2
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
writeln('|',hero.name,'           ', monster.name,'|');log_generate('log_old_generate','monster.name '+monster.name);
writeln('|',text[5],'             ', text[5],'|');
writeln('|',hero.hp,'             ', monster.hp,'|');log_generate('log_old_generate','monster.hp '+inttostr(monster.hp));
writeln('|',text[6],'             ', text[6],'|');
writeln('|',hero.mp,'             ', monster.mp,'|');
writeln('|',text[12],'            ', text[12],'|');
writeln('|',hero.dmg ,'           ',monster.dmg,'|');log_generate('log_old_generate','monster.dmg '+inttostr(monster.dmg));
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


procedure map_output(x,y:integer);
var
temp_char:char;
temp_color:integer;
begin

temp_char:=map[x,y].structure;
temp_color:=map[x,y].color;
map[x,y].structure:='@';
map[x,y].color:=4;
if (x-1>=6) and(x+1<=x_map-6) and (y-1>=11) and (y+1<=y_map-11) then begin//2.00

repeat begin//2.0
clrscr;
textcolor(white);
writeln(' _____________________');//top
for i:=x-5 to x+5 do begin//2.1//5
write('|');//left
 for j:=y-10 to y+10 do begin//2.2//10
 textcolor(map[i,j].color);
 write(map[i,j].structure);
 textcolor(white);
 end;//2.2
 writeln('|');//right
end;//2.1
 writeln(' ---------------------');
map[x,y].structure:=temp_char;//+16.08.2015 
map[x,y].color:=temp_color;//+16.09.2015
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
if y+1<={244}2037 then y:=y+1 else y:=y;
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
if x+1<={249}2042 then x:=x+1 else x:=x;
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
assign(lang,'res\lang\rus\text_win.lang');
reset(lang);
while not eof(lang) do begin
readln(lang,text[i]);

delete(text[i],1,3);
i:=i+1;
end;
close(lang);
textcolor(yellow);
writeln	(text[1]);
textcolor(white);
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
//map_generate('map_new_generate');
map_generate('map_test_generate');

main_menu; 
end;
'2':begin load; main_menu; end;
'3': exit
end;
END.


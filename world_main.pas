{
		world_main.pas

		Copyright 2015 Alexander Fedotov <zigfridone@gmail.com>

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
{v.0.33a}{25.11.2016}

program world_of_sand;
{//$O+}
{//$FPUTYPE SSE2}
 {//$IFDEF WIN32}
//{$APPTYPE Console}

{//$SMARTLINK+}
{//$S+}
{//$STACKFRAMES+}
{//$MEMORY 524288,524288}
uses sysutils,linux,crt{,windows},dateutils,Zipper,gen;
{//$mmx+}
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
hp,mp,exp,lvl,x,y:integer;
//+10.08.2015
dmg,ign_dmg,veapon,armor,attak,defense:integer;
gold:integer;
//+15.08.2015
stren,intel,agility,sex,race,init,masking,obser:word;
//+21.08.2015
slot_1,slot_2,slot_3,slot_4,slot_5:inventory;//inventory
//+06.09.2015
bag:array [0..9] of inventory;
//+25.10.2015
typ,clas,podclas,podtyp:byte;

end;
subject=record//+05.11.2015
name,type_subject:string[50];
base_dmg,base_defense,ves,cost,tip:word;{tip=1-weapon,2-armor...}
stren,intel,agility,hp,mp:word;//+29.02.2016
init,masking,obser:word;
end;
quest=record
red:byte;
st:array[0..5]of string[75];
x,y:word;
end;
new_body =record//+05.11.2015
//ocnov
name:string[100];
stren,intel,agility,sex,race:word;
{race= 1-human,2-ork,3-elf,4-dwarf,5-undead,6-skeleton,7-ghost}
//vichisl
hp,mp:smallint;
attak,defense,ves:word;
//obnov
exp,lvl,gold,x,y,xd,yd:word;
init,masking,obser:word;
point:byte;
//boev
dmg,ign_dmg:integer;
//invent
s:array[1..5]of subject;
j:array[0..4]of subject;{0,1-ring,2,3-link,4-amulet}

//bag
bag:array[0..99] of subject;
//story
st0,st1,st2,st3:string[100];
//quest
quest_activ:quest;
quest_flag:boolean;
//prof
prof:array[0..9]of byte;
//magic
//+ 30.05.2016
magic:array[0..3]of byte;
end;
beast_body=record
hp,dmg,ign_dmg:integer;
name:string;
flag_life,flag_hishn:byte;
x,y:word;
skin,meat,teeth,bones,clutches:subject;
end;

erath =record
x,y,npc_index,beast_index,mob_index:word;
structure:char;
color:byte;
name:string[25];
tip:byte;//flag_life__beast(1/2)_human(3/4)_not_life(0)_dead-beast(5)_dead-mob(6)
progress:word;
end;
mini_erath=record
x,y:word;
structure:char;
color:byte;
name:string[2];
ver:byte;
end;
oz_index=record
x,y:word;
oz_name:string[25];
end;
//19.11.2015
pyst_index=record
x,y:word;
end;
temp=record
nb1,nb2:new_body;
end;
spell=record
name:string;
k0,k1,k2,k3:byte;
min_mana:word;
end;
var
magic:array[0..99]of spell;
map:array[0..2048,0..2048] of erath;
mini_map,dungeons:array[0..204,0..204]of mini_erath;
//out_map:array[0..9,0..19]of char;
hero:new_body;
//super:new_body;
monster:body;
npc:array[0..17000] of new_body;
max_npc:word;
//28.01.2016
mob:array[0..10000] of new_body;
//21.02.2016
temp_battle,mob_temp:temp;
menu_key:char;
i,j,n,m,l,k,k0,k1,k2,k_oz,i_oz,j_oz,n_oz,m_oz:integer;//áçñâç¨ª¨{счётчики}
s:string;//temp
lang,lang_f: text;
hf,st,qst:text;
monster_name,map_oz:text;
color,har,item_name,spell_f:text;
f_log:text;
f_typ:text;//+25.10.2015
prof:text;//21.02.2016
text:array[0..200] of string[100];
text_name:array[0..100] of string[100];
//+31.08.2015
color_name:array[0..1002] of string[100];
har_name:array[0..1000] of string[100];
//+03.11.2015
map_name:array[0..1000] of string[100];
//+03.03.2016
quest_st:quest;
//+08.11.2015
oz_list:array [0..100] of oz_index;
//+19.11.2015
pyst_list:array[0..1000] of pyst_index;
//04.03.2016
room_list:array[0..9] of pyst_index;
//+16.11.2015
beast_list:array[0..10000]of beast_body;
hero_save:file of new_body;
map_save:file of erath;
npc_save,mob_save:file of new_body;
beast_save:file of beast_body;
oz_save:file of oz_index;
pyst_save:file of pyst_index;
simbol: array [0..12] of char;
fmt:string='dd/mm/yyyy hh:nn:ss.zzz';
//+25.10.2015
s_typ{,s_clas,s_podclas}:array[0..9]of string;
s_podtyp:array[0..50]of string;
//+02.01.2016
lang_s:string[5];
//20.02.2016/+05.04.2016
log:string[10];
dangeons_flag:boolean;


//+24.09.2015
const
x_map = 2048;
y_map = 2048;
npc_max =32768;
progress_max=100;

{
//+07.11.2015
function dialog(s_in:string):string;
begin

end;}

//25.05.2016
procedure magic_load;
var mls:string;
begin
if lang_s='w_rus' then assign(spell_f,'res\magic\magic_w_rus');
if lang_s='u_rus' then assign(spell_f,'res/magic/magic_u_rus');
if lang_s='w_eng' then assign(spell_f,'res\magic\magic_w_eng');
if lang_s='u_eng' then assign(spell_f,'res/magic/magic_u_eng');
reset(spell_f);
n:=0;
while not eof(spell_f) do begin//1.1
readln(spell_f,magic[n].name);
readln(spell_f,mls);
magic[n].k0:=strtoint(mls);
readln(spell_f,mls);
magic[n].k1:=strtoint(mls);
readln(spell_f,mls);
magic[n].k2:=strtoint(mls);
readln(spell_f,mls);
magic[n].k3:=strtoint(mls);
readln(spell_f,mls);
magic[n].min_mana:=strtoint(mls);
n:=n+1;
end;//1.1
close(spell_f);
end;

function magic_out_info(no:word):string;
begin
magic_out_info:=magic[no].name;
end;

function magic_use_spell(mus:temp):temp;
begin
magic_use_spell.nb1:=mus.nb1;
magic_use_spell.nb2:=mus.nb2;
end;

procedure log_generate(command:string;text:string);
begin;
if command='log_new_generate' then begin//1
assign(f_log,'./log.log');
rewrite(f_log);
writeln(f_log,formatdatetime(fmt,now)+' '+text);
close(f_log);
end;//1
if command='log_old_generate' then begin//2
assign(f_log,'./log.log');
append(f_log);
writeln(f_log,formatdatetime(fmt,now)+' '+text);
close(f_log);
end;//2
{
if command='log_drop_generate' then begin//3
assign(f_log,'log.txt');
erase(f_log);

end;//3}
end;

//11.12.2015
function name_tab(s:string;i:byte):string;
begin
if (lang_s='w_rus') or (lang_s='w_eng')then begin //1
while length(s)<i do begin//1.1
s:=s+' ';
end;//1.1
end;//1
if (lang_s='u_rus') or (lang_s='u_eng')then begin //2
while length(Utf8ToAnsi(s))<i do begin//2.1
s:=s+' ';
end;//2.1
end;//2
name_tab:=s;
end;


//03.03.2016
function quest_generate(qs:byte):quest;
var 
qss,qss1:string[50];
qsi,qsj:byte;
qsr:word;
begin
quest_generate.x:=0;quest_generate.y:=0;
if qs=100 then begin //1
for qsi:=0 to 5 do quest_generate.st[qsi]:='';

end{1} else begin//2
if lang_s='w_rus' then assign(qst,'res\quest\r_w_quest');
if lang_s='u_rus' then assign(qst,'res/quest/r_u_quest');
if lang_s='w_eng' then assign(qst,'res\quest\e_w_quest');
if lang_s='u_eng' then assign(qst,'res/quest/e_u_quest');
reset(qst);
qsi:=0;
while not eof(qst) do begin//1
readln(qst,qss);
if qss=inttostr(qs) then  begin//2
for qsi:=0 to 5 do begin//
readln(qst,qss1);
quest_generate.st[qsi]:=qss1;
end;//3
end;//2
if qs=0 then begin //1.1
quest_generate.st[0]:=quest_generate.st[0]+npc[random(max_npc)].name;
quest_generate.st[0]:=name_tab(quest_generate.st[0],75);
quest_generate.st[2]:=oz_list[random(100)].oz_name+' '+oz_list[random(100)].oz_name;
repeat
qsi:=random(x_map);qsj:=random(y_map);
until (qsi>20)and(qsi<x_map-20)and(qsj>20)and(qsj<y_map-20);
quest_generate.x:=qsi;
quest_generate.y:=qsj;
end;//1.1
if qs=1 then begin //1.2
qsr:=random(100);
quest_generate.st[0]:=quest_generate.st[0]+oz_list[qsr].oz_name;
quest_generate.st[0]:=name_tab(quest_generate.st[0],75);
quest_generate.st[2]:=beast_list[qsr].name;
quest_generate.x:=beast_list[qsr].x;
quest_generate.y:=beast_list[qsr].y;
end;//1.2
if qs=2 then begin //1.3
qsr:=random(100);
quest_generate.st[0]:=quest_generate.st[0]+oz_list[qsr].oz_name;
quest_generate.st[0]:=name_tab(quest_generate.st[0],75);
quest_generate.st[2]:=oz_list[qsr].oz_name+' '+text[142];
quest_generate.x:=oz_list[qsr].x;
quest_generate.y:=oz_list[qsr].y;
end;//1.3
end;//1
close(qst);
end;//2
//for qsi:=0 to 5 do quest_generate.st[qsi]:=name_tab(quest_generate.st[qsi],100);
quest_generate.red:=qs;
//log_generate('log_old_generate','qg_qs '+inttostr(qs));
//log_generate('log_old_generate','qg_s[0] '+quest_generate.st[0]);
end;

//05.03.2016
procedure quest_output(qo:byte);
begin
//if qo=100 then writeln(text[50]) else begin//1
quest_st:=quest_generate(qo);
clrscr;
for i:=0 to 5 do
writeln(quest_st.st[i]);
//end;//1
writeln('');
writeln(text[96]);
readln();
end;

procedure quest_output_activ(qoa:quest);
begin
clrscr;
for i:=0 to 5 do
writeln(qoa.st[i]);
writeln(qoa.x,' ',qoa.y);

writeln('');
writeln(text[96]);
readln();
end;

//04.03.2016
procedure dungeon_generate_pass(pass:byte);
var
tx1,tx2,ty1,ty2:byte;
begin
for i:=0 to pass do begin//0

 if room_list[i].x>room_list[i+1].x then begin//1
// log_generate('log_old_generate','pass >- '+inttostr(room_list[i].x)+' '+inttostr(room_list[i+1].x));
 tx1:=room_list[i].x;tx2:=room_list[i+1].x;
 ty1:=room_list[i].y;ty2:=room_list[i+1].y;
 while tx1>tx2 do begin//1.1
dungeons[tx1,ty1].color:=14;
dungeons[tx1,ty1].structure:='.';
dungeons[tx1,ty1].ver:=0;
tx1:=tx1-1;
 end;//1.1
 end;//1
 
 if room_list[i].x<room_list[i+1].x then begin//2
 // log_generate('log_old_generate','pass <- '+inttostr(room_list[i].x)+' '+inttostr(room_list[i+1].x));
 tx1:=room_list[i].x;tx2:=room_list[i+1].x;
 ty1:=room_list[i].y;ty2:=room_list[i+1].y;
 while tx1<tx2 do begin//2.1
dungeons[tx1,ty1].color:=14;
dungeons[tx1,ty1].structure:='.';
dungeons[tx1,ty1].ver:=0;
tx1:=tx1+1;
 end;//2.1
 end;//2
 /////------------------------------------------------------------
 
  if room_list[i].y>room_list[i+1].y then begin//1
// log_generate('log_old_generate','pass >- '+inttostr(room_list[i].x)+' '+inttostr(room_list[i+1].x));
 tx1:=room_list[i].x;tx2:=room_list[i+1].x;
 ty1:=room_list[i].y;ty2:=room_list[i+1].y;
 while ty1>ty2 do begin//1.1
dungeons[tx2,ty1].color:=14;
dungeons[tx2,ty1].structure:='.';
dungeons[tx2,ty1].ver:=0;
ty1:=ty1-1;
 end;//1.1
 end;//1
 
 if room_list[i].y<room_list[i+1].y then begin//2
 // log_generate('log_old_generate','pass <- '+inttostr(room_list[i].x)+' '+inttostr(room_list[i+1].x));
 tx1:=room_list[i].x;tx2:=room_list[i+1].x;
 ty1:=room_list[i].y;ty2:=room_list[i+1].y;
 while ty1<ty2 do begin//2.1
dungeons[tx2,ty1].color:=14;
dungeons[tx2,ty1].structure:='.';
dungeons[tx2,ty1].ver:=0;
ty1:=ty1+1;
 end;//2.1
 end;//2
  
end;//0
end;

//04.03.2016
procedure dungeon_generate_room(dgri,dgrj:byte);
var
ii,jj:byte;
begin
for ii:=dgri-5 to dgri+5 do begin//1
for jj:=dgrj-5 to dgrj+5 do begin//2
//dungeons[ii,jj].x:=ii;
//dungeons[ii,jj].y:=jj;
dungeons[ii,jj].color:=14;
dungeons[ii,jj].structure:='.';
dungeons[ii,jj].ver:=0;

end;//2
end;//1

end;

//05.03.2016
procedure dungeon_generate_mob(dgm:byte);
var
dgmx,dgmy:byte;
begin
for i:=0 to dgm do begin//1
dgmx:=random(200);
dgmy:=random(200);
if dungeons[dgmx,dgmy].structure='.' then begin//2
dungeons[dgmx,dgmy].structure:='@';
dungeons[dgmx,dgmy].color:=5;
end;//2
end;//1
end;

//03.03.2016
procedure dungeon_generate(dg:byte);
var
dgi,dgj:byte;
begin
//zapol
for i:=0 to 204 do begin//1
for j:=0 to 204 do begin//2
dungeons[i,j].x:=i;
dungeons[i,j].y:=j;
dungeons[i,j].color:=14;
dungeons[i,j].structure:='#';
dungeons[i,j].ver:=0;
end;//1
end;//2

for i:=0 to dg do begin//3

dgi:=0;dgj:=0;
//while (dgi<6)and(dgi>198)and(dgj<6)and(dgj>198) do begin//1.1
dgi:=random(200);dgj:=random(200);
if dgi<11 then dgi:=dgi+11;
if dgi>188 then dgi:=dgi-11;
if dgj<11 then dgj:=dgj+11;
if dgj>188 then dgj:=dgi-11;
//end;//1.1
room_list[i].x:=dgi;
room_list[i].y:=dgj;
log_generate('log_old_generate','room- '+inttostr(dgi)+' '+inttostr(dgj));
dungeon_generate_room(dgi,dgj);
end;//3
dungeon_generate_pass(dg-1);
dungeons[room_list[0].x,room_list[0].y].structure:='^';
dungeons[room_list[dg].x,room_list[dg].y].structure:='/';
dungeon_generate_mob(100);
end;


//31.12.2015
procedure story;
var
ss:string;
begin
ClrScr;
if lang_s='w_rus' then assign(st,'res\lang\rus\story');
if lang_s='u_rus' then assign(st,'res/lang/rus/story_u');
if lang_s='w_eng' then assign(st,'res\lang\eng\story');
if lang_s='u_eng' then assign(st,'res/lang/eng/story');
reset(st);
while not eof(st) do begin
readln(st,ss);
writeln(ss);
end;
close(st);
writeln(text[96]);
readln();
end;

//29.12.2015
procedure help;
var

h:array [0..15] of string;
ih:byte;
begin
ClrScr;
ih:=0;
if lang_s='w_rus' then assign(hf,'res\lang\rus\help');
if lang_s='u_rus' then assign(hf,'res/lang/rus/help_u');
if lang_s='w_eng' then assign(hf,'res\lang\eng\help');
if lang_s='u_eng' then assign(hf,'res/lang/eng/help');
reset(hf);
while not eof(hf) do begin
readln(hf,h[ih]);
ih:=ih+1;
end;
close(hf);
writeln(h[0]);
textcolor(yellow);
writeln('. - '+h[1]);
writeln(': - '+h[2]);
writeln('; - '+h[3]);
writeln('# - '+h[4]);
textcolor(6);
writeln('/ - '+h[5]);
textcolor(2);
writeln('" - '+h[6]);
writeln('! - '+h[9]);
textcolor(1);
writeln('0 - '+h[7]);
writeln('~ - '+h[8]);
textcolor(7);
writeln('_ - '+h[10]);
writeln('- - '+h[11]);
writeln('= - '+h[12]);
textcolor(8);
writeln('^ - '+h[13]);
textcolor(white);
writeln(text[96]);
readln();

end;


//27.12.2015
procedure item_ful_info(ifi:subject);
begin
ClrScr;
if ifi.tip=0 then writeln(text[50]);
if ifi.tip<>0 then begin//0
writeln(text[91]+' '+ifi.name);
//type_subject:string;
if (ifi.tip=1)or(ifi.tip=2)or(ifi.tip=3)or(ifi.tip=4) then begin//1
writeln(text[12]+' '+inttostr(ifi.base_dmg));
writeln(text[100]+' '+inttostr(ifi.base_defense));

//,tip:word;{tip=1-weapon,2-armor...}
writeln(text[31]+' '+inttostr(ifi.init));
writeln(text[32]+' '+inttostr(ifi.masking));
writeln(text[33]+' '+inttostr(ifi.obser));
end;//1
if (ifi.tip=5)or(ifi.tip=6)or(ifi.tip=7) then begin//2
writeln(text[26]+' '+inttostr(ifi.stren));
writeln(text[27]+' '+inttostr(ifi.intel));
writeln(text[28]+' '+inttostr(ifi.agility));
writeln(text[5]+' '+inttostr(ifi.hp));
writeln(text[6]+' '+inttostr(ifi.mp));
end;//2
writeln(text[93]+' '+inttostr(ifi.ves));
writeln(text[102]+' '+inttostr(ifi.cost));
end;//0
writeln(text[96]);
readln();
end;


//+08.11.2015
function story_npc(command:char;lvl:byte):string;
var
born,stud,work,live:array[0..20]of string[55];
ts:string;
ib,iss,iw,il:byte;
begin
ib:=0;iss:=0;iw:=0;il:=0;
if lang_s='u_rus' then assign(prof,'res/har/u_prof_rus');
if lang_s='u_eng' then assign(prof,'res/har/u_prof_eng');
if lang_s='w_rus' then assign(prof,'res\har\w_prof_rus');
if lang_s='w_eng' then assign(prof,'res\har\w_prof_eng');
reset(prof);
while not eof(prof) do begin

readln(prof,ts);
if ts[2]='b' then begin delete(ts,1,9);born[ib]:=ts; ib:=ib+1; end;
if ts[2]='s' then begin  delete(ts,1,9);stud[iss]:=ts; iss:=iss+1; end;
if ts[2]='w' then begin delete(ts,1,9);work[iw]:=ts; iw:=iw+1; end;
if ts[2]='l' then begin delete(ts,1,9);live[il]:=ts; il:=il+1; end;

end;
close(prof);

if (command='b')and(lvl=0) then story_npc:=text[77]+' '+born[random(ib)]+oz_list[random(100)].oz_name;
if (command='s')and(lvl=0) then story_npc:=text[127]+' '+stud[random(iss)];
if (command='w')and(lvl=0) then story_npc:=text[78]+' '+work[random(iw)];
if (command='l')and(lvl=0) then story_npc:=text[128]+' '+live[random(il)];
//prof

if (command='s')and(lvl>0) then story_npc:=stud[lvl];
if (command='w')and(lvl>0) then story_npc:=work[lvl];
if (command='l')and(lvl>0) then story_npc:=live[lvl];
end;



//22.11.2015
function beast_muve(bb:beast_body;command:string;bi:word):beast_body;

var
r_bm:byte;
begin
if log='full' then log_generate('log_old_generate','beast_muve');

beast_muve:=bb;
if (command='start')and (bb.x<x_map-2)and (bb.y<y_map-2)and(bb.flag_life<>0)and(bb.flag_life<>5)and (bb.x>2)and (bb.y>2) then begin//00

r_bm:=random(4);
if r_bm=0 then beast_muve.x:=bb.x+1;
if r_bm=1 then beast_muve.x:=bb.x-1;
if r_bm=2 then beast_muve.y:=bb.y+1;
if r_bm=3 then beast_muve.y:=bb.y-1;

map[bb.x,bb.y].tip:=0;
map[beast_muve.x,beast_muve.y].tip:=1;
map[bb.x,bb.y].beast_index:=0;
map[beast_muve.x,beast_muve.y].beast_index:=bi;

end;//00
if (command='life')and (bb.x<x_map-2)and (bb.y<y_map-2)and(bb.flag_life<>0)and(bb.flag_life<>5)and (bb.x>2)and (bb.y>2) then begin//1

r_bm:=random(4);
if r_bm=0 then beast_muve.x:=bb.x+1;
if r_bm=1 then beast_muve.x:=bb.x-1;
if r_bm=2 then beast_muve.y:=bb.y+1;
if r_bm=3 then beast_muve.y:=bb.y-1;

if bb.flag_hishn=1 then begin//1.1
//while map
end;//1.1
map[bb.x,bb.y].tip:=0;
map[beast_muve.x,beast_muve.y].tip:=1;
map[bb.x,bb.y].beast_index:=0;
map[beast_muve.x,beast_muve.y].beast_index:=bi;

end;//1

end;

//29.02.2016
function hero_get_dress(hgd:new_body;command:char;ih:byte;dr:char):new_body;
{
* command:'o'-dress/'j'-jevel
* ih-# slot(1,2...)
* dr:'d'-up har, 'u'-down har
* }
begin

if (command='j')and(dr='d') then begin
hgd.stren:=hgd.stren+hgd.j[ih].stren;
hgd.intel:=hgd.intel+hgd.j[ih].intel;
hgd.agility:=hgd.agility+hgd.j[ih].agility;
hgd.hp:=hgd.hp+hgd.j[ih].hp;
hgd.mp:=hgd.mp+hgd.j[ih].mp;
end;

if (command='o')and(dr='d')  then begin
hgd.init:=hgd.init+hgd.s[ih].init;
hgd.masking:=hgd.masking+hgd.s[ih].masking;
hgd.obser:=hgd.obser+hgd.s[ih].obser;
hgd.dmg:=hgd.attak+hgd.s[ih].base_dmg;
hgd.ign_dmg:=hgd.defense+hgd.s[ih].base_defense;
end;

if (command='j')and(dr='u') then begin
hgd.stren:=hgd.stren-hgd.j[ih].stren;
hgd.intel:=hgd.intel-hgd.j[ih].intel;
hgd.agility:=hgd.agility-hgd.j[ih].agility;
hgd.hp:=hgd.hp-hgd.j[ih].hp;
hgd.mp:=hgd.mp-hgd.j[ih].mp;
end;

if (command='o')and(dr='u')  then begin
hgd.init:=hgd.init-hgd.s[ih].init;
hgd.masking:=hgd.masking-hgd.s[ih].masking;
hgd.obser:=hgd.obser-hgd.s[ih].obser;
hgd.dmg:=hgd.attak-hgd.s[ih].base_dmg;
hgd.ign_dmg:=hgd.defense-hgd.s[ih].base_defense;
end;


hero_get_dress:=hgd;
end;

function name_item_generate(command:string):string;//+09.12.2015
var
nig,r:byte;
item_m_name:array[1..200]of string[20];
begin
//log_generate('log_old_generate','name_item_generate -1- '+command);
//if command='helm' then begin//1
if lang_s='w_rus' then assign(item_name,'res\har\'+command);
if lang_s='u_rus' then assign(item_name,'res/har/u_'+command);
if lang_s='w_eng' then assign(item_name,'res\har\'+command+'_eng');
if lang_s='u_eng' then assign(item_name,'res/har/'+command+'_eng');
reset(item_name);
nig:=1;
while not eof(item_name) do begin//1.1
readln(item_name,item_m_name[nig]);
nig:=nig+1;
end;//1.1
close(item_name);
repeat r:=random(nig) until (r>0)and(r<nig-1);
{if (lang_s='w_rus') or (lang_s='w_eng')then} name_item_generate:=item_m_name[r];
{if (lang_s='u_rus') or (lang_s='u_eng')then name_item_generate:=CP866ToUTF8(item_m_name[r]);}
nig:=1;

end;


function color_generate:string;
var
n:integer;
begin
if lang_s='w_rus' then assign(color,'res\har\color');
if lang_s='u_rus' then assign(color,'res/har/u_color');
if lang_s='w_eng' then assign(color,'res\har\color_eng');
if lang_s='u_eng' then assign(color,'res/har/color_eng');
reset(color);
n:=1;
while not eof(color) do begin//1.1
readln(color,color_name[n]);
n:=n+1;
end;//1.1
close(color);
color_generate:=color_name[random(n)];
end;


//23.11.2015
function beast_inv_generate(command:string):subject;
{
skin
meat
teeth
bones
clutches
 }
begin
//log_generate('log_old_generate','beast_inv_generate -command- '+command);
if command='null' then begin//1
beast_inv_generate.name:='null';
beast_inv_generate.type_subject:='null';
beast_inv_generate.base_dmg:=0;
beast_inv_generate.base_defense:=0;
beast_inv_generate.ves:=0;
beast_inv_generate.cost:=0;
beast_inv_generate.tip:=0;
beast_inv_generate.init:=0;
beast_inv_generate.masking:=0;
beast_inv_generate.obser:=0;

beast_inv_generate.stren:=0;
beast_inv_generate.intel:=0;
beast_inv_generate.agility:=0;
beast_inv_generate.hp:=0;
beast_inv_generate.mp:=0;
end;//1
if command='skin' then begin//1
beast_inv_generate.name:=name_item_generate(command);//text[82];
beast_inv_generate.type_subject:='skin';
beast_inv_generate.base_dmg:=0;
beast_inv_generate.base_defense:=1;
beast_inv_generate.ves:=1+random(5);
beast_inv_generate.cost:=1+random(20);
beast_inv_generate.tip:=2;
beast_inv_generate.init:=1;
beast_inv_generate.masking:=1;
beast_inv_generate.obser:=1;
beast_inv_generate.stren:=0;
beast_inv_generate.intel:=0;
beast_inv_generate.agility:=0;
beast_inv_generate.hp:=0;
beast_inv_generate.mp:=0;
end;//1
if command='meat' then begin//1
beast_inv_generate.name:=name_item_generate(command);//text[83];
beast_inv_generate.type_subject:='meat';
beast_inv_generate.base_dmg:=0;
beast_inv_generate.base_defense:=1;
beast_inv_generate.ves:=1+random(5);
beast_inv_generate.cost:=1+random(20);
beast_inv_generate.tip:=3;
beast_inv_generate.init:=1;
beast_inv_generate.masking:=1;
beast_inv_generate.obser:=1;
beast_inv_generate.stren:=0;
beast_inv_generate.intel:=0;
beast_inv_generate.agility:=0;
beast_inv_generate.hp:=0;
beast_inv_generate.mp:=0;
end;//1
if command='teeth' then begin//1
beast_inv_generate.name:=name_item_generate(command);//text[84];
beast_inv_generate.type_subject:='teeth';
beast_inv_generate.base_dmg:=1;
beast_inv_generate.base_defense:=2;
beast_inv_generate.ves:=1+random(5);
beast_inv_generate.cost:=1+random(20);
beast_inv_generate.tip:=1;
beast_inv_generate.init:=1;
beast_inv_generate.masking:=1;
beast_inv_generate.obser:=1;
beast_inv_generate.stren:=0;
beast_inv_generate.intel:=0;
beast_inv_generate.agility:=0;
beast_inv_generate.hp:=0;
beast_inv_generate.mp:=0;
end;//1
if command='bones' then begin//1
beast_inv_generate.name:=name_item_generate(command);//text[85];
beast_inv_generate.type_subject:='bones';
beast_inv_generate.base_dmg:=0;
beast_inv_generate.base_defense:=1;
beast_inv_generate.ves:=1+random(5);
beast_inv_generate.cost:=1+random(20);
beast_inv_generate.tip:=4;
beast_inv_generate.init:=1;
beast_inv_generate.masking:=1;
beast_inv_generate.obser:=1;
beast_inv_generate.stren:=0;
beast_inv_generate.intel:=0;
beast_inv_generate.agility:=0;
beast_inv_generate.hp:=0;
beast_inv_generate.mp:=0;
end;//1
if command='clutches' then begin//1
beast_inv_generate.name:=name_item_generate(command);//text[86];
beast_inv_generate.type_subject:='clutches';
beast_inv_generate.base_dmg:=1;
beast_inv_generate.base_defense:=0;
beast_inv_generate.ves:=1+random(5);
beast_inv_generate.cost:=1+random(20);
beast_inv_generate.tip:=1;
beast_inv_generate.init:=1;
beast_inv_generate.masking:=1;
beast_inv_generate.obser:=1;
beast_inv_generate.stren:=0;
beast_inv_generate.intel:=0;
beast_inv_generate.agility:=0;
beast_inv_generate.hp:=0;
beast_inv_generate.mp:=0;
end;//1
if command='helm' then begin//1
beast_inv_generate.name:=color_generate+' '+name_item_generate(command);//text[86];
beast_inv_generate.type_subject:='helm';
beast_inv_generate.base_dmg:=0;
beast_inv_generate.base_defense:=1+random(15);
beast_inv_generate.ves:=1+random(5);
beast_inv_generate.cost:=1+random(20);
beast_inv_generate.tip:=2;
beast_inv_generate.init:=1;
beast_inv_generate.masking:=1+random(5);
beast_inv_generate.obser:=1+random(5);
beast_inv_generate.stren:=0;
beast_inv_generate.intel:=0;
beast_inv_generate.agility:=0;
beast_inv_generate.hp:=0;
beast_inv_generate.mp:=0;
end;//1
if command='dress' then begin//1
beast_inv_generate.name:=color_generate+' '+name_item_generate(command);//text[86];
beast_inv_generate.type_subject:='dress';
beast_inv_generate.base_dmg:=0;
beast_inv_generate.base_defense:=1+random(25);
beast_inv_generate.ves:=1+random(5);
beast_inv_generate.cost:=5+random(30);
beast_inv_generate.tip:=2;
beast_inv_generate.init:=1+random(5);
beast_inv_generate.masking:=1+random(5);
beast_inv_generate.obser:=1;
beast_inv_generate.stren:=0;
beast_inv_generate.intel:=0;
beast_inv_generate.agility:=0;
beast_inv_generate.hp:=0;
beast_inv_generate.mp:=0;
end;//1
if command='shoes' then begin//1
beast_inv_generate.name:=color_generate+' '+name_item_generate(command);//text[86];
beast_inv_generate.type_subject:='shoes';
beast_inv_generate.base_dmg:=1;
beast_inv_generate.base_defense:=1+random(15);
beast_inv_generate.ves:=1+random(5);
beast_inv_generate.cost:=1+random(20);
beast_inv_generate.tip:=2;
beast_inv_generate.init:=1+random(5);
beast_inv_generate.masking:=1+random(5);
beast_inv_generate.obser:=1;
beast_inv_generate.stren:=0;
beast_inv_generate.intel:=0;
beast_inv_generate.agility:=0;
beast_inv_generate.hp:=0;
beast_inv_generate.mp:=0;
end;//1
if command='sword' then begin//1
beast_inv_generate.name:=color_generate+' '+name_item_generate(command);//text[86];
beast_inv_generate.type_subject:='sword';
beast_inv_generate.base_dmg:=3+random(15);
beast_inv_generate.base_defense:=1+random(5);
beast_inv_generate.ves:=1+random(5);
beast_inv_generate.cost:=5+random(20);
beast_inv_generate.tip:=1;
beast_inv_generate.init:=1+random(10);
beast_inv_generate.masking:=1;
beast_inv_generate.obser:=1;
beast_inv_generate.stren:=0;
beast_inv_generate.intel:=0;
beast_inv_generate.agility:=0;
beast_inv_generate.hp:=0;
beast_inv_generate.mp:=0;
end;//1
if command='shield' then begin//1
beast_inv_generate.name:=color_generate+' '+name_item_generate(command);//text[86];
beast_inv_generate.type_subject:='shield';
beast_inv_generate.base_dmg:=1;
beast_inv_generate.base_defense:=1+random(35);
beast_inv_generate.ves:=1+random(5);
beast_inv_generate.cost:=15+random(40);
beast_inv_generate.tip:=1;
beast_inv_generate.init:=1+random(5);
beast_inv_generate.masking:=1+random(15);
beast_inv_generate.obser:=1;
beast_inv_generate.stren:=0;
beast_inv_generate.intel:=0;
beast_inv_generate.agility:=0;
beast_inv_generate.hp:=0;
beast_inv_generate.mp:=0;
end;//1
if command='ring' then begin//1
beast_inv_generate.name:=color_generate+' '+text[136];
beast_inv_generate.type_subject:='ring';
beast_inv_generate.base_dmg:=1;
beast_inv_generate.base_defense:=1;
beast_inv_generate.ves:=1;
beast_inv_generate.cost:=15+random(40);
beast_inv_generate.tip:=5;//!
beast_inv_generate.init:=1;
beast_inv_generate.masking:=1;
beast_inv_generate.obser:=1;
beast_inv_generate.stren:=random(5);
beast_inv_generate.intel:=random(5);
beast_inv_generate.hp:=random(5);
beast_inv_generate.mp:=random(5);
end;//1
if command='link' then begin//1
beast_inv_generate.name:=color_generate+' '+text[137];
beast_inv_generate.type_subject:='link';
beast_inv_generate.base_dmg:=1;
beast_inv_generate.base_defense:=1;
beast_inv_generate.ves:=1;
beast_inv_generate.cost:=15+random(40);
beast_inv_generate.tip:=6;//!
beast_inv_generate.init:=1;
beast_inv_generate.masking:=1;
beast_inv_generate.obser:=1;
beast_inv_generate.stren:=random(5);
beast_inv_generate.intel:=random(5);
beast_inv_generate.hp:=random(5);
beast_inv_generate.mp:=random(5);
end;//1
if command='amulet' then begin//1
beast_inv_generate.name:=color_generate+' '+text[138];
beast_inv_generate.type_subject:='amulet';
beast_inv_generate.base_dmg:=1;
beast_inv_generate.base_defense:=1;
beast_inv_generate.ves:=1;
beast_inv_generate.cost:=15+random(40);
beast_inv_generate.tip:=5;//!
beast_inv_generate.init:=1;
beast_inv_generate.masking:=1;
beast_inv_generate.obser:=1;
beast_inv_generate.stren:=random(5);
beast_inv_generate.intel:=random(5);
beast_inv_generate.hp:=random(5);
beast_inv_generate.mp:=random(5);
end;//1
end;


//11.03.2016
function mob_dressed(md:new_body;command:char;slot_bag,slot_dress:byte):new_body;
{
* command: 'o'-dress;'j'-jevel
* }
begin
if command='o' then begin//1
md.s[slot_dress]:=md.bag[slot_bag];
md.bag[slot_bag]:=beast_inv_generate('null');
md:=hero_get_dress(md,'o',slot_dress,'d');
end;//1
if command='j' then begin//2
md.j[slot_dress]:=md.bag[slot_bag];
md.bag[slot_bag]:=beast_inv_generate('null');
md:=hero_get_dress(md,'j',slot_dress,'d');
end;//2
mob_dressed:=md;
end;

//08.03.2016
function mob_dress_up(mdu:new_body):new_body;
var
mi:byte;
fl:boolean;
begin
//1
mi:=0;
fl:=false;
{-------------------------------------}
for mi:=0 to 5 do begin//3

if( mdu.s[1].tip=0)and( mdu.bag[mi].type_subject='helm') then begin//3.1
mdu:=mob_dressed(mdu,'o',mi,1);
//log_generate('log_old_generate','mob_dress_up '+mdu.s[1].name);
end; //3.1
if( mdu.s[2].tip=0)and( mdu.bag[mi].type_subject='dress')then mdu:=mob_dressed(mdu,'o',mi,2);
if( mdu.s[3].tip=0)and( mdu.bag[mi].type_subject='shoes')then mdu:=mob_dressed(mdu,'o',mi,3);
if( mdu.s[4].tip=0)and( mdu.bag[mi].type_subject='sword')then mdu:=mob_dressed(mdu,'o',mi,4);
if( mdu.s[5].tip=0)and( mdu.bag[mi].type_subject='shield')then mdu:=mob_dressed(mdu,'o',mi,5);

if( mdu.j[0].tip=0)and( mdu.bag[mi].tip=5)then begin mdu:=mob_dressed(mdu,'j',mi,0); fl:=true;end;
if( mdu.j[1].tip=0)and( mdu.bag[mi].tip=5) and (fl=false)then  mdu:=mob_dressed(mdu,'j',mi,1);
fl:=false;
if( mdu.j[2].tip=0)and( mdu.bag[mi].tip=6)then begin mdu:=mob_dressed(mdu,'j',mi,2); fl:=true;end;
if( mdu.j[3].tip=0)and( mdu.bag[mi].tip=6) and (fl=false)then  mdu:=mob_dressed(mdu,'j',mi,3);
fl:=false;
if( mdu.j[4].tip=0)and( mdu.bag[mi].tip=7)then  mdu:=mob_dressed(mdu,'j',mi,4); 
end;//3



mob_dress_up:=mdu;
end;



//04.02.2016
function mob_muve(mm:new_body;command:string;mi:byte):new_body;
var
mmf:boolean;
mmt:byte;
begin
mob_muve:=mm;
mmt:=random(3);
if (command='start') and (map[mm.x,mm.y].tip=3) and(mmt=2) 
and(mm.x+2<x_map)and(mm.x>2)and(mm.y+2<y_map)and(mm.y>2) 
and (hero.xd=0)and(hero.yd=0)
then begin//00
mmf:=true;
if (mob_muve.x<mob_muve.quest_activ.x)and(mmf=true) then begin
mob_muve.x:=mob_muve.x+1; mmf:=false;end;
if (mob_muve.x>mob_muve.quest_activ.x)and(mmf=true)  then begin
 mob_muve.x:=mob_muve.x-1; mmf:=false;end;

if (mob_muve.y<mob_muve.quest_activ.y)and(mmf=true)  then  begin
mob_muve.y:=mob_muve.y+1; mmf:=false;end;
if (mob_muve.y>mob_muve.quest_activ.y)and(mmf=true)  then  begin
mob_muve.y:=mob_muve.y-1; mmf:=false;end;

if (mob_muve.y=mob_muve.quest_activ.y)and(mob_muve.x=mob_muve.quest_activ.x) then
begin//1
 mob_muve.exp:=mm.exp+10;
 mob_muve.quest_activ:=quest_generate(random(3));
 log_generate('log_old_generate','mob_muve quest complit '+inttostr(mi));
 end;//1
{
tt:=random(4);
if tt=0 then mob_muve.x:=mob_muve.x+1;
if tt=1 then mob_muve.x:=mob_muve.x-1;
if tt=2 then mob_muve.y:=mob_muve.y+1;
if tt=3 then mob_muve.y:=mob_muve.y-1;
}
end;//00
map[mm.x,mm.y].tip:=0;
map[mob_muve.x,mob_muve.y].tip:=3;
map[mm.x,mm.y].mob_index:=0;
map[mob_muve.x,mob_muve.y].mob_index:=mi;

//log_generate('log_old_generate','mob_muve 33 '+inttostr(mi)+' '+inttostr(mob_muve.x)+':'+inttostr(mob_muve.y));
end;



//+11.11.2015
procedure muve(i_m,j_m:word; command:string);
var
i_muv,j_muv,rr:word;
bm_i:word;
begin
if command='start' then begin//00
for i_muv:=i_m-5 to i_m+5 do begin//0.1
	for j_muv:=j_m-10 to j_m+10 do begin//0.2
	
if map[i_muv,j_muv].progress>=progress_max then begin//1

if map[i_muv,j_muv].structure='/' then begin//1.2
 map[i_muv,j_muv].structure:='.';
 map[i_muv,j_muv].color:=14;
 map[i_muv,j_muv].progress:=0;

end;//1.2

if map[i_muv,j_muv].structure='"' then begin//1.1
rr:=random(4);
if (rr=0)and (i_muv<x_map-1) then begin //1.1.1
map[i_muv+1,j_muv].structure:='"';
map[i_muv+1,j_muv].color:=2;
map[i_muv+1,j_muv].progress:=0;
end;//1.1.1
if (rr=1)and (i_muv>0) then begin //1.1.2
map[i_muv-1,j_muv].structure:='"';
map[i_muv-1,j_muv].color:=2;
map[i_muv-1,j_muv].progress:=0;
end;//1.1.2
if (rr=2)and (j_muv<y_map-1) then begin//1.1.3
 map[i_muv,j_muv+1].structure:='"';
 map[i_muv,j_muv+1].color:=2;
 map[i_muv,j_muv+1].progress:=0;
 end;//1.1.3
if (rr=3)and (j_muv>0) then begin //1.1.4
map[i_muv,j_muv-1].structure:='"';
map[i_muv,j_muv-1].color:=2;
map[i_muv,j_muv-1].progress:=0;
end;//1.1.4

 map[i_muv,j_muv].structure:='/';
 map[i_muv,j_muv].color:=6;
 map[i_muv,j_muv].progress:=0;

end;//1.1	
	


end;//1
if (map[i_muv,j_muv].structure='"')or (map[i_muv,j_muv].structure='/') then map[i_muv,j_muv].progress:=map[i_muv,j_muv].progress+1;
end;end;//0.1//0.2
end;//00

if command='test' then begin//000------------------------000-----------------

//log_generate('log_old_generate','start_muve_');
for i_muv:=10 to x_map-10 do begin//0.1
	for j_muv:=10 to y_map-10 do begin//0.2
	
//if map[i_muv,j_muv].tip =3 then mob[map[i_muv,j_muv].mob_index]:=mob_muve(mob[map[i_muv,j_muv].mob_index],'start',map[i_muv,j_muv].mob_index);
	
//mob[map[i_muv,j_muv].mob_index]:=mob_muve(mob[map[i_muv,j_muv].mob_index],'start');	
if map[i_muv,j_muv].progress>=100 then begin//1--------------!!!!2->100!!!!--------------

if map[i_muv,j_muv].structure='/' then begin//1.2
 map[i_muv,j_muv].structure:='.';
 map[i_muv,j_muv].color:=14;
 map[i_muv,j_muv].progress:=0;

end;//1.2

if map[i_muv,j_muv].structure='"' then begin//1.1
rr:=random(4);
if (rr=0)and (i_muv<x_map-1) and(map[i_muv+1,j_muv].structure='.') then begin //1.1.1
//log_generate('log_old_generate','muve 0');
map[i_muv+1,j_muv].structure:='"';
map[i_muv+1,j_muv].color:=2;
map[i_muv+1,j_muv].progress:=0;

 map[i_muv,j_muv].structure:='/';
 map[i_muv,j_muv].color:=6;
 map[i_muv,j_muv].progress:=0;

end;//1.1.1
if (rr=1)and (i_muv>0) and(map[i_muv-1,j_muv].structure='.')then begin //1.1.2
//log_generate('log_old_generate','muve 1');
map[i_muv-1,j_muv].structure:='"';
map[i_muv-1,j_muv].color:=2;
map[i_muv-1,j_muv].progress:=0;

 map[i_muv,j_muv].structure:='/';
 map[i_muv,j_muv].color:=6;
 map[i_muv,j_muv].progress:=0;

end;//1.1.2
if (rr=2)and (j_muv<y_map-1)and(map[i_muv,j_muv+1].structure='.') then begin//1.1.3
//log_generate('log_old_generate','muve 2');
 map[i_muv,j_muv+1].structure:='"';
 map[i_muv,j_muv+1].color:=2;
 map[i_muv,j_muv+1].progress:=0;

  map[i_muv,j_muv].structure:='/';
 map[i_muv,j_muv].color:=6;
 map[i_muv,j_muv].progress:=0;

 end;//1.1.3
if (rr=3)and (j_muv>0)and(map[i_muv,j_muv-1].structure='.') then begin //1.1.4
//log_generate('log_old_generate','muve 3');
map[i_muv,j_muv-1].structure:='"';
map[i_muv,j_muv-1].color:=2;
map[i_muv,j_muv-1].progress:=0;

 map[i_muv,j_muv].structure:='/';
 map[i_muv,j_muv].color:=6;
 map[i_muv,j_muv].progress:=0;

end;//1.1.4

 {map[i_muv,j_muv].structure:='/';
 map[i_muv,j_muv].color:=6;
 map[i_muv,j_muv].progress:=0;}

end;//1.1	
	


end;//1
if (map[i_muv,j_muv].structure='"')or (map[i_muv,j_muv].structure='/') then map[i_muv,j_muv].progress:=map[i_muv,j_muv].progress+1;
end;end;//0.1//0.2
//log_generate('log_old_generate','start_muve_beast ');

for bm_i:=0 to 10000 do begin //2

beast_list[bm_i]:=beast_muve(beast_list[bm_i],'start',bm_i);
if mob[bm_i].hp>0 then mob[bm_i]:=mob_muve(mob[bm_i],'start',bm_i);
end;//2

end;//000
end;



function name_generate(command:string):string;//+12.08.2015
var
s:string;
begin
//02.04.2016
if lang_s='w_eng' then s:='res\mob\monster_'+command+'_win_eng.name';
if lang_s='u_eng' then s:='res/mob/monster_'+command+'_unix_eng.name';
if lang_s='w_rus' then s:='res\mob\monster_'+command+'_win.name';//+01.09.2015
if lang_s='u_rus' then s:='res/mob/monster_'+command+'_unix.name';//19.02.2016
assign(monster_name,s);
reset(monster_name);
m:=1;
while not eof(monster_name) do begin//1.1
readln(monster_name,text_name[m]);
m:=m+1;
end;//1.1
close(monster_name);
//+31.08.2015
if lang_s='w_rus' then assign(color,'res\har\color');
if lang_s='u_rus' then assign(color,'res/har/u_color');
if lang_s='w_eng' then assign(color,'res\har\color_eng');
if lang_s='u_eng' then assign(color,'res/har/color_eng');
reset(color);
n:=1;
while not eof(color) do begin//1.1
readln(color,color_name[n]);
n:=n+1;
end;//1.1
close(color);
//
if lang_s='w_rus' then assign(har,'res\har\har');
if lang_s='u_rus' then assign(har,'res/har/u_har');
if lang_s='w_eng' then assign(har,'res\har\har_eng');
if lang_s='u_eng' then assign(har,'res/har/har_eng');
reset(har);
i:=1;
while not eof(har) do begin//1.1
readln(har,har_name[i]);
i:=i+1;
end;//1.1
close(har);

name_generate:={har_name[random(i)]+' '+}text_name[random(m)]{+' '+color_name[random(n)]};
end;




//01.01.2016
procedure beast_drop_out(bdo:beast_body);
begin
if log='full' then log_generate('log_old_generate','beast_drop_out ');
clrscr;
writeln('|'+text[91]+'       |'+text[12]+'|'+text[92]+'|'+text[93]+'|');
if bdo.skin.tip<> 0 then writeln('|'+'1- '+text[89]+' '+name_tab(bdo.skin.name,16)+'|'+name_tab(inttostr(bdo.skin.base_dmg),6)+'|'+name_tab(inttostr(bdo.skin.base_defense),6)+'|'+name_tab(inttostr(bdo.skin.ves),4)+'|');
if bdo.meat.tip<> 0 then writeln('|'+'2- '+text[89]+' '+name_tab(bdo.meat.name,16)+'|'+name_tab(inttostr(bdo.meat.base_dmg),6)+'|'+name_tab(inttostr(bdo.meat.base_defense),6)+'|'+name_tab(inttostr(bdo.meat.ves),4)+'|');
if bdo.teeth.tip<> 0 then writeln('|'+'3- '+text[89]+' '+name_tab(bdo.teeth.name,16)+'|'+name_tab(inttostr(bdo.teeth.base_dmg),6)+'|'+name_tab(inttostr(bdo.teeth.base_defense),6)+'|'+name_tab(inttostr(bdo.teeth.ves),4)+'|');
if bdo.bones.tip<> 0 then writeln('|'+'4- '+text[89]+' '+name_tab(bdo.bones.name,16)+'|'+name_tab(inttostr(bdo.bones.base_dmg),6)+'|'+name_tab(inttostr(bdo.bones.base_defense),6)+'|'+name_tab(inttostr(bdo.bones.ves),4)+'|');
if bdo.clutches.tip<> 0 then writeln('|'+'5- '+text[89]+' '+name_tab(bdo.clutches.name,16)+'|'+name_tab(inttostr(bdo.clutches.base_dmg),6)+'|'+name_tab(inttostr(bdo.clutches.base_defense),6)+'|'+name_tab(inttostr(bdo.clutches.ves),4)+'|');
end;

function item_info(i_t:byte):string;
begin
//log_generate('log_old_generate','inem_info - i_t -'+inttostr(i_t));
if i_t= 0 then  item_info:=text[50];
if i_t= 1 then  item_info:=text[46];
if i_t= 2 then  item_info:=text[47];
if i_t= 3 then  item_info:=text[48];
if i_t= 4 then  item_info:=text[49];
if i_t= 5 then  item_info:=text[136];
if i_t= 6 then  item_info:=text[137];
if i_t= 7 then  item_info:=text[138];
end;

//09.01.2016
function trade_out(t_o,he:new_body;command:string):temp;
var
//tr:string;
toi,bagi:byte;
trader:new_body;
begin
if log='full' then log_generate('log_old_generate','trade_out '+command);

repeat begin//0
clrscr;
bagi:=0;
if command= 'trade' then trader:=he; 
if command= 'cell' then  trader:= t_o; 
writeln('--------------------------------------------------------');
writeln('|'+name_tab(text[91],30)+'|'+name_tab(text[110],11)+'|'+name_tab(text[12],6)+'|'
+name_tab(text[92],6)+'|'+name_tab(text[102],10)+'|'
+name_tab(text[93],4)+'|');
for toi:=0 to 8 do begin//1
if trader.bag[toi].tip<>0 then writeln('|'+name_tab(trader.bag[toi].name,30)+'|'+name_tab(item_info(trader.bag[toi].tip),11)+'|'+name_tab(inttostr(trader.bag[toi].base_dmg),6)
+'|'+name_tab(inttostr(trader.bag[toi].base_defense),6)+'|'+name_tab(inttostr(trader.bag[toi].cost),10)
+'|'+name_tab(inttostr(trader.bag[toi].ves),4)+'|'+'-'+inttostr(toi+1));
end;//1
writeln('--------------------------------------------------------');
writeln(he.name,' ',text[116],':',he.gold,' | ',t_o.name,' ',text[116],':',t_o.gold,' |');

writeln(text[90]);
menu_key:=readkey;
//end;//0


//begin //00
if (command= 'cell')and(t_o.bag[strtoint(menu_key)-1].cost<=he.gold) and (strtoint(menu_key)>0)then begin//00.1
while he.bag[bagi].tip<>0 do bagi:=bagi+1;
he.bag[bagi]:=t_o.bag[strtoint(menu_key)-1];
he.gold:=he.gold-t_o.bag[strtoint(menu_key)-1].cost;
t_o.bag[strtoint(menu_key)-1]:=beast_inv_generate('null');

trade_out.nb1:=he;
trade_out.nb2:=t_o;
//menu_key:='0';
end;//00.1
if (command= 'trade')and (hero.bag[strtoint(menu_key)-1].cost<=t_o.gold) and (strtoint(menu_key)>0)then begin//00.2
while t_o.bag[bagi].tip<>0 do bagi:=bagi+1;
t_o.bag[bagi]:=he.bag[strtoint(menu_key)-1];
t_o.gold:=t_o.gold-he.bag[strtoint(menu_key)-1].cost;
he.gold:=he.gold+he.bag[strtoint(menu_key)-1].cost;
trade_out.nb1:=he;
trade_out.nb2:=t_o;
he.bag[strtoint(menu_key)-1]:=beast_inv_generate('null');
//menu_key:='0';
end;//00.2
end;//00

until menu_key='0';
trade_out.nb1:=he;
trade_out.nb2:=t_o;
end;

//29.02.2016
function mob_drop_out_loot(mdol1,mdol2:new_body;command:char;index:word):temp;
var
bagi:byte;

begin
mob_drop_out_loot.nb1:=mdol1;
mob_drop_out_loot.nb2:=mdol2;
log_generate('log_old_generate','mob_drop_out_loot '+command+' '+inttostr(index));
log_generate('log_old_generate','mob_drop_out_loot start mob.name '+mdol2.name);
bagi:=0;
if (command= 'o')and(mdol2.s[index+1].tip<> 0 ) then begin//00.1
while mdol1.bag[bagi].tip<>0 do bagi:=bagi+1;
mdol1.bag[bagi]:=mdol2.s[index+1];
mdol2.s[index+1]:=beast_inv_generate('null');
end;//00.1
bagi:=0;
if (command= 'e')and(mdol2.bag[index].tip<> 0 ) then begin//00.1
while mdol1.bag[bagi].tip<>0 do bagi:=bagi+1;
mdol1.bag[bagi]:=mdol2.bag[index];
mdol2.bag[index]:=beast_inv_generate('null');
end;//00.1
bagi:=0;
if (command= 'j')and(mdol2.j[index].tip<> 0 ) then begin//00.1
while mdol1.bag[bagi].tip<>0 do bagi:=bagi+1;
mdol1.bag[bagi]:=mdol2.j[index];
mdol2.j[index]:=beast_inv_generate('null');
end;//00.1
bagi:=0;

mob_drop_out_loot.nb1:=mdol1;
mob_drop_out_loot.nb2:=mdol2;
log_generate('log_old_generate','mob_drop_out_loot finish mob.name '+mdol2.name);
end;
//27.02.2016
function mob_drop_out(mdo1,mdo2:new_body;command:char):temp;
//mdo1-hero,mdo2-mob
var
mdot:temp;
begin
mdot.nb1:=mdo1;
mdot.nb2:=mdo2;
log_generate('log_old_generate','mob drop_out '+command);
log_generate('log_old_generate','mob_drop_out start mob.name '+mdo2.name);
repeat begin//0
clrscr;
if command='o' then begin//1
writeln('|'+name_tab(text[91],35)+'|'+name_tab(text[12],6)+'|'+name_tab(text[92],6)+'|'+name_tab(text[93],4)+'|');
for i:=1 to 5 do
if mdo2.s[i].tip<> 0 then writeln('|',i,'- '+name_tab(text[89],5)+' '+name_tab(mdo2.s[i].name,25)+'|'+name_tab(inttostr(mdo2.s[i].base_dmg),6)+'|'+name_tab(inttostr(mdo2.s[i].base_defense),6)+'|'+name_tab(inttostr(mdo2.s[i].ves),4)+'|');
end;//1
if command='e' then begin//2
writeln('|'+name_tab(text[91],35)+'|'+name_tab(text[12],6)+'|'+name_tab(text[92],6)+'|'+name_tab(text[93],4)+'|');
for i:=0 to 4 do 
if mdo2.bag[i].tip<> 0 then writeln('|',i+1,'- '+name_tab(text[89],5)+' '+name_tab(mdo2.bag[i].name,25)+'|'+name_tab(inttostr(mdo2.bag[i].base_dmg),6)+'|'+name_tab(inttostr(mdo2.bag[i].base_defense),6)+'|'+name_tab(inttostr(mdo2.bag[i].ves),4)+'|');
end;//2
if command='j' then begin//2
writeln('|'+name_tab(text[91],35)+'|'+name_tab(text[12],6)+'|'+name_tab(text[92],6)+'|'+name_tab(text[93],4)+'|');
for i:=0 to 4 do 
if mdo2.j[i].tip<> 0 then writeln('|',i+1,'- '+name_tab(text[89],5)+' '+name_tab(mdo2.j[i].name,25)+'|'+name_tab(inttostr(mdo2.j[i].base_dmg),6)+'|'+name_tab(inttostr(mdo2.j[i].base_defense),6)+'|'+name_tab(inttostr(mdo2.j[i].ves),4)+'|');
end;//2

writeln(text[90]);
menu_key:=readkey;

case menu_key of
'1':mdot:=mob_drop_out_loot(mdo1,mdo2,command,0);
'2':mdot:=mob_drop_out_loot(mdo1,mdo2,command,1); 
'3':mdot:=mob_drop_out_loot(mdo1,mdo2,command,2);
'4':mdot:=mob_drop_out_loot(mdo1,mdo2,command,3);
'5':mdot:=mob_drop_out_loot(mdo1,mdo2,command,4);
end;
mdo1:=mdot.nb1;
mdo2:=mdot.nb2;
end;//0
mob_drop_out.nb1:=mdot.nb1;
mob_drop_out.nb2:=mdot.nb2;
until menu_key='0';


log_generate('log_old_generate','mob_drop_out finish mob.name '+mdo2.name);
end;


//27.02.2016
function mob_drop(md1,md2:new_body):temp;
//nb1-hero, nb2-mob
var
mdt:temp;
begin
mdt.nb1:=md1;
mdt.nb2:=md2;
log_generate('log_old_generate','mob_drop start mob.name '+md2.name);
repeat begin//1
clrscr;
writeln(text[89]+' '+text[88]+' '+md2.name);
writeln('1- ',text[133]);
writeln('2- ',text[134]);
writeln('3- ',text[139]);
writeln(text[90]);
menu_key:=readkey;
case menu_key of
'1': begin mdt:=mob_drop_out(md1,md2,'o');mob_drop.nb1:=mdt.nb1;mob_drop.nb2:=mdt.nb2; end;
'2': begin mdt:=mob_drop_out(md1,md2,'e');mob_drop.nb1:=mdt.nb1;mob_drop.nb2:=mdt.nb2; end;
'3': begin mdt:=mob_drop_out(md1,md2,'j');mob_drop.nb1:=mdt.nb1;mob_drop.nb2:=mdt.nb2; end;

end;
end;//1

until menu_key='0';
mob_drop.nb1:=mdt.nb1;
mob_drop.nb2:=mdt.nb2;
log_generate('log_old_generate','mob_drop finish mob.name '+mdt.nb2.name);
end;


//11.12.2015
function beast_drop(bd:beast_body):beast_body;
var
bdi:byte;
begin
if log='full' then log_generate('log_old_generate','besr_drop');
beast_drop:=bd;
bdi:=0;
clrscr;
writeln(text[45]+bd.name);
repeat begin//1
bdi:=0;
beast_drop_out(beast_drop);
writeln(text[90]);
menu_key:=readkey;
case menu_key of
'1': begin //1.1
while hero.bag[bdi].tip<>0 do bdi:=bdi+1;
hero.bag[bdi]:=beast_drop.skin;
beast_drop:=bd;
beast_drop.skin:=beast_inv_generate('null');

writeln(text[108]);
writeln(text[96]);
readln();
menu_key:='0';
	end;//1.1
'2':	begin//1.2
while hero.bag[bdi].tip<>0 do bdi:=bdi+1;
hero.bag[bdi]:=beast_drop.meat;
beast_drop:=bd;
beast_drop.meat:=beast_inv_generate('null');

writeln(text[108]);
writeln(text[96]);
readln();
menu_key:='0';
	end;//1.2
'3':	begin//1.3
while hero.bag[bdi].tip<>0 do bdi:=bdi+1;
hero.bag[bdi]:=beast_drop.teeth;
beast_drop:=bd;
beast_drop.teeth:=beast_inv_generate('null');

writeln(text[108]);
writeln(text[96]);
readln();
menu_key:='0';		
	end;//1.3
'4':	begin//1.4
while hero.bag[bdi].tip<>0 do bdi:=bdi+1;
hero.bag[bdi]:=beast_drop.bones;
beast_drop:=bd;
beast_drop.bones:=beast_inv_generate('null');

writeln(text[108]);
writeln(text[96]);
readln();	
menu_key:='0';	
	end;//1.4
'5':	begin//1.5
while hero.bag[bdi].tip<>0 do bdi:=bdi+1;
hero.bag[bdi]:=beast_drop.clutches;
beast_drop:=bd;
beast_drop.clutches:=beast_inv_generate('null');

writeln(text[108]);
writeln(text[96]);
readln();
menu_key:='0';		
	end;//1.5
end;//1

end;//1
until menu_key='0';
end;

//16.11.2015
function beast_generate(i_b,j_b:word):beast_body;
begin
//log_generate('log_old_generate','beast_generate -i_b- '+inttostr(i_b)+' -j_b- '+inttostr(j_b));
beast_generate.hp:=100;
beast_generate.dmg:=1;
beast_generate.ign_dmg:=1;
beast_generate.name:=name_generate('beast');
beast_generate.flag_life:=1;
beast_generate.flag_hishn:=random(1);
beast_generate.x:=i_b+random(20);
beast_generate.y:=j_b+random(20);
beast_generate.skin:=beast_inv_generate('skin');
beast_generate.meat:=beast_inv_generate('meat');
beast_generate.teeth:=beast_inv_generate('teeth');
beast_generate.bones:=beast_inv_generate('bones');
beast_generate.clutches:=beast_inv_generate('clutches');

//log_generate('log_old_generate',inttostr(i_b)+':'+inttostr(j_b)+' '+beast_generate.name);
end;

//20.01.2016
function race_output(r_o:word):string;
begin
{race= 1-human,2-ork,3-elf,4-dwarf}
if r_o=1 then race_output:=text[112];
if r_o=2 then race_output:=text[113];
if r_o=3 then race_output:=text[114];
if r_o=4 then race_output:=text[115];
if r_o=5 then race_output:=text[121];
if r_o=6 then race_output:=text[122];
if r_o=7 then race_output:=text[123];

end;

//01.03.2016
function select(si,namber_str:byte):byte;
var
sii,ns:byte;
begin

ns:=namber_str;
for sii:=1 to si do begin//1
writeln(text[141],' - ',sii);
if namber_str<>0 then writeln(' - ',text[ns]);
if namber_str<>0 then ns:=ns+1;
end;//1
menu_key:=readkey;
select:=strtoint(menu_key);
end;

//09.01.2016
function npc_output(n_o,ho:new_body):temp;
var
noi:byte;
n_ot:temp;
begin
repeat begin//1.0
clrscr;
writeln(n_o.name);
writeln(race_output(n_o.race));
writeln(n_o.st0);
writeln(n_o.st1);
writeln(n_o.st2);
writeln(n_o.st3);
for l:=0 to 9 do begin//1.1
if n_o.prof[l]>0 then writeln(text[148],' ',story_npc('l',l));
log_generate('log_old_generate','nps prof '+inttostr(l)+' '+inttostr(n_o.prof[l])+' '+story_npc('l',l));
end;//1.1
writeln('');
writeln('1- '+text[69]);
writeln('2- '+text[68]);
if n_o.quest_flag=true then writeln('3- '+text[143]);
writeln(text[90]);
menu_key:=readkey;
end;//1.0

case menu_key of//2.0
'1':begin n_ot:=trade_out(n_o,ho,'trade');ho:=n_ot.nb1;n_o:=n_ot.nb2;end;
'2':begin n_ot:=trade_out(n_o,ho,'cell');ho:=n_ot.nb1;n_o:=n_ot.nb2;end;
'3': begin//3
log_generate('log_old_generate','hero quest 0-1 '+ho.quest_activ.st[0]);
log_generate('log_old_generate','npc quest 0-1 '+n_o.quest_activ.st[0]);
if n_o.quest_flag=true then  quest_output_activ(n_o.quest_activ); 
if ho.quest_flag=false then begin//4
 noi:=select(2,145);
 if noi=1 then begin //5
 ho.quest_flag:=true;
 ho.quest_activ:=n_o.quest_activ;
 n_o.quest_flag:=false;
 n_o.quest_activ:=quest_generate(100);
 
 end;//5
 end;//4
  end;//3
end;//2.0
until menu_key='0';
npc_output.nb1:=n_o;
npc_output.nb2:=ho;
log_generate('log_old_generate','hero quest 0-2 '+ho.quest_activ.st[0]);
log_generate('log_old_generate','npc quest 0-2 '+n_o.quest_activ.st[0]);
end;


//27.12.2015
function hero_update(nb:new_body):new_body;
begin
if log='full' then log_generate('log_old_generate','hero update, hero name '+nb.name+' lvl '+inttostr(nb.lvl));


//if nb.name='22' then log_generate('log_old_generate','hero update 1,  '+inttostr(nb.stren));
{
i:=0;

for i:=0 to 4 do begin
//if nb.name='22' then log_generate('log_old_generate','hero update '+inttostr(i)+'- '+inttostr(nb.j[i].stren));
nb.stren:=nb.stren+nb.j[i].stren;
nb.intel:=nb.intel+nb.j[i].intel;
nb.agility:=nb.agility+nb.j[i].agility;

nb.hp:=nb.hp+nb.j[i].hp;
nb.mp:=nb.mp+nb.j[i].mp;
//hero_update.j[i]:=nb.j[i];
end;
}
//if nb.name='22' then log_generate('log_old_generate','hero update 2,  '+inttostr(nb.stren));
nb.hp:=(10*nb.lvl)+(nb.stren*2)+nb.agility;
nb.mp:=(10*nb.lvl)+(nb.intel*2);
{
hero_update.stren:=nb.stren;
hero_update.intel:=nb.intel;
hero_update.agility:=nb.agility;

hero_update.sex:=nb.sex;
hero_update.race:=nb.race;
//vichisl
hero_update.hp:=nb.hp;
hero_update.mp:=nb.mp;}

nb.attak:=4+nb.stren;
nb.defense:=4+nb.agility;
{hero_update.ves:=nb.ves;
//obnov
hero_update.exp:=nb.exp;
hero_update.lvl:=nb.lvl;
hero_update.gold:=nb.gold;
hero_update.x:=nb.x;
hero_update.y:=nb.y;}
nb.dmg:=nb.attak*4;
nb.ign_dmg:=nb.defense*4;
{
i:=1;
for i:=1 to 5 do begin
nb.init:=nb.init+nb.s[i].init;
nb.masking:=nb.masking+nb.s[i].masking;
nb.obser:=nb.obser+nb.s[i].obser;

//boev
nb.dmg:=nb.attak+nb.s[i].base_dmg;
nb.ign_dmg:=nb.defense+nb.s[i].base_defense;
//invent

end;
}
{
//story
hero_update.st0:=nb.st0;
hero_update.st1:=nb.st1;
hero_update.st2:=nb.st2;
hero_update.st3:=nb.st3;
//bag
for i:=0 to 99 do
hero_update.bag[i]:=nb.bag[i];}
hero_update:=nb;
end;

//07.11.2015
function npc_generate(i_n,j_n:integer; sid:byte; tip:byte):new_body;
var
st:string;
stg:byte;
tx,ty:word;
begin
if log='full' then log_generate('log_old_generate','nps generate sig '+inttostr(sid)+' tip '+inttostr(tip));
npc_generate.lvl:=1;
//ocnov
npc_generate.name:=name_generate('human');
npc_generate.stren:=random(5)+1;
npc_generate.intel:=random(5)+1;
npc_generate.agility:=random(5)+1;
npc_generate.sex:=1;
if sid=1 then npc_generate.race:=1 else npc_generate.race:=random(3)+1;

npc_generate.ves:=random(50)+1;
//obnov
npc_generate.exp:=random(50)+1;

npc_generate.xd:=0;
npc_generate.yd:=0;
npc_generate.gold:=random(100)+50;
if tip=1 then npc_generate.x:=i_n;
if tip=1 then npc_generate.y:=j_n;

if tip=2 then begin//1
repeat
begin
tx:=i_n-random(100)+random(100);;
ty:=j_n-random(100)+random(100);;
end;
until (tx>11)and(tx<x_map-11)and(ty>11)and(ty<y_map-11);
npc_generate.x:=tx;
npc_generate.y:=ty;
end;//1

npc_generate.init:=random(5)+1;
npc_generate.masking:=random(5)+1;
npc_generate.obser:=random(5)+1;
npc_generate.point:=0;//21.12.2015

//invent
for i:=0 to 4 do npc_generate.j[i]:=beast_inv_generate('null');
for i:=1 to 5 do npc_generate.s[i]:=beast_inv_generate('null');
{
npc_generate.s[1]:=beast_inv_generate('helm');
npc_generate.s[2]:=beast_inv_generate('dress');
npc_generate.s[3]:=beast_inv_generate('shoes');
npc_generate.s[4]:=beast_inv_generate('sword');
npc_generate.s[5]:=beast_inv_generate('shield');

npc_generate.j[0]:=beast_inv_generate('ring');
npc_generate.j[1]:=beast_inv_generate('ring');
npc_generate.j[2]:=beast_inv_generate('link');
npc_generate.j[3]:=beast_inv_generate('link');
npc_generate.j[4]:=beast_inv_generate('amulet');
}
for k2:=0 to 4 do begin//bg1
stg:=random(6);
if stg=0 then st:='helm';
if stg=1 then st:='dress';
if stg=2 then st:='shoes';
if stg=3 then st:='sword';
if stg=4 then st:='shield';
if stg=5 then st:='ring';
if stg=6 then st:='link';
if stg=7 then st:='amulet';
npc_generate.bag[k2]:=beast_inv_generate(st);

end;//bg1
for k2:=5 to 99 do begin//bg2
npc_generate.bag[k2]:=beast_inv_generate('null');
end;//bg2
//story
npc_generate.st0:=story_npc('b',0);
npc_generate.st1:=story_npc('s',0);
npc_generate.st2:=story_npc('w',0);
repeat k:=random(9); until k>0;
//log_generate('log_old_generate','nps generate '+inttostr(k0)+' '+story_npc('l',k0));
npc_generate.st3:=text[128]+' '+story_npc('l',k);
//qest
npc_generate.quest_activ:=quest_generate(100);
npc_generate.quest_flag:=false;
//prof
for k0:=0 to 9 do npc_generate.prof[k0]:=0;
npc_generate.prof[k]:=1;
npc_generate:=hero_update(npc_generate);
end;


//+27.08.2015
procedure equip (command:string;inv:inventory);
begin//+30.08.2015
{if command='slot_1' then begin //1
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
end;//5}
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
 if command='null' then begin//4
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
//if hero.bag[i].types=0 then begin hero.bag[i]:=inventory_generation('ingredient',command1,hero.lvl); exit; end;

end;//2
end;//1
end;

procedure typ_generate(command:string);//+25.10.2015
var
s:string;

begin
if log='full' then log_generate('log_old_generate','tip_generate');
s:='res/mob/typ.type';
//log_generate('log_old_generate','tip_generate_stop');
assign(f_typ,s);
reset(f_typ);
readln(f_typ,s_typ[0]);
k1:=0;
for m:=0 to  4 do begin //1
readln(f_typ,s_typ[m]);
delete(s_typ[m],1,8);
for n:=0 to 9 do begin//2
readln(f_typ,s_podtyp[k1]);
delete(s_podtyp[k1],1,11);
k1:=k1+1;
end;//2
end;//1
if log='full' then log_generate('log_old_generate','k1 '+inttostr(k1));
close(f_typ);

//typ_generate:='';
end;


//21.02.2016
function auto_lvlup(al:new_body):new_body;

begin
//al:=hero_update(al);
if log='full' then log_generate('log_old_generate','avto levelup, mob name '+al.name+' lvl '+inttostr(al.lvl));
if al.exp>=al.lvl*5 then begin//1
al.exp:=0;
al.lvl:=al.lvl+1;

if (al.stren>=al.intel)and(al.stren>=al.agility) then al.stren:=al.stren+1;
if (al.intel>=al.stren)and(al.intel>=al.agility) then al.intel:=al.intel+1;
if (al.agility>=al.intel)and(al.agility>=al.stren) then al.agility:=al.agility+1;
end;//1
al:=hero_update(al);
auto_lvlup:=al;
end;


//08.02.2016
//++21.02.2016
function mob_battle(mb1,mb2:new_body):temp;

begin
//mb1:=hero_update(mb1);mb2:=hero_update(mb2);
if log='full' then log_generate('log_old_generate','mob batle, mob1 name '+mb1.name+' , mob2 name '+mb2.name+' lvl1 '+inttostr(mb1.lvl)+' lvl2 '+inttostr(mb2.lvl));
if log='full' then log_generate('log_old_generate','mb1_hp- '+inttostr(mb1.hp)+' '+inttostr(mb2.hp));
if log='full' then log_generate('log_old_generate','mb1_dmg- '+inttostr(mb1.dmg)+' '+inttostr(mb2.dmg));
if log='full' then log_generate('log_old_generate','mb1_ign_dmg- '+inttostr(mb1.ign_dmg)+' '+inttostr(mb2.ign_dmg));
if (mb1.hp>0)and (mb2.hp>0) then begin//0
 repeat begin//1
if mb1.dmg>mb2.ign_dmg then begin mb2.hp:=mb2.hp-abs(mb1.dmg-mb2.ign_dmg);mb1.hp:=mb1.hp-(mb2.dmg div 4); end;
if mb2.dmg>mb1.ign_dmg then begin mb1.hp:=mb1.hp-abs(mb2.dmg-mb1.ign_dmg) ;mb2.hp:=mb2.hp-(mb1.dmg div 4); end;
if (mb2.dmg<=mb1.ign_dmg) or (mb1.dmg<=mb2.ign_dmg)then begin mb1.hp:=mb1.hp-(mb2.dmg div 4);  mb2.hp:=mb2.hp-(mb1.dmg div 4); end;
if log='full' then log_generate('log_old_generate','mb_x- '+inttostr(mb1.hp)+' '+inttostr(mb2.hp));
end;//1
until (mb2.hp<=0) or(mb1.hp<=0);
end;//0
if mb1.hp>0 then begin mb1.exp:=mb1.exp+10; mb1:=auto_lvlup(mb1); mob_battle.nb1:=mb1;mob_battle.nb2:=mb2;  end;
if mb2.hp>0 then begin mb2.exp:=mb2.exp+10;  mb2:=auto_lvlup(mb2); mob_battle.nb1:=mb1; mob_battle.nb2:=mb2; end;
if  (mb1.hp<=0) then begin {mb1:=hero_update(mb1);}  mob_battle.nb1:=mb1; mob_battle.nb2:=mb2; end;
if (mb2.hp<=0)  then begin{ mb2:=hero_update(mb2); } mob_battle.nb1:=mb1; mob_battle.nb2:=mb2; end;
if log='full' then log_generate('log_old_generate','mb2- '+inttostr(mb1.hp)+' '+inttostr(mb2.hp));
end;


//21.02.2016
function undead(ud:new_body;tim:byte):new_body;
begin
if log='full' then log_generate('log_old_generate','undead, mob name '+ud.name+' lvl '+inttostr(ud.lvl));
if (tim>0) and (tim<=20) then begin ud.race:=5; ud.stren:=ud.stren+5; end;
if (tim>20) and (tim<=80) then begin ud.race:=6; ud.agility:=ud.agility+5;end;
if (tim>80) and (tim<=100) then begin ud.race:=7; ud.intel:=ud.intel+5;end;
ud:=hero_update(ud);
undead:=ud;
if (ud.hp<0) or (ud.hp>1000) then log_generate('log_old_generate','undead, mob name '+ud.name+' lvl '+inttostr(ud.lvl));
end;



procedure evolution(evo:integer);
var e_i,e_i1:integer;
begin
writeln	(text[124]);
for e_i:=0 to evo do begin//1

for e_i1:=0 to 9999 do begin//2
//ClrScr;
//writeln	(text[124],' ',inttostr(e_i),' ',inttostr(e_i1));
 //log_generate('log_old_generate',text[124]+' '+inttostr(e_i)+' '+inttostr(e_i1)+' '+inttostr(mob[e_i1].hp)+' '+inttostr(mob[e_i1].hp));
if (mob[e_i1].hp>1)and(mob[e_i1+1].hp>1) then temp_battle:=mob_battle(mob[e_i1],mob[e_i1+1]);

mob[e_i1]:=temp_battle.nb1;
mob[e_i1+1]:=temp_battle.nb2;
// log_generate('log_old_generate','1- '+inttostr(mob[e_i1].hp)+' '+inttostr(mob[e_i1].hp));

if mob[e_i1].hp<=0 then mob[e_i1]:=undead(mob[e_i1],random(100));
if mob[e_i1+1].hp<=0 then mob[e_i1+1]:=undead(mob[e_i1+1],random(100));
// log_generate('log_old_generate','2- '+inttostr(mob[e_i1].hp)+' '+inttostr(mob[e_i1].hp));


end;//2
end;//1
end;



function lvlup(ll:new_body):new_body;
begin
if ll.point>0 then evolution(1);
if ll.exp>=ll.lvl*5 then begin//1
ll.exp:=0;
ll.lvl:=ll.lvl+1;
ll.point:=ll.point+1;

repeat begin
if ll.point>0 then ll:=hero_update(ll);

//20.12.2015
clrscr;
writeln(text[97]);
writeln('----------------------------------------');
writeln('|',name_tab(text[8],20),' ',name_tab(inttostr(ll.lvl),20),'|');
writeln('|',name_tab(text[26],20),' ',name_tab(inttostr(ll.stren),18),'+1','|');
writeln('|',name_tab(text[27],20),' ',name_tab(inttostr(ll.intel),18),'+2','|');
writeln('|',name_tab(text[28],20),' ',name_tab(inttostr(ll.agility),18),'+3','|');
writeln('|',name_tab(text[98],20),' ',name_tab(inttostr(ll.point),20),'|');
writeln('|',name_tab(text[99],20),' ',name_tab(inttostr(ll.dmg),20),'|');
writeln('|',name_tab(text[100],20),' ',name_tab(inttostr(ll.ign_dmg),20),'|');
writeln('|',name_tab(text[5],20),' ',name_tab(inttostr(ll.hp),20),'|');
writeln('----------------------------------------');
writeln(text[90]);


menu_key:=readkey;
case menu_key of
'1':begin if ll.point>0 then begin ll.stren:=ll.stren+1;ll.point:=ll.point-1; end; end;
'2':begin if ll.point>0 then begin ll.intel:=ll.intel+1;ll.point:=ll.point-1;end;end;
'3':begin if ll.point>0 then begin ll.agility:=ll.agility+1;ll.point:=ll.point-1;end;end;
end;end;
until menu_key='0';
end;//1
lvlup:=ll;
end;


function hero_generate(h:string):new_body;//+12.08.2015
begin
clrscr;
if h='hero_new' then begin //0//+15.08.2015
//log_generate('log_old_generate','hero_generate '+'start -1-');
writeln(text[20]);readln(s);
hero_generate.name:=s;
writeln(text[21]);
m:=0;
repeat begin//0.1
menu_key:=readkey;
case menu_key of//0.2
'1': begin hero_generate.sex:=1;m:=1;end;//М
'2':begin hero_generate.sex:=2;m:=1;end;//Ж
else
writeln(text[24]);
end;//0.2
end;//0.1
until m=1;
m:=0;
writeln(text[22]);
writeln('1- '+text[112]);
writeln('2- '+text[113]);
writeln('3- '+text[114]);
writeln('4- '+text[115]);
repeat begin//0.11
menu_key:=readkey;
case menu_key of//0.21
'1':begin  hero_generate.race:=1;m:=1;
hero_generate.stren:=2;
hero_generate.intel:=4;
hero_generate.agility:=4;
end;//human
'2':begin hero_generate.race:=2;m:=1;
hero_generate.stren:=4;
hero_generate.intel:=2;
hero_generate.agility:=4;
end;//ork
'3':begin hero_generate.race:=3;m:=1;
hero_generate.stren:=2;
hero_generate.intel:=6;
hero_generate.agility:=2;
end;//elf
'4':begin hero_generate.race:=4;m:=1;
hero_generate.stren:=6;
hero_generate.intel:=2;
hero_generate.agility:=2;
end;//dwarf
else
writeln(text[24]);
end;//0.21
end;//0.11
until m=1;
if log='full' then log_generate('log_old_generate','hero_generate '+'-2- ');
//08.11.2015
//+16.11.2015
hero_generate.x:=oz_list[1].x+10;
hero_generate.y:=oz_list[1].y;
hero_generate.xd:=0;
hero_generate.yd:=0;

{
hero_generate.stren:=1;
hero_generate.intel:=1;
hero_generate.agility:=1;}
hero_generate.init:=1;
hero_generate.masking:=1;
hero_generate.obser:=1;

hero_generate.lvl:=1;

hero_generate.hp:=10*hero_generate.lvl;
hero_generate.mp:=10*hero_generate.lvl;
hero_generate.exp:=0;

if log='full' then log_generate('log_old_generate','hero_generate '+'-3- ');
//hero.veapon:=4;
//hero.armor:=4;
hero_generate.attak:=4+hero_generate.stren;
hero_generate.defense:=4+hero_generate.agility;
hero_generate.dmg:=4*hero_generate.attak;
hero_generate.ign_dmg:=4*hero_generate.defense;
hero_generate.gold:=100;//-----------------------------temp!!!---delete
hero_generate.point:=0;//22.12.2015//++23.12.2015//++02.03.2016
for i:=0 to 4 do hero_generate.j[i]:=beast_inv_generate('null');
for i:=1 to 5 do hero_generate.s[i]:=beast_inv_generate('null');
{
hero_generate.s[1]:=beast_inv_generate('helm');
hero_generate.s[2]:=beast_inv_generate('dress');
hero_generate.s[3]:=beast_inv_generate('shoes');
hero_generate.s[4]:=beast_inv_generate('sword');
hero_generate.s[5]:=beast_inv_generate('shield');

hero_generate.j[0]:=beast_inv_generate('ring');
hero_generate.j[1]:=beast_inv_generate('ring');
hero_generate.j[2]:=beast_inv_generate('link');
hero_generate.j[3]:=beast_inv_generate('link');
hero_generate.j[4]:=beast_inv_generate('amulet');}
if log='full' then log_generate('log_old_generate','hero_generate '+'-4- ');
//+06.09.2015
//++01.01.2016
//
for n:=0 to 2 do hero_generate.bag[n]:=beast_inv_generate('ring');
for n:=3 to 99 do hero_generate.bag[n]:=beast_inv_generate('null');
if log='full' then log_generate('log_old_generate','hero_generate'+' -5- ');
//qest
hero_generate.quest_activ:=quest_generate(100);
hero_generate.quest_flag:=false;
//prof
for i:=0 to 9 do hero_generate.prof[i]:=0;
//magic
for i:=0 to 3 do hero_generate.magic[i]:=0;
end;//0

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
//+25.10.2015

monster.typ:=random(4);
monster.podtyp:=random(50);
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
var
Zip: TZipper;
F:TZipFileEntries;
begin
ClrScr;
writeln(text[17],' ',hero.name);
log_generate('log_old_generate','start save hero');
if (lang_s='w_rus')or(lang_s='w_eng') then assign(hero_save,'res\save\hero.save');
if lang_s='u_rus' then assign(hero_save,'res/save/hero.save');
rewrite(hero_save);
write(hero_save,hero);
close(hero_save);
writeln(text[17],' ',text[76]);
{NPC}log_generate('log_old_generate','start save npc');
if (lang_s='w_rus')or(lang_s='w_eng') then assign(npc_save,'res\save\npc.save');
if lang_s='u_rus' then assign(npc_save,'res/save/npc.save');
rewrite(npc_save);
for i:=0 to 17000 do begin//1.1
write(npc_save,npc[i]);
end;//1.1
close(npc_save);


{MOB}log_generate('log_old_generate','start save mob');
writeln(text[17],' ',text[118]);
if (lang_s='w_rus')or(lang_s='w_eng') then assign(mob_save,'res\save\mob.save');
if lang_s='u_rus' then assign(mob_save,'res/save/mob.save');
rewrite(mob_save);
for i:=0 to 10000 do begin//1.1
write(mob_save,mob[i]);
end;//1.1
close(mob_save);

{BEAST}log_generate('log_old_generate','start save beast');
writeln(text[17],' ',text[119]);
if (lang_s='w_rus')or(lang_s='w_eng') then assign(beast_save,'res\save\beast.save');
if lang_s='u_rus' then assign(beast_save,'res/save/beast.save');
rewrite(beast_save);
for i:=0 to 10000 do begin//1.1
write(beast_save,beast_list[i]);
end;//1.1
close(beast_save);

{OZ}log_generate('log_old_generate','start save oz');
writeln(text[17],' ',text[75]);
if (lang_s='w_rus')or(lang_s='w_eng') then assign(oz_save,'res\save\oz.save');
if lang_s='u_rus' then assign(oz_save,'res/save/oz.save');
rewrite(oz_save);
for i:=0 to 100 do begin//1.1
write(oz_save,oz_list[i]);
end;//1.1
close(oz_save);


{PYST}log_generate('log_old_generate','start save pyst');
writeln(text[17],' ',text[74]);
if (lang_s='w_rus')or(lang_s='w_eng') then assign(pyst_save,'res\save\pyst.save');
if lang_s='u_rus' then assign(pyst_save,'res/save/pyst.save');
rewrite(pyst_save);
for i:=0 to 1000 do begin//1.1
write(pyst_save,pyst_list[i]);
end;//1.1
close(pyst_save);

log_generate('log_old_generate','start save map');
writeln(text[17],' ',text[9]);
if (lang_s='w_rus')or(lang_s='w_eng') then assign(map_save,'res\save\map.save');
if lang_s='u_rus' then assign(map_save,'res/save/map.save');
rewrite(map_save);
for i:=0 to x_map do begin//1.1
	for j:=0 to y_map do begin//1.2
write(map_save,map[i,j]);
end;end;//1.1//1.2
close(map_save);
writeln(text[18]);
writeln(text[94]);
log_generate('log_old_generate','start zip');
 F:=TZipFileEntries.Create(TZipFileEntry);
if (lang_s='w_rus')or(lang_s='w_eng') then  begin
   F.AddFileEntry('res\save\hero.save','hero.save');
   F.AddFileEntry('res\save\npc.save','npc.save');
   F.AddFileEntry('res\save\map.save','map.save');
   F.AddFileEntry('res\save\mob.save','mob.save');
   F.AddFileEntry('res\save\beast.save','beast.save');
   F.AddFileEntry('res\save\oz.save','oz.save');
   F.AddFileEntry('res\save\pyst.save','pyst.save');
end;
if lang_s='u_rus' then  begin
   F.AddFileEntry('res/save/hero.save','hero.save');
   F.AddFileEntry('res/save/npc.save','npc.save');
   F.AddFileEntry('res/save/map.save','map.save');
   F.AddFileEntry('res/save/mob.save','mob.save');
   F.AddFileEntry('res/save/beast.save','beast.save');
   F.AddFileEntry('res/save/oz.save','oz.save');
   F.AddFileEntry('res/save/pyst.save','pyst.save');
end;
 zip:=TZipper.Create;
if (lang_s='w_rus')or(lang_s='w_eng') then   zip.FileName:='res\save\save.zip';
if lang_s='u_rus' then   zip.FileName:='res/save/save.zip';
 zip.ZipFiles(F);
 Zip.Free;
 F.Free;
 log_generate('log_old_generate','stop zip');
writeln(text[94],' ',text[2]);
if (lang_s='w_rus')or(lang_s='w_eng') then  begin
DeleteFile('res\save\hero.save');
DeleteFile('res\save\npc.save');
DeleteFile('res\save\map.save');
DeleteFile('res\save\mob.save');
DeleteFile('res\save\beast.save');
DeleteFile('res\save\oz.save');
DeleteFile('res\save\pyst.save');
end;
if (lang_s='u_rus')or(lang_s='u_eng') then  begin
DeleteFile('res/save/hero.save');
DeleteFile('res/save/npc.save');
DeleteFile('res/save/map.save');
DeleteFile('res/save/mob.save');
DeleteFile('res/save/beast.save');
DeleteFile('res/save/oz.save');
DeleteFile('res/save/pyst.save');
end;
writeln(text[95]);
writeln(text[96]);
readln();
end;
procedure load;
var
  UnZipper: TUnZipper;

begin
ClrScr;
if log='full' then log_generate('log_old_generate','start UnZip');
 UnZipper := TUnZipper.Create;
 // try
  if (lang_s='w_rus')or (lang_s='w_eng') then    UnZipper.FileName := 'res\save\save.zip';
  if (lang_s='w_rus')or (lang_s='w_eng') then    UnZipper.OutputPath := 'res\save\';
  if (lang_s='u_rus')or(lang_s='u_eng') then    UnZipper.FileName := 'res/save/save.zip';
  if (lang_s='u_rus')or(lang_s='u_eng')  then    UnZipper.OutputPath := 'res/save/';
 // if lang_s='u_eng' then    UnZipper.FileName := 'res/save/save.zip';
//  if lang_s='u_eng' then    UnZipper.OutputPath := 'res/save/';
 // if lang_s='w_eng' then    UnZipper.FileName := 'res\save\save.zip';
 // if lang_s='w_eng' then    UnZipper.OutputPath := 'res\save\';
    UnZipper.Examine;
    UnZipper.UnZipAllFiles;
 // finally
    UnZipper.Free;
if log='full' then  log_generate('log_old_generate','stop UnZip');
if log='full' then log_generate('log_old_generate','start hero.save');
if (lang_s='w_rus')or(lang_s='w_eng') then  assign(hero_save,'res\save\hero.save');
if lang_s='u_rus' then  assign(hero_save,'res/save/hero.save');
if lang_s='u_eng' then  assign(hero_save,'res/save/hero.save');
reset(hero_save);
read(hero_save,hero);
close(hero_save);

if (lang_s='w_rus')or(lang_s='w_eng') then  assign(npc_save,'res\save\npc.save');
if lang_s='u_rus' then  assign(npc_save,'res/save/npc.save');
if lang_s='u_eng' then  assign(npc_save,'res/save/npc.save');

reset(npc_save);
for i:=0 to 17000 do begin//1.1
read(npc_save,npc[i]);
end;//1.1
close(npc_save);

if (lang_s='w_rus')or(lang_s='w_eng') then  assign(mob_save,'res\save\mob.save');
if lang_s='u_rus' then  assign(mob_save,'res/save/mob.save');
if lang_s='u_eng' then  assign(mob_save,'res/save/mob.save');
reset(mob_save);
for i:=0 to 10000 do begin//1.1
read(mob_save,mob[i]);
end;//1.1
close(mob_save);


if (lang_s='w_rus')or(lang_s='w_eng') then  assign(beast_save,'res\save\beast.save');
if lang_s='u_rus' then  assign(beast_save,'res/save/beast.save');
if lang_s='u_eng' then  assign(beast_save,'res/save/beast.save');
reset(beast_save);
for i:=0 to 10000 do begin//1.1
read(beast_save,beast_list[i]);
end;//1.1
close(beast_save);

if (lang_s='w_rus')or(lang_s='w_eng') then  assign(oz_save,'res\save\oz.save');
if lang_s='u_rus' then  assign(oz_save,'res/save/oz.save');
if lang_s='u_eng' then  assign(oz_save,'res/save/oz.save');
reset(oz_save);
for i:=0 to 100 do begin//1.1
read(oz_save,oz_list[i]);
end;//1.1
close(oz_save);


if (lang_s='w_rus')or(lang_s='w_eng') then  assign(pyst_save,'res\save\pyst.save');
if lang_s='u_rus' then  assign(pyst_save,'res/save/pyst.save');
if lang_s='u_eng' then  assign(pyst_save,'res/save/pyst.save');
reset(pyst_save);
for i:=0 to 1000 do begin//1.1
read(pyst_save,pyst_list[i]);
end;//1.1
close(pyst_save);

if (lang_s='w_rus')or(lang_s='w_eng') then  assign(map_save,'res\save\map.save');
if lang_s='u_rus' then  assign(map_save,'res/save/map.save');
if lang_s='u_eng' then  assign(map_save,'res/save/map.save');
reset(map_save);
for i:=0 to x_map do begin//1.1
	for j:=0 to y_map do begin//1.2
read(map_save,map[i,j]);
end;end;//1.1//1.2
close(map_save);
writeln(text[19]);
if (lang_s='w_rus')or(lang_s='w_eng') then  begin
  DeleteFile('res\save\hero.save');
  DeleteFile('res\save\npc.save');
  DeleteFile('res\save\map.save');
  DeleteFile('res\save\mob.save');
  DeleteFile('res\save\beast.save');
  DeleteFile('res\save\oz.save');
  DeleteFile('res\save\pyst.save');
end;
if (lang_s='u_rus')or(lang_s='u_eng') then  begin
  DeleteFile('res/save/hero.save');
  DeleteFile('res/save/npc.save');
  DeleteFile('res/save/map.save');
  DeleteFile('res/save/mob.save');
  DeleteFile('res/save/beast.save');
  DeleteFile('res/save/oz.save');
  DeleteFile('res/save/pyst.save');
end;
writeln(text[95]);
writeln(text[96]);
readln();
end;




//22.02.2016
function hero_battle(hb1,hb2:new_body):temp;
//hb1-hero, hb2-mob
var
flag:boolean;
begin
repeat begin
flag:=true;
clrscr;
writeln(text[11]);
writeln('----------------------------------------');
writeln('|',name_tab(text[131],10),' ',name_tab(hb1.name,10),'|',name_tab(hb2.name,10),'|');
writeln('|',name_tab(text[8],10),' ',name_tab(inttostr(hb1.lvl),10),'|',name_tab(inttostr(hb2.lvl),10),'|');
writeln('|',name_tab(text[5],10),' ',name_tab(inttostr(hb1.hp),10),'|',name_tab(inttostr(hb2.hp),10),'|');
writeln('|',name_tab(text[99],10),' ',name_tab(inttostr(hb1.dmg),10),'|',name_tab(inttostr(hb2.dmg),10),'|');
writeln('|',name_tab(text[100],10),' ',name_tab(inttostr(hb1.ign_dmg),10),'|',name_tab(inttostr(hb2.ign_dmg),10),'|');
writeln('----------------------------------------');
writeln('0- ',text[125]);
writeln('1- ',text[130]);
writeln('2- ',text[129]);

writeln(text[90]);
menu_key:=readkey;
case menu_key of
'1':begin //1.0
 if hb1.dmg>=hb2.ign_dmg then hb2.hp:=hb2.hp-abs(hb1.dmg-hb2.ign_dmg); 
 if hb1.dmg<hb2.ign_dmg then hb2.hp:=hb2.hp-((hb1.dmg div 4)+1);

if hb2.dmg>=hb1.ign_dmg then hb1.hp:=hb1.hp-abs(hb2.dmg-hb1.ign_dmg) else hb1.hp:=hb1.hp-((hb2.dmg div 4)+1);
end;//1.0
'2':begin hb1.hp:=hb1.hp+100; end;
'0':begin flag:=false; hero_battle.nb1:=hb1; hero_battle.nb2:=hb2; end;
end;end;
until (menu_key='0')or(hb1.hp<=0)or(hb2.hp<=0);
if (hb1.hp>0)and(flag=true) then begin hb1.exp:=hb1.exp+10; hb1:=lvlup(hb1); hero_battle.nb1:=hb1;hero_battle.nb2:=hb2;  end;
if( hb2.hp>0 )and(flag=true)then begin hb2.exp:=hb2.exp+10;  hb2:=auto_lvlup(hb2); hero_battle.nb1:=hb1; hero_battle.nb2:=hb2; end;
if hb1.hp<=0 then begin clrscr; writeln(text[132]); halt; end;
end;




//29.11.2015
function hunt(bb:beast_body):beast_body;
var i0:integer;
begin
i0:=0;
//repeat begin//0


i:=1;
repeat begin//1
clrscr;
writeln(text[36], i0);
i0:=i0+1;
writeln(text[35]);
writeln(text[14],': ',i);
writeln('----------------------------------------');
writeln('|',name_tab(hero.name,20),name_tab(bb.name,20),'|');
writeln('|',name_tab(text[5],20),name_tab(text[5],20),'|');
writeln('|',name_tab(inttostr(hero.hp),20), name_tab(inttostr(bb.hp),20),'|');
//writeln('|',text[6],'             ', text[6],'|');
//writeln('|',hero.mp,'             ', bb.mp,'|');
writeln('|',name_tab(text[12],20), name_tab(text[12],20),'|');
writeln('|',name_tab(inttostr(hero.dmg),20),name_tab(inttostr(bb.dmg),20),'|');
writeln('--------------------------------------');
writeln(text[13],hero.ign_dmg,'    ',bb.ign_dmg );
writeln(text[7],hero.exp );
writeln(text[8],hero.lvl );
i:=i+1;
if monster.dmg>=hero.ign_dmg then hero.hp:=hero.hp-abs(bb.dmg-hero.ign_dmg) else hero.hp:=hero.hp-(bb.dmg div 4);

if hero.dmg>=bb.ign_dmg then bb.hp:=monster.hp-abs(hero.dmg-bb.ign_dmg) else bb.hp:=bb.hp-(hero.dmg div 4);
//monster.hp:=monster.hp-abs(hero.dmg-monster.ign_dmg);
writeln('-------------------');
writeln(text[37],abs(bb.dmg-hero.ign_dmg));
writeln(text[38],abs(hero.dmg-bb.ign_dmg));
writeln('-------------------');
writeln(text[96]);
readln();
delay(500);
end;//1
until (hero.hp<=0) or(bb.hp<=0);
if hero.hp<=0 then exit;
if bb.hp<=0 then begin//2
hunt.flag_life:=0;
hunt.hp:=0;
map[bb.x,bb.y].tip:=5;
hero.hp:=10*hero.lvl;///-------------test----------------------
hero.gold:=hero.gold+10;//bb.gold;
hero.exp:=hero.exp+10;//bb.exp;
writeln(text[96]);
readln();
//drop('monster_beast',bb.name);
hero:=lvlup(hero);

writeln(text[15]);
delay(500);
writeln(text[96]);
readln();

end;//2

hunt.dmg:=bb.dmg;
hunt.ign_dmg:=bb.ign_dmg;
hunt.name:=bb.name;
//hunt.flag_life:=bb.flag_life;
hunt.flag_hishn:=bb.flag_hishn;
hunt.skin:=bb.skin;
hunt.meat:=bb.meat;
hunt.teeth:=bb.teeth;
hunt.bones:=bb.bones;
hunt.clutches:=bb.clutches;
//end;//0
//until readkey='1';
end;

procedure battle;
var i0:integer;
begin
if log='full' then log_generate('log_old_generate','battle');
i0:=0;
repeat begin//0

hero_generate('monster_human');
i:=1;
repeat begin//1
clrscr;
writeln(text[36], i0);
i0:=i0+1;
writeln(text[35]);
writeln(text[14],': ',i);
writeln('-------------------------');
writeln('|',hero.name,'           ', s_typ[monster.typ],' ',s_podtyp[monster.podtyp],'|');
writeln('|','     ',monster.name,'|');
if log='full' then log_generate('log_old_generate','monster.name '+monster.name+' type '+s_typ[monster.typ]+' podtype '+s_podtyp[monster.podtyp]);
writeln('|',text[5],'             ', text[5],'|');
writeln('|',hero.hp,'             ', monster.hp,'|');if log='full' then log_generate('log_old_generate','monster.hp '+inttostr(monster.hp));
writeln('|',text[6],'             ', text[6],'|');
writeln('|',hero.mp,'             ', monster.mp,'|');
writeln('|',text[12],'            ', text[12],'|');
writeln('|',hero.dmg ,'           ',monster.dmg,'|');if log='full' then log_generate('log_old_generate','monster.dmg '+inttostr(monster.dmg));
writeln('-------------------------');
writeln(text[13],hero.ign_dmg,'    ',monster.ign_dmg );
writeln(text[7],hero.exp );
writeln(text[8],hero.lvl );
i:=i+1;
if monster.dmg>=hero.ign_dmg then hero.hp:=hero.hp-abs(monster.dmg-hero.ign_dmg) else hero.hp:=hero.hp-(monster.dmg div 4);

if hero.dmg>=monster.ign_dmg then monster.hp:=monster.hp-abs(hero.dmg-monster.ign_dmg) else monster.hp:=monster.hp-(hero.dmg div 4);
//monster.hp:=monster.hp-abs(hero.dmg-monster.ign_dmg);
writeln('-------------------');
writeln(text[37],abs(monster.dmg-hero.ign_dmg));
writeln(text[38],abs(hero.dmg-monster.ign_dmg));
writeln('-------------------');
//readln();
delay(500);
end;//1
until (hero.hp<=0) or(monster.hp<=0);
if hero.hp<=0 then exit;
if monster.hp<=0 then begin//2
hero.hp:=10*hero.lvl;///-------------test----------------------
hero.gold:=hero.gold+monster.gold;
hero.exp:=hero.exp+monster.exp;
drop('monster_beast',monster.name);
hero:=lvlup(hero);

writeln(text[15]);
delay(500);

//readln();

end;//2
end;//0
until readkey='1';
end;



//01.03.2016
function hero_dressed(hd:new_body;number:byte):new_body;
var
bagi,hdi:byte;
begin
hero_dressed:=hd;


log_generate('log_old_generate','hero_dressed '+inttostr(number));
log_generate('log_old_generate','hero_dressed bag tip'+inttostr(hd.bag[number].tip));
log_generate('log_old_generate','hero_dressed j1 tip'+inttostr(hd.j[1].tip));
log_generate('log_old_generate','hero_dressed j0 tip'+inttostr(hd.j[0].tip));
//weapon-------------------------------------------------------------
bagi:=0;
if (hd.bag[number].tip=1)and(hd.s[4].tip= 0 ) then  begin//1
hd.s[4]:=hd.bag[number];
hd.bag[number]:=beast_inv_generate('null');
hd:=hero_get_dress(hd,'o',4,'d');
end;//1

if (hd.bag[number].tip=1)and(hd.s[4].tip= 1 ) then  begin//2
while hd.bag[bagi].tip<>0 do bagi:=bagi+1;
hd.bag[bagi]:=hd.s[4];
hd:=hero_get_dress(hd,'o',4,'u');
hd.s[4]:=beast_inv_generate('null');

hd.s[4]:=hd.bag[number];
hd.bag[number]:=beast_inv_generate('null');
hd:=hero_get_dress(hd,'o',4,'d');
end;//2
//helem-------------------------------------------------------------
bagi:=0;
if (hd.bag[number].tip=2)and(hd.s[1].tip= 0 )and(hd.bag[number].type_subject='helm') then  begin//1
hd.s[1]:=hd.bag[number];
hd.bag[number]:=beast_inv_generate('null');
hd:=hero_get_dress(hd,'o',1,'d');
end;//1

if (hd.bag[number].tip=2)and(hd.s[1].tip= 2 )and(hd.bag[number].type_subject='helm') then  begin//2
while hd.bag[bagi].tip<>0 do bagi:=bagi+1;
hd.bag[bagi]:=hd.s[1];
hd:=hero_get_dress(hd,'o',1,'u');
hd.s[1]:=beast_inv_generate('null');

hd.s[1]:=hd.bag[number];
hd.bag[number]:=beast_inv_generate('null');
hd:=hero_get_dress(hd,'o',1,'d');
end;//2
//dress-------------------------------------------------------------
bagi:=0;
if (hd.bag[number].tip=2)and(hd.s[2].tip= 0 )and(hd.bag[number].type_subject='dress') then  begin//1
hd.s[2]:=hd.bag[number];
hd.bag[number]:=beast_inv_generate('null');
hd:=hero_get_dress(hd,'o',2,'d');
end;//1

if (hd.bag[number].tip=2)and(hd.s[2].tip= 2 )and(hd.bag[number].type_subject='dress') then  begin//2
while hd.bag[bagi].tip<>0 do bagi:=bagi+1;
hd.bag[bagi]:=hd.s[2];
hd:=hero_get_dress(hd,'o',2,'u');
hd.s[2]:=beast_inv_generate('null');

hd.s[2]:=hd.bag[number];
hd.bag[number]:=beast_inv_generate('null');
hd:=hero_get_dress(hd,'o',2,'d');
end;//2
//shoes-------------------------------------------------------------
bagi:=0;
if (hd.bag[number].tip=2)and(hd.s[3].tip= 0 )and(hd.bag[number].type_subject='shoes') then  begin//1
hd.s[3]:=hd.bag[number];
hd.bag[number]:=beast_inv_generate('null');
hd:=hero_get_dress(hd,'o',3,'d');
end;//1

if (hd.bag[number].tip=2)and(hd.s[3].tip= 2 )and(hd.bag[number].type_subject='shoes') then  begin//2
while hd.bag[bagi].tip<>0 do bagi:=bagi+1;
hd.bag[bagi]:=hd.s[3];
hd:=hero_get_dress(hd,'o',3,'u');
hd.s[3]:=beast_inv_generate('null');

hd.s[3]:=hd.bag[number];
hd.bag[number]:=beast_inv_generate('null');
hd:=hero_get_dress(hd,'o',3,'d');
end;//2
//shield-------------------------------------------------------------
bagi:=0;
if (hd.bag[number].tip=2)and(hd.s[5].tip= 0 )and(hd.bag[number].type_subject='shield') then  begin//1
hd.s[5]:=hd.bag[number];
hd.bag[number]:=beast_inv_generate('null');
hd:=hero_get_dress(hd,'o',5,'d');
end;//1

if (hd.bag[number].tip=2)and(hd.s[5].tip= 2 )and(hd.bag[number].type_subject='shield') then  begin//2
while hd.bag[bagi].tip<>0 do bagi:=bagi+1;
hd.bag[bagi]:=hd.s[5];
hd:=hero_get_dress(hd,'o',5,'u');
hd.s[5]:=beast_inv_generate('null');

hd.s[5]:=hd.bag[number];
hd.bag[number]:=beast_inv_generate('null');
hd:=hero_get_dress(hd,'o',5,'d');
end;//2
//amulet-------------------------------------------------------------
bagi:=0;
if (hd.bag[number].tip=7)and(hd.j[4].tip= 0 )then  begin//1
hd.j[4]:=hd.bag[number];
hd.bag[number]:=beast_inv_generate('null');
hd:=hero_get_dress(hd,'j',4,'d');
end;//1

if (hd.bag[number].tip=7)and(hd.j[4].tip= 7 )then  begin//2
while hd.bag[bagi].tip<>0 do bagi:=bagi+1;
hd.bag[bagi]:=hd.j[4];
hd:=hero_get_dress(hd,'j',4,'u');
hd.j[4]:=beast_inv_generate('null');

hd.j[4]:=hd.bag[number];
hd.bag[number]:=beast_inv_generate('null');
hd:=hero_get_dress(hd,'j',4,'d');
end;//2
//ring-------------------------------------------------------------
bagi:=0;
if (hd.bag[number].tip=5)then  begin//2
while hd.bag[bagi].tip<>0 do bagi:=bagi+1;
hdi:=select(2,0);
if hd.j[hdi-1].tip<>0 then begin//3
hd.bag[bagi]:=hd.j[hdi-1];
hd:=hero_get_dress(hd,'j',hdi-1,'u');
hd.j[hdi-1]:=beast_inv_generate('null');
end;//3
hd.j[hdi-1]:=hd.bag[number];
hd.bag[number]:=beast_inv_generate('null');
hd:=hero_get_dress(hd,'j',hdi-1,'d');
end;//2
//link-------------------------------------------------------------
bagi:=0;
if (hd.bag[number].tip=6)then  begin//2
while hd.bag[bagi].tip<>0 do bagi:=bagi+1;
hdi:=select(2,0);
if hd.j[hdi+1].tip<>0 then begin//3
hd.bag[bagi]:=hd.j[hdi+1];
hd:=hero_get_dress(hd,'j',hdi+1,'u');
hd.j[hdi+1]:=beast_inv_generate('null');
end;//3
hd.j[hdi+1]:=hd.bag[number];
hd.bag[number]:=beast_inv_generate('null');
hd:=hero_get_dress(hd,'j',hdi+1,'d');
end;//2
hero_dressed:=hd;
end;

function bag_info(bi:new_body):new_body;//correction 19.03.2016
var
b_l,t_b_l,bi1,bk:byte;
//bss:Set Of 'a'..'z';
bs:array[0..9]of char;
begin
b_l:=0;bi1:=0;
bs[0]:='q';bs[1]:='w';bs[2]:='e';bs[3]:='r';bs[4]:='t';bs[5]:='y';bs[6]:='u';bs[7]:='i';bs[8]:='o';bs[9]:='p';
if log='full' then log_generate('log_old_generate','bag_info');

repeat begin//1.1
b_l:=0;bi1:=0;
clrscr;
writeln(text[117],' (1-9)');
writeln(text[45]);
t_b_l:=(b_l*10)+9;
bk:=b_l*10;
for i:=b_l*10 to t_b_l do begin//1
if bi.bag[i].tip <> 0 then writeln(text[44],' ',i,' ',bi.bag[i].name,' ',item_info(bi.bag[i].tip),' ',text[140],bs[bi1]);
bi1:=bi1+1;
end;//1
writeln(text[90]);
menu_key:=readkey;

case menu_key of//2
'q':bi:=hero_dressed(bi,bk);
'w':bi:=hero_dressed(bi,bk+1); 
'e':bi:=hero_dressed(bi,bk+2); 
'r':bi:=hero_dressed(bi,bk+3); 
't':bi:=hero_dressed(bi,bk+4); 
'y':bi:=hero_dressed(bi,bk+5); 
'u':bi:=hero_dressed(bi,bk+6); 
'i':bi:=hero_dressed(bi,bk+7); 
'o':bi:=hero_dressed(bi,bk+8); 
'p':bi:=hero_dressed(bi,bk+9); 
else b_l:=strtoint(menu_key);
end;//2

end;//1.1
until menu_key='0';
bag_info:=bi;
end;


function hero_output(ho:new_body):new_body;
begin
if log='full' then log_generate('log_old_generate','hero_output ');
repeat begin//1
clrscr;
writeln();
writeln(text[5],' ',ho.hp,' ',text[6],ho.mp );
writeln(text[7],ho.exp,' ',text[8],ho.lvl );
writeln(text[12],ho.dmg,' ',text[13],ho.ign_dmg  );
writeln(text[26],' ',ho.stren );
writeln(text[27],' ',ho.intel );
writeln(text[28],' ',ho.agility );
writeln(text[29],' ',ho.sex );
writeln(text[30],' ',race_output(ho.race) );
writeln(text[31],' ',ho.init );
writeln(text[32],' ',ho.masking ); 
writeln(text[33],' ',ho.obser );
//writeln(magic_out_info(0) );
writeln('        ___');
writeln('       |_1_|       1',text[40],' ',ho.s[1].base_defense,' h- ',text[101]);
writeln('  ___   ___   ___  2',text[40],' ',ho.s[2].base_defense,' d- ',text[103]);
writeln(' | 4 | |   | | 5 | 4',text[41],' ',ho.s[4].base_dmg,' f- ',text[105]);
writeln(' |___| | 2 | |___| 5',text[40],' ',ho.s[5].base_defense,' g- ',text[106]);
writeln('       |___|');
writeln('        ___');
writeln('       |_3_|       3',text[40],' ',ho.s[3].base_defense,' s- ',text[104]);
//+06.09.2015
writeln('#(1-5)- ',text[139]);
writeln('b- ',text[43]);
if ho.quest_flag=true then writeln('q- ',text[144]);
if ho.point>0 then writeln('l- ',text[8]);
writeln(text[90]);

menu_key:=readkey;

case menu_key of
'b':ho:=bag_info(ho);
'h':item_ful_info(ho.s[1]);
'd':item_ful_info(ho.s[2]);
's':item_ful_info(ho.s[3]);
'f':item_ful_info(ho.s[4]);
'g':item_ful_info(ho.s[5]);
'1':item_ful_info(ho.j[0]);
'2':item_ful_info(ho.j[1]);
'3':item_ful_info(ho.j[2]);
'4':item_ful_info(ho.j[3]);
'5':item_ful_info(ho.j[4]);
'l':begin if ho.point>0 then ho:=lvlup(ho); end;
'q':begin if ho.quest_flag=true then quest_output_activ(ho.quest_activ);  end;
end;//2
end;
until menu_key='0';
hero_output:=ho;
end;
{
//22.02.2016
procedure map_out(mx,my:integer);
begin

end;
}
//21.02.2016
function mob_output(m_o:new_body):new_body;
var
tt:temp;
begin
repeat begin//1.0
clrscr;
writeln(m_o.name,' ',text[8],inttostr(m_o.lvl) );
writeln(race_output(m_o.race));
writeln(m_o.st0);
writeln(m_o.st1);
writeln(m_o.st2);
writeln(m_o.st3);
writeln('');
writeln('1- '+text[11]);
writeln('2- '+text[125]);
writeln(text[90]);
menu_key:=readkey;
end;//1.0

case menu_key of//2.0
'1': begin 
if map[m_o.x,m_o.y].tip<>6 then tt:=hero_battle(hero,m_o);
hero:=tt.nb1;
m_o:=tt.nb2;
mob_output:=m_o;
if m_o.hp<=0 then map[m_o.x,m_o.y].tip:=6;
end;
'2': begin 
mob_output:=m_o;
end;
end;//2.0
until (menu_key='0')or (m_o.hp<=0);
end;


//01.11.2015
function map_info(m_i:char):string;
begin
//log_generate('log_old_generate','map_info - m_i -'+m_i);
if m_i='.' then map_info:=text[51];
if m_i=':'then map_info:=text[52];
if m_i=';'then map_info:=text[53];
if m_i='#'then map_info:=text[54];
if m_i='/'then map_info:=text[55];
if m_i='"'then map_info:=text[56];
if m_i='0'then map_info:=text[57];
if m_i='~'then map_info:=text[58];
if m_i='!'then map_info:=text[59];
if m_i='_'then map_info:=text[60];
if m_i='-'then map_info:=text[61];
if m_i='='then map_info:=text[62];
if m_i='^'then map_info:=text[63];
end;

//28.02.2016
procedure mini_map_output(x,y:word);
var
temp_char:char;
temp_color:integer;
begin
if x-1<6 then x:=6;
if x+1>197 then x:=197;
if y-1<11 then y:=11;
if y+1>192 then y:=192;
if (x-1>=7) and(x+1<=198) and (y-1>=12) and (y+1<=193) then begin//2.00
repeat begin//2.0
ClrScr;
temp_char:=mini_map[x,y].structure;
temp_color:=mini_map[x,y].color;
mini_map[x,y].structure:='@';
mini_map[x,y].color:=4;
clrscr;
textcolor(white);

writeln(' _____________________');//top


for i:=x-5 to x+5 do begin//2.1//5
write('|');//left
 for j:=y-10 to y+10 do begin//2.2//10
 {if mini_map[i,j].tip=1 then begin//2.3
 textcolor(10);
 write('@');
 textcolor(white);
 end;//2.3
 if mini_map[i,j].tip=0 then begin//2.4}
 textcolor(mini_map[i,j].color);
 if mini_map[i,j].name=' ' then write(mini_map[i,j].structure);
 if mini_map[i,j].name<>' ' then begin textcolor(white); write(mini_map[i,j].name[1]); end;
 textcolor(white);
 
{ end;//2.4
  if (mini_map[i,j].tip=5)or(mini_map[i,j].tip=6) then begin//2.5
 textcolor(8);
 write('@');
 textcolor(white);
 end;//2.5
  if mini_map[i,j].tip=3 then begin//2.6
 textcolor(5);
 write('@');
 textcolor(white);
 end;//2.6 }
 end;//2.2
 writeln('|');//right
end;//2.1

 writeln(' ---------------------');
// writeln(x,' ',y);
mini_map[x,y].structure:=temp_char;//+16.08.2015
mini_map[x,y].color:=temp_color;//+16.09.2015

writeln	(text[90]);
menu_key:=readkey;
end;//2.0
until menu_key='0';
end;//2.00 
end;



//04.03.2016
function dungeon_output(doi,doj:byte;don:new_body):new_body;
var
temp_char:char;
temp_color:byte;
begin
dungeon_output:=don;
{if x-1<6 then x:=6;
if x+1>198 then x:=198;
if y-1<11 then y:=11;
if y+1>193 then y:=193;
if (x-1>=6) and(x+1<=198) and (y-1>=11) and (y+1<=204-11) then begin//2.00}
repeat begin//2.0
ClrScr;
temp_char:=dungeons[doi,doj].structure;
temp_color:=dungeons[doi,doj].color;
dungeons[doi,doj].structure:='@';
dungeons[doi,doj].color:=4;
clrscr;
textcolor(white);

writeln(' _____________________');//top


for i:=doi-5 to doi+5 do begin//2.1//5
write('|');//left
 for j:=doj-10 to doj+10 do begin//2.2//10

 textcolor(dungeons[i,j].color);
 write(dungeons[i,j].structure);
 
 textcolor(white);
 
 end;//2.2
 writeln('|');//right
end;//2.1

 writeln(' ---------------------');
 writeln(doi,' ',doj);
dungeons[doi,doj].structure:=temp_char;//+16.08.2015
dungeons[doi,doj].color:=temp_color;//+16.09.2015

if (dungeons[doi+1,doj].structure='/')or(dungeons[doi-1,doj].structure='/')
or(dungeons[doi,doj+1].structure='/')or(dungeons[doi,doj-1].structure='/')then 
writeln	('5- ',text[147]);

if (dungeons[doi+1,doj].structure='@')or(dungeons[doi-1,doj].structure='@')
or(dungeons[doi,doj+1].structure='@')or(dungeons[doi,doj-1].structure='@')then 
writeln	('9- ',text[11]);
writeln	(text[90]);
menu_key:=readkey;
end;//2.0
case menu_key of//3.0
'6':begin//3.1
doi:=doi;
if( doj+1<=198)and(dungeons[doi,doj+1].structure='.') then doj:=doj+1 else doj:=doj;
don.yd:=doj;
end;//3.1
'4':begin//3.2
doi:=doi;
if (doj-1>=11)and(dungeons[doi,doj-1].structure='.') then doj:=doj-1 else doj:=doj;
don.yd:=doj;
 end;//3.2
'8':begin//3.3
if (doi-1>=6)and(dungeons[doi-1,doj].structure='.') then doi:=doi-1 else doi:=doi;
doj:=doj;
don.xd:=doi;
 end;//3.3while
'2':begin//3.4
if (doi+1<=198)and(dungeons[doi+1,doj].structure='.') then doi:=doi+1 else doi:=doi;
doj:=doj;
don.xd:=doi;
 end;//3.4
 
'9':begin//3.5
don:=hero_battle(don,npc_generate(1,1,1,1)).nb1;
if dungeons[doi+1,doj].structure='@'then dungeons[doi+1,doj].structure:='.';
if dungeons[doi-1,doj].structure='@'then dungeons[doi-1,doj].structure:='.';
if dungeons[doi,doj+1].structure='@'then dungeons[doi,doj+1].structure:='.';
if dungeons[doi,doj-1].structure='@'then dungeons[doi,doj-1].structure:='.';
 end;//3.5
 
'5': begin//3.6
if (dungeons[doi+1,doj].structure='/')or(dungeons[doi-1,doj].structure='/')
or(dungeons[doi,doj+1].structure='/')or(dungeons[doi,doj-1].structure='/') then
begin//3.6.1
don.xd:=0;
don.yd:=0;
dangeons_flag:=true;
menu_key:='0';
end;//3.6.1

end; //3.6
end;
dungeon_output:=don;
until {(}menu_key='0'{)and((dungeons[doi+1,doj].structure='/')or(dungeons[doi-1,doj].structure='/')
or(dungeons[doi,doj+1].structure='/')or(dungeons[doi,doj-1].structure='/'))};
//end;//2.00 
dungeon_output:=don;
end;


function map_output(x,y:word;mo:new_body):new_body;
var
temp_char:char;
temp_color:integer;
mot:temp;
begin
if  (mo.x=mo.quest_activ.x) and (mo.y=mo.quest_activ.y) then begin//00
 mo.quest_flag:=false;
 mo.quest_activ:=quest_generate(100);
end;//00
if (x-1>=6) and(x+1<=x_map-6) and (y-1>=11) and (y+1<=y_map-11) then begin//2.00

repeat begin//2.0
temp_char:=map[x,y].structure;
temp_color:=map[x,y].color;
map[x,y].structure:='@';
map[x,y].color:=4;
clrscr;
textcolor(white);
writeln(map[x,y].name);{i,j}
//writeln(inttostr(map[x,y].progress));
writeln(' _____________________');//top


for i:=x-5 to x+5 do begin//2.1//5
write('|');//left
 for j:=y-10 to y+10 do begin//2.2//10
 if map[i,j].tip=1 then begin//2.3
 textcolor(10);
 write('@');
 textcolor(white);
 end;//2.3
 if map[i,j].tip=0 then begin//2.4
 textcolor(map[i,j].color);
 write(map[i,j].structure);
 textcolor(white);
 end;//2.4
  if (map[i,j].tip=5)or(map[i,j].tip=6) then begin//2.5
 textcolor(8);
 write('@');
 textcolor(white);
 end;//2.5
  if map[i,j].tip=3 then begin//2.6
 textcolor(5);
 write('@');
 textcolor(white);
 end;//2.6 
 end;//2.2
 writeln('|');//right
end;//2.1

 writeln(' ---------------------');
 //writeln();
map[x,y].structure:=temp_char;//+16.08.2015
map[x,y].color:=temp_color;//+16.09.2015
write(text[34],' ',x,' : ',y,text[71]+map_info(map[x,y].structure));
if (map[x,y].tip<>0) and( map[x,y].tip<>5) and ( map[x,y].tip<>3)and ( map[x,y].tip<>6)then begin write(text[80]+beast_list[map[x,y].beast_index].name);end;
if map[x,y].tip=5 then begin write(text[88]+beast_list[map[x,y].beast_index].name);end;
writeln();
if map[x,y].npc_index<>0 then begin write(text[76]+npc[map[x,y].npc_index].name);writeln(); end;
if map[x,y].mob_index<>0 then begin write(text[118]+' '+mob[map[x,y].mob_index].name);writeln(); end;

write	('6- -> '+text[64]+map_info(map[x,y+1].structure) );
if (map[x,y+1].tip<>0)and( map[x,y+1].tip<>5) and( map[x,y+1].tip<>3)and( map[x,y+1].tip<>6)then begin write(text[80]+beast_list[map[x,y+1].beast_index].name);end;
if map[x,y+1].tip=5 then begin write(text[88]+beast_list[map[x,y+1].beast_index].name);end;
writeln();
write	('4- <- '+text[65]+map_info(map[x,y-1].structure) );
if (map[x,y-1].tip<>0)and( map[x,y-1].tip<>5) and( map[x,y-1].tip<>3)and( map[x,y-1].tip<>6)then begin write(text[80]+beast_list[map[x,y-1].beast_index].name);end;
if map[x,y-1].tip=5 then begin write(text[88]+beast_list[map[x,y-1].beast_index].name);end;
writeln();
write	('8- /\ '+text[67]+map_info(map[x-1,y].structure) );
if (map[x-1,y].tip<>0)and( map[x-1,y].tip<>5)and( map[x-1,y].tip<>3) and( map[x-1,y].tip<>6) then begin write(text[80]+beast_list[map[x-1,y].beast_index].name);end;
if map[x-1,y].tip=5 then begin write(text[88]+beast_list[map[x-1,y].beast_index].name);end;
writeln();
write	('2- \/ '+text[66]+map_info(map[x+1,y].structure) );
if (map[x+1,y].tip<>0)and( map[x+1,y].tip<>5) and( map[x+1,y].tip<>3) and( map[x+1,y].tip<>6)then begin write(text[80]+beast_list[map[x+1,y].beast_index].name);end;
if map[x+1,y].tip=5 then begin write(text[88]+beast_list[map[x+1,y].beast_index].name);end;
writeln();
writeln	('5- ',text[2]);
writeln	('m- ',text[135]);
if map[x,y].npc_index<>0 then writeln	('9- ',text[111]);
//mob!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if( map[x,y].mob_index<>0)and(map[x,y].tip<>6) then writeln	('9- ',text[126]);
if (map[x,y].structure='=')or(map[x,y].structure='_')or(map[x,y].structure='-')then writeln	('d- ',text[142]);

if (map[x,y+1].tip=1)or (map[x,y+1].tip=2)or (map[x,y+1].tip=4)then
{if (map[x,y+1].tip<>0)and (map[x,y+1].tip<>5)and (map[x,y+1].tip<>3)then} writeln	('7- ',text[87]);
if (map[x,y-1].tip=1)or (map[x,y-1].tip=2)or (map[x,y-1].tip=4)then
{if (map[x,y-1].tip<>0)and(map[x,y-1].tip<>5)and (map[x,y+1].tip<>3)then} writeln	('7- ',text[87]);
if (map[x-1,y].tip=1)or (map[x-1,y].tip=2)or (map[x-1,y].tip=4)then
{if (map[x-1,y].tip<>0)and(map[x-1,y].tip<>5)and (map[x,y+1].tip<>3)then} writeln	('7- ',text[87]);
if (map[x+1,y].tip=1)or (map[x+1,y].tip=2)or (map[x+1,y].tip=4)then
{if (map[x+1,y].tip<>0)and(map[x+1,y].tip<>5)and (map[x,y+1].tip<>3)then} writeln	('7- ',text[87]);
if (map[x,y].tip=1)or (map[x,y].tip=2)or (map[x,y].tip=4)then
{if (map[x,y].tip<>0)and(map[x,y].tip<>5) and (map[x,y+1].tip<>3) then} writeln	('7- ',text[87]);
if (map[x,y].tip=5)or(map[x,y].tip=6) then  writeln	('3- ',text[89]);


//readln(menu_key);
menu_key:=readkey;
end;//2.0

case menu_key of//3.0
'6':begin//3.1
x:=x;
if y+1<={244}2037 then y:=y+1 else y:=y;
mo.y:=y;
//log_generate('log_old_generate','map_output - x - '+inttostr(x)+' - y - '+inttostr(y));
muve(x,y,'test');


end;//3.1
'4':begin//3.2

x:=x;
if y-1>=11 then y:=y-1 else y:=y;

mo.y:=y;
//log_generate('log_old_generate','map_output - x - '+inttostr(x)+' - y - '+inttostr(y));
muve(x,y,'test');

 end;//3.2
'8':begin//3.3
if x-1>=6 then x:=x-1 else x:=x;
y:=y;
mo.x:=x;
//log_generate('log_old_generate','map_output - x - '+inttostr(x)+' - y - '+inttostr(y));
muve(x,y,'test');

 end;//3.3while
'2':begin//3.4
if x+1<={249}2042 then x:=x+1 else x:=x;
y:=y;
mo.x:=x;
//log_generate('log_old_generate','map_output - x - '+inttostr(x)+' - y - '+inttostr(y));
muve(x,y,'test');

 end;//3.4

'9':begin//3.5//+09.11.2015
if map[x,y].npc_index<>0 then begin//3.5.1
mot:=npc_output(npc[map[x,y].npc_index],mo);
npc[map[x,y].npc_index]:=mot.nb1;//npc_output(npc[map[x,y].npc_index]);
mo:=mot.nb2;
mo:=map_output(x,y,mo);
end;//3.5.1
if (map[x,y].mob_index<>0)and(map[x,y].tip<>6) then begin//3.5.1
mob[map[x,y].mob_index]:=mob_output(mob[map[x,y].mob_index]);
mo:=map_output(x,y,mo);
end;//3.5.1
map_output:=mo;
 end;//3.5

'7':begin//3.6
if (map[x,y+1].tip<>0) and(map[x,y+1].tip<>3) then beast_list[map[x,y+1].beast_index]:=hunt(beast_list[map[x,y+1].beast_index]);
if (map[x,y-1].tip<>0)and(map[x,y-1].tip<>3) then beast_list[map[x,y-1].beast_index]:=hunt(beast_list[map[x,y-1].beast_index]);
if (map[x-1,y].tip<>0)and (map[x-1,y].tip<>3)then beast_list[map[x-1,y].beast_index]:=hunt(beast_list[map[x-1,y].beast_index]);
if (map[x+1,y].tip<>0)and (map[x+1,y].tip<>3)then beast_list[map[x+1,y].beast_index]:=hunt(beast_list[map[x+1,y].beast_index]);
if (map[x,y].tip<>0)and (map[x,y].tip<>3)then beast_list[map[x,y].beast_index]:=hunt(beast_list[map[x,y].beast_index]);
 end;//3.6

'3':begin//3.7
mob_temp.nb1:=mo;
if (map[x,y].tip=5)then beast_list[map[x,y].beast_index]:=beast_drop(beast_list[map[x,y].beast_index]);
if (map[x,y].tip=6)then  begin 
mob_temp:=mob_drop(mo,mob[map[x,y].mob_index]); 
mo:=mob_temp.nb1; 
mob[map[x,y].mob_index]:=mob_temp.nb2;
end;
 end;//3.7
 
'm':begin//3.8
mini_map_output(x div 10,y div 10);
 end;//3.8
 
 'd':begin//3.9
if (map[x,y].structure='=')or(map[x,y].structure='_')or(map[x,y].structure='-')then
begin//3.9.1
if (mo.xd=0)and(mo.yd=0) then begin//3.9.2
dungeon_generate(9);
mo.xd:=room_list[0].x;
mo.yd:=room_list[0].y;
end;//3.9.2
mo:=dungeon_output(mo.xd,mo.yd,mo);
map_output:=mo;
menu_key:='5';
if dangeons_flag=true then begin//3.9.3
map[x,y].structure:='.';
map[x,y].color:=14;
dangeons_flag:=false;
end;//3.9.3
end;//3.9.1
map_output:=mo;
 end;//3.9
 
end;//3.0
map_output:=mo;
until menu_key='5';
end;//2.00 else mapgenerate(new,'/\')
end;

//02.11.2015
procedure trade;
begin
repeat begin//1
ClrScr;
writeln	('1- ',text[68]);
writeln	('2- ',text[69]);
writeln	('3- ',text[2]);
menu_key:=readkey;
case menu_key of
'1': begin //1.1
	//trade_out(t_o:beast_body;command:string);
	end;//1.1
'2':	begin//1.2
	
	end;//1.2
end;//1
end;
until menu_key='3';
end;

//01.02.2016
procedure mob_generate;
var
bl,i,k0:integer;
begin
if log='full' then log_generate('log_old_generate','mob generate ');
bl:=0;
i:=0;
k0:=0;
//ClrScr;
writeln	(text[72]+text[118]);

k0:=0;
for bl:=0 to 99 do begin//8
for i:=0 to 99 do begin//8.1
temp_battle:=mob_battle(npc_generate(oz_list[bl].x,oz_list[bl].y,1,2),npc_generate(oz_list[bl].x,oz_list[bl].y,1,2));
if log='full' then log_generate('log_old_generate','mob generate '+inttostr(k0));
	mob[k0]:=temp_battle.nb1;
	mob[k0].quest_activ:=quest_generate(random(3));
	//log_generate('log_old_generate','mob generate quest '+inttostr(mob[k0].quest_activ.x)+' '+inttostr(mob[k0].quest_activ.y));
	mob[k0].quest_flag:=true;
	mob[k0]:=hero_update(mob[k0]);
	{if (bl=10)and((i=10)or(i=20)or(i=30)or(i=40))then log_generate('log_old_generate','mob generate1 '+mob[k0].s[1].name+' '+mob[k0].s[2].name);}
	mob[k0]:=mob_dress_up(mob[k0]);
	{if (bl=10)and(((i=10)or(i=20)or(i=30)or(i=40))) then log_generate('log_old_generate','mob generate2 '+mob[k0].s[1].name+' '+mob[k0].s[2].name);}
	//--------------------------------------mob--------
	map[mob[k0].x,mob[k0].y].tip:=3;
	map[mob[k0].x,mob[k0].y].mob_index:=k0;

	k0:=k0+1;
end;//8.1
end;//8
end;


procedure map_generate(command:string);
var
bl:integer;
temp_npc1,temp_npc2:new_body;
begin
clrscr;
dangeons_flag:=false;
{if log='full' then }log_generate('log_old_generate','start map generate -1.0');
//+03.11.2015
k_oz:=0;
//+16.11.2015
bl:=0;
if lang_s='w_rus' then assign(map_oz,'res\map\oz.name');
if lang_s='u_rus' then assign(map_oz,'res/map/oz_u_r.name');
if lang_s='w_eng' then assign(map_oz,'res\map\oz_eng.name');
if lang_s='u_eng' then assign(map_oz,'res/map/oz_eng.name');
reset(map_oz);
while not eof(map_oz) do begin
readln(map_oz,map_name[k_oz]);
k_oz:=k_oz+1;
end;
close(map_oz);
{if log='full' then} log_generate('log_old_generate','start map generate -1.1');

simbol[0]:='.';//colore[0]:=1;colore[13]:=13;
simbol[1]:=':';//colore[1]:=1;colore[14]:=14;
simbol[2]:=';';//colore[2]:=2;
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
{if log='full' then} log_generate('log_old_generate','start sand full -2');
//+17.09.2015

//---------------
for i:=0 to x_map do begin//2.1
	for j:=0 to y_map do begin//2.2
	map[i,j].x:=i;
	map[i,j].y:=j;	
	map[i,j].structure:=simbol[0];
	map[i,j].color:=14;
	map[i,j].progress:=0;
	map[i,j].tip:=0;
	map[i,j].name:=' ';
		end;//2.2
end;//2.1
//---------------
{if log='full' then} log_generate('log_old_generate','start col -3');
writeln(text[72],text[73]);
for i:=0 to 1000 do begin//3
//+18.09.2015

repeat
begin
n:=random(x_map);
m:=random(y_map);
end;
until (n>8)and(n<x_map-8)and(m>8)and(m<y_map-8);
//n:=random(x_map);
//m:=random(y_map);
map[n,m].structure:=simbol[6];
map[n,m].color:=1;

k:=random(113); if k<13 then begin map[n-1,m-1].structure:=simbol[8];map[n-1,m-1].color:=2;end; if (k>13) and (k<38) then begin map[n-1,m-1].structure:=simbol[5];map[n-1,m-1].color:=2; end else begin map[n-1,m-1].structure:=simbol[3];map[n-1,m-1].color:=14; end;
k:=random(113); if k<13 then begin map[n-1,m].structure:=simbol[8];map[n-1,m].color:=2;end; if (k>13) and (k<38) then begin map[n-1,m].structure:=simbol[5];map[n-1,m].color:=2; end else begin map[n-1,m].structure:=simbol[3];map[n-1,m].color:=14; end;
k:=random(113); if k<13 then begin map[n-1,m+1].structure:=simbol[8];map[n-1,m+1].color:=2;end; if (k>13) and (k<38) then begin map[n-1,m+1].structure:=simbol[5];map[n-1,m+1].color:=2; end else begin map[n-1,m+1].structure:=simbol[3];map[n-1,m+1].color:=14;end;
k:=random(113); if k<13 then begin map[n,m-1].structure:=simbol[8];map[n,m-1].color:=2;end; if (k>13) and (k<38) then begin map[n,m-1].structure:=simbol[5];map[n,m-1].color:=2; end else begin map[n,m-1].structure:=simbol[3];map[n,m-1].color:=14;end;
k:=random(113); if k<13 then begin map[n,m+1].structure:=simbol[8];map[n,m+1].color:=2;end; if (k>13) and (k<38) then begin map[n,m+1].structure:=simbol[5];map[n,m+1].color:=2; end else begin map[n,m+1].structure:=simbol[3];map[n,m+1].color:=14;end;
k:=random(113); if k<13 then begin map[n+1,m-1].structure:=simbol[8];map[n+1,m-1].color:=2;end; if (k>13) and (k<38) then begin map[n+1,m-1].structure:=simbol[5];map[n+1,m-1].color:=2; end else begin map[n+1,m-1].structure:=simbol[3];map[n+1,m-1].color:=14;end;
k:=random(113); if k<13 then begin map[n+1,m].structure:=simbol[8];map[n+1,m].color:=2;end; if (k>13) and (k<38) then begin map[n+1,m].structure:=simbol[5];map[n+1,m].color:=2; end else begin map[n+1,m].structure:=simbol[3];map[n+1,m].color:=14;end;
k:=random(113); if k<13 then begin map[n+1,m+1].structure:=simbol[8];map[n+1,m+1].color:=2;end; if (k>13) and (k<38) then begin map[n+1,m+1].structure:=simbol[5];map[n+1,m+1].color:=2; end else begin map[n+1,m+1].structure:=simbol[3];map[n+1,m+1].color:=14;end;
//


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
//3 ----------------------------------------
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
writeln(text[72],text[74]);//---------------------------------------------
{if log='full' then} log_generate('log_old_generate','start raw -4');
for l:=0 to 1000 do begin//5
//+22.10.2015

repeat
begin
n:=random(x_map);
m:=random(y_map);
end;
until (n>32)and(n<x_map-32)and(m>32)and(m<y_map-32);
pyst_list[l].x:=n;
pyst_list[l].y:=m;
//4-//++31.10.2015
for i:=n-32 to n+32 do begin//5.1
	for j:=m-32 to m+32 do begin//5.2
	
	k0:=random(100);
	if k0<10 then begin //5.2.1
	map[i,j].structure:=simbol[3];
	map[i,j].color:=14;
	end;//5.2.1
	if (k0>10) and (k0<96) then begin //5.2.2
	map[i,j].structure:=simbol[0];
	map[i,j].color:=14;
	end;//5.2.2
	if (k0>96) and (k0<98) then begin //5.2.2
	map[i,j].structure:=simbol[9];
	map[i,j].color:=7;
	end;//5.2.2
	
	if (k0>98) and (k0<100)then begin//5.2.2.1
	map[i,j].structure:=simbol[5];
	map[i,j].color:=2;
	map[i,j].progress:=random(progress_max);	
	end;//5.2.2.1
	end;//5.1
	end;//5.2
//3-cryg//++31.10.2015
for i:=n-8 to n+8 do begin//5.1
	for j:=m-8 to m+8 do begin//5.2
	
	k0:=random(100);
	if (k0<30)  then begin //5.2.1
	map[i,j].structure:=simbol[3];
	map[i,j].color:=14;
	end;//5.2.1
	if (k0>30) and(k0<90) then begin //5.3.1
	map[i,j].structure:=simbol[0];
	map[i,j].color:=14;
	end;//5.3.1 	
	if(k0>90) and(k0<95) then begin //5.2.2
	map[i,j].structure:=simbol[5];
	map[i,j].color:=2;
	map[i,j].progress:=random(progress_max);
	end;//5.2.2
	if(k0>95) and(k0<100) then begin//5.2.2.1
	map[i,j].structure:=simbol[4];
	map[i,j].color:=6;
	map[i,j].progress:=random(progress_max);	
	end;//5.2.2.1
	end;//5.1
	end;//5.2
map[n,m].structure:=simbol[5];
map[n,m].color:=2;
map[n,m].progress:=random(progress_max);
end;//5
writeln(text[72],text[75]);
{if log='full' then} log_generate('log_old_generate','start oaz -5');
//+31.10.2015
//-------------------------------------------------------
k1:=1;k0:=0;
i:=0;j:=0;
l:=0;
n:=0;m:=0;
for l:=0 to 100 do begin//6
k:=random(k_oz);
repeat
begin
n:=random(x_map);
m:=random(y_map);
n_oz:=n;
m_oz:=m;
end;
//---------(6)
until (n>32)and(n<x_map-32)and(m>32)and(m<y_map-32);
	//+08.11.2015
	oz_list[l].x:=n_oz;
	oz_list[l].y:=m_oz;
	oz_list[l].oz_name:=map_name[k];

for i:=n-32 to n+32 do begin//6.1
	for j:=m-32 to m+32 do begin//6.2
	map[i,j].name:=map_name[k];
	k0:=random(100);
	if k0<20  then begin //6.2.1
	map[i,j].structure:=simbol[3];//log_generate('log_old_generate',inttostr(k0)+' ---- (6.1)----');
	map[i,j].color:=14;
	end;//6.2.1
	if (k0>20) and(k0<22) then begin //6.2.5.1
	map[i,j].structure:=simbol[10];//
	map[i,j].color:=7;
	end;//6.3.1	
	if (k0>22) and(k0<90) then begin //6.2.5.1
	map[i,j].structure:=simbol[0];//log_generate('log_old_generate',inttostr(k0)+' ---- (6.2)----');
	map[i,j].color:=14;
	end;//6.3.1 	
	if (k0>90)and(k0<98) then begin //6.2.2
	map[i,j].structure:=simbol[5];//log_generate('log_old_generate',inttostr(k0)+' ---- (6.3)----');
	map[i,j].color:=2;

	end;//6.2.2
	if (k0>98)and(k0<100) then begin//6.2.2.1
	map[i,j].structure:=simbol[4];//log_generate('log_old_generate',inttostr(k0)+' ---- (6.4)----');
	map[i,j].color:=6;	
	end;//6.2.2.1
	end;//6.1
	end;//6.2
if log='full' then log_generate('log_old_generate','start oaz -!!- '+inttostr(l));	
//-----------(5)
for i:=n-16 to n+16 do begin//6.1
	for j:=m-16 to m+16 do begin//6.2
	
	k0:=random(100);
	if k0<20  then begin //6.2.1
	map[i,j].structure:=simbol[5];
	map[i,j].color:=2;
	end;//6.2.1
	if (k0>20) and(k0<30) then begin //6.3.1
	map[i,j].structure:=simbol[4];
	map[i,j].color:=6;
	end;//6.3.1 	
	if (k0>30)and(k0<70) then begin //6.2.2
	map[i,j].structure:=simbol[3];
	map[i,j].color:=14;
	end;//6.2.2
	if (k0>70)and(k0<100) then begin//6.2.2.1
	map[i,j].structure:=simbol[0];
	map[i,j].color:=14;	
	end;//6.2.2.1
	end;//6.1
	end;//6.2
//log_generate('log_old_generate','start oaz -!!!- '+inttostr(l));	
//------------(4)
for i:=n-8 to n+8 do begin//6.1
	for j:=m-8 to m+8 do begin//6.2
	
	k0:=random(100);
	if k0<20  then begin //6.2.1
	map[i,j].structure:=simbol[8];
	map[i,j].color:=2;
	end;//6.2.1
	if (k0>20) and(k0<30) then begin //6.3.1
	map[i,j].structure:=simbol[5];
	map[i,j].color:=2;
	end;
	if (k0>30) and(k0<50) then begin //6.3.1
	map[i,j].structure:=simbol[0];
	map[i,j].color:=14;
	end;
	if (k0>50)and(k0<100) then begin//6.2.2.1
	map[i,j].structure:=simbol[3];
	map[i,j].color:=14;	
	end;//6.2.2.1
	end;//6.1
	end;//6.2
	//log_generate('log_old_generate','start oaz -!!!!- '+inttostr(l));	
//------------(3)
for i_oz:=n_oz-6 to n_oz+6 do begin//6.1
	for j_oz:=m_oz-6 to m_oz+6 do begin//6.2
	
	k0:=random(100);
	if k0<30  then begin //6.2.1
	map[i_oz,j_oz].structure:=simbol[5];
	map[i_oz,j_oz].color:=2;
	{map[i_oz,j_oz].beast_index:=bl;
	map[i_oz,j_oz].tip:=1;
	beast_list[bl]:=beast_generate(i,j);
	bl:=bl+1;}
	end;//6.2.1
	if (k0>30) and(k0<90) then begin //6.3.1
	map[i_oz,j_oz].structure:=simbol[3];
	map[i_oz,j_oz].color:=14;
	end;
	if (k0>90)and(k0<100) then begin//6.2.2.1
	map[i_oz,j_oz].structure:=simbol[12];
	map[i_oz,j_oz].color:=8;
	map[i_oz,j_oz].npc_index:=k1;
	map[i_oz,j_oz].x:=i_oz;
	map[i_oz,j_oz].y:=j_oz;
	//-----------------------------------------------------------------------------------------
	if log='full' then log_generate('log_old_generate','start nps generate -6- '+inttostr(k1));
repeat
temp_npc1:=npc_generate(map[i_oz,j_oz].x,map[i_oz,j_oz].y,1,1);

temp_npc2:=npc_generate(map[i_oz,j_oz].x,map[i_oz,j_oz].y,1,1);
temp_battle:=mob_battle(temp_npc1,temp_npc2);
until temp_battle.nb1.hp>0;
max_npc:=k1;
 npc[k1]:=temp_battle.nb1;
//if temp_battle.nb1.hp>0 then npc[k1]:=temp_battle.nb1;
//if temp_battle.nb2.hp>0 then npc[k1]:=temp_battle.nb2;
	k1:=k1+1;
		
	end;//6.2.2.1
	end;//6.1
	end;//6.2
	if log='full' then log_generate('log_old_generate','start sand -7- '+inttostr(i_oz));	
//------------(2)
for i_oz:=n_oz-3 to n_oz+3 do begin//6.1
	for j_oz:=m_oz-3 to m_oz+3 do begin//6.2
	
	k0:=random(100);
	if k0<90  then begin //6.2.1
	map[i_oz,j_oz].structure:=simbol[3];
	map[i_oz,j_oz].color:=14;
	end;
	if (k0>90)and(k0<100) then begin//6.2.2.1
	map[i_oz,j_oz].structure:=simbol[7];
	map[i_oz,j_oz].color:=1;	
	end;//6.2.2.1
	end;//6.1
	end;//6.2
if log='full' then log_generate('log_old_generate','start sand -8- '+inttostr(i_oz));
//------------(1)
for i_oz:=n_oz-2 to n_oz+2 do begin//6.1
	for j_oz:=m_oz-2 to m_oz+2 do begin//6.2
	
	k0:=random(100);
	if k0<70  then begin //6.2.1
	map[i_oz,j_oz].structure:=simbol[7];
	map[i_oz,j_oz].color:=1;
	end;
	if (k0>70)and(k0<100) then begin//6.2.2.1
	map[i_oz,j_oz].structure:=simbol[3];
	map[i_oz,j_oz].color:=14;	
	end;//6.2.2.1
	end;//6.1
	end;//6.2
	if log='full' then log_generate('log_old_generate','end sand -9- '+inttostr(n_oz)+' '+inttostr(m_oz));
//------------(0)
map[n_oz,m_oz].structure:=simbol[7];
map[n_oz,m_oz].color:=1;
end;//6

k1:=1;k0:=0;
i:=0;j:=0;
l:=0;
n:=0;m:=0;
{if log='full' then} log_generate('log_old_generate','start beast -10- '+inttostr(bl));
writeln(text[72],text[109]);

for i:=0 to max_npc do begin//8.1
npc[i].quest_activ:=quest_generate(random(3));
npc[i].quest_flag:=true;
end;//8.1

for bl:=0 to 1000 do begin//7
for i:=0 to 9 do begin//7.1
{st1:=inttostr(bl);
st2:=inttostr(i);
st0:=st2+st1;
j:=strtoint(st0}
//log_generate('log_old_generate',inttostr(j));
	beast_list[k0]:=beast_generate(pyst_list[bl].x,pyst_list[bl].y);//--------------------------------------BEAST--------
	map[beast_list[k0].x,beast_list[k0].y].tip:=1;
	map[beast_list[k0].x,beast_list[k0].y].beast_index:=k0;
	k0:=k0+1;
end;//7.1
end;//7
i:=0;j:=0;

for i:=0 to max_npc do begin//8.1
npc[i].quest_activ:=quest_generate(random(3));
npc[i].quest_flag:=true;
end;//8.1

end;//2
if command='map_story_generate' then begin//3
//
//+24.09.2015
if log='full' then log_generate('log_new_generate','~ \/ (water)');
for i:=0 to x_map do begin//3.1
	for j:=0 to y_map do begin//3.2
	map[i,j].x:=i;
	map[i,j].y:=j;	
	map[i,j].structure:=simbol[7];
	map[i,j].color:=1;
		end;//3.2
	end;//3.1
	m:=random(3)+1;
	if log='full' then log_generate('log_old_generate',inttostr(m)+' # (land)');
for n:=0 to m do begin//3.3

repeat l:=random(x_map); until (l>400) and (l<x_map-400); if log='full' then log_generate('log_old_generate',inttostr(l)+' x (land)');
repeat k:=random(y_map); until (k>400) and (k<y_map-400); if log='full' then log_generate('log_old_generate',inttostr(k)+' y (land)');
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

procedure mini_map_generate;
begin
writeln	(text[72],text[135]);
for i:=0 to 204 do begin //1
for j:=0 to 204 do begin //2
mini_map[i,j].structure:=map[i*10,j*10].structure;
mini_map[i,j].color:=map[i*10,j*10].color;
if map[i*10,j*10].name<>' ' then mini_map[i,j].name:=map[i*10,j*10].name else mini_map[i,j].name:=' ';
mini_map[i,j].ver:=0;
end;//2
end;//1
end;

function beast_live(bl:beast_body):beast_body;
begin
beast_live:=bl;
if bl.flag_hishn=1{travoed}then begin//1

end;//1
end;

function main_menu(mm:new_body):new_body;
begin

repeat begin//1
ClrScr;
writeln	('1- ',text[10]);
writeln	('2- ',text[9]);
writeln	('4- ',text[17]);
writeln	('5- ',text[2]);
writeln	('9- ',text[107]);

menu_key:=readkey;
case menu_key of
'1': begin //1.1
	mm:=hero_output(mm);
	end;//1.1
'2':	begin//1.2
if (mm.xd<>0)and(mm.yd<>0) then mm:=dungeon_output(mm.xd,mm.yd,mm);
if (mm.xd=0)and(mm.yd=0) then	mm:=map_output(mm.x,mm.y,mm); 
	mm:=main_menu(mm);
	end;//1.2
'4': begin//1.4
save;
end;//1.4
'9':help;
end;
end;//2
main_menu:=mm;
until menu_key='5';
end;


function zero_generate(command:string):new_body;
var
zg:new_body;
begin
if command='start' then begin//0
{---log---}log_generate('log_old_generate','start generate');
map_generate('map_test_generate');
mob_generate;
mini_map_generate;
{---log---}log_generate('log_old_generate','stop generate');
//evolution(5);
if log='full' then log_generate('log_old_generate','start hero_generate');
zg:=hero_generate('hero_new');
zero_generate:=zg;
end;//0
end;

function zero_menu(zmc:char):new_body;
var
zm:new_body;
begin
repeat
 ClrScr;
writeln	(text[3]);
writeln	('1-',text[4]);
writeln	('2-',text[16]);
writeln	('3-',text[2]);

menu_key:=readkey;
case menu_key of
'1': begin
zm:=zero_generate('start');
zero_menu:=zm;
//31.12.2015
story;
menu_key:='3';
end;
'2':begin load;
zero_menu:=zm;
menu_key:='3';
 {hero:=main_menu(hero);} end;
//'3': exit;

end;
until menu_key='3'
end;
//03.04.2016
function hero_study(hs:new_body;command:byte):new_body;
begin
 hs.prof[command]:=hs.prof[command]+1;
hero_study:=hs;
end;

//-------------------------
//+20.08.2015
{
win cp866 text_win.lang
unix utf-8 text.lang
}
//--------------------------------
BEGIN
Window(1,1,200,200);
log:='full';
log_generate('log_new_generate','begin');
Randomize;
typ_generate('');
i:=0;
//02.01.2016
if log='full' then log_generate('log_old_generate','start lang_f');
assign(lang_f,'lang_f');
reset(lang_f);
readln(lang_f,lang_s);
readln(lang_f,log);
close(lang_f);
if log='full' then log_generate('log_old_generate','lang = '+lang_s);
//if (lang_s<>'w_rus')or (lang_s<>'u_rus')or (lang_s<>'w_eng')or (lang_s<>'u_eng') then begin writeln	('error file lang_f'); exit; end;
if log='full' then log_generate('log_old_generate','close lang_f');
//log_generate('log_new_generate','1-1');
if log='full' then log_generate('log_old_generate','start lang'+' '+lang_s);
if lang_s='w_rus' then assign(lang,'res\lang\rus\text_win.lang');
if lang_s='w_eng' then assign(lang,'res\lang\eng\text_win.lang');
if lang_s='u_eng' then assign(lang,'res/lang/eng/text_win.lang');
if lang_s='u_rus' then assign(lang,'res/lang/rus/text_unix.lang');
if log='full' then log_generate('log_old_generate','off lang'+' '+lang_s);
reset(lang);
while not eof(lang) do begin
readln(lang,text[i]);

delete(text[i],1,3);
//text[i]:=name_tab(text[i],10);
i:=i+1;
end;
close(lang);
magic_load;
if log='full' then log_generate('log_old_generate','close lang');

textcolor(yellow);
writeln	(text[1]);
textcolor(white);
readln();

hero:=zero_menu('h');
hero:=main_menu(hero);


END.


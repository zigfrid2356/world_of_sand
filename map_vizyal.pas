{
   test.pas
   
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


program GetMax;
 
uses graph,crt,sysutils,windows,dateutils;
type
erath =record
x,y,npc_index,beast_index:word;
structure:char;
color:byte;
name:string[25];
tip:byte;//flag_life__beast(1/2)_human(3/4)_not_life(0)
progress:word;
end;
var
map:array[0..2048,0..2048] of erath;
gd,gm: integer;
map_save:file of erath;
i,j,ii,iii:integer;
const 
x_map = 2048;
y_map = 2048;

procedure muve(i_m,j_m:word; command:string);
var
i_muv,j_muv,rr:word;
begin

if command='test' then begin//000------------------------000-----------------
//log_generate('log_old_generate','start_muve');
for i_muv:=1 to 800 do begin//0.1
	for j_muv:=1 to 600 do begin//0.2
	
if map[i_muv,j_muv].progress>=2 then begin//1

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
//log_generate('log_old_generate','stop_muve');
end;//000
end;
begin
//gd:=D16bit; 
gm:=m800x600x64K; 
gd:=detect;
//gm:=0;
  // gd:=VGA;   {адаптер VGA}
  // gm:=VGAHi; {режим 640*480пикс.*16 цветов}
   initgraph(gd,gm,'');
   //line (0,0,getmaxx,getmaxy);
   //setcolor(15);
    
   //putpixel(20,10,15);
   
   assign(map_save,'res\save\map.save');
reset(map_save);
for i:=0 to x_map do begin//1.1
	for j:=0 to y_map do begin//1.2
read(map_save,map[i,j]);
//if map[i,j].structure='#' then putpixel(i,j,15) else putpixel(i,j,map[i,j].color);
end;end;//1.1//1.2
close(map_save);
for ii:=0 to 10 do begin//00--------------------00---------------
for i:=0 to 800 do begin//1.1
	for j:=0 to 600 do begin//1.2
if map[i,j].structure='#' then putpixel(i,j,15) else putpixel(i,j,map[i,j].color);
end;end;//1.1//1.2
for iii:=0 to 100 do muve(128,128,'test');
end;//00----------------------------------------00---------------
readln();
   //readln; 
   closegraph;
   
end.


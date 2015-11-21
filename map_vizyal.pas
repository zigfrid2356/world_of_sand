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
i,j:integer;
const 
x_map = 2048;
y_map = 2048;
begin
gd:=detect;
gm:=0;
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
if map[i,j].structure='#' then putpixel(i,j,15) else putpixel(i,j,map[i,j].color);
end;end;//1.1//1.2
close(map_save);

readln();
   readln; 
   closegraph;
   
end.


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
 
uses graph;
var  gd,gm: integer;
begin
   gd:=VGA;   {адаптер VGA}
   gm:=VGAHi; {режим 640*480пикс.*16 цветов}
   initgraph(gd,gm,'');
   line (0,0,getmaxx,getmaxy); 
   readln; closegraph;
end.


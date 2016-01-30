//��������� � ��������������
//������� �� 17.04.2012
//�����㥬 � ��⭠�
// �襭�� �� 30.01.2016

//*************************************************//
//**                                             **//
//**                                             **//
//**                                             **//
//**              ��������� ������               **//
//**                     ��                      **//
//**                 17.04.2012                  **//
//**                                             **//
//**                                             **//
//*************************************************//

UNIT gen;
{
	* ����� ��� �᭮���� ������஢
	* }
{
	* 17.01.2011
	* ++ stat_monster_generate
	* + star
	* 09.01.2011
	* + function name_monster_generate
	* + stat_monster_generate
	* 25.05.2011
	* + map
	* + map_muve
	* + map_generate
	* + map_based
	* +map_load
	* +map_save
	* 27.05.2011
	* + king_batle
	* + get_info
	* 28.05.2011
	* - king_batle
	* 05.06.2011
	* ++map_based
	* 06.06.2011
	*  +map_info
	* 07.06.2011
	* + gravitation
	* 09.06.2011
	* + item_generation
	* 14.06.2011
	* + date_generation
	* 24.06.2011
	* + tree
	* + char_visible
	* 26.08.2011
	* ++ map_save,map_load
	* }
INTERFACE
uses crt,SysUtils;
//ᠬ� ���� �� �뤠� ����� � ���� ᡮન �����
function get_info:string;

//function king_batle(var h_hp,h_damage,h_rezisten,m_hp,m_damage,m_rezisten:extended;h_mp,m_mp:integer):extended;
function date_generation(s:byte):string;
procedure gravitation(hx,hy,hz:integer;s:char);
function map_info(i:byte):string;
function name_monster_generate(s:string):string;
function char_visible(s:string):string;
function stat_monster_generate(s:string;i:integer):integer;
procedure star(x:integer);
procedure map(hx,hy,hz:integer);
function map_muve(hx,hy,hz,hm:integer):integer;
procedure map_generate(x:integer);

procedure map_load;
procedure map_save;
procedure map_mob_kill_save(hx,hy,hz:integer);
procedure tree(x,y:integer);
procedure big_map(hx,hy,hz:integer);
procedure flash_map_load(hx,hy,hz:integer);

procedure map_layer_fuel(k:integer);//������塞 ���� ᫮� ����� �����
procedure generate_room(x,y,dl,sh,k:integer);//��१��� � 
//᫮� �������, ��砫�� ���न���� �,�, dl��� � sh�ਭ� �������
procedure map_layer_generate(k:integer);
{type

material=(water,stone,air,forester,);//⨯ ���ਠ��}
{type world_n=record
ansi_image_n:AnsiChar;
a_material_n:byte;//0..6;
x,y,z:byte;
end;}
type world=record
ansi_image:AnsiChar;//string[2];//����ࠦ���� �祩�� ����࠭�⢠
//���ਠ� ᫮� ⥯��� �।�⠢���� � ���� ����
//0-������,1-��ॢ�,2-����,3-�����,4-������,5-�����
{
	* 24.06.2011
	* + 6-�ࠢ�,���-�� ���⢠ ��ॢ쥢
	* 16.08.2011
	* �� �ᥫ����� ��� �� ����ᮢ �� ���� � ⮫쪮 ���ଠ�� ����뢠��� �� ᮡ���
	* ������� ����� � �ࣨ�(�����)
	* ���� ����� 娬��᪨� ����⮢ �� ������ ��⮨� ���ਠ� ������� �����
	* ������� ����� ⠪-�� ����� ��।��񭭠� ����(� ��⠫��� � ��. ��� =0)
	* ��ࢮ��砫�� ����� ����⮢:
	* ��᫮த-O
	* ����த-H
	* 㣫�த-C
	* �६���-Si
	* ������-Fe
	* 
	* ��᮪ Si+C
	* ����� O+Si+C
	* ������ ��⮨� �� SiO2
	* ������ O2
	* ���� H2O
	* 
	* }

a_material:byte;//0..6;
//���� ��室����,��⨢�� ᫮� 128, ��⪠ ������ ���� ��������� �����宬
//��� ���⪮� ������ ���� ��� ���� ��� ������
end;
{
	* 27.08.2011
	* ��� �㤥� ��ࠧ�� ����॥!
	* }
type map_based=record
a:array[1..256,1..256,1..256]of world;
end;
var
{
	* 25.05.2011
	* ���� ���⭮�� 0.1
	* ����᪠�, �࠭���� ࠧ��஢
	* 05.06.2011
	* + ������ ����� ����࠭�⢠
	* + ��� �⠫ ���嬥��
	* }
map_based_n: map_based;

         {
			 * 25.05.2011
			 * ����⪠ ����� ࠧ ������ ��������
			 * }
         inv: record
         position:array[1..10]of integer;         
		 name:string;
		 image:string;
		 kol_vo:integer;
		 end;
IMPLEMENTATION
{
	* 27.05.2011
	* �����頥� ����� � ���� ᡮન �����
	* }
function get_info:string;
begin
get_info:='v0.1 bd24.06.2011';
end;
{
	* 07.06.2011
	* ��楤�� ����뢠�� �� ����� ����⢨� �ࠢ��樨
	* ��।�� ���न���� ����, � ᨬ��� ��।����騩 ����⢨�
	* v-�뢮��� ����� � ���� ᡮન ��楤���
	* g-�����뢠�� ��� �����
	* h-����⢨� ⮫쪮 ��� ����
	* �� ���᪠�� ᫮� �� ᫮�� ��� ����� ����� ���� � ������
	* }
	procedure gravitation(hx,hy,hz:integer;s:char);
	var
	i,j,k:integer;//���न���� �����
	i_j:integer;//����稪 ��室��, ���� ᠬ� ���孨� ������ ������ ������
	begin
	case s of//1
	'v':write('v0.1 bild 07.06.2011');
	'g':begin//2
	map_load;
	for i_j:=1 to 256 do
	for i:=1 to 256 do
	for j:=1 to 256 do
	for k:=2 to 255 do
	if (map_based_n.a[i,j,k-1].a_material=0)
	and(map_based_n.a[i,j,k].a_material<>0)then
		begin
		map_based_n.a[i,j,k-1].a_material:=map_based_n.a[i,j,k].a_material;
		map_based_n.a[i,j,k].a_material:=map_based_n.a[i,j,k+1].a_material;
		map_based_n.a[i,j,k-1].ansi_image:=map_based_n.a[i,j,k].ansi_image;
		map_based_n.a[i,j,k].ansi_image:=map_based_n.a[i,j,k+1].ansi_image;
		end;
	map_save;
	end;//2
	'h':
	begin//3
	if map_based_n.a[hx,hy,hz-1].a_material=0 then 
						begin
						
	map_based_n.a[hx,hy,hz-1].ansi_image:=map_based_n.a[hx,hy,hz].ansi_image;
	map_based_n.a[hx,hy,hz].ansi_image:=' ';
						end;
	end;//3
	end;//1
	end;
{
	* 06.06.2011
	* �����頥� �������� ���ਠ�� �� ��� ������
	* 0-������,1-��ॢ�,2-����,3-�����,4-������,5-�����
	* 24.06.2011
	* + 6-�ࠢ� 
	* }
	function map_info(i:byte):string;
	begin
	case i of
	0:map_info:='������';
	1:map_info:='��ॢ�';
	2:map_info:='����';
	3:map_info:='�����';
	4:map_info:='������';
	5:map_info:='�����';
	6:map_info:='�ࠢ�';
	end;
	end;
{
	* 09.01.2011
	* ������� ����� �� ���ᨢ� ��� �ᯮ�������� � 䠩���
	* n_m_g_1.txt,n_m_g_2.tx,n_m_g_3.txt
	* �� �室 ����� ������� version - �����蠥� ����� �㭪樨
	* name - �����頥� ��砩��� ���
	* }
function name_monster_generate(s:string):string;
var
f_m1{,f_m2,f_m3}:textfile;
s_m1:string;
i,i1{,i2}:integer;
         begin
         if s='version' then name_monster_generate:='v 0.1';
         if s='name' then begin //1
         i1:=1;
         Assign(f_m1,'files/n_m_g_1.txt');
         reset(f_m1);
         i:=random(700);//�᫮ ��ப � 䠩�� n_m_g_1.txt
         while not eof(f_m1) do
begin
readln(f_m1,s_m1);
if i=i1 then name_monster_generate:=s_m1;
i1:=i1+1;
end;
         close(f_m1);

end;//1
         end;
{
	* 09.01.2011
	* �㭪�� �����樨 ��⮢ ����
	* ��।�� ��� ��ࠬ��� � ��� ���� �� ��室� ����砥�
	* ���祭�� ��ࠬ���
	* ��।������ ���祭�� version, hp, mp, damage, rezisten
	* }
function stat_monster_generate(s:string;i:integer):integer;
begin
if s='version' then stat_monster_generate:=1;
if s='hp' then stat_monster_generate:=i*10+100+random(i*50);
if s='mp' then stat_monster_generate:=i*10;
if s='damage' then stat_monster_generate:=i*4{+random(i*2)};
if s='rezisten' then stat_monster_generate:=i*2{+random(i+5)};
end;
{
	* 17.01.2011
	* procedure star �����뢠�� ��񧤮��
	* }
	procedure star(x:integer);
	begin
	write('|');
Sleep(x);write(#13);
write('\');
sleep(x);write(#13);
write('-');
sleep(x);write(#13);
write('/');
sleep(x);write(#13);
	end;
	{
		* 25.05.2011
		* procedure map_load
		* ����㧪� �����
		* }
	procedure map_load;
	var
	map_file:file of map_based;//textfile;
	//i,j,k:integer;
	begin

    Assign(map_file,'files/map/map1.map');
    reset(map_file); 
	read(map_file,map_based_n);
	close(map_file);
	end;
	{
		* 25.05.2011
		* procedure map_save
		* ��࠭���� �����
		* }
	procedure map_save;
	var
	map_file:file of map_based;
	begin
	Assign(map_file,'files/map/map1.map');
	rewrite(map_file);
	write(map_file,map_based_n);
	close(map_file);		
	end;
	{
		* 25.05.2011
		* ��楤�� �⮡ࠦ���� �����
		* }
	procedure map(hx,hy,hz:integer);
	var
	i,j:integer;
	begin
map_load;
	
for j:=-4 to 4 do  begin//1
write('|');
for i:=-15 to 15 do  begin//2
write(map_based_n.a[hx+i,hy+j,hz].ansi_image);
end;//2
//writeln('||');
case j of
-4:writeln('||');
-3:writeln('| �� ��������� � '+map_info(map_based_n.a[hx,hy,hz].a_material));
-2:writeln('| ������� '+map_info(map_based_n.a[hx,hy+1,hz].a_material));
-1:writeln('| ������ '+map_info(map_based_n.a[hx,hy-1,hz].a_material));
0:writeln('| ������ '+map_info(map_based_n.a[hx+1,hy,hz].a_material));
1:writeln('| ����� '+map_info(map_based_n.a[hx-1,hy,hz].a_material));
2:writeln('| ��� ������� '+map_info(map_based_n.a[hx,hy,hz+1].a_material));
3:writeln('| ��� ������ '+map_info(map_based_n.a[hx,hy,hz-1].a_material));
4:writeln('||');
end;
end;//1

	end;
	{
		* 25.05.2011
		* ��楤�� ����� ��������� ���� �� ���⭮��
		* ���� ��������� �����
		* ��� 0.1 �।�⠢��� ᮡ�� ���᪮��� ࠧ��ࠬ� 256 �� 256 ���⮪
		* ����砥� ⥪�訥 ���न���� ���� � ����⢨� ���஥ ���������� ᮢ�����
		* hm
		* 0 - �⮨� �� ����
		* 1 - �����
		* 2 - �����
		* 3 - ����
		* 4 - ��ࠢ�
		* �����頥� १����
		* 1 - ����⢨� �ᯥ譮, ���ᮭ�� ����� �� ᢮����� ���⮪, ����� � ���ﭨ� ��१���ᠭ�
		* 2 - ����⢨� ����������. �ॣࠤ� - �⥭�
		* 3 - ����⢨� ����������. �ॣࠤ� - ����
		* 3 - ����⢨� ����������. �ॣࠤ� - ���
		* �� �������� ���� �ந�室�� ��१����� ���ﭨ� �����
		* ������� ����� ���ᠭ� � ��楤�� map_generate
		* }
	function map_muve(hx,hy,hz,hm:integer):integer;	
	begin
	map_load;
	if (hx=1)or(hx=255)or(hy=1)or(hy=255) then map_muve:=2 else begin//1
	case hm of 
	0: map_muve:=1;
	1: begin
	if map_based_n.a[hx,hy+1,hz].ansi_image=' ' then begin map_based_n.a[hx,hy,hz].ansi_image:=' ';map_based_n.a[hx,hy+1,hz].ansi_image:='@'; map_muve:=1;end;
	if map_based_n.a[hx,hy+1,hz].ansi_image='#' then map_muve:=2;
	if map_based_n.a[hx,hy+1,hz].ansi_image='%' then map_muve:=3;
	if map_based_n.a[hx,hy+1,hz].ansi_image='*' then map_muve:=4;
	end;
	2: begin
	if map_based_n.a[hx-1,hy,hz].ansi_image=' ' then begin map_based_n.a[hx,hy,hz].ansi_image:=' ';map_based_n.a[hx-1,hy,hz].ansi_image:='@';map_muve:=1;end;
	if map_based_n.a[hx-1,hy,hz].ansi_image='#' then map_muve:=2;
	if map_based_n.a[hx-1,hy,hz].ansi_image='%' then map_muve:=3;
	if map_based_n.a[hx-1,hy,hz].ansi_image='*' then map_muve:=4;	
	end;
	3: begin
	if map_based_n.a[hx,hy-1,hz].ansi_image=' ' then begin map_based_n.a[hx,hy,hz].ansi_image:=' ';map_based_n.a[hx,hy-1,hz].ansi_image:='@';map_muve:=1;end;
	if map_based_n.a[hx,hy-1,hz].ansi_image='#' then map_muve:=2;
	if map_based_n.a[hx,hy-1,hz].ansi_image='%' then map_muve:=3;
	if map_based_n.a[hx,hy-1,hz].ansi_image='*' then map_muve:=4;	
	end;
	4: begin
	if map_based_n.a[hx+1,hy,hz].ansi_image=' ' then begin map_based_n.a[hx,hy,hz].ansi_image:=' ';map_based_n.a[hx+1,hy,hz].ansi_image:='@';map_muve:=1;end;
	if map_based_n.a[hx+1,hy,hz].ansi_image='#' then map_muve:=2;
	if map_based_n.a[hx+1,hy,hz].ansi_image='%' then map_muve:=3;
	if map_based_n.a[hx+1,hy,hz].ansi_image='*' then map_muve:=4;	
	end;
	end;
	end;//1
	map_save;
	
	end;
	{
		* 24.06.2011
		* �㭪�� �⮡ࠦ���� ᨬ���� �� ⠡���� � ����ᨬ��� �� �ॡ������
		* ��।�� �ॡ㥬�� ᫮��, ����砥� �㦭� ᨬ���
		* �᫨ ᫮�� �� ���ᠭ� � 䠩�� ⮣�� �뢮��� �����⥫�� ����
		* }
	function char_visible(s:string):string;
	var
	f:textfile;
	s_r,s_rez:string[40];//�⠥��� � �⠥���_१�������� ��ப�
	i:integer;//�������� ����������
	begin
	Assign(f,'files/item.smv');
    reset(f);
    while not eof(f) do begin//1
    readln(f,s_r);
    readln(f,s_rez);
    i:=pos(s,s_r);
    if i<>0 then char_visible:=s_rez else char_visible:='?';
    end;//1
	close(f);
	end;
	{
		* 24.06.2011
		* ��楤�� �����樨 ��ॢ�
		* ��ॢ� ��⮨� �� "��ॢ�" � "�ࠢ�"
		* ⠪-�� ��ॢ� ��⮨� �� ��������� � ��������� ���
		* ��� �����樨 �� ��।�� ��㬥�� ���न���� ��砫� ��� ��ॢ� �� ᫮� 128
		* }
		procedure tree(x,y:integer);
		begin
		map_load;
//�⢮�		
{	map_based_n.a[x,y,128].ansi_image:=char_visible('�⢮�');
	map_based_n.a[x,y,128].a_material:=1;
//�஭�
	map_based_n.a[x,y,129].ansi_image:=char_visible('�஭�');
	map_based_n.a[x,y,129].a_material:=6;
//��୨
	map_based_n.a[x,y,127].ansi_image:=char_visible('��୨');
	map_based_n.a[x,y,127].a_material:=1;	}		
		map_save;
		end;
		
	{
		* 25.05.2011
		* ��楤�� �����樨 �����
		* ����஢�� ᨬ����� 
		* # - �⥭�
		* % - ����
		* * - ��⨢���
		* $ - �।���
		* 
		* }
	procedure map_generate(x:integer);
	var
	i,j,k:integer;
  	m_o:array[0..14]of char{string[1]}=(' ',' ',' ','*','%','#','*',' ',' ',' ',' ',' ',' ',' ','#');
//	m_o:array[0..14]of string[1]=('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E');

	//0-������,1-��ॢ�,2-����,3-�����,4-������,5-�����
	m_m:array[0..14]of byte=(0,0,0,0,2,3,0,0,0,0,0,0,3,3,4); 
	m_m_s:array[0..14]of byte=(3,3,3,3,3,4,4,4,5,3,3,3,1,1,3);
	begin
	randomize;
	//᭠砫� ᣥ����㥬 �⬮����
	//�⬮��� �� ���� �ᯮ������� ��稭�� � ᫮� 129 �� 256
	//����騩 �᪫��⥫쭮 �� ������ (��ॢ쥢 � �����஢)
	for i:=1 to 256 do begin//1
	for j:=1 to 256 do begin//2
	for k:=129 to 256 do begin//3
	map_based_n.a[i,j,k].ansi_image:=m_o[(random(2))];
	map_based_n.a[i,j,k].a_material:=0;
	end;end;end;		
	//ᣥ����㥬 ����ਬ�� ����࠭�⢮
	//��� �ᯮ�������� �� ᫮� 128 � ��⮨� � �᭮���� �� ������ � �ਬ���� �९���⢨�
	for i:=1 to 256 do begin//1
	for j:=1 to 256 do begin//2
	map_based_n.a[i,j,128].ansi_image:=m_o[(random(9))];
	map_based_n.a[i,j,128].a_material:=m_m[(random(14))];
	if (i=128) and (j=128) then begin 
								map_based_n.a[i,j,128].ansi_image:='@';
								map_based_n.a[i,j,128].a_material:=0;
								end;
	end;//2
	end;//1
	//������㥬 ����, ��� ��室���� �� ᫮�� � 1 �� 127
	//� ��⮨� � �᭮���� �� ���� � ����� � ��࠯����ﬨ �����஢,����,��ॢ쥢
	//� �������� �����-����
	for i:=1 to 256 do begin//1
	for j:=1 to 256 do begin//2
	for k:=1 to 127 do begin//3
	map_based_n.a[i,j,k].ansi_image:='#';
	map_based_n.a[i,j,k].a_material:=m_m_s[(random(14))];	
	end;end;end;
	{
		* 19.07.2011
		* ����� ���� ������� �����
		* ���� ���������� �� �� ���� ��⥩, ��� ࠭��,
		* � �� ������ - ��������(��㡨��� ��த�), ��⨢�� ᫮�(���,宫��,���� � 
		* ��᫠ ४), �⬮���(������ � ����)
		* }
		{begin
		
		end;}
	
	map_save;
	end;
	
	{
		* 18.04.2012
		* ������塞 ���� ᫮� ����� �����
		* k- ����� ᫮�
		* }
	procedure map_layer_fuel(k:integer);
	var
	i,j:integer;
	begin
		{������塞 ᫮� �����}
	for i:=1 to 256 do begin
	for j:=1 to 256 do begin
	map_based_n.a[i,j,k].ansi_image:='#';
	map_based_n.a[i,j,k].a_material:=3;	
	end;end;
	map_save;
	end;
	{
		* 18.04.2012
		*��१��� � ᫮� �������, ��砫�� ���न���� �,�, dl��� � sh�ਭ� ������� 
		* k- ����� ᫮�
		* }
	procedure generate_room(x,y,dl,sh,k:integer);
	var
	i,j:integer;	
	begin
		{������ �������}
	for i:=x to x+dl do begin
	for j:=y to y+sh do begin
	map_based_n.a[i,j,k].ansi_image:=' ';
	map_based_n.a[i,j,k].a_material:=0;	
	end;end;
	map_save;
	end;
	
	{
		*18.04.2012 
		* ᮧ��� ᫮� ����� � �����⠬� � ��ਤ�ࠬ�
		* }
	procedure map_layer_generate(k:integer);
	var
	x,y,dl,sh,i:integer;
	begin
	//��������� ᫮� �����
	map_layer_fuel(k);
	
	x:=random(100);
	y:=random(100);
	dl:=random(50);
	sh:=random(50);
	//ᮧ���� �������
	generate_room(x,y,dl,sh,k);
	//� �ந����쭮� ���ࠢ����� �஡��� ��ਤ��
	i:=random(3);
	case i of
	0:generate_room(x,y+3,dl,3,k);
	1:generate_room(x+3,y,dl,3,k);
	2:generate_room(x+dl,y,dl,3,k);
	3:generate_room(x,y+sh,dl,3,k);
	end;
	map_save;
	end;
	
	
	{
		* 27.05.2011
		* �㭪�� ��஫��᪮� ���� 
		* ����砥� ���祭�� hp,mp,rezisten � damage ��⨢�����
		* �����頥� hp ����, �᫨ <= ����, ��ன �ந�ࠫ...
		* 28.05.2011
		* ��७�ᥭ� � �᭮���� �ணࠬ��	
		* }
{function king_batle(var h_hp,h_damage,h_rezisten,m_hp,m_damage,m_rezisten:extended;h_mp,m_mp:integer):extended;}

procedure map_mob_kill_save(hx,hy,hz:integer);
begin
map_load;
map_based_n.a[hx,hy,128].ansi_image:=' ';
map_save;

end;
{
	* 14.06.2011
	* �㭪�� �����樨 ����
	* }
function date_generation(s:byte):string;
	var
	dat1_file,dat2_file:textfile;//䠩� � �����묨 � ���ਠ���
	d_m1,d_m2:array[0..9]of string[50];
	s1,s2:string[50];
	i:byte;
begin
date_generation:='test date';
    Assign(dat1_file,'files/date/date1.date');
    reset(dat1_file);
    Assign(dat2_file,'files/date/date2.date');
    reset(dat2_file);    
    for i:=0 to 9 do begin
    
    readln(dat1_file,s1);d_m1[i]:=s1;
    readln(dat2_file,s2);d_m2[i]:=s2;
					  end;
    close(dat1_file);
    close(dat2_file);
date_generation:=d_m1[random(9)]+' '+ d_m2[random(9)];   
end;	
{
	* 26.06.2011
	* �㭪�� ���ᠭ�� �������� ����������
	* v0.1
	* }
	function get_cast(s:string):string;
	begin
	
	end;
	{
		*26.08.2011 
		* ����஥筠� ��楤��
		* }
procedure flash_map_load(hx,hy,hz:integer);
	var
	map_file:file of map_based;//textfile;
	begin
    Assign(map_file,'files/map/map1.map');
    reset(map_file);	
	read(map_file,map_based_n);
	close(map_file);
end;	
{
	*26.08.2011 
	* ����஥筠� ��楤��
	* }
	procedure big_map(hx,hy,hz:integer);
	var
	i,j:integer;
	
	begin
//map_load;
flash_map_load(hx,hy,hz);	
for j:=-20 to 20 do  begin//1
write('|');
for i:=-35 to 35 do  begin//2
write(map_based_n.a[hx+i,hy+j,hz].{a_material}ansi_image);
end;//2
writeln('||');
{case j of
-4:writeln('||');
-3:writeln('| �� ��������� � '+map_info(map_based_n.a[hx,hy,hz].a_material));
-2:writeln('| ������� '+map_info(map_based_n.a[hx,hy+1,hz].a_material));
-1:writeln('| ������ '+map_info(map_based_n.a[hx,hy-1,hz].a_material));
0:writeln('| ������ '+map_info(map_based_n.a[hx+1,hy,hz].a_material));
1:writeln('| ����� '+map_info(map_based_n.a[hx-1,hy,hz].a_material));
2:writeln('| ��� ������� '+map_info(map_based_n.a[hx,hy,hz+1].a_material));
3:writeln('| ��� ������ '+map_info(map_based_n.a[hx,hy,hz-1].a_material));
4:writeln('||');
end;}
end;//1
	
	end;
BEGIN
//���樨����� ����
END.

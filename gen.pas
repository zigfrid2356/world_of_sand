//��������� � ��������������
//������� �� 17.04.2012
//�����㥬 � ��⭠�
//�襭�� �� 30.01.2016

//*************************************************//
//**                                             **//
//**                                             **//
//**                                             **//
//**              ��������� ������               **//
//**                     ��                      **//
//**                 30.01.2016                  **//
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


IMPLEMENTATION
{
	* 27.05.2011
	* �����頥� ����� � ���� ᡮન �����
	* }
function get_info:string;
begin
get_info:='v0.2 bd30.01.2016';
end;

//+16.09.2015


BEGIN
//���樨����� ����
END.

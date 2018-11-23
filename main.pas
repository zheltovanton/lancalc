unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Winsock, Dialogs, StdCtrls, Buttons, Masks, ActnMan, ActnColorMaps, ExtCtrls,
  jpeg, ComCtrls;

type
  TForm1 = class(TForm)
    XPColor: TXPColorMap;
    Panel1: TPanel;
    Label12: TLabel;
    Edit9: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit12: TEdit;
    Edit11: TEdit;
    Edit10: TEdit;
    Edit8: TEdit;
    Edit7: TEdit;
    Edit6: TEdit;
    Edit5: TEdit;
    Label11: TLabel;
    Label10: TLabel;
    Label9: TLabel;
    Label8: TLabel;
    Label13: TLabel;
    Panel2: TPanel;
    Edit1: TEdit;
    Label6: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    ComboBox1: TComboBox;
    dopIpEdit: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    inversMaskEdit: TEdit;
    maskEdit1: TEdit;
    ipEdit1: TEdit;
    Label14: TLabel;
    Panel3: TPanel;
    ipEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    maskEdit: TEdit;
    sbApply: TSpeedButton;
    Label15: TLabel;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    Shape2: TShape;
    Shape1: TShape;
    Image1: TImage;
    UpDown1: TUpDown;
    Label16: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure ipEditKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1CloseUp(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure maskEditChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure maskEditMouseEnter(Sender: TObject);
    procedure Edit9MouseLeave(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
  private
    procedure ChisloHostov;
    procedure AddressSeti;
    procedure MaxMinBroadcastIP;
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TIPAddress = record
    oct1,
    oct2,
    oct3,
    oct4: Byte;
  end;

var
  Form1: TForm1;

  subnetMasks: array [0..23] of string =
  ('', '255.0.0.0', '255.128.0.0', '255.192.0.0', '255.224.0.0',
   '255.240.0.0', '255.248.0.0', '255.252.0.0', '255.254.0.0',
   '255.255.0.0', '255.255.128.0', '255.255.192.0', '255.255.224.0',
   '255.255.240.0', '255.255.248.0', '255.255.252.0', '255.255.254.0',
   '255.255.255.0', '255.255.255.128', '255.255.255.192', '255.255.255.224',
   '255.255.255.240', '255.255.255.248', '255.255.255.252');

  prefixes: array [0..23] of string =
  ('', '/8', '/9', '/10', '/11', '/12', '/13', '/14', '/15', '/16',
   '/17', '/18', '/19', '/20', '/21', '/22', '/23', '/24', '/25', '/26',
   '/27', '/28', '/29', '/30');

implementation

{$R *.dfm}

function GetLocalIP : string;
type
  TaPInAddr = array [0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: array [0..63] of char;
  I: Integer;
  GInitData: TWSADATA;
begin
  WSAStartup($101, GInitData);
  Result := '';
  GetHostName(Buffer, SizeOf(Buffer));
  phe :=GetHostByName(buffer);
  if phe = nil then
    Exit;
  pptr := PaPInAddr(Phe^.h_addr_list);
  I := 0;
  while pptr^[I] <> nil do
  begin
    result:=StrPas(inet_ntoa(pptr^[I]^));
    Inc(I);
  end;
  WSACleanup;
end;

function CheckIP(ip:string):boolean;
var i : integer;
    s1,s2,s3,s4 : string;
    n1,n2,n3,n4 : integer;
    n : Integer;
begin
  Result := false;
  if ip='' then 
    begin
      Result := true;
      Exit;
    end;
  s1:='';  s2:='';  s3:='';  s4:='';
  n := 1;
  if length(ip)<16  then
    begin
      for I:= 1 to length(ip) do
        begin
           if (n=4)and(ip[i]='.') then s1:='-1';
           if ip[i]='.' then
             begin
               inc(n);
               Continue;
             end;

           if n=1 then s1:=s1+ip[i];
           if n=2 then s2:=s2+ip[i];
           if n=3 then s3:=s3+ip[i];
           if n=4 then s4:=s4+ip[i];
        end;
       n1:=StrToIntDef(s1,-1);
       n2:=StrToIntDef(s2,-1);
       n3:=StrToIntDef(s3,-1);
       n4:=StrToIntDef(s4,-1);
       Result := true;
       if (n1=-1)or(n1>255) then Result := false;
       if (n2=-1)or(n2>255) then Result := false;
       if (n3=-1)or(n3>255) then Result := false;
       if (n4=-1)or(n4>255) then Result := false;

    end else Result := false;
end;

function BinToInt(Value: string): Integer;
 var
   i, iValueSize: Integer;
 begin
   Result := 0;
   iValueSize := Length(Value);
   for i := iValueSize downto 1 do
     if Value[i] = '1' then
       Result := Result + (1 shl (iValueSize - i));
 end;


function IpToHEX(const ip: TIPAddress): String;
begin
  Result := IntToHex(ip.oct1, 2) + '.';
  Result := Result + IntToHex(ip.oct2, 2) + '.';
  Result := Result + IntToHex(ip.oct3, 2) + '.';
  Result := Result + IntToHex(ip.oct4, 2);
end;

function IpToDouble(const ip: TIPAddress): String;
var
  sDv: string;
  iMod, iDch, i :integer;
begin
 sDv := '';
  iDch := ip.oct1;
  while iDch >= 2 do
    begin
      iMod := iDch mod 2;
      iDch := iDch div 2;
      sDv := IntToStr(iMod) + sDv;
    end;
  sDv := IntToStr(iDch) + sDv;

  if Length(sDv) < 8 then
    for I := 1 to 8 - Length(sDv) do
      sDv := '0' + sDv;
  Result := sDv + '.';

  sDv := '';
  iDch := ip.oct2;
  while iDch >= 2 do
    begin
      iMod := iDch mod 2;
      iDch := iDch div 2;
      sDv := IntToStr(iMod) + sDv;
    end;
  sDv := IntToStr(iDch) + sDv;

  if Length(sDv) < 8 then
    for I := 1 to 8 - Length(sDv) do
      sDv := '0' + sDv;
  Result := Result + sDv + '.';

  sDv := '';
  iDch := ip.oct3;
  while iDch >= 2 do
    begin
      iMod := iDch mod 2;
      iDch := iDch div 2;
      sDv := IntToStr(iMod) + sDv;
    end;
  sDv := IntToStr(iDch) + sDv;

  if Length(sDv) < 8 then
    for I := 1 to 8 - Length(sDv) do
      sDv := '0' + sDv;
  Result := Result + sDv + '.';

  sDv := '';
  iDch := ip.oct4;
  while iDch >= 2 do
    begin
      iMod := iDch mod 2;
      iDch := iDch div 2;
      sDv := IntToStr(iMod) + sDv;
    end;
  sDv := IntToStr(iDch) + sDv;

  if Length(sDv) < 8 then
    for I := 1 to 8 - Length(sDv) do
      sDv := '0' + sDv;
  Result := Result + sDv;
end;

function IPToCardinal(const ip: TIPAddress):Cardinal;
begin
  Result :=  (ip.Oct1*16777216)
            +(ip.Oct2*65536)
            +(ip.Oct3*256)
            +(ip.Oct4);
end;

function CardinalToIP(const Value:Cardinal):TIPAddress;
begin
  Result.Oct1 := Value div 16777216;
  Result.Oct2 := Value div 65536;
  Result.Oct3 := Value div 256;
  Result.Oct4 := Value mod 256;
end;

function StrToIp(const ip: string): TIPAddress;
var
  i, k: integer;
  outIp: TIPAddress;
  tmpStr: string;
begin
  // octet1
  tmpStr := '';
  for i := 1 to Length(ip) do
  begin
    if ip[i] <> '.' then
      tmpStr := tmpStr + ip[i]
    else
    begin
      outIp.oct1 := StrToInt(tmpStr);
      k := i;
      break;
    end;
  end;

  //octet2
  tmpStr := '';
  for i := k + 1 to Length(ip) do
  begin
    if ip[i] <> '.' then
      tmpStr := tmpStr + ip[i]
    else
    begin
      outIp.oct2 := StrToInt(tmpStr);
      k := i;
      break;
    end;
  end;

  //octet3
  tmpStr := '';
  for i := k + 1 to Length(ip) do
  begin
    if ip[i] <> '.' then
      tmpStr := tmpStr + ip[i]
    else
    begin
      outIp.oct3 := StrToInt(tmpStr);
      k := i;
      break;
    end;
  end;

  //octet4
  tmpStr := '';
  for i := k + 1 to Length(ip) do
      tmpStr := tmpStr + ip[i];

  outIp.oct4 := StrToInt(tmpStr);

  Result := outIp;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  ip1: TIPAddress;
begin
  if (Trim(ipEdit.Text) = '') or (Trim(maskEdit.Text) = '') then
    Exit;

  if CheckIP(ipEdit.Text) = False then
  begin
    MessageDlg('Wrong IP address!', mtError, [mbOk], 0);
    ipEdit.SetFocus;
    Exit;
  end;
  
  ipEdit1.Text := ipEdit.Text;
  maskEdit1.Text := maskEdit.Text;

  ip1 := StrToIp(maskEdit1.Text);
  inversMaskEdit.Text := IntToStr(255 - ip1.oct1) + '.' + IntToStr(255 - ip1.oct2) + '.' + IntToStr(255 - ip1.oct3) + '.' + IntToStr(255 - ip1.oct4);

  ChisloHostov;

  AddressSeti;

  MaxMinBroadcastIP;

  ComboBox1CloseUp(Sender);
end;

procedure TForm1.ComboBox1CloseUp(Sender: TObject);
var
  ip1, ip2, ip3: TIPAddress;
  ip4, ip5, ip6, ip7: TIPAddress;
begin
  if (Trim(ipEdit.Text) = '') or (Trim(maskEdit.Text) = '') then
    Exit;
  
  if CheckIP(ipEdit.Text) = False then
  begin
    MessageDlg('Wrong IP address!', mtError, [mbOk], 0);
    ipEdit.SetFocus;
    Exit;
  end;

  ip1 := StrToIp(maskEdit1.Text);
  ip2 := StrToIp(ipEdit1.Text);
  ip3 := StrToIp(inversMaskEdit.Text);

  ip4 := StrToIp(Edit8.Text);
  ip5 := StrToIp(Edit7.Text);
  ip6 := StrToIp(Edit6.Text);
  ip7 := StrToIp(Edit5.Text);


  if ComboBox1.ItemIndex = 0 then
  begin
    dopIpEdit.Text := IntToStr(IPToCardinal(ip2));
    Edit3.Text := IntToStr(IPToCardinal(ip1));
    Edit4.Text := IntToStr(IPToCardinal(ip3));

    Edit10.Text := IntToStr(IPToCardinal(ip4));
    Edit11.Text := IntToStr(IPToCardinal(ip5));
    Edit12.Text := IntToStr(IPToCardinal(ip6));
    Edit14.Text := IntToStr(IPToCardinal(ip7));
  end;

  if ComboBox1.ItemIndex = 1 then
  begin
    dopIpEdit.Text := IpToDouble(ip2);
    Edit3.Text := IpToDouble(ip1);
    Edit4.Text := IpToDouble(ip3);

    Edit10.Text := IpToDouble(ip4);
    Edit11.Text := IpToDouble(ip5);
    Edit12.Text := IpToDouble(ip6);
    Edit14.Text := IpToDouble(ip7);
  end;

  if ComboBox1.ItemIndex = 2 then
  begin
    dopIpEdit.Text := IpToHEX(ip2);
    Edit3.Text := IpToHEX(ip1);
    Edit4.Text := IpToHEX(ip3);

    Edit10.Text := IpToHEX(ip4);
    Edit11.Text := IpToHEX(ip5);
    Edit12.Text := IpToHEX(ip6);
    Edit14.Text := IpToHEX(ip7);
  end;

end;

procedure TForm1.Edit9MouseLeave(Sender: TObject);
begin
  (Sender as TEdit).Color:=$00EEEEEE;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  ipEdit.SetFocus;
  ipEdit.Text:=GetLocalIP;
end;

procedure TForm1.ChisloHostov;
var
  str_mask: string;
  str_temp: string;
  i: Integer;
  k: Integer;
  hostov: Integer;
begin
  // –ассчитываем число хостов
  //(2 в степени сколько нулей в двоичном представлении маски с конца)
  str_mask := IpToDouble(StrToIp(maskEdit1.Text));
  str_temp := '';
  for i := 1 to Length(str_mask) do
  begin
    if str_mask[i] <> '.' then
      str_temp := str_temp + str_mask[i];
  end;
  k := 0;
  for i := Length(str_temp) downto 1 do
  begin
    if str_temp[i] = '0' then
      inc(k)
    else
      break;
  end;
  hostov := 1;
  for i := 1 to k do
    hostov := hostov * 2;
  // минус адрес самой сети и broadcast
  hostov := hostov - 2;
  Edit9.Text := IntToStr(hostov);

  // –ассчитываем префикс сети (сколько 1 в маске сети сначала)
  k := 0;
  for i := 1 to Length(str_temp) do
  begin
    if str_temp[i] = '1' then
      inc(k)
    else
      break;
  end;
  Edit1.Text := '/' + IntToStr(k);
end;

procedure TForm1.AddressSeti;
var
  ip_str2: string;
  i, k: Integer;
  ip_str1: string;
  ip_str3: string;
  oc1, oc2, oc3, oc4: string;
  tmpStr: string;
begin
  // ќпредел€ем адрес сети (логическое » между адресом и маской сети)
  ip_str1 := IpToDouble(StrToIp(ipEdit1.Text));
  ip_str2 := IpToDouble(StrToIp(maskEdit1.Text));
  ip_str3 := '';
  for i := 1 to Length(ip_str1) do
  begin
    if (ip_str1[i] = '1') and (ip_str2[i] = '1') then
      ip_str3 := ip_str3 + '1';

    if ip_str1[i] = '.' then
      ip_str3 := ip_str3 + '.';

    if (ip_str1[i] = '0') or (ip_str2[i] = '0') then
      ip_str3 := ip_str3 + '0';
  end;
  //ShowMessage(ip_str3);
  //ip_seti := StrToIp(ip_str3);

  // octet1
  tmpStr := '';
  for i := 1 to Length(ip_str3) do
  begin
    if ip_str3[i] <> '.' then
      tmpStr := tmpStr + ip_str3[i]
    else
    begin
      oc1 := tmpStr;
      k := i;
      break;
    end;
  end;

  // octet2
  tmpStr := '';
  for i := k + 1 to Length(ip_str3) do
  begin
    if ip_str3[i] <> '.' then
      tmpStr := tmpStr + ip_str3[i]
    else
    begin
      oc2 := tmpStr;
      k := i;
      break;
    end;
  end;

  // octet3
  tmpStr := '';
  for i := k + 1 to Length(ip_str3) do
  begin
    if ip_str3[i] <> '.' then
      tmpStr := tmpStr + ip_str3[i]
    else
    begin
      oc3 := tmpStr;
      k := i;
      break;
    end;
  end;

  // octet3
  tmpStr := '';
  for i := k + 1 to Length(ip_str3) do
    tmpStr := tmpStr + ip_str3[i];
  oc4 := tmpStr;

  Edit8.Text := IntToStr(BinToInt(oc1)) + '.' + IntToStr(BinToInt(oc2)) + '.' + IntToStr(BinToInt(oc3)) + '.' + IntToStr(BinToInt(oc4));

end;

procedure TForm1.MaxMinBroadcastIP;
var
  ip_tmp1: TIPAddress;
  ip_tmp: Cardinal;
begin
  // ћинимальный IP в сети
  ip_tmp := IPToCardinal(StrToIp(Edit8.Text)) + 1;
  ip_tmp1 := CardinalToIP(ip_tmp);
  Edit7.Text := IntToStr(ip_tmp1.oct1) + '.' + IntToStr(ip_tmp1.oct2) + '.' + IntToStr(ip_tmp1.oct3) + '.' + IntToStr(ip_tmp1.oct4);

  // Broadcast адрес
  ip_tmp := IPToCardinal(StrToIp(Edit8.Text)) + 1 + StrToInt(Edit9.Text);
  ip_tmp1 := CardinalToIP(ip_tmp);
  Edit5.Text := IntToStr(ip_tmp1.oct1) + '.' + IntToStr(ip_tmp1.oct2) + '.' + IntToStr(ip_tmp1.oct3) + '.' + IntToStr(ip_tmp1.oct4);

  // ћаксимальный IP в сети
  ip_tmp := IPToCardinal(StrToIp(Edit8.Text)) + StrToInt(Edit9.Text);
  ip_tmp1 := CardinalToIP(ip_tmp);
  Edit6.Text := IntToStr(ip_tmp1.oct1) + '.' + IntToStr(ip_tmp1.oct2) + '.' + IntToStr(ip_tmp1.oct3) + '.' + IntToStr(ip_tmp1.oct4);
  Edit13.Text := Edit7.Text + ' - ' + Edit6.Text;
end;

procedure TForm1.ipEditKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #46])  then key := #0
end;

procedure TForm1.maskEditChange(Sender: TObject);
begin
  ipEdit1.Text := '';
  maskEdit1.Text := '';
  inversMaskEdit.Text := '';
  Edit1.Text := '';
  dopIpEdit.Text := '';
  Edit3.Text := '';
  Edit4.Text := '';
  Edit8.Text := '';
  Edit7.Text := '';
  Edit6.Text := '';
  Edit5.Text := '';
  Edit9.Text := '';
  Edit10.Text := '';
  Edit11.Text := '';
  Edit12.Text := '';
  Edit13.Text := '';
  Edit14.Text := '';

  if (Trim(ipEdit.Text) = '') or (Trim(maskEdit.Text) = '') then
    Exit;

  if CheckIP(ipEdit.Text) = False then
    Exit;

  Button1Click(Sender);
end;

procedure TForm1.maskEditMouseEnter(Sender: TObject);
begin
  (Sender as TEdit).Color:=XPColor.SelectedColor ;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  case (Sender as TSpeedButton).Tag of
    1:
      begin
        //maskEdit.Text := '255.0.0.0';
        UpDown1.Position := 1;
        maskEdit.Text := subnetMasks[UpDown1.Position];
        Label16.Caption := prefixes[UpDown1.Position];
      end;
    2:
      begin
        //maskEdit.Text := '255.255.0.0';
        UpDown1.Position := 9;
        maskEdit.Text := subnetMasks[UpDown1.Position];
        Label16.Caption := prefixes[UpDown1.Position];
      end;
    3:
      begin
        //maskEdit.Text := '255.255.255.0';
        UpDown1.Position := 17;
        maskEdit.Text := subnetMasks[UpDown1.Position];
        Label16.Caption := prefixes[UpDown1.Position];
      end;
  end;

  Button1Click(Sender);
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
  MasksForm.ShowModal;
  maskEdit.Text := masks.mask_str;
  UpDown1.Position := masks.updownPosition;
  maskEdit.Text := subnetMasks[UpDown1.Position];
  Label16.Caption := prefixes[UpDown1.Position];
end;

procedure TForm1.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
  maskEdit.Text := subnetMasks[UpDown1.Position];
  Label16.Caption := prefixes[UpDown1.Position];
end;

end.

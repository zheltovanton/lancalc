unit masks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Buttons;

type
  TMasksForm = class(TForm)
    StringGrid1: TStringGrid;
    sbApply: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MasksForm: TMasksForm;
  mask_str: string;
  updownPosition: integer;

implementation

{$R *.dfm}

procedure TMasksForm.Button1Click(Sender: TObject);
begin
  StringGrid1DblClick(Sender);
end;

procedure TMasksForm.FormShow(Sender: TObject);
begin
  StringGrid1.Cells[0,0] := 'Class';
  StringGrid1.Cells[1,0] := 'Mask';
  StringGrid1.Cells[2,0] := 'Inv. Mask';
  StringGrid1.Cells[3,0] := 'Num Hosts';
  StringGrid1.Cells[4,0] := 'Prefix';


  StringGrid1.Cells[0,1] := 'Class À';
  StringGrid1.Cells[1,1] := '255.0.0.0';
  StringGrid1.Cells[2,1] := '0.255.255.255';
  StringGrid1.Cells[3,1] := '16777214';
  StringGrid1.Cells[4,1] := '/8';

  StringGrid1.Cells[0,2] := '';
  StringGrid1.Cells[1,2] := '255.128.0.0';
  StringGrid1.Cells[2,2] := '0.127.255.255';
  StringGrid1.Cells[3,2] := '8388606';
  StringGrid1.Cells[4,2] := '/9';

  StringGrid1.Cells[0,3] := '';
  StringGrid1.Cells[1,3] := '255.192.0.0';
  StringGrid1.Cells[2,3] := '0.63.255.255';
  StringGrid1.Cells[3,3] := '4194302';
  StringGrid1.Cells[4,3] := '/10';

  StringGrid1.Cells[0,4] := '';
  StringGrid1.Cells[1,4] := '255.224.0.0';
  StringGrid1.Cells[2,4] := '0.31.255.255';
  StringGrid1.Cells[3,4] := '2097150';
  StringGrid1.Cells[4,4] := '/11';

  StringGrid1.Cells[0,5] := '';
  StringGrid1.Cells[1,5] := '255.240.0.0';
  StringGrid1.Cells[2,5] := '0.15.255.255';
  StringGrid1.Cells[3,5] := '1048574';
  StringGrid1.Cells[4,5] := '/12';

  StringGrid1.Cells[0,6] := '';
  StringGrid1.Cells[1,6] := '255.248.0.0';
  StringGrid1.Cells[2,6] := '0.7.255.255';
  StringGrid1.Cells[3,6] := '524286';
  StringGrid1.Cells[4,6] := '/13';

  StringGrid1.Cells[0,7] := '';
  StringGrid1.Cells[1,7] := '255.252.0.0';
  StringGrid1.Cells[2,7] := '0.3.255.255';
  StringGrid1.Cells[3,7] := '262142';
  StringGrid1.Cells[4,7] := '/14';

  StringGrid1.Cells[0,8] := '';
  StringGrid1.Cells[1,8] := '255.254.0.0';
  StringGrid1.Cells[2,8] := '0.1.255.255';
  StringGrid1.Cells[3,8] := '131070';
  StringGrid1.Cells[4,8] := '/15';

  StringGrid1.Cells[0,9] := 'Class Â';
  StringGrid1.Cells[1,9] := '255.255.0.0';
  StringGrid1.Cells[2,9] := '0.0.255.255';
  StringGrid1.Cells[3,9] := '65534';
  StringGrid1.Cells[4,9] := '/16';

  StringGrid1.Cells[0,10] := '';
  StringGrid1.Cells[1,10] := '255.255.128.0';
  StringGrid1.Cells[2,10] := '0.0.127.255';
  StringGrid1.Cells[3,10] := '32766';
  StringGrid1.Cells[4,10] := '/17';

  StringGrid1.Cells[0,11] := '';
  StringGrid1.Cells[1,11] := '255.255.192.0';
  StringGrid1.Cells[2,11] := '0.0.63.255';
  StringGrid1.Cells[3,11] := '16382';
  StringGrid1.Cells[4,11] := '/18';

  StringGrid1.Cells[0,12] := '';
  StringGrid1.Cells[1,12] := '255.255.224.0';
  StringGrid1.Cells[2,12] := '0.0.31.255';
  StringGrid1.Cells[3,12] := '8190';
  StringGrid1.Cells[4,12] := '/19';

  StringGrid1.Cells[0,13] := '';
  StringGrid1.Cells[1,13] := '255.255.240.0';
  StringGrid1.Cells[2,13] := '0.0.15.255';
  StringGrid1.Cells[3,13] := '4094';
  StringGrid1.Cells[4,13] := '/20';

  StringGrid1.Cells[0,14] := '';
  StringGrid1.Cells[1,14] := '255.255.248.0';
  StringGrid1.Cells[2,14] := '0.0.7.255';
  StringGrid1.Cells[3,14] := '2046';
  StringGrid1.Cells[4,14] := '/21';

  StringGrid1.Cells[0,15] := '';
  StringGrid1.Cells[1,15] := '255.255.252.0';
  StringGrid1.Cells[2,15] := '0.0.3.255';
  StringGrid1.Cells[3,15] := '1022';
  StringGrid1.Cells[4,15] := '/22';

  StringGrid1.Cells[0,16] := '';
  StringGrid1.Cells[1,16] := '255.255.254.0';
  StringGrid1.Cells[2,16] := '0.0.1.255';
  StringGrid1.Cells[3,16] := '510';
  StringGrid1.Cells[4,16] := '/23';

  StringGrid1.Cells[0,17] := 'Class Ñ';
  StringGrid1.Cells[1,17] := '255.255.255.0';
  StringGrid1.Cells[2,17] := '0.0.0.255';
  StringGrid1.Cells[3,17] := '254';
  StringGrid1.Cells[4,17] := '/24';

  StringGrid1.Cells[0,18] := '';
  StringGrid1.Cells[1,18] := '255.255.255.128';
  StringGrid1.Cells[2,18] := '0.0.0.127';
  StringGrid1.Cells[3,18] := '126';
  StringGrid1.Cells[4,18] := '/25';

  StringGrid1.Cells[0,19] := '';
  StringGrid1.Cells[1,19] := '255.255.255.192';
  StringGrid1.Cells[2,19] := '0.0.0.63';
  StringGrid1.Cells[3,19] := '62';
  StringGrid1.Cells[4,19] := '/26';

  StringGrid1.Cells[0,20] := '';
  StringGrid1.Cells[1,20] := '255.255.255.224';
  StringGrid1.Cells[2,20] := '0.0.0.31';
  StringGrid1.Cells[3,20] := '30';
  StringGrid1.Cells[4,20] := '/27';

  StringGrid1.Cells[0,21] := '';
  StringGrid1.Cells[1,21] := '255.255.255.240';
  StringGrid1.Cells[2,21] := '0.0.0.15';
  StringGrid1.Cells[3,21] := '14';
  StringGrid1.Cells[4,21] := '/28';

  StringGrid1.Cells[0,22] := '';
  StringGrid1.Cells[1,22] := '255.255.255.248';
  StringGrid1.Cells[2,22] := '0.0.0.7';
  StringGrid1.Cells[3,22] := '6';
  StringGrid1.Cells[4,22] := '/29';

  StringGrid1.Cells[0,23] := '';
  StringGrid1.Cells[1,23] := '255.255.255.252';
  StringGrid1.Cells[2,23] := '0.0.0.3';
  StringGrid1.Cells[3,23] := '2';
  StringGrid1.Cells[4,23] := '/30';
end;

procedure TMasksForm.StringGrid1DblClick(Sender: TObject);
begin
  mask_str := StringGrid1.Cells[1, StringGrid1.Row];
  updownPosition := StringGrid1.Row;
  MasksForm.Close;
end;

end.

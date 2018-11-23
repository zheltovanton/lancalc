program lancalc;

uses
  Forms,
  main in 'main.pas' {Form1},
  masks in 'masks.pas' {MasksForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TMasksForm, MasksForm);
  Application.Run;
end.

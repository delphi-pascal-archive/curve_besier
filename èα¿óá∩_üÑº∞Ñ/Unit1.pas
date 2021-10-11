unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    E0X: TEdit;
    Label2: TLabel;
    E0Y: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    E1X: TEdit;
    Label5: TLabel;
    E1Y: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    E2X: TEdit;
    Label8: TLabel;
    E2Y: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    E3X: TEdit;
    Label11: TLabel;
    E3Y: TEdit;
    Label12: TLabel;
    BtnApplyCoord: TBitBtn;
    Panel3: TPanel;
    PaintBox1: TPaintBox;
    procedure PaintBox1Paint(Sender: TObject);
    procedure BtnApplyCoordClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    Arr_pt: Array[0..3] Of TPoint;    // Array avec les 4 points ...

    DraggingPt: Boolean;         // Savoir si on est en train de changer la position d' un point ...
    IndDraggingPt: Integer;      // Savoir quel est le point que l' on bouge ...

    function PontoEm(x, y: Integer; Ponto: TPoint): Boolean; // Permet de savoir s' il existe un point aux coordonnées x, y ...
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BtnApplyCoordClick(Sender: TObject);
begin
  Arr_pt[0] := Point(StrToInt(E0X.Text), StrToInt(E0Y.Text));
  Arr_pt[1] := Point(StrToInt(E1X.Text), StrToInt(E1Y.Text));
  Arr_pt[2] := Point(StrToInt(E2X.Text), StrToInt(E2Y.Text));
  Arr_pt[3] := Point(StrToInt(E3X.Text), StrToInt(E3Y.Text));

  PaintBox1.Refresh;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  DraggingPt := False;
  BtnApplyCoord.OnClick(Nil);   // Inicialization des points ...
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);

        procedure DesenharPonto(Ponto: TPoint; CorPen: TColor; CorBrush: TColor);  // Dessine un point ...
        begin
          PaintBox1.Canvas.Pen.Color   := CorPen;
          PaintBox1.Canvas.Brush.Color := CorBrush;

          PaintBox1.Canvas.Rectangle(Ponto.X-2, Ponto.Y-2, Ponto.X+2, Ponto.Y+2);
        end;

        procedure MoverPara(Ponto: TPoint);                                        // MoveTo ...
        begin
          PaintBox1.Canvas.MoveTo(Ponto.x, Ponto.Y);
        end;

        procedure Linha(PontoInicial: TPoint; PontoFinal: TPoint; Cor: TColor);    // Dessine une ligne entre 2 points ...
        begin
          PaintBox1.Canvas.Pen.Color := Cor;
          MoverPara(PontoInicial);
          PaintBox1.Canvas.LineTo(PontoFinal.X, PontoFinal.Y);
        end;

begin
  With PaintBox1.Canvas Do
  begin
    Brush.Color := clWhite;
    Pen.Color   := clBlack;
    FillRect(PaintBox1.ClientRect);

    PolyBezier(Arr_pt);

    Linha(Arr_pt[0], Arr_pt[1], clRed);          // P1 e P2 ...
    Linha(Arr_pt[3], Arr_pt[2], clRed);          // P4 e P3 ...

    DesenharPonto(Arr_pt[0], clBlack, clYellow);
    DesenharPonto(Arr_pt[1], clBlack, clBlack);
    DesenharPonto(Arr_pt[2], clBlack, clBlack);
    DesenharPonto(Arr_pt[3], clBlack, clYellow);
  end;
end;

function  TForm1.PontoEm(x, y: Integer; Ponto: TPoint): Boolean;
begin
  RESULT := (Ponto.X >= x-2) And (Ponto.X <= x+2)
              And (Ponto.y >= y-2) And (Ponto.y <= y+2);
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DraggingPt := False;

  If PontoEm(x, y, Arr_pt[0])
  Then Begin
    DraggingPt := True;
    IndDraggingPt := 0;
  End;

  If PontoEm(x, y, Arr_pt[1])
  Then Begin
    DraggingPt := True;
    IndDraggingPt := 1;
  End;

  If PontoEm(x, y, Arr_pt[2])
  Then Begin
    DraggingPt := True;
    IndDraggingPt := 2;
  End;

  If PontoEm(x, y, Arr_pt[3])
  Then Begin
    DraggingPt := True;
    IndDraggingPt := 3;
  End;

  If DraggingPt
  Then PaintBox1.Cursor := crHandPoint;
end;

procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  If DraggingPt
  Then Begin
    Arr_pt[IndDraggingPt] := Point(x, y);

    TEdit( FindComponent('E' + IntToStr(IndDraggingPt)+ 'X') ).Text := IntToStr(x);
    TEdit( FindComponent('E' + IntToStr(IndDraggingPt)+ 'Y') ).Text := IntToStr(y);

    PaintBox1Paint(Nil);
  End
  Else
    If PontoEm(x, y, Arr_pt[0]) Or PontoEm(x, y, Arr_pt[1])
      Or PontoEm(x, y, Arr_pt[2]) Or PontoEm(x, y, Arr_pt[3])
    Then PaintBox1.Cursor := crHandPoint
    Else PaintBox1.Cursor := crDefault;
end;

procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If DraggingPt
  Then Begin
    PaintBox1MouseMove(PaintBox1, Shift, x, y);  // Posicionar ponto no sitio certo ...

    DraggingPt := False;
    PaintBox1.Cursor := crDefault;
  End;
end;

end.

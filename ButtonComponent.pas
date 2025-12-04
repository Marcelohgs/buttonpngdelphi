unit ButtonComponent;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Graphics,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, Winapi.Messages, Windows;

type
  TImageLayout = (ilImageTop, ilImageLeft);

  TButtonPNG = class(TGraphicControl)
  private
    FCaption: string;
    FImagePNG: TPngImage;
    FCorFundo: TColor;
    FCorTexto: TColor;
    FCorHover: TColor;
    FCorBorda: TColor;
    FIsHover: Boolean;
    FIsPressed: Boolean;
    FImageLayout: TImageLayout;
    FFont: TFont;  // ← ADICIONADO
    FOnClick: TNotifyEvent;
    procedure SetCaption(const Value: string);
    procedure SetImagePNG(const Value: TPngImage);
    procedure SetCorFundo(const Value: TColor);
    procedure SetCorTexto(const Value: TColor);
    procedure SetCorHover(const Value: TColor);
    procedure SetCorBorda(const Value: TColor);
    procedure SetImageLayout(const Value: TImageLayout);
    procedure SetFont(const Value: TFont);  // ← ADICIONADO
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure Paint; override;
    procedure Click; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function GetImageSize: Integer;  // ← ADICIONADO
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Caption: string read FCaption write SetCaption;
    property ImagePNG: TPngImage read FImagePNG write SetImagePNG;
    property ImageLayout: TImageLayout read FImageLayout write SetImageLayout default ilImageTop;
    property Font: TFont read FFont write SetFont;  // ← ADICIONADO
    property CorFundo: TColor read FCorFundo write SetCorFundo default clBtnFace;
    property CorTexto: TColor read FCorTexto write SetCorTexto default clBlack;
    property CorHover: TColor read FCorHover write SetCorHover default clSkyBlue;
    property CorBorda: TColor read FCorBorda write SetCorBorda default clGray;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property Align;
    property Anchors;
    property Cursor default crHandPoint;
    property Enabled;
    property Hint;
    property ShowHint;
    property Visible;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('ComponentesInterativa', [TButtonPNG]);
end;

{ TButtonPNG }

constructor TButtonPNG.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FImagePNG := TPngImage.Create;
  FFont := TFont.Create;
  FFont.Name := 'Segoe UI';
  FFont.Size := 9;
  FFont.Style := [fsBold];
  FCorFundo := clBtnFace;
  FCorTexto := clBlack;
  FCorHover := clSkyBlue;
  FCorBorda := clGray;
  FIsHover := False;
  FIsPressed := False;
  FImageLayout := ilImageTop;
  FCaption := 'Button';
  Width := 100;
  Height := 35;
  Cursor := crHandPoint;
end;

destructor TButtonPNG.Destroy;
begin
  FFont.Free;
  FImagePNG.Free;
  inherited;
end;

procedure TButtonPNG.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Invalidate;
  end;
end;

procedure TButtonPNG.SetImagePNG(const Value: TPngImage);
begin
  FImagePNG.Assign(Value);
  Invalidate;
end;

procedure TButtonPNG.SetCorFundo(const Value: TColor);
begin
  if FCorFundo <> Value then
  begin
    FCorFundo := Value;
    Invalidate;
  end;
end;

procedure TButtonPNG.SetCorTexto(const Value: TColor);
begin
  if FCorTexto <> Value then
  begin
    FCorTexto := Value;
    Invalidate;
  end;
end;

procedure TButtonPNG.SetCorHover(const Value: TColor);
begin
  if FCorHover <> Value then
  begin
    FCorHover := Value;
    Invalidate;
  end;
end;

procedure TButtonPNG.SetCorBorda(const Value: TColor);
begin
  if FCorBorda <> Value then
  begin
    FCorBorda := Value;
    Invalidate;
  end;
end;

procedure TButtonPNG.SetImageLayout(const Value: TImageLayout);
begin
  if FImageLayout <> Value then
  begin
    FImageLayout := Value;
    Invalidate;
  end;
end;

procedure TButtonPNG.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  Invalidate;
end;

function TButtonPNG.GetImageSize: Integer;
begin
  case FImageLayout of
    ilImageTop: Result := 32;
    ilImageLeft: Result := 24;
  else
    Result := 32;
  end;
end;

procedure TButtonPNG.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if Enabled then
  begin
    FIsHover := True;
    Invalidate;
  end;
end;

procedure TButtonPNG.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FIsHover := False;
  FIsPressed := False;
  Invalidate;
end;

procedure TButtonPNG.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (Button = mbLeft) and Enabled then
  begin
    FIsPressed := True;
    Invalidate;
  end;
end;

procedure TButtonPNG.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then
  begin
    FIsPressed := False;
    Invalidate;
  end;
end;

procedure TButtonPNG.Paint;
var
  TextRect: TRect;
  ImgX, ImgY: Integer;
  Offset: Integer;
  ImageSize: Integer;
  DestRect: TRect;
  BlendFunc: TBlendFunction;
begin
  inherited;

  // Define a cor de fundo baseado no estado
  if not Enabled then
    Canvas.Brush.Color := clBtnFace
  else if FIsHover then
    Canvas.Brush.Color := FCorHover
  else
    Canvas.Brush.Color := FCorFundo;

  // Define a cor da borda
  Canvas.Pen.Color := FCorBorda;

  Canvas.RoundRect(0, 0, Width, Height, 5, 5);

  if FIsPressed and Enabled then
    Offset := 2
  else
    Offset := 0;

  if not FImagePNG.Empty then
  begin
    ImageSize := GetImageSize;

    case FImageLayout of
      ilImageTop:
        begin
          ImgX := (Width - ImageSize) div 2 + Offset;
          ImgY := 7 + Offset;
        end;
      ilImageLeft:
        begin
          ImgX := 10 + Offset;
          ImgY := (Height - ImageSize) div 2 + Offset;
        end;
    end;

    DestRect := Rect(ImgX, ImgY, ImgX + ImageSize, ImgY + ImageSize);

    // Desenha a imagem
    Canvas.StretchDraw(DestRect, FImagePNG);

    // Se desabilitado, desenha um retângulo semi-transparente branco por cima
    if not Enabled then
    begin
      Canvas.Brush.Color := clWhite;
      Canvas.Brush.Style := bsSolid;

      BlendFunc.BlendOp := AC_SRC_OVER;
      BlendFunc.BlendFlags := 0;
      BlendFunc.SourceConstantAlpha := 128; // Opacidade do efeito
      BlendFunc.AlphaFormat := 0;

      Windows.AlphaBlend(Canvas.Handle, DestRect.Left, DestRect.Top,
        ImageSize, ImageSize, Canvas.Handle, DestRect.Left, DestRect.Top,
        ImageSize, ImageSize, BlendFunc);
    end;
  end;

  Canvas.Brush.Style := bsClear;
  Canvas.Font.Assign(FFont);

  if not Enabled then
    Canvas.Font.Color := clGray
  else
    Canvas.Font.Color := FCorTexto;

  case FImageLayout of
    ilImageTop:
      begin
        TextRect := Rect(Offset, Offset, Width + Offset, Height + Offset);
        if not FImagePNG.Empty then
          TextRect.Top := GetImageSize + 7 + Offset;
        DrawText(Canvas.Handle, PChar(FCaption), -1, TextRect,
          DT_CENTER or DT_VCENTER or DT_SINGLELINE);
      end;
    ilImageLeft:
      begin
        if not FImagePNG.Empty then
          TextRect := Rect(GetImageSize + 15 + Offset, Offset, Width + Offset, Height + Offset)
        else
          TextRect := Rect(Offset, Offset, Width + Offset, Height + Offset);
        DrawText(Canvas.Handle, PChar(FCaption), -1, TextRect,
          DT_LEFT or DT_VCENTER or DT_SINGLELINE);
      end;
  end;
end;

procedure TButtonPNG.Click;
begin
  inherited;
  if Enabled then
  begin
    FIsPressed := False;
    Invalidate;
    if Assigned(FOnClick) then
      FOnClick(Self);
  end;
end;

end.

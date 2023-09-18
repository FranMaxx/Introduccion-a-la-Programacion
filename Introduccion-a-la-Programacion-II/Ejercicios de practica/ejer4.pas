program ejercicio4;

type 
    PuntArbol = ^TArbol;
    TArbol = record
        valor: integer;
        menor: PuntArbol;
        mayor: PuntArbol;
    end;
    
    
procedure CrearNodo (var Arbol: PuntArbol; valor: integer);
begin
        new (Arbol);
        Arbol^.valor:= valor;
        Arbol^.mayor:= nil;
        Arbol^.menor:= nil;
end;

procedure InsertarEnArbol (var Arbol: PuntArbol; valor: integer);
begin
    if (Arbol = nil) then
    begin
        CrearNodo(Arbol, valor);
        end
    else begin
        if (Arbol^.valor < valor) then
        begin
            InsertarEnArbol(arbol^.mayor, valor);
        end
        else
        begin
            InsertarEnArbol(arbol^.menor, valor);
        end;
    end;
end;

procedure CargarArbol (var Arbol: PuntArbol); 
var
    valor: integer;
begin
    valor:= 0;
    while (valor <> -1) do
    begin
        writeln('ingrese un numero para el arbol, si desea finalizar, ingrese -1');
        read(valor);
        if (valor <> -1) then 
            InsertarEnArbol(Arbol, valor);
    end;
end;


Procedure ImprimirArbolAscendente(arbol:PuntArbol);
Begin
    If (arbol <> Nil) Then
    Begin
        ImprimirArbolAscendente(arbol^.menor);
        writeln(arbol^.valor);
        ImprimirArbolAscendente(arbol^.mayor);
    End;
End;

function SumaArbol (arbol: PuntArbol):integer;
begin
    if (arbol = nil) then
        sumaArbol := 0
    else
        SumaArbol := arbol^.valor + SumaArbol (arbol^.menor) + SumaArbol (arbol^.mayor);
end;

procedure CompararSumasEImprimir (arbol: PuntArbol; var acumulador:integer);
begin
    if (Arbol <> nil) then begin
        acumulador := acumulador - arbol^.valor;
        if (acumulador > 0) then 
            CompararSumasEImprimir (arbol^.menor, acumulador);
        if (acumulador > 0) then 
            CompararSumasEImprimir (arbol^.mayor, acumulador);
        if (acumulador = 0) then        //No va con else porque lo imprimimos cuando sale de la recursion
            writeln(arbol^.valor);
    end;
end;


//Programa principal
var
    arbol: PuntArbol;
    acumulador: integer;
begin
    CargarArbol (Arbol);
    ImprimirArbolAscendente (Arbol);
    acumulador := SumaArbol (Arbol^.menor) + Arbol^.valor;
    writeln('Los que cumplen las condiciones son:');
    CompararSumasEImprimir (Arbol^.mayor, acumulador);
end.
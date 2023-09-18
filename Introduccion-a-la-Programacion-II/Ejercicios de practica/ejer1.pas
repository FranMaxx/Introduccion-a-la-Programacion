Program exc1;

Type 
    PuntArbol =   ^TArbol;
    TArbol =   Record
        nivel:   integer;
        codigo:   integer;
        menor,mayor:   PuntArbol;
    End;

    PuntLista =   ^TLista;
    TLista =   Record
        nivel:   integer;
        codigo:   integer;
        Sig:   PuntLista;
    End;

    Tarchivo =   file Of integer;


Procedure CargarArchivo (Var Codigo: Tarchivo);
Var 
    Valor:   integer;
Begin
    Valor := 0;
    While (Valor <> -1) Do
        Begin
            writeln ('Ingrese el valor que se quiere agregar al archivo');
            readln (Valor);
            write (Codigo, Valor);
        End;
End;

Procedure ImprimirArchivo(var codigo: Tarchivo);
var valor: integer;
begin
    seek(codigo, 0);
    writeln('Archivo ');
    while not eof(codigo) do begin
        read(codigo, valor);
        write(valor, '|');
    end;
    writeln('-------------------');
end;

Procedure AbrirArchivo(Var archivo:Tarchivo);
Begin
    {$I-}
    reset(archivo);
    {$I+}
    If (ioresult <> 0) Then
    Begin
        rewrite(archivo);
        CargarArchivo(archivo);
    End;
End;

Function BuscaEnArchivo (Var Codigo: Tarchivo; Codigo_Buscado: integer):   boolean;
Var 
    Dato:   integer;
Begin
    seek(Codigo,0);
    // EL ARCHIVO YA ESTA ABIERTO, CORRESPONDE SEEK(CODIGO,0)
    read (Codigo, Dato);

    While Not (eof(Codigo)) And (Codigo_Buscado > Dato)   Do
    begin
        read (Codigo, Dato);
        writeln(dato);
    end;
    If (Dato = Codigo_Buscado) And Not (eof(Codigo)) Then
        BuscaEnArchivo := true
    Else
        BuscaEnArchivo := false;
End;

Procedure CrearNodo(Var Arbol: PuntArbol;valor,nivel:integer);
Begin
    new (Arbol);
    Arbol^.codigo := valor;
    Arbol^.mayor := Nil;
    Arbol^.menor := Nil;
    Arbol^.nivel := nivel;
End;

Procedure InsertarEnArbol(Var Arbol: PuntArbol; valor, nivel: integer);
Begin
    If (Arbol = Nil) Then
        CrearNodo(Arbol,valor,nivel)
    Else
        If (Arbol^.codigo < valor) Then
            InsertarEnArbol(arbol^.mayor,valor,nivel+1)
        Else
            InsertarEnArbol(arbol^.menor,valor,nivel+1);
End;

Procedure CargarArbol(Var Arbol: PuntArbol);
Var 
    nivel,valor:   integer;
Begin
    valor := 0;
    While (valor <> -1) Do
        Begin
            writeln('ingrese un valor para cargar el arbol, si desea finalizar, ingrese -1');
            readln(valor);
            nivel := 0;
            If valor <> -1 Then
                InsertarEnArbol(Arbol,valor,nivel);
        End;
End;

// -----------------------------------------------------------------
// -----------------------------------------------------------------
// -----------------------------------------------------------------

Function BuscaEnArbol (Arbol: PuntArbol; codigo_buscado:integer):   boolean;
Begin
    If (Arbol <> Nil) Then
        Begin
            If (codigo_buscado = arbol^.codigo) Then
                BuscaEnArbol := true
            Else
                If (codigo_buscado < arbol^.codigo) Then
                    BuscaEnArbol := BuscaEnArbol(Arbol^.menor,codigo_buscado)
            Else
                BuscaEnArbol := BuscaEnArbol(Arbol^.mayor,codigo_buscado);
        End
    Else
        BuscaEnArbol := false;
End;


Procedure ImprimirArbolAscendente(arbol:PuntArbol);
Begin
    If (arbol <> Nil) Then
    Begin
        ImprimirArbolAscendente(arbol^.menor);
        writeln(arbol^.codigo);
        ImprimirArbolAscendente(arbol^.mayor);
    End;
End;

Procedure InsertarOrdenadoLista(Var lista:PuntLista; nodoInsertar:PuntLista);
Begin
    If (lista = Nil) Or (nodoInsertar^.nivel > lista^.nivel) Then
        Begin
            nodoInsertar^.sig := lista;
            lista := nodoInsertar;
        End
    Else
        InsertarOrdenadoLista(lista^.sig, nodoInsertar);
End;

Function CantDescendientes(Arbol: PuntArbol): integer;
Begin
    If (arbol <> Nil) Then
        CantDescendientes := 1 + CantDescendientes(Arbol^.menor) + CantDescendientes(Arbol^.mayor)
    Else
        CantDescendientes := 0;
End;

Procedure CrearNodo(Var nodoInsertar: PuntLista;valor,nivel:integer);
Begin
    new (nodoInsertar);
    nodoInsertar^.codigo := valor;
    nodoInsertar^.sig := Nil;
    nodoInsertar^.nivel := nivel;
End;

Function EsImpar(arbol:PuntArbol):   boolean;
Begin
    // Restamos uno para excluir al padre de los descendientes
    EsImpar := (((CantDescendientes(arbol) - 1)  Mod 2) <> 0);
    writeln(CantDescendientes(arbol) - 1);
End;

Procedure ArmarLista(Arbol:PuntArbol; Var lista:PuntLista; codigo_buscado:integer);
Var 
    nodoInsertar: PuntLista;
Begin
    If arbol <> Nil Then
    Begin
        If (arbol^.codigo < (codigo_buscado + 100)) And (arbol^.codigo > codigo_buscado) Then
        Begin
            writeln(arbol^.codigo, ' esta en rango');
            If  Esimpar(arbol)  Then
            Begin
                writeln(arbol^.codigo, ' tiene descendintes impares');
                CrearNodo(nodoInsertar,arbol^.codigo,arbol^.nivel);
                InsertarOrdenadoLista(lista, nodoInsertar);

                ArmarLista(Arbol^.menor,lista,codigo_buscado);
                ArmarLista(Arbol^.mayor,lista,codigo_buscado);
            End;
        End
        Else If  (arbol^.codigo > (codigo_buscado + 100)) Then
        begin
            writeln('Codigo demasiado grande');
            ArmarLista(arbol^.menor,lista,codigo_buscado);  
        end
        Else If (arbol^.codigo < codigo_buscado)   Then
        begin
            writeln('Codigo demasiado chico');
            ArmarLista(arbol^.mayor,lista,codigo_buscado);
        end;
    End;
End;

Procedure imprimirlista(lista:puntlista);
Begin
    If (lista <> Nil) Then
        Begin
            writeln(lista^.codigo);
            imprimirlista(lista^.sig);
        End;
End;

Procedure Resolver(Elarbol:PuntArbol; Var codigo:Tarchivo);
Var 
    codigo_buscado:   integer;
    lista:   PuntLista;
Begin
    lista := Nil;
    
    writeln ('Ingrese el valor que se quiere buscar');
    readln (Codigo_Buscado);

    If (BuscaEnArchivo(codigo,codigo_buscado)) Then
        Begin
            writeln ('El valor se encuentra en el archivo');
            If (BuscaEnArbol(Elarbol,Codigo_Buscado) =true) Then
                writeln('El valor se encuentra tanto en el archivo como en el arbol')
            Else
                InsertarEnArbol(Elarbol,Codigo_Buscado,0)
        End
    Else
        writeln ('El valor NO se encuentra en el archivo');
    
    writeln('------------------------------');
    ImprimirArbolAscendente(Elarbol);
    writeln('------------------------------');
    
    ArmarLista(Elarbol,lista,codigo_buscado);
    
    writeln('la lista es: ');
    ImprimirLista(lista);
End;


///MAIN///
Var 
    Elarbol:   PuntArbol;
    Codigo:   Tarchivo;
Begin
    assign (codigo,'/work/anonymous_enteritos.dat');
    AbrirArchivo (codigo);
    ImprimirArchivo(codigo);

    Elarbol := Nil;
    CargarArbol(Elarbol);

    Resolver(Elarbol,codigo);

    Close (Codigo);
End.
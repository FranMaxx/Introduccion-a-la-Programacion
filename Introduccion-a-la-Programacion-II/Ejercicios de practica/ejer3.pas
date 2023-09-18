program exc3;

Type
     ///EQUIPO///
    TEquipo = record
        Nombre: string;
        Puntaje: integer;
    end;
    ///ARBOL///
    PuntArbol = ^TArbol;
    TArbol = record
        Equipo: TEquipo;
        ListaPuntaje: PuntArbol;
        Izq, Der: PuntArbol;
    end;
    ///ARCHIVO///
    TArchivo =  file of TEquipo;

///ARCHIVO////
procedure CargarArchivo (var Equipo: TArchivo);
var
    EquipoNuevo: TEquipo;
    valor: Integer;
begin
    Valor:= 0;                              //PARA QUE ENTRE EN EL BUCLE Y NO HAYA BASURA
    while (Valor <> -1) do 
    begin
        writeln ('Ingrese el nombre que se quiere agregar al archivo');
        readln (EquipoNuevo.Nombre);
        writeln ('Ingrese el puntaje que se quiere agregar al archivo');
        readln (EquipoNuevo.Puntaje);
        write (Equipo, EquipoNuevo);
        writeln ('Si ingresa un -1 deja de cargar en el archivo');
        readln (valor);
    end;    
end;

procedure AbrirArchivo(var Archivo:TArchivo);       // ABRE EL ARCHIVO Y LO CARGA SI NO EXISTE ....
begin
    {$I-}
    reset (archivo);
    {$I+}
    if (ioresult <> 0) then begin
        rewrite(archivo);
        CargarArchivo(archivo);
    end;
end;

///PROCEDEMIENTOS PARA LA RESOLUCION DEL PROBLEMA///
procedure CrearNodoArbol(var Arbol: PuntArbol; EquipoNuevo: TEquipo);
begin
    new (Arbol);
    Arbol^.Equipo.Nombre:= EquipoNuevo.Nombre;    
    Arbol^.Equipo.Puntaje:= EquipoNuevo.Puntaje;
    Arbol^.ListaPuntaje:= NIL;                      
    Arbol^.izq:= NIL;
    Arbol^.der:= NIL;
end;


procedure InsertarOrdenadoPorPuntaje (Arbol: PuntArbol; var Lista: PuntArbol); 
begin
    //writeln('Entra aca? inicio');
    if (Lista = nil) or (Arbol^.Equipo.Puntaje > Lista^.Equipo.Puntaje) then begin  
        Arbol^.ListaPuntaje := Lista;
        Lista := Arbol;
    end 
    else begin
        InsertarOrdenadoPorPuntaje(Arbol, Lista^.ListaPuntaje);
    end;
end;    

procedure InsertarAlfabeticamente (var Arbol, Lista: PuntArbol; EquipoNuevo: TEquipo);
//ESTE PROCEDIMIENTO RECIBE UN CASILLERO DEL ARCHIVO Y LO INSERTA DE MANERA ALFABETICA EN EL ARBOL
begin
    begin
    if (Arbol = NIL) then
    begin
        CrearNodoArbol (Arbol,EquipoNuevo);
        InsertarOrdenadoPorPuntaje (Arbol, Lista);         //ESTE PROCEDIMIENTO VA AGREGANDO ORDENANDAMENTE POR PUNTAJE
    end else begin
        if (Arbol^.Equipo.Nombre < EquipoNuevo.Nombre) then
        begin
            InsertarAlfabeticamente (arbol^.der,Lista, EquipoNuevo);
        end
        else
        begin
            InsertarAlfabeticamente (arbol^.izq,Lista, EquipoNuevo);
        end;
    end;
end;
end;

procedure RecorreArchivo (var Archivo: TArchivo; var Arbol, Lista: PuntArbol);
//ESTE PROCEDIMIENTO RECORRE EL ARCHIVO HASTA VACIARSE Y LE PASA POR PARAMETRO A OTRO PROCEDIMIENTO PARA AGREGAR AL ARBOL
var
    EquipoNuevo: TEquipo;
begin
    seek (Archivo, 0);
    while not (eof (Archivo)) do begin
        read (Archivo, EquipoNuevo);
        InsertarAlfabeticamente (Arbol, Lista, EquipoNuevo);
    end;    
end;

///IMPRIMIR///
procedure ImprimirArbolAscendente (Arbol: PuntArbol);  
begin
    if (arbol <> nil) then
    begin
        ImprimirArbolAscendente(arbol^.izq);
        writeln('Nombre: ',arbol^.Equipo.Nombre);
        writeln('Puntaje: ',arbol^.Equipo.Puntaje);
        writeln('------------------------------');
        ImprimirArbolAscendente (arbol^.der);
    end;
end;

procedure ImprimirLista(Lista: puntArbol);
begin
    if (Lista <> nil) then 
    begin
        writeln(Lista^.Equipo.Puntaje);
        ImprimirLista(Lista^.ListaPuntaje);
    end;
end;

///MAIN///
var
    ElArbol, Lista: PuntArbol;
    Equipo :TArchivo;
begin
    assign (Equipo, '/work/GRUPO_ANONIMO_enteros.dat');
    ElArbol:= NIL;
    Lista:= NIL;    
    AbrirArchivo (Equipo);
    RecorreArchivo (Equipo, ElArbol, Lista);
    writeln ('===========================================================');
    writeln ('El arbol quedo de la siguiente manera: ');
    ImprimirArbolAscendente (ElArbol);
    writeln ('===========================================================');
    writeln ('La lista  ada por puntaje quedo de la siguiente manera: ');
    ImprimirLista (Lista);
    Close (Equipo);
end.
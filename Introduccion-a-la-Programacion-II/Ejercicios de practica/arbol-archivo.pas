program arbolAArchivo;

{ De un arbol, crear un archivo de mayor a menor }

type
    puntArbol = ^TArbol;
    TArbol = record
        num: integer;
        menor, mayor: puntArbol;
    end;
    
    archivo = file of integer;
    
procedure crearNodoArbol(var arbol: puntArbol; num: integer);
begin
    new(arbol);
    arbol^.num:= num;
    arbol^.menor:= nil;
    arbol^.mayor:= nil;
end;

procedure insertarOrdenado(var arbol: puntArbol; num: integer);
begin
    if arbol = nil then
        crearNodoArbol(arbol, num)
    else begin
        if num < arbol^.num then
            insertarOrdenado(arbol^.menor, num)
        else
            insertarOrdenado(arbol^.mayor, num);
    end;
end;

procedure cargarArbol(var arch: archivo; var arbol: puntArbol);
begin
    insertarOrdenado(arbol, 1);
    insertarOrdenado(arbol, 4);
    insertarOrdenado(arbol, 2);
    insertarOrdenado(arbol, 3);
    insertarOrdenado(arbol, 5);
end;

procedure imprimirArbol(arbol: puntArbol);
begin
    if arbol <> nil then begin
        imprimirArbol(arbol^.menor);
        writeln(arbol^.num);
        imprimirArbol(arbol^.mayor);
    end;
end;

procedure cargarArchivo(arbol: puntArbol; var arch: archivo);
begin
    if arbol <> nil then begin
        cargarArchivo(arbol^.mayor, arch);
        write(arch, arbol^.num);
        cargarArchivo(arbol^.menor, arch);
    end;
end;

procedure imprimirArchivo(var arch: archivo);
var aux: integer;
begin
    seek(arch, 0);
    
    while not eof(arch) do begin
        read(arch, aux);
        writeln(aux);
    end;
end;

// Programa principal
var arch: archivo;
    arbol: puntArbol;
begin
    assign(arch, '/work/lozano_archivoAArbol');
    
    arbol:= nil;
    
    cargarArbol(arch, arbol);
    imprimirArbol(arbol);
    
    writeln;
    
    rewrite(arch);
    cargarArchivo(arbol, arch);
    imprimirArchivo(arch);
    close(arch);
end.
program archivoAArbol;

{ De un archivo, crea un arbol ordenado }

type
    puntArbol = ^TArbol;
    TArbol = record
        num: integer;
        menor, mayor: puntArbol;
    end;
    
    archivo = file of integer;
    
procedure cargarArchivo(var arch: archivo);
begin
    write(arch, 2);
    write(arch, 4);
    write(arch, 6);
    write(arch, 1);
end;

procedure abrirArchivo(var arch: archivo);
begin
    {$I-}
    reset(arch);
    {$I+}
    if ioresult <> 0 then begin
        rewrite(arch);
        cargarArchivo(arch);
    end;
end;

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
var aux: integer;
begin
    seek(arch, 0);
    
    while not eof(arch) do begin
        read(arch, aux);
        insertarOrdenado(arbol, aux);
    end;
end;

procedure imprimirArbol(arbol: puntArbol);
begin
    if arbol <> nil then begin
        imprimirArbol(arbol^.menor);
        writeln(arbol^.num);
        imprimirArbol(arbol^.mayor);
    end;
end;
    
// Programa principal
var arch: archivo;
    arbol: puntArbol;
begin
    assign(arch, '/work/lozano_archivoAArbol');
    
    arbol:= nil;
    
    abrirArchivo(arch);
    cargarArbol(arch, arbol);
    imprimirArbol(arbol);
    close(arch);
end.
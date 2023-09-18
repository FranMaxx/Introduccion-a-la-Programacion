program recuperatorio2021;

type
    TEquipo = record
        nombre: string;
        puntaje: integer;
    end;
    
    puntArbol = ^TArbol;
    TArbol = record
        equipo: TEquipo;
        menor, mayor, ordenPuntaje: puntArbol;
    end;
    
    archivoEquipos = file of TEquipo;
    
procedure abrirArchivo(var arch: archivoEquipos; var arbol: puntArbol);
begin
    {$I-}
    reset(arch);
    {$I+}
    if ioresult <> 0 then
        rewrite(arch);
end;
    
procedure imprimirArchivo(var arch: archivoEquipos);
var aux: TEquipo;
begin
    seek(arch, 0);
    
    while not eof(arch) do begin
        read(arch, aux);
        writeln(aux.nombre, ' - ', aux.puntaje);
    end;
end;

procedure crearNodo(var arbol: puntArbol; equipo: TEquipo);
begin
    new(arbol);
    arbol^.equipo.nombre:= equipo.nombre;
    arbol^.equipo.puntaje:= equipo.puntaje;
    arbol^.menor:= nil;
    arbol^.mayor:= nil;
    arbol^.ordenPuntaje:= nil;
end;

procedure insertarPuntajeOrdenado(arbol: puntArbol; var lista: puntArbol);
begin
    if (lista = nil) or (arbol^.equipo.puntaje < lista^.equipo.puntaje) then begin
        arbol^.ordenPuntaje:= lista;
        lista:= arbol;
    end else
        insertarPuntajeOrdenado(arbol, lista^.ordenPuntaje);
end;

procedure insertarOrdenadoArbol(var arbol, lista: puntArbol; equipo: TEquipo);
begin
    if arbol = nil then begin
        crearNodo(arbol, equipo);
        insertarPuntajeOrdenado(arbol, lista);
    end else begin
        if equipo.nombre < arbol^.equipo.nombre then
            insertarOrdenadoArbol(arbol^.menor, lista, equipo)
        else
            insertarOrdenadoArbol(arbol^.mayor, lista, equipo);
    end;
end;

function estaEnArbol(arbol: puntArbol; equipo: TEquipo): boolean;
begin
    if arbol = nil then begin
        estaEnArbol:= false
    end else if arbol^.equipo.nombre = equipo.nombre then
        estaEnArbol:= true
    else if equipo.nombre < arbol^.equipo.nombre then
        estaEnArbol:= estaEnArbol(arbol^.menor, equipo)
    else
        estaEnArbol:= estaEnArbol(arbol^.mayor, equipo);
end;

procedure crearArbol(var arbol, lista: puntArbol; equipo: TEquipo);
begin
    if not estaEnArbol(arbol, equipo) then
        insertarOrdenadoArbol(arbol, lista, equipo);
end;

procedure cargarArbol(var arbol, lista: puntArbol; var arch: archivoEquipos);
var aux: TEquipo;
begin
    seek(arch, 0);
    
    while not eof(arch) do begin
        read(arch, aux);
        crearArbol(arbol, lista, aux);
    end;
end;

procedure imprimirArbol(arbol: puntArbol);
begin
    if arbol <> nil then begin
        imprimirArbol(arbol^.menor);
        writeln(arbol^.equipo.nombre, ' - ', arbol^.equipo.puntaje);
        imprimirArbol(arbol^.mayor);
    end;
end;

procedure imprimirLista(lista: puntArbol);
begin
    if lista <> nil then begin
        writeln(lista^.equipo.puntaje, '. ', lista^.equipo.nombre);
        imprimirLista(lista^.ordenPuntaje);
    end;
end;

var arch: archivoEquipos;
    arb_equipos, lista: puntArbol;
    aux: TEquipo;
begin
    arb_equipos:= nil;
    lista:= nil;
    
    assign(arch, '/work/lozano_recuperatorio2021');
    abrirArchivo(arch, arb_equipos);
    cargarArbol(arb_equipos, lista, arch);
    
    writeln('ARBOL ORIGINAL');
    imprimirArbol(arb_equipos);
    
    writeln;
    
    imprimirLista(lista);
    
    close(arch);
end.
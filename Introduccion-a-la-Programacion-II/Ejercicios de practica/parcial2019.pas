program parcial2019;

type
    puntArbol = ^TArbol;
    TArbol = record
        nro: integer;
        menor, mayor, sig_suma: puntArbol;
    end;

procedure crearNodoArbol(var nodo: puntArbol; nro: integer);
begin
    new(nodo);
    nodo^.nro:= nro;
    nodo^.menor:= nil;
    nodo^.mayor:= nil;
    nodo^.sig_suma:= nil;
end;

procedure insertarArbol(var arbol: puntArbol; nro: integer);
begin
    if arbol = nil then
        crearNodoArbol(arbol, nro)
    else begin
        if nro < arbol^.nro then
            insertarArbol(arbol^.menor, nro)
        else
            insertarArbol(arbol^.mayor, nro);
    end;
end;

procedure crearArbol(var arbol: puntArbol);
begin
    insertarArbol(arbol, 4);
    insertarArbol(arbol, 3);
    insertarArbol(arbol, 1);
    insertarArbol(arbol, 2);
    insertarArbol(arbol, 6);
    insertarArbol(arbol, 5);
    insertarArbol(arbol, 7);
end;

function sumaNroDescendientes(nodo: puntArbol): integer;
begin
    if nodo <> nil then begin
        sumaNroDescendientes:= nodo^.nro + sumaNroDescendientes(nodo^.menor) + sumaNroDescendientes(nodo^.mayor);
    end else
        sumaNroDescendientes:= 0;
end;

procedure insertarOrdenadoLista(var lista: puntArbol; arbol: puntArbol);
begin
    if (lista = nil) or ((sumaNroDescendientes(arbol) - arbol^.nro) < (sumaNroDescendientes(lista) - lista^.nro)) then begin
        arbol^.sig_suma:= lista;
        lista:= arbol;
    end else
        insertarOrdenadoLista(lista^.sig_suma, arbol);
end;

procedure crearLista(var arbol, lista: puntArbol; nivel, nivelActual: integer);
begin
    if (arbol <> nil) and (nivelActual <= nivel) then begin
        
        if nivelActual = nivel then
            insertarOrdenadoLista(lista, arbol);
        
        crearLista(arbol^.menor, lista, nivel, nivelActual + 1);
        crearLista(arbol^.mayor, lista, nivel, nivelActual + 1);
    end;
end;

procedure imprimirLista(lista: puntArbol);
begin
    if lista <> nil then begin
        writeln(lista^.nro);
        imprimirLista(lista^.sig_suma);
    end;
end;

var arbol_nros, arbol_suma: puntArbol;
    nivel: integer;
begin
    arbol_nros:= nil;
    arbol_suma:= nil;
    nivel:= 2;
    
    crearArbol(arbol_nros);
    
    crearLista(arbol_nros, arbol_suma, nivel, 1);
    imprimirLista(arbol_suma);
end.
program parcial2020;

const
    min = 0;
    max = 5;
    
type
    puntArbol = ^TArbol;
    TArbol = record
        num: integer;
        punt_ant, punt_pos, punt_lista: puntArbol;
    end;

procedure crearNodoArbol(var nodo: puntArbol; num: integer);
begin
    new(nodo);
    nodo^.num:= num;
    nodo^.punt_ant:= nil;
    nodo^.punt_pos:= nil;
    nodo^.punt_lista:= nil;
end;

procedure insertarOrdenadoArbol(var arbol: puntArbol; num: integer);
begin
    if arbol = nil then
        crearNodoArbol(arbol, num)
    else begin
        if num < arbol^.num then
            insertarOrdenadoArbol(arbol^.punt_ant, num)
        else
            insertarOrdenadoArbol(arbol^.punt_pos, num);
    end;
end;

procedure cargarArbol(var arbol: puntArbol);
begin
    insertarOrdenadoArbol(arbol, 4);
    insertarOrdenadoArbol(arbol, 3);
    insertarOrdenadoArbol(arbol, 1);
    insertarOrdenadoArbol(arbol, 2);
    insertarOrdenadoArbol(arbol, 6);
    insertarOrdenadoArbol(arbol, 8);
    insertarOrdenadoArbol(arbol, 9);
    insertarOrdenadoArbol(arbol, 7);
end;

function punteroAlNodo(arbol: puntArbol; num: integer): puntArbol;
begin
    if arbol = nil then
        punteroAlNodo:= nil
    else if num = arbol^.num then
        punteroAlNodo:= arbol
    else if num < arbol^.num then
        punteroAlNodo:= punteroAlNodo(arbol^.punt_ant, num)
    else
        punteroAlNodo:= punteroAlNodo(arbol^.punt_pos, num);
end;

procedure imprimirArbol(arbol: puntArbol);
begin
    if arbol <> nil then begin
        imprimirArbol(arbol^.punt_ant);
        writeln(arbol^.num);
        imprimirArbol(arbol^.punt_pos);
    end;
end;

function cantidadDescendientes(nodo: puntArbol): integer;
begin
    if nodo <> nil then
        cantidadDescendientes:= 1 + cantidadDescendientes(nodo^.punt_ant) + cantidadDescendientes(nodo^.punt_pos)
    else
        cantidadDescendientes:= 0;
end;

procedure insertarLista(var lista: puntArbol; arbol: puntArbol);
begin
    if (lista = nil) or ((cantidadDescendientes(arbol) - 1) < (cantidadDescendientes(lista) - 1)) then begin
        arbol^.punt_lista:= lista;
        lista:= arbol;
    end else
        insertarLista(lista^.punt_lista, arbol);
end;

procedure crearLista(var lista: puntArbol; arbol: puntArbol; nivel: integer);
begin
    if (arbol <> nil) and (nivel < max) then begin
        
        if nivel > min then
            insertarLista(lista, arbol);
            
        crearLista(lista, arbol^.punt_ant, nivel + 1);
        crearLista(lista, arbol^.punt_pos, nivel + 1);
    end;
end;

procedure imprimirLista(lista: puntArbol);
begin
    if lista <> nil then begin
        writeln(lista^.num);
        imprimirLista(lista^.punt_lista);
    end;
end;

var arbol, lista, cursor: puntArbol;
begin
    arbol:= nil;
    lista:= nil;
    
    cargarArbol(arbol);
    crearLista(lista, arbol, 0);
    //imprimirArbol(arbol);
    imprimirLista(arbol);
end.
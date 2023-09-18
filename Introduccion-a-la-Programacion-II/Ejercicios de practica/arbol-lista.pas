program arbolALista;

{ De un arbol, hacer una lista simple ordenada de mayor a menor }

type
    puntArbol = ^TArbol;
    TArbol = record
        num: integer;
        menor, mayor: puntArbol;
    end;
    
    puntLista = ^TLista;
    TLista = record
        num: integer;
        sig: puntLista;
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

procedure cargarArbol(var arbol: puntArbol);
begin
    insertarOrdenado(arbol, 1);
    insertarOrdenado(arbol, 2);
    insertarOrdenado(arbol, 3);
    insertarOrdenado(arbol, 5);
    insertarOrdenado(arbol, 4);
end;

procedure crearNodoLista(var nodoInsertar: puntLista; num: integer);
begin
    new(nodoInsertar);
    nodoInsertar^.num:= num;
    nodoInsertar^.sig:= nil;
end;

procedure insertarOrdenadoLista(nodoInsertar: puntLista; var lista: puntLista);
begin
    if (lista = nil) or (nodoInsertar^.num > lista^.num) then begin
        nodoInsertar^.sig:= lista;
        lista:= nodoInsertar;
    end else
        insertarOrdenadoLista(nodoInsertar, lista^.sig);
end;

procedure cargarLista(arbol: puntArbol; var lista: puntLista);
var nodoInsertar: puntLista;
begin
    if arbol <> nil then begin
    
        crearNodoLista(nodoInsertar, arbol^.num);
        insertarOrdenadoLista(nodoInsertar, lista);
    
        cargarLista(arbol^.menor, lista);
        cargarLista(arbol^.mayor, lista);
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

procedure imprimirLista(lista: puntLista);
begin
    if lista <> nil then begin
        writeln(lista^.num);
        imprimirLista(lista^.sig);
    end;
end;

// Programa principal
var arbol: puntArbol;
    lista: puntLista;
begin
    arbol:= nil;
    lista:= nil;
    
    cargarArbol(arbol);
    cargarLista(arbol, lista);
    imprimirArbol(arbol);
    
    writeln;
    
    imprimirLista(lista);
end.
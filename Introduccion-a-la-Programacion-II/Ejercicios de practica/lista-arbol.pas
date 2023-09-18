program listaAArbol;

{ De una lista, hacer un arbol de menor a mayor }

type
    puntLista = ^TLista;
    TLista = record
        num: integer;
        sig: puntLista;
    end;
    
    puntArbol = ^TArbol;
    TArbol = record
        num: integer;
        menor, mayor: puntArbol;
    end;
    
procedure crearNodoLista(var lista: puntLista; num: integer);
begin
    new(lista);
    lista^.num:= num;
    lista^.sig:= nil;
end;

procedure insertarLista(var lista: puntLista; num: integer);
begin
    if lista = nil then
        crearNodoLista(lista, num)
    else
        insertarLista(lista^.sig, num);
end;

procedure cargarLista(var lista: puntLista);
begin
    insertarLista(lista, 9);
    insertarLista(lista, 7);
    insertarLista(lista, 10);
    insertarLista(lista, 5);
    insertarLista(lista, 3);
end;

procedure crearNodoArbol(var arbol: puntArbol; num: integer);
begin
    new(arbol);
    arbol^.num:= num;
    arbol^.menor:= nil;
    arbol^.mayor:= nil;
end;

procedure insertarOrdenadoArbol(var arbol: puntArbol; num: integer);
begin
    if arbol = nil then
        crearNodoArbol(arbol, num)
    else begin
        if num < arbol^.num then
            insertarOrdenadoArbol(arbol^.menor, num)
        else
            insertarOrdenadoArbol(arbol^.mayor, num);
    end;
end;

procedure cargarArbol(var arbol: puntArbol; lista: puntLista);
begin
    if lista <> nil then begin
        insertarOrdenadoArbol(arbol, lista^.num);
        cargarArbol(arbol, lista^.sig);
    end;
end;

procedure imprimirLista(lista: puntLista);
begin
    if lista <> nil then begin
        writeln(lista^.num);
        imprimirLista(lista^.sig);
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
var lista: puntLista;
    arbol: puntArbol;
begin
    lista:= nil;
    arbol:= nil;
    
    cargarLista(lista);
    imprimirLista(lista);
    
    writeln;
    
    cargarArbol(arbol, lista);
    imprimirArbol(arbol);
end.
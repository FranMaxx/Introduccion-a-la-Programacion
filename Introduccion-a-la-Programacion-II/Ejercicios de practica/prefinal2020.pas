program prefinal2020;

const
    min = 1;
    max = 10;
    
type
    puntArbol = ^TArbol;
    TArbol = record
        dato, clave: integer;
        menor, mayor: puntArbol;
    end;
    
    puntLista = ^TLista;
    TLista = record
        clave: integer;
        ant, sig: puntLista;
    end;

// -- Pre configuracion -- //
procedure crearNodoArbol(var nodo: puntArbol; dato, clave: integer);
begin
    new(nodo);
    nodo^.dato:= dato;
    nodo^.clave:= clave;
    nodo^.menor:= nil;
    nodo^.mayor:= nil;
end;

procedure insertarArbolOrdenado(var arbol: puntArbol; dato, clave: integer);
begin
    if arbol = nil then
        crearNodoArbol(arbol, dato, clave)
    else begin
        if dato < arbol^.dato then
            insertarArbolOrdenado(arbol^.menor, dato, clave)
        else
            insertarArbolOrdenado(arbol^.mayor, dato, clave);
    end;
end;

procedure cargarArbol(var arbol: puntArbol);
begin
    insertarArbolOrdenado(arbol, 4, 100);
    insertarArbolOrdenado(arbol, 3, 101);
    insertarArbolOrdenado(arbol, 2, 103);
    insertarArbolOrdenado(arbol, 1, 102);
    insertarArbolOrdenado(arbol, 5, 104);
end;

{procedure imprimirArbol(arbol: puntArbol);
begin
    if arbol <> nil then begin
        imprimirArbol(arbol^.menor);
        writeln(arbol^.dato);
        imprimirArbol(arbol^.mayor);
    end;
end;}

// -- Problema principal -- //
procedure crearNodoLista(var nodo: puntLista; arbol: puntArbol);
begin
    new(nodo);
    nodo^.clave:= arbol^.clave;
    nodo^.ant:= nil;
    nodo^.sig:= nil;
end;

procedure insertarListaDoble(var lista: puntLista; nodo: puntLista);
begin
    if (lista = nil) or (nodo^.clave < lista^.clave) then begin
        nodo^.sig:= lista;
        
        if lista <> nil then begin
            nodo^.ant:= lista^.ant;
            lista^.ant:= nodo;
        end;
        
        lista:= nodo;
    end else if lista^.sig = nil then begin
        lista^.sig:= nodo;
        nodo^.ant:= lista;
    end else
        insertarListaDoble(lista^.sig, nodo);
end;

function cantidadDescendientes(nodo: puntArbol): integer;
begin
    if nodo <> nil then
        cantidadDescendientes:= 1 + cantidadDescendientes(nodo^.menor) + cantidadDescendientes(nodo^.mayor)
    else
        cantidadDescendientes:= 0;
end;

procedure crearListaDoble(var lista: puntLista; arbol: puntArbol);
var nodoLista: puntLista;
begin
    if arbol <> nil then begin
        if (arbol^.dato >= min) and (arbol^.dato <= max) and (cantidadDescendientes(arbol^.menor) > cantidadDescendientes(arbol^.mayor)) then begin
            crearNodoLista(nodoLista, arbol);
            insertarListaDoble(lista, nodoLista);
            
            crearListaDoble(lista, arbol^.menor);
            crearListaDoble(lista, arbol^.mayor);
        end else if arbol^.dato < min  then
            crearListaDoble(lista, arbol^.mayor)
        else
            crearListaDoble(lista, arbol^.menor);
    end;
end;

procedure imprimirLista(lista: puntLista);
begin
    if lista <> nil then begin
        writeln(lista^.clave);
        imprimirLista(lista^.sig);
    end;
end;

var valores: puntArbol;
    lista_cla: puntLista;
begin
    cargarArbol(valores);
    //imprimirArbol(valores);
    
    crearListaDoble(lista_cla, valores);
    imprimirLista(lista_cla);
end.
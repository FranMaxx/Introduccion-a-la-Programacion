program parcial2022;

const
    nivelMax = 10;
    
type
    TFecha = record
        dia: 1..31;
        mes: 1..12;
        anio: 1900..2022;
    end;
    
    puntArbol = ^TArbol;
    TArbol = record
        fecha: TFecha;
        id_proveedor: integer;
        monto: real;
        menor, mayor: puntArbol;
    end;
    
    puntListaSimple = ^TListaSimple;
    TListaSimple = record
        id_proveedor: integer;
        monto: real;
        sig: puntListaSimple;
    end;
    
    puntLista = ^TLista;
    TLista = record
        fecha: TFecha;
        ant, sig: puntLista;
        compras: puntListaSimple;
    end;
    
// -- Preconfig -- //

procedure crearNodoArbol(var arbol: puntArbol; dia, mes, anio, id: integer; monto: real);
begin
    new(arbol);
    arbol^.fecha.dia:= dia;
    arbol^.fecha.mes:= mes;
    arbol^.fecha.anio:= anio;
    arbol^.id_proveedor:= id;
    arbol^.monto:= monto;
    arbol^.menor:= nil;
    arbol^.mayor:= nil;
end;

procedure insertarArbol(var arbol: puntArbol; dia, mes, anio, id: integer; monto: real);
begin
    if arbol = nil then
        crearNodoArbol(arbol, dia, mes, anio, id, monto)
    else begin
        if id < arbol^.id_proveedor then
            insertarArbol(arbol^.menor, dia, mes, anio, id, monto)
        else
            insertarArbol(arbol^.mayor, dia, mes, anio, id, monto);
    end;
end;

procedure cargarArbol(var arbol: puntArbol);
begin
    insertarArbol(arbol, 9, 3, 2000, 5, 100);
    insertarArbol(arbol, 9, 3, 2000, -5, 100);
    insertarArbol(arbol, 5, 6, 2001, 3, 500);
    insertarArbol(arbol, 5, 6, 2001, -3, 500);
    insertarArbol(arbol, 24, 7, 2013, 7, 250);
    insertarArbol(arbol, 24, 7, 2013, -7, 250);
    insertarArbol(arbol, 31, 2, 1999, 2, 120);
    insertarArbol(arbol, 31, 2, 1999, -2, 120);
    insertarArbol(arbol, 1, 1, 1998, 2, 120);
    insertarArbol(arbol, 1, 1, 1998, -2, 120);
    insertarArbol(arbol, 8, 10, 1972, 4, 400);
    insertarArbol(arbol, 8, 10, 1972, -4, 400);
end;

{procedure imprimirArbol(arbol: puntArbol);
begin
    if arbol <> nil then begin
        imprimirArbol(arbol^.menor);
        writeln(arbol^.id_proveedor);
        imprimirArbol(arbol^.mayor);
    end;
end;}

// -- Problema parcial -- //
procedure crearNodoListaDoble(var nodo: puntLista; arbol: puntArbol);
begin
    new(nodo);
    nodo^.fecha.dia:= arbol^.fecha.dia;
    nodo^.fecha.mes:= arbol^.fecha.mes;
    nodo^.fecha.anio:= arbol^.fecha.anio;
    nodo^.ant:= nil;
    nodo^.sig:= nil;
    nodo^.compras:= nil;
end;

procedure crearNodoListaSimple(var nodo: puntListaSimple; arbol: puntArbol);
begin
    new(nodo);
    nodo^.id_proveedor:= arbol^.id_proveedor;
    nodo^.monto:= arbol^.monto;
    nodo^.sig:= nil;
end;

function punteroAlNodo(arbol: puntArbol; lista: puntLista): puntLista;
begin
    if lista = nil then
        punteroAlNodo:= nil
    else if arbol^.fecha.anio = lista^.fecha.anio then
        punteroAlNodo:= lista
    else
        punteroAlNodo:= punteroAlNodo(arbol, lista^.sig);
end;

procedure insertarListaDoble(var lista: puntLista; nodoInsertar: puntLista);
begin
    if (lista = nil) or (nodoInsertar^.fecha.anio < lista^.fecha.anio) then begin
    
        // Primer caso
        nodoInsertar^.sig:= lista;
        
        // Segundo caso
        if lista <> nil then begin
            nodoInsertar^.ant:= lista^.ant;
            lista^.ant:= nodoInsertar;
        end;
        
        lista:= nodoInsertar; // Primer caso
        
    end else if lista^.sig = nil then begin // Tercer caso
        lista^.sig:= nodoInsertar;
        nodoInsertar^.ant:= lista;
    end else
        insertarListaDoble(lista^.sig, nodoInsertar);
end;

procedure insertarComprasOrdenado(nodito: puntListaSimple; var compras: puntListaSimple);
begin
    if (compras = nil) or (nodito^.id_proveedor < compras^.id_proveedor) then begin
        nodito^.sig:= compras;
        compras:= nodito;
    end else
        insertarComprasOrdenado(nodito, compras^.sig);
end;

procedure insertarOrdenadoLista(arbol: puntArbol; var lista: puntLista);
var nodoInsertar, cursor: puntLista;
    nodoInsertarSimple: puntListaSimple;
begin
    cursor:= punteroAlNodo(arbol, lista);
    crearNodoListaSimple(nodoInsertarSimple, arbol);
    
    if cursor <> nil then
        insertarComprasOrdenado(nodoInsertarSimple, cursor^.compras)
    else begin
        crearNodoListaDoble(nodoInsertar, arbol);
        insertarListaDoble(lista, nodoInsertar);
        insertarComprasOrdenado(nodoInsertarSimple, nodoInsertar^.compras)
    end;
end;


procedure crearListaDeListas(arbol: puntArbol; var lista: puntLista; nivel: integer);
begin
    if (arbol <> nil) and (nivel <= nivelMax) then begin
        insertarOrdenadoLista(arbol, lista);
        crearListaDeListas(arbol^.menor, lista, nivel + 1);
        crearListaDeListas(arbol^.mayor, lista, nivel + 1);
    end;
end;

procedure imprimirLista(lista: puntLista);
begin
    if lista <> nil then begin
        writeln(lista^.fecha.anio, ' = ', lista^.compras^.id_proveedor, ' & ', lista^.compras^.sig^.id_proveedor);
        imprimirLista(lista^.sig);
    end;
end;

var arbol: puntArbol;
    lista: puntLista;
begin
    cargarArbol(arbol);
    // imprimirArbol(arbol);
    
    crearListaDeListas(arbol, lista, 1);
    imprimirLista(lista);
end.
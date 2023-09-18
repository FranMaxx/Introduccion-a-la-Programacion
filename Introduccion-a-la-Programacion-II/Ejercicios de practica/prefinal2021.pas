program prefinal2021;

// Falta agregar el monto mas alto de cada nodo

const
    nroMin = 5;
    nroMax = 6;
    
type
    puntArbol = ^TArbol;
    TArbol = record
        nro_cliente: integer;
        nro_factura: integer;
        monto: real;
        menor, mayor: puntArbol;
    end;
    
    puntLista = ^TLista;
    TLista = record
        nro_cliente: integer;
        monto: real;
        ant, sig: puntLista;
    end;

// --- Pre config --- //
procedure crearNodoArbol(var nodo: puntArbol; cliente, factura: integer; monto: real);
begin
    new(nodo);
    nodo^.nro_cliente:= cliente;
    nodo^.nro_factura:= factura;
    nodo^.monto:= monto;
    nodo^.menor:= nil;
    nodo^.mayor:= nil;
end;

procedure insertarOrdenadoArbol(var arbol: puntArbol; cliente, factura: integer; monto: real);
begin
    if arbol = nil then
        crearNodoArbol(arbol, cliente, factura, monto)
    else begin
        if cliente < arbol^.nro_cliente then
            insertarOrdenadoArbol(arbol^.menor, cliente, factura, monto)
        else
            insertarOrdenadoArbol(arbol^.mayor, cliente, factura, monto);
    end;
end;

procedure cargarArbol(var arbol: puntArbol);
begin
    insertarOrdenadoArbol(arbol, 6, 10, 500);
    insertarOrdenadoArbol(arbol, 3, 12, 1300);
    insertarOrdenadoArbol(arbol, 2, 14, 750);
    insertarOrdenadoArbol(arbol, 5, 15, 220);
    insertarOrdenadoArbol(arbol, 7, 16, 580);
    insertarOrdenadoArbol(arbol, 9, 19, 310);
end;

procedure imprimirArbol(arbol: puntArbol);
begin
    if arbol <> nil then begin
        imprimirArbol(arbol^.menor);
        writeln(arbol^.nro_cliente);
        imprimirArbol(arbol^.mayor);
    end;
end;

// --- Problema --- //
procedure crearNodoLista(var nodo: puntLista; arbol: puntArbol);
begin
    new(nodo);
    nodo^.nro_cliente:= arbol^.nro_cliente;
    nodo^.monto:= arbol^.monto;
    nodo^.sig:= nil;
    nodo^.ant:= nil;
end;

procedure insertarOrdenadoLista(var lista: puntLista; nodoInsertar: puntLista);
begin
    if (lista = nil) or (nodoInsertar^.monto < lista^.monto) then begin
        nodoInsertar^.sig:= lista;
        
        if lista <> nil then begin
            nodoInsertar^.ant:= lista^.ant;
            lista^.ant:= nodoInsertar;
        end;
        
        lista:= nodoInsertar;
    end else if lista^.sig = nil then begin
        lista^.sig:= nodoInsertar;
        nodoInsertar^.ant:= lista;
    end else
        insertarOrdenadoLista(lista^.sig, nodoInsertar);
end;

procedure crearListaDoble(var lista: puntLista; arbol: puntArbol);
var nodoInsertar: puntLista;
begin
    if arbol <> nil then begin
        if (arbol^.nro_cliente < nroMin) or (arbol^.nro_cliente > nroMax) then begin
            crearNodoLista(nodoInsertar, arbol);
            insertarOrdenadoLista(lista, nodoInsertar);
        end;
        
        crearListaDoble(lista, arbol^.menor);
        crearListaDoble(lista, arbol^.mayor);
    end;
end;

procedure imprimirLista(lista: puntLista);
begin
    if lista <> nil then begin
        writeln(lista^.nro_cliente, ' - ', lista^.monto);
        imprimirLista(lista^.sig);
    end;
end;

var arbol_facturas: puntArbol;
    monto_cliente: puntLista;
begin
    arbol_facturas:= nil;
    monto_cliente:= nil;
    
    cargarArbol(arbol_facturas);
    
    crearListaDoble(monto_cliente, arbol_facturas);
    imprimirLista(monto_cliente);
end.
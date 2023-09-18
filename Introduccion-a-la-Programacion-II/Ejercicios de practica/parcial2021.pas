program parcial2021;

const
    art_min = 1;
    art_max = 10;
    prof_maxima = 10;

type
    puntArbol = ^TArbol;
    TArbol = record
        nro_articulo: integer;
        anio_fabricacion: 1970..2025;
        menor, mayor: puntArbol;
    end;
    
    puntLista = ^TLista;
    TLista = record
        cant_articulos: integer;
        anio_fabricacion: 1970..2025;
        ant, sig: puntLista;
    end;

// --- Preconfiguracion --- //
procedure crearNodo(var arbol: puntArbol; nro_articulo, anio_fabricacion: integer);
begin
    new(arbol);
    arbol^.nro_articulo:= nro_articulo;
    arbol^.anio_fabricacion:= anio_fabricacion;
    arbol^.menor:= nil;
    arbol^.mayor:= nil;
end;

procedure insertarOrdenadoArbol(var arbol: puntArbol; nro_articulo, anio_fabricacion: integer);
begin
    if arbol = nil then
        crearNodo(arbol, nro_articulo, anio_fabricacion)
    else begin
        if nro_articulo < arbol^.nro_articulo then
            insertarOrdenadoArbol(arbol^.menor, nro_articulo, anio_fabricacion)
        else
            insertarOrdenadoArbol(arbol^.mayor, nro_articulo, anio_fabricacion);
    end;
end;

procedure cargarArbol(var arbol: puntArbol);
begin
    insertarOrdenadoArbol(arbol, 4, 2000);
    insertarOrdenadoArbol(arbol, 1, 2004);
    insertarOrdenadoArbol(arbol, 2, 2006);
    insertarOrdenadoArbol(arbol, 6, 2005);
    insertarOrdenadoArbol(arbol, 5, 2005);
end;

procedure imprimirArbol(arbol: puntArbol);
begin
    if arbol <> nil then begin
        imprimirArbol(arbol^.menor);
        writeln(arbol^.nro_articulo);
        imprimirArbol(arbol^.mayor);
    end;
end;

// --- Problema principal --- //
procedure crearNodoLista(var nodo: puntLista; arbol: puntArbol);
begin
    new(nodo);
    nodo^.cant_articulos:= 1;
    nodo^.anio_fabricacion:= arbol^.anio_fabricacion;
    nodo^.ant:= nil;
    nodo^.sig:= nil;
end;

function puntAlNodo(lista: puntLista; arbol: puntArbol): puntLista;
begin
    if lista = nil then
        puntAlNodo:= nil
    else if lista^.anio_fabricacion = arbol^.anio_fabricacion then
        puntAlNodo:= lista
    else
        puntAlNodo:= puntAlNodo(lista^.sig, arbol);
end;

procedure insertarNodoLista(var lista: puntLista; nodo: puntLista);
begin
    if (lista = nil) or (nodo^.cant_articulos < lista^.cant_articulos) then begin
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
        insertarNodoLista(lista^.sig, nodo);
end;

// Falta procedimiento modificarYOrdenar (es lo unico que falta)

procedure insertarListaDoble(var lista: puntLista; arbol: puntArbol);
var nodoLista, cursor: puntLista;
begin
    cursor:= puntAlNodo(lista, arbol);
    
    if cursor <> nil then begin
        // modificarYOrdenar(lista, cursor);
    end else begin
        crearNodoLista(nodoLista, arbol);
        insertarNodoLista(lista, nodoLista);
    end;
end;

procedure generarListaDoble(var lista: puntLista; arbol: puntArbol; nivel: integer);
begin
    if (arbol <> nil) and (nivel <= prof_maxima) then begin
        if (arbol^.nro_articulo >= art_min) and (arbol^.nro_articulo <= art_max) then begin
            insertarListaDoble(lista, arbol);
            generarListaDoble(lista, arbol^.menor, nivel + 1);
            generarListaDoble(lista, arbol^.mayor, nivel + 1);
        end else if art_min < arbol^.nro_articulo then begin
            generarListaDoble(lista, arbol^.menor, nivel + 1);
        end else
            generarListaDoble(lista, arbol^.mayor, nivel + 1);
    end;
end;

procedure imprimirLista(lista: puntLista);
begin
    if lista <> nil then begin
        writeln(lista^.anio_fabricacion, ', ', lista^.cant_articulos);
        imprimirLista(lista^.sig);
    end;
end;

var arbol: puntArbol;
    lista: puntLista;
begin
    arbol:= nil;
    lista:= nil;
    
    cargarArbol(arbol);
    //imprimirArbol(arbol);
    
    generarListaDoble(lista, arbol, 1);
    imprimirLista(lista);
end.
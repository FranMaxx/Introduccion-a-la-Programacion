// -- SIN TERMINAR -- //

program ejercicio3;

{ a)Codifique un módulo que inserte un número entero en una lista ordenada ascendentemente
conservando el orden. 

  b) Para la solución del ejercicio a), indique para cada uno de los casos
especificados, el resultado final esperado de la ejecución (estado de la lista) y el resultado real
(obtenido del seguimiento del código con el ejemplo de datos dado)

    lista: 8 10 (nro. a insertar: 9)
    lista: 8 10 (nro. a insertar: 16)
    lista: 8 10 (nro. a insertar: 3)
    lista: 8 10 (nro. a insertar: 8)
    lista: nil (nro. a insertar: 8) 
}

type
    punt = ^nodo;
    nodo = record
        num: integer;
        sig: punt;
    end;

procedure instanciarLista(var lista, cursor: punt);
begin
    new(lista);
    cursor:= lista;
end;

procedure crearNodo(var cursor: punt);
begin
    new(cursor^.sig);
    cursor:= cursor^.sig;
end;


procedure cargarLista(var lista: punt);
var cursor: punt;
begin
    instanciarLista(lista, cursor);
        
    cursor^.num:= 8;
    cursor^.sig:= nil;
    
    crearNodo(cursor);
    cursor^.num:= 10;
    cursor^.sig:= nil;
end;

procedure insertarNumero(var lista: punt; num: integer);
var cursor: punt;
begin
    cursor:= lista^.sig;
    crearNodo(cursor);
    
    cursor^.num:= num;
    cursor^.sig:= nil;
end;

procedure imprimirLista(lista: punt);
begin
    write('Resultado obtenido: ');
    while lista <> nil do begin
        write(lista^.num, ' ');
        lista:= lista^.sig;
    end;
end;

// Programa principal
var lista1: punt;
    lista2: punt;
begin
    lista1:= nil;
    lista2:= nil;
    
    cargarLista(lista1);
    writeln('Resultado esperado: 8 9 10');
    insertarNumero(lista1, 9);
    imprimirLista(lista1);
end.
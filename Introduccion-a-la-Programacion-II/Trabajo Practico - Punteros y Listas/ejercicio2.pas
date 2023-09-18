program ejercicio2;
 
{ Realice todos los procedimientos y funciones necesarios para realizar las siguientes tareas:
    a) Dado como parámetro un arreglo de enteros de longitud N, crear una lista vinculada con
    todos los elementos del arreglo
    b) Retornar la suma de los elementos de la lista vinculada.
    c) Retornar la cantidad de elementos de la lista
    d) Retornar el promedio de los elementos de la lista vinculada
    e) Retornar el máximo elemento de la lista vinculada.
}

const
    max = 10;

type
    arrType = array [1..max] of integer;
    punt = ^nodo;
    nodo = record
        num: integer;
        sig: punt;
    end;

procedure cargarArreglo(var arr: arrType);
var i: integer;
begin
    for i:= 1 to max do
        arr[i]:= random(5) + 1
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

procedure cargarListaVinculada(var lista: punt; arr: arrType);
var cursor: punt;
    i: integer;
begin
    for i:= 1 to max - 1 do begin
        if lista = nil then
            instanciarLista(lista, cursor)
        else
            crearNodo(cursor);
            
        cursor^.num:= arr[i];
        cursor^.sig:= nil;
    end;
    
    cursor^.num:= arr[max];
    cursor^.sig:= nil;
end;

function sumaElementos(lista: punt): integer;
begin
    while lista <> nil do begin
        sumaElementos += lista^.num;
        lista:= lista^.sig;
    end;
end;

function cantidadElementos(): integer;
begin
    cantidadElementos:= max;
end;

function maximoElemento(lista: punt): integer;
var aux: integer;
begin
    aux:= 0;
    
    while lista <> nil do begin
        if lista^.num > aux then
            aux:= lista^.num;
        lista:= lista^.sig;
    end;
    
    maximoElemento:= aux;
end;

procedure imprimirLista(lista: punt);
begin
    writeln('Contenido de la lista');
    while lista <> nil do begin
        writeln(lista^.num);
        lista:= lista^.sig;
    end;
end;

// Programa principal
var lista: punt;
    arr: arrType;
begin
    randomize;
    
    lista:= nil;
    
    cargarArreglo(arr);
    cargarListaVinculada(lista, arr);
    imprimirLista(lista);
    
    writeln;
    writeln('Suma: ', sumaElementos(lista));
    writeln('Cantidad: ', cantidadElementos());
    writeln('Promedio: ', sumaElementos(lista) div cantidadElementos());
    writeln('Maximo: ', maximoElemento(lista));
end.
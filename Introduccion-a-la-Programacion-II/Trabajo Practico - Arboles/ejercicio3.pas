program ejercicio3;

{ Se tiene un árbol binario cuyos nodos contienen el Nro. Alumno y DNI de los alumnos de
Intro II. El árbol está ordenado por DNI. Se pide: a) Hacer un procedimiento/función que dado
un DNI retorne el Nro. de Alumno asociado b)Hacer un procedimiento/función que dado un
Nro. de Alumno retorne el DNI asociado }

type
    punt = ^nodoArbol;
    nodoArbol = record
        nro: integer;
        dni: integer;
        menor, mayor: punt;
    end;

procedure crearNodo(var arbol: punt; nro, dni: integer);
begin
    new(arbol);
    arbol^.nro:= nro;
    arbol^.dni:= dni;
    arbol^.menor:= nil;
    arbol^.mayor:= nil;
end;

procedure insertarValores(var arbol: punt; nro, dni: integer);
begin
    if arbol = nil then
        crearNodo(arbol, nro, dni)
    else begin
        if dni < arbol^.dni then
            insertarValores(arbol^.menor, nro, dni)
        else
            insertarValores(arbol^.mayor, nro, dni);
    end;
end;

procedure cargarArbol(var arbol: punt);
begin
    insertarValores(arbol, 1, 1000);
    insertarValores(arbol, 3, 1002);
    insertarValores(arbol, 2, 1001);
end;

function buscarNro(arbol: punt; dni: integer): punt;
begin
    if arbol = nil then
        buscarNro:= nil
    else if arbol^.dni = dni then
        buscarNro:= arbol
    else if dni < arbol^.dni then
        buscarNro:= buscarNro(arbol^.menor, dni)
    else
        buscarNro:= buscarNro(arbol^.mayor, dni);
end;

function buscarDni(arbol: punt; nro: integer): punt;
begin
    if arbol = nil then
        buscarDni:= nil
    else if arbol^.nro = nro then
        buscarDni:= arbol
    else if nro < arbol^.nro then
        buscarDni:= buscarDni(arbol^.menor, nro)
    else
        buscarDni:= buscarDni(arbol^.mayor, nro);
end;

var arbol: punt;
begin
    arbol:= nil;
    
    cargarArbol(arbol);
    writeln('Nro. de Alumno: ', buscarNro(arbol, 1000)^.nro);
    writeln('Dni: ', buscarDni(arbol, 1)^.dni);
end.
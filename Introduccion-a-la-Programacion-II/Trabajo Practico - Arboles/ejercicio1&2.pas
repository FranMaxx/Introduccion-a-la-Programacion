program ejercicio1y2;

{ Se tiene un archivo desordenado con números enteros. Se pretende que realice un
procedimiento que lea todos los números del archivo y genere un árbol ordenado en forma
ascendente }

{ Hacer un procedimiento que imprima los números del árbol del ejercicio 1: a)en orden
ascendente(in-order). b) en orden descendente(in-order) c) imprimir de tal forma que no se
imprima un padre si no se han impreso todos sus hijos (post-order). d) imprimir los números
del árbol anterior de tal forma que no se imprima un nodo si no se ha impreso su padre
(pre-order) }

type
    punt = ^nodoArbol;
    nodoArbol = record
        nro: integer;
        mayor, menor: punt;
    end;
    
    archivo = file of integer;

procedure crearArchivo(var arch: archivo);
begin
    rewrite(arch);
    write(arch, 4);
    write(arch, 3);
    write(arch, 7);
    write(arch, 1);
    write(arch, 9);
    write(arch, 2);
    write(arch, 6);
    close(arch);
end;

procedure crearNodo(num: integer; var arbol: punt);
begin
    new(arbol);
    arbol^.nro:= num;
    arbol^.mayor:= nil;
    arbol^.menor:= nil;
end;

procedure insertar(num: integer; var arbol: punt);
begin
    if arbol = nil then
        crearNodo(num, arbol)
    else begin
        if num < arbol^.nro then
            insertar(num, arbol^.menor)
        else
            insertar(num, arbol^.mayor);
    end;
end;

procedure leerArchivo(var arch: archivo; var arbol: punt);
var num: integer;
begin
    reset(arch);
    
    while not eof(arch) do begin
        read(arch, num);
        insertar(num, arbol);
    end;
    
    close(arch);
end;

procedure imprimirInOrderAscendente(arbol: punt);
begin
    if arbol <> nil then begin
        imprimirInOrderAscendente(arbol^.menor);
        writeln(arbol^.nro);
        imprimirInOrderAscendente(arbol^.mayor);
    end;
end;

procedure imprimirInOrderDescendente(arbol: punt);
begin
    if arbol <> nil then begin
        imprimirInOrderDescendente(arbol^.mayor);
        writeln(arbol^.nro);
        imprimirInOrderDescendente(arbol^.menor);
    end;
end;

procedure imprimirPostOrder(arbol: punt);
begin
    if arbol <> nil then begin
        imprimirPostOrder(arbol^.menor);
        imprimirPostOrder(arbol^.mayor);
        writeln(arbol^.nro);
    end;
end;

procedure imprimirPreOrder(arbol: punt);
begin
    if arbol <> nil then begin
        writeln(arbol^.nro);
        imprimirPreOrder(arbol^.menor);
        imprimirPreOrder(arbol^.mayor);
    end; 
end;

var arbol: punt;
    arch: archivo;
begin
    assign(arch, '/work/lozano_ejercicio1Arboles');
    arbol:= nil;
    
    crearArchivo(arch);
    leerArchivo(arch, arbol);
    
    writeln('IN ORDER ASCENDENTE');
    imprimirInOrderAscendente(arbol);
    writeln;
    
    writeln('IN ORDER DESCENDENTE');
    imprimirInOrderDescendente(arbol);
    writeln;
    
    writeln('POST ORDER');
    imprimirPostOrder(arbol);
    writeln;
    
    writeln('PRE ORDER');
    imprimirPreOrder(arbol);
    writeln;
end.
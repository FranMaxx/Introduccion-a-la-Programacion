program ejercicio4;

{ Realice un procedimiento que dado un número lo busque en el árbol ordenado y lo borre si
existe. Tenga en cuenta que dicho número se puede encontrar como una hoja del árbol (sin
hijos que cuelguen de él) o como nodo interno con otros nodos colgando de él.
Si el nodo a eliminar (B) es interno y tiene las dos subramas no vacías se utiliza la estrategia
de reemplazo por el Nodo más Derecho (C) del Subárbol Izquierdo. }

type
    punt = ^nodoArbol;
    nodoArbol = record
        num: integer;
        HI: punt;
        HD: punt;
    end;

    archivo = file of integer;

procedure crearNodo(var arbol: punt; num: integer);
begin
    new(arbol);
    arbol^.num:= num;
    arbol^.HI:= nil;
    arbol^.HD:= nil;
end;

procedure insertar(var arbol: punt; num: integer);
begin
    if arbol = nil then
        crearNodo(arbol, num)
    else begin
        if num < arbol^.num then
            insertar(arbol^.HI, num)
        else
            insertar(arbol^.HD, num);
    end;
end;

procedure cargarArbol(var arbol: punt);
begin
    insertar(arbol, 15);
    insertar(arbol, 9);
    insertar(arbol, 6);
    insertar(arbol, 14);
    insertar(arbol, 13);
    insertar(arbol, 20);
    insertar(arbol, 17);
    insertar(arbol, 64);
    insertar(arbol, 26);
    insertar(arbol, 72);
end;

function existe(arbol: punt; num: integer): boolean;
begin
    if arbol = nil then
        existe:= false
    else begin
        if arbol^.num = num then
            existe:= true
        else begin
            if num < arbol^.num then
                existe:= existe(arbol^.HI, num)
            else
                existe:= existe(arbol^.HD, num);
        end;
    end;
end;

function punteroAlNodo(arbol: punt; num: integer): punt;
begin
    if arbol = nil then
        punteroAlNodo:= nil
    else if num = arbol^.num then
        punteroAlNodo:= arbol
    else if num < arbol^.num then
        punteroAlNodo:= punteroAlNodo(arbol^.HI, num)
    else
        punteroAlNodo:= punteroAlNodo(arbol^.HD, num);
end;

// Opcion 1
procedure borrarNodoHoja(var arbol, cursor: punt);
begin
    // Contenido
end;

// Imprimir arbol
procedure imprimirInOrder(arbol: punt);
begin
    if arbol <> nil then begin
        imprimirInOrder(arbol^.HI);
        writeln(arbol^.num);
        imprimirInOrder(arbol^.HD);
    end;
end;

var arbol, cursor: punt;
    num: integer;
begin
    arbol:= nil;
    num:= 72;
    
    cargarArbol(arbol);
    
    if existe(arbol, num) then begin
        cursor:= punteroAlNodo(arbol, num);
        
        if (cursor^.HI = nil) and (cursor^.HD = nil) then begin
            // Opcion 1
            //...
        end else if cursor^.HI = nil then begin
        
            // Opcion 2
            // ...
        end else if cursor^.HD = nil then begin
            // Opcion 2
            // ...
        end else begin
            // Opcion 3
            // ...;
        end;
    end else
        writeln('Lo siento, no existe ese numero');
end.

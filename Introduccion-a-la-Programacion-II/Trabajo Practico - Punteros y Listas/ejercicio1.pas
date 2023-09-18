program ejercicio1;

{ Codifique un módulo que cargue por teclado N caracteres en una lista (uno por nodo). El fin de
la carga se detecta cuando el usuario ingresa el carácter “*” }

const
    asterisco = '*';

type
    punt = ^nodo;
    nodo = record
        letra: char;
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
    elemento: char;
begin
    writeln('Ingrese un caracter distinto de ', asterisco);
    readln(elemento);
    
    while elemento <> asterisco do begin
        
        if lista = nil then
            instanciarLista(lista, cursor)
        else 
            crearNodo(cursor);
            
        cursor^.letra:= elemento;
        cursor^.sig:= nil;
        readln(elemento);
        
    end;
end;

procedure imprimirLista(lista: punt);
begin
    writeln;
    writeln('Contenido de la lista');
    
    while lista <> nil do begin
        writeln(lista^.letra);
        lista:= lista^.sig;
    end;
end;

// Programa principal
var lista: punt;
begin
    lista:= nil;
    
    cargarLista(lista);
    imprimirLista(lista);
end.
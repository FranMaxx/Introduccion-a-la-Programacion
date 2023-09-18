program ejercicio1;

{ En cada caso realizar un método (procedimentos/función según corresponda) para un archivo de nombre ‘Enteros.dat’:
    a) Crear el archivo y cargue tres valores pedidos al usuario.
    b) Leer todos los datos que posee e imprimirlos por pantalla.
    c) Agregar un valor entero pedido por pantalla al final del archivo.
    d) Devolver el promedio del contenido.
    e) Devolver el mayor de los valores.
}

const 
    max = 3;

type
    archivoInteger = file of integer;

procedure pedirDatos(var varArchivo: archivoInteger);
var i, valor: integer;
begin
    writeln('Ingrese enteros (', max, ' max)');
    
    for i:= 1 to max do begin
        write('[', i, '] - ');
        readln(valor);
        write(varArchivo, valor);
    end;
end;

procedure agregarValorEntero(var varArchivo: archivoInteger);
var aux, elemento: integer;
begin
    reset(varArchivo);
    
    writeln;
    writeln('Ingrese un nuevo valor entero:');
    readln(aux);
    
    seek(varArchivo, filesize(varArchivo) - 1);
    read(varArchivo, elemento);
    write(varArchivo, aux);
    
    close(varArchivo);
end;

function promedio(var varArchivo: archivoInteger): real;
var aux, i: integer;
begin
    aux:= 0;
    
    reset(varArchivo);
    
    while not eof(varArchivo) do begin
        read(varArchivo, i);
        aux:= aux + i;
    end;
    
    promedio:= aux / filesize(varArchivo);
    
    close(varArchivo);
end;

function valorMayor(var varArchivo: archivoInteger): integer;
var i, aux: integer;
begin
    reset(varArchivo);
    
    aux:= filepos(varArchivo) - 1; 
    
    while not eof(varArchivo) do begin
        read(varArchivo, i);
        
        if i > aux then
            aux:= i
    end;
    
    close(varArchivo);
    
    valorMayor:= aux;
end;

procedure crearArchivo(var varArchivo: archivoInteger);
begin
    rewrite(varArchivo);
    pedirDatos(varArchivo);
    close(varArchivo);
end;

procedure leerArchivo(var varArchivo: archivoInteger);
var elemento: integer;
begin
    reset(varArchivo);
    
    writeln;
    writeln('Archivo:');
    
    while not eof(varArchivo) do begin
        read(varArchivo, elemento);
        writeln(elemento);
    end;
    
    close(varArchivo)
end;

// Programa principal
var varArchivo: archivoInteger;
begin
    assign(varArchivo, 'Enteros.dat');
    crearArchivo(varArchivo);
    agregarValorEntero(varArchivo);
    leerArchivo(varArchivo);
    
    writeln;
    writeln('Promedio: ', promedio(varArchivo):0:2);
    
    writeln;
    writeln('Valor mayor: ', valorMayor(varArchivo));
end.
program ejercicio3;

{ Dado un archivo de números enteros codifique una función que dado un número lo 
busque en el archivo y retorne su posición (-1 si no lo encontró).
    a) Los elementos del archivo se encuentran desordenados.
    b) Los elementos del archivo se encuentran ordenados (no debería recorrerlo 
    completamente).
}

type
    archivo = file of integer;

procedure cargarArchivo(var arch: archivo);
var i: integer;
begin
    rewrite(arch);
    
    for i:= 1 to 20 do
        write(arch, i);
        
    close(arch);
end;

function posicionDesordenada(var arch: archivo; num: integer): integer;
var aux: integer;
begin
    posicionDesordenada:= -1;
    
    reset(arch);
    while not eof(arch) do begin
        read(arch, aux);
        
        if aux = num then
            posicionDesordenada:= filepos(arch) - 1;
    end;
    close(arch);
end;

function posicionOrdenada(var arch: archivo; num: integer): integer;
var aux: integer;
begin
    posicionOrdenada:= -1;
    
    reset(arch);
    while not eof(arch) and (aux <= num) do begin
        read(arch, aux);
        
        if aux = num then
            posicionOrdenada:= filepos(arch) - 1;
    end;
    close(arch);
end;

// Programa principal
var arch: archivo;
    pos: integer;
begin
    assign(arch, 'Posiciones.dat');
    cargarArchivo(arch);

    writeln('Por favor ingrese el número que desea buscar...');
    readln(pos);
    
    writeln;
    writeln('Con posición desordenada: ', posicionDesordenada(arch, pos));
    
    writeln;
    writeln('Con posición ordenada: ', posicionOrdenada(arch, pos));
end.
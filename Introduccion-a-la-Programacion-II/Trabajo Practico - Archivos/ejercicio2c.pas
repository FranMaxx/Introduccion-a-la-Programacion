program ejercicio2c;

{ 
    c) Dado un nuevo nombre de archivo ingresado por el usuario, crear un 
    archivo clonado con el creado en a); es decir, crear otro que tenga 
    exactamente el mismo contenido pero con un nombre distinto
}

type
    archivo = file of char;

procedure clonar(var arch, clon: archivo);
var aux: char;
begin
    reset(arch);
    rewrite(clon);
    
    while not eof(arch) do begin
        read(arch, aux);
        write(clon, aux);
    end;
    
    close(clon);
    close(arch);
    
    writeln;
    writeln('¡El archivo ha sido clonado exitosamente!');
end;

// Programa principal
var arch, clon: archivo;
    archName: string;
begin
    writeln('Ingrese el nombre del archivo');
    readln(archName);
    
    assign(arch, archName + '.dat');
    assign(clon, 'clonado' + '.dat');

    clonar(arch, clon);
    
    mostrar(arch);
end.
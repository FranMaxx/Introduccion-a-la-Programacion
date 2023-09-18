program ejercicio2;

{ 
    a) Hacer un método de carga que permita ingresar caracteres al archivo hasta 
    ingresar ‘*’, luego desde el principal ingresar un nombre de archivo por 
    teclado e invocar el método con el nombre ingresado).
    
    b) Dada una posición entera (válida) y un char, ambos ingresados por el 
    usuario, modifique el contenido del archivo en la posición ingresada con 
    el char ingresado.
}

type
    archivo = file of char;
    
procedure cargar(var arch: archivo);
var aux: char;
begin
    writeln;
    rewrite(arch);
    
    writeln('Ingrese valores, "*" para cancelar...');
    readln(aux);
    write(arch, aux);
    
    while aux <> '*' do begin
        writeln('Ingrese valores, "*" para cancelar...');
        readln(aux);
        
        if aux <> '*' then
            write(arch, aux);    
    end;
    
    close(arch);
end;

procedure modificar(var arch: archivo);
var pos: integer;
    val: char;
begin
    writeln;
    writeln('Ingrese un valor a modificar...');
    readln(val);
    
    writeln;
    writeln('Ingrese una posición valida... (comienzan desde el 0)');
    readln(pos);
    
    reset(arch);
    seek(arch, pos);
    write(arch, val);
    close(arch);
end;

procedure mostrar(var arch: archivo);
var e: char;
begin
    reset(arch);
    
    writeln;
    writeln('Valores del archivo:');
    
    while not eof(arch) do begin
        read(arch, e);
        writeln('- ', e);
    end;
    
    close(arch);
end;

// Programa principal
var arch, clon: archivo;
    archName: string;
begin
    writeln('Ingrese el nombre del archivo');
    readln(archName);
    
    assign(arch, archName + '.dat');
    assign(clon, 'clonado' + '.dat');
    
    cargar(arch);
    modificar(arch);
    
    mostrar(arch);
end.
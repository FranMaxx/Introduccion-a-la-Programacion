program ejercicio4;

{ 
    Crear un archivo desordenado de SOCIOS de un club con registros con la siguiente información: 
    DNI, Nro. Socio, Nombre y Apellido, año ingreso. La carga termina cuando se ingresa un DNI=0. 
    
    b) Hacer un programa que dado un DNI
    imprima todos los datos del socio si existe en el Archivo SOCIOS
}

{ Lo utilizo para convertir los integers en strings }
uses SysUtils;

type
    socios = record
        dni: 0..9;
        nro_socio: integer;
        nombre: string;
        apellido: string;
        anio: integer;
    end;
    
    archivo = file of socios;

procedure cargarArchivo(var arch: archivo);
var auxInt: integer;
    auxStr: string;
    socio: socios;
begin
    writeln('Ingrese un DNI (0 para cancelar)...');
    readln(auxInt);
    writeln;
    
    rewrite(arch);
    
    while auxInt <> 0 do begin
    
        socio.dni:= auxInt;
        
        writeln('Ingrese un numero de socio...');
        readln(auxInt);
        socio.nro_socio:= auxInt;
        writeln;
        
        writeln('Ingrese un nombre');
        readln(auxStr);
        socio.nombre:= auxStr;
        writeln;
        
        writeln('Ingrese un apellido');
        readln(auxStr);
        socio.apellido:= auxStr;
        writeln;
        
        writeln('Ingrese un anio de ingreso...');
        readln(auxInt);
        socio.anio:= auxInt;
        writeln;
        
        write(arch, socio);
        
        writeln('Ingrese un DNI (0 para cancelar)...');
        readln(auxInt);
        writeln;
    end;
    
    close(arch);
end;

{ Lo imprimi como un objeto de JavaScript jajaj }
procedure imprimirDatos(var arch: archivo);
var aux: socios;
    dni: integer;
    txt: string;
begin
    txt:= 'Lo siento, no se ha encontrado ese usuario...';
    
    writeln('Ingrese el dni que esta buscando...');
    readln(dni);
    
    reset(arch);
    
    while not eof(arch) do begin
        read(arch, aux);
        
        if aux.dni = dni then begin
            txt:= '{ dni: ' + IntToStr(aux.dni) + 
            ', nroSocio: ' + IntToStr(aux.nro_socio) +
            ', nombre: ' + aux.nombre +
            ', apellido: ' + aux.apellido +
            ', anio: ' + IntToStr(aux.anio) +
            ' }';
        end;
    end;
    
    writeln;
    writeln('CONSULTANDO EL ARCHIVO...');
    writeln(txt);
    
    close(arch);
end;

// Programa principal
var arch: archivo;
begin
    assign(arch, '/work/lozano_ejercicio4.dat');
    
    cargarArchivo(arch);
    imprimirDatos(arch);
end.
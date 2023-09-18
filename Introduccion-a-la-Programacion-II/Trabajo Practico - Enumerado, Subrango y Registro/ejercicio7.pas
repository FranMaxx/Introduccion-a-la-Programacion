program ejercicio7;

{ Codifique el procedimiento que, a partir del archivo, emite un listado de todos los alumnos de la universidad, agrupándolos
por facultad, por carrera, y por año que cursa. Al comenzar cada “categoría” imprimir un título, y al finalizar emitir el total
de alumnos, o sea, de cada año, cada carrera, cada facultad y la universidad }

{ Lo utilizo para convertir los integers en strings }
uses SysUtils;

const
    maxFacultad = 3;
    maxCarreras = 3;
    maxNombres = 5;

type
    alumno = record
        nombre: string;
        facultad: string;
        carrera: string;
        anio: string
    end;
    
    archivo = file of alumno;
    typeFacultades = array [1..maxFacultad] of string;
    typeCarreras = array [1..maxCarreras] of string;
    typeNombres = array [1..maxNombres] of string;
    typeContador = array [1..12] of integer;

procedure cargarNombres(var arrNombres: typeNombres);
begin
    arrNombres[1]:= 'Francisco';
    arrNombres[2]:= 'Juan Manuel';
    arrNombres[3]:= 'Martin';
    arrNombres[4]:= 'Nahuel';
    arrNombres[5]:= 'Valentin';
end;

procedure cargarFacultades(var arrFacultades: typeFacultades);
begin
    arrFacultades[1]:= 'Ciencias Exactas';
    arrFacultades[2]:= 'Ciencias Economicas';
    arrFacultades[3]:= 'Ciencias Humanas';
end;

procedure cargarCarreraExactas(var arrExactas: typeCarreras);
begin
    arrExactas[1]:= 'Ingenieria en Sistemas';
    arrExactas[2]:= 'TUDAI';
    arrExactas[3]:= 'TUARI';
end;

procedure cargarCarreraEconomicas(var arrEconomicas: typeCarreras);
begin
    arrEconomicas[1]:= 'Lic. en Administracion';
    arrEconomicas[2]:= 'Contador Publico';
    arrEconomicas[3]:= 'Lic. en Economia Empresarial';
end;

procedure cargarCarreraHumanas(var arrHumanas: typeCarreras);
begin
    arrHumanas[1]:= 'Profesorado en Geografia';
    arrHumanas[2]:= 'Profesorado en Historia';
    arrHumanas[3]:= 'Guia Universitario de Turismo';
end;

function crearUsuarioExactas(arrExactas: typeCarreras; arrFacultades: typeFacultades; arrNombres: typeNombres):alumno;
var user: alumno;
begin
    user.nombre:= arrNombres[random(maxNombres) + 1];
    user.facultad:= arrFacultades[1];
    user.carrera:= arrExactas[random(maxCarreras) + 1];
    user.anio:= IntToStr(random(2) + 1);
    
    crearUsuarioExactas:= user;
end;

function crearUsuarioEconomicas(arrEconomicas: typeCarreras; arrFacultades: typeFacultades; arrNombres: typeNombres):alumno;
var user: alumno;
begin
    user.nombre:= arrNombres[random(maxNombres) + 1];
    user.facultad:= arrFacultades[2];
    user.carrera:= arrEconomicas[random(maxCarreras) + 1];
    user.anio:= IntToStr(random(2) + 1);
    
    crearUsuarioEconomicas:= user;
end;

function crearUsuarioHumanas(arrHumanas: typeCarreras; arrFacultades: typeFacultades; arrNombres: typeNombres):alumno;
var user: alumno;
begin
    user.nombre:= arrNombres[random(maxNombres) + 1];
    user.facultad:= arrFacultades[3];
    user.carrera:= arrHumanas[random(maxCarreras) + 1];
    user.anio:= IntToStr(random(2) + 1);
    
    crearUsuarioHumanas:= user;
end;

procedure cargarContador(var arrContador: typeContador);
var i: integer;
begin
    for i:= 1 to 12 do
        arrContador[i]:= 0;
end;

var arch: archivo;
    arrNombres: typeNombres;
    arrFacultades: typeFacultades;
    arrExactas, arrEconomicas, arrHumanas: typeCarreras;
    
    arrContador: typeContador;
    
    aux: alumno;
    i: integer;
begin
    randomize;
    
    cargarNombres(arrNombres);
    cargarFacultades(arrFacultades);
    cargarCarreraExactas(arrExactas);
    cargarCarreraEconomicas(arrEconomicas);
    cargarCarreraHumanas(arrHumanas);
    
    cargarContador(arrContador);
    
    assign(arch, '/work/lozano_ejercicio7.dat');
    rewrite(arch);
    
    for i:= 1 to 20 do begin
        write(arch, crearUsuarioExactas(arrExactas, arrFacultades, arrNombres));
        write(arch, crearUsuarioEconomicas(arrEconomicas, arrFacultades, arrNombres));
        write(arch, crearUsuarioHumanas(arrHumanas, arrFacultades, arrNombres));
    end;
    
    close(arch);
    
    
    reset(arch);
    
    while not eof(arch) do begin
        read(arch, aux);
        
        writeln(aux.facultad);
        writeln('---- ' + aux.carrera);
        writeln('-------- ' + aux.anio + '°');
        writeln('---------------- ' + aux.nombre);
        
        writeln;
        
        if aux.facultad = arrFacultades[1] then begin
            
            arrContador[1] += 1;
            
            if aux.carrera = arrExactas[1] then
                arrContador[2] += 1;
                
            if aux.carrera = arrExactas[2] then
                arrContador[3] += 1;
                
            if aux.carrera = arrExactas[3] then
                arrContador[4] += 1;
            
        end;
        
        if aux.facultad = arrFacultades[2] then begin
            
            arrContador[5] += 1;
            
            if aux.carrera = arrEconomicas[1] then
                arrContador[6] += 1;
                
            if aux.carrera = arrEconomicas[2] then
                arrContador[7] += 1;
                
            if aux.carrera = arrEconomicas[3] then
                arrContador[8] += 1;
            
        end;
        
        if aux.facultad = arrFacultades[3] then begin
            
            arrContador[9] += 1;
            
            if aux.carrera = arrHumanas[1] then
                arrContador[10] += 1;
                
            if aux.carrera = arrHumanas[2] then
                arrContador[11] += 1;
                
            if aux.carrera = arrHumanas[3] then
                arrContador[12] += 1;
            
        end;
    end;
    
    writeln;
    writeln('TOTAL ALUMNOS:');
    writeln;
    
    writeln(arrFacultades[1] + ': ', arrContador[1]);
    writeln('---- ' + arrExactas[1] + ': ', arrContador[2]);
    writeln('---- ' + arrExactas[2] + ': ', arrContador[3]);
    writeln('---- ' + arrExactas[3] + ': ', arrContador[4]);
    
    writeln;
    
    writeln(arrFacultades[2] + ': ', arrContador[5]);
    writeln('---- ' + arrEconomicas[1] + ': ', arrContador[6]);
    writeln('---- ' + arrEconomicas[2] + ': ', arrContador[7]);
    writeln('---- ' + arrEconomicas[3] + ': ', arrContador[8]);
    
    writeln;
    
    writeln(arrFacultades[3] + ': ', arrContador[9]);
    writeln('---- ' + arrHumanas[1] + ': ', arrContador[10]);
    writeln('---- ' + arrHumanas[2] + ': ', arrContador[12]);
    writeln('---- ' + arrHumanas[3] + ': ', arrContador[11]);
    
    writeln;
    writeln('Universidad Nacional del Centro: ', filesize(arch));
    
    close(arch);
    
end.
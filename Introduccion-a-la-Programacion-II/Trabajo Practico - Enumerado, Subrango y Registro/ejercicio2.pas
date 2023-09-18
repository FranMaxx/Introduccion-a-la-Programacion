program ejercicio2;

{ Codificar un procedimiento que, dados el arreglo y un registro con los datos de
un nuevo alumno, inserte dicho alumno en el arreglo, manteniendo el orden }

const
    max = 10;

type
    alumno = record
        nro_de_libreta: integer;
        nombre: string;
        cod_facultad: 1..9;
        cod_carrera: 10..99;
        anio: integer
    end;
    
    arrType = array [1..max] of alumno;

procedure cargarArreglo(var arr: arrType);
var i: integer;
begin
    for i:= 1 to max - 1 do begin
        arr[i].nro_de_libreta:= random(100) + 1;
        arr[i].nombre:= 'Pepito';
        arr[i].cod_facultad:= random(9) + 1;
        arr[i].cod_carrera:= random(99 - 10) + 10;
        arr[i].anio:= random(15) + 1995;
    end;
end;

procedure ordenarArreglo(var arr: arrType);
var i, j: integer;
    aux: alumno;
begin
    i:= 1;
    
    for i:= 1 to max do begin
        for j:= 1 to max - 1 do begin
            if arr[j].nro_de_libreta > arr[j + 1].nro_de_libreta then begin
            
                aux:= arr[j + 1];
                arr[j + 1]:= arr[j];
                arr[j]:= aux;
            
            end;
        end;
    end;
    
    writeln;
end;

function nuevoAlumno(): alumno;
var auxInt: integer;
    auxStr: string;
begin
    writeln('Ingrese los siguientes datos para ingresar un nuevo usuario.');
    
    writeln('Nro. de libreta:');
    readln(auxInt);
    nuevoAlumno.nro_de_libreta:= auxInt;
    writeln;
    
    writeln('Nombre:');
    readln(auxStr);
    nuevoAlumno.nombre:= auxStr;
    writeln;
    
    writeln('Codigo facultad:');
    readln(auxInt);
    nuevoAlumno.cod_facultad:= auxInt;
    writeln;
    
    writeln('Codigo carrera:');
    readln(auxInt);
    nuevoAlumno.cod_carrera:= auxInt;
    writeln;
    
    writeln('Anio:');
    readln(auxInt);
    nuevoAlumno.anio:= auxInt;
    writeln;
end;

procedure insertarAlumno(var arr: arrType; alumno: alumno);
begin
    arr[max]:= alumno;
end;

procedure imprimirArreglo(arr: arrType);
var i: integer;
begin

    writeln('DATOS DE LOS ALUMNOS:');
    
    for i:= 1 to max do begin
    
        write('[', i, '] - [ ', 
            arr[i].nro_de_libreta, ', ',
            arr[i].nombre, ', ',
            arr[i].cod_facultad, ', ',
            arr[i].cod_carrera, ', ',
            arr[i].anio,' ]'
        );
        
        writeln;
    end;
end;

// Programa principal
var arr: arrType;
begin
    randomize;
    
    cargarArreglo(arr);
    insertarAlumno(arr, nuevoAlumno());
    ordenarArreglo(arr);
    imprimirArreglo(arr);
end.
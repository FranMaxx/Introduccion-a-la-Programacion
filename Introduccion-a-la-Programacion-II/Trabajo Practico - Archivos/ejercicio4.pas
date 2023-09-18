program ejercicio4;

{ Suponga que tiene un archivo de arreglos de 5 enteros. Cada entero corresponde 
a la nota en la materia 1, 2, 3, 4 y 5 de las y los estudiantes de primer año de 
una carrera. Cada elemento del archivo corresponde a las notas de un estudiante 
y el archivo contiene las notas de las y los estudiantes de primer año de la carrera. 
Codifique un método que genere un arreglo con la nota promedio (entero) en cada 
una de las materias }

const
    min = 1;
    max = 5;
    maxAlumnos = 10;

type
    arrType = array [min..max] of integer;
    archivo = file of arrType;

function generadorNotas(): arrType;
var i: integer;
begin
    for i:= min to max do begin
        generadorNotas[i]:= random(10);
    end;
end;

procedure cargarNotas(var arch: archivo);
var i: integer;
begin
    rewrite(arch);
    
    for i:= min to maxAlumnos do begin
        write(arch, generadorNotas);
    end;
    
    close(arch);
end;

procedure mostrarNotas(var arch: archivo);
var aux: arrType;
    i, j: integer;
begin
    j:= 1;
    
    reset(arch);
    
    while not eof(arch) do begin
        read(arch, aux);
        
        write('Alumno N° ', j, ' = ');
        
        for i:= min to max do
            write('[ ', aux[i], ' ]');
        writeln;
        
        j+= 1;
    end;
    
    close(arch);
end;

procedure generarPromedio(var arch: archivo; var promedio: arrType);
var i, j: integer;
    nota: arrType;
begin
    reset(arch);
    
    while not eof(arch) do begin
        read(arch, nota);
        
        for i:= min to max do
            promedio[i]+= nota[i];
    end;
    
    close(arch);
    
    for j:= min to max do begin
        promedio[j]:= promedio[j] div maxAlumnos;
    end;
    
end;

procedure mostrarPromedio(promedio: arrType);
var i: integer;
begin
    for i:= min to max do
        write('[ ', promedio[i], ' ]');
end;

// Programa principal
var arch: archivo;
    promedio: arrType;
begin
    randomize;
    
    assign(arch, 'Notas.dat');
    cargarNotas(arch);
    mostrarNotas(arch);
    
    generarPromedio(arch, promedio);
    
    writeln;
    write('Promedio = ');
    mostrarPromedio(promedio);
end.
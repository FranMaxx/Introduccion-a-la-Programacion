program ejercicio5;

{ Se tienen dos archivos con los números (enteros >= 0). Ambos archivos están 
ordenados de forma ascendente. Elimine de uno de los archivos los números que 
están en el otro archivo. Implementar borrado lógico. }

const
  maxNums = 5;

type
  archivo = file of integer;

procedure cargarArchivos(var arch1, arch2: archivo);
var i, j: integer;
begin
  rewrite(arch1);
  
  for i:= 1 to maxNums do
    write(arch1, random(5) + 1);
    
  close(arch1);
  
  rewrite(arch2);
  
  for j:= 1 to maxNums do
    write(arch2, random(5) + 1);
    
  close(arch2);
end;

procedure mostrarArchivos(var arch1, arch2: archivo);
var aux, aux2: integer;
begin
  writeln('Archivo 1 ORIGINAL:');
  
  reset(arch1);
  
  while not eof(arch1) do begin
    read(arch1, aux);
    writeln('- ', aux);
  end;
  
  close(arch1);
  
  writeln;
  writeln('Archivo 2 ORIGINAL:');
  
  reset(arch2);
  
  while not eof(arch2) do begin
    read(arch2, aux2);
    writeln('- ', aux2);
  end;
  
  close(arch2);
end;

procedure borradoLogico(var arch1, arch2: archivo);
var aux, pos, aux2: integer;
begin
  reset(arch1);
  reset(arch2);
  
  while not eof(arch1) do begin
    seek(arch2, 0);
    read(arch1, aux);
    
    while not eof(arch2) do begin
      read(arch2, aux2);
      
        if aux = aux2 then begin
            pos:= filepos(arch1) - 1;
            seek(arch1, pos);
            write(arch1, -1);
        end;
        
    end;
    
  end;
  
  close(arch2);
  close(arch1);
end;

procedure archivoModificado(var arch1: archivo);
var aux: integer;
begin
  writeln;
  writeln('Archivo 1 MODIFICADO:');
  
  reset(arch1);
  
  while not eof(arch1) do begin
    read(arch1, aux);
    writeln('- ', aux);
  end;
  
  close(arch1);
end;

// Programa principal
var arch1, arch2: archivo;
begin
  randomize;
  
  assign(arch1, 'numeros1.dat');
  assign(arch2, 'numeros2.dat');
  
  cargarArchivos(arch1, arch2);
  mostrarArchivos(arch1, arch2);
  borradoLogico(arch1, arch2);
  archivoModificado(arch1);
end.
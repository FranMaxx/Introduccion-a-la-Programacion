// ------------ SIN TERMINAR ------------

program ejercicio1;

{ Defina un registro para representar una fecha(DIA/MES/AÑO) y codifique procedimientos o funciones para manejo de
fechas }

type
    fecha = record
        dia: 1..30;
        mes: 1..12;
        anio: 1900..2022;
end;

procedure ingresarFecha(var fecha1: fecha);
begin
    writeln('Ingrese un dia, por favor');
    readln(fecha1.dia);
    writeln;
    
    writeln('Ingrese un mes, por favor');
    readln(fecha1.mes);
    writeln;
    
    writeln('Ingrese un anio, por favor');
    readln(fecha1.anio);
    writeln;
end;

{ PREGUNTAR EN CLASE POR QUE TIRA TRUE }
function verificarFecha(fecha1: fecha): boolean;
begin
    verificarFecha:= false;
    
    if (fecha1.dia >= 1) and (fecha1.dia <= 30) then
        if (fecha1.mes >= 1) and (fecha1.mes <= 12) then
            if (fecha1.anio >= 1900) and (fecha1.anio <= 2022) then
                verificarFecha:= true;
end;

{ CORREGIR, SOLO FUNCIONA CON DIAS MENORES A 365 }
procedure sumarDiasAUnaFecha(var fecha1: fecha);
var dia, diff, counter, i: integer;
    aux: real;
begin
    writeln('¿Cuantos dias deseas sumarle a la fecha?');
    readln(dia);
    
    diff:= fecha1.dia + dia;
    
    if diff > 30 then begin
        
        aux:= (diff / 30);
        aux:= Trunc(aux);
        counter:= round(aux);
        
        for i:= 1 to counter do begin
            fecha1.mes += 1;
        end;
        
        fecha1.dia += dia - 30;
        
    end else 
        fecha1.dia += dia;
    
end;

procedure imprimirFecha(fecha1: fecha);
begin
    writeln;
    writeln('Fecha: ', fecha1.dia, '/', fecha1.mes, '/', fecha1.anio);
end;

// Programa principal
var fecha1: fecha;
begin
    ingresarFecha(fecha1);
    writeln('Fecha valida: ', verificarFecha(fecha1));
    
    writeln;
    
    sumarDiasAUnaFecha(fecha1);
    imprimirFecha(fecha1);
end.
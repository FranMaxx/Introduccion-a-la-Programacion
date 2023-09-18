// Insertar arbol

procedure crearNodo(var arbol: punt; num: integer);
begin
new(arbol);
arbol^.num:= num;
arbol^.men:= nil;
arbol^.may:= nil;
end;

procedure insertar(var arbol: punt; num: integer);
begin
if arbol = nil then
crearNodo(arbol, num);
else begin
if num < arbol^.num then
insertar(arbol^.men, num)
else
insertar(arbol^.may, num);
end;
end;

// Imprimir

procedure imprimir(arbol: punt);
begin
if arbol <> nil then begin
imprimir(arbol^.men);
writeln(arbol^.num);
imprimir(arbol^.may);
end;
end;

function punteroAlNodo(arbol: punt; num: integer);
begin
if arbol = nil then
punteroAlNodo:= nil
else if num = arbol^.num then
punteroAlNodo:= arbol
else if num < arbol^.num then
punteroAlNodo(arbol^.men, num)
else
punteroAlNodo(arbol^.may, num);
end;

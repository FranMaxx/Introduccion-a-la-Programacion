procedure insertarOrdenadoListaSimple(var lista: puntLista; nodo: puntLista);
begin
    if (lista = nil) or (nodo^.num < lista^.num) then begin
        nodo^.sig:= lista;
        lista:= nodo;
    end else
        insertarOrdenadoListaSimple(lista^.sig, nodo);
end;


// Primer caso: Insertar al principio
// Segundo caso: Insertar al medio
// Tercer caso: Insertar al final
procedure insertarOrdenadoListaDoble(var lista: puntLista; nodo: puntLista);
begin
    if (lista = nil) or (nodo^.num < lista^.num) then begin
        nodo^.sig:= lista; // Primer caso
        
        // Segundo caso
        if lista <> nil then begin
            nodo^.ant:= lista^.ant;
            lista^.ant:= nodo;
        end;
        
        lista:= nodo; // Primer caso
    end 
    else 
        if lista^.sig = nil then begin
            lista^.sig:= nodo;
            nodo^.ant:= lista;
        end 
    else
        insertarOrdenadoListaDoble(lista^.sig, nodo);
end;
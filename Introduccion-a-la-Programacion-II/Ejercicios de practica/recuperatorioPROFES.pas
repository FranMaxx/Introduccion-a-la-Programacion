program Recuperatorio;

type
    Tarbol = ^PuntArbol;
    PuntArbol = record
        nombre: string;
        deuda: real;
        sigDeuda: Tarbol; 
        MenorLetra, MayorLetra: Tarbol;
    end;
    
    TClientes = record
        nombre: string;
        deuda: real;
    end;
    
    ArchCliente = file of TClientes; //se asume que el archivo existe y ya se encuentra cargado

procedure AbrirArchivo(var Clientes: ArchCliente); //procedimiento para abrir el archivo
begin
    {$I-} //desactivo verificacion de errores de entrada/salida
    reset(Clientes);
    {$I+} //activo verificacion de errores de entrada/salida
    if ioresult <> 0 then
        Rewrite(Clientes);
end;

procedure CrearNodoArbol(var ARB_CLIENTES: Tarbol; Dato: TClientes); //creo los nodos en el arbol
begin
    new(ARB_CLIENTES);
    ARB_CLIENTES^.MayorLetra:= nil;
    ARB_CLIENTES^.MenorLetra:= nil;
    ARB_CLIENTES^.sigDeuda:= nil;
    ARB_CLIENTES^.nombre:= Dato.nombre;
    ARB_CLIENTES^.deuda:= Dato.deuda;
end;

procedure InsertarArbolAlfabeticamente(var ARB_CLIENTES: Tarbol; NuevoNodo: Tarbol); //inserto los nodos de manera que quede ordenado alfabeticamente
begin
    if ARB_CLIENTES = nil then
        ARB_CLIENTES:= NuevoNodo
    else
    if ARB_CLIENTES^.nombre < NuevoNodo^.nombre then
        InsertarArbolAlfabeticamente(ARB_CLIENTES^.MayorLetra, NuevoNodo)
    else
        InsertarArbolAlfabeticamente(ARB_CLIENTES^.MenorLetra, NuevoNodo)
end;

function EstaEnArbol(ARB_CLIENTES: Tarbol; nombre: string): Tarbol; //funcion que me devuelve un puntero si encuentra el cliente
begin
    if ARB_CLIENTES <> nil then 
        if ARB_CLIENTES^.nombre = nombre then
            EstaEnArbol:= ARB_CLIENTES
        else
        if nombre > ARB_CLIENTES^.nombre then
            EstaEnArbol:= EstaEnArbol(ARB_CLIENTES^.MayorLetra, nombre)
        else
            EstaEnArbol:= EstaEnArbol(ARB_CLIENTES^.MenorLetra, nombre)
        else
            EstaEnArbol:= nil;
end;

procedure VincularNodoLista(var ORDEN_DEUDAS: Tarbol; Lista: Tarbol); //vinculo los nodos del arbol "creando" una lista con el 
begin
    if (ORDEN_DEUDAS = nil) or (ORDEN_DEUDAS^.deuda <= Lista^.deuda) then begin
        Lista^.sigDeuda:= ORDEN_DEUDAS;
        ORDEN_DEUDAS:= Lista;
    end
    else
        VincularNodoLista(ORDEN_DEUDAS^.sigDeuda, Lista);
end;

procedure CrearArbol(var ARB_CLIENTES: Tarbol; var Clientes: ArchCliente; ORDEN_DEUDAS: Tarbol); //creo el arbol manteniendo los ordenes que se me piden
var
    Dato: TClientes;
    NuevoNodo: Tarbol;
begin
    seek(Clientes, 0);
    while not eof(Clientes) do begin
        read(Clientes, Dato);
        if EstaEnArbol(ARB_CLIENTES, Dato.nombre) = nil then begin //si la funcion devuelve distinto a nil, el cliente ya existe
            CrearNodoArbol(NuevoNodo, Dato);
            InsertarArbolAlfabeticamente(ARB_CLIENTES, NuevoNodo);
            VincularNodoLista(ORDEN_DEUDAS, NuevoNodo);
            NuevoNodo:= nil;
        end;
    end;
end;

//Programa Principal

var
    ARB_CLIENTES, ORDEN_DEUDAS: Tarbol;
    Clientes: ArchCliente;
begin
    //se espera aca la carga del archivo etc
    assign (Clientes, '/work/Clientes.dat');
    CrearArbol(ARB_CLIENTES, Clientes, ORDEN_DEUDAS);
end.
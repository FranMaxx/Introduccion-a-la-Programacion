program exc2;

Type                                                                                
    
    PuntArbol = ^TArbol;
    TArbol = record
        nro_factura: integer;
        facturas_impagas: integer;
        menor, mayor: PuntArbol;
    end;
        
    PuntLista = ^TLista;
    TLista = record
        codigo_cliente: integer;
        monto_adeudado: integer;
        facturas: PuntArbol;
        Sig_Cliente: PuntLista;
        Sig_Deudor: PuntLista;
    end;
   
    TArchivo = file of integer;

procedure CargarArchivo (var Codigo: Tarchivo); //Este archivo debe cargarse en orden menor a mayor
var
    Valor: integer;
begin
    Valor:= 0;                              
    while (Valor <> -1) do 
    begin
        writeln ('Ingrese el valor que se quiere agregar al archivo');
        readln (Valor);
        write (Codigo, Valor);
    end;    
end;
procedure AbrirArchivo(var archivo:Tarchivo);       
begin
    {$I-}
    reset(archivo);
    {$I+}
    if (ioresult <> 0) then begin
        rewrite(archivo);
        CargarArchivo(archivo);
    end;
end;

procedure CrearNodo (var Arbol: PuntArbol; valor, dato: integer);
begin
        new (Arbol);
        Arbol^.nro_factura:= valor;
        Arbol^.facturas_impagas:= dato;
        Arbol^.mayor:= nil;
        Arbol^.menor:= nil;
end;

procedure InsertarEnArbol (var Arbol: PuntArbol; valor, dato: integer);
begin
    if (Arbol = nil) then
    begin
        CrearNodo(Arbol, valor, dato);
        end
    else begin
        if (Arbol^.facturas_impagas < valor) then
        begin
            InsertarEnArbol(arbol^.mayor, valor,dato);
        end
        else
        begin
            InsertarEnArbol(arbol^.menor, valor,dato);
        end;
    end;
end;

procedure CargarArbol (var Arbol: PuntArbol); 
var
    dato, valor: integer;
begin
    dato:= 0;
    valor:= 0;
    while (valor <> -1) do
    begin
        writeln('ingrese un nro de factura para cargar el arbol, si desea finalizar, ingrese -1');
        read(valor);
        if (valor <> -1) then begin
            writeln('ingrese un valor de factura impaga');
            read(dato);
            InsertarEnArbol(Arbol, valor, dato);
        end;
    end;
end;

function SumaFacturas (nodo: PuntArbol): integer; //suma todos los valores de cada nodo
begin
    if (nodo <> nil) then 
        SumaFacturas:= nodo^.facturas_impagas + SumaFacturas (nodo^.menor) + SumaFacturas (nodo^.mayor) //sumas mientras sea dist a nil
    else
        SumaFacturas:= 0; //si es nil, suma 0
end;

procedure ActualizarMonto (nodo: PuntLista; ListaClientes: PuntLista); //le paso nodos, var porque  se actualiza  // NO SE ACTUALIZA LA DIRECC DE MEM DE NODO, SOLO SU CONTENIDO........
begin
    nodo^.monto_adeudado:= SumaFacturas(nodo^.facturas);
end;

procedure InsertarOrdenadoLista(var ListaDeudas: PuntLista; nodoInsertar: PuntLista); //ordenado por el monto adeudado
begin
    if (ListaDeudas = nil) or (nodoInsertar^.monto_adeudado < ListaDeudas^.monto_adeudado) then begin  
        nodoInsertar^.sig_Deudor := ListaDeudas;
        ListaDeudas := nodoInsertar;
    end else
        InsertarOrdenadoLista(ListaDeudas^.sig_Deudor, nodoInsertar);
end;  

function NodoLista (ListaClientes: PuntLista; codigo_cliente: integer): PuntLista;   //devuelve el nodo si lo encuentra en la lista
begin
    if (ListaClientes <> nil) and (ListaClientes^.codigo_cliente <> codigo_cliente) then 
        NodoLista(ListaClientes^.sig_Deudor, codigo_cliente)
    else
        if (ListaClientes^.codigo_cliente = codigo_cliente) then
            NodoLista:= ListaClientes
        else begin
            writeln('no se encontro el archivo en la lista');
            Nodolista:= nil;
        end;
end;

procedure NuevoOrdenCliente (var ListaClientes, ListaDeudas: PuntLista; var Archivo: TArchivo); //recorre el archivo y va buscando en la lista, busca y actualiza en la lista
var
    codigo_cliente: integer;
    nodoInsertar: PuntLista;
begin
    while not (eof(Archivo)) do begin
        read(Archivo, codigo_cliente);
        nodoInsertar:= NodoLista(ListaClientes, codigo_cliente);
        ActualizarMonto(nodoInsertar, ListaClientes);
        InsertarOrdenadoLista(ListaDeudas, nodoInsertar);
    end;
end;

//Programa Principal

var
    ListaCliente, ListaDeudas: PuntLista;
    ARC_Cliente: TArchivo;
    Arbol: TArbol;
begin
    assign (ARC_Cliente, '/work/RojasTomas_Ejer2_Recu.dat');
    CargarArchivo(ARC_Cliente);
    AbrirArchivo(ARC_CLiente);
    ListaDeudas:= nil;
    NuevoOrdenCliente(ListaCliente, ListaDeudas, ARC_Cliente);
    Close(ARC_CLiente);
end.
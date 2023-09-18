program ejercicio5;

type
    PuntCiudad = ^Ciudad;
    Ciudad = record
        nombre: string;
        provincia: string;
        Poblacion: longint;
        SigCiudad: PuntCiudad;
        AnteriorCiudad: PuntCiudad;
    end;
    
    PuntProvincia = ^Provincia;
    Provincia = record
        nombre: string;
        Poblacion: longint;
        sigProvincia: PuntProvincia;
    end;
    
procedure CrearCiudad (var NuevaCiudad: PuntCiudad; ciudad, provincia: string; Poblacion: longint);
begin
    new (NuevaCiudad);
    NuevaCiudad^.nombre:= ciudad;
    NuevaCiudad^.provincia:= provincia;
    NuevaCiudad^.Poblacion:= Poblacion;
    NuevaCiudad^.sigCiudad:= nil;
    NuevaCiudad^.AnteriorCiudad:= nil;
end;

procedure InsertarEnCiudades (var Ciudades: PuntCiudad; NuevaCiudad: PuntCiudad);
begin
    if (Ciudades = nil) then
        Ciudades := NuevaCiudad
    else begin
        if (Ciudades^.nombre < NuevaCiudad^.nombre) then
            InsertarEnCiudades(Ciudades^.sigCiudad, NuevaCiudad)
        else
            InsertarEnCiudades(Ciudades^.anteriorCiudad, NuevaCiudad);
    end;
end;

procedure CargarCiudades (var Ciudades: PuntCiudad); 
var
    ciudad, provincia : string;
    Poblacion: longint;
    i, cantidad: integer;
    NuevaCiudad: PuntCiudad;
begin
    writeln('Cuantos bor?');
    readln(cantidad);
    for i := 1 to cantidad do
    begin
        writeln('Ingrese la ciudad');
        readln(ciudad);
        writeln('ingrese la provincia de la ciudad:');
        readln(provincia);
        writeln('ingrese la cantidad de habitantes de la ciudad:');
        readln(Poblacion);
        CrearCiudad (NuevaCiudad, ciudad, provincia, Poblacion);
        InsertarEnCiudades (ciudades, NuevaCiudad);
    end;
end;

Procedure ImprimirArbolAscendente(ciudades:PuntCiudad);
Begin
    If (ciudades <> Nil) Then
    Begin
        ImprimirArbolAscendente(ciudades^.anteriorciudad);
        writeln('--------------------------');
        writeln('Ciudad: ',ciudades^.nombre);
        writeln('Provincia: ',ciudades^.provincia);
        writeln('Cantidad de habitantes: ',ciudades^.Poblacion);
        writeln('--------------------------');
        ImprimirArbolAscendente(ciudades^.sigciudad);
    End;
End;

procedure InsertarEnListaOrdenado (var Poblacion: PuntProvincia; NuevaProvincia: PuntProvincia);
begin
    if (Poblacion = nil) or (Poblacion^.poblacion > NuevaProvincia^.poblacion) then begin
        NuevaProvincia^.sigProvincia := Poblacion;
        Poblacion := NuevaProvincia;
    end else
        InsertarEnListaOrdenado (Poblacion^.sigProvincia, NuevaProvincia);
end;

procedure CrearProvincia (var NuevaProvincia: PuntProvincia; Ciudades: PuntCiudad);
begin
    new(NuevaProvincia);
    NuevaProvincia^.Nombre := Ciudades^.Provincia;
    NuevaProvincia^.Poblacion := Ciudades^.Poblacion;
    NuevaProvincia^.sigProvincia := nil;
end;

function BuscaProvinciaEnLista (Poblacion: PuntProvincia; NombreProvincia:string): boolean;
begin
    if (Poblacion <> nil) then
        if (Poblacion^.Nombre <> NombreProvincia) then
            BuscaProvinciaEnLista := BuscaProvinciaEnLista (Poblacion^.sigProvincia, NombreProvincia)
        else
            BuscaProvinciaEnLista := true
    else
        BuscaProvinciaEnLista := false;
end;

procedure Desvincular(var provincias, ProvinciaDesvinculada: puntProvincia; nombre: string);
begin
    if (provincias^.nombre = nombre) then begin
        ProvinciaDesvinculada := provincias;
        provincias := provincias^.sigProvincia;
    end else begin
        // Siguiente provincia nunca debe llegar a nil plis
        if (provincias^.sigProvincia^.nombre = nombre) then
        begin
            ProvinciaDesvinculada := provincias^.sigProvincia;
            provincias^.sigProvincia := provincias^.sigProvincia^.sigProvincia;
            ProvinciaDesvinculada^.sigProvincia := nil;
        end else
            Desvincular(provincias^.sigProvincia, ProvinciaDesvinculada, nombre);
    end  
end;

{procedure DeletePointer (var requestedList: TPointer; var auxRequested: TPointer);
var 
    auxPointer, DeleteSpace: TPointer;
begin 
    auxPointer:= requestedList;
    if (auxPointer^.next = nil) then begin
        auxPointer := nil;
        //Borra el primer nodo. 
    end else begin 
        while (auxPointer^.next^.Content <> auxRequested^.Content) do begin 
            auxPointer:= auxPointer^.next;
        end; 
        if (auxPointer^.next^.next = nil) then begin
            DeleteSpace:= auxPointer^.next;
            auxPointer^.next:= nil;
            Dispose(DeleteSpace);
            //Borra el último nodo.
        end else begin  
            DeleteSpace:= auxPointer^.Next;
            auxPointer^.next:= auxPointer^.next^.next;
            Dispose(DeleteSpace);
        end; //Borra un nodo del medio. 
    end;
    requestedList:= auxPointer;
end;}

Procedure HacerloNecesario(var provincias: puntProvincia; ciudad: puntCiudad);
var NuevaProvincia, ProvinciaDesvinculada: puntProvincia;
    existe: boolean;
begin
    existe := BuscaProvinciaEnLista (Provincias, ciudad^.Provincia);
    
    if not existe then begin
        CrearProvincia (NuevaProvincia, ciudad);
        InsertarEnListaOrdenado (Provincias, NuevaProvincia);
        
    end else begin
        Desvincular(provincias, ProvinciaDesvinculada, ciudad^.provincia);
        ProvinciaDesvinculada^.Poblacion := ProvinciaDesvinculada^.Poblacion + ciudad^.Poblacion;
        
        InsertarEnListaOrdenado (Provincias, ProvinciaDesvinculada);
    end;
end;

procedure ActualizarProvincias (Ciudades: PuntCiudad; var Provincias: PuntProvincia; Ciudad1, Ciudad2:string);
var
    NuevaProvincia, Aux: puntProvincia;
begin
    if (Ciudades <> nil) then begin
        if (Ciudad1 <= Ciudades^.nombre) and (Ciudad2 >= Ciudades^.nombre) then begin    //Si esto ocurre estamos dentro del rango
        
            HacerloNecesario(provincias, ciudades);
            
            ActualizarProvincias (Ciudades^.anteriorCiudad, Provincias, Ciudad1, Ciudad2); 
            ActualizarProvincias (Ciudades^.sigCiudad, Provincias, Ciudad1, Ciudad2);
        end else if (Ciudades^.nombre > Ciudad2) then begin
            ActualizarProvincias (Ciudades^.anteriorCiudad, Provincias, Ciudad1, Ciudad2);
        end else
            ActualizarProvincias (Ciudades^.sigCiudad, Provincias, Ciudad1, Ciudad2);
    end;
end;

Procedure Imprimirlista(lista:puntProvincia);
Begin
    If (lista <> Nil) Then
    Begin
        writeln('Nombre de provincia: ',lista^.Nombre);
        writeln('Poblacion: ',lista^.Poblacion);
        imprimirlista(lista^.sigProvincia);
    End;
End;

//Programa principal
var
    Ciudades: PuntCiudad;
    Poblacion: PuntProvincia;
    Ciudad1, Ciudad2: string;
begin
    Ciudades := nil;
    Poblacion := nil;
    CargarCiudades (Ciudades);
    ImprimirArbolAscendente (Ciudades);
    writeln('Ingrese la ciudad1: ');
    readln(Ciudad1);
    writeln('Ingrese la ciudad2: ');
    readln(Ciudad2);
    ActualizarProvincias(Ciudades, Poblacion, Ciudad1, Ciudad2);
    writeln('La lista es: ');
    ImprimirLista (Poblacion);
end.
program parcial;

{ Se tiene un árbol en el que cada nodo posee nro_articulo(integer) y anio_fabricacion(1970-2025). 
Este árbol está ordenado por número de artículo. Se pide que dados dos números de artículo 
(art_min, art_max) y un número de profundidad (prof_maxima) recorra el árbol y genere una lista doblemente 
vinculada conteniendo el anio_fabricacion y la cantidad de artículos encontrados de ese año. 
Los nodos de la lista deben estar permanentemente ordenados en forma descendente por cantidad de artículos. 
Los nodos del árbol a tener en cuenta son sólo los que poseen el nro_articulo entre art_min y art_max y cuya profundidad en el árbol no supera prof_maxima 
(la raíz tiene profundidad = 1). No debe recorrer nodos inútilmente. 
Realice el DE, la declaración de constantes, tipos, variables, programa principal y todos los módulos que considere necesarios. Considerar que el árbol inicialmente está cargado. }

type
	punt = ^nodoArbol;
  nodoArbol = record
  	nro_articulo: integer;
    anio_fabricacion: 1970..2025;
    HI, HD: punt;
    
end;
  puntLDV = ^nodo;
  nodo = record
  	anio_fabricacion: 1970..2025;
    cant_articulos: integer;
  	ant, sig: puntLDV;
  end;

// -- Presets -- //
procedure crearNodo(var arbol: punt; nro, anio: integer);
begin
	new(arbol);
  arbol^.nro_articulo:= nro;
  arbol^.anio_fabricacion:= anio;
  arbol^.HI:= nil;
  arbol^.HD:= nil;
end;

procedure insertarArbol(var arbol: punt; nro, anio: integer);
begin
	if arbol = nil then
  	crearNodo(arbol, nro, anio)
	else begin
  	if nro < arbol^.nro_articulo then
    	insertarArbol(arbol^.HI, nro, anio)
    else
    	insertarArbol(arbol^.HD, nro, anio)
  end;
end;

procedure cargarArbol(var arbol: punt);
begin
	insertarArbol(arbol, 5, 2000);
  insertarArbol(arbol, 3, 2001);
  insertarArbol(arbol, 8, 2000);
  insertarArbol(arbol, 1, 2001);
  insertarArbol(arbol, 2, 2002);
  insertarArbol(arbol, 7, 2002);
  insertarArbol(arbol, 9, 2002);
end;

// IGNORAR
procedure imprimir(arbol: punt);
begin
	if arbol <> nil then begin
  	imprimir(arbol^.HI);
    writeln(arbol^.nro_articulo, ', ', arbol^.anio_fabricacion);
    imprimir(arbol^.HD);
  end;
end;

// -- Programa principal -- //
var arbol, listaDV: punt;
		art_min, art_max, prof_maxima: integer;
begin
	arbol:= nil;
  
  // --- Valores --- //
    art_min:= 2;
    art_max:= 10;
    prof_maxima:= 3;
  
  cargarArbol(arbol);
  imprimir(arbol);
end.
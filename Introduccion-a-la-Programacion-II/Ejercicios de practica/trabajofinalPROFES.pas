program Telegram;

uses 
    sysutils;
type
    Usuarios = record
        Usuario: string[8];
        Password: string[8];
    end;
    
    Convers = record
        Codigo_De_Conversacion: integer;
        NombreUser1, NombreUser2: string[8];
    end;
    
    Mensajes = record
            Codigo_De_Conversacion: integer;
            Fecha_Y_Hora: string;
            Mensaje: string;
            Usuario: string[8];
            leido: boolean;
    end;

    Arbol = ^PuntArbol;
    PuntArbol = record
        Username: string[8];
        Password: string[8];
        MayorLetra, MenorLetra: Arbol;
    end;
    
    TListaMens = ^PuntListaMens;
    PuntListaMens = record
        Fecha_Y_Hora: string;
        Mensaje: string;
        User: Arbol;
        leido: boolean;
        sig: TListaMens;
    end;
    
    ListaConvers = ^PuntListaConver;
    PuntListaConver = record
        Codigo_De_Conversacion: integer; //ordena la lista ascendentemente
        PuntUser1, PuntUser2: Arbol;
        aListaMens: TListaMens;
        sig: ListaConvers;
    end;
    
    ArchUsuarios = file of Usuarios;
    
    ArchConvers = file of Convers;
    
    ArchMensajes = file of Mensajes;
    
procedure AbrirArchivoUsuario(var Users: ArchUsuarios);
begin
    {$I-} // deshabilito los errores de I/O
    reset(Users);
    {$I+} // habilito los errores de I/O
    if (ioresult <> 0) then
        Rewrite(Users);
end;

procedure AbrirArchivoConversaciones(var Conversaciones: ArchConvers);
begin
    {$I-} // deshabilito los errores de I/O
    reset(Conversaciones);
    {$I+} // habilito los errores de I/O
    if (ioresult <> 0) then
        Rewrite(Conversaciones);
end;

procedure AbrirArchivoMensajes(var Mensajes: ArchMensajes);
begin
    {$I-} // deshabilito los errores de I/O
    reset(Mensajes);
    {$I+} // habilito los errores de I/O
    if (ioresult <> 0) then
        Rewrite(Mensajes);
end;

//Modulos del Menu 2

function CantMensNoLeidos(Mensajes: TListaMens; nombre1: string): integer; 
//recorre la lista mensajes y devuelve la cant de mensajes no leidos en una conversacion
begin
    if Mensajes <> nil then
    if nombre1 <> mensajes^.user^.username then begin
        if Mensajes^.Leido = false then
            CantMensNoLeidos:= CantMensNoLeidos(Mensajes^.sig, nombre1) + 1
        else
            CantMensNoLeidos:= 0;
    end;
end;

procedure ListarConversacionesActivas(Conversaciones: ListaConvers; usuario: string);
var
    MensajesNoLeidos: integer;
begin
    if Conversaciones <> nil then begin
        if (usuario = conversaciones^.puntuser1^.username) or (usuario = conversaciones^.puntuser2^.username) then begin
            MensajesNoLeidos:= CantMensNoLeidos(Conversaciones^.aListaMens, usuario);
            if MensajesNoLeidos <> 0 then begin
                write('|Codigo de conversacion|: ');
                writeln(conversaciones^.codigo_de_conversacion);
                if usuario = conversaciones^.puntuser1^.username then begin
                    write('|Usuario|: ');
                    writeln(conversaciones^.puntuser2^.username);
                end else begin
                    writeln('|Usuario|: ');
                    writeln(conversaciones^.puntuser1^.username);
                end;
                writeln('|Cantidad de mensajes no leidos|: ', MensajesNoLeidos);
            end;
        end;
    ListarConversacionesActivas(conversaciones^.sig, usuario);
    end;
end;

procedure ListarTodasConvers(arbusuarios: Arbol; conversaciones: ListaConvers);
begin
    if conversaciones <> nil then begin
        if arbusuarios^.username = conversaciones^.puntuser1^.username then begin
            write('|Codigo de converscacion|: ');
            writeln(conversaciones^.Codigo_De_Conversacion);
            write('|Usuario|: ');
            writeln(conversaciones^.PuntUser2^.Username);
        end;
        if arbusuarios^.username = conversaciones^.puntuser2^.username then begin
            write('|Codigo de converscacion|: ');
            writeln(conversaciones^.Codigo_De_Conversacion);
            write('|Usuario|: ');
            writeln(conversaciones^.PuntUser1^.Username);
        end;
    ListarTodasConvers(arbusuarios, conversaciones^.sig);
    end;
end;

procedure MarcarComoLeido(ListaMensajes: Tlistamens; nombre: string);
begin
    if (ListaMensajes <> nil) then
        if (ListaMensajes^.leido = false) and (Listamensajes^.user^.username <> nombre) then begin
            ListaMensajes^.leido:= true;
            MarcarComoLeido(ListaMensajes^.sig, nombre);
        end;
end;

procedure MostrarUltimosNoLeidos(Mensajes: TListaMens; contador, max: integer; nombre: string);
//muestra los ultimos mensajes no leidos, si no coinciden con el "rango" se le agregan leidos tambien
begin
    if Mensajes <> nil then begin
        writeln();
        if (Mensajes^.Leido = false) or (contador <= max) then begin
            MostrarUltimosNoLeidos(Mensajes^.sig, contador + 1, max, nombre);
            write('|Fecha y hora|: ');
            writeln(Mensajes^.fecha_y_hora);
            write('|Mensaje|: ');
            writeln(Mensajes^.Mensaje);
            write('|Usuario|: ');
            writeln(Mensajes^.user^.username);
            writeln('|Visto|: ', Mensajes^.leido);
            MarcarComoLeido(Mensajes, nombre);
        end;
    end;
end;

procedure VerUltimosMensajes(Conversaciones: ListaConvers; nombre: string);
var
    CodigoConver: integer;
begin
    writeln('Ingrese el codigo de conversacion: ');
    readln(CodigoConver);
    if Conversaciones <> nil then begin
        while (conversaciones <> nil) and (conversaciones^.codigo_de_conversacion <> CodigoConver) do
            conversaciones:= conversaciones^.sig;
        if conversaciones <> nil then
            MostrarUltimosNoLeidos(conversaciones^.alistamens, 1, 10, nombre)
    end else
        writeln('No hay mensajes');
end;

procedure MostrarMensajes(Mensajes: tlistamens);
begin
    if (mensajes <> nil) then begin
        MostrarMensajes(Mensajes^.sig);
        writeln();
        write('|Fecha y hora|: ');
        writeln(Mensajes^.fecha_y_hora);
        writeln();
        write('|Mensaje|: ');
        writeln(Mensajes^.Mensaje);
        writeln();
        write('|Usuario|: ');
        writeln(Mensajes^.user^.username);
        writeln();
        writeln('|Visto|: ', mensajes^.leido);
    end;
end;

procedure VerConver(conver: ListaConvers; nombre_usuario: string);
var
    chatsito: listaconvers;
    code: integer;
begin
    writeln('Ingrese codigo de la conversacion que desea leer: ');
    readln(code);
    while (conver <> nil) and (conver^.codigo_de_conversacion <> code) do
            conver:= conver^.sig;
    if (conver <> nil) then begin
        MostrarMensajes(conver^.alistamens);
        MarcarComoLeido(conver^.alistamens, nombre_usuario);
    end;
end;

procedure CrearNodoListaMensaje(var ListaMensajes: Tlistamens; usuario1: arbol);
var
    nodomensaje: tlistamens;
    mensaje: string;
begin
    writeln('Ingrese el mensaje que quiere enviar: ');
    readln(mensaje);
    new(nodomensaje);
    nodomensaje^.fecha_y_hora:= DateTimeToStr(now);
    nodomensaje^.user:= usuario1;
    nodomensaje^.leido:= false;
    writeln(nodomensaje^.leido);
    nodomensaje^.Mensaje:= mensaje;
    nodomensaje^.sig:= ListaMensajes;
    ListaMensajes:= nodomensaje;
end;

procedure ContestarMensaje(conver: listaconvers; nombre2: string; arbusuarios: arbol; code: integer);
begin
    writeln('Ingrese el codigo de la conversacion que quiere contestar: ');
    readln(code);
    while (conver <> nil) and (code <> conver^.codigo_de_conversacion) do
            conver:= conver^.sig;
    if conver = nil then
        writeln('No existe tal conversacion')
    else begin
        MostrarUltimosNoLeidos(conver^.alistamens, 1, 5, nombre2);
        if (conver^.puntuser1^.username = nombre2) or (conver^.puntuser2^.username = nombre2) then begin
            if (conver^.puntuser1^.username = nombre2) then
                CrearNodoListaMensaje(conver^.alistamens, conver^.puntuser1)
            else
                CrearNodoListaMensaje(conver^.alistamens, conver^.puntuser2);
        end;
    end;
end;

function ExisteConver(Conver: ListaConvers; Nombre1, Nombre2: string): ListaConvers;
begin
    if Conver <> nil then begin
        if (Conver^.PuntUser1^.Username = Nombre1) and (Conver^.PuntUser2^.Username = Nombre2) then
            ExisteConver:= Conver
        else
        if (Conver^.PuntUser2^.Username = Nombre1) and (Conver^.PuntUser1^.Username = Nombre2) then
            ExisteConver:= Conver
        else
            ExisteConver:= ExisteConver(Conver^.sig, Nombre1, Nombre2)
    end else
        ExisteConver:= nil;
end;

function DevuelvePuntUser(arbusuarios: arbol; Nombre: string): Arbol;
begin
    if (arbusuarios <> nil) then begin
        if nombre = arbusuarios^.username then
            DevuelvePuntUser:= arbusuarios
        else
            if arbusuarios^.username < nombre then
                DevuelvePuntUser:= DevuelvePuntUser(arbusuarios^.mayorletra, nombre)
            else
                DevuelvePuntUser:= DevuelvePuntUser(arbusuarios^.menorletra, nombre);
    end else
        DevuelvePuntUser:= nil;
end;

procedure CrearConver(var Conver: ListaConvers; nombre1, nombre2: string; arbusuarios: arbol; code: integer);
begin
    new(Conver);
    Conver^.sig:= nil;
    Conver^.alistamens:= nil;
    Conver^.Codigo_De_Conversacion:= code + 1;
    Conver^.puntuser1:= DevuelvePuntUser(arbusuarios, nombre1);
    Conver^.puntuser2:= DevuelvePuntUser(arbusuarios, nombre2);
end;

procedure NuevaConver(ArbUsuarios: arbol; conver: ListaConvers; nombre1: string);
var
    nombre2: string[8];
begin
    writeln('Ingrese el usuario con el que quiere hablar');
    readln(nombre2);
        if ExisteConver(Conver, Nombre1, Nombre2) = nil then begin
            while conver^.sig <> nil do 
                conver:= conver^.sig;
            CrearConver(conver^.sig, nombre1, nombre2, arbusuarios, conver^.codigo_de_conversacion);
        end else
            writeln('La conversacion ya existe');
end;

{function NodoAnteriorListaMens(listamensajes: tlistamens; nodomsj: tlistamens): TlistaMens;
begin
    if listamensajes <> nil then
        if listamensajes^.sig <> nodomsj then
            NodoAnteriorListaMens := NodoAnteriorListaMens(listamensajes, nodomsj)
        else
            NodoAnteriorListaMens := listamensajes;
end;

function NodoAnteriorListaConver(conver: listaconvers): listaconvers;
begin
    if conver <> nil then
        if conver^.sig^.sig = nil then
           NodoAnteriorListaConver:= NodoAnteriorListaConver(conver);
end;


procedure EliminarListaMensajes(var ListaMensajes: tlistamens); //funciona
var
    ant, nodo: tlistamens;
begin
    writeln('PROBLEMA EN ELIMINAR LISTA MENSAJES');
    if Listamensajes <> nil then begin
        EliminarListaMensajes(ListaMensajes^.sig);
        ant:= NodoAnteriorListaMens(nodo, listamensajes);
        writeln('ant');
        if ant = nil then begin
            dispose(Listamensajes);
            Listamensajes:= nil;
        end else begin
            dispose(ant^.sig);
            ant^.sig:= nil;
        end;
    end;
end;

procedure EliminarNodoConver (ArbUsuarios: arbol; var conver: ListaConvers; codigo_conver: integer);
var
    ant: listaconvers;
begin
    writeln('ERROR EN ELIMINAR NODO CONVER');
    ant:= NodoAnteriorListaConver(conver);
    if conver <> nil then begin
        if  codigo_conver = conver^.codigo_de_conversacion then begin
            ant^.sig:= conver^.sig^.sig;
            conver^.sig:= nil;
            dispose(conver);
        end;
    end;
end;

Procedure BuscaReemplazo(var nodo, cambiar: arbol);
begin
   if (nodo^.mayorletra = nil) then begin
        cambiar := nodo;
        nodo := nodo^.menorletra;
    end else
        BuscaReemplazo(nodo^.mayorletra, cambiar);
end;

Procedure BorrarNodo(var aBorrar: arbol);
var 
    cambiar: arbol;
begin
    if (aBorrar^.mayorletra <> nil) and (aBorrar^.menorletra <> nil) then begin
        BuscaReemplazo(aBorrar^.menorletra, cambiar);
        cambiar^.menorletra := aBorrar^.menorletra;
        cambiar^.mayorletra := aBorrar^.mayorletra;
    end else 
    if (aBorrar^.menorletra = nil) then
        cambiar := aBorrar^.mayorletra
    else begin
        cambiar := aBorrar^.menorletra;
        dispose(aBorrar);
        aBorrar := cambiar;
    end;
end;

Procedure Borrar(var arbusuarios: arbol; nombre: string);
begin
    if (nil <> arbusuarios) then
        if (nombre = arbusuarios^.username) then
            BorrarNodo(arbusuarios)
        else
            if (nombre > arbusuarios^.username) then
                Borrar(arbusuarios^.mayorletra, nombre)
            else
                Borrar(arbusuarios^.menorletra, nombre);
end;

procedure BorrarUsuario(var ArbUsuarios: arbol; var conver: ListaConvers; nombre: string);
begin
    EliminarListaMensajes(conver^.alistamens);
    EliminarNodoConver(arbusuarios, conver, conver^.codigo_de_conversacion);
    Borrar(arbusuarios, nombre);
end;}

procedure LogOut();
begin
end;

procedure mostrarmenu2();
begin
    writeln('-> (1) Listar Conversaciones Activas');
    writeln('-> (2) Listar Todas Las Conversaciones');
    writeln('-> (3) Ver Ultimos Mensajes');
    writeln('-> (4) Ver Conversacion');
    writeln('-> (5) Contestar Mensaje');
    writeln('-> (6) Nueva Conversacion');
    writeln('-> (7) Borrar Usuario');
    writeln('-> (8) Log Out');
end;

procedure Menu2(conver: ListaConvers; userarbol: arbol; var arbusuarios: arbol);
var
    num: integer;
begin
    num:= 0;
    while num <> 8 do begin
        writeln();
        writeln('                       <------MENU2------>');
        writeln();
        mostrarmenu2();
        writeln();
        writeln('Ingrese una opcion: ');
        readln(num);
        if num = 1 then
            ListarConversacionesActivas(conver, userarbol^.username)
        else
        if num = 2 then
            ListarTodasConvers(userarbol, conver)
        else
        if num = 3 then
            VerUltimosMensajes(conver, userarbol^.username)
        else
        if num = 4 then
            VerConver(conver, userarbol^.username)
        else
        if num = 5 then
            ContestarMensaje(conver, userarbol^.username, arbusuarios, conver^.codigo_de_conversacion)
        else
        if num = 6 then 
            NuevaConver(arbusuarios, conver, userarbol^.username)
        else
        if num = 7 then
            //BorrarUsuario(arbusuarios, conver, userarbol^.username)
        else
        if num = 8 then begin
            writeln();
            writeln('Usted ha cerrado su sesion');
            LogOut();
        end;
    end;
end;

//Modulos 

{procedure CargarArchivo1 (var archarbol: ArchUsuarios);
    var
        dato: Usuarios;
        n:integer;
    begin
        seek(archarbol, 0);
        for N:= 1 to 5 do
            begin
                writeln('Ingrese el usuario: ');
                readln(dato.usuario);
                writeln('Digite su contraseña: ');
                readln(dato.password);
                write(archarbol, dato);
            end;
    end;
    procedure CargarArchivo2(var conver:archconvers);
    var
        dato: convers;
        n: integer;
    begin
        seek(conver, 0);
        for n:= 1 to 6 do
            begin
                writeln('Ingrese el codigo de la conversacion: ');
                readln(dato.Codigo_De_Conversacion);
                writeln('Ingrese el usuario1: ');
                readln(dato.NombreUser1);
                writeln('Ingrese el otro usuario2: ');
                readln(dato.NombreUser2);
                write(conver, dato);
            end;
    end;
    
    procedure cargararchivo3 (var Mensajitos: ArchMensajes);
    var
        dato: Mensajes;
        n: integer;
    begin
        seek(Mensajitos, 0);
        for n:= 1 to 8 do 
            begin
                writeln('Ingrese el codigo de la conversacion: ');
                readln(dato.codigo_de_conversacion);
                dato.fecha_y_Hora:= DateTimeToStr(Now);
                writeln('Ingrese el mensaje: ');
                readln(dato.mensaje);
                writeln('Usuario que envia el mensaje: ');
                readln(dato.usuario);
                dato.leido:= false;
                write(Mensajitos, dato);
            end;
    end;}

procedure InsertarArbol(var arbusuarios: Arbol; dato: usuarios);
begin
    if (arbusuarios = nil) then begin
        new(arbusuarios);
        arbusuarios^.Username:= dato.usuario;
        arbusuarios^.Password:= dato.password;
        arbusuarios^.MayorLetra:= nil;
        arbusuarios^.MenorLetra:= nil;
    end else
    if (arbusuarios^.Username < dato.usuario) then
        InsertarArbol(arbusuarios^.MayorLetra, dato)
    else
        InsertarArbol(arbusuarios^.MenorLetra, dato);
end;

procedure VuelcaArchivoEnArbol(var arbusuarios: Arbol; var Users: ArchUsuarios);
var 
    persona: usuarios;
    nuevousuario: arbol;
begin
    reset(Users);
    while not eof(Users) do begin
        read(Users, persona);
        InsertarArbol(arbusuarios, persona);
        nuevousuario:= nil;
    end;
    close(users);
end;


procedure InsertarListaConversacion(var Lista: ListaConvers; Nombre1, Nombre2: string; codigo: integer; arbusuarios: arbol);
begin
    if (Lista = nil) then begin
        new(Lista);
        Lista^.Codigo_De_Conversacion:= codigo;
        Lista^.PuntUser1:= DevuelvePuntUser(arbusuarios, Nombre1);
        Lista^.PuntUser2:= DevuelvePuntUser(arbusuarios, Nombre2);
        Lista^.sig:= nil;
        Lista^.alistamens:= nil;
    end else
        InsertarListaConversacion(Lista^.sig, Nombre1, Nombre2, codigo, arbusuarios);
end;
        
procedure VuelcaArchivoEnListaConver(var conver: ListaConvers; var conversa: ArchConvers; arbusuarios: arbol);
var
    Conversacion: convers;
begin
    reset(conversa);
    while not eof(conversa) do begin
        read(conversa, Conversacion);
        InsertarListaConversacion(conver, Conversacion.NombreUser1, Conversacion.NombreUser2, Conversacion.Codigo_De_Conversacion, arbusuarios);
    end;
    close(conversa);
end;

procedure CrearListaMensajesAlInicio (var Mensajes: TListaMens; sms: mensajes; personita: arbol);
var
    nodomensaje: tlistamens;
begin
    new(nodomensaje);
    nodomensaje^.fecha_y_hora:= sms.fecha_y_hora;
    nodomensaje^.user:= personita;
    nodomensaje^.leido:= sms.leido;
    nodomensaje^.Mensaje:= sms.mensaje;
    nodomensaje^.sig:= Mensajes;
    Mensajes:= nodomensaje;
end;

procedure VuelcaArchivoEnListaMens(conver: ListaConvers; var Mens: ArchMensajes; arbusuarios: arbol);
var
    sms: Mensajes;
    personita: arbol;
begin
    reset(Mens);
    while not eof(Mens) do begin
        read(Mens, sms);
        personita:= DevuelvePuntUser(arbusuarios, sms.usuario);
        if (sms.codigo_de_conversacion = conver^.codigo_de_conversacion) then
            CrearListaMensajesAlInicio(conver^.aListaMens, sms, personita)
        else begin
            while (conver <> nil) and (sms.codigo_de_conversacion <> conver^.codigo_de_conversacion) do
                conver:= conver^.sig;
            if (sms.codigo_de_conversacion = conver^.codigo_de_conversacion) then
                CrearListaMensajesAlInicio(conver^.aListaMens, sms, personita);
        end;
    end;
    close(mens);
end;

procedure imprimirarbolinorder(arbusuarios: Arbol);
begin
    if arbusuarios <> nil then begin
        imprimirarbolinorder(arbusuarios^.menorletra);
        writeln(arbusuarios^.username);
        imprimirarbolinorder(arbusuarios^.mayorletra);
    end;
end;

procedure ImprimirListaConv (lista:listaconvers);
        procedure ImprimirListaMensajes (lista:tlistamens);
            begin
                if (lista <> nil) then
                    begin
                        writeln ('|FechaHora: ', lista^.fecha_y_hora, '| Mensaje: ', lista^.mensaje, '| Enviado por: ', lista^.User^.username, '| Visto: ', lista^.leido);
                        writeln();
                        ImprimirListaMensajes (lista^.sig);
                    end;
            end;
    begin
        if (lista <> nil) then
            begin
                writeln ('CODE conversacion --> ', lista^.Codigo_De_Conversacion);
                writeln ('USER 1 --> ', lista^.Puntuser1^.username);
                writeln ('USER 2 --> ', lista^.Puntuser2^.username);
                //if lista^.alistamens <> nil then
                ImprimirListaMensajes (lista^.aListaMens);
                ImprimirListaConv (lista^.sig);
            end;
    end;

//Modulos del Menu1

function VerificaUsuario(arbusuarios: arbol; usuario: string): Arbol;
begin
    if (arbusuarios <> nil) then
        if (Arbusuarios^.Username = usuario) then begin
            VerificaUsuario:= arbusuarios;
           writeln('El Usuario existe');
        end else 
            if (usuario < arbusuarios^.Username) then
                VerificaUsuario := VerificaUsuario(arbusuarios^.menorLetra, usuario)
            else
                VerificaUsuario := VerificaUsuario(arbusuarios^.mayorLetra, usuario)
    else begin
        VerificaUsuario:= nil;
        writeln('El usuario no existe');
    end;
end;

procedure NuevoUsuario(var arbusuarios: arbol);
var
    username: string[8];
    password: string[8];
    dato: usuarios;
begin
    writeln('Ingrese un nuevo usuario de hasta 8 caracteres: ');
    readln(username);
    writeln('Ingrese su contrasenia de hasta 8 caracteres: ');
    readln(password);
    if (VerificaUsuario(arbusuarios, username)) = nil then begin
        dato.usuario:= username;
        dato.password:= password;
        InsertarArbol(arbusuarios, dato);
    end;
end;

{procedure GeneraListaConversAux();
begin

end;

procedure MuestraListaConverAux();
begin

end;

procedure user_hiperconnect;//(ListaConvers: ); //muestra el listado en orden de conversacion (mayor a menor)
begin

end;}

procedure CopiarArbol_en_ArchivoArbol(var Users: ArchUsuarios; ArbUsuarios: Arbol);
var
    Persona: Usuarios;
begin
    if ArbUsuarios <> nil then begin
        persona.usuario:= arbusuarios^.username;
        persona.password:= arbusuarios^.password;
        write(Users, Persona);
        CopiarArbol_en_ArchivoArbol(Users, ArbUsuarios^.MayorLetra);
        CopiarArbol_en_ArchivoArbol(Users, ArbUsuarios^.MenorLetra);
    end;
end;

procedure CopiarListaMens_en_ArchivoListaMens(var Mens: ArchMensajes; Listmens: Tlistamens; codigo: integer); //el primero del archivo es el ultimo de la lista
var
    Mensajitos: Mensajes;
begin
    if Listmens <> nil then begin
        CopiarListaMens_en_ArchivoListaMens(Mens, Listmens^.sig, codigo);
        Mensajitos.Codigo_De_Conversacion:= codigo;
        Mensajitos.leido:= Listmens^.leido;
        Mensajitos.usuario:= Listmens^.user^.username;
        Mensajitos.fecha_y_hora:= Listmens^.fecha_y_hora;
        Mensajitos.mensaje:= Listmens^.mensaje;
        write(Mens, Mensajitos);
    end;
end;

procedure CopiarListaConvers_en_ArchivoListaConvers(var AConvers: ArchConvers; LConversaciones: ListaConvers; var mensajes: archmensajes);
var
    Conversacion: Convers;
begin
    if LConversaciones <> nil then begin
        Conversacion.Codigo_De_Conversacion:= LConversaciones^.Codigo_De_Conversacion;
        Conversacion.NombreUser1:= LConversaciones^.PuntUser1^.username;
        Conversacion.NombreUser2:= LConversaciones^.PuntUser2^.username;
        write(AConvers, Conversacion);
        CopiarListaMens_en_ArchivoListaMens(mensajes, Lconversaciones^.aListamens, Lconversaciones^.Codigo_De_Conversacion);
        CopiarListaConvers_en_ArchivoListaConvers(Aconvers, LConversaciones^.sig, mensajes);
    end;
end;

procedure Salir(arbusuarios: arbol; mens: TListaMens; conver: ListaConvers; var Users: ArchUsuarios; var Convers: ArchConvers; var Mensajes: ArchMensajes);
begin
    assign (users, '/work/ArbolTomasito.dat');
    assign (convers,'/work/ConverTomas.dat');
    assign (mensajes, '/work/MensajesTomas.dat');
    rewrite(users);
    rewrite(convers);
    rewrite(mensajes);
    CopiarArbol_en_ArchivoArbol(Users, arbusuarios);
    CopiarListaConvers_en_ArchivoListaConvers(Convers, conver, mensajes);
    close(users);
    close(convers);
    close(mensajes);
end;

procedure Login(arbusuarios: arbol; Conver: ListaConvers); //llama al menu 2 si se verifico correctamente el usuario
var
    usuario, contrasenia: string[8];
    user: arbol;
begin
    writeln('Ingrese un usuario');
    readln(usuario);
    writeln('Ingrese la contrasenia');
    readln(contrasenia);
    if (arbusuarios <> nil) then begin
        user:= DevuelvePuntUser(arbusuarios, usuario);
        if (user = nil) then
            writeln('El usuario no existe')
        else
            if user^.password = contrasenia then begin
                writeln();
                writeln('--------El usuario existe, Bienvenido, que desea hacer?--------');
                Menu2(Conver, user, arbusuarios);
            end else
                writeln('La contraseña ingresada es incorrecta');
    end;
end;

procedure mostrar1();
begin
    writeln('    |Bienvenido a Telegram S.A|     ');
    writeln();
    writeln('<------MENU1------>');
    writeln();
    writeln('--> (1) Login');
    writeln();
    writeln('--> (2) Nuevo Usuario');
    writeln();
    writeln('--> (3) Lista Usuarios HiperConectados');
    writeln();
    writeln('--> (4) Salir');
    writeln();
end;

procedure Menu1(var arbusuarios: arbol; var Lista: ListaConvers; var Users: ArchUsuarios; var Convers: ArchConvers; var Mensajes: ArchMensajes; var Mensaj: TListaMens);
var
    num: integer;
begin
    num:= 0;
    while num <> 4 do begin
        mostrar1();
        writeln('Ingrese una opcion: ');
        readln(num);
        if num = 1 then
            Login(arbusuarios, Lista)
        else
        if num = 2 then
            begin
                NuevoUsuario(arbusuarios);
                imprimirarbolinorder(arbusuarios);
            end      
        //else
        //if num = 3 then
            //user_hiperconnect()
        else
        if num = 4 then begin
            writeln();
            writeln('----Usted salió, gracias por utilizar nuestros servicios----');
            Salir(arbusuarios, Mensaj, Lista, Users, Convers, Mensajes);
        end;
    end;
end;

//Programa Principal // los mensajes aparecen en falso, pueden probar viendolos y cambiar su estado

var
    ArbUsuarios: Arbol;
    Conver: ListaConvers;
    archarbol: archusuarios;
    archconver: archconvers;
    archmens: archmensajes;
begin
    assign (archarbol, '/work/ArbolTomasito.dat');
    assign (archconver,'/work/ConverTomas.dat');
    assign (archmens, '/work/MensajesTomas.dat');
    //rewrite(archarbol);
    //rewrite(archconver);
    AbrirArchivoUsuario(archarbol);
    //writeln('------Cargue el archivo de usuarios------');
    AbrirArchivoConversaciones(archconver);
    //CargarArchivo1(archarbol);
    //writeln('------Cargue al archivo de conversaciones------');
    //CargarArchivo2(archconver);
    AbrirArchivoMensajes(archmens);
    //writeln('------Cargue mensajes------');
    //rewrite(archmens);
    //cargararchivo3(archMens);
    VuelcaArchivoEnArbol(ArbUsuarios, archarbol);
    VuelcaArchivoEnListaConver(conver, archconver, arbusuarios);
    VuelcaArchivoEnListaMens(conver, archmens, arbusuarios);
    //writeln('Arbol Ordenado: ');
    //imprimirarbolinorder(arbusuarios);
    writeln();
    //ImprimirListaConv(conver);
    Menu1(arbusuarios, conver, archarbol, archconver, archmens, conver^.aListaMens);
end.
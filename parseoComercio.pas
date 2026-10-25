program parseoArca;
uses
    crt;
type
      tCon = record
               cuil : string[13];
               nom : string[30]; // Apellido y nombre
               mail : string[30];
               cel : string[15];
               clfis : string[10];
               dir : string[30];
               tipocont : char;
               activo : boolean;
           End;
    tArc = file Of tCon;

    // El reintegro
     Treintegro = record
      cuilcontribuyente: string[13];
      nroresolucion: integer;
      montoreintegro: real;
      estado: string[15];
      activo: boolean;
   end;
   Tarchrei = file of Treintegro;

   // Las compras
   tCompras = record
         idCom: integer;
         cuilCli: string[13]; // FK - contribuyente
         fecha: string[10];
         des: string[50];
         montoTotal: real;
         medioPago: string[15]; // Efectivo, debito, credito, etc.
         activo: boolean;
       end;
    TarchCom = file of tCompras;

var
    con : tCon;   // Archivos de contribuyentes
    archReintegro:Tarchrei; // Archivos de reintegros
    archBin : tArc; //Archivos de contribuyentes
    rei : Treintegro; // Registro de reintegro
    archCom: TarchCom; // Archivos de compras
    com: tCompras;// Registro de compras

    //archText: text;
    opc : char; // Menu

function existeCuil(cuilbuscado: string[13]): boolean;
var
  tmp:tCon; // Archivo de contribuyente

  begin
       existeCuil := false;
       reset(archBin);//Abrir el contribuyente

       while not eof(archBin) do begin
           read(archBin, tmp);
           if(tmp.cuil = cuilbuscado) and tmp.activo then begin
               existeCuil:= true;
               break;
           end;
         end;
         close(archBin);
         reset(archBin); // Volver a abrir
       end;

function formatoCuil (cuil:string):string;
begin  //Cuando escribas 20323423234 y en pantalla aparezca 20-32342323-4
     formatoCuil := copy(cuil,1,2)+'-'+copy(cuil,3,8)+'-'+copy(cuil,11,1);
end;

function formatoCel(cel:string):string;
begin
     //Cuando escribas 1122334455 aparezca en pantalla 11-2233-4455
     formatoCel:= copy(cel,1,2) +'-'+ copy(cel,3,4)+'-'+copy(cel,7,4);
end;


procedure altaDatos();

var
   numcuil : string[13];

begin

   reset(archBin);

   write('CUIT/CUIL: ');
   readln(numcuil);

   while numcuil <> '*' do
   begin

      { Validar longitud del CUIL }
      while (length(numcuil) <> 11) and (numcuil <> '*') do
      begin
         textcolor(white);
         textbackground(red);
         write('CUIL incorrecto, ingrese otro: ');
         textcolor(white);
         textbackground(black);
         readln(numcuil);
      end;

      if numcuil = '*' then
         break;

      con.cuil := formatoCuil(numcuil);

      { Verificar si el CUIL ya existe }
      if existeCuil(con.cuil) then
      begin
         textcolor(white);
         textbackground(yellow);
         writeln('El CUIL ya existe.');
         textcolor(white);
         textbackground(black);

         write('CUIT/CUIL: ');
         readln(numcuil);
      end
      else begin
         write('Nombre: ');
         readln(con.nom);

         write('Mail: ');
         readln(con.mail);

         write('Celular: ');
         readln(con.cel);

         while length(con.cel) <> 10 do begin
              textcolor(white);
              textbackground(red);
              write('Telefono incorrecto, ingrese otro: ');
              textcolor(white);
              textbackground(black);
              readln(con.cel);
         end;

         con.cel := formatoCel(con.cel);

         write('Clave Fiscal: ');
         readln(con.clfis);
         write('Direccion: ');
         readln(con.dir);

         repeat
            write('Tipo de Contribuyente (R/M): ');
            readln(con.tipocont);

            con.tipocont := upcase(con.tipocont);
            textcolor(white);
            textbackground(red);
            writeln('tipo de contribuyente no existe: ');
            textcolor(white);
            textbackground(black);
         until (con.tipocont = 'R') or (con.tipocont = 'M');

         con.activo := true;

         seek(archBin, filesize(archBin));
         write(archBin, con);

         writeln;
         textcolor(white);
         textbackground(green);
         writeln('Contribuyente registrado correctamente.');
         textcolor(white);
         textbackground(black);

         writeln;

         write('CUIT/CUIL: ');
         readln(numcuil);

      end; // cierre else

   end; // cierre while

   close(archBin);

end;

procedure bajaDatos();
    var
        numcuil : string[13];
        encontrado : boolean;
    begin
        reset(archBin);
        write('Ingrese el CUIT/CUIL del contribuyente a eliminar: ');
        readln(numcuil);
        encontrado := false;
        seek(archBin, 0);
        while not eof(archBin) and not encontrado do begin
            read(archBin, con);
            //writeln(con.cuil);
            //readkey;
            if (con.cuil = numcuil) and (con.activo = true) then begin
                con.activo := false;
                seek(archBin, filepos(archBin) - 1); // Retrocedemos una posici?n
                write(archBin, con);
                encontrado := true;
                writeln('El Contribuyente ha sido eliminado correctamente.');
            end;
        end;
        close(archBin);
        
        if not encontrado then
            writeln('El contribuyente no se encuentra.');
    end;

procedure buscarDatos();
var
    numcuil : string[13];
    encontrado : boolean;
    pos : longint;
begin
    reset(archBin);
    write('Ingrese el CUIT/CUIL a buscar: ');
    readln(numcuil);
    encontrado := false;
    
    while not eof(archBin) and not encontrado do begin
        pos := filepos(archBin); // Guardamos la posici?n del registro en el archivo
        read(archBin, con);
        if (con.cuil = numcuil) and con.activo then begin
            encontrado := true;
            writeln('Direccion de Registro Posicion: ', pos);
            writeln('-------------------------------------');
            writeln('CUIT/CUIL             |', con.cuil);
            writeln('Nombre                |', con.nom);
            writeln('Mail                  |', con.mail);
            writeln('Celular               |', con.cel);
            writeln('Clave Fiscal          |', con.clfis);
            writeln('Direccion             |', con.dir);
            writeln('Tipo de Contribuyente:|',con.tipocont);
            writeln('-------------------------------------');
        end;
    end;
    close(archBin);
    
    if not encontrado then begin
        textcolor(red);
        writeln('El contribuyente no existe o esta inactivo.');
        textcolor(white);
        end;
    writeln;
    textcolor(yellow);
    writeln('Presiona un boton para salir');
    textcolor(white);
    readkey;
end;

procedure modificarDatos();
var
    numcuil : string[13];
    encontrado : boolean;
    pos : longint;
    opcMod : char;
begin
    reset(archBin);
    write('Ingrese el CUIT/CUIT del contribuyente a modificar: ');
    readln(numcuil);
    encontrado := false;
    
    while not eof(archBin) and not encontrado do begin
        pos := filepos(archBin);
        read(archBin, con);
        if (con.cuil = numcuil) and con.activo then begin
            encontrado := true;
            repeat
            clrscr;

            textcolor(yellow);
                writeln('Direccion de Registro Posicion: ', pos);
                writeln('--- Menu de Modificacion ---');
                writeln('1. Nombre: ', con.nom);
                writeln('2. Mail: ', con.mail);
                writeln('3. Celular: ', con.cel);
                writeln('4. Clave Fiscal: ', con.clfis);
                writeln('5. Direccion: ', con.dir);
                writeln('6. Tipo de Contribuyente (R/M): ', con.tipocont);
                writeln('0. Guardar y Salir');
                write('Elija el campo a cambiar: ');
                readln(opcMod);
                textcolor(white);
                
                case opcMod of
                    '1': begin 
                            write('Nuevo Nombre (',con.nom,'): ');
                            readln(con.nom);
                         end;

                    '2': begin
                            write('Nuevo Mail (',con.mail,'): ');
                            readln(con.mail);
                         end;
                    '3': begin
                            write('Nuevo Celular (',con.cel,'): ');
                            readln(con.cel);
                         end;
                    '4': begin
                            write('Nueva Clave Fiscal (',con.clfis,'): ');
                            readln(con.clfis);
                         end;
                    '5': begin
                            write('Nueva Direccion (',con.dir,'): ');
                            readln(con.dir);
                         end;
                    '6': begin
                            write('Nuevo Tipo de Contribuyente (R/M) (',con.tipocont,'): ');
                            readln(con.tipocont);
                         end;
                end;
            until opcMod = '0';
            seek(archBin, pos);
            write(archBin, con);
            textcolor(green);
            writeln('Registro actualizado exitosamente.');
            textcolor(white);
            readkey;
        end;
    end;
    close(archBin);
    
    if not encontrado then begin
        textcolor(red);
        writeln('El contribuyente no existe o esta inactivo.');
       textcolor(white);
       end;
end;

procedure gestionarReintegro();
var
    cuilbuscado : string[13];
    encontrado : boolean;
    montoBase :real;
    montocalculado : real;
begin
    assign(archBin, 'contribuyentes.dat');
    assign(archReintegro, 'reintegros.dat');

    {$I-}
    reset(archReintegro);
    {$I+}
    if IOResult <> 0 then
        rewrite(archReintegro);

    write('Ingrese CUIL/CUIT del contribuyente: ');
    readln(cuilbuscado);
    encontrado := false;

    reset(archBin);
    while not eof(archBin) and not encontrado do begin
        read(archBin, con);
        if (con.cuil = cuilbuscado) and con.activo then
            encontrado := true;
    end;
    close(archBin);

    if encontrado then begin
        write('Ingrese el monto base: ');
        readln(montoBase);

       if con.tipocont = 'R' then
        montocalculado := montoBase * 0.21
        else
           montocalculado := 0;

        writeln('Monto de reintegro calculado: $', montocalculado:0:2);

        // Guardar en archivo de reintegros
        seek(archReintegro, filesize(archReintegro));  // mueve el puntero al final del archivo
        rei.cuilcontribuyente := cuilbuscado; // Guarda el cuil
        rei.nroresolucion := filesize(archReintegro) + 1;   //asigna el numero de resolucion automatico
        rei.montoreintegro := montocalculado; //guarda el monto calculado
        rei.estado := 'Pendiente';
        rei.activo := true;
        write(archReintegro, rei); // Escribe el registro en el archivo

        writeln('Reintegro registrado en archivo.');
    end
    else begin
        writeln('Contribuyente no encontrado o inactivo.');
    end;

    close(archReintegro);

    writeln('Presione una tecla para continuar...');
    readkey;
end;

procedure altaCompras();
 var
    nCom: integer;
    cuilbuscado:string[13];
 begin
  assign(archCom, 'comprasclientes.dat');
   {$I-}
    reset(archCom);
    {$I+}
    if IOResult <> 0 then
        rewrite(archCom);

    write('CUIL/CUIT del cliente: ');
    readln(cuilbuscado);

   if existeCuil(cuilbuscado) then begin
      seek(archCom, filesize(archCom));
      nCom := filesize(archCom) + 1;

      com.idCom := nCom;
      com.cuilCli := cuilbuscado;

      write('Fecha de la compra: ');
      readln(com.fecha);
      write('Descripcion: ');
      readln(com.des);
      write('Monto total: ');
      readln(com.montoTotal);
      write('Medio de pago: ');
      readln(com.medioPago);
      com.activo := true;

      write(archCom, com);
      close(archCom);

      textcolor(green);
      writeln('Compra registrada correctamente');
      textcolor(white);
    end 
    else begin
         close(archCom);
         textcolor(red);
         writeln('CUIL/CUIT NO existe o esta inactivo.');
         textcolor(white);
    end;

    readkey;
end;

procedure listarCon10();
var
   posI: integer; // Posicion del inicio
   posA: integer; // Posicion actual

begin
     reset(archBin);
     if filesize(archBin) <= 10 then
         posI := 0
     else
         posI := filesize(archBin) - 10;

      seek(archBin, posI);

    textcolor(cyan);

   writeln('==============================================================================================');
   writeln('| Pos | CUIL           | Nombre                        | Celular       | Tipo |');
   writeln('==============================================================================================');
   textcolor(white);

   while not eof(archBin) do
   begin
      posA := filepos(archBin);
      read(archBin,con);
      if con.activo then
      begin

         writeln('| ',(posA-1):3,' | ',con.cuil:13,' | ',con.nom:30,' | ',con.cel:12,' | ',con.tipocont:4,' |');

      end;
   end;
   writeln('==============================================================================================');

   close(archBin);
   readkey;
end;
BEGIN
     assign (archBin, 'contribuyentes.dat');
    {$I-}
        reset(archBin);
    {$I+}
    if IOResult <> 0 then
        rewrite(archBin);
    close(archBin);
    repeat
        clrscr;
        writeln(' Menu Principal ');
        writeln(' A - Alta de Contribuyente ');
        writeln(' B - Baja de Registro ');
        writeln(' C - Busqueda de Registro ');
        writeln(' M - Modificacion de Contribuyente ');
        writeln(' R - Reintegro');
        writeln(' P - Alta Compras ');
        writeln(' L - Ultimos 10 contribuyentes');
        writeln(' T - Terminar ');
        readln(opc);
        case opc of
            'A', 'a': altaDatos();
            'B', 'b': bajaDatos();
            'C', 'c': buscarDatos();
            'M', 'm': modificarDatos();
            'R', 'r': gestionarReintegro();
            'P', 'p': altaCompras();
            'L', 'l': listarCon10();
            'T', 't': writeln('Saliendo del programa');
            else      writeln('Opcion Invalida ');
        end;
    until (opc = 'T') or (opc = 't');
    readkey;
END.

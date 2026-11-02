Program parseoArca;
uses
    crt;

Type 
       tCon = Record
              cuil : string[13];
              nom : string[30];// Apellido y nombre
              mail : string[30];
              cel : string[15];
              clfis : string[10];
              dir : string[30];
              tipocont : char;
              activo : boolean;
              End;
    tArc = file Of tCon;

    // El reintegro
     Treintegro = Record
                    cuilcontribuyente: string[13];
                    nroresolucion: integer;
                    montoreintegro: real;
                    estado: string[15];
                    activo: boolean;
                  End;
   Tarchrei = file Of Treintegro;

   // Las compras
   tCompras = Record
                idCom: integer;
                cuilCli: string[13];
                // FK - contribuyente
                fecha: string[10];
                des: string[50];
                montoTotal: real;
                medioPago: string[15];
                // Efectivo, debito, credito, etc.
                activo: boolean;
               End;
    TarchCom = file Of tCompras;

  // Escructura completa de ventas lo que pide al ARCA 
   tVenta = Record
              idVenta : longint;
              cuil : string[11];
              monto : real
   End;

   TarchVenta = file Of tVenta;

Var 
    con : tCon;// Archivos de contribuyentes
    archReintegro: Tarchrei;// Archivos de reintegros
    archBin : tArc;//Archivos de contribuyentes
    rei : Treintegro;// Registro de reintegro
    archCom: TarchCom;// Archivos de compras
    com: tCompras;// Registro de compras
    archText: text;
    venta : tVenta;// Registro de ventas
    archVenta : TarchVenta;// Archivos de ventas
     archVentaTxt : text;
      opc : char; // Menu

Function existeCuil(cuilbuscado: String[13]): boolean;

Var 
  tmp: tCon;// Archivo de contribuyente

  Begin
       existeCuil := false;
       reset(archBin);//Abrir el contribuyente

       while not eof(archBin) Do
    Begin
           read(archBin, tmp);
           If (tmp.cuil = cuilbuscado) And tmp.activo Then
             Begin
               existeCuil := true;
               break;
             End;
         End;
         close(archBin);
         reset(archBin);
    // Volver a abrir
       End;

Function formatoCuil (cuil:String[11]): string;
Begin
  //Cuando escribas 20323423234 y en pantalla aparezca 20-32342323-4
     formatoCuil := copy(cuil,1,2)+'-'+copy(cuil,3,8)+'-'+copy(cuil,11,1);
End;

Function formatoCel(cel:String): string;
Begin
     //Cuando escribas 1122334455 aparezca en pantalla 11-2233-4455
     formatoCel := copy(cel,1,2) +'-'+ copy(cel,3,4)+'-'+copy(cel,7,4);
End;

Function quitGuiones(cadena:String): string;

Var 
   i: integer;
Begin
   quitGuiones := '';

   For i:=1 To length(cadena) Do
      If cadena[i] <> '-' Then
         quitGuiones := quitGuiones + cadena[i];
End;

Procedure altaDatos();

Var 
   numcuil : string[13];

Begin

   {$I-}
   reset(archBin);
   {$I+}
   If IOResult <> 0 Then
      rewrite(archBin);

   write('CUIT/CUIL: ');
   readln(numcuil);

   while numcuil <> '*' Do
   Begin

      // Validar longitud del CUIL
      while (length(numcuil) <> 13) and (numcuil <> '*') Do
      Begin
         textcolor(white);
         textbackground(red);
         write('CUIL incorrecto, ingrese otro: ');
         textcolor(white);
         textbackground(black);
         readln(numcuil);
      End;

      If numcuil = '*' Then
         break;

      con.cuil := quitGuiones(numcuil);

      // Verificar si el CUIL ya existe
      If existeCuil(con.cuil) Then
        Begin
          textcolor(white);
          textbackground(yellow);
          writeln('El CUIL ya existe.');
          textcolor(white);
          textbackground(black);

          write('CUIT/CUIL: ');
          readln(numcuil);
        End
      Else
        Begin
          write('Nombre: ');
          readln(con.nom);

          write('Mail: ');
          readln(con.mail);

          write('Celular: ');
          readln(con.cel);

          while length(con.cel) <> 10 Do
          Begin
              textcolor(white);
              textbackground(red);
              write('Telefono incorrecto, ingrese otro (10 digitos): ');
              textcolor(white);
              textbackground(black);
              readln(con.cel);
          End;

          con.cel := quitGuiones(con.cel);

          write('Clave Fiscal: ');
          readln(con.clfis);
          write('Direccion: ');
          readln(con.dir);

          Repeat
            write('Tipo de Contribuyente (R/M): ');
            readln(con.tipocont);

            con.tipocont := upcase(con.tipocont);

            If (con.tipocont <> 'R') And (con.tipocont <> 'M') Then
              Begin
                textcolor(white);
                textbackground(red);
                writeln('Tipo de contribuyente no existe');
                textcolor(white);
                textbackground(black);
              End;

          Until (con.tipocont = 'R') Or (con.tipocont = 'M');

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

        End;
     // cierre else

   End;
  // cierre while

   close(archBin);

End;

Procedure bajaDatos();

    Var 
        numcuil : string[13];
        encontrado : boolean;
    Begin
        {$I-}
        reset(archBin);
        {$I+}
        If IOResult <> 0 Then
            rewrite(archBin);

        write('Ingrese el CUIT/CUIL del contribuyente a eliminar: ');
        readln(numcuil);
        numcuil := quitGuiones(numcuil);
        encontrado := false;
        seek(archBin, 0);
        while not eof(archBin) and not encontrado Do
      Begin
            read(archBin, con);
            If (con.cuil = numcuil) And (con.activo = true) Then
              Begin
                con.activo := false;
                seek(archBin, filepos(archBin) - 1);
                // Retrocedemos una posici?n
                write(archBin, con);
                encontrado := true;
                writeln('El Contribuyente ha sido eliminado correctamente.');
              End;
        End;
        close(archBin);

        If Not encontrado Then
            writeln('El contribuyente no se encuentra.');
    End;

Procedure buscarDatos();

Var 
    numcuil : string[13];
    encontrado : boolean;
    pos : longint;
Begin
    {$I-}
    reset(archBin);
    {$I+}
    If IOResult <> 0 Then
        rewrite(archBin);

    write('Ingrese el CUIT/CUIL a buscar: ');
    readln(numcuil);
    numcuil := quitGuiones(numcuil);
    encontrado := false;

    while not eof(archBin) and not encontrado Do
  Begin
        pos := filepos(archBin);// Guardamos la posicion del registro en el archivo
        read(archBin, con);
        If (con.cuil = numcuil) And con.activo Then
          Begin
            encontrado := true;
            writeln('Direccion de Registro Posicion: ', pos);
            writeln('-------------------------------------');
            writeln('CUIT/CUIL             |', formatoCuil(con.cuil));
            writeln('Nombre                |', con.nom);
            writeln('Mail                  |', con.mail);
            writeln('Celular               |', formatoCel(con.cel));
            writeln('Clave Fiscal          |', con.clfis);
            writeln('Direccion             |', con.dir);
            writeln('Tipo de Contribuyente:|',con.tipocont);
            writeln('-------------------------------------');
          End;
    End;
    close(archBin);

    If Not encontrado Then
      Begin
        textcolor(red);
        writeln('El contribuyente no existe o esta inactivo.');
        textcolor(white);
        End;
    writeln;
    textcolor(yellow);
    writeln('Presiona un boton para salir');
    textcolor(white);
    readkey;
End;

Procedure modificarDatos();

Var 
    numcuil : string[13];
    encontrado : boolean;
    pos : longint;
    opcMod : char;
Begin
    {$I-}
    reset(archBin);
    {$I+}
    If IOResult <> 0 Then
        rewrite(archBin);

    write('Ingrese el CUIT/CUIT del contribuyente a modificar: ');
    readln(numcuil);
    numcuil := quitGuiones(numcuil);
    encontrado := false;

    while not eof(archBin) and not encontrado Do
  Begin
        pos := filepos(archBin);
        read(archBin, con);
        If (con.cuil = numcuil) And con.activo Then
          Begin
            encontrado := true;
            Repeat
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

                Case opcMod Of
                    '1':
                         Begin
                            write('Nuevo Nombre (',con.nom,'): ');
                            readln(con.nom);
                         End;

                    '2':
                         Begin
                            write('Nuevo Mail (',con.mail,'): ');
                            readln(con.mail);
                         End;
                    '3':
                         Begin
                            write('Nuevo Celular (',con.cel,'): ');
                            readln(con.cel);
                         End;
                    '4':
                         Begin
                            write('Nueva Clave Fiscal (',con.clfis,'): ');
                            readln(con.clfis);
                         End;
                    '5':
                         Begin
                            write('Nueva Direccion (',con.dir,'): ');
                            readln(con.dir);
                         End;
                    '6':
                         Begin
                            write('Nuevo Tipo de Contribuyente (R/M) (',con.tipocont,'): '
                           );
                            readln(con.tipocont);
                         End;
                End;
            Until opcMod = '0';
            seek(archBin, pos);
            write(archBin, con);
            textcolor(green);
            writeln('Registro actualizado exitosamente.');
            textcolor(white);
            readkey;
          End;
    End;
    close(archBin);

    If Not encontrado Then
      Begin
        textcolor(red);
        writeln('El contribuyente no existe o esta inactivo.');
        textcolor(white);
       End;
End;

Procedure importarVentas();

Var 
   linea : string;
   c : integer;
   aux : string;
   codError : integer;
Begin

   assign(archVentaTxt,'ventas_banco.txt');
   reset(archVentaTxt);

   assign(archVenta,'ventas.dat');
   rewrite(archVenta);

   while not eof(archVentaTxt) Do
   Begin

      readln(archVentaTxt,linea);
      c := 1;

      // Id venta

      aux := '';
      while linea[c] <> ';' Do
      Begin
         aux := aux + linea[c];
         inc(c);
      End;

      val(aux, venta.idVenta, codError);// Convertir de un string a numero
      If codError <> 0 Then
        Begin
          writeln('Error en ID');
          readkey;
        End;
      inc(c);

      //Cuil
      venta.cuil := '';
      while linea[c] <> ';' Do
      Begin
         venta.cuil := venta.cuil + linea[c];
         inc(c);
      End;
      inc(c);

      // saltea dia
      while linea[c] <> ';' Do
         inc(c);
      inc(c);
      //saltea mes
      while linea[c] <> ';' Do
         inc(c);
      inc(c);
     //saltea anio
     while linea[c] <> ';' Do
         inc(c);
      inc(c);

     //monto
      aux := '';
      while linea[c] <> ';' Do
      Begin
         aux := aux + linea[c];
         inc(c);
      End;

      val(aux, venta.monto, codError);//Convertir un string a un numero
       If codError <> 0 Then
         Begin
           writeln('Error en monto');
           readkey;
         End;
      inc(c);


      write(archVenta, venta);

        { writeln('ID: ', venta.idVenta);
         writeln('CUIL-T: ', venta.cuil);
         writeln('MONTO: ', venta.monto:0:2);
         writeln('----------------');
      readkey;}
   End;

   close(archVentaTxt);
   close(archVenta);

   writeln('Ventas importadas correctamente');
   readkey;

End;

Procedure listarUltimasVentas();

Var 
   posI : integer;
   posA : integer;
Begin
   assign(archVenta,'ventas.dat');
   reset(archVenta);

   If filesize(archVenta) >= 10 Then
      posI := 0
   Else
      posI := filesize(archVenta) - 10;

   seek(archVenta, posI);

   writeln('==================================================');
   writeln('| Pos | ID Venta | CUIL-T        | Monto          |');
   writeln('==================================================');

   while not eof(archVenta) Do
   Begin
      posA := filepos(archVenta);
      read(archVenta, venta);

      writeln('| ',posA:3,' | ',venta.idVenta:8,' | ',venta.cuil:11,' | $',venta.monto:10:2,' |');
   End;

   writeln('==================================================');

   close(archVenta);
   readkey;
End;


Procedure generarReintegro();

Var
   encontrado : boolean;

Begin

   { Archivos }

   assign(archVenta,'ventas.dat');
   assign(archBin,'contribuyentes.dat');
   assign(archReintegro,'reintegros.dat');

   reset(archVenta);
   reset(archBin);

   {$I-}
   reset(archReintegro);
   {$I+}

   if IOResult <> 0 then
      rewrite(archReintegro);

   { Recorre todas las ventas }

   while not eof(archVenta) do
   begin

      read(archVenta, venta);

      encontrado := false;

      { Buscar contribuyente }

      seek(archBin,0);

      while not eof(archBin) and not encontrado do
      begin

         read(archBin, con);

        { writeln('Venta: ', venta.cuil);
         writeln('Contribuyente: ', con.cuil);
         readkey;}

         if (con.cuil = venta.cuil) and con.activo then
         begin

           { writeln('COINCIDE');
            writeln('VENTA: ', venta.cuil);
            writeln('CONTRIBUYENTE: ', con.cuil);
            writeln('ACTIVO: ', con.activo);
            writeln('TIPO: ', con.tipocont);
            readkey;}

            encontrado := true;

         end;

      end;

      { Si encontró }

      if encontrado then
      begin

         { Solo responsables }

         if con.tipocont = 'R' then
         begin

            {writeln('ENCONTRO RESPONSABLE');
            writeln('CUIL: ', con.cuil);
            writeln('MONTO: ', venta.monto:0:2);
            readkey;}

            rei.cuilcontribuyente := venta.cuil;
            seek(archReintegro, filesize(archReintegro));
            rei.nroresolucion := filesize(archReintegro)+1;
            rei.montoreintegro := venta.monto * 0.21;
            rei.estado := 'pendiente';
            rei.activo := true;

            {writeln('GUARDANDO REINTEGRO');
            writeln('CUIL: ', rei.cuilcontribuyente);
            writeln('RESOLUCION: ', rei.nroresolucion);
            writeln('MONTO: ', rei.montoreintegro:0:2);
            readkey;}


              write(archReintegro, rei);


         end;

      end;

   end;

   close(archVenta);
   close(archBin);
   close(archReintegro);

   writeln;
   writeln('Reintegro exitoso');
   readkey;

End;

Procedure listarUltimosReintegros();

Var 
   posI : integer;
   posA : integer;
Begin
   assign(archReintegro,'reintegros.dat');
   reset(archReintegro);

   If filesize(archReintegro) >= 10 Then
      posI := 0
   Else
      posI := filesize(archReintegro);

   seek(archReintegro, posI);

   writeln('===================================================================');
   writeln('| Pos | CUIL-T        | Resolucion | Reintegro      | Estado       |');
   writeln('===================================================================');

   while not eof(archReintegro) Do
   Begin
      posA := filepos(archReintegro);
      read(archReintegro, rei);

      If rei.activo Then
        Begin
          writeln('| ',posA:3,' | ',rei.cuilcontribuyente:11,' | ',rei.nroresolucion:10,' | $',rei.montoreintegro:12:2,' | ',rei.estado:12,' |');
        End;
   End;

   writeln('===================================================================');

   close(archReintegro);
   readkey;
End;

Procedure altaCompras();

 Var 
    nCom: integer;
    cuilbuscado: string[13];
 Begin
   assign(archCom, 'comprasclientes.dat');
   {$I-}
    reset(archCom);
    {$I+}
    If IOResult <> 0 Then
        rewrite(archCom);

    write('CUIL/CUIT del cliente: ');
    readln(cuilbuscado);
    cuilbuscado := quitGuiones(cuilbuscado);

   If existeCuil(cuilbuscado) Then
     Begin
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
     End
    Else
      Begin
         close(archCom);
         textcolor(red);
         writeln('CUIL/CUIT NO existe o esta inactivo.');
         textcolor(white);
      End;

    readkey;
End;

Procedure listarCon10();

Var 
   posI: integer;
  // Posicion del inicio
   posA: integer;
  // Posicion actual

Begin
     {$I-}
     reset(archBin);
     {$I+}
     If IOResult <> 0 Then
         rewrite(archBin);

     If filesize(archBin) >= 10 Then
         posI := 0
     Else
         posI := filesize(archBin);

      seek(archBin, posI);

    textcolor(cyan);

   writeln('===============================================================================');
   writeln('| Pos| CUIL-T           | Nombre                        | Celular       | Tipo ');
   writeln('===============================================================================');
   textcolor(white);

   while not eof(archBin) Do
   Begin
      posA := filepos(archBin);
      read(archBin,con);
      If con.activo Then
        Begin
          writeln('| ',posA:3,' | ',formatoCuil(con.cuil): 11,'  | ',con.nom: 30,' | ',formatoCel(con.cel): 12,' | ',con.tipocont:4,' |');
        End;
   End;
   writeln('===============================================================================');

   close(archBin);
   readkey;
End;

Procedure importarDesdeTxt();

Var 
   linea : string;
   c : integer;

Begin
   assign(archText,'contribuyentes.txt');
   reset(archText);

   assign(archBin,'contribuyentes.dat');
   rewrite(archBin);

   while not eof(archText) Do
   Begin
      readln(archText,linea);

      c := 1;

      con.cuil := '';
      while linea[c] <> ';' Do
      Begin
         con.cuil := con.cuil + linea[c];
         inc(c);
      End;
      inc(c);

      con.nom := '';
      while linea[c] <> ';' Do
      Begin
         con.nom := con.nom + linea[c];
         inc(c);
      End;
      inc(c);

      con.mail := '';
      while linea[c] <> ';' Do
      Begin
         con.mail := con.mail + linea[c];

         inc(c);
      End;
      inc(c);

      con.cel := '';
      while linea[c] <> ';' Do
      Begin
         con.cel := con.cel + linea[c];
         inc(c);
      End;

      inc(c);

      con.clfis := '';
      while linea[c] <> ';' Do
      Begin
         con.clfis := con.clfis + linea[c];
         inc(c);

      End;

      inc(c);

      con.dir := '';
      while linea[c] <> ';' Do
      Begin
         con.dir := con.dir + linea[c];
         inc(c);

      End;

      inc(c);

      con.tipocont := linea[c];

      con.cuil := quitGuiones(con.cuil);
      con.cel := quitGuiones(con.cel);

      con.activo := true;

      write(archBin,con);
   End;

   close(archText);
   close(archBin);

   writeln('Importacion finalizada correctamente');
   readkey;
End;

Begin
     assign (archBin, 'contribuyentes.dat');
    {$I-}
        reset(archBin);
    {$I+}
    If IOResult <> 0 Then
        rewrite(archBin);
    close(archBin);
    Repeat
        clrscr;
        writeln(' Menu Principal ');
        writeln(' A - Alta de Contribuyente ');
        writeln(' B - Baja de Registro ');
        writeln(' C - Busqueda de Registro ');
        writeln(' M - Modificacion de Contribuyente ');
        writeln(' R - Reintegro');
        writeln(' P - Alta Compras ');
        writeln(' L - Listado contribuyentes');
        writeln(' U - Listado ventas');
        writeln(' E - Listado reintegros');
        writeln(' I - Importar TXT ');
        writeln(' V - Importar Ventas');
        writeln(' T - Terminar ');
        readln(opc);
        Case opc Of
            'A', 'a': altaDatos();
            'B', 'b': bajaDatos();
            'C', 'c': buscarDatos();
            'M', 'm': modificarDatos();
            'R', 'r': generarReintegro();
            'P', 'p': altaCompras();
            'L', 'l': listarCon10();
            'U', 'u': listarUltimasVentas();
            'E','e' : listarUltimosReintegros();
            'I', 'i': importarDesdeTxt();
            'V', 'v': importarVentas();
            'T', 't': writeln('Saliendo del programa');
            Else      writeln('Opcion Invalida ');
        End;
    Until (opc = 'T') Or (opc = 't');
    readkey;
End.

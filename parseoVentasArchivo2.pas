program parseoVentasArchivo2;
uses
    crt;
type
   Treintegro = record
                cuilcontribuyente     : string[13];
                nroresolucion      : integer;
                montoreintegro      : integer;
                estado     : string[15];
                activo : boolean;
                end;
    Tarchrei = file of Treintegro;

var
   regVentas  : Treintegro;
   archivo : text;
   archVentas : Tarchrei;
   linea   : string;
   cLin, c, i : integer;
   auxStr  : string;
   coderr    : integer;

// Cuerpo del programa
BEGIN
     assign(archivo, 'ventas_arca.txt');
     reset(archivo);
     assign(archVentas, 'ventas_arca1.dat');
     rewrite(archVentas);
     writeln('Detalle de ventas / ARCA');
     cLin := 0;
     
     // Ciclo de lectura del archivo de texto
     while not eof(archivo) do
     begin
          readln(archivo, linea);
          inc(cLin);
          writeln('Nro ', cLin, ':');
          c := 1;
          //Recuperación del CUIL/CUIT
          regVentas.cuilcontribuyente := '';
          while linea[c] <> ';' do
          begin
               regVentas.cuilcontribuyente := regVentas.cuilcontribuyente + linea[c];
               inc(c);
          end;
          for i := 1 to 13-length(regVentas.cuilcontribuyente) do
               regVentas.cuilcontribuyente := regVentas.cuilcontribuyente + ' ';
          inc(c);
          //Recuperación del Número de Resolución
          auxStr := '';
          while linea[c] <> ';' do
          begin
               auxStr := auxStr + linea[c];
               inc(c);
          end;
          val(auxStr, regVentas.nroresolucion, coderr);
          inc(c);
          //Recuperación del Monto
          auxStr := '';
          while linea[c] <> ';' do
          begin
               auxStr := auxStr + linea[c];
               inc(c);
          end;
          val(auxStr, regVentas.montoreintegro, coderr);
          inc(c);

          regVentas.activo := true;
          //Recuperación del Estado del Contribuyente
          regVentas.estado := '';
          while linea[c] <> ';' do
          begin
               regVentas.estado := regVentas.estado + linea[c];
               inc(c);
          end;
          for i := 1 to 13-length(regVentas.estado) do
               regVentas.estado := regVentas.estado + ' ';
          inc(c);
          // Impresión de datos
          writeln('       CUIL/CUIT:    ', regVentas.cuilcontribuyente);
          writeln('       Numero de Resolucion:        ', regVentas.nroresolucion);
          writeln('       Monto:        ', regVentas.montoreintegro);
          writeln('       Estado:        ', regVentas.estado);
          writeln('----------------------------------');
          write(archVentas, regVentas);
     end;
     close(archivo);
     close(archVentas);
     writeln('Parseo a binario finalizado con exito.');
     readkey;
END.

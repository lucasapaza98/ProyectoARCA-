program parseoVentas;
uses
    crt;
type
    t_RegVenta = record
                 nroVenta : longint;
                 cuil     : string[13];
                 dia      : integer;
                 mes      : integer;
                 anio     : integer;
                 monto    : real;
                 tipoPago : string[15];
                 desc     : string[50];
                 activo : boolean;
                 end;
    t_ArVenta = file of t_RegVenta;

var
   regVen  : t_RegVenta;
   archivo : text;
   arVenta : t_ArVenta;
   linea   : string;
   cLin, c, i : integer;
   auxStr  : string;
   coderr    : integer;

// Cuerpo del programa
BEGIN
     assign(archivo, 'ventas_arca.txt');
     reset(archivo);
     assign(arVenta, 'ventas_arca.dat');
     rewrite(arVenta);
     writeln('Detalle de ventas / ARCA');
     cLin := 0;
     
     // Ciclo de lectura del archivo de texto
     while not eof(archivo) do
     begin
          readln(archivo, linea);
          inc(cLin);
          writeln('Nro ', cLin, ':');
          c := 1;
          //Recuperación del Número de Venta
          auxStr := '';
          while linea[c] <> ';' do
          begin
               auxStr := auxStr + linea[c];
               inc(c);
          end;
          val(auxStr, regVen.nroVenta, coderr);
          inc(c);
          //Recuperación del CUIL/CUIT
          regVen.cuil := '';
          while linea[c] <> ';' do
          begin
               regVen.cuil := regVen.cuil + linea[c];
               inc(c);
          end;
          for i := 1 to 13-length(regVen.cuil) do
               regVen.cuil := regVen.cuil + ' ';
          inc(c);
          //Recuperación del Día
          auxStr := '';
          while linea[c] <> ';' do
          begin
               auxStr := auxStr + linea[c];
               inc(c);
          end;
          val(auxStr, regVen.dia, coderr);
          inc(c);
          //Recuperación del Mes
          auxStr := '';
          while linea[c] <> ';' do
          begin
               auxStr := auxStr + linea[c];
               inc(c);
          end;
          val(auxStr, regVen.mes, coderr);
          inc(c);
          //Recuperación del Año
          auxStr := '';
          while linea[c] <> ';' do
          begin
               auxStr := auxStr + linea[c];
               inc(c);
          end;
          val(auxStr, regVen.anio, coderr);
          inc(c);
          //Recuperación del Monto
          auxStr := '';
          while linea[c] <> ';' do
          begin
               auxStr := auxStr + linea[c];
               inc(c);
          end;
          val(auxStr, regVen.monto, coderr);
          inc(c);
          //Recuperación del Tipo de Pago
          regVen.tipoPago := '';
          while linea[c] <> ';' do
          begin
               regVen.tipoPago := regVen.tipoPago + linea[c];
               inc(c);
          end;
          for i := 1 to 15-length(regVen.tipoPago) do
               regVen.tipoPago := regVen.tipoPago + ' ';
          inc(c);
          //Recuperación de la Descripción
          regVen.desc := '';
          while linea[c] <> ';' do
          begin
               regVen.desc := regVen.desc + linea[c];
               inc(c);
          end;
          for i := 1 to 50-length(regVen.desc) do
               regVen.desc := regVen.desc + ' ';
          inc(c);
          regVen.activo := true;
          //Impresión de datos
          writeln('       Nro Venta:    ', regVen.nroVenta);
          writeln('       CUIL/CUIT:    ', regVen.cuil);
          writeln('       Fecha:        ', regVen.dia, '/', regVen.mes, '/', regVen.anio);
          writeln('       Monto:        ', regVen.monto:0:2);
          writeln('       Tipo Pago:    ', regVen.tipoPago);
          writeln('       Descripcion:  ', regVen.desc);
          writeln('----------------------------------');
          write(arVenta, regVen);
     end;
     close(archivo);
     close(arVenta);
     writeln('Parseo a binario finalizado con exito.');
     readkey;
END.

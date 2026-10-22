program parseoContrib;
uses
    crt;
type
    t_RegCont = record
               cuil : string[13];
               nom : string[30]; // Apellido y nombre
               mail : string[30];
               cel : string[15];
               clfis : string[10];
               dir : string[30];
               tipocont : char;
               activo : boolean;
                end;

    t_ArCont = file of t_RegCont;

var
   regCon  : t_RegCont;
   archivo : text;
   arCont  : t_ArCont;
   linea   : string;
   cLin , c, i :integer;

//Procedimientos

//Cuerpo del programa
BEGIN
     assign(archivo , 'contribuyentes.txt');
     reset(archivo);
     assign(arCont, 'contribuyentes.dat');
     rewrite(arCont);
     writeln('Detalle de contribuyente');
     cLin := 0;
     // Ciclo de lectura del archivo
     while not eof(archivo) do
     begin
          readln(archivo , linea);
          inc(cLin);
          writeln('Nro ' , cLin, ':');
          c := 1;
          //Recuperacion del CUIL CUIT
          regCon.cuil := '';
          while linea[c] <> ';' do
          begin
               regCon.cuil := regCon.cuil + linea[c];
               inc(c);
          end;
          inc(c);
          //Recuperacion del nombre
          regCon.nom := '';
          while linea[c] <> ';' do
          begin
               regCon.nom := regCon.nom + linea[c];
               inc(c);
          end;
          for i := 1 to 30-length(regCon.nom) do
              regCon.nom := regCon.nom + ' ';
          inc(c);
          // Recuperacion del mail
          regCon.mail := '';
          while linea[c] <> ';' do
          begin
               regCon.mail := regCon.mail + linea[c];
               inc(c);
          end;
          for i := 1 to 30-length(regCon.mail) do
              regCon.mail := regCon.mail + ' ';
          inc(c);
          // Recuperacion del celular
          regCon.cel := '';
          while linea[c] <> ';' do
          begin
               regCon.cel := regCon.cel + linea[c];
               inc(c);
          end;
          for i := 1 to 15-length(regCon.cel) do
              regCon.cel := regCon.cel + ' ';
          inc(c);
          // Recuperacion de clave fiscal
          regCon.clfis := '';
          while linea[c]<>';' do
          begin
               regCon.clfis := regCon.clfis + linea[c];
               inc(c);
          end;
          for i := 1 to 10-length(regCon.clfis) do
              regCon.clfis := regCon.clfis + ' ';
          inc(c);
          // Recuperacion de direcci?n
          regCon.dir := '';
          while linea[c] <> ';' do
          begin
               regCon.dir := regCon.dir + linea[c];
               inc(c);
          end;
          for i := 1 to 30-length(regCon.dir) do
              regCon.dir := regCon.dir + ' ';
          inc(c);
          regCon.tipocont := linea[c];
          regCon.activo := true;
          // Impresion de datos
          writeln('       CUIL/CUIT:       ',regCon.cuil);
          writeln('       Apellido Nombre: ',regCon.nom);
          writeln('       Mail:            ',regCon.mail);
          writeln('       Celular:         ',regCon.cel);
          writeln('       Clave Fiscal:    ',regCon.clfis);
          writeln('       Direcci?n:       ',regCon.dir);
          writeln('       Tipo Contrib:    ',regCon.tipocont);
          writeln('----------------------------------');
          readkey;
          write(arCont, regCon);
     end;
     close(archivo);
     close(arCont);
     readkey;
END.


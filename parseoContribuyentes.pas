program parseoContrib;
uses
    crt;
type
    t_RegCont = record
                cuiLT  : string[13];
                apeNom,
                mail,
                direc  : string[30];
                celu   : string[15];
                claveF : string[10];
                tipoCon: char;
                end;
    t_ArCont = file of t_RegCont;

var
   regCon  : t_RegCont;
   archivo : text;
   arCont  : t_ArCont;
   linea   : string;
   cLin , c :integer;

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
          regCon.cuiLT := '';
          while linea[c] <> ';' do
          begin
               regCon.cuiLT := regCon.cuiLT + linea[c];
               inc(c);
          end;
          inc(c);
          //Recuperacion del nombre
          regCon.apeNom := '';
          while linea[c] <> ';' do
          begin
               regCon.apeNom := regCon.apeNom + linea[c];
               inc(c);
          end;
          inc(c);
          // Recuperacion del mail
          regCon.mail := '';
          while linea[c] <> ';' do
          begin
               regCon.mail := regCon.mail + linea[c];
               inc(c);
          end;
          inc(c);
          // Recuperacion del celular
          regCon.celu := '';
          while linea[c] <> ';' do
          begin
               regCon.celu := regCon.celu + linea[c];
               inc(c);
          end;
          inc(c);
          // Recuperacion de clave fiscal
          regCon.claveF := '';
          while linea[c]<>';' do
          begin
               regCon.claveF := regCon.claveF + linea[c];
               inc(c);
          end;
          inc(c);
          // Recuperacion de dirección
          regCon.direc := '';
          while linea[c] <> ';' do
          begin
               regCon.direc := regCon.direc + linea[c];
               inc(c);
          end;
          inc(c);
          regCon.tipoCon := linea[c];
          // Impresion de datos
          writeln('       CUIL/CUIT:       ',regCon.cuiLT);
          writeln('       Apellido Nombre: ',regCon.apeNom);
          writeln('       Mail:            ',regCon.mail);
          writeln('       Celular:         ',regCon.celu);
          writeln('       Clave Fiscal:    ',regCon.claveF);
          writeln('       Dirección:       ',regCon.direc);
          writeln('       Tipo Contrib:    ',regCon.tipoCon);
          writeln('----------------------------------');
          write(arCont, regCon);
     end;
     close(archivo);
     close(arCont);
     readkey;
END.



Program parseoContrib;
uses
    crt;

Type 
    t_RegCont = Record
                  cuiLT  : string[13];
                  apeNom,
                  mail,
                  direc  : string[30];
                  celu   : string[15];
                  claveF : string[10];
                  tipoCon: char;
                End;
    t_ArCont = file Of t_RegCont;

Var 
   regCon  : t_RegCont;
   archivo : text;
   arCont  : t_ArCont;
   linea   : string;
   cLin , c : integer;

   //Procedimientos

  //Cuerpo del programa
Begin
     assign(archivo , 'contribuyentes.txt');
     reset(archivo);
     assign(arCont, 'contribuyentes.dat');
     rewrite(arCont);
     writeln('Detalle de contribuyente');
     cLin := 0;
     // Ciclo de lectura del archivo
     while not eof(archivo) Do
     Begin
          readln(archivo , linea);
          inc(cLin);
          writeln('Nro ' , cLin, ':');
          c := 1;
          //Recuperacion del CUIL CUIT
          regCon.cuiLT := '';
          while linea[c] <> ';' Do
          Begin
               regCon.cuiLT := regCon.cuiLT + linea[c];
               inc(c);
          End;
          inc(c);
          //Recuperacion del nombre
          regCon.apeNom := '';
          while linea[c] <> ';' Do
          Begin
               regCon.apeNom := regCon.apeNom + linea[c];
               inc(c);
          End;
          inc(c);
          // Recuperacion del mail
          regCon.mail := '';
          while linea[c] <> ';' Do
          Begin
               regCon.mail := regCon.mail + linea[c];
               inc(c);
          End;
          inc(c);
          // Recuperacion del celular
          regCon.celu := '';
          while linea[c] <> ';' Do
          Begin
               regCon.celu := regCon.celu + linea[c];
               inc(c);
          End;
          inc(c);
          // Recuperacion de clave fiscal
          regCon.claveF := '';
          while linea[c]<>';' Do
          Begin
               regCon.claveF := regCon.claveF + linea[c];
               inc(c);
          End;
          inc(c);
          // Recuperacion de direcci�n
          regCon.direc := '';
          while linea[c] <> ';' Do
          Begin
               regCon.direc := regCon.direc + linea[c];
               inc(c);
          End;
          inc(c);
          regCon.tipoCon := linea[c];
          // Impresion de datos
          writeln('       CUIL/CUIT:       ',regCon.cuiLT);
          writeln('       Apellido Nombre: ',regCon.apeNom);
          writeln('       Mail:            ',regCon.mail);
          writeln('       Celular:         ',regCon.celu);
          writeln('       Clave Fiscal:    ',regCon.claveF);
          writeln('       Direcci�n:       ',regCon.direc);
          writeln('       Tipo Contrib:    ',regCon.tipoCon);
          writeln('----------------------------------');
          write(arCont, regCon);
     End;
     close(archivo);
     close(arCont);
     readkey;
End.

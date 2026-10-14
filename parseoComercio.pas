
Program parseoArca;

uses
    crt;


Type 
      tCon = Record
               nom : string[30];
               ape : string[30];
               cuil : string[13];
               cel : string[10];
               dir : string[30];
               mail : string[30];
               clfis : string[10];
               tipocont : char;
               activo : boolean;
           End;
    tArc = file Of tCon;

Var 
    con : tCon;
    archBin : tArc;
    archText: text;
    opc : char;

Procedure altaDatos();

    Var 
        numcuil : string[13];
        Begin
            reset(archBin);
            seek(archBin, filesize(archBin));
            write('CUIT/CUIL: ');
            readln(numcuil);
            while numcuil <> '*' Do
          Begin
                con.cuil := numcuil;
                write('Nombre: ');
                readln(con.nom);
                write('Apellido: ');
                readln(con.ape);
                write('Celular: ');
                readln(con.cel);
                write('Direccion: ');
                readln(con.dir);
                write('Mail: ');
                readln(con.mail);
                write('Clave Fiscal: ');
                readln(con.clfis);
                write('Tipo de Contribuyente (R/M): ');
                readln(con.tipocont);
                con.activo := true;
                write(archBin, con);
                write('CUIT/CUIL: ');
                readln(numcuil);
            End;
            close(archBin);
        End;

Procedure importarDesdeTxt();

Var linea : string;
    c, cLin : integer;
Begin
    assign(archTxt, 'contribuyentes.txt');
    reset(archTxt);
    assign(archBin, 'contribuyentes.dat');
    rewrite(archBin);
    cLin := 0;

    while not eof(archTxt) Do
  Begin
        readln(archTxt, linea);
        inc(cLin);
        c := 1;

        // Parseo campo por campo
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

        con.ape := '';
        while linea[c] <> ';' Do
    Begin
            con.ape := con.ape + linea[c];
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
        con.activo := true;

        write(archBin, con);
    End;

    close(archTxt);
    close(archBin);
    writeln('Importaci�n desde TXT finalizada.');

End;

Begin

End.

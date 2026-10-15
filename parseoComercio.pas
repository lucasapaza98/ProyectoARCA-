Program parseoArca;
uses
    crt;
Type
      tCon = Record
               nom : string[30];
               ape : string[30];
               cuil : string[13];
               cel : string[15];
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
    // archText: text;
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
            writeln(con.cuil);
            readkey;
            if (con.cuil = numcuil) and (con.activo = true) then begin
                con.activo := false;
                seek(archBin, filepos(archBin) - 1); // Retrocedemos una posición
               // write(archBin, con);
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
        pos := filepos(archBin); // Guardamos la posición del registro en el archivo
        read(archBin, con);
       // if (con.cuil = numcuil) and con.activo then begin
            encontrado := true;
            writeln('Direccion de Registro Posicion: ', pos);
            writeln('CUIT/CUIL: ', con.cuil);
            writeln('Nombre: ', con.nom);
            writeln('Apellido: ', con.ape);
            writeln('Celular: ', con.cel);
            writeln('Direccion: ', con.dir);
            writeln('Mail: ', con.mail);
            writeln('Clave Fiscal: ', con.clfis);
            writeln('Tipo de Contribuyente: ', con.tipocont);
        //end;
    end;
    close(archBin);
    
    if not encontrado then
        writeln('El contribuyente no existe o esta inactivo.');
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
                writeln('Direccion de Registro Posicion: ', pos);
                writeln('--- Menu de Modificacion ---');
                writeln('1. Nombre: ', con.nom);
                writeln('2. Apellido: ', con.ape);
                writeln('3. Celular: ', con.cel);
                writeln('4. Direccion: ', con.dir);
                writeln('5. Mail: ', con.mail);
                writeln('6. Clave Fiscal: ', con.clfis);
                writeln('7. Tipo de Contribuyente (R/M): ', con.tipocont);
                writeln('0. Guardar y Salir');
                write('Elija el campo a cambiar: ');
                readln(opcMod);
                
                case opcMod of
                    '1': begin 
                            write('Nuevo Nombre: '); 
                            readln(con.nom);
                         end;
                    '2': begin 
                            write('Nuevo Apellido: '); 
                            readln(con.ape);
                         end;
                    '3': begin 
                            write('Nuevo Celular: '); 
                            readln(con.cel);
                         end;
                    '4': begin 
                            write('Nueva Direccion: '); 
                            readln(con.dir);
                         end;
                    '5': begin 
                            write('Nuevo Mail: '); 
                            readln(con.mail);
                         end;
                    '6': begin 
                            write('Nueva Clave Fiscal: ');
                            readln(con.clfis);
                         end;
                    '7': begin 
                            write('Nuevo Tipo de Contribuyente (R/M): ');
                            readln(con.tipocont);
                         end;
                end;
            until opcMod = '0';
            seek(archBin, pos);
            write(archBin, con);
            writeln('Registro actualizado exitosamente.');
        end;
    end;
    close(archBin);
    
    if not encontrado then
        writeln('El contribuyente no existe o esta inactivo.');
end;


{Procedure importarDesdeTxt();   Procedimiento de Parseo y Transformación de Datos de Texto a Binario

Var linea : string;
    c, cLin : integer;
Begin
    assign(archText, 'contribuyentes.txt');
    reset(archText);
    assign(archBin, 'contribuyentes.dat');
    reset(archBin);
    cLin := 0;

    while not eof(archText) Do
    Begin
        readln(archText, linea);
        inc(cLin);
        c := 1;

        // Parseo campo por campo

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

        con.cuil := '';
        while linea[c] <> ';' Do
        Begin
            con.cuil := con.cuil + linea[c];
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

        con.dir := '';
        while linea[c] <> ';' Do
        Begin
            con.dir := con.dir + linea[c];
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

        con.clfis := '';
        while linea[c] <> ';' Do
        Begin
            con.clfis := con.clfis + linea[c];
            inc(c);
        End;
        inc(c);

        con.tipocont := linea[c];
        con.activo := true;

        write(archBin, con);
    End;

    close(archText);
    close(archBin);
    writeln('Importacion desde TXT finalizada.');


End;
}
BEGIN
     assign (archBin, 'contribuyentes.dat');
    {$I-}
        reset(archBin);
    {$I+}
    if IOResult <> 0 then
        rewrite(archBin);
    close(archBin);
    repeat
        writeln(' Menu Principal ');
        writeln(' A - Alta de Contribuyente ');
        writeln(' B - Baja de Registro ');
        writeln(' C - Busqueda de Registro ');
        writeln(' M - Modificacion de Contribuyente ');
        writeln(' T - Terminar ');
        readln(opc);
        case opc of
            'A', 'a': altaDatos();
            'B', 'b': bajaDatos();
            'C', 'c': buscarDatos();
            'M', 'm': modificarDatos();
            'T', 't': writeln('Saliendo del programa');
            else      writeln('Opcion Invalida ');
        end;
    until (opc = 'T') or (opc = 't');
    readkey;
END.

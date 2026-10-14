program Agenda;
uses
    crt;
type
    tCon = record
           nom : string[30];
           ape : string[30];
           cuil : string[13];
           cel : string[10];
           dir : string[30];
           mail : string[30];
           clfis : string[10];
           tipocont : char;
           activo : boolean;
           end;
    tArc = file of tCon;
var
    con : tCon;
    arch : tArc;
    opc : char;

procedure altaDatos();
    var
        numcuil : string[13];
        begin
            reset(arch);
            seek(arch, filesize(arch));
            write('CUIT/CUIL: ');
            readln(numcuil);
            while numcuil <> '*' do begin
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
                write(arch, con);
                write('CUIT/CUIL: ');
                readln(numcuil);
            end;
            close(arch);
        end;

procedure bajaDatos();
    var
        numcuil : string[13];
        encontrado : boolean;
    begin
        reset(arch);
        write('Ingrese el CUIT/CUIL del contribuyente a eliminar: ');
        readln(numcuil);
        encontrado := false;
        
        while not eof(arch) and not encontrado do begin
            read(arch, con);
            if (con.cuil = numcuil) and (con.activo = true) then begin
                con.activo := false;
                seek(arch, filepos(arch) - 1); // Retrocedemos una posición
                write(arch, con);
                encontrado := true;
                writeln('El Contribuyente ha sido eliminado correctamente.');
            end;
        end;
        close(arch);
        
        if not encontrado then
            writeln('El contribuyente no se encuentra.');
    end;

procedure buscarDatos();
var
    numcuil : string[13];
    encontrado : boolean;
    pos : longint;
begin
    reset(arch);
    write('Ingrese el CUIT/CUIL a buscar: ');
    readln(numcuil);
    encontrado := false;
    
    while not eof(arch) and not encontrado do begin
        pos := filepos(arch); // Guardamos la posición del registro en el archivo
        read(arch, con);
        if (con.cuil = numcuil) and con.activo then begin
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
        end;
    end;
    close(arch);
    
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
    reset(arch);
    write('Ingrese el CUIT/CUIT del contribuyente a modificar: ');
    readln(numcuil);
    encontrado := false;
    
    while not eof(arch) and not encontrado do begin
        pos := filepos(arch);
        read(arch, con);
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
            seek(arch, pos);
            write(arch, con);
            writeln('Registro actualizado exitosamente.');
        end;
    end;
    close(arch);
    
    if not encontrado then
        writeln('El contribuyente no existe o esta inactivo.');
end;

BEGIN
    assign (arch, 'contribuyentes.txt');
    {$I-}
        reset(arch);
    {$I+}
    if IOResult <> 0 then
        rewrite(arch);
    close(arch);
    repeat
        clrscr;
        writeln(' Menu Principal ');
        writeln(' A - Alta de Contribuyente ');
        writeln(' B - Baja de Registro ');
        writeln(' C - Busqueda de Registro ');
        writeln(' M - Modificacion de Contribuyente ');
        writeln(' T - Terminar ');
        readln(opc);
        case upcase(opc) of
            'A': altaDatos();
            'B': bajaDatos();
            'C': buscarDatos();
            'M': modificarDatos();
            'T': writeln('Saliendo del programa');
            else
             writeln('Opcion Invalida ');
        end;
    until (opc = 'T') or (opc = 't');
    readkey;
END. 

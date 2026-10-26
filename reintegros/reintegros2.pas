Program reintegros;

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
    archBin : tArc;
    opc : char;

{ --- PROCEDIMIENTO DE REINTEGRO --- }
procedure gestionarReintegro();
var
    cuilbuscado : string[13];
    encontrado : boolean;
    montoCalculado : real;
begin
    clrscr;
    writeln('=== MODULO DE REINTEGROS ARCA ===');
    write('Ingrese CUIT/CUIL del contribuyente: ');
    readln(cuilbuscado);
    
    assign(archBin, 'contribuyentes.dat');
    {$I-}
    reset(archBin);
    {$I+}
    if IOResult <> 0 then begin
        writeln('Error: No se encuentra el archivo "contribuyentes.dat". Asegurese de haberlo creado antes.');
        exit;
    end;
    
    encontrado := false;
    
    while not eof(archBin) and not encontrado do begin
        read(archBin, con);
        if (con.cuil = cuilbuscado) and con.activo then begin
            encontrado := true;
        end;
    end;
    
    close(archBin);
    
    if not encontrado then begin
        writeln;
        writeln('El contribuyente no se encuentra o esta inactivo.');
    end 
    else begin
        writeln;
        writeln('Contribuyente encontrado: ', con.nom, ' ', con.ape);
        writeln('Tipo de Contribuyente: ', con.tipocont);
        
        if con.tipocont = 'R' then
            montoCalculado := 50000.00
        else
            montoCalculado := 20000.00;
            
        writeln('Monto de reintegro calculado: $', montoCalculado:0:2);
    end;
    
    writeln;
    writeln('Presione una tecla para continuar...');
    readkey;
end;

{ --- PROGRAMA PRINCIPAL INDEPENDIENTE --- }
BEGIN
    repeat
        clrscr;
        writeln('=== MENU REINTEGROS ===');
        writeln('1 - Procesar Reintegro');
        writeln('2 - Salir');
        write('Seleccione una opcion: ');
        readln(opc);
        
        case opc of
            '1': gestionarReintegro();
            '2': writeln('Saliendo del programa...');
            else 
                writeln('Opcion invalida.');
        end;
        
        if opc <> '2' then begin
            writeln;
            write('Presione una tecla para volver...');
            readkey;
        end;
    until opc = '2';
END.

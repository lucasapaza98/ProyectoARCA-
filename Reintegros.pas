Program reintegros;
uses
    crt;
type
   tContribuyente = record
      cuil : string[13];
      tipocont : char;
      activo : boolean;
   end;

   treintegro = record
      cuilcontribuyente : string[13];
      nroresolucion     : integer;
      montoreintegro    : real;
      estado            : string[15];
      activo            : boolean;
   end;
  
var
   arch : file of tContribuyente;
   con  : tContribuyente;

procedure gestionarReintegro();
var
    cuilbuscado : string[13];
    encontrado : boolean;
    montocalculado : real;
begin
    reset(archBin);
    write('Ingrese CUIL/CUIT del contribuyente: ');
    readln(cuilbuscado);
    encontrado := false;

    while not eof(archBin) and not encontrado do begin
        read(archBin, con);
        if (con.cuil = cuilbuscado) and con.activo then
            encontrado := true;
    end;
    close(archBin);

    if encontrado then begin
        if con.tipocont = 'R' then
            montocalculado := 50000.00
        else
            montocalculado := 20000.00;

        writeln('Monto de reintegro calculado: $', montocalculado:0:2);
    end
    else
        writeln('Contribuyente no encontrado o inactivo.');

    writeln('Presione una tecla para continuar...');
    readkey;
end;

BEGIN
   gestionarReintegro();
   readkey;
END.


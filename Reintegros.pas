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
   assign(arch, 'contribuyentes.dat');

   repeat
      clrscr;
      writeln('=== MODULO DE REINTEGROS ARCA ===');
      write('Ingrese CUIL/CUIT (o 0 para salir): ');
      readln(cuilbuscado);

      if cuilbuscado <> '0' then begin
         reset(arch);
         encontrado := false;

         while not eof(arch) and not encontrado do begin
            read(arch, con);
            if (con.cuil = cuilbuscado) and con.activo then begin
               encontrado := true;
            end;
         end;

         close(arch);

         if encontrado then begin
            if con.tipocont = 'R' then
               montocalculado := 50000.00
            else
               montocalculado := 20000.00;

            writeln('Monto de reintegro calculado: $', montocalculado:0:2);
         end
         else
            writeln('Contribuyente no encontrado o inactivo.');

         writeln;
         writeln('Presione una tecla para continuar...');
         readkey;
      end;
   until cuilbuscado = '0';
end;

BEGIN
   gestionarReintegro();
   readkey;
END.


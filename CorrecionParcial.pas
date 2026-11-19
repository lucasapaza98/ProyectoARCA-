program CoreccionParcial;
uses
    crt;
type
    tRegMae = record
              cuilt : string[11];
              nom : string [30];
              end;
    tArcMae = file of tRegMae;

    tRegMov = record
              cuilt : string[11];
              importe : longint;
              end;
    tArcMae = file of tRegMov;
var
   regMae : tRegMov;
   arcMae : tArcMae;
   regMov : tRegMov;
   arcMov : tArcMov;

procedure verResumen(regCli : tRegMae);
var
   cant : integer;
   total : longint;
begin
     cant := 0;
     total := 0;
     reset(arcMov);
     while not eof(arcMov) do begin
           read(arcMov, regMov);
           if regMov.cuilt = regCli.cult then begin
              cant := cant + 1;
              total := total + regMov.importe;
           end;
     end;
     close(arcMov);

     if cant > 0 then
        writeln(regCli.nom, ' realizo ', cant, ' transacciones por ', total, ' pesos ');
end; // Procedure

procedure conMovimientos();
begin
     reset(arcMae);
     while not eof(arcMae) do begin
           read(arcMae, regMae);
           verResumen (regMae);
     end;
     close(arcMae);
end;

function movimientos(cuilt : string[11]) : integer;
         var
            cant : integer;
         begin
              cant := 0;
              reset(arcMov);
              while not eof(arcMov) do begin
                    read(arcMov, regMov);
                    if regMov.cuilt = cuilt then
                       cant := cant + 1;
              end;
              close(arcMov);
              movimientos := cant;
         end;

procedure sinMovimientos();
begin
     reset(arcMae);
     while not eof(arcMae) do begin
           read(arcMae, regMae);
           if movimientos(regMae.cuilt) = 0 then
              writeln(regMae.cuilt, regMae.nom);
     end;
     close(arcMae);
end;

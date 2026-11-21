program CorreccionParcial;
uses
    crt;
type
    tRegMae = record
              cuilt : string[11];
              nom : string[30];
              end;
    tArcMae = file of tRegMae;

    tRegMov = record
              cuilt : string[11];
              importe : longint;
              end;
    tArcMov = file of tRegMov;
var
   arcMae : tArcMae;
   arcMov : tArcMov;
   rMae : tRegMae;
   rMov : tRegMov;

procedure verResumen(regCli : tRegMae);
var
   cant : integer;
   total : longint;
begin
     cant := 0;
     total := 0;
     reset(arcMov);
     while not eof(arcMov) do begin
           read(arcMov, rMov);
           if rMov.cuilt = regCli.cuilt then begin
              cant := cant + 1;
              total := total + rMov.importe;
           end;
     end;
     close(arcMov);

     if cant > 0 then
        writeln(regCli.nom, ' realizo ', cant, ' transacciones por ', total, ' pesos');
end; { Procedure }

procedure conMovimientos;
begin
     reset(arcMae);
     while not eof(arcMae) do begin
           read(arcMae, rMae);
           verResumen(rMae); { llamando al procedimiento verResumen }
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
           read(arcMov, rMov);
           if rMov.cuilt = cuilt then
              cant := cant + 1;
     end;
     close(arcMov);
     movimientos := cant; { guardando la cantidad en la funcion movimientos }
end;

procedure sinMovimientos;
begin
     reset(arcMae);
     while not eof(arcMae) do begin
           read(arcMae, rMae);
           if movimientos(rMae.cuilt) = 0 then { Si la funcion movimientos() es = 0 }
              writeln(rMae.cuilt, ' ', rMae.nom);
     end;
     close(arcMae);
end;

procedure agregarCliente(cuit : string[11]; nombre : string[30]);
begin
     rMae.cuilt := cuit;
     rMae.nom := nombre;
     write(arcMae, rMae);
end;

procedure agregarMovimiento(cuit : string[11]; imp : longint);
begin
     rMov.cuilt := cuit;
     rMov.importe := imp;
     write(arcMov, rMov);
end;

procedure crearArchivosPrueba;
begin
     rewrite(arcMae);
     agregarCliente('20111111112', 'Ana Gomez');  //llamando la funcion de agregarCliente()
     agregarCliente('27222222223', 'Luis Perez');
     agregarCliente('20333333334', 'Carla Diaz'); { Sin movimientos }
     close(arcMae);

     rewrite(arcMov);
     agregarMovimiento('20111111112', 15000);  // llamando el procedimiento agregarMovimiento
     agregarMovimiento('20111111112', 5000);
     agregarMovimiento('27222222223', 8200);
     close(arcMov);
end;

begin
     clrscr;
     assign(arcMae, 'maestro.dat');
     assign(arcMov, 'movimientos.dat');

     crearArchivosPrueba; // datos agregado en agregarClientes() AgregarMovimientos()

     writeln('--- Clientes con movimientos ---');
     conMovimientos;

     writeln('--- Clientes sin movimientos ---');
     sinMovimientos;

     readln;
end.

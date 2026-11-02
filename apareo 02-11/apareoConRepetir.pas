{Además de realizar el apareo, guarda en el tercer archivo el promedio}
program apareo2;
uses
    crt;
var
   arch1, arch2, arch3 : text;
   reg1, reg2, reg3 : string;
{Área de Procedimientos y Funciones}
function calProm(registro : string) : real;
var
   i, c, n1, n2, ce : integer;
   nom, ns1, ns2 : string;

begin
    c := 1;
    nom := '';
    ns1 := '';
    ns2 := '';
    for i := 1 to 3 do
    begin
         while (registro[c] <> ',') and (c <= length(registro)) do
         begin
              if i = 1 then
                 nom := nom + registro[c]
              else if i = 2 then
                 ns1 := ns1 + registro[c]
              else if i = 3 then
                 ns2 := ns2 + registro[c];
              c := c + 1;
         end;
         c := c + 1;
    end;
    val(ns1, n1, ce);
    val(ns2, n2, ce);
    calProm := (n1 + n2)/2.0;
end;

//procedimiento que muestra los datos de un archivo
//recibe como parámetros archivo y registro de trabajo
procedure verArchivo(var arch : text; reg : string);
begin
     reset(arch);
     while not eof(arch) do
     begin
          readln(arch, reg);
          writeln('Registro de: ', reg, ' promedio ', calProm(reg):0:2);
     end;
     close(arch);
     writeln('---------------------------------------');
     readkey;
end;

procedure procesArch;
begin
    reset(arch1);          //abre archivo 1 como lectura
    reset(arch2);          //abre archivo 2 como lectura
    rewrite(arch3);        //abre archivo 3 para crearlo
    readln(arch1, reg1);   //lee primer registro arch1
    readln(arch2, reg2);   //lee primer registro arch2
    writeln('Leido 1,',reg1);
    writeln('Leido 2,',reg2);
    writeln('-------------------');
//-----------------------------------------------------------------------------
    repeat
        if (reg1 < reg2)  then begin
           writeln(arch3, reg1);
           writeln(' --> Grabando de archivo 1 a ', reg1);
           if not eof(arch1) then
              readln(arch1, reg1);
        end else
        if (reg2 < reg1)  then begin
           writeln(arch3, reg2);
           writeln(' --> Grabando de archivo 2 a ', reg2);
           if not eof(arch2) then
              readln(arch2, reg2);
        end else
        if (reg2 = reg1) then begin
           writeln(arch3, reg1);
           writeln(arch3, reg2);
           writeln(' --> IGUALES Grabando de archivo 1 a ', reg1);
           writeln(' --> IGUALES Grabando de archivo 2 a ', reg2);
           if not eof(arch1) then
              readln(arch1, reg1);
           if not eof(arch2) then
              readln(arch2, reg2);
        end;
        writeln('Leido 1,',reg1);
        writeln('Leido 2,',reg2);
        writeln('-------------------');
        readkey;
    until eof(arch1) or eof(arch2); //hasta que terminen ambos archivos
//-----------------------------------------------------------------------------
writeln('------ salida ciclo repetir ------');
writeln('Ultimo Leido 1,',reg1);
writeln('Ultimo Leido 2,',reg2);
    if reg1 < reg2 then begin
      writeln(arch3, reg1);
      writeln(arch3, reg2);
    end
    else begin
       writeln(arch3, reg2);
       writeln(arch3, reg1);
    end;

    while not eof(arch1) do begin
       readln(arch1, reg1);
       writeln('Archivo 1,',reg1);
       writeln(arch3, reg1);
    end;

    writeln('Ultimo reg 2,',reg2);
    while not eof(arch2) do begin
       readln(arch2, reg2);
       writeln('Archivo 2,',reg2);
       writeln(arch3, reg2);
    end;

    //cierre de los archivos
    close(arch1);
    close(arch2);
    close(arch3);
end;
{Cuerpo del Programa}
BEGIN
    writeln('NUEVA VERSION');
    assign(arch1, 'notas1.txt');     // asocia primer archivo (entrada)
    assign(arch2, 'notas2.txt');    // asocia segundo archivo (entrada)
    assign(arch3, 'notasTodas.txt'); // asocia tercer archivo (salida)
    verArchivo(arch1, reg1);   //llamado al procedimiento para ver archivo1
    verArchivo(arch2, reg2);   //llamado al procedimiento para ver archivo2
    procesArch;                //llamado al procesamiento de datos
    //clrscr;
    writeln('---------------------------------------');
    writeln('Archivo Resultante, todos los registros');
    writeln('---------------------------------------');
    verArchivo(arch3, reg3);   //llamado al procedimiento para ver archivo3
END.

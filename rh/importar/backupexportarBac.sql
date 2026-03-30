declare @Planilla varchar(5), @Archivo varchar(5)

create table #planillaBSJ(
	registros numeric identity, 
	planilla char(5),
	archivo char(5),
	cedula char(9),
	blancos char(11),
	fechaini char(6),
	monto char(13),
	ceros char(3),
	detalle char(14),
	blancos2 char(11),
	fechafin char(5),
	blanco char(1),
	nombre char(30)
)

-- Numero de Planilla
if not exists(select 1 from RHParametros where Pcodigo = 200 and Ecodigo = @Ecodigo) begin
       insert RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
       values (@Ecodigo, 200, 'Numero de Planilla', 'B0011')
end
select @Planilla = Pvalor
from RHParametros
where Ecodigo = @Ecodigo
and Pcodigo = 200

-- Consecutivo de Archivo
if not exists(select 1 from RHParametros where Pcodigo = 210 and Ecodigo = @Ecodigo) begin
       insert RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
       values (@Ecodigo, 210, 'Consecutivo de Archivo de Planilla', '1')
end
select @Archivo = Pvalor
from RHParametros
where Ecodigo = @Ecodigo
and Pcodigo = 210

insert #planillaBSJ (planilla, archivo, cedula, blancos, fechaini, monto, ceros, detalle, blancos2, fechafin, blanco, nombre)
select 'T' || substring(@Planilla, 2, 4), 
         replicate('0', 5-datalength(@Archivo)) || @Archivo, 
         left(a.DRIdentificacion, 9), 
         replicate(' ', 11), 
         convert(char(6), b.ERNfinicio, 12), 
         replicate('0', 13-datalength(convert(varchar, convert(int, round(a.DRNliquido * 100, 0))))) ||convert(varchar, convert(int, round(a.DRNliquido * 100, 0))),
         replicate('0', 3), 
         left(b.ERNdescripcion, 14), 
         replicate(' ', 11), 
         right('0' || convert(varchar, datepart(dd,b.ERNffin)), 2) || '-' || right('0' || convert(varchar, datepart(mm,b.ERNffin)), 2),
         replicate(' ', 1), 
         left(a.DRNapellido1, 13) || replicate(' ', 13-datalength(left(a.DRNapellido1, 13))) 
         || left(a.DRNapellido2, 13) || replicate(' ', 13-datalength(left(a.DRNapellido2, 13)))
         || left(a.DRNnombre, 4)
from DRNomina a, ERNomina b
where a.ERNid = @ERNid
and a.Bid = @Bid
and a.ERNid = b.ERNid
order by 1, 3

-- encabezado
select @Planilla,
         convert(char(5), replicate('0', 5-datalength(@Archivo)) || @Archivo),
         convert(char(9), replicate(' ', 9)),
         convert(char(11), replicate(' ', 11)),
         convert(char(3), replicate('0', 3)),
         convert(char(6), b.ERNfinicio, 12), 
         convert(char(13), replicate('0', 13-datalength(convert(varchar(13), sum(convert(numeric,a.monto))))) || convert(varchar(13), sum(convert(numeric, a.monto)))),
         convert(char(3), replicate('0', 3-datalength(convert(varchar, count(1)))) || convert(varchar, count(1))),
         convert(char(14), left(b.ERNdescripcion, 14)),
         convert(char(11), replicate(' ', 11)),
         convert(char(5), right('0' || convert(varchar, datepart(dd,b.ERNffin)), 2) || '-' || right('0' || convert(varchar, datepart(mm,b.ERNffin)), 2)),
         convert(char(1), replicate(' ', 1)),
         convert(char(30), replicate(' ', 30))
from #planillaBSJ a, ERNomina b
where b.ERNid = @ERNid
group by b.ERNdescripcion, b.ERNfinicio

union

-- detalle
select planilla,
         archivo,
         cedula,
         blancos,
         replicate('0', 3-datalength(convert(varchar, registros))) || convert(varchar, registros),
         fechaini,
         monto,
         ceros,
         detalle,
         blancos2,
         fechafin,
         blanco,
         nombre
from #planillaBSJ
order by 1, 3

drop table #planillaBSJ

update RHParametros
set Pvalor = convert(varchar, convert(numeric, Pvalor) + 1)
where Ecodigo = @Ecodigo
and Pcodigo = 210

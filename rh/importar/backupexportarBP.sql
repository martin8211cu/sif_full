if object_id('##RHExportarBPPR') is not null
 drop table ##RHExportarBPPR
 
create table ##RHExportarBPPR( orden smallint, 
        data varchar(255)
         )
 
insert ##RHExportarBPPR(orden, data)

select 2,
	substring(rtrim(ltrim(c.DEnombre))||rtrim(ltrim(c.DEapellido1))||rtrim(ltrim(c.DEapellido2)), 1, 22)
  ||	replicate('', 22-datalength(substring(rtrim(ltrim(c.DEnombre))||rtrim(ltrim(c.DEapellido1))||rtrim(ltrim(c.DEapellido2)), 1, 22)))

  || substring(c.DEidentificacion,1,11)
  || replicate('', 11-datalength(rtrim(substring(c.DEidentificacion, 1, 11))))

  || rtrim(convert(varchar, substring(isnull(d.Iaba,''), 1, 9)))
  || replicate('', 9-isnull(datalength(rtrim(substring(isnull(d.Iaba,' '),1,9))),0))

  || convert(varchar, ltrim(rtrim(substring(a.CBcc, 1, 9))))
  || replicate('', 9-datalength(ltrim(rtrim(substring(a.CBcc, 1, 9)))))

  || '22'

  || convert(varchar, DRNliquido)
  || replicate('', 10-datalength(rtrim(convert(varchar,a.DRNliquido))))
from DRNomina a, ERNomina b, DatosEmpleado c, Bancos d
where a.ERNid=@ERNid
and b.ERNid=@ERNid
and b.Ecodigo=@Ecodigo
and c.Ecodigo=@Ecodigo
and d.Ecodigo=@Ecodigo
and a.ERNid=b.ERNid
and a.DEid=c.DEid
and a.Bid=d.Bid
and a.Bid is not null
--and datalength(rtrim(a.CBcc)) > 9


declare @c1 int, @c2 int
select @c1 = count(1) from DRNomina a, ERNomina b
where a.ERNid=@ERNid
and b.ERNid=@ERNid
and b.Ecodigo=@Ecodigo
and a.ERNid=b.ERNid
and a.Bid is not null
--and datalength(rtrim(a.CBcc)) > 9

select @c2 = count(1) from ##RHExportarBPPR

if @c1 != @c2
 select 'La cantidad de Personas generadas en el archivo para este Banco no concuerda con la cantidad de Personas en la Relación de Cálculo!' as Error

select data from ##RHExportarBPPR order by orden 
 
drop table ##RHExportarBPPR

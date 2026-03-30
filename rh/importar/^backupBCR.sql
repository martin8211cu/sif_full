declare 
	@archivo int, --pasar compo parametro el consecutivo que se genera
	@cedulajur char(12),
	@cedula char(12), --cedula de usuario que registra
	@DEid numeric, --id de usuario que registra
	@testkey numeric,
	@cuenta varchar(20),
	@contador int,
	@documento int,
	@cuentaorigen varchar(20),
	@fpago datetime

/********************************
	@Ecodigo int,
	@EcodigoASP numeric,
	@ERNid numeric,
	@Bid numeric,
	@Usucodigo numeric
 
	select 
		@Ecodigo = 162, 
		@EcodigoASP = 228,
		@ERNid = 18,
		@Bid = 11,
		@Usucodigo = 0
********************************/
	
select @archivo = 0, @contador = 1

select @cuentaorigen = a.CBcc, @fpago = b.CPfpago
from ERNomina a, CalendarioPagos b
where a.ERNid = @ERNid
and a.Ecodigo = @Ecodigo
and a.RCNid = b.CPid
and a.Ecodigo = b.Ecodigo

-- Calcula el numero de consecutivo(archivo)
--select @archivo = convert(numeric, isnull(Pvalor,'0'))
if exists( select * from RHParametros where Ecodigo=@Ecodigo and Pcodigo=210 ) begin
	select @archivo = convert(numeric, isnull(Pvalor,'1'))
	from RHParametros
	where Pcodigo=210
	and Ecodigo=@Ecodigo
end
else begin
	select @archivo = 1	
end

if @archivo >= 1000 begin
 select @archivo = 0
end 

-- documento
select @documento = 1
 
-- recupera la cedula juridica de la empresa
select @cedulajur = Eidentificacion 
from asp..Empresa
where Ecodigo=@EcodigoASP
 
-- quita guiones a la cedula juridica
declare @pos int
 
while (1=1) begin
 select @pos = charindex('-', @cedulajur)
 if @pos = 0 
  break
 
 if ((@pos > 1) and (datalength(@cedulajur ) > @pos)) 
  select @cedulajur  = substring(@cedulajur ,1,@pos-1) + substring(@cedulajur , @pos+1, datalength(@cedulajur ))
 else 
  if @pos = 1
    select @cedulajur  = substring(@cedulajur ,2,datalength(@cedulajur ))
  else 
   if @pos = datalength(@cedulajur )
    select @cedulajur = substring(@cedulajur ,1,datalength(@cedulajur )-1)
 
end
 
-- recupera el DEid del empleado que registra
select @DEid=convert(numeric,llave) from asp..UsuarioReferencia 
where Usucodigo=@Usucodigo and STabla='DatosEmpleado'
and Ecodigo=@EcodigoASP
 
-- selecciona la cedula del empleado que registra
select @cedula=DEidentificacion from DatosEmpleado where DEid=@DEid and Ecodigo=@Ecodigo

select @cedula = b.Pid 
from asp..Usuario a, asp..DatosPersonales b
where a.Usucodigo = @Usucodigo
  and a.datos_personales = b.datos_personales

-- Quita guiones de la cedula
while (1=1) begin
 select @pos = charindex('-', @cedula)
 if @pos = 0 
  break
 
 if ((@pos > 1) and (datalength(@cedula ) > @pos)) 
  select @cedula = substring(@cedula ,1,@pos-1) + substring(@cedula, @pos+1, datalength(@cedula))
 else 
  if @pos = 1
    select @cedula = substring(@cedula,2,datalength(@cedula))
  else 
   if @pos = datalength(@cedula)
    select @cedula = substring(@cedula,1,datalength(@cedula)-1)
 
end

--Quita guiones de la cuenta de la que se saca la plata
while (1=1) begin
 select @pos = charindex('-', @cuentaorigen)
 if @pos = 0 
  break
 
 if ((@pos > 1) and (datalength(@cuentaorigen) > @pos)) 
  select @cuentaorigen = substring(@cuentaorigen ,1,@pos-1) + substring(@cuentaorigen, @pos+1, datalength(@cuentaorigen))
 else 
  if @pos = 1
    select @cuentaorigen = substring(@cuentaorigen,2,datalength(@cuentaorigen))
  else 
   if @pos = datalength(@cuentaorigen)
    select @cuentaorigen = substring(@cuentaorigen,1,datalength(@cuentaorigen)-1)
 
end
 
-- calculo del testkey
declare @resultado1 numeric

select @resultado1 = 
	sum(convert(numeric, substring(CBcc, 6, 3)) + convert(numeric,substring(CBcc, 9, datalength(rtrim(CBcc))-9)))
from DRNomina 
where ERNid=@ERNid  
  and Bid=@Bid
  and datalength(rtrim(ltrim(CBcc))) > 9

declare @resultado2 numeric
select @resultado2 = sum(floor(convert(numeric, substring(CBcc, 6, datalength(rtrim(CBcc))-6))/(case DRNliquido when 0 then 1 else DRNliquido end)))
from DRNomina 
where ERNid=@ERNid
  and Bid=@Bid
  and datalength(rtrim(ltrim(CBcc))) > 9
 
select @testkey = @resultado1+@resultado2
 

if object_id('##RHExportarBCR') is not null
 drop table ##RHExportarBCR
 
create table ##RHExportarBCR( orden smallint, 
        data varchar(255), 
		linea int null
         )
 
insert ##RHExportarBCR(orden, data, linea)
select 
	1, 
	replicate('',2) || '0'
    || replicate( '', 12 - datalength(@cedulajur) )|| convert(varchar, @cedulajur) --Cedula Juridica
	|| replicate('',3- datalength(convert(varchar,@archivo))) || convert(varchar, @archivo)
	|| substring(convert(varchar,@fpago ,103),1,2)||substring(convert(varchar,@fpago ,103),4,2)||substring(convert(varchar,@fpago ,103),9,2)
	|| replicate('',11 - datalength(convert(varchar,isnull(@cedula,'3337844')))) || convert(varchar,isnull(@cedula,'3337844'))
    || replicate('',12 - datalength(convert(varchar,@testkey)) ) || convert(varchar(255), @testkey)
    || replicate('',19)||'0'
    || replicate('',15)||'0',
	1
from ERNomina
where ERNid=@ERNid

insert ##RHExportarBCR(orden, data, linea)
select 
	2, 
	replicate('',2) || '01' -- Tipo de Cuenta
    || replicate( '', 4) || '0' -- Filler
	|| replicate('', 2) || '1' --Oficina
    || replicate('',8 - datalength(@cuentaorigen)) || @cuentaorigen -- Cuenta de la que se saca la plata
	|| '04'
    || replicate('',3) || '0'
    || replicate('',6) || '1'
	|| replicate('',15-datalength(convert(varchar,sum(a.DRNliquido)*100))) || convert(varchar,convert(numeric,sum(a.DRNliquido)*100))
	|| substring(convert(varchar,@fpago ,103),1,2)||substring(convert(varchar,@fpago ,103),4,2)||substring(convert(varchar,@fpago ,103),9,2)
	|| '0'
	|| convert(varchar,b.ERNdescripcion)||replicate('', 30-datalength(rtrim(b.ERNdescripcion)))
	|| '0',
	1
from DRNomina a, ERNomina b
where a.ERNid = @ERNid
and a.Bid is not null
and a.ERNid = b.ERNid
and b.Ecodigo = @Ecodigo
 
insert ##RHExportarBCR(orden, data, linea)
select 3, replicate('',2)
 || '0' || substring(a.CBcc,5,1)  --Tipo de Cuenta (1 Corriente, 2 Ahorro)
 || replicate('',4) || '0'
 || replicate('', 3-datalength(convert(varchar, convert(int,substring(a.CBcc, 6, 3))))) -- Oficina
 || convert(varchar, convert(int,substring(a.CBcc, 6, 3)))
 || substring(a.CBcc, 9, datalength(rtrim(a.CBcc))-9)
 || '0'
 || '2'
 || replicate('',3) || '0'
 || case when datalength(convert(varchar, DRNlinea)) < 8 then replicate('', 8-datalength(convert(varchar, DRNlinea))) end
 || case when datalength(convert(varchar, DRNlinea)) > 8 
         then substring(convert(varchar, DRNlinea),(datalength(convert(varchar, DRNlinea))-8)+1, datalength(convert(varchar, DRNlinea))-(datalength(convert(varchar, DRNlinea))-8) )
	     else convert(varchar, DRNlinea) end

 || replicate('',12-(datalength(convert(varchar,convert(numeric,DRNliquido*100))))) 
 || convert(varchar,convert(numeric,DRNliquido*100))

 || substring(convert(varchar,@fpago ,103),1,2)||substring(convert(varchar,@fpago ,103),4,2)||substring(convert(varchar,@fpago ,103),9,2)
 || '0'
 || convert(varchar,b.ERNdescripcion)||replicate('', 30-datalength(rtrim(b.ERNdescripcion)))
 || '0',
 null
from DRNomina a, ERNomina b
where a.ERNid=@ERNid
and b.ERNid=@ERNid
and b.Ecodigo=@Ecodigo
and a.ERNid=b.ERNid
and a.Bid=@Bid
and datalength(rtrim(a.CBcc)) > 9

update ##RHExportarBCR set 
		data = substring(data,1,29) || replicate('',4-datalength(convert(varchar,@contador))) || convert(varchar,@contador) || substring(data,35,datalength(data)), @contador=@contador + 1 
where orden = 3
select @contador = 1
update ##RHExportarBCR set 
		linea = @contador, @contador=@contador + 1 
where orden = 3


declare @c1 int, @c2 int
select @c1 = count(1) from DRNomina a, ERNomina b
where a.ERNid=@ERNid
and b.ERNid=@ERNid
and b.Ecodigo=@Ecodigo
and a.ERNid=b.ERNid
and a.Bid=@Bid

select @c2 = count(1) from ##RHExportarBCR where orden = 3

if @c1 != (@c2)
 select 'La cantidad de Personas generadas en el archivo para este Banco no concuerda con la cantidad de Personas en la Relación de Cálculo!' as Error

select data from ##RHExportarBCR order by orden, linea
 
-- actualiza el consecutivo en RHParametros 
select @archivo = @archivo + 1

update RHParametros
set Pvalor = convert(varchar, @archivo)
where Ecodigo=@Ecodigo
  and Pcodigo=210
if @@rowcount = 0 begin
	insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor)
	values (@Ecodigo, 210, 'Consecutivo de Archivo de Planilla', convert(varchar, @archivo))
end

drop table ##RHExportarBCR
2	 select * from #table_name# where fname like '%PAULA%'	
4	select *,'Porque se llama PAULA'
from #table_name#
where fname like  '%PAULA%'	set rowcount 500
select
applicant_id,
personal_id_nbr as personid,
first_names as fname,
last_name as lname,
extra_char_1 as lname2,
proc_cmplt_f as proc_flag,
date_stamp,
issue_dt as issue_date,
expiry_dt as expiry_date
from pasaportes..CONSULTA
set rowcount 0
32		select 
     a.Ecodigo, a.Cconcepto, a.Eperiodo, a.Emes, 
     a.Edocumento, convert(varchar,a.Efecha,112) as Efecha, 
     a.Edescripcion, a.Edocbase, a.Ereferencia, 
     a.ECauxiliar, a.ECusuario, a.ECselect,
     b.Dlinea, b.Ocodigo, b.Ddescripcion, 
     b.Ddocumento, b.Dreferencia, b.Dmovimiento, 
     b.Ccuenta, b.Doriginal, b.Dlocal, b.Mcodigo, 
     b.Dtipocambio
from EContables a, DContables b
where a.IDcontable=b.IDcontable
  and a.Ecodigo = @Ecodigo
  and a.IDcontable = @IDcontable
  and b.IDcontable = @IDcontable
131	insert Empresas (Ecodigo, Edescripcion, Elocalizacion, Ecache, Usucodigo, Ulocalizacion, Mcodigo, cliente_empresarial)
select fEcodigo, fEdescripcion, fElocalizacion, fEcache, fUsucodigo, fUlocalizacion, fMcodigo, fcliente_empresarial
from #table_name#	
132	declare @check1 numeric, @check2 numeric, @check3 numeric, @check4 numeric, @lote int

-- Chequear que snnumero, tdcodigo sea único
select @check1 = count(count(1))
from #table_name#
group by snnumero, tdcodigo

if @check1 <= 1 begin

-- Chequear integridad referencial del socio y el tipo de deducción
select @check2 = count(1)
from #table_name# a
where not exists(
select 1
from SNegocios b
where a.snnumero = b.SNnumero
and b.Ecodigo = @Ecodigo
) or not exists(
select 1
from TDeduccion c
where a.tdcodigo = c.TDcodigo
and c.Ecodigo = @Ecodigo
)

if @check2 < 1 begin

-- Chequear existencia de empleado

select @check3 = count(1)
from #table_name# a
where not exists(
select 1
from DatosEmpleado b
where a.cedula = b.DEidentificacion
and b.Ecodigo = @Ecodigo
)

if @check3 < 1 begin

-- Chequear Validez de Metodo y Controla Saldo
select @check4 = count(1)
from #table_name# a
where (a.controlsaldo != 0
and a.controlsaldo != 1)
or
(a.metodo != 0
and a.metodo != 1)

if @check4 < 1 begin

select @lote = isnull(max(EIDlote)+1, 1) from EIDeducciones

-- Inserta el Encabezado del Lote
insert into EIDeducciones(EIDlote, Ecodigo, TDid, SNcodigo, Usucodigo, Ulocalizacion, EIDfecha, EIDestado)
select @lote, @Ecodigo, c.TDid, b.SNcodigo, @Usucodigo,  @Ulocalizacion, getDate(), 0
from #table_name# a, SNegocios b, TDeduccion c
where a.snnumero = b.SNnumero
and b.Ecodigo = @Ecodigo
and a.tdcodigo = c.TDcodigo
and c.Ecodigo = @Ecodigo
group by c.TDid, b.SNcodigo

-- Inserta las Deducciones
insert into DIDeducciones(EIDlote, DIDidentificacion, DIDreferencia, DIDmetodo, DIDvalor, DIDfechaini, DIDfechafin, DIDmonto, DIDcontrolsaldo)
select @lote, cedula, referencia, metodo, valor, fechaini, fechafin, monto, controlsaldo
from #table_name#

end -- check4
else begin -- check4

select distinct 'Metodo o Control de Saldo son incorrectos' as Error, metodo as Metodo, controlsaldo as Control_Saldo
from #table_name# a
where (a.controlsaldo != 0
and a.controlsaldo != 1)
or
(a.metodo != 0
and a.metodo != 1)

end -- check4

end -- check3
else begin -- check3

select distinct 'Empleado no Existe' as Error, cedula as Empleado
from #table_name# a
where not exists(
select 1
from DatosEmpleado b
where a.cedula = b.DEidentificacion
and b.Ecodigo = @Ecodigo
)

end -- check3

end -- check2
else begin -- check2

select distinct 'Socio o Tipo de Deducción son incorrectos.' as Error, snnumero as Socio_Negocio, tdcodigo as Tipo_Deduccion 
from #table_name# a
where not exists(
select 1
from SNegocios b
where a.snnumero = b.SNnumero
and b.Ecodigo = @Ecodigo
) or not exists(
select 1
from TDeduccion c
where a.tdcodigo = c.TDcodigo
and c.Ecodigo = @Ecodigo
)

end -- else check2

end -- check1
else begin -- check1

select distinct 'El archivo debe contener únicamente un número de cuenta con un tipo de deducción' as Error, snnumero as Socio_Negocio, tdcodigo as Tipo_Deduccion 
from #table_name#

end -- else check1
	
149	declare @check1 int, @check2 int

select @check1 = count(1)
from #table_name# a, DatosEmpleado b, CIncidentes c, Incidencias d
where a.DEidentificacion=b.DEidentificacion
  and a.CIcodigo=c.CIcodigo 
  and b.DEid=d.DEid
  and c.CIid=d.CIid
  and a.Ifecha=d.Ifecha
  and b.Ecodigo=@Ecodigo
  and c.Ecodigo=@Ecodigo


if @check1 < 1 begin 

	select @check2 = count(1) 
	from #table_name# 
	where (CFcodigo is not null and CFcodigo <> ' ')
	    and CFcodigo not in (select CFcodigo from CFuncional where Ecodigo = @Ecodigo)

	if @check2 < 1 begin

		-- Inserta Incidencias
	
		insert Incidencias ( DEid, CIid, CFid, Ifecha, Ivalor, Ifechasis, Usucodigo, Ulocalizacion )
		select DEid, CIid, cf.CFid, Ifecha, Ivalor, getDate(), @Usucodigo, @Ulocalizacion
		from #table_name# a, DatosEmpleado b, CIncidentes c, CFuncional cf
		where a.DEidentificacion=b.DEidentificacion
		  and a.CIcodigo=c.CIcodigo 
		  and b.Ecodigo=@Ecodigo
		  and c.Ecodigo=@Ecodigo
		  and a.CFcodigo *= cf.CFcodigo
		  and cf.Ecodigo = @Ecodigo

		select 'Empleado no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor from #table_name# a
		where a.DEidentificacion not in ( select DEidentificacion from DatosEmpleado b where a.DEidentificacion=b.DEidentificacion )
		union
		select 'Concepto Incidente no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor from #table_name# a
		where a.CIcodigo not in ( select CIcodigo from CIncidentes c where a.CIcodigo=c.CIcodigo )
	end
	else begin 
		select 'Centro Funcional no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, CFcodigo, Ivalor from #table_name# a
		where (CFcodigo is not null and CFcodigo <> ' ')
                                   and CFcodigo not in (select CFcodigo from CFuncional where Ecodigo = @Ecodigo)
	end
end
else begin
	select 'Registro ya existe' Motivo, a.DEidentificacion, a.CIcodigo, a.Ifecha, a.Ivalor
	from #table_name# a, DatosEmpleado b, CIncidentes c
	where a.DEidentificacion=b.DEidentificacion
	  and a.CIcodigo=c.CIcodigo 
	  and b.Ecodigo=@Ecodigo
	  and c.Ecodigo=@Ecodigo
	union 
	select 'Empleado no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor from #table_name# a
	where a.DEidentificacion not in ( select DEidentificacion from DatosEmpleado b where a.DEidentificacion=b.DEidentificacion )
	union
	select 'Concepto Incidente no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor from #table_name# a
	where a.CIcodigo not in ( select CIcodigo from CIncidentes c where a.CIcodigo=c.CIcodigo )
	order by Motivo
end	
159		
234		select coalesce(a.DRNnombre,'') + '' + coalesce(a.DRNapellido1,'') + '' + coalesce(a.DRNapellido2,'') as Nombre,
         substring(a.CBcc,1,3) as T_Cuenta,
         coalesce(a.CBcc,'-1') as N_Cuenta,
         1 as Subcuenta,
         1 as T_Saldo,
         a.DRNliquido as Monto,
         b.ERNdescripcion as Detalle,
         a.DRIdentificacion as Ref_1,
         coalesce(a.DRNnombre,'') + '' + coalesce(a.DRNapellido1,'') + '' + coalesce(a.DRNapellido2,'') as Ref_2,
         0 as Cod_Contable
from DRNomina a, ERNomina b
where a.ERNid=@ERNid
and a.Bid=@Bid
and a.ERNid=b.ERNid
235		declare @Planilla varchar(5), @Archivo varchar(5)

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
239		select coalesce(a.DRNnombre,'') + '' + coalesce(a.DRNapellido1,'') + '' + coalesce(a.DRNapellido2,'') as Nombre,
         substring(a.CBcc,1,3) as T_Cuenta,
         coalesce(a.CBcc,'-1') as N_Cuenta,
         1 as Subcuenta,
         1 as T_Saldo,
         a.DRNliquido as Monto,
         b.ERNdescripcion as Detalle,
         a.DRIdentificacion as Ref_1,
         coalesce(a.DRNnombre,'') + '' + coalesce(a.DRNapellido1,'') + '' + coalesce(a.DRNapellido2,'') as Ref_2,
         0 as Cod_Contable
from DRNomina a, ERNomina b
where a.ERNid=@ERNid
and a.Bid is null
and a.ERNid=b.ERNid
240	declare @check1 numeric, @Alm_Aid numeric

select @Alm_Aid = min(Aid) from Almacen
where Ecodigo = @Ecodigo

-- Chequear existencia de artículo

select @check1 = count(1)
from #table_name# a
where not exists(select 1 from Articulos b, Existencias e
where rtrim(a.sapno) = rtrim(b.Acodigo)
  and b.Ecodigo = @Ecodigo
  and e.Alm_Aid  = @Alm_Aid 
  and b.Aid = e.Aid)

if @check1 < 1 begin


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  declare @ETid numeric

  insert into ETransformacion(Ecodigo,Usucodigo,Ulocalizacion,ETfecha,ETdocumento, ETcostoProd)
  values(@Ecodigo, @Usucodigo, @Ulocalizacion, getdate(), 'PR-'+convert(varchar,getdate(),103)+' '+convert(varchar,getdate(),108), 0.00)

  select @ETid = @@identity

  insert into DTransformacion
  (ETid, Aid, Alm_Aid, Acodigo, Ucodigo, 
   DTobservacion, DTinvinicial, DTrecepcion, DTprodcons, DTembarques, 
   DTconsumopropio, DTperdidaganancia, DTinvfinal, DTfactor, DTfecha,
   DTcostoU, DTcostoT)
  
  select @ETid, a.Aid, @Alm_Aid, t.sapno, a.Ucodigo, 
           t.Product, t.Opening, t.Receipts, t.Production, t.Shipments, 
           t.Own, t.LossGain, t.Ending, 1.00, getdate(), 
           1.00, 1.00  
  from #table_name# t, Articulos a
where rtrim(a.Acodigo) = rtrim(t.sapno)
  and a.Ecodigo = @Ecodigo

  update DTransformacion 
  set Aid = b.Aid
  from DTransformacion c, Articulos b, ETransformacion e 
  where c.Aid is null
    and c.Acodigo = b.Acodigo
    and  e.ETid = c.ETid
    and  e.Ecodigo = @Ecodigo
    and b.Ecodigo = @Ecodigo

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

end -- check1
else begin -- check1
  select distinct 'Artículo no Existe o no tiene Existencias' as Error, a.sapno as Artículo
  from #table_name# a
  where not exists(
  select 1
  from Articulos b, Existencias e
  where rtrim(a.sapno) = rtrim(b.Acodigo)
    and b.Ecodigo = @Ecodigo
    and e.Alm_Aid  = @Alm_Aid 
    and b.Aid = e.Aid)

end -- check1	
241	declare @check1 int, @Alm_Aid numeric, @check2 int

select @Alm_Aid = min(Aid) from Almacen 
where Ecodigo = @Ecodigo

-- Chequear existencia de artículo

select @check1 = count(1)
from #table_name# a
where not exists(select 1 from Articulos b, Existencias e
where rtrim(a.Product) = rtrim(b.Acodigo)
  and b.Ecodigo = @Ecodigo
  and e.Alm_Aid  = @Alm_Aid 
  and b.Aid = e.Aid)

-- Chequear existencia de artículos en Tránsito

select @check2 = count(1)
from #table_name# a
where not exists(select 1 from Transito t
where rtrim(a.Product) = rtrim(t.Acodigo)
  and rtrim(t.Tembarque) = rtrim(a.MovementName)
  and t.Ecodigo = @Ecodigo)


if @check1 = 0 and @check2 = 0 begin

-- Actualiza el Tid

update #table_name# set Field8 = (select convert(varchar, tr.Tid)
from Transito tr
where rtrim(tr.Acodigo) = rtrim(#table_name#.Product)
  and rtrim(tr.Tembarque) = rtrim(#table_name#.MovementName)
  and tr.Ecodigo = @Ecodigo)

declare @ERTid numeric


insert ERecibeTransito 
(Ecodigo, ERTfecha, ERTaplicado, Usucodigo, Ulocalizacion, ERTdocref)
values (@Ecodigo, getdate(), 0, @Usucodigo, '00','RP-'+convert(varchar,getdate(),103) )

select @ERTid = @@identity


insert DRecibeTransito 
(ERTid, Alm_Aid, DRTcantidad, Aid, DRTfecha, Ddocumento, DRTcostoU, DRTembarque, Ucodigo, Tid, DRTgananciaperdida)

select @ERTid, @Alm_Aid, convert(float,t.Pounds) / 2, a.Aid, t.Date, t.Field8, 
case when tr.Tcantidad != 0 then round(tr.TcostoLinea / tr.Tcantidad, 6) else 0.00 end, 
t.MovementName, a.Ucodigo, convert(numeric, t.Field8), (convert(float,t.Pounds) / 2) - (tr.Tcantidad - isnull(tr.Trecibido, 0))
from #table_name# t, Articulos a, Transito tr
where rtrim(a.Acodigo) = rtrim(t.Product)
  and a.Ecodigo = @Ecodigo
  and tr.Tid = convert(numeric, t.Field8)

update Transito
set Trecibido = Tcantidad
where Transito.Tid in (select  distinct convert(numeric, t.Field8) from #table_name# t)

end 


 if @check1 = 0 and @check2 != 0 begin
	  select distinct 'Artículo / Embarque no Existe' as Error, Product as Artículo, MovementName as Embarque
	  from #table_name# a
	  where not exists(
	  select 1
	  from Transito t
	  where rtrim(a.Product) = rtrim(t.Acodigo)
               and rtrim(t.Tembarque) = rtrim(a.MovementName)
	    and t.Ecodigo = @Ecodigo)
 end

if @check1 > 0 begin
	  select 'Artículo no Existe o no tiene Existencias' as Error, Product as Artículo
	  from #table_name# a
	  where not exists(
	  select 1
	  from Articulos b, Existencias e
	  where b.Ecodigo = @Ecodigo
                    and b.Acodigo = rtrim(a.Product)
	    and e.Alm_Aid  = @Alm_Aid 
	    and b.Aid = e.Aid)
end	
242	declare @check1 numeric, @check2 numeric, @Alm_Aid numeric, @check3 numeric

-- Formatea la fecha
update #table_name#
set BOLDate = substring(BOLDate, 7,4) || substring(BOLDate, 4,2) || substring(BOLDate, 1,2) 
where substring(BOLDate,3,1)='/'

-- Actualiza los cantidades en nulo o vacío con cero
update #table_name# set BBLQty = isnull(BBLQty, '0')
update #table_name# set BBLQty = case when isnull(rtrim(BBLQty),'') = '' then '0' else BBLQty end

-- Actualiza los montos negativos que vienen de la forma (#)
update #table_name# set BBLQty = '-' + substring(BBLQty, 2, datalength(BBLQty)-2)
where BBLQty like '(%)'

update #table_name# set Amount = '-' + substring(Amount, 2, datalength(Amount)-2)
where Amount like '(%)'

declare      @CPTcodigo char(2), @Mcodigo numeric, @SNcodigo int, @Icodigo char(5), @Ocodigo int, @Dcodigo int,
	@SNcuentacxp numeric, @Cid numeric, @CuentaConcepto numeric


select @SNcodigo = convert(int,Pvalor) from Parametros where Ecodigo = @Ecodigo and Pcodigo = 450
select @CPTcodigo = Pvalor from Parametros where Ecodigo = @Ecodigo and Pcodigo = 460
select @Icodigo = Pvalor from Parametros where Ecodigo = @Ecodigo and Pcodigo = 470

if (@SNcodigo is null or @CPTcodigo is null or @Icodigo is null) begin
   select 'Se deben definir todos los parámetros de importación' as Error
end

select @Alm_Aid = min(Aid) from Almacen where Ecodigo = @Ecodigo


-- Chequear existencia de artículo

select @check1 = count(1)
from #table_name# a
where not exists(select 1 from Articulos b, Existencias e
where rtrim(a.Material) = rtrim(b.Acodigo)
  and b.Ecodigo = @Ecodigo
  and e.Alm_Aid  = @Alm_Aid 
  and b.Aid = e.Aid)
  and rtrim(a.Material) != ''


if @check1 < 1 begin


-- Chequear llave alterna duplicada


select @check2 = count(1)
from #table_name# t
where exists(select 1 from EDocumentosCxP 
			where Ecodigo = @Ecodigo  
 			  and CPTcodigo = @CPTcodigo  
			  and SNcodigo = @SNcodigo  
   			  and rtrim(EDdocumento) = rtrim(t.DocumentNo))

if @check2 < 1 begin
  select @check3 = count(1) from #table_name# t
  where exists (select 1 from EDocumentosCP 
			where Ecodigo = @Ecodigo  
 			  and CPTcodigo = @CPTcodigo  
			  and SNcodigo = @SNcodigo  
      			  and rtrim(Ddocumento) = rtrim(t.DocumentNo))
if @check3 < 1 begin

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


select @Mcodigo = Mcodigo from Empresas where Ecodigo = @Ecodigo

select @Ocodigo = min(Ocodigo) from Oficinas where Ecodigo = @Ecodigo

select @Dcodigo = min(Dcodigo) from Departamentos where Ecodigo = @Ecodigo

select @Cid = min(Cid) from Conceptos where Ecodigo = @Ecodigo and Ctipo = 'G'

select @SNcuentacxp = SNcuentacxp from SNegocios where Ecodigo = @Ecodigo and SNcodigo = @SNcodigo

select @CuentaConcepto = min(IACgastoajuste) from IAContables where Ecodigo = @Ecodigo

insert into EDocumentosCxP (
	Ecodigo, CPTcodigo, EDdocumento, Mcodigo, 
	SNcodigo, Icodigo, Ocodigo, Ccuenta, 
	EDtipocambio, EDimpuesto, EDporcdescuento, EDdescuento, EDtotal, 
	EDfecha, EDusuario, EDselect
)

select distinct
	@Ecodigo, @CPTcodigo, DocumentNo, @Mcodigo, 
	@SNcodigo, @Icodigo, @Ocodigo, @SNcuentacxp, 
	1.00, 0.00, 0.00, 0.00, 0.00, 
	BOLDate, @Usulogin, 0
from #table_name#


insert into DDocumentosCxP (
	IDdocumento, Aid, Cid, Alm_Aid, 
	Ecodigo, Dcodigo, Ccuenta, DDdescripcion, DDdescalterna, 
	DDcantidad, DDpreciou, DDdesclinea, DDporcdesclin, DDtotallinea, 
	DDtipo, DDtransito, DDembarque, DDfembarque)

select 
	e.IDdocumento, 
	art.Aid as Articulo, 
	case when t.Material is null then @Cid else null end as Concepto, 
	case when t.Material is not null then @Alm_Aid else null end as Almacen, 	
	@Ecodigo as Empresa, 
	@Dcodigo as Depto,
	@SNcuentacxp as CuentaInv, 
	isnull(art.Adescripcion, 'Concepto'), 
	isnull(art.Adescripcion, 'Concepto'), 	
	case when rtrim(t.Material) != ''  then convert(float,t.BBLQty) else 1 end, convert(money,t.Amount)/case when convert(float,t.BBLQty) != 0 then isnull(convert(float,t.BBLQty),1) else 1 end, 0.00, 0.00, convert(money,t.Amount), 
	case when rtrim(t.Material) != ''  then 'A' else 'S' end, 0, t.BOLNo, convert(datetime,t.BOLDate)
from #table_name# t, EDocumentosCxP e, Articulos art
where rtrim(e.EDdocumento) = rtrim(t.DocumentNo)
  and e.CPTcodigo = @CPTcodigo
  and e.EDfecha = convert(datetime,t.BOLDate)
  and e.Ecodigo = @Ecodigo
  and art.Ecodigo = @Ecodigo
  and art.Acodigo =* t.Material

-- Actualiza el total en el encabezado

update EDocumentosCxP set
 EDtotal = ( 
  (1+(c.Iporcentaje / 100.00)) * (isnull((
   select sum(b.DDtotallinea) 
   from DDocumentosCxP b, EDocumentosCxP a
   where b.IDdocumento = a.IDdocumento
     and a.IDdocumento = EDocumentosCxP.IDdocumento
   group by a.IDdocumento), 0.00) -  EDocumentosCxP.EDdescuento))
from Impuestos c          
where EDocumentosCxP.Ecodigo = @Ecodigo
  and EDocumentosCxP.EDtotal = 0.00
  and EDocumentosCxP.EDtipocambio = 1.00
  and EDocumentosCxP.EDimpuesto = 0.00
  and EDocumentosCxP.EDporcdescuento = 0.00
  and EDocumentosCxP.EDdescuento = 0.00
  and c.Ecodigo = EDocumentosCxP.Ecodigo
  and c.Icodigo = EDocumentosCxP.Icodigo


--Determina la cuenta para los artículos de Inventario
update DDocumentosCxP
set Ccuenta = isnull( (
	select iac.IACinventario
	from Existencias exi, IAContables iac
	where exi.Aid = d.Aid
	   and exi.Alm_Aid = d.Alm_Aid
	   and iac.IACcodigo = exi.IACcodigo
	   and iac.Ecodigo = exi.Ecodigo), 0)
from EDocumentosCxP e, DDocumentosCxP d
where e.CPTcodigo = @CPTcodigo
   and e.SNcodigo = @SNcodigo
   and e.Ecodigo = @Ecodigo
   and e.EDdocumento in (select  distinct DocumentNo from #table_name#)
   and d.IDdocumento = e.IDdocumento
   and d.DDtipo = 'A'

--Asigna la cuenta para los Conceptos
update DDocumentosCxP
set Ccuenta = @CuentaConcepto, Cid = @Cid
from EDocumentosCxP e, DDocumentosCxP d
where e.CPTcodigo = @CPTcodigo
   and e.SNcodigo = @SNcodigo
   and e.Ecodigo = @Ecodigo
   and e.EDdocumento in (select  distinct DocumentNo from #table_name#)
   and d.IDdocumento = e.IDdocumento
   and d.DDtipo = 'S'

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
end -- check 3
else begin -- check 3
  select distinct 'Intento de insertar registro duplicado en EDocumentosCP (documentos Aplicados) con el Documento:  ' || t.DocumentNo as Error
  from #table_name# t
  where exists(select 1 from EDocumentosCP 
			where Ecodigo = @Ecodigo  
 			  and CPTcodigo = @CPTcodigo  
			  and SNcodigo = @SNcodigo  
   			  and Ddocumento = t.DocumentNo )
end -- check 3
end -- check2
else begin -- check2

  select distinct 'Intento de insertar registro duplicado en EDocumentosCxP con el Documento:  ' || t.DocumentNo as Error
  from #table_name# t
  where exists(select 1 from EDocumentosCxP 
			where Ecodigo = @Ecodigo  
 			  and CPTcodigo = @CPTcodigo  
			  and SNcodigo = @SNcodigo  
   			  and EDdocumento = t.DocumentNo )


end -- check2

end -- check1
else begin -- check1

  select distinct 'Artículo no Existe o no tiene Existencias' as Error, a.Material as Artículo
  from #table_name# a
  where not exists(
    select 1
    from Articulos b, Existencias e
    where rtrim(a.Material) = rtrim(b.Acodigo)
      and b.Ecodigo = @Ecodigo
      and e.Alm_Aid  = @Alm_Aid 
      and b.Aid = e.Aid
      and rtrim(a.Material) != '')
    

end -- check1	
243	declare 
	@check1 numeric, 
	@check2 numeric, 
	@Alm_Aid numeric, 
	@Dcodigo numeric,
	@Mcodigo numeric, 
	@Icodigo char(5), 
	@Ocodigo int,
	@IDdocumento numeric,
	@Ccuentatransito numeric,
        @CPTcodigo char(2)

select @CPTcodigo = 'NR'

-- Validar que existan los Proveedores
  select distinct 'El Proveedor indicado no existe en el Catálogo de Socios de Negocios.' as Error, a.SNnumero as Proveedor
  from #table_name# a
  where not exists(
  select 1
  from SNegocios b
  where b.Ecodigo = @Ecodigo
    and b.SNnumero = a.SNnumero)

select @Icodigo = Pvalor from Parametros where Ecodigo = @Ecodigo and Pcodigo = 470

select @Alm_Aid = min(Aid) , @Dcodigo = min(Dcodigo)  from Almacen
where Ecodigo = @Ecodigo

-- Chequear existencia de artículo

select @check1 = count(1)
from #table_name# a
where not exists(select 1 from Articulos b, Existencias e
where b.Ecodigo = @Ecodigo
  and e.Alm_Aid  = @Alm_Aid
  and a.Acodigo= b.Acodigo
  and b.Aid = e.Aid )


if @check1 < 1 begin


-- Chequear llave alterna duplicada

select @check2 = count(1) from #table_name# t, SNegocios sn
where exists(select 1 from EDocumentosCxP 
			where Ecodigo = @Ecodigo  
 			  and CPTcodigo = @CPTcodigo  
			  and SNcodigo = sn.SNcodigo  
			  and t.SNnumero = sn.SNnumero
			  and sn.Ecodigo = @Ecodigo
   			  and rtrim(EDdocumento) = t.documento)


if @check2 < 1 begin

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


select @Mcodigo = Mcodigo from Empresas where Ecodigo = @Ecodigo
select @Ocodigo = min(Ocodigo) from Oficinas where Ecodigo = @Ecodigo

insert EDocumentosCxP
(Ecodigo, CPTcodigo, SNcodigo, Icodigo,Ocodigo, Ccuenta,  EDtipocambio, EDimpuesto, EDporcdescuento, EDdescuento, EDtotal, EDfecha, EDusuario, EDdocumento, Mcodigo )
select  distinct @Ecodigo, a.CPTcodigo , b.SNcodigo , @Icodigo,  @Ocodigo, b.SNcuentacxp , 1, 0 ,  0 ,0 , 0, getdate(), @Usulogin , a.documento, @Mcodigo 
from #table_name# a, SNegocios b
where b.Ecodigo = @Ecodigo
  and b.SNnumero = a.SNnumero


select @Ccuentatransito = min (b.IACtransito)
from  Existencias a, IAContables b
where a.Ecodigo = @Ecodigo
  and b.Ecodigo = a.Ecodigo
  and b.IACcodigo = a.IACcodigo
  and b.IACtransito is not null

--select * into borrar from #table_name#

insert DDocumentosCxP
(IDdocumento,  Aid,  Cid, Alm_Aid, Ecodigo, Dcodigo, Ccuenta,
 DDdescalterna, DDcantidad, DDpreciou, DDdesclinea, DDporcdesclin, DDtotallinea, DDtipo, DDtransito, 
 DDembarque, DDfembarque, DDobservaciones, DDdescripcion )
select 
  e.IDdocumento, art.Aid, null, @Alm_Aid, @Ecodigo, @Dcodigo, @Ccuentatransito ,  
  t.nombredelbarco, convert(float,t.cantidad), convert(float,t.preciounitario) as preciounitario, 0, 0, 0,'A',1, 
  t.codembarque, getdate(),  t.nombredelbarco || ' ' || t.state || ' ' || t.days, 'Prueba PMI'
from EDocumentosCxP e, #table_name# t, Articulos art, SNegocios sn
where e.Ecodigo = @Ecodigo
  and e.CPTcodigo = t.CPTcodigo
  and e.SNcodigo = sn.SNcodigo
  and sn.Ecodigo = e.Ecodigo
  and sn.SNnumero = t.SNnumero
  and rtrim(e.EDdocumento) = rtrim(t.documento)
  and e.CPTcodigo = t.CPTcodigo
  and art.Ecodigo = @Ecodigo
  and art.Acodigo =* t.Acodigo


--Determina la cuenta para los artículos en Tránsito
update DDocumentosCxP
set Ccuenta = isnull( (
	select iac.IACtransito
	from Existencias exi, IAContables iac
	where exi.Aid = d.Aid
	   and exi.Alm_Aid = d.Alm_Aid
	   and iac.IACcodigo = exi.IACcodigo
	   and iac.Ecodigo = exi.Ecodigo), 0)
from EDocumentosCxP e, DDocumentosCxP d
where e.CPTcodigo = @CPTcodigo
   and e.Ecodigo = @Ecodigo
   and e.EDdocumento in (select  distinct documento from #table_name#)
   and d.IDdocumento = e.IDdocumento
   and d.DDtipo = 'A'


-- Actualiza el total de la cada línea

update DDocumentosCxP
set DDtotallinea = d.DDcantidad * d.DDpreciou - d.DDdesclinea
from EDocumentosCxP e, DDocumentosCxP d
where e.Ecodigo = @Ecodigo
   and e.EDdocumento in (select  distinct documento from #table_name#)
   and d.IDdocumento = e.IDdocumento
   and d.DDtipo = 'A'


-- Actualiza el total del encabezado
update EDocumentosCxP 
set EDtotal = isnull((select sum(b.DDtotallinea) from DDocumentosCxP b
			where b.IDdocumento  =  EDocumentosCxP.IDdocumento), 0.00)
from #table_name# t2, SNegocios sn
where EDocumentosCxP.EDdocumento = t2.documento  
   and EDocumentosCxP.CPTcodigo = t2.CPTcodigo
   and EDocumentosCxP.SNcodigo = sn.SNcodigo
   and t2.SNnumero = sn.SNnumero
   and sn.Ecodigo = @Ecodigo
   and EDocumentosCxP.Ecodigo = @Ecodigo
 
-- Actualiza la descripción con la del artículo

 update DDocumentosCxP 
  set DDdescripcion = art.Adescripcion
from EDocumentosCxP a, DDocumentosCxP b, Articulos art
where a.CPTcodigo = @CPTcodigo
   and a.Ecodigo = @Ecodigo
   and a.EDdocumento in (select distinct documento from #table_name#)
   and a.IDdocumento = b.IDdocumento 
   and b.DDtipo = 'A'
   and b.Aid = art.Aid
   and a.Ecodigo = art.Ecodigo


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

end -- check2
else begin -- check2

  select distinct 'Intento de insertar registro duplicado en EDocumentosCxP con el Documento: ' || t.documento as Error
  from #table_name# t, SNegocios sn
  where exists(select 1 from EDocumentosCxP 
			where Ecodigo = @Ecodigo  
 			  and CPTcodigo = @CPTcodigo  
			  and SNcodigo = sn.SNcodigo
   			  and EDdocumento = t.documento)
	and t.SNnumero = sn.SNnumero
	and sn.Ecodigo = @Ecodigo
end -- check2


end -- check1
else begin -- check1

  select distinct 'Artículo no Existe o no tiene existencias' as Error, a.Acodigo as Artículo
  from #table_name# a
  where not exists(
  select 1
  from Articulos b , Existencias e
  where b.Ecodigo = @Ecodigo
    and e.Alm_Aid  = @Alm_Aid
    and a.Acodigo = b.Acodigo
    and b.Aid = e.Aid  )

end -- check1	
269	select 'hola',* from #table_name#	
333	declare @check1 numeric, @check2 numeric, @Alm_Aid numeric

-- Formatea la fecha
update #table_name#
set DocumentDate = substring(DocumentDate, 7,4) || substring(DocumentDate, 1,2) || substring(DocumentDate, 4,2)
where substring(DocumentDate,3,1)='/'

-- Actualiza los cantidades en nulo con cero
update #table_name# set QtyBBL = isnull(QtyBBL, '0')
update #table_name# set QtyBBL = case when rtrim(QtyBBL) = '' then '0' else QtyBBL end

-- Actualiza los montos negativos que vienen de la forma (#)
update #table_name# set QtyBBL = '-' + substring(QtyBBL, 2, datalength(QtyBBL)-2)
where QtyBBL like '(%)'

update #table_name# set Amount = '-' + substring(Amount, 2, datalength(Amount)-2)
where Amount like '(%)'

declare      @CCTcodigo char(2), @Mcodigo numeric, @SNcodigo int, @Icodigo char(5), @Ocodigo int, @Dcodigo int,
	@SNcuentacxc numeric, @Cid numeric, @CuentaConcepto numeric

select @SNcodigo = convert(int,Pvalor) from Parametros where Ecodigo = @Ecodigo and Pcodigo = 450
select @CCTcodigo = Pvalor from Parametros where Ecodigo = @Ecodigo and Pcodigo = 480
select @Icodigo = Pvalor from Parametros where Ecodigo = @Ecodigo and Pcodigo = 470


if (@SNcodigo is null or @CCTcodigo is null or @Icodigo is null) begin
   select 'Se deben definir todos los parámetros de importación' as Error
end


select @Alm_Aid = min(Aid) from Almacen where Ecodigo = @Ecodigo

-- Chequear existencia de artículo

select @check1 = count(1)
from #table_name# a
where not exists(select 1 from Articulos b, Existencias e
where rtrim(a.Material) = rtrim(b.Acodigo)
  and b.Ecodigo = @Ecodigo
  and e.Alm_Aid  = @Alm_Aid 
  and b.Aid = e.Aid)


if @check1 < 1 begin

-- Chequear llave alterna duplicada


select @check2 = count(1)
from #table_name# t
where exists(select 1 from EDocumentosCxC 
			where Ecodigo = @Ecodigo  
 			  and CCTcodigo = @CCTcodigo  
   			  and rtrim(EDdocumento) = rtrim(t.DocumentNo))

if @check2 < 1 begin

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


select @Mcodigo = Mcodigo from Empresas where Ecodigo = @Ecodigo

select @Ocodigo = min(Ocodigo) from Oficinas where Ecodigo = @Ecodigo

select @Dcodigo = min(Dcodigo) from Departamentos where Ecodigo = @Ecodigo

select @Cid = min(Cid) from Conceptos where Ecodigo = @Ecodigo and Ctipo = 'I'

select @SNcuentacxc = SNcuentacxc from SNegocios where Ecodigo = @Ecodigo and SNcodigo = @SNcodigo

select @CuentaConcepto = min(IACgastoajuste) from IAContables where Ecodigo = @Ecodigo


insert into EDocumentosCxC (
	Ecodigo, CCTcodigo, EDdocumento, Mcodigo, 
	SNcodigo, Icodigo, Ocodigo, Ccuenta, 
	EDtipocambio, EDimpuesto, EDporcdesc, EDdescuento, EDtotal, 
	EDfecha, EDusuario, EDselect
)
select distinct
	@Ecodigo, @CCTcodigo, DocumentNo, @Mcodigo, 
	@SNcodigo, @Icodigo, @Ocodigo, @SNcuentacxc, 
	1.00, 0.00, 0.00, 0.00, 0.00, 
	DocumentDate, @Usulogin, 0
from #table_name#


insert into DDocumentosCxC (
	EDid, 
                Aid, 
                Cid, 
                Alm_Aid, 
	Dcodigo, 
                Ccuenta, 
                DDdescripcion, 
                DDdescalterna, 
	DDcantidad, 
                DDpreciou, 
                DDdesclinea, DDporcdesclin, 
                DDtotallinea, 
	DDtipo)

select 
	e.EDid, 
	art.Aid as Articulo, 
	case when t.Material is null then @Cid else null end as Concepto, 
	case when t.Material is not null then @Alm_Aid else null end as Almacen, 	
	@Dcodigo as Depto,
	@SNcuentacxc as Cuenta, 
	isnull(art.Adescripcion, 'Concepto'), 
	isnull(art.Adescripcion, 'Concepto'), 	
	case when rtrim(t.Material) != '' then convert(float,t.QtyBBL) else 1 end, 
                convert(money,t.Amount)/case when convert(float,t.QtyBBL) != 0 then isnull(convert(float,t.QtyBBL),1) else 1 end, 
                0.00, 0.00, 
                convert(money,t.Amount), 
	case when rtrim(t.Material) != '' then 'A' else 'S' end
from #table_name# t, EDocumentosCxC e, Articulos art
where rtrim(e.EDdocumento) = rtrim(t.DocumentNo)
  and e.CCTcodigo = @CCTcodigo
  and e.EDfecha = convert(datetime,t.DocumentDate)
  and e.Ecodigo = @Ecodigo
  and art.Ecodigo = @Ecodigo
  and art.Acodigo =* t.Material

-- Actualiza el total del encabezado

update EDocumentosCxC set
 EDtotal = ( 
  (1+(c.Iporcentaje / 100.00)) * (isnull((
   select sum(b.DDtotallinea) 
   from DDocumentosCxC b, EDocumentosCxC a
   where b.EDid = a.EDid
     and a.EDid = EDocumentosCxC.EDid
   group by a.EDid), 0.00) -  EDocumentosCxC.EDdescuento))
from Impuestos c          
where EDocumentosCxC.Ecodigo = @Ecodigo
  and EDocumentosCxC.EDtotal = 0.00
  and EDocumentosCxC.EDtipocambio = 1.00
  and EDocumentosCxC.EDimpuesto = 0.00
  and EDocumentosCxC.EDporcdesc = 0.00
  and EDocumentosCxC.EDdescuento = 0.00
  and c.Ecodigo = EDocumentosCxC.Ecodigo
  and c.Icodigo = EDocumentosCxC.Icodigo


-- Actualiza la cuenta de Inventario
update DDocumentosCxC
set Ccuenta = isnull( (
	select iac.IACinventario
	from Existencias exi, IAContables iac
	where exi.Aid = d.Aid
	   and exi.Alm_Aid = d.Alm_Aid
	   and iac.IACcodigo = exi.IACcodigo
	   and iac.Ecodigo = exi.Ecodigo), 0)
from EDocumentosCxC e, DDocumentosCxC d
where e.CCTcodigo = @CCTcodigo
   and e.SNcodigo = @SNcodigo
   and e.Ecodigo = @Ecodigo
   and e.EDdocumento in (select  distinct DocumentNo from #table_name#)
   and d.EDid = e.EDid
   and d.DDtipo = 'A'

--Asigna la cuenta para los Conceptos
update DDocumentosCxC
set Ccuenta = @CuentaConcepto, Cid = @Cid
from EDocumentosCxC e, DDocumentosCxC d
where e.CCTcodigo = @CCTcodigo
   and e.SNcodigo = @SNcodigo
   and e.Ecodigo = @Ecodigo
   and e.EDdocumento in (select  distinct DocumentNo from #table_name#)
   and d.EDid = e.EDid
   and d.DDtipo = 'S'

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

end -- check2
else begin -- check2

  select distinct 'Intento de insertar registro duplicado en EDocumentosCxC con el Documento:  ' || t.DocumentNo as Error
  from #table_name# t
  where exists(select 1 from EDocumentosCxC 
			where Ecodigo = @Ecodigo  
 			  and CCTcodigo = @CCTcodigo  
   			  and EDdocumento = t.DocumentNo )


end -- check2

end -- check1
else begin -- check1

  select distinct 'Artículo no Existe o no tiene Existencias' as Error, a.Material as Artículo
  from #table_name# a
  where not exists(
  select 1
  from Articulos b, Existencias e
  where rtrim(a.Material) = rtrim(b.Acodigo)
    and b.Ecodigo = @Ecodigo
    and e.Alm_Aid  = @Alm_Aid 
    and b.Aid = e.Aid)

end -- check1	
334	declare @check1 numeric, @check2 numeric, @check3 numeric, @check4 numeric, @check5 numeric, @check6 numeric, @lote int, @llave numeric, @fechavigente datetime

-- Chequear existencia de empleado
select @check1 = count(1)
from #table_name# a
where not exists(
select 1
from DatosEmpleado b, LineaTiempo c
where b.DEidentificacion = a.DEidentificacion
and b.NTIcodigo = a.NTIcodigo
and b.Ecodigo = @Ecodigo
and b.DEid = c.DEid
and a.RHAfdesde between c.LTdesde and c.LThasta
)

if @check1 < 1 begin

-- Validar que no existan duplicados en el archivo
select @check2 = count(count(1))
from #table_name#
group by NTIcodigo, DEidentificacion
having count(1) > 1

if @check2 < 1 begin

-- Validar que no existan montos negativos en los datos a importar
select @check3 = count(1)
from #table_name#
where RHDvalor < 0.00

if @check3 < 1 begin
    
-- Validar que la fecha de vigencia del aumento sea unico en todo el archivo de importacion
select @check4 = count(distinct RHAfdesde)
from #table_name#

if @check4 = 1 begin

-- Validar que la fecha de Aumento en el Lote no haya sido registrado anteriormente para un empleado
select @check5 = count(1)
from #table_name# a
where exists(
select 1
from RHEAumentos b, RHDAumentos e
where b.RHAfdesde = a.RHAfdesde
   and e.RHAid = b.RHAid
   and e.NTIcodigo = a.NTIcodigo
   and e.DEidentificacion = a.DEidentificacion
)

if @check5 < 1 begin

-- Valida que los tipos de Identificación sea válidos
select @check6 = count(1)
from #table_name# a
where not exists(
select 1
from NTipoIdentificacion b
where b.NTIcodigo = a.NTIcodigo
)

if @check6 < 1 begin

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
select @lote = isnull(max(RHAlote)+1, 1) from RHEAumentos
where Ecodigo = @Ecodigo

select @fechavigente = RHAfdesde
from #table_name#

-- Insertar Encabezado de Relación
insert RHEAumentos (Ecodigo, RHAlote, Usucodigo, RHAfecha, RHAfdesde, RHAestado, RHAusucodigo, RHAfautoriza)
values (@Ecodigo, @lote, @Usucodigo, getdate(), @fechavigente, 0, null, null)

select @llave = @@identity

-- Insertar Detalle de Relación
insert RHDAumentos (RHAid, NTIcodigo, DEidentificacion, RHDtipo, RHDvalor)
select @llave, NTIcodigo, DEidentificacion, 0, RHDvalor
from #table_name#

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
end -- check6
else begin -- check6

select distinct 'Tipo de Identificación Inválido' as Error, NTIcodigo as TipoIdentificacion
from #table_name# a
where not exists(
select 1
from NTipoIdentificacion b
where b.NTIcodigo = a.NTIcodigo
)

end -- else check6

end -- check5
else begin -- check5

select distinct 'Fecha de Aumento en el Lote ya fue registrado para este empleado' as Error, a.RHAfdesde as FechaVigencia, a.DEidentificacion as Cedula
from #table_name# a
where exists(
select 1
from RHEAumentos b, RHDAumentos e
where b.RHAfdesde = a.RHAfdesde
   and e.RHAid = b.RHAid
   and e.NTIcodigo = a.NTIcodigo
   and e.DEidentificacion = a.DEidentificacion
)

end -- else check5

end -- check4
else begin -- check4

select 'No debe haber mas de una fecha vigente en el archivo de importacion' as Error, RHAfdesde as Vigencia
from #table_name#
group by RHAfdesde

end -- else check4
 
end -- check3
else begin -- check3

select 'Aumento NO puede ser negativo' as Error, DEidentificacion as Empleado, RHDvalor as Aumento
from #table_name#
where RHDvalor < 0.00

end -- else check3
 
end -- check2
else begin -- check2

select 'Empleado con mas de un Aumento Salarial' as Error, DEidentificacion as Empleado
from #table_name#
group by NTIcodigo, DEidentificacion
having count(1) > 1

end -- else check2
 
end -- check1
else begin -- check1

select distinct 'Empleado no Existe o no esta Nombrado' as Error, NTIcodigo as TipoIdentificacion, DEidentificacion as Empleado
from #table_name# a
where not exists(
select 1
from DatosEmpleado b, LineaTiempo c
where b.DEidentificacion = a.DEidentificacion
and b.NTIcodigo = a.NTIcodigo
and b.Ecodigo = @Ecodigo
and b.DEid = c.DEid
and a.RHAfdesde between c.LTdesde and c.LThasta
)

end -- else check1	
336	 select * from #table_name# where fname like '%PAULA%'	 
337	select * from #table_name# where fname like '%PAULA%'	
338	declare @check1 numeric, @check2 numeric, @check3 numeric, @check4 numeric, @check5 numeric, @check6 numeric, @lote int, @llave numeric, @fechavigente datetime

-- Chequear existencia de empleado
select @check1 = count(1)
from #table_name# a
where not exists(
select 1
from DatosEmpleado b, LineaTiempo c
where b.DEidentificacion = a.DEidentificacion
and b.NTIcodigo = a.NTIcodigo
and b.Ecodigo = @Ecodigo
and b.DEid = c.DEid
and a.RHAfdesde between c.LTdesde and c.LThasta
)

if @check1 < 1 begin

-- Validar que no existan duplicados en el archivo
select @check2 = count(count(1))
from #table_name#
group by NTIcodigo, DEidentificacion
having count(1) > 1

if @check2 < 1 begin

-- Validar que no existan montos negativos en los datos a importar
select @check3 = count(1)
from #table_name#
where RHDvalor < 0.00

if @check3 < 1 begin
    
-- Validar que la fecha de vigencia del aumento sea unico en todo el archivo de importacion
select @check4 = count(distinct RHAfdesde)
from #table_name#

if @check4 = 1 begin

-- Validar que la fecha de Aumento en el Lote no haya sido registrado anteriormente para un empleado
select @check5 = count(1)
from #table_name# a
where exists(
select 1
from RHEAumentos b, RHDAumentos e
where b.RHAfdesde = a.RHAfdesde
   and e.RHAid = b.RHAid
   and e.NTIcodigo = a.NTIcodigo
   and e.DEidentificacion = a.DEidentificacion
)

if @check5 < 1 begin

-- Valida que los tipos de Identificación sea válidos
select @check6 = count(1)
from #table_name# a
where not exists(
select 1
from NTipoIdentificacion b
where b.NTIcodigo = a.NTIcodigo
)

if @check6 < 1 begin

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
select @lote = isnull(max(RHAlote)+1, 1) from RHEAumentos
where Ecodigo = @Ecodigo

select @fechavigente = RHAfdesde
from #table_name#

-- Insertar Encabezado de Relación
insert RHEAumentos (Ecodigo, RHAlote, Usucodigo, RHAfecha, RHAfdesde, RHAestado, RHAusucodigo, RHAfautoriza)
values (@Ecodigo, @lote, @Usucodigo, getdate(), @fechavigente, 0, null, null)

select @llave = @@identity

-- Insertar Detalle de Relación
insert RHDAumentos (RHAid, NTIcodigo, DEidentificacion, RHDtipo, RHDvalor)
select @llave, NTIcodigo, DEidentificacion, 0, RHDvalor
from #table_name#

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
end -- check6
else begin -- check6

select distinct 'Tipo de Identificación Inválido' as Error, NTIcodigo as TipoIdentificacion
from #table_name# a
where not exists(
select 1
from NTipoIdentificacion b
where b.NTIcodigo = a.NTIcodigo
)

end -- else check6

end -- check5
else begin -- check5

select distinct 'Fecha de Aumento en el Lote ya fue registrado para este empleado' as Error, a.RHAfdesde as FechaVigencia, a.DEidentificacion as Cedula
from #table_name# a
where exists(
select 1
from RHEAumentos b, RHDAumentos e
where b.RHAfdesde = a.RHAfdesde
   and e.RHAid = b.RHAid
   and e.NTIcodigo = a.NTIcodigo
   and e.DEidentificacion = a.DEidentificacion
)

end -- else check5

end -- check4
else begin -- check4

select 'No debe haber mas de una fecha vigente en el archivo de importacion' as Error, RHAfdesde as Vigencia
from #table_name#
group by RHAfdesde

end -- else check4
 
end -- check3
else begin -- check3

select 'Aumento NO puede ser negativo' as Error, DEidentificacion as Empleado, RHDvalor as Aumento
from #table_name#
where RHDvalor < 0.00

end -- else check3
 
end -- check2
else begin -- check2

select 'Empleado con mas de un Aumento Salarial' as Error, DEidentificacion as Empleado
from #table_name#
group by NTIcodigo, DEidentificacion
having count(1) > 1

end -- else check2
 
end -- check1
else begin -- check1

select distinct 'Empleado no Existe o no esta Nombrado' as Error, NTIcodigo as TipoIdentificacion, DEidentificacion as Empleado
from #table_name# a
where not exists(
select 1
from DatosEmpleado b, LineaTiempo c
where b.DEidentificacion = a.DEidentificacion
and b.NTIcodigo = a.NTIcodigo
and b.Ecodigo = @Ecodigo
and b.DEid = c.DEid
and a.RHAfdesde between c.LTdesde and c.LThasta
)

end -- else check1	 
438	declare @check1 numeric, @check2 numeric, @check3 numeric, @check4 numeric, @check5 numeric, @check6 numeric, @Afecha datetime
select @Afecha = getDate()

-- Chequear existencia de articulos
select @check1 = count(1)
from #table_name# a, Articulos b
where b.Acodigo = a.Acodigo
and b.Ecodigo = @Ecodigo

if @check1 < 1 begin
 -- Validar existencia de Unidades
 select @check2 = count(1)
  from #table_name# a
  where not exists( select 1
                          from Unidades b
                          where b.Ucodigo = a.Ucodigo
                             and b.Ecodigo = @Ecodigo)

 if @check2 < 1 begin
  -- Validar existencia de Clasificacion
  select @check3 = count(1)
   from #table_name# a
   where not exists( select 1
                             from Clasificaciones b
                              where b.Ccodigoclas = a.Ccodigoclas
                                 and b.Ecodigo = @Ecodigo)

  if @check3 < 1 begin
   -- Validar que no existan duplicados en el archivo
  select @check4 = count(count(1))
    from #table_name#
    group by Acodigo
    having count(1) > 1
  
  if @check4 < 1 begin
   -- Validar que existan las marcas
   select @check5 = count(1)
    from #table_name# a
    where a.AFMcodigo is not null
        and ltrim(rtrim(a.AFMcodigo ))<> ''
        and not exists( select 1
                              from AFMarcas b
                               where b.AFMcodigo = a.AFMcodigo
                                 and b.Ecodigo = @Ecodigo)

   if @check5 < 1 begin
    --VAlidar que exita modelo-marca
    select @check6 = count(1)
      from #table_name# a
      where a.AFMcodigo is not null and ltrim(rtrim(a.AFMcodigo))<>''
         and a.AFMMcodigo is not null and ltrim(rtrim(a.AFMMcodigo))<>''
         and not exists( select 1
                                  from AFMModelos b, AFMarcas c
                                  where a.AFMcodigo = c.AFMcodigo
                                     and c.AFMid = b.AFMid
                                     and b.AFMMcodigo = a.AFMMcodigo
                                     and b.Ecodigo = @Ecodigo
                                     and c.Ecodigo = @Ecodigo)
     if @check6 < 1 begin
      -- Insertar Artículos
      insert Articulos ( Ecodigo, Acodigo, Acodalterno, Ucodigo, Ccodigo, Adescripcion, Afecha, AFMid, AFMMid)
               select   @Ecodigo, a.Acodigo, a.Acodalterno, a.Ucodigo, b.Ccodigo, a.Adescripcion, @Afecha, c.AFMid, d.AFMMid
               from #table_name# a, Clasificaciones b, AFMarcas c, AFMModelos d
               where a.Ccodigoclas = b.Ccodigoclas
                  and b.Ecodigo = @Ecodigo
                  and c.Ecodigo = @Ecodigo
                  and d.Ecodigo = @Ecodigo
                  and a.AFMcodigo *= c.AFMcodigo
                  and c.AFMid *= d.AFMid
                  and a.AFMMcodigo *= d.AFMMcodigo

     end
     else begin
      select 'Codigo Marca-Modelo no esta registrado en el sistema' as Error, a.AFMcodigo as Marca, a.AFMMcodigo as Modelos
       from #table_name# a
       where a.AFMcodigo is not null
         and ltrim(rtrim(a.AFMcodigo)) <> ''
         and a.AFMMcodigo is not null
         and ltrim(rtrim(a.AFMMcodigo)) <> ''
         and not exists( select 1
                                from AFMModelos b, AFMarcas c
                                where a.AFMcodigo = c.AFMcodigo
                                   and c.AFMid = b.AFMid
                                   and b.AFMMcodigo = a.AFMMcodigo
                                   and b.Ecodigo = @Ecodigo
                                   and c.Ecodigo = @Ecodigo )

     end --check6
   end
   else begin
     select 'Codigo de marca no esta registrado en el sistema' as Error, a.AFMcodigo as Marca
       from #table_name# a
        where a.AFMcodigo is not null
         and ltrim(rtrim(a.AFMcodigo)) <> ''
         and not exists( select 1
                               from AFMarcas b
                                where b.AFMcodigo = a.AFMcodigo
                                   and b.Ecodigo = @Ecodigo)


   end--check 5
  end -- check4
  else begin -- check4
    select 'Código de Artículo aparece duplicado en el archivo' as Error, Acodigo as Articulo
    from #table_name#
    group by Acodigo
    having count(1) > 1
  end -- else check4
 end -- check3
 else begin -- check3
  select distinct 'Código de Clasificación no está registrado en el sistema' as Error, a.Ccodigoclas as Clasificacion
    from #table_name# a
    where  not exists( select 1
                               from Clasificaciones b
                                where b.Ccodigoclas = a.Ccodigoclas
                                   and b.Ecodigo = @Ecodigo )

 end -- else check3
end -- check2
else begin -- check2
  select distinct 'Código de Unidad no está registrado en el sistema' as Error, a.Ucodigo as Unidad
   from #table_name# a
   where  not exists( select 1
                                 from Unidades b
                                 where b.Ucodigo = a.Ucodigo
                                  and b.Ecodigo = @Ecodigo )

end -- else check2
end -- check1
else begin -- check1
  select distinct 'Código de Artículo ya existe en el sistema' as Error, a.Acodigo as Articulo
  from #table_name# a, Articulos b
  where b.Acodigo = a.Acodigo
   and b.Ecodigo = @Ecodigo
end -- else check1	
439	declare @check1 numeric, @check2 numeric, @check3 numeric, @check4 numeric, @check5 numeric, @check6 numeric, @SNcodigo int

-- Chequear existencia de Números de Socio
select @check1 = count(1)
from #table_name# a, SNegocios b
where b.SNnumero = a.SNnumero
and b.Ecodigo = @Ecodigo

if @check1 < 1 begin

-- Chequear existencia de Identificación de Socio
select @check2 = count(1)
from #table_name# a, SNegocios b
where b.SNidentificacion = a.SNidentificacion
and b.Ecodigo = @Ecodigo

if @check2 < 1 begin

-- Validar que el Código no esté duplicado en el archivo
select @check3 = count(count(1))
from #table_name#
group by SNnumero
having count(1) > 1

if @check3 < 1 begin

-- Validar que la Identificación no esté duplicada en el archivo
select @check4 = count(count(1))
from #table_name#
group by SNidentificacion
having count(1) > 1

if @check4 < 1 begin

select @SNcodigo = isnull(max(SNcodigo),0) 
from SNegocios 
where Ecodigo = @Ecodigo 
and SNcodigo <> 9999

insert SNegocios (Ecodigo,SNnumero,  SNcodigo, SNnombre, SNidentificacion, SNtiposocio, SNtelefono, SNFax, SNemail, SNtipo, SNvencompras, SNvenventas, SNdireccion, SNFecha, SNcertificado)
select @Ecodigo, a.SNnumero, id + @SNcodigo, a.SNnombre, a.SNidentificacion, ltrim(rtrim(a.SNtiposocio)), a.SNtelefono, a.SNFax, a.SNemail, ltrim(rtrim(a.SNtipo)), a.SNvencompras, a.SNvenventas, a.SNdireccion, getDate(), 0
from #table_name# a

end -- check4
else begin -- check4

select 'Identificación del Socio de Negocio aparece duplicado en el archivo' as Error, a.SNidentificacion as Identificacion
from #table_name# a
group by SNidentificacion
having count(1) > 1

end -- else check4

end -- check3
else begin -- check3

select 'Código de Socio de Negocio aparece duplicado en el archivo' as Error, a.SNnumero as Codigo
from #table_name# a
group by SNnumero
having count(1) > 1

end -- else check3

end -- check2
else begin -- check2

select distinct 'Identificación del Socio ya existe en el sistema' as Error, a.SNidentificacion as Identificacion
from #table_name# a, SNegocios b
where b.SNidentificacion = a.SNidentificacion
and b.Ecodigo = @Ecodigo

end -- else check2

end -- check1
else begin -- check1

select distinct 'Código de Socio ya existe en el sistema' as Error, a.SNnumero as Codigo
from #table_name# a, SNegocios b
where b.SNnumero = a.SNnumero

end -- else check1	
440	declare @check1 numeric, @check2 numeric, @check3 numeric, @check4 numeric, @check5 numeric, @check6 numeric

-- Chequear existencia de Artículos
select @check1 = count(1)
from #table_name# a
where not exists(
select 1
from Articulos b
where b.Acodigo = a.Acodigo
and b.Ecodigo = @Ecodigo
)

if @check1 < 1 begin

-- Chequear existencia de Almacén
select @check2 = count(1)
from #table_name# a
where not exists(
select 1
from Almacen b
where b.Almcodigo = a.Almcodigo
and b.Ecodigo = @Ecodigo
)

if @check2 < 1 begin

-- Chequear Existencia de Cuenta Contable
select @check3 = count(1)
from #table_name# a
where not exists(
select 1
from IAContables b
where b.IACcodigogrupo = a.IACcodigogrupo
and b.Ecodigo = @Ecodigo
)

if @check3 < 1 begin

-- Chequear si las existencias ya están registradas en el sistema
select @check4 = count(1)
from #table_name# a, Articulos b, Almacen c, Existencias d
where b.Acodigo = a.Acodigo
and b.Ecodigo = @Ecodigo
and c.Almcodigo = a.Almcodigo
and c.Ecodigo = @Ecodigo
and d.Aid = b.Aid
and d.Alm_Aid = c.Aid

if @check4 < 1 begin

-- Validar que no existan duplicados en el archivo
select @check5 = count(count(1))
from #table_name#
group by Acodigo, Almcodigo
having count(1) > 1

if @check5 < 1 begin

-- Insertar Existencias
insert Existencias (Ecodigo, Aid, Alm_Aid, IACcodigo, Eexistencia, Ecostou, Epreciocompra, Ecostototal, Esalidas, Eestante, Ecasilla, Eexistmin, Eexistmax)
select @Ecodigo, b.Aid, c.Aid, d.IACcodigo, 0.00, 0.00, 0.00, 0.00, 0.00, a.Eestante, a.Ecasilla, a.Eexistmin, a.Eexistmax
from #table_name# a, Articulos b, Almacen c, IAContables d
where b.Acodigo = a.Acodigo
and b.Ecodigo = @Ecodigo
and c.Almcodigo = a.Almcodigo
and c.Ecodigo = @Ecodigo
and a.IACcodigogrupo *= d.IACcodigogrupo
and d.Ecodigo = @Ecodigo

end -- check5
else begin -- check5

select 'Combinación de Artículo y Almacén aparece duplicado en el archivo' as Error, Acodigo as Articulo, Almcodigo as Almacen
from #table_name#
group by Acodigo, Almcodigo
having count(1) > 1

end -- else check5

end -- check4
else begin -- check4

select 'Existencia ya está registrada en el sistema' as Error, a.Acodigo as Articulo, a.Almcodigo as Almacen
from #table_name# a, Articulos b, Almacen c, Existencias d
where b.Acodigo = a.Acodigo
and b.Ecodigo = @Ecodigo
and c.Almcodigo = a.Almcodigo
and c.Ecodigo = @Ecodigo
and d.Aid = b.Aid
and d.Alm_Aid = c.Aid

end -- else check4

end -- check3
else begin -- check3

select distinct 'Código de Cuenta Contable no existe en el sistema' as Error, a.IACcodigogrupo as Cuenta_Contable
from #table_name# a
where not exists(
select 1
from IAContables b
where b.IACcodigogrupo = a.IACcodigogrupo
and b.Ecodigo = @Ecodigo
)

end -- else check3

end -- check2
else begin -- check2

select distinct 'Código de Almacén no existe en el sistema' as Error, a.Almcodigo as Almacen
from #table_name# a
where not exists(
select 1
from Almacen b
where b.Almcodigo = a.Almcodigo
and b.Ecodigo = @Ecodigo
)

end -- else check2

end -- check1
else begin -- check1

select distinct 'Código de Artículo no existe en el sistema' as Error, a.Acodigo as Articulo
from #table_name# a
where not exists(
select 1
from Articulos b
where b.Acodigo = a.Acodigo
and b.Ecodigo = @Ecodigo
)

end -- else check1	
441		declare @archivo int --pasar compo parametro el consecutivo que se genera
declare @cedulajur char(12)
declare @cedula char(12) --cedula de usuario que registra
declare @DEid numeric --id de usuario que registra
declare @testkey numeric
declare @cuenta varchar(20)
declare @documento int
 
-- revisar esto bien 
select @archivo = 0

-- Calcula el numero de consecutivo(archivo) NO ESTA EN PRODUCCION
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
        data varchar(255)
         )
 
insert ##RHExportarBCR(orden, data)
select 1, replicate('',2)||'0'
                  || replicate( '', 12 - datalength(@cedulajur) ) 
                  || convert(varchar, @cedulajur)
         || replicate('',3- datalength(convert(varchar,@archivo)) )
      || convert(varchar, @archivo)
      || substring(convert(varchar,ERNfdeposito,103),1,2)||substring(convert(varchar,ERNfdeposito,103),4,2)||substring(convert(varchar,ERNfdeposito,103),9,2)
      || replicate('',12 - datalength(@cedula))
      || @cedula
      || replicate('',12 - datalength(convert(varchar,@testkey)) )  
      || convert(varchar(255), @testkey)
      || replicate('',19)||'0'
      || replicate('',15)||'0'
from ERNomina
where ERNid=@ERNid
 
insert ##RHExportarBCR(orden, data)
select 2, replicate('',2)
 || '02'
 || replicate('',4) || '0'
 || replicate('', 3-datalength(convert(varchar, convert(int,substring(a.CBcc, 6, 3)))))
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

 || substring(convert(varchar,getDate(),103),1,2)||substring(convert(varchar,getDate(),103),4,2)||substring(convert(varchar,getDate(),103),9,2)
 || '0'
 || convert(varchar,b.ERNdescripcion)||replicate('', 30-datalength(rtrim(b.ERNdescripcion)))
 || '0'
from DRNomina a, ERNomina b
where a.ERNid=@ERNid
and b.ERNid=@ERNid
and b.Ecodigo=@Ecodigo
and a.ERNid=b.ERNid
and a.Bid=@Bid
and datalength(rtrim(a.CBcc)) > 9

declare @c1 int, @c2 int
select @c1 = count(1) from DRNomina a, ERNomina b
where a.ERNid=@ERNid
and b.ERNid=@ERNid
and b.Ecodigo=@Ecodigo
and a.ERNid=b.ERNid
and a.Bid=@Bid

select @c2 = count(1) from ##RHExportarBCR

if @c1 != (@c2 -1)
 select 'La cantidad de Personas generadas en el archivo para este Banco no concuerda con la cantidad de Personas en la Relación de Cálculo!' as Error

select data from ##RHExportarBCR order by orden 
 
-- actualiza el consecutivo en RHParametros NO ESTA EN PRODUCCION
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


442		declare 
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
	|| replicate('',1) || substring(convert(varchar,@fpago ,103),1,2)||substring(convert(varchar,@fpago ,103),4,2)||substring(convert(varchar,@fpago ,103),9,2)
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
    || replicate('',7) || '1'
	|| replicate('',15-datalength(convert(varchar,sum(a.DRNliquido)*100))) || convert(varchar,convert(numeric,sum(a.DRNliquido)*100))
	|| substring(convert(varchar,@fpago ,103),1,2)||substring(convert(varchar,@fpago ,103),4,2)||substring(convert(varchar,@fpago ,103),9,2)
	|| '0'
	|| convert(varchar,b.ERNdescripcion)||replicate('', 30-datalength(rtrim(b.ERNdescripcion)))
	|| '0',
	1
from DRNomina a, ERNomina b
where b.ERNid = @ERNid
and b.Ecodigo = @Ecodigo
and b.ERNid = a.ERNid
and a.Bid is not null
 
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
 || replicate('',1) || case when datalength(convert(varchar, DRNlinea)) < 8 then replicate('', 8-datalength(convert(varchar, DRNlinea))) end
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
		data = substring(data,1,30) || replicate('',4-datalength(convert(varchar,@contador))) || convert(varchar,@contador) || substring(data,36,datalength(data)), @contador=@contador + 1 
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
444		if object_id('##RHExportarBPPR') is not null
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
534	 	
535		select  a.DRIdentificacion
 || char(9)
 || a.DRNapellido1
 || ' '
 || a.DRNapellido2
 || ' '
 || a.DRNnombre
 || char(9)
 || convert(varchar, convert(int,substring(a.CBcc, 6, 3)))
 || '-'
 || substring(a.CBcc, 9, datalength(rtrim(a.CBcc))-9)
 || char(9)
 || convert(varchar,DRNliquido) as datos
from DRNomina a, ERNomina b
where a.ERNid=@ERNid
and b.ERNid=@ERNid
and b.Ecodigo=@Ecodigo
and a.ERNid=b.ERNid
and a.Bid=@Bid
and datalength(rtrim(a.CBcc)) > 9
541	declare @check1 numeric, @Dcodigo numeric, @Ocodigo numeric, @RHPMid numeric, @RHPMfproceso datetime

-- Chequear existencia de Tarjetas Correctas
select @check1 = count(1)
from #table_name# a
where not exists(
select 1
from DatosEmpleado b
where b.DEtarjeta = a.Tarjeta
and b.Ecodigo = @Ecodigo
)

if @check1 < 1 begin

select @Dcodigo = min(Dcodigo) 
from Departamentos
where Ecodigo = @Ecodigo

select @Ocodigo = min(Ocodigo) 
from Oficinas
where Ecodigo = @Ecodigo

insert RMarcas(Ecodigo, RHPMid, RMtiporegis, RMfecha, Dcodigo, Ocodigo, DEid, DEidentificacion, RMreloj, RMmarcaproces, BMUsucodigo, BMfecha)
select @Ecodigo, -@Ecodigo, '1', convert(varchar, convert(datetime, a.Fecha), 106) || ' ' || substring(a.Hora, 1, 2) || ':' || substring(a.Hora, 3, 2) || ':' || substring(a.Hora, 5, 2), @Dcodigo, @Ocodigo, b.DEid, b.DEidentificacion, a.RMreloj, 0, @Usucodigo, getDate()
from #table_name# a, DatosEmpleado b
where a.Tarjeta = b.DEtarjeta
and b.Ecodigo = @Ecodigo
and convert(datetime, substring(a.Hora, 1, 2) || ':' || substring(a.Hora, 3, 2) || ':' || substring(a.Hora, 5, 2)) < '12:00:00'

insert RMarcas(Ecodigo, RHPMid, RMtiporegis, RMfecha, Dcodigo, Ocodigo, DEid, DEidentificacion, RMreloj, RMmarcaproces, BMUsucodigo, BMfecha)
select @Ecodigo, -@Ecodigo, '2', convert(varchar, convert(datetime, a.Fecha), 106) || ' ' || substring(a.Hora, 1, 2) || ':' || substring(a.Hora, 3, 2) || ':' || substring(a.Hora, 5, 2), @Dcodigo, @Ocodigo, b.DEid, b.DEidentificacion, a.RMreloj, 0, @Usucodigo, getDate()
from #table_name# a, DatosEmpleado b
where a.Tarjeta = b.DEtarjeta
and b.Ecodigo = @Ecodigo
and convert(datetime, substring(a.Hora, 1, 2) || ':' || substring(a.Hora, 3, 2) || ':' || substring(a.Hora, 5, 2)) >= '12:00:00'

end -- check1
else begin -- else check1

select distinct 'No existe nigún empleado con esta tarjeta, nombrado hasta la fecha' as Error, a.Tarjeta as Tarjeta
from #table_name# a
where not exists(
select 1
from DatosEmpleado b
where b.DEtarjeta = a.Tarjeta
and b.Ecodigo = @Ecodigo
)

end -- else check1	
641		set nocount on
/*
Este archivo tiene que incluir la información acumulada de todas las planillas pagadas en un mes y año en particular que le es indicada por el usuario
2. Para el caso de Nación, esta información corresponde a todas aquellas nóminas que corresponden a un mismo mes, esto quiere decir que la fecha fin de la nómina este el mes que estoy solicitando.
4. Este archivo para algunos meses por ende contendrá 3 o 2 bisemanas juntas
5. El formato del archivo debe ser el siguiente:
    a) 01 - 01 Todos los registros 4
    b) 02 - 07 Número patronal
    c) 08 - 09 Sector del patrono
    d) 10 - 10 Digito verificador 
    e) 11 - 11 Tipo de cédula (0 nacionales, 7 extranjeros)
    f) 12 - 21 Número de cédula o asegurado
    g) 22 - 51 Apellidos y nombre del empleado (En MAYÚSCULA)
    h) 52 - 61 Espacio en blanco
    i) 62 - 70 Salario (con dos decimales y sin punto)
    j) 71 - 71 Clase de seguro (En MAYUSCULA)
    k) 72 - 72 Observaciones (En MAYUSCULA)
    l) 73 - 80 Espacios en Blanco

k) Esto se llena solamente para aquellos empleados 
que en el mes que se esta sacando hayan 'ingresado', 'salido' 
o hayan estado incapacitados.   
Para el caso que hayan ingresado se pone una 'E', 
para el caso que hayan salido se pone una 'S' 
y para el caso que hayn tenido una incapacidad en el mes actual se pone una 'I'
           
l) Para el caso reciba de monto 0 en su salario (incapacidad diferente a maternidad), debe sustituirse el campo 72 la I por el mes en que se inició la incapacidad, de acuerdo a la siguiente simbología
        1 Enero
        2 Febrero
        3 Marzo
        4 Abril
        5 Mayo
        6 Junio
        7 Julio
        8 Agosto
        9 Setiembre
        0 Octubre
        N Noviembre
        X Diciembre
*/

declare @f1 datetime, @f2 datetime

select @f1 = min(CPdesde)
   from  CalendarioPagos 
where CPmes = @CPmes
    and CPperiodo = @CPperiodo
    and Ecodigo =@Ecodigo

select  @f2= max(CPhasta)
   from  CalendarioPagos 
where CPmes = @CPmes
    and CPperiodo = @CPperiodo
    and Ecodigo =@Ecodigo


--- Parametros que deben incorporarse en la tabla RHParametros y deben leerse al iniciar la consulta
declare @numeropatronal char(9) 

select @numeropatronal = ' '

select @numeropatronal = Pvalor
from RHParametros
where Ecodigo = @Ecodigo
  and Pcodigo = 300

create table #reporte (
	DEid numeric, 
	denombre char(30), 
	texto char(61), 
	observaciones char(1), 
	salario money,
	ordenar char(1)
)

/* Insertar todos los empleados que tuvieron salario en el mes con el salario bruto de HSalarioEmpleado */ 
insert #reporte (DEid, denombre, texto, observaciones, salario,ordenar)
select 
	e.DEid as DEid, 
	convert(char(30), upper(e.DEapellido1) || ' ' || upper(e.DEapellido2) || ' ' || upper(e.DEnombre)) as denombre,
	'4' || 
	@numeropatronal || 
	case when e.NTIcodigo = 'C' then '0' else '7' end ||
	replicate ('0', 10 - datalength(convert(varchar(10), e.DEidentificacion))) ||
	convert(varchar(10), e.DEidentificacion) ||
	convert(char(30), upper(e.DEapellido1) || ' ' || upper(e.DEapellido2) || ' ' || upper(e.DEnombre)) ||
	'          ' as texto,
	' ' as observaciones,
	sum(h.SEsalariobruto) as salario, ' '
from CalendarioPagos c (index CalendarioPagos_01), HSalarioEmpleado h, DatosEmpleado e
where c.Ecodigo = @Ecodigo
  and c.CPperiodo = @CPperiodo
  and c.CPmes = @CPmes
  and h.RCNid = c.CPid
  and e.DEid = h.DEid
group by e.NTIcodigo, e.DEidentificacion, e.DEapellido1, e.DEapellido2, e.DEnombre

update #reporte
set salario = salario 
	+ isnull(
		(select sum(se.SEsalariobruto)
		from SalarioEmpleado se, CalendarioPagos c
		where se.DEid = #reporte.DEid
		  and c.CPid = se.RCNid
		  and c.CPperiodo = @CPperiodo
		  and c.CPmes = @CPmes
		)
		, 0)

/* Actualizar el monto de salario tomando en cuenta las incidencias aplicadas */
update #reporte
set salario = salario + isnull(
	(select sum(ic.ICmontores)
	from 
		HIncidenciasCalculo ic, 
		CalendarioPagos c,
		CIncidentes ci
	where ic.DEid = #reporte.DEid
	  and c.Ecodigo = @Ecodigo
	  and c.CPperiodo = @CPperiodo
	  and c.CPmes = @CPmes
	  and ic.RCNid = c.CPid
	  and ci.CIid = ic.CIid
	  and ci.CInocargas = 0), 0.00)

update #reporte
set salario = salario + isnull(
	(select sum(ic.ICmontores)
	from 
		IncidenciasCalculo ic, 
		CalendarioPagos c,
		CIncidentes ci
	where ic.DEid = #reporte.DEid
	  and c.Ecodigo = @Ecodigo
	  and c.CPperiodo = @CPperiodo
	  and c.CPmes = @CPmes
	  and ic.RCNid = c.CPid
	  and ci.CIid = ic.CIid
	  and ci.CInocargas = 0	), 0.00)

--  Determinacion de registros de Salida / Entrada / Incapacidad en el mes

-- Salida
update #reporte
set observaciones = 'S'
where exists(
	select 1 
	from DLaboralesEmpleado dl, RHTipoAccion ta 
	where dl.DEid = #reporte.DEid 
	  and dl.DLfvigencia between @f1 and @f2
	  and ta.RHTid = dl.RHTid
	  and ta.RHTcomportam = 2)

-- Entrada. Cuando tiene el empleado una accion de nombramiento entre las fechas
update #reporte
set observaciones = 'E'
where observaciones = ' '
  and exists(
	select 1 
	from DLaboralesEmpleado dl, RHTipoAccion ta 
	where dl.DEid = #reporte.DEid 
	  and dl.DLfvigencia between @f1 and @f2
	  and ta.RHTid = dl.RHTid
	  and ta.RHTcomportam = 1)


-- Entradas retroactivas, antes del inicio de las fechas del mes seleccionado, procesadas entre las fechas de la nomina.
update #reporte
set observaciones = 'E'
where observaciones = ' '
  and exists(
	select 1 
	from DLaboralesEmpleado dl, RHTipoAccion ta 
	where dl.DEid = #reporte.DEid 
	  and dl.DLfechaaplic between @f1 and @f2
	  and dl.DLfvigencia < @f1 
	  and ta.RHTid = dl.RHTid
	  and ta.RHTcomportam = 1)

update #reporte
set observaciones = 'I'
where observaciones = ' '
  and exists(
	select 1 
	from CalendarioPagos c, HIncidenciasCalculo ic, RHSaldoPagosExceso sp, RHTipoAccion ta 
	where c.Ecodigo = @Ecodigo
	  and c.CPperiodo = @CPperiodo
	  and c.CPmes = @CPmes
	  and ic.RCNid = c.CPid
	  and ic.DEid = #reporte.DEid
	  and ic.RHSPEid is not null
	  and sp.RHSPEid = ic.RHSPEid
	  and ta.RHTid = sp.RHTid
	  and ta.RHTcomportam = 5)

update #reporte
set observaciones = 'I'
where observaciones = ' '
  and exists(
	select 1 
	from HPagosEmpleado pe, CalendarioPagos c, RHTipoAccion ta 
	where pe.DEid = #reporte.DEid
	  and c.CPid = RCNid
	  and c.Ecodigo = @Ecodigo
	  and c.CPperiodo = @CPperiodo
	  and c.CPmes = @CPmes
	  and ta.RHTid = pe.RHTid
	  and ta.RHTcomportam = 5)

update #reporte
set observaciones = 'I'
where observaciones = ' '
  and exists(
	select 1 
	from PagosEmpleado pe, CalendarioPagos c, RHTipoAccion ta 
	where pe.DEid = #reporte.DEid
	  and c.CPid = RCNid
	  and c.Ecodigo = @Ecodigo
	  and c.CPperiodo = @CPperiodo
	  and c.CPmes = @CPmes
	  and ta.RHTid = pe.RHTid
	  and ta.RHTcomportam = 5)

/* 
	Insertar todas las salidas de funcionarios aplicables  
	entre las fechas del reporte y que no esten incluidas en el reporte generado
	(no tuvieron salario) en el mes seleccionado.
	Se incluyen las salidas retroactivas a esta nomina aplicadas entre las fechas del mes seleccionado
	en el segundo query
*/

insert #reporte (DEid, denombre, texto, observaciones, salario, ordenar)
select 
	e.DEid as DEid, 
	convert(char(30), upper(e.DEapellido1) || ' ' || upper(e.DEapellido2) || ' ' || upper(e.DEnombre)) as denombre,
	'4' || @numeropatronal || 
	case when e.NTIcodigo = 'C' then '0' else '7' end ||
	replicate ('0', 10 - datalength(convert(varchar(10), ltrim(rtrim(e.DEidentificacion))))) ||
	convert(varchar(10), e.DEidentificacion) ||
	convert(char(30), upper(e.DEapellido1) || ' ' || upper(e.DEapellido2) || ' ' || upper(e.DEnombre)) ||
	'          ' as texto,
	'S' as observaciones,
	0.00 as salario, '0'
from DLaboralesEmpleado dl, DatosEmpleado e, RHTipoAccion ta
where dl.Ecodigo = @Ecodigo
  and dl.DLfvigencia between @f1 and @f2
  and ta.RHTid = dl.RHTid
  and ta.RHTcomportam = 2
  and e.DEid = dl.DEid
  and not exists(select 1 from #reporte r where r.DEid = e.DEid)

insert #reporte (DEid, denombre, texto, observaciones, salario, ordenar)
select 
	e.DEid as DEid, 
	convert(char(30), upper(e.DEapellido1) || ' ' || upper(e.DEapellido2) || ' ' || upper(e.DEnombre)) as denombre,
	'4' || @numeropatronal || 
	case when e.NTIcodigo = 'C' then '0' else '7' end ||
	replicate ('0', 10 - datalength(convert(varchar(10), ltrim(rtrim(e.DEidentificacion))))) ||
	convert(varchar(10), e.DEidentificacion) ||
	convert(char(30), upper(e.DEapellido1) || ' ' || upper(e.DEapellido2) || ' ' || upper(e.DEnombre)) ||
	'          ' as texto,
	'S' as observaciones,
	0.00 as salario, '0'
from DLaboralesEmpleado dl, DatosEmpleado e, RHTipoAccion ta
where dl.Ecodigo = @Ecodigo
  and dl.DLfechaaplic between @f1 and @f2
  and dl.DLfvigencia < @f1 
  and ta.RHTid = dl.RHTid
  and ta.RHTcomportam = 2
  and e.DEid = dl.DEid
  and not exists(select 1 from #reporte r where r.DEid = e.DEid)

/* 
	Poner el mes de inicio de la incapacidad actual cuando la persona 
	esta incapacitada y el salario es cero, segun especificacion.
	Pendiente de completar este punto!
*/

update #reporte
set observaciones = '%', ordenar = '1'
where observaciones = 'I'
  and salario = 0.00

if @tiporep != 'D' begin
	select 
		texto 
		||
		replicate('0', 9 - datalength(convert(varchar, convert(numeric(9,0), salario * 100)))) 
		||
		convert(varchar, convert(numeric(9,0), salario * 100)) 
		|| 
		'C'
		||
		observaciones 
		|| 
		'        ' as salida
	from #reporte
	order by ordenar, denombre
end
else begin
	select 
		left(texto, 21),
		denombre as Nombre,
		convert(char(15), salario, 1) as Salario,
		'C'
		||
		observaciones 
		|| 
		'        ' as salida
	from #reporte
	order by ordenar, denombre
end

drop table #reporte
642	
declare @check1 int

select @check1 = count(1) 

from 
        #table_name# a, 
        Departamentos b

where 
        b.Ecodigo = @Ecodigo and
        b.Dcodigo = a.Codigo

if @check1 < 0

insert Departamentos 
         (Ecodigo, Dcodigo, Ddescripcion)

select 
         @Ecodigo, Codigo, Descripcion 

from 
        #table_name#

else 

select 
       'Registros ya insertados' as Motivo, @Ecodigo as Empresa, 
       Codigo as Código, Descripcion as Descripción 

from 
       #table_name# a, 
       Departamentos b

where 
       b.Ecodigo = @Ecodigo and
       b.Dcodigo = a.Codigo

order by Codigo	
643	declare @check int

insert EVacacionesEmpleado
         (DEid,EVfantig,EVfecha,EVmes,EVdia,EVinicializar)

select d.DEid, 
         (select min(LTdesde) from LineaTiempo lt where lt.Ecodigo = @Ecodigo and lt.DEid = d.DEid),
         getdate(),
         (select datepart(mm,min(LTdesde)) from LineaTiempo lt where lt.Ecodigo = @Ecodigo and lt.DEid = d.DEid),
         (select datepart(dd,min(LTdesde)) from LineaTiempo lt where lt.Ecodigo = @Ecodigo and lt.DEid = d.DEid),
         0

from 
        DatosEmpleado d

where 
        d.Ecodigo = @Ecodigo and
        d.DEid not in (select DEid from EVacacionesEmpleado ev where ev.DEid = d.DEid)

insert DVacacionesEmpleado
        (DEid,Ecodigo, DVEfecha,DVEreferencia,DVEdescripcion,DVEdisfrutados,DVEcompensados,DVEenfermedad,DVEmonto,Usucodigo,Ulocalizacion,DVEfalta,DVEperiodo)

select d.DEid, @Ecodigo, EVfantig, (select min(DLlinea) from DLaboralesEmpleado dl where dl.DEid = d.DEid), 'Carga Inicial de saldos de Vacaciones', Disponibles, 0,0,0,@Usucodigo, @Ulocalizacion, getdate(),null 

from 
        DatoEmpleado d,
        #table_name# a, 
        EVacacionesEmpleado e

where 
        d.DEidentificacion = a.Cedula and
        and e.DEid = d.DEid	
644	declare @check1 int

select @check1 = count(1) 

from 
        #table_name# a, 
        Oficinas b

where 
        b.Ecodigo = @Ecodigo and 
        b.Ocodigo = a.Codigo

if (@check1 < 1)

insert Oficinas 
        (Ecodigo, Ocodigo, Odescripcion)

select 
        @Ecodigo, Codigo, Descripcion 

from 
       #table_name#


else

select 
        'Registros ya insertados' as Motivo, @Ecodigo as Empresa,
        Codigo as Código, Descripcion as Descripción 

from 
        #table_name# a, Oficinas b

where 
        b.Ecodigo = @Ecodigo and
        b.Ocodigo = a.Codigo

order by Codigo	
645	declare @check1 int

select @check1 = isnull(count(1),0) 

from 
        #table_name# a, 
        RHPuestos b

where 
        b.Ecodigo = @Ecodigo and
        b.RHPcodigo = a.Codigo

if (@check1 < 1)

insert RHPuestos 
      (Ecodigo, RHPcodigo, RHPdescpuesto, BMusuario, BMfecha)

select 
      @Ecodigo, Codigo, Descripcion,@Usucodigo, getdate()

from 
      #table_name#

else 

select 
      'Registros ya insertados' as Motivo, @Ecodigo as Empresa, 
      Codigo as Código, Descripcion as Descripción 

from 
      #table_name# a, RHPuestos b

where 
       b.Ecodigo = @Ecodigo and
       b.RHPcodigo = a.Codigo

order by Codigo	
744	declare @check1 int

select @check1 = count(1) 
from 
       #table_name# a,
        CFuncional c   

where 
       c.CFcodigo = a.Codigo and
       c.Ecodigo = @Ecodigo

if (@check1 < 1)
begin

insert CFuncional
     (Ecodigo, Dcodigo, Ocodigo, CFpath, CFnivel, CFcodigo, 
      CFdescripcion) 

select 
     @Ecodigo, 0, 0, '', 0, Codigo, Descripcion 

from 
      #table_name#

update CFuncional 
set 
       CFidresp = b.CFid

from 
        CFuncional,
        #table_name# a,
        CFuncional b 

where 
        CFuncional.CFcodigo  = a.Codigo and 
        CFuncional.Ecodigo = @Ecodigo  and 
        CFuncional.Ecodigo = b.Ecodigo  and 
        convert(int,b.CFcodigo)  = convert(int,a.Responsable)

update CFuncional 
set 
        CFidresp = null
where 
        Ecodigo = @Ecodigo and
        CFidresp = 0

end

else 

select 
       'Datos ya existen', b.CFcodigo, b.CFdescripcion 
from 
       CFuncional b, 
       #table_name# a

where 
       b.CFcodigo = a.Codigo and
       b.Ecodigo = @Ecodigo	
745	/*
update CFuncional 
set CFidresp = (select CFid from CFuncional c, #table_name# a  where c.CFcodigo  = convert(varchar(9),a.Responsable)  )
from #table_name# a
where CFuncional.CFcodigo  = a.Codigo
   and Ecodigo = @Ecodigo
*/
update CFuncional 
set CFidresp = b.CFid
from  CFuncional ,   #table_name# a, CFuncional b 
where CFuncional.CFcodigo  = a.Codigo
   and CFuncional.Ecodigo = @Ecodigo
   and CFuncional.Ecodigo = b.Ecodigo
   and convert(int,b.CFcodigo)  = convert(int,a.Responsable)
	
747	declare @check1 int

select @check1 = count(1) 

from 
        RHPlazas d, 
        #table_name# a

where 
        d.RHPcodigo = a.codigo and
        d.Ecodigo = @Ecodigo

if (@check1 < 1)

insert RHPlazas 
       (Ecodigo, RHPcodigo, RHPdescripcion, RHPpuesto, CFid, 
        Dcodigo, Ocodigo) 

select 
       @Ecodigo, codigo, descripcion, puesto, CFid, 0, 0
from 
       #table_name# a, 
       CFuncional b

where 
       a.centro_func = b.CFcodigo and 
       b.Ecodigo = @Ecodigo

else 

select 
       'Datos ya existen', RHPcodigo, RHPdescripcion, RHPpuesto

from 
       RHPlazas d, 
       #table_name# a

where 
       d.RHPcodigo = a.codigo and
       d.Ecodigo = @Ecodigo	
748	declare @check1 int

select @check1 = count(1) 

from 
       RHVigenciasTabla v, 
       #table_name# a

where 
       v.RHVTcodigo = a.codigo and 
       v.RHVTfecharige = a.desde and
       v.RHVTfechahasta = a.hasta and
       v.Ecodigo = @Ecodigo

if (@check1 < 1)

insert RHVigenciasTabla
       (Ecodigo, BMusucodigo, RHTTid, RHVTfecharige, 
        RHVTfechahasta, RHVTporcentaje, RHVTdocumento, 
        RHVTdescripcion, RHVTcodigo, RHVTtablabase,  
        RHVTestado, BMfalta, BMfmod ) 

select 
      @Ecodigo, @Usucodigo,  RHTTid, desde, hasta, porcentaje, 
      documento, descripcion, codigo, null, 'P', getdate(), 
      getdate() 

from 
      #table_name# a, 
      RHTTablaSalarial b

where 
      a.codigo_tabla = b.RHTTcodigo

else 

select 
      'Datos ya existen', v.Ecodigo, v.RHVTcodigo, 
       v.RHVTfecharige, v.RHVTfechahasta

from 
      RHVigenciasTabla v, 
      #table_name# a

where 
      v.RHVTcodigo = a.codigo and 
      v.RHVTfecharige = a.desde and
      v.RHVTfechahasta = a.hasta and
      v.Ecodigo = @Ecodigo
	
749	declare @check1 int

select @check1 = count(1) 
from 
         #table_name# a, RHMontosCategoria b, 
         RHVigenciasTabla c

where 
         a.codigo_tabla = b.RHMCcodigo and
         a.codigo_vigencia = c.RHVTcodigo and 
         b.RHTTid = c.RHTTid

if (@check1 < 1)
begin

insert RHMontosCategoria
        (BMusucodigo, RHMCcodigo, RHMCpaso, CSid, 
         RHMCmonto, RHTTid, RHVTid, BMfalta, BMfmod ) 

select 
       @Usucodigo,  codigo, paso, CSid, monto, b.RHTTid, 
       RHVTid, getdate(), getdate() 

from 
       #table_name# a, RHTTablaSalarial b, RHVigenciasTabla c,
       ComponentesSalariales d

where 
       a.codigo_tabla = b.RHTTcodigo and
       a.codigo_vigencia = c.RHVTcodigo and 
       b.RHTTid = c.RHTTid and
       a.componente = d.CScodigo


insert RHCategoriasTipoTabla
       (RHTTid, RHMCcodigo, RHMCpaso)

select 
       distinct a.RHTTid, RHMCcodigo, RHMCpaso   

from 
       RHMontosCategoria a , RHVigenciasTabla b

where 
       a.RHVTid = b.RHVTid and
       b.Ecodigo = @Ecodigo

end    

else 
select 
       'Datos ya existen', RHMCcodigo, RHMCpaso, CSid, 
        RHMCmonto, b.RHTTid, b.RHVTid

from 
       #table_name# a, RHMontosCategoria b, 
       RHVigenciasTabla c

where 
       a.codigo_tabla = b.RHMCcodigo and
       a.codigo_vigencia = c.RHVTcodigo and 
       b.RHTTid = c.RHTTid
	
750	declare @check1 int

select @check1 = count(1) 

from 
        RHPuestosCategoria p, 
        #table_name# a,
        RHCategoriasTipoTabla b, 
        RHTTablaSalarial c

where 
        a.puesto = p.RHPcodigo  and
        a.codigo_tabla = c.RHTTcodigo and
        a.categoria = b.RHMCcodigo and
        a.paso = b.RHMCpaso and
        c.Ecodigo = @Ecodigo and 
        b.RHTTid = c.RHTTid       

if (@check1 < 1)

insert RHPuestosCategoria
       (Ecodigo, BMusucodigo, RHPCfinicio, RHPCffinal,  
        RHPcodigo,  RHTCid, BMfalta, BMfmod ) 

select 
       @Ecodigo, @Usucodigo, desde, hasta, puesto, RHTCid, 
       getdate(), getdate() 

from 
       #table_name# a, 
       RHCategoriasTipoTabla b, 
       RHTTablaSalarial c

where 
       a.codigo_tabla = c.RHTTcodigo and
       a.categoria = b.RHMCcodigo and
       a.paso = b.RHMCpaso and
       c.Ecodigo = @Ecodigo and 
       b.RHTTid = c.RHTTid       

else 

select 
       'Datos ya existen', @Ecodigo, puesto, codigo_tabla, 
       categoria, paso

from 
       RHPuestosCategoria p, 
       #table_name# a, 
       RHCategoriasTipoTabla b, 
       RHTTablaSalarial c

where 
       a.puesto = p.RHPcodigo  and
       a.codigo_tabla = c.RHTTcodigo and
       a.categoria = b.RHMCcodigo and
       a.paso = b.RHMCpaso and
       c.Ecodigo = @Ecodigo and 
       b.RHTTid = c.RHTTid
	
751	declare @check1 int

select @check1 = count(1) 

from 
        #table_name# a, 
        RHComponentesAgrupados  b,
        ComponentesSalariales c 

where 
        a.codigo = c.CScodigo and
        c.Ecodigo = @Ecodigo and 
        a.codigo_grupo = b.RHCAcodigo and 
        b.Ecodigo = @Ecodigo                  

if (@check1 < 1)

insert ComponentesSalariales
        (Ecodigo, CScodigo, CSdescripcion, CSusatabla, 
         CSsalariobase, CAid ) 

select 
       @Ecodigo, codigo, descripcion, comportamiento, 
       salario_base, RHCAid

from 
      #table_name# a, 
      RHComponentesAgrupados b

where
      a.codigo_grupo = b.RHCAcodigo and
      b.Ecodigo = @Ecodigo

else
 
select 
        'Datos ya existen', CScodigo, CSdescripcion, RHCAcodigo 

from 
       #table_name# a, RHComponentesAgrupados  b,
       ComponentesSalariales c 

where 
       a.codigo = c.CScodigo and
       c.Ecodigo = @Ecodigo and 
       a.codigo_grupo = b.RHCAcodigo and 
       b.Ecodigo = @Ecodigo	
752	 	
753	declare @check1 int

select @check1 = count(1) 

from 
       #table_name# a,
       DatosEmpleado d

where 
       DEidentificacion = identificacion and
       d.Ecodigo = @Ecodigo

if (@check1 < 1)

insert DatosEmpleado 
        (Ecodigo, Usucodigo, Ulocalizacion, DEnombre, 
         DEapellido1, DEapellido2, NTIcodigo, DEidentificacion, 
         DEcivil, DEfechanac, DEsexo, DEdireccion, Bid, CBcc, 
         Mcodigo, DEtelefono1, DEtelefono2, DEemail, DEtarjeta, 
         DEpassword, DEcantdep, DEsistema) 

select 
        @Ecodigo, @Usucodigo, @Ulocalizacion, nombre, 
        apellido1, apellido2, tipo_id, identificacion, civil, 
        fecha_nac, sexo, direccion, banco, cuenta, moneda, 
        telefono1, telefono2, correo, tarjeta, password, 0 , 1

from #table_name#

else 

select 
       'Datos ya existen', DEnombre, DEapellido1, DEapellido2, 
        DEidentificacion

from 
       DatosEmpleado, 
       #table_name# 

where 
       DEidentificacion = identificacion	
754	declare @check1 int

select @check1 = count(1) 

from 
       DatosEmpleado d, 
       #table_name# a

where 
        d.DEidentificacion = a.identificacion and
        d.Ecodigo = @Ecodigo

if (@check1 >= 1)



insert FEmpleado 
       (DEid, Usucodigo, Ulocalizacion, FEnombre, FEapellido1, 
        FEapellido2, FEsexo, FEidentificacion, Pid, FEdir, FEfnac, 
        NTIcodigo, FEdeducrenta, FEestudia, FEasignacion, 
        FEdiscapacitado ) 

select 
        DEid, @Usucodigo, @Ulocalizacion, nombre, apellido1, 
        apellido2, sexo, identificacion,

        case  parentesco
                 when 1 then 13 
                 when 2 then 3 
                 when 3 then 4 
                 when 4 then 2 
                 when 5 then 14
                 when 6 then 1
                 when 7 then 21 
                 when 8 then 12
                 when 9 then 11
                 else 0
	 end,
       direccion, fecha_nac, 
       tipo_id, renta, estudia, asignaciones, discapacitado

from 
       #table_name# a, 
       DatosEmpleado b

where 
       b.DEidentificacion = a.cedula_empleado


else 

select 
       'El empleado no existe', cedula_empleado 

from 
      #table_name#	
755	declare @check1 int

select 
         @check1 = count(1) 
from  
         #table_name# a, DatosEmpleado b, RHAcciones c, 
         RHTipoAccion d

where 
        a.cedula = b.DEidentificacion and
        b.DEid = c.DEid and
        a.tipo_accion  = d.RHTcodigo and
        c.RHTid = d.RHTid and
        a.desde = c.DLfvigencia and
        a.hasta = c.DLffin  and
        c.Ecodigo  = @Ecodigo


if (@check1 < 1)


insert RHAcciones 
           (DEid,RHTid,Ecodigo,Tcodigo, RVid, RHJid, RHTCid, 
            Dcodigo, Ocodigo, RHPid, RHPcodigo, DLfvigencia, 
            DLffin, DLsalario, DLobs, Usucodigo, Ulocalizacion,
            RHAporc, RHAporcsal, RHAidtramite, RHAvdisf, 
            RHAvcomp, IEid ,TEid )

select   DEid, RHTid, @Ecodigo, nomina, RVid, RHJid, e.RHTCid, 
           departamento, oficina, RHPid, puesto, desde, hasta, 
           salario, descripcion, @Usucodigo, @Ulocalizacion, 
           porc_plaza, porc_salario, null, disfrutados, compensados,
           null, null
                             
from    #table_name# a, RegimenVacaciones b, RHJornadas c, 
           RHPlazas d, RHCategoriasTipoTabla e, 
           RHTTablaSalarial f, RHTipoAccion g, DatosEmpleado h

where 
          a.cedula = h.DEidentificacion and
          a.tipo_accion  = g.RHTcodigo and
          a.regimen = b.RVcodigo and
          a.jornada  = c.RHJcodigo and
          a.plaza  = d.RHPcodigo and
          a.tabla_salarial  = f.RHTTcodigo and
          e.RHTTid  = f.RHTTid and
          e.RHMCcodigo  = a.categoria and
          e.RHMCpaso  = a.paso and
          f.Ecodigo  = @Ecodigo
        
else 

select 'Datos ya existen', c.DEid,  c.RHTid, DLfvigencia, DLffin , c.Ecodigo 

from         
		#table_name# a, DatosEmpleado b, RHAcciones c, RHTipoAccion d
		
where 
        a.cedula = b.DEidentificacion and
        b.DEid = c.DEid and
        a.tipo_accion  = d.RHTcodigo and
        c.RHTid = d.RHTid and
        a.desde = c.DLfvigencia and
        a.hasta = c.DLffin  and
        c.Ecodigo  = @Ecodigo	
756	declare @check1 int

select @check1 = count(1) 

from  
        #table_name# a, 
        HRCalculoNomina b

where 
        a.desde = b.RCdesde and
        a.hasta = b.RChasta and
        b.Ecodigo  = @Ecodigo

if (@check1 < 1)

insert HRCalculoNomina
        (RCNid, Ecodigo, Usucodigo, Ulocalizacion, Tcodigo, 
         RCDescripcion, RDdesde, RChasta, RCestado)

select 
       CPid, @Ecodigo, @Usucodigo, @Ulocalizacion, codigo, 
       descripcion, desde, hasta, 3                    

from 
       #table_name# a, CalendarioPagos b

where 
       a.desde = b.RCdesde and 
       a.hasta = b.RChasta and     
       b.Ecodigo = @Ecodigo

else 

select 
       'Datos ya existen', b.RCNid, b.Tcodigo, 
        b.RCDescripcion, b.RCdesde, b.RChasta

from  
       #table_name# a, HRCalculoNomina b

where 
       a.desde = b.RCdesde and
       a.hasta = b.RChasta and
       b.Ecodigo  = @Ecodigo	
757	declare @check1 int

select @check1 = count(1) 

from  
         #table_name# a, 
         HRCalculoNomina b, 
         HSalarioEmpleado c

where 
        a.empleado = c.DEid
        a.desde = b.RCdesde and
        a.hasta = b.RChasta and
        b.RCNid = c.RCNid  and
        b.Ecodigo  = @Ecodigo

if (@check1 < 1)

insert HSalarioEmpleado
       (DEid, RCNid, SEcalculado, SEsalariobruto, SEincidencias, 
        SEcargasempleado, SEcargaspatrono, SErenta, 
        SEdeducciones, SEliquido, SEacumulado, SEproyectado, 
        SEinodeduc, SEinocargas, SEinorenta)

select 
        empleado, RCNid,  calculado, salario_bruto, incidencias, 
        cargas_emp, cargas_patrono, renta, deducciones, liquido, 
        acumulado, proyectado, ino_deduc, ino_cargas, ino_renta

from 
        #table_name# a, 
        HRCalculoNomina b

where  
        a.desde = b.RCdesde and 
        a.hasta = b.RChasta
        b.Ecodigo = @Ecodigo
       
else 
select 
        'Datos ya existen', c.RCNid, c.DEid, b.RCdesde, b.RChasta

from  
        #table_name# a, 
        HRCalculoNomina b, 
        HSalarioEmpleado c, 

where 
        a.empleado = c.DEid
        a.desde = b.RCdesde and
        a.hasta = b.RChasta and
        b.RCNid = c.RCNid  and
        c.Ecodigo  = @Ecodigo	
758	 	
759	 	
761	 	
762	---  Graba el Detalle de la Accion

---- Verifica que NO exista ese componente en la accion

declare @check1 int


select @check1 = count(1) 

from  #table_name# a, 
        ComponentesSalariales b, 
        RHAcciones c,
        DatosEmpleado d,
        RHTipoAccion e,
        RHDAcciones f
		
where 
        a.cedula = d.DEidentificacion and
        a.tipo_accion  = e.RHTcodigo and
        a.componente = b.CScodigo and
        a.desde = c.DLfvigencia and
        a.hasta = c.DLffin and
        d.DEid = c.DEid and
        e.RHTid = c.RHTid and
        f.CSid = b.CSid

		
---- Verifica que exista la accion en las fechas comprendidas
		
declare @check2 int

select @check2 = count(1) 

from
       #table_name# a, 
       RHAcciones c,
       DatosEmpleado d,
       RHTipoAccion e
		
where 
       a.cedula = d.DEidentificacion and
       a.tipo_accion  = e.RHTcodigo and
       a.desde = c.DLfvigencia and
       a.hasta = c.DLffin and		
       d.DEid = c.DEid and
       e.RHTid = c.RHTid 		
		
		
if ( (@check1 < 1) and   (@check2 >= 1)  )
		


insert RHDAcciones
         (Usucodigo, Ulocalizacion, RHAlinea, CSid, RHDAtabla, 
         RHDAunidad, RHDAmontobase, RHDAmontores) 

select 
         @Usucodigo, @Ulocalizacion, RHAlinea, CSid, null, 1, 
         monto, monto
		
from 
        #table_name# a, 
        ComponentesSalariales b, 
        RHAcciones c,
        DatosEmpleado d,
        RHTipoAccion e

where 
        a.cedula = d.DEidentificacion and
        a.tipo_accion  = e.RHTcodigo and
        a.componente = b.CScodigo and
        a.desde = c.DLfvigencia and
        a.hasta = c.DLffin and
        d.DEid = c.DEid and
        e.RHTid = c.RHTid
		
else
begin

if ( @check1 >= 1) 

select 
         'Datos ya existen', cedula, tipo_accion, componente, 
        desde, hasta

from  
        #table_name# a, 
        ComponentesSalariales b, 
        RHAcciones c,
        DatosEmpleado d,
        RHTipoAccion e,
        RHDAcciones f
		
where 
        a.cedula = d.DEidentificacion and
        a.tipo_accion  = e.RHTcodigo and
        a.componente = b.CScodigo and
        a.desde = c.DLfvigencia and
        a.hasta = c.DLffin and
        d.DEid = c.DEid and
        e.RHTid = c.RHTid and
        f.CSid = b.CSid		
		
if ( @check2 < 1)

select 'La Acción NO existe en esas fechas', 
         cedula, tipo_accion, componente, desde, hasta

from
        #table_name#

end	
763	--Este script se usa para cargar plazas cuando el archivo 
--de Excel muestra la cantidad para cada puesto
--ejm:  Puesto con 9 plazas

declare @check1 int,
           @a int,
           @id int,
           @centro_func varchar(12),
           @puesto varchar(60),
           @cantidad int,
           @cod_puesto varchar(12),
           @avance int,
           @CFid numeric

select @check1 = 0

select @id = min(id) 
  from #table_name#
  
--select @a = isnull(max(convert(int, RHPcodigo) ,0))+ 1 from RHPlazas
select @a = 1

While (1 = 1)
begin

   select @centro_func = centro_func, @puesto = puesto, @cantidad = cantidad
   from #table_name#
   where id = @id
				
   select @cod_puesto = b.RHPcodigo
   from RHPuestos b
   where Upper(@puesto) = Upper(b.RHPdescpuesto)
         and b.Ecodigo = @Ecodigo

   select @CFid = CFid
   from  #table_name# a, CFuncional b
   where a.centro_func = b.CFcodigo and b.Ecodigo = @Ecodigo		
         
   select @avance = 0
	
    While (@avance < @cantidad)			
    begin

       select @avance = @avance + 1
       insert RHPlazas  (Ecodigo, RHPcodigo, RHPdescripcion, RHPpuesto, CFid) 
       values (@Ecodigo, convert(char(4),@a), 'Plaza '||convert(char(4),@a), @cod_puesto, @CFid)
       select @a = @a + 1
    end -- while (1 to @cantidad)

   select @id = min(id) 
   from #table_name#
   where  id > @id

   if (@id is null)
   break
       
   end -- While (1 = 1)	
764	/*
Declare
@CFid numeric,
@CFidt numeric,
@CFidRes numeric,
@CFcodigo char(10),
@nivel int,
@path varchar(100),
@salida int 

Select @CFid  = Min(CFid) 
from CFuncional 
where  Ecodigo = @Ecodigo

While 1 = 1
Begin
	Select @CFidt = @CFid, @nivel = 0, @path = null, @salida = 0
	While @salida != 1
		begin
		Select @CFcodigo = CFcodigo,
             	 @CFidRes = CFidresp 
		from CFuncional
		where  CFid  = @CFidt
	        and Ecodigo = @Ecodigo
	
		If @CFidRes is not null
		Begin
			If @path is null
			begin
				Select @nivel = 1, @path = ltrim(rtrim(@CFcodigo))
			end
			Else
			Begin
				Select @nivel = @nivel + 1, @path = ltrim(rtrim(@CFcodigo)) || '/' || @path 
			End
			Select @CFidt = @CFidRes
		End
		Else
		Begin
			If @path is null
			Begin
				Select @nivel = 1, @path = ltrim(rtrim(@CFcodigo))
			end
			Else
			begin
				Select @nivel = @nivel + 1, @path = ltrim(rtrim(@CFcodigo)) || '/' || @path 
			end		
			select @salida = 1
		end
	end
	update CFuncional set CFpath = @path, CFnivel = @nivel where CFid = @CFid
	Select @CFid  = Min(CFid ) 
	from CFuncional
	where  CFid  > @CFid  and Ecodigo = @Ecodigo

	If  @CFid is null
		break
end
*/

select  * from SalarioEmpleado	
765	declare @check1 numeric, @check2 numeric

-- Validar que no existan duplicados en el archivo
select @check1 = count(count(1))
from #table_name#
group by AFMcodigo
having count(1) > 1

if @check1 < 1 begin
-- Validar si ya existen las marcas en el catalogo
select @check2 = count(1)
from #table_name# a, AFMarcas b
where b.AFMcodigo = a.AFMcodigo
and b.Ecodigo = @Ecodigo

if @check2 < 1 begin

insert AFMarcas ( Ecodigo, AFMcodigo, AFMdescripcion, AFMuso)
 select  @Ecodigo, AFMcodigo, AFMdescripcion, 'A'
 from #table_name# 

end
else begin
select 'Codigo de Marca ya existe en el sistema' as Error, a.AFMcodigo as Marca
from #table_name# a, AFMarcas b
where b.AFMcodigo = a.AFMcodigo
and b.Ecodigo = @Ecodigo

end  --check2
end
else begin 

select 'Código de Marcas aparece duplicado en el archivo' as Error, AFMcodigo as Marca 
from #table_name#
group by AFMcodigo
having count(1) > 1

end --check1	
766	declare @check1 numeric, @check2 numeric, @check3 numeric

-- Validar que no existan duplicados en el archivo
select @check1 = count(count(1))
from #table_name#
group by AFMcodigo, AFMMcodigo
having count(1) > 1

if @check1 < 1 begin

 -- Validar que existan las marcas en el catalogo
 select @check2 = count(1) 
 from #table_name# a
 where not exists(
 select 1
 from AFMarcas b
 where b.AFMcodigo = a.AFMcodigo
 and b.Ecodigo = @Ecodigo)

 if @check2 < 1 begin
  --Validar si ya existen marcas modelos en el catalogo
  select @check3 = count(1)
  from #table_name# a, AFMarcas b, AFMModelos c
   where a.AFMcodigo = b.AFMcodigo
    and b.Ecodigo = @Ecodigo
    and c.Ecodigo = @Ecodigo
    and b.AFMid = c.AFMid
     and a.AFMMcodigo = c.AFMMcodigo

  if @check3 < 1 begin
   -- Insertar Modelos
   insert AFMModelos ( AFMid, Ecodigo, AFMMcodigo, AFMMdescripcion)
    select  b.AFMid, @Ecodigo, a.AFMMcodigo, a.AFMMdescripcion
       from #table_name# a, AFMarcas b
       where a.AFMcodigo = b.AFMcodigo
          and b.Ecodigo = @Ecodigo
  end
  else begin
    select 'Ya existe Maca-Modelo en el sistema' as Error, a.AFMcodigo as Marca, a.AFMMcodigo as Modelo
    from #table_name# a, AFMarcas b, AFMModelos c
    where a.AFMcodigo = b.AFMcodigo
       and b.Ecodigo = @Ecodigo
       and c.Ecodigo = @Ecodigo
       and b.AFMid = c.AFMid
       and a.AFMMcodigo = c.AFMMcodigo
  end --check3
 end
 else begin  
   select  'Codigo de Marca no esta registrado en el sistema' as Error, AFMcodigo as Marca
   from #table_name# a
   where not exists (select 1  from AFMarcas b
                              where b.AFMcodigo = a.AFMcodigo
                               and b.Ecodigo = @Ecodigo)
 end   --check2
end
else begin
  select 'Código de Marca, Modelo aparece duplicado en el archivo' as Error, AFMcodigo as Marca, AFMMcodigo as Modelo
    from #table_name#
    group by AFMcodigo, AFMMcodigo
    having count(1) > 1
end --check1	
767	declare @check1 numeric
-- Verificar si ya existe la unidad
if exists (select 1 from #table_name# a, Unidades b
  where b.Ecodigo = @Ecodigo
  and a.Ucodigo = b.Ucodigo)
begin
  select 'Unidad de Medida ya existe en el sistema' as Error, a.Ucodigo as Unidad
  from #table_name# a, Unidades b
  where b.Ecodigo = @Ecodigo
  and a.Ucodigo = b.Ucodigo
end
else begin
 -- verificar que no existan duplicados
 select @check1 = count(count(1))
   from #table_name#
   group by Ucodigo
   having count(1) > 1
   if @check1 > 1 begin
        select 'Codigo de Unidad de Medida aparece duplicado en el archivo' as Error, Ucodigo  as Unidad
      from #table_name#
      group by Ucodigo
      having count(1) > 1
   end
   else begin 
          insert Unidades(Ecodigo, Ucodigo, Udescripcion, Uequivalencia, Utipo)
      select @Ecodigo, Ucodigo, Udescripcion, Uequivalencia, Utipo
       from #table_name#
   end
end	
768	declare @check1 numeric, @check2 numeric, @check3 numeric,  @mini numeric, @Ccodigoclaspadre  varchar(5), @Ccodigoclas varchar(5), @Ccodigopadre numeric,  @Cnivel numeric, @Cpath varchar(255), @maxid numeric

-- Validar que no existan duplicados en el archivo
select @check1 = count(count(1))
from #table_name#
group by Ccodigoclas
having count(1) > 1

if @check1 < 1 begin
 -- Validar si ya existe el codigo de clasificacion en el sistema
 select @check2 = count(1)
   from #table_name# a, Clasificaciones b
    where a.Ccodigoclas = b.Ccodigoclas
       and b.Ecodigo = @Ecodigo

 if @check2 < 1 begin
  --Validar que exista el codigo del padre
  select @check3 = count(1)  from #table_name# a 
    where ltrim(rtrim(a.Ccodigoclaspadre)) <> '' 
      and a.Ccodigoclaspadre  is not null
      and  not exists ( select 1 
                                  from #table_name# b
                                   where a.Ccodigoclaspadre = b.Ccodigoclas)

   if @check3 < 1 begin
    select @maxid = max(Ccodigo) from Clasificaciones where Ecodigo = @Ecodigo
    select @maxid = isnull(@maxid, 0) 
    select @mini = -1
    select @mini = min(id) from #table_name# where id > @mini
    while @mini is not null begin
      select @Ccodigoclaspadre = ltrim(rtrim(Ccodigoclaspadre)) , 
               @Ccodigoclas = ltrim(rtrim(Ccodigoclas))
         from #table_name# where id = @mini
      if (@Ccodigoclaspadre = '') or (@Ccodigoclaspadre is null) begin
       select @Cnivel = 0, @Cpath = right(('00000' + @Ccodigoclas), 5)
        select @Ccodigopadre = null     
      end
      else begin
        select @Cnivel = 0
        select @Cpath = right(('00000' + @Ccodigoclas), 5) 
        select @Ccodigopadre = a.id from #table_name# a
           where a.Ccodigoclas = @Ccodigoclaspadre
        select @Ccodigopadre = isnull(@Ccodigopadre, 0) + @maxid
        while (@Ccodigoclaspadre is not null) and (@Ccodigoclaspadre <>'') begin
          select @Cpath = right(('00000' + @Ccodigoclaspadre), 5)  +  '/' +  @Cpath 
          select @Cnivel = @Cnivel + 1
          select @Ccodigoclaspadre = ltrim(rtrim(Ccodigoclaspadre)) from #table_name#
             where Ccodigoclas = @Ccodigoclaspadre
        end 
      end
             
            insert Clasificaciones(Ecodigo, Ccodigo, Ccodigopadre, Ccodigoclas, Cdescripcion, Cpath, Cnivel, Ccomision, cuentac)
                        select @Ecodigo, id + @maxid, @Ccodigopadre, Ccodigoclas, Cdescripcion, @Cpath, @Cnivel, Ccomision, cuentac
                 from #table_name# a
                 where a.id = @mini

      select @mini = min(id) from #table_name# where id > @mini
    end
   end
   else begin
      select 'No existe el codigo del padre' as Error, a.Ccodigoclaspadre as Codigo_Padre
      from #table_name# a 
       where ltrim(rtrim(a.Ccodigoclaspadre)) <> '' 
          and a.Ccodigoclaspadre is not null
          and  not exists (select 1 from #table_name# b
                                  where b.Ccodigoclas = a.Ccodigoclaspadre)
   end --check3
 end
 else begin
   select 'Codigo de Clasificacion ya existe en el sistema' as Error, a.Ccodigoclas as Clasificacion
    from #table_name# a, Clasificaciones b
    where a.Ccodigoclas = b.Ccodigoclas
       and b.Ecodigo = @Ecodigo
 end --check2
end
else begin
 select 'Codigo de Clasificacion aparece duplicado en el archivo' as Error, Ccodigoclas as Clasificacion
   from #table_name#
  group by Ccodigoclas
  having count(1) > 1
end --check1	
769	declare @check1 numeric, @check2 numeric, @check3 numeric,  @mini numeric, @CCcodigopadre  varchar(5), @CCcodigo varchar(5), @CCidpadre numeric,  @Cnivel numeric, @Cpath varchar(255),@maxid numeric , @Afecha datetime
select @Afecha = getDate()

-- Validar que no existan duplicados en el archivo
select @check1 = count(count(1))
from #table_name#
group by CCcodigo
having count(1) > 1

if @check1 < 1 begin
  -- Validar si ya existe el codigo de clasificacion en el sistema
  select @check2 = count(1)
   from #table_name# a, CConceptos b
   where a.CCcodigo = b.CCcodigo
      and b.Ecodigo = @Ecodigo

 if @check2 < 1 begin
  --Validar que exista el codigo del padre
  select @check3 = count(1)  from #table_name# a 
   where ltrim(rtrim(a.CCcodigopadre)) <> '' 
     and a.CCcodigopadre is not null
     and not exists (select 1
                            from #table_name# b
                             where  b.CCcodigo  = a.CCcodigopadre)


  if @check3 < 1 begin

   select @mini = -1
    select @mini = min(id) from #table_name# where id > @mini
    select @maxid  = max(CCid) from CConceptos where Ecodigo = @Ecodigo
    while @mini is not null begin
     select @CCcodigopadre = ltrim(rtrim(CCcodigopadre)) , 
              @CCcodigo = ltrim(rtrim(CCcodigo))
       from #table_name# where id = @mini
     if @CCcodigopadre = ''  or @CCcodigopadre is null begin
      select @Cnivel = 0, @Cpath = right(('00000' + @CCcodigo), 5)
     end
     else begin
       select @Cnivel = 0
       select @Cpath = right(('00000' + @CCcodigo), 5) 
       while (@CCcodigopadre is not null) and  (@CCcodigopadre <> '') begin
        select @Cpath =  right(('00000' + @CCcodigopadre), 5)  +  '/' + @Cpath
        select @Cnivel = @Cnivel + 1
        select @CCcodigopadre = ltrim(rtrim(CCcodigopadre)) from #table_name#
         where CCcodigo = @CCcodigopadre
       end 
     end
      insert CConceptos( Ecodigo,  CCcodigo, CCdescripcion, Usucodigo, CCfalta, CCnivel, CCpath, cuentac)
         select   @Ecodigo,   CCcodigo, CCdescripcion, @Usucodigo, @Afecha,  @Cnivel, @Cpath,  cuentac
          from #table_name# a
           where a.id = @mini
 
      select @mini = min(id) from #table_name# where id > @mini
    end
    if exists (select 1 from #table_name# a where ltrim(rtrim(a.CCcodigopadre)) <>'' and a.CCcodigopadre is not null)
    begin
       select @mini = -1
       select @mini = min(id) from #table_name# a where id > @mini and ltrim(rtrim(a.CCcodigopadre)) <>'' and a.CCcodigopadre is not null
       while @mini is not null begin
          select @CCcodigopadre = ltrim(rtrim(CCcodigopadre)) , 
                   @CCcodigo = ltrim(rtrim(CCcodigo))
              from #table_name# where id = @mini
            
           select @CCidpadre = a.CCid  from CConceptos a
              where a.CCcodigo = @CCcodigopadre
                 and a.Ecodigo = @Ecodigo

            update CConceptos
                     set CCidpadre = @CCidpadre
                    where CCcodigo = @CCcodigo
                        and Ecodigo = @Ecodigo

            select @mini = min(id) from #table_name# a where id > @mini and ltrim(rtrim(a.CCcodigopadre)) <>'' and a.CCcodigopadre is not null

       end
    end
  end
  else begin
    select 'No existe el codigo del padre' as Error, a.CCcodigopadre as Codigo_Padre
      from #table_name# a 
      where ltrim(rtrim(a.CCcodigopadre)) <> '' 
       and a.CCcodigopadre is not null
       and not exists (select 1 from #table_name# b
                                where b.CCcodigo  = a.CCcodigopadre )
  end --check3
 end
 else begin
   select 'Codigo de Clasificacion ya existe en el sistema' as Error, a.CCcodigo as Clasificacion
    from #table_name# a, CConceptos b
    where a.CCcodigo = b.CCcodigo
       and b.Ecodigo = @Ecodigo
 end --check2
end
else begin
 select 'Codigo de Clasificacion aparece duplicado en el archivo' as Error, CCcodigo as Clasificacion
  from #table_name#
  group by CCcodigo
   having count(1) > 1
end --check1	
770	declare @check1 numeric, @check2 numeric, @check3 numeric, @check4 numeric


-- Validar que no existan duplicados en el archivo
select @check1 = count(count(1))
from #table_name#
group by Ccodigo
having count(1) > 1

if @check1 < 1 begin
  -- Validar si ya existe el codigo de Servicio en el sistema
  select @check2 = count(1)
   from #table_name# a, Conceptos b
   where a.Ccodigo = b.Ccodigo
      and b.Ecodigo = @Ecodigo

 if @check2 < 1 begin
  -- Validar existencia de Unidades
  select @check3 = count(1)
   from #table_name# a
   where ltrim(rtrim(a.Ucodigo)) <>''
     and a.Ucodigo is not null
     and not exists( select 1 from Unidades b
                           where b.Ucodigo = a.Ucodigo
                              and b.Ecodigo = @Ecodigo)

  if @check3 < 1 begin
    --Validar existencia de Clasificaciones de Servicio
    select @check4 = count(1)
      from #table_name# a
     where ltrim(rtrim(a.CCcodigo )) <> ''
        and a.CCcodigo is not null
        and not exists( select 1 from CConceptos b
                                where b.CCcodigo = a.CCcodigo
                                    and b.Ecodigo = @Ecodigo)

   if @check4 < 1 begin

     insert Conceptos ( Ecodigo, Ccodigo, Cdescripcion, Ctipo, Ucodigo, CCid)
       select  @Ecodigo, a.Ccodigo, a.Cdescripcion, a.Ctipo, a.Ucodigo, b.CCid
         from #table_name# a, CConceptos b
         where a.CCcodigo *= b.CCcodigo
           and b.Ecodigo = @Ecodigo

   end --check4
   else begin  --check4
     select 'Clasificacion de servicio no esta registrada en el sistema' as Error, a.CCcodigo as Clasificaion_Servicio
      from #table_name# a
      where ltrim(rtrim(a.CCcodigo )) <> ''
         and a.CCcodigo is not null
         and not exists( select 1 from CConceptos b
                                   where b.CCcodigo = a.CCcodigo
                                      and b.Ecodigo = @Ecodigo )

   end  --check4
  end --check3
  else begin --check3
     select 'Codigo de Unidad no esta registrado en el sistema' as Error, a.Ucodigo as Unidad
     from #table_name# a
    where ltrim(rtrim(a.Ucodigo)) <>''
      and a.Ucodigo is not null
      and  not exists(select 1 from Unidades b
                             where b.Ucodigo = a.Ucodigo
                                and b.Ecodigo = @Ecodigo)

  end --check3
 end --check2
 else begin
   select 'El servicio ya se encuentra registrado en el sistema' as Error, a.Ccodigo as Servicio
    from #table_name# a, Conceptos b
    where a.Ccodigo = b.Ccodigo
       and b.Ecodigo = @Ecodigo
 end --check2
end --check1
else begin
  select 'Codigo del Servicio aparece duplicado en el archivo' as Error, Ccodigo as Servicio
    from #table_name#
     group by Ccodigo
     having count(1) > 1
end --check1	
771	declare @check1 numeric, @check2 numeric, @check3 numeric, @check4 numeric, @maxid numeric

-- Validar que no existan duplicados en el archivo
select @check1 = count(count(1))
from #table_name#
group by Almcodigo
having count(1) > 1

if @check1 < 1 begin
 -- Validar si existe el codigo de almacen en el sistema
  select @check2 = count(1)
  from #table_name# a, Almacen b
  where a.Almcodigo = b.Almcodigo
  and b.Ecodigo = @Ecodigo

 if @check2 < 1 begin
  --Validar que  exista la oficina en el sistema
  select @check3 = count(1)
   from #table_name# a 
    where not exists ( select 1 from Oficinas b
                              where a.Oficodigo = b.Oficodigo
                                 and b.Ecodigo = @Ecodigo )

  if @check3 < 1 begin
    --Validar que  exista el departamento en el sistema
   select @check4 = count(1)
    from #table_name# a 
     where not exists ( select 1 from  Departamentos b
                               where a.Deptocodigo = b.Deptocodigo
                                  and b.Ecodigo = @Ecodigo )

   if @check4 < 1 begin
      if exists(select 1 from Almacen where Ecodigo = @Ecodigo) begin
        select @maxid = max(Aid) from Almacen where Ecodigo = @Ecodigo
      end
      else begin
        select @maxid =  0
      end
      insert Almacen( Ecodigo, Almcodigo, Ocodigo, Dcodigo, Bdescripcion, Bdireccion, Btelefono)
        select  @Ecodigo, a.Almcodigo, b.Ocodigo, c.Dcodigo, Bdescripcion, Bdireccion, Btelefono
           from #table_name# a, Oficinas b, Departamentos c
           where a.Oficodigo =b.Oficodigo
            and a.Deptocodigo = c.Deptocodigo
            and b.Ecodigo = @Ecodigo
            and c.Ecodigo = @Ecodigo

   end --check4
   else begin 
     select 'Departamento no se encuentra registrado en el sistema' as Error, a.Deptocodigo as Departamento
      from #table_name# a 
        where not exists (select 1 from  Departamentos b
                                   where a.Deptocodigo = b.Deptocodigo
                                       and b.Ecodigo = @Ecodigo )

   end --check4
  end --check3
  else begin
      select 'Oficinas no se encuentran registrado en el sistema' as Error, a.Oficodigo as Oficina
           from #table_name# a 
           where not exists ( select 1 from  Oficinas b
                                       where a.Oficodigo = b.Oficodigo
                                          and b.Ecodigo = @Ecodigo )

  end --check3
 end --check2
 else begin
   select 'Almacen ya esta registrado  en el sistema' as Error, a.Almcodigo as Almacen
   from #table_name# a, Almacen b
    where a.Almcodigo = b.Almcodigo
    and b.Ecodigo = @Ecodigo
 end --check2
end--check1
else begin
   select 'Existen Almacenes duplicados en el archivo' as Error, Almcodigo as Almacen
    from #table_name#
    group by Almcodigo
     having count(1) > 1
end	
772	  

         insert IAContables (Ecodigo,  IACcodigogrupo, IACdescripcion,
                              IACinventario, IACingajuste, IACgastoajuste, 
                              IACcompra, IACingventa, IACcostoventa, IACtransito)
             select @Ecodigo,  IACcodigogrupo, IACdescripcion, 
                              1, 1, 1, 1, 1, 1, 1
             from #table_name# a
	
773	declare @check1 numeric


--Validar que no existan datos duplicados
select @check1 = count(count(1))
from #table_name#
group by Acodigo, Almcodigo
having count(1) > 1

if @check1 > 0 begin
  select 'Codigo Articulo-Almacen duplicado en el archivo' as Error, Acodigo as Articulo, Almcodigo as Almacen
   from #table_name#
   group by Acodigo, Almcodigo
   having count(1) > 1
end
else begin

 --Validar si ya existen Codigo Articulo-Almancen registrado en el sistema
 if  (select count(1) 
       from #table_name# a, Articulos b, Almacen c, Existencias d
       where a.Acodigo = b.Acodigo
          and b.Ecodigo = @Ecodigo
          and a.Almcodigo = c.Almcodigo
          and c.Ecodigo = @Ecodigo
          and b.Aid = d.Aid
          and c.Aid = d.Alm_Aid
          and d.Ecodigo = @Ecodigo ) > 0 
  begin
       select 'Existencia de Codigo Articulo-Almacen ya se encuentra registrado en el sistema' as Error, a.Acodigo as Articulo, a.Almcodigo as Almacen
       from #table_name# a, Articulos b, Almacen c, Existencias d
       where a.Acodigo = b.Acodigo
          and b.Ecodigo = @Ecodigo
          and a.Almcodigo = c.Almcodigo
          and c.Ecodigo = @Ecodigo
          and b.Aid = d.Aid
          and c.Aid = d.Alm_Aid
          and d.Ecodigo = @Ecodigo      
 end
 else begin

  --Verificar que exista el codigo del articulo
  if (select count(1) from #table_name#)  <>
     (select count(1)  from #table_name# a, Articulos b
       where a.Acodigo = b.Acodigo
          and b.Ecodigo = @Ecodigo)  
   begin
      select 'Articulo no se encuentra registrado en el sistema' as Error, Acodigo as Articulo
       from #table_name# a
       where not exists (select 1 from Articulos b
                                  where a.Acodigo = b.Acodigo
                                     and b.Ecodigo = @Ecodigo)
  end
  else begin

   --Verificar que exista el Almacen
    if (select count(1) from #table_name#) <>
       (select count(1)  from #table_name# a,  Almacen c
       where  a.Almcodigo = c.Almcodigo
          and c.Ecodigo = @Ecodigo) 
    begin
        select 'Almacen no se encuentra registrado en el sistema' as Error, Almcodigo as Almacen
          from #table_name# a
          where not exists (select 1 from  Almacen c
                                   where  a.Almcodigo = c.Almcodigo
                                       and c.Ecodigo = @Ecodigo)
    end
    else begin

      --Verificar que existe el grupo
      if (select count(1) from #table_name#
               where ltrim(rtrim(IACcodigogrupo)) <>''
                        and IACcodigogrupo is not null) <>
         (select count(1) from #table_name# a, IAContables b
                 where a.IACcodigogrupo = b.IACcodigogrupo
                      and b.Ecodigo =  @Ecodigo )
	begin
         select ' Grupo no se encuentra registrada en el sistema ' as Error, a.IACcodigogrupo as Grupo_Contable
             from #table_name# a
             where ltrim(rtrim(a.IACcodigogrupo)) <> ''
                 and a.IACcodigogrupo is not null
                  and not exists (select 1 from IAContables b
		      where a.IACcodigogrupo = b.IACcodigogrupo
                                                 and b.Ecodigo = @Ecodigo)

      end
      else begin

          insert Existencias(Aid, Alm_Aid, Ecodigo, IACcodigo, Eexistencia, Eexistmin, Eexistmax, Ecostou, Epreciocompra, Ecostototal, Esalidas)
           select  b.Aid, c.Aid, @Ecodigo, d.IACcodigo, Eexistencia, Eexistmin, Eexistmax, 0, 0, 0, 0
                from #table_name# a, Articulos b, Almacen c, IAContables d
                where a.Acodigo = b.Acodigo
                   and a.Almcodigo = c.Almcodigo
                   and a.IACcodigogrupo = d.IACcodigogrupo
                   and b.Ecodigo = @Ecodigo
                   and c.Ecodigo = @Ecodigo
                   and d.Ecodigo = @Ecodigo

      end -- si existe Cuenta 
    end --si existe Almacen
  end -- si existe Articulo
 end -- ya existe Articulo-Almacen en el sistema
end --check1 duplicados	
774	declare @check1 numeric, @check2 numeric, @check3 numeric, @maxid numeric

-- Validar que no existan duplicados en el archivo
select @check1 = count(count(1))
from #table_name#
group by ACcodigodesc
having count(1) > 1

if @check > 0 begin
  select 'Existen categorias duplicadas en el archivo' as Error, ACcodigodesc as Categoria
   from #table_name#
   group by ACcodigodesc
   having count(1) > 1
end
else begin
  -- Validar que no exista la categoria en el sistema
  if  exists(select 1 from #table_name# a, ACategoria b
                  where a.ACcodigodesc = b.ACcodigodesc
                     and b.Ecodigo = @Ecodigo) begin
      select 'Categoria ya esta registrada en el sistema' as Error, a.ACcodigodesc as Categoria
         from #table_name# a, ACategoria b
         where a.ACcodigodesc = b.ACcodigodesc
             and b.Ecodigo = @Ecodigo
  end
  else begin
     select @maxid = max(ACcodigo) from ACategoria where Ecodigo = @Ecodigo
     select @maxid = isnull(@maxid, 0)
     insert ACategoria (Ecodigo, ACcodigo, ACcodigodesc, ACdescripcion, ACvutil, ACcatvutil, ACmetododep, ACmascara)
           select @Ecodigo, id + @maxid, ACcodigodesc, ACdescripcion, ACvutil, ACcatvutil, ACmetododep, ACmascara
              from #table_name#
  end -- exite la categoria en el sistema
end --check1 duplicados	
775	declare @check1 numeric

-- Validar que no existan duplicados en el archivo
select @check1 = count(count(1))
from #table_name#
group by ACcodigoCat, ACcodigodesc
having count(1) > 1

if @check1 > 0 begin
  select 'Codigo Categoria-Clase estan duplicados en el archivo' as Error, ACcodigoCat as Categoria, ACcodigodesc as Clase
  from #table_name#
  group by ACcodigoCat, ACcodigodesc
  having count(1) > 1
end 
else begin
 -- Verificar que no existan Categoria y Clase en el sistema
 if exists (select 1 from #table_name# a, AClasificacion b, ACategoria c
                 where a.ACcodigoCat = c.ACcodigodesc
                    and c.ACcodigo = b.ACcodigo
                    and c.Ecodigo = @Ecodigo
                    and b.Ecodigo = @Ecodigo
                    and b.ACcodigodesc = a.ACcodigodesc)
  begin
       select 'Categoria-Clase ya esta registrado en el sistema' as Error, a.ACcodigoCat as Categoria, a.ACcodigodesc as Clase
          from #table_name# a,  AClasificacion b, ACategoria c
           where a.ACcodigoCat = c.ACcodigodesc
              and c.ACcodigo = b.ACcodigo
              and c.Ecodigo = @Ecodigo
              and b.Ecodigo = @Ecodigo
              and b.ACcodigodesc = a.ACcodigodesc
  end
  else begin
   --Validar que exista la categoria
   if (select count(1) from #table_name#) <>
      (select count(1) from #table_name# a, ACategoria b
           where a.ACcodigoCat = b.ACcodigodesc
              and b.Ecodigo = @Ecodigo)
   begin
        select 'Categoria no esta registrada en el sistema' as Error, a.ACcodigoCat as Categoria
           from #table_name# a
            where not exists( select 1 from ACategoria b
                                       where a.ACcodigoCat = b.ACcodigodesc
                                          and b.Ecodigo = @Ecodigo)
   end
   else begin
     --Validar que exista cuenta superavit
     if (select count(1) from #table_name#) <>
        (select count(1) from #table_name# a, CFinanciera b
            where a.ACcsuperavitf = b.CFformato
                and b.Ecodigo = @Ecodigo)
     begin
        select 'Cuenta Superavit no esta registrada en el sistema' as Error, a.ACcsuperavitf as Cuenta_Superavit
            from #table_name# a
            where not exists ( select 1 from  CFinanciera b
                                        where a.ACcsuperavitf = b.CFformato
                                           and b.Ecodigo = @Ecodigo)
     end
     else begin
      --Validar que exista cuenta adquisicion
      if (select count(1) from #table_name#) <>
        (select count(1) from #table_name# a, CFinanciera b
            where a.ACcadqf = b.CFformato
                and b.Ecodigo = @Ecodigo)
      begin
        select 'Cuenta Adquisicion no esta registrada en el sistema' as Error, a.ACcadqf as Cuenta_Adquisicion
            from #table_name# a
            where not exists ( select 1 from  CFinanciera b
                                        where a.ACcadqf = b.CFformato
                                           and b.Ecodigo = @Ecodigo)
      end
      else begin
       --Validar que exista cuenta Depreciacion acumulada
       if (select count(1) from #table_name#) <>
          (select count(1) from #table_name# a, CFinanciera b
            where a.ACcdepacumf = b.CFformato
                and b.Ecodigo = @Ecodigo)
       begin
         select 'Cuenta Depreciacion Acumulada no esta registrada en el sistema' as Error, a.ACcdepacumf as Cuenta_Depreciacion
            from #table_name# a
            where not exists ( select 1 from  CFinanciera b
                                        where a.ACcdepacumf = b.CFformato
                                           and b.Ecodigo = @Ecodigo)
       end
       else begin
        --Validar que exista cuenta Revaluacion
        if (select count(1) from #table_name#) <>
           (select count(1) from #table_name# a, CFinanciera b
            where a.ACcrevaluacionf = b.CFformato
                and b.Ecodigo = @Ecodigo)
        begin
          select 'Cuenta Revaluacion no esta registrada en el sistema' as Error, a.ACcrevaluacionf as Cuenta_Revaluacion
             from #table_name# a
             where not exists ( select 1 from  CFinanciera b
                                        where a.ACcrevaluacionf = b.CFformato
                                           and b.Ecodigo = @Ecodigo)
        end
        else begin
         --Validar que exista cuenta Depreciacion de laRevaluacion
         if (select count(1) from #table_name#) <>
            (select count(1) from #table_name# a, CFinanciera b
             where a.ACcdepacumrevf = b.CFformato
                 and b.Ecodigo = @Ecodigo)
         begin
           select 'Cuenta Depreciacion de la Revaluacion no esta registrada en el sistema' as Error, a.ACcdepacumrevf as Cuenta_Dep_Rev
              from #table_name# a
              where not exists ( select 1 from  CFinanciera b
                                        where a.ACcdepacumrevf = b.CFformato
                                           and b.Ecodigo = @Ecodigo)
         end
         else begin
            insert AClasificacion (Ecodigo, ACcodigo, ACid, ACcodigodesc, ACdescripcion, ACvutil, ACdepreciable, ACrevalua, ACcsuperavit, ACcadq, ACcdepacum, ACcrevaluacion, ACcdepacumrev, ACtipo, ACvalorres)
                      select @Ecodigo, b.ACcodigo, id, a.ACcodigodesc, a.ACdescripcion, a.ACvutil, a.ACdepreciable, a.ACrevalua, c.CFcuenta, d.CFcuenta, e.CFcuenta, f.CFcuenta, g.CFcuenta, a.ACtipo, a.ACvalorres
                            from #table_name# a, ACategoria b, CFinanciera c , CFinanciera d, CFinanciera e, CFinanciera f, CFinanciera g
                            where a.ACcodigoCat = b.ACcodigodesc
                               and b.Ecodigo = @Ecodigo
                               and a.ACcsuperavitf = c.CFformato
                               and a.ACcadqf = d.CFformato
                               and a.ACcdepacumf = e.CFformato
                               and a.ACcrevaluacionf = f.CFformato
                               and a.ACcdepacumrevf = g.CFformato
                               and c.Ecodigo = @Ecodigo
                               and d.Ecodigo = @Ecodigo
                               and e.Ecodigo = @Ecodigo
                               and f.Ecodigo = @Ecodigo
                               and g.Ecodigo = @Ecodigo
         end -- existe cuenta Depreciacion de la Revaluacion?
        end -- existe cuenta Revaluacion?
       end -- existe cuenta Depreciacion Acumulada?
      end -- existe cuenta adquisicion?
     end -- existe cuenta superavit?
   end -- existe la categoria?
  end -- existe Categoria-Clase en el sistema
end --check1 duplicados	
865	declare @check1 numeric, @check2 numeric, @check3 numeric,  @mini numeric, @CFresp  varchar(10), @CFcodigo varchar(10), @CFidresp numeric,  @Cnivel numeric, @Cpath varchar(255), @maxid numeric

-- Validar que no existan duplicados en el archivo
select @check1 = count(count(1))
from #table_name#
group by CFcodigo
having count(1) > 1

if @check1 > 0  begin
 select 'Codigo de Centro Funcional aparece duplicado en el archivo' as Error, CFcodigo as Centro_Funcional
   from #table_name#
  group by CFcodigo
  having count(1) > 1
end
else begin
 -- Validar si ya existe el Centro Funcional  en el sistema
 if exists ( select 1    from #table_name# a, CFuncional b
                 where a.CFcodigo = b.CFcodigo
                    and b.Ecodigo = @Ecodigo)
 begin
    select 'Centro Funcional ya esta registrado en el sistemas' as Error, a.CFcodigo as Centro_Funcional
        from #table_name# a, CFuncional b
                 where a.CFcodigo = b.CFcodigo
                    and b.Ecodigo = @Ecodigo
 end
 else begin
   --Validar que exista Departamento
   if (select count(1) from #table_name#) <>
      (select count(1) from #table_name# a, Departamentos b
          where a.Deptocodigo = b.Deptocodigo
             and b.Ecodigo = @Ecodigo)
   begin
      select 'Departamento no se encuentra registrado en el sistema' as Error, a.Deptocodigo as Departamento
         from #table_name# a
         where not exists (select 1 from Departamentos b
                                    where a.Deptocodigo = b.Deptocodigo
                                        and b.Ecodigo = @Ecodigo)
   end
   else begin
     --Validar que exista la Oficina
     if (select count(1) from #table_name#) <>
        (select count(1) from #table_name# a, Oficinas b
            where a.Oficodigo = b.Oficodigo
               and b.Ecodigo = @Ecodigo)
     begin
        select 'Oficina no se encuentra registrada en el sistema' as Error, a.Oficodigo as Oficina
           from #table_name# a
           where not exists (select 1 from  Oficinas b
                                       where a.Oficodigo = b.Oficodigo
                                          and b.Ecodigo = @Ecodigo)

     end
     else begin
       -- Validar que exista el Centro Responsable
      if (select  count(1)  from #table_name# a 
               where ltrim(rtrim(a.CFresp)) <> '' 
                  and a.CFresp  is not null ) <>
           ( select count(1)  from #table_name# a, #table_name# b
                           where a.CFresp = b.CFcodigo)
      begin
         select 'Centro Responsable no se encuentra registrado' as Error, a.CFresp as Centro_Responsable
              from #table_name# a 
               where ltrim(rtrim(a.CFresp)) <> '' 
                and a.CFresp  is not null 
                and not exists  ( select 1  from #table_name# b
                           where a.CFresp = b.CFcodigo)
       
      end 
      else begin
        --Validar que exista el Comprador
        if (select count(1) from #table_name# a
                  where a.CMCcodigo <> ''
                     and a.CMCcodigo is not null) <>
           (select count(1) from #table_name# a, CMCompradores b
            where a.CMCcodigo = b.CMCcodigo
               and b.Ecodigo = @Ecodigo)
        begin
          select 'Comprador no se encuentra registrada en el sistema' as Error, a.CMCcodigo as Comprador
              from #table_name# a
               where not exists (select 1 from  CMCompradores b
                                       where a.CMCcodigo = b.CMCcodigo
                                          and b.Ecodigo = @Ecodigo)

       end
       else begin
         if exists (select 1 from CFuncional where Ecodigo = @Ecodigo)
         begin
                select @maxid = max(CFid) from CFuncional where Ecodigo = @Ecodigo
         end
         else begin
                select @maxid = 0
         end

         select @mini = -1
         select @mini = min(id) from #table_name# where id > @mini
         while @mini is not null begin

            select @CFresp = ltrim(rtrim(CFresp)) , 
                     @CFcodigo = ltrim(rtrim(CFcodigo))
               from #table_name# where id = @mini

            if (@CFresp = '') or (@CFresp is null) begin
               select @Cnivel = 0, @Cpath = right(('00000' + @CFcodigo), 5)
            end
            else begin
               select @Cnivel = 0
               select @Cpath = right(('00000' + @CFcodigo), 5) 
   
               while (@CFresp is not null) and (@CFresp <>'') begin
                  select @Cpath = @Cpath +  '/' + right(('00000' + @CFresp), 5)
                  select @Cnivel = @Cnivel + 1
                  select @CFresp = ltrim(rtrim(CFresp)) from #table_name#
                         where CFcodigo = @CFresp
               end 
            end

            insert CFuncional( Ecodigo, CFcodigo, Dcodigo, Ocodigo, CFdescripcion,  CFcuentac, CFuresponsable, CFcomprador, CFpath, CFnivel)
                        select  @Ecodigo, a.CFcodigo, b.Dcodigo, c.Ocodigo, a.CFdescripcion, a.CFcuentac, a.CFuresponsable, d.CMCid, @Cpath, @Cnivel
                 from #table_name# a, Departamentos b, Oficinas c, CMCompradores d
                 where a.id = @mini
                    and a.Deptocodigo = b.Deptocodigo
                    and b.Ecodigo = @Ecodigo
                    and a.Oficodigo = c.Oficodigo
                    and c.Ecodigo = @Ecodigo 
                    and a.CMCcodigo *= d.CMCcodigo
                    and d.Ecodigo = @Ecodigo

            select @mini = min(id) from #table_name# where id > @mini
         end --while
         if exists( select 1 from #table_name# where ltrim(rtrim(CFresp)) <> '' and CFresp is not null)
         begin
             select @mini = -1
             select @mini = min(id) from #table_name# where id > @mini and ltrim(rtrim(CFresp)) <> '' and CFresp is not null
             while @mini is not null begin
                select @CFresp = ltrim(rtrim(CFresp)) , 
                         @CFcodigo = ltrim(rtrim(CFcodigo))
                   from #table_name# where id = @mini
                select   @CFidresp = CFidresp from CFuncional 
                      where  CFcodigo = @CFresp
                        and   Ecodigo = @Ecodigo
                 update CFuncional
                        set CFidresp = @CFidresp
                       where Ecodigo = @Ecodigo
                          and CFcodigo = @CFcodigo
    
                 select @mini = min(id) from #table_name# where id > @mini and ltrim(rtrim(CFresp)) <> '' and CFresp is not null
             end
         end
       end -- existe Comprador?
      end -- existe Centro Responsable?
     end -- existe Oficina ?
   end -- existe Dpto?
 end  -- Centro funcional ya existe
end -- Duplicados en el archivo	
866	declare @check1 numeric

-- Validar que no existan duplicados en el archivo
select @check1 = count(count(1))
from #table_name#
group by EOnumero
having count(1) > 1

if @check1 > 0  begin
  select 'Existen OC duplcadas en el archivo ' as Error, EOnumero as OC
   from #table_name#
   group by EOnumero
   having count(1) > 1
end
else begin
  -- Validar si ya existe el codigo de clasificacion en el sistema
 if exists  (select 1    from #table_name# a, EOrdenCM b
                  where a.EOnumero = b.EOnumero
                     and b.Ecodigo = @Ecodigo )
 begin
   select 'Orden de Compra ya se encuentra en el sistema' as Error, a.EOnumero as Orden_Compra
    from #table_name# a, EOrdenCM b
                  where a.EOnumero = b.EOnumero
                     and b.Ecodigo = @Ecodigo 

 end
 else begin
   --Validar que exista el Socio de Negocio 
   if (select  count(1) from #table_name#) <>
      (select count(1) from #table_name# a, SNegocios b
          where a.SNcodigo = b.SNcodigo
             and b.Ecodigo = @Ecodigo)
   begin
         select 'Socio Negocio no se encuentra registrado en el sistema' as Error, a.SNcodigo as Socio_Negocio
              from #table_name# a
              where not exists ( select 1 from  SNegocios b
                                         where a.SNcodigo = b.SNcodigo
                                          and b.Ecodigo = @Ecodigo )
    end
    else begin
     --Validar que exista el Comprador
    if (select  count(1) from #table_name#) <>
       (select count(1) from #table_name# a, CMCompradores b
          where a.CMCcodigo = b.CMCcodigo
             and b.Ecodigo = @Ecodigo)
     begin
         select 'Comprador no se encuentra registrado en el sistema' as Error, a.CMCcodigo as Comprador
              from #table_name# a
              where not exists ( select 1 from  CMCompradores b
                                         where a.CMCcodigo = b.CMCcodigo
                                          and b.Ecodigo = @Ecodigo )
     end
     else begin
     --Validar que exista Moneda
     if (select  count(1) from #table_name#) <>
        (select count(1) from #table_name# a, Monedas b
           where a.Miso4217 = b.Miso4217
              and b.Ecodigo = @Ecodigo)
      begin
         select 'Moneda no se encuentra registrado en el sistema' as Error, a.Miso4217 as Moneda
              from #table_name# a
              where not exists ( select 1 from  Monedas b
                                         where a.Miso4217 = b.Miso4217
                                          and b.Ecodigo = @Ecodigo )
      end
      else begin
      --Validar que exista Tipo OC
      if (select  count(1) from #table_name#) <>
         (select count(1) from #table_name# a, CMTipoOrden b
           where a.CMTOcodigo = b.CMTOcodigo
              and b.Ecodigo = @Ecodigo)
       begin
         select 'Tipo OC no se encuentra registrado en el sistema' as Error, a.CMTOcodigo as Tipo_OC
              from #table_name# a
              where not exists ( select 1 from  CMTipoOrden b
                                         where a.CMTOcodigo = b.CMTOcodigo
                                          and b.Ecodigo = @Ecodigo )
       end
       else begin
          insert EOrdenCM(Ecodigo, EOnumero, SNcodigo, CMCid, Mcodigo, CMTOcodigo, EOfecha, Observaciones, EOtc, Impuesto, EOdesc, EOtotal, EOfalta, EOplazo, EOporcanticipo, EOestado, Usucodigo)
            select   @Ecodigo, a.EOnumero, a.SNcodigo, b.CMCid, c.Mcodigo, a.CMTOcodigo, a.EOfecha, a.Observaciones, a.EOtc, a.Impuesto, a.EOdesc, a.EOtotal, a.EOfecha, a.EOplazo, a.EOporcanticipo, a.EOestado, 1               from #table_name# a, CMCompradores b, Monedas c
               where a.CMCcodigo = b.CMCcodigo
                  and b.Ecodigo = @Ecodigo
                  and a.Miso4217 = c.Miso4217
                  and c.Ecodigo = @Ecodigo

       end -- existe tipo OC ?
      end -- existe Moneda ?
     end -- existe comprador ?
    end -- existe Socio Negocio ?
 end  --ya existe la OC
end -- duplicados	
867	declare @check1 numeric, @check2 numeric, @check3 numeric,  @mini numeric, @Ccodigoclaspadre  varchar(5), @Ccodigoclas varchar(5), @Ccodigopadre numeric,  @Cnivel numeric, @Cpath varchar(255)

-- Validar que no existan duplicados en el archivo
select @check1 = count(count(1))
from #table_name#
group by EOnumero, DOconsecutivo
having count(1) > 1

if @check1 > 0 
begin
 select 'Detalle de OC esta duplicado en el archivo' as Error, EOnumero as Numero_OC, DOconsecutivo as Detalle
   from #table_name#
   group by EOnumero, DOconsecutivo
   having count(1) > 1

end
else begin
 -- Validar si ya existe OC-Detalle en el sistema
 if exists ( select 1   from #table_name# a, DOrdenCM b
    where a.EOnumero = b.EOnumero
       and a.DOconsecutivo = b.DOconsecutivo
       and b.Ecodigo = @Ecodigo )
 begin
   select 'Detalle de OC ya se encuentra registrada en el sistema' as Error, a.EOnumero as Numero_OC, a.DOconsecutivo as Detalle
    from #table_name# a, DOrdenCM b
    where a.EOnumero = b.EOnumero
       and a.DOconsecutivo = b.DOconsecutivo
       and b.Ecodigo = @Ecodigo 
 end
 else begin
  -- Validar que exista Concepto
  if (select count(1) from #table_name# a
       where ltrim(rtrim(a.Ccodigo)) <> ''
          and a.Ccodigo is not null  ) <>
    (select count(1) from #table_name# a, Conceptos b
    where a.Ccodigo = b.Ccodigo
       and b.Ecodigo = @Ecodigo )
  begin
    select 'Concepto no se encuentra registrada en el sistema' as Error, a.Ccodigo as Concepto
     from #table_name# a
     where not exists (select 1 from Conceptos b
                              where a.Ccodigo = b.Ccodigo
                                  and b.Ecodigo = @Ecodigo )
  end
  else begin
   -- Validar que exista Articulo
   if (select count(1) from #table_name# a
       where a.Acodigo is not null
          and ltrim(rtrim(a.Acodigo)) <> '' ) <>
      (select count(1) from #table_name# a, Articulos b
      where a.Acodigo = b.Acodigo
        and b.Ecodigo = @Ecodigo )
   begin
     select 'Articulo no se encuentra registrada en el sistema' as Error, a.Acodigo as Articulo
      from #table_name# a
      where not exists (select 1 from Articulos b
                               where a.Acodigo = b.Acodigo
                                   and b.Ecodigo = @Ecodigo )
   end
   else begin
    -- Validar que exista Almacen
    if (select count(1) from #table_name# a
       where a.Almcodigo is not null
          and ltrim(rtrim(a.Almcodigo)) <> '' ) <>
       (select count(1) from #table_name# a, Almacen b
       where a.Almcodigo = b.Almcodigo
         and b.Ecodigo = @Ecodigo )
    begin
      select 'Almacen no se encuentra registrado en el sistema' as Error, a.Almcodigo as Almacen
       from #table_name# a
       where not exists (select 1 from Almacen b
                               where a.Almcodigo = b.Almcodigo
                                   and b.Ecodigo = @Ecodigo )
    end
    else begin
     -- Validar que exista Categoria-Clase
     if (select count(1) from #table_name# a
           where a.ACcodigo is not null
            and ltrim(rtrim(a.ACcodigo)) <> ''
            and a.ACid is not null
            and ltrim(rtrim(a.ACid)) <> '' ) <>
        (select count(1) from #table_name# a, ACategoria b, AClasificacion c
        where a.ACcodigo = b.ACcodigodesc
           and b.Ecodigo = @Ecodigo
           and b.ACcodigo = c.ACcodigo
           and c.Ecodigo = @Ecodigo
           and a.ACid = c.ACcodigodesc  )
     begin
       select 'Categoria-Clase no se encuentra registrado en el sistema' as Error, a.ACcodigo as Categoria, a.ACid as Clase
        from #table_name# a
         where a.ACcodigo is not null
            and ltrim(rtrim(a.ACcodigo)) <> ''
            and a.ACid is not null
            and ltrim(rtrim(a.ACid)) <> '' 
            and not exists (select 1 from  ACategoria b, AClasificacion c
                                  where a.ACcodigo = b.ACcodigodesc
                                     and b.Ecodigo = @Ecodigo
                                     and b.ACcodigo = c.ACcodigo
                                     and c.Ecodigo = @Ecodigo
                                     and a.ACid = c.ACcodigodesc )
     end
     else begin
      -- Validar que exista Centro Funcional
      if (select count(1) from #table_name# a ) <>
         (select count(1) from #table_name# a, CFuncional b   
           where a.CFcodigo = b.CFcodigo
            and b.Ecodigo = @Ecodigo )
      begin
        select 'Centro Funcional no se encuentra registrado en el sistema' as Error, a.CFcodigo as Centro_Funcional
         from #table_name# a
          where not exists (select 1 from  CFuncional b
                                        where a.CFcodigo = b.CFcodigo                                      
                                           and b.Ecodigo = @Ecodigo)
      end
      else begin
       -- Validar que exista Impuesto
       if (select count(1) from #table_name# a ) <>
          (select count(1) from #table_name# a, Impuestos b   
            where a.Icodigo = b.Icodigo
             and b.Ecodigo = @Ecodigo )
       begin
         select 'Impuesto no se encuentra registrado en el sistema' as Error, a.Icodigo as Impuesto
          from #table_name# a
           where not exists (select 1 from  Impuestos b
                                         where a.Icodigo = b.Icodigo                                      
                                            and b.Ecodigo = @Ecodigo)
       end
       else begin
        -- Validar que exista Unidad Medida
        if (select count(1) from #table_name# a ) <>
           (select count(1) from #table_name# a, Unidades b   
             where a.Ucodigo = b.Ucodigo
              and b.Ecodigo = @Ecodigo )
        begin
          select 'Unidad Medida no se encuentra registrado en el sistema' as Error, a.Ucodigo as Unidad
           from #table_name# a
            where not exists (select 1 from  Unidades b
                                          where a.Ucodigo = b.Ucodigo                                      
                                             and b.Ecodigo = @Ecodigo)
        end
        else begin
        -- Validar que exista Pais
        if (select count(1) from #table_name# a 
                  where a.Ppais is not null
                      and ltrim(rtrim(a.Ppais ))<>'') <>
           (select count(1) from #table_name# a, Pais b   
             where a.Ppais = b.Ppais)
        begin
         select 'Pais no se encuentra registrado en el sistema' as Error, a.Ppais as Pais
          from #table_name# a
           where not exists (select 1 from  Pais b
                                         where a.Ppais = b.Ppais)
        end
        else begin
           insert DOrdenCM( Ecodigo, EOidorden, EOnumero, DOconsecutivo, CMtipo, Cid, Aid, Alm_Aid, ACcodigo, ACid,   CFid, Icodigo, Ucodigo, DOdescripcion, DOalterna, DOobservaciones, DOcantidad, DOcantsurtida, DOpreciou, DOtotal, DOfechaes, DOgarantia, Ppais, DOfechareq)
                  select  @Ecodigo, b.EOidorden, a.EOnumero, a.DOconsecutivo, a.CMtipo, c.Cid, d.Aid, e.Aid, f.ACcodigo, f.ACid, h.CFid, a.Icodigo, a.Ucodigo, a.DOdescripcion, a.DOalterna, a.DOobservaciones, a.DOcantidad, a.DOcantsurtida, a.DOpreciou, a.DOtotal, a.DOfechaes, a.DOgarantia, a.Ppais, a.DOfechareq
                   from #table_name# a, EOrdenCM b, Conceptos c, Articulos d, Almacen e, AClasificacion f, ACategoria g, CFuncional h
                   where a.EOnumero = b.EOnumero
                      and b.Ecodigo = @Ecodigo
                      and a.Ccodigo = c.Ccodigo
                      and c.Ecodigo = @Ecodigo
                      and a.Acodigo = d.Acodigo
                      and d.Ecodigo = @Ecodigo
                      and a.Almcodigo = e.Almcodigo
                      and e.Ecodigo = @Ecodigo
                      and a.ACcodigo = g.ACcodigodesc
                      and g.Ecodigo = @Ecodigo
                      and g.ACcodigo = f.ACcodigo
                      and f.Ecodigo = @Ecodigo
                      and a.ACid = f.ACcodigodesc
                      and a.CFcodigo = h.CFcodigo
                      and h.Ecodigo = @Ecodigo


        end -- existe PAis?     
        end -- existe Unidad Medida?    
       end -- existe Impuesto?  
      end -- existe Centro Funcional?  
     end -- existe Categoria-Clase ?  
    end -- existe Almacen ? 
   end -- existe Articulo ?
  end -- existe concepto?
 end -- existe OC-Detalle en el sistema ?
end -- duplicados	
868	declare @check1 numeric, @fecha datetime

select @fecha = getdate()

-- Validar que no existan duplicados en el archivo
select @check1 = count(count(1))
from #table_name#
group by CMScodigo
having count(1) > 1

if @check1 > 0 begin
  select 'Solicitantes Duplicados en el archivo' as Error, a.CMScodigo as Solicitante
   from #table_name# a
   group by a.CMScodigo
   having count(1) > 1
end
else begin
 -- Validar si ya existe el codigo de Solicitante en el sistema
 if exists (select 1 from #table_name# a, CMSolicitantes b
    where a.CMScodigo = b.CMScodigo
       and b.Ecodigo = @Ecodigo)
 begin
    select 'El codigo de Solicitante ya esta registrado' as Error, a.CMScodigo as Solicitante       
        from #table_name# a, CMSolicitantes b
        where a.CMScodigo = b.CMScodigo
           and b.Ecodigo = @Ecodigo
 end 
 else begin
    insert CMSolicitantes ( Ecodigo, CMScodigo, CMSnombre, CMSestado, Usucodigo, CMSfalta)
                   select  @Ecodigo, a.CMScodigo, CMSnombre + ' ' + CMSpapellido + ' ' + CMSsapellido , 1, 1, @fecha
                       from #table_name# a
 end -- Solicitante ya existe
end --duplicados	
869	declare @check1 numeric, @fecha datetime

select @fecha = getdate()

-- Validar que no existan duplicados en el archivo
select @check1 = count(count(1))
from #table_name#
group by CMScodigo, CFcodigo
having count(1) > 1

if @check1 > 0 begin
  select 'Solicitante - Centro funcional duplicado en el archivo' as Error, CMScodigo as Solicitante, CFcodigo as Centro_Funcional
  from #table_name#
  group by CMScodigo, CFcodigo
  having count(1) > 1

end
else begin
 -- Validar si ya existe Solicitante-Centro Funcional en el sistema
 if exists (select 1 from #table_name# a, CMSolicitantesCF b, CMSolicitantes c, CFuncional d
                where a.CMScodigo = c.CMScodigo
                   and c.Ecodigo = @Ecodigo
                   and a.CFcodigo = d.CFcodigo
                   and d.Ecodigo = @Ecodigo
                   and c.CMSid = b.CMSid
                   and d.CFid = b.CFid)
 begin
    select 'Existe Solicitante - Centro funcional registrado en el sistema' as Error, a.CMScodigo as Solicitante, a.CFcodigo as Centro_Funcional
        from #table_name# a, CMSolicitantesCF b, CMSolicitantes c, CFuncional d
                where a.CMScodigo = c.CMScodigo
                   and c.Ecodigo = @Ecodigo
                   and a.CFcodigo = d.CFcodigo
                   and d.Ecodigo = @Ecodigo
                   and c.CMSid = b.CMSid
                   and d.CFid = b.CFid

 end
 else begin
  -- Validar que exista Solictante
  if (select count(1)  from #table_name# ) <>
     (select count(1) from #table_name# a, CMSolicitantes b
                where a.CMScodigo = b.CMScodigo
                   and b.Ecodigo = @Ecodigo)
  begin
    select 'Solicitante no esta registrado en el sistema' as Error, a.CMScodigo as Solicitante
        from #table_name# a
        where not exists (select 1 from  CMSolicitantes b
                                    where a.CMScodigo = b.CMScodigo
                                       and b.Ecodigo = @Ecodigo)
  end
  else begin
   -- Validar que exista Centro Funcional
   if (select count(1)  from #table_name# ) <>
      (select count(1) from #table_name# a, CFuncional b
                where a.CFcodigo = b.CFcodigo
                   and b.Ecodigo = @Ecodigo)
   begin
     select 'Centro Funcional no esta registrado en el sistema' as Error, a.CFcodigo as Centro_Funcional
         from #table_name# a
         where not exists (select 1 from  CFuncional b
                                    where a.CFcodigo = b.CFcodigo
                                       and b.Ecodigo = @Ecodigo)
   end
   else begin
     insert CMSolicitantesCF(CFid, CMSid, Usucodigo, CMSCFfecha)
        select b.CFid, c.CMSid, 1, @fecha
           from #table_name# a, CFuncional b, CMSolicitantes c
           where a.CFcodigo = b.CFcodigo
              and b.Ecodigo = @Ecodigo
              and a.CMScodigo = c.CMScodigo
              and c.Ecodigo = @Ecodigo
 
  
   end -- existe Centro Funcional?  
  end -- existe solicitante?
 end -- Ya Existe  Solicitante-C.Funcional
end --duplicados	
965	declare @check1 numeric, @check2 numeric, @check3 numeric, @check4 numeric, @check5 numeric, @check6 numeric, @SNcodigo int

-- Chequear existencia de Números de Socio
if exists(select 1 from #table_name# a, SNegocios b
                   where a.SNnumero = b.SNnumero
                      and b.Ecodigo = @Ecodigo)
begin
   select 'Socio Negocio ya existe' as Error, a.SNnumero as Socio
      from #table_name# a, SNegocios b
       where a.SNnumero = b.SNnumero
          and b.Ecodigo = @Ecodigo
end
else begin
 -- Chequear existencia de Identificacion de Socio
 if exists(select 1 from #table_name# a, SNegocios b
                   where a.SNnumero = b.SNidentificacion
                      and b.Ecodigo = @Ecodigo)
 begin
   select 'Socio Negocio ya existe' as Error, a.SNidentificacion as Identificacion
      from #table_name# a, SNegocios b
       where a.SNidentificacion = b.SNidentificacion
          and b.Ecodigo = @Ecodigo
 end
 else begin
   -- Validar que el Código no esté duplicado en el archivo
   select @check3 = count(count(1))
      from #table_name#
      group by SNnumero
      having count(1) > 1
   if @check3 > 0 begin
       select 'Numero duplicado en el archivo' as Error, a.SNnumero as Numero
      from #table_name# a
      group by SNnumero
      having count(1) > 1
   end
   else begin
    -- Validar que la identificacion no esté duplicado en el archivo
     select @check1 = count(count(1))
        from #table_name#
        group by SNidentificacion
        having count(1) > 1
     if @check1 > 0 begin
        select 'Numero duplicado en el archivo' as Error, a.SNidentificacion as Identificacion
          from #table_name# a
          group by SNidentificacion
          having count(1) > 1
    end
    else begin
        select @SNcodigo = max(SNcodigo) 
         from SNegocios 
         where Ecodigo = @Ecodigo 
            and SNcodigo <> 9999
     
         select @SNcodigo = isnull(@SNcodigo, 0)

        insert SNegocios (Ecodigo,SNnumero,  SNcodigo, SNnombre, SNidentificacion, SNtiposocio, SNtelefono, SNFax, SNemail, SNtipo, SNvencompras, SNvenventas, SNdireccion, SNFecha, SNcertificado)
                      select @Ecodigo, a.SNnumero, id + @SNcodigo, a.SNnombre, a.SNidentificacion, ltrim(rtrim(a.SNtiposocio)), a.SNtelefono, a.SNFax, a.SNemail, ltrim(rtrim(a.SNtipo)), a.SNvencompras, a.SNvenventas, a.SNdireccion, getDate(), 0
        from #table_name# a

    end -- identificacion duplicado        
   end -- numero duplicado
 end --exista identificacion
end --exista numero	
966	declare @check1 numeric, @check2 numeric, @check3 numeric

-- Validar que no existan duplicados en el archivo
select @check1 = count(count(1))
from #table_name#
group by IACcodigogrupo
having count(1) > 1

if @check1 > 0 begin
 select 'Existen codigos de grupo  duplicados en el sistema' as Error, IACcodigogrupo as Grupo
 from #table_name#
 group by IACcodigogrupo
 having count(1) > 1
end
else begin

 -- Validar si ya existe el grupo en el sistema
  select @check2 = count(1) 
  from #table_name# a, IAContables b
  where a.IACcodigogrupo = b.IACcodigogrupo
     and b.Ecodigo = @Ecodigo
 if @check2 > 0 begin
  select 'Codigo de Grupo ya existe en el sistema' as Error,  a.IACcodigogrupo as Grupo
   from #table_name# a, IAContables b
   where a.IACcodigogrupo = b.IACcodigogrupo
      and b.Ecodigo = @Ecodigo
 end
 else begin
  -- Validar que exista la cuenta de inventario
   if (select count(1) from #table_name#) <> 
     (select count(1) from #table_name# a, CFinanciera b 
         where a.IACinventariof = b.CFformato 
         and b.Ecodigo = @Ecodigo)
   begin

     select 'La cuenta de Inventario no se encuentra registrada en el sistema' as Error, a.IACinventariof as Cuenta_Inventario
        from #table_name# a
        where not exists(
                  select 1 from CFinanciera b
                      where b.CFformato = a.IACinventariof
                         and b.Ecodigo = @Ecodigo)
   end
   else begin
    --Validar que exita la cuenta de Ing. Ajuste 
    if (select count(1) from #table_name#) <> 
       (select count(1) from #table_name# a, CFinanciera b
          where a.IACingajustef = b.CFformato 
             and b.Ecodigo = @Ecodigo) begin
      select 'La cuenta de Ing. Ajuste no se encuentra registrada en el sistema' as Error, a.IACingajustef as Cuenta_Ing_Ajuste
        from #table_name# a
        where not exists(
                  select 1 from CFinanciera b
                      where b.CFformato = a.IACingajustef
                         and b.Ecodigo = @Ecodigo)
    end
    else begin
     --Validar que exita la cuenta de Gasto Ajuste 
     if (select count(1) from #table_name#) <> 
        (select count(1) from #table_name# a, CFinanciera b 
            where a.IACgastoajustef = b.CFformato 
               and b.Ecodigo = @Ecodigo) 
    begin
      select 'La cuenta de Gasto Ajuste no se encuentra registrada en el sistema' as Error, a.IACgastoajustef as Cuenta_Gasto_Ajuste
        from #table_name# a
        where not exists(
                  select 1 from CFinanciera b
                      where b.CFformato = a.IACgastoajustef
                         and b.Ecodigo = @Ecodigo)
     end
     else begin
      --Validar que exita la cuenta de Compra 
      if (select count(1) from #table_name#) <>
         (select count(1) from #table_name# a, CFinanciera b 
            where a.IACcompraf = b.CFformato 
                  and b.Ecodigo = @Ecodigo) begin
       select 'La cuenta de Compra no se encuentra registrada en el sistema' as Error, a.IACcompraf as Cuenta_Compra
        from #table_name# a
        where not exists(
                  select 1 from CFinanciera b
                      where b.CFformato = a.IACcompraf
                         and b.Ecodigo = @Ecodigo)
      end
      else begin
       --Validar que exita la cuenta de Ing Venta 
       if (select count(1) from #table_name#) <> 
         (select count(1) from #table_name# a, CFinanciera b 
            where a.IACingventaf = b.CFformato 
             and b.Ecodigo = @Ecodigo) begin
        select 'La cuenta de Ing. Venta no se encuentra registrada en el sistema' as Error, a.IACingventaf as Cuenta_Ing_Venta  
         from #table_name# a
         where not exists(
                  select 1 from CFinanciera b
                      where b.CFformato = a.IACingventaf
                         and b.Ecodigo = @Ecodigo)
       end
       else begin
        --Validar que exita la cuenta de Costo Venta
        if (select count(1) from #table_name#) <> 
           (select count(1) from #table_name# a, CFinanciera b 
                where a.IACcostoventaf = b.CFformato 
                  and b.Ecodigo = @Ecodigo) begin
          select 'La cuenta de Costo venta  no se encuentra registrada en el sistema' as Error, a.IACcostoventaf as Cuenta_Costo_Venta
           from #table_name# a
           where not exists(
                  select 1 from CFinanciera b
                      where b.CFformato = a.IACcostoventaf
                         and b.Ecodigo = @Ecodigo)
        end
        else begin
         --Validar que exita la cuenta de Transito
         if (select count(1) from #table_name# 
                where IACtransitof is not null 
                   and ltrim(rtrim(IACtransitof)) <> '') <> 
            (select count(1) from #table_name# a, CFinanciera b 
                    where a.IACcostoventaf = b.CFformato 
                      and b.Ecodigo = @Ecodigo  )
         begin
           select 'La cuenta de Transito no se encuentra registrada en el sistema' as Error, a.IACtransitof as Cuenta_Transito
            from #table_name# a
            where not exists(
                  select 1 from CFinanciera b
                      where b.CFformato = a.IACtransitof
                         and b.Ecodigo = @Ecodigo)
         end
         else begin
           --Inserto registros
           insert IAContables (Ecodigo,  IACcodigogrupo, IACdescripcion,
                              IACinventario, IACingajuste, IACgastoajuste, 
                              IACcompra, IACingventa, IACcostoventa, IACtransito)
             select @Ecodigo,  IACcodigogrupo, IACdescripcion, 
                              b.CFcuenta, c.CFcuenta, d.CFcuenta, 
                             e.CFcuenta, f.CFcuenta, g.CFcuenta, h.CFcuenta
                     from #table_name# a, CFinanciera b, CFinanciera c, CFinanciera d, CFinanciera e,  CFinanciera f, CFinanciera g, CFinanciera h
                     where b.CFformato = a.IACinventariof
                        and c.CFformato = a.IACingajustef
                        and d.CFformato = a.IACgastoajustef
                        and e.CFformato = a.IACcompraf
                        and f.CFformato = a.IACingventaf
                        and g.CFformato = a.IACcostoventaf
                        and h.CFformato = a.IACtransitof
                        and b.Ecodigo = @Ecodigo
                        and c.Ecodigo = @Ecodigo
                        and d.Ecodigo = @Ecodigo
                        and e.Ecodigo = @Ecodigo
                        and f.Ecodigo = @Ecodigo
                        and g.Ecodigo = @Ecodigo
                        and h.Ecodigo = @Ecodigo
         end     --cta transito
        end     --cta Costo Venta
       end     --cta Ing. Venta
      end     --cta Compra
     end     --cta gas. Ajuste
    end     --cta ing. Ajuste
   end -- cta inventario
 end --check2
end --check1	
967	insert Unidades(Ecodigo, Ucodigo, Udescripcion, Uequivalencia, Utipo)
      select @Ecodigo, Ucodigo, Udescripcion, Uequivalencia, Utipo
       from #table_name#	
968	declare @check1 numeric, @maxid numeric
-- Verificar si ya existe el dpto
if exists (select 1 from #table_name# a, Departamentos b
  where b.Ecodigo = @Ecodigo
  and a.Deptocodigo = b.Deptocodigo)
begin
  select 'Departamento ya existe en el sistema' as Error, a.Deptocodigo as Departamento
  from #table_name# a, Departamentos b
  where b.Ecodigo = @Ecodigo
  and a.Deptocodigo = b.Deptocodigo
end
else begin
 -- verificar que no existan duplicados
 select @check1 = count(count(1))
   from #table_name#
   group by Deptocodigo
   having count(1) > 1
   if @check1 > 1 begin
        select 'Codigo de Departamento aparece duplicado en el archivo' as Error, Deptocodigo  as Departamento
      from #table_name#
      group by Deptocodigo
      having count(1) > 1
   end
   else begin 
         select @maxid = max(Dcodigo) from Departamentos where Ecodigo = @Ecodigo
          select @maxid = isnull(@maxid, 0)
          insert Departamentos(Ecodigo, Dcodigo, Deptocodigo, Ddescripcion)
      select @Ecodigo, id + @maxid, Deptocodigo, Ddescripcion
       from #table_name#
   end
end	
969	 	
1067	sql impor	sql expo
1068		----script  del ins


set nocount on
/*
Este archivo tiene que incluir la información acumulada de todas las planillas pagadas en un mes y año en particular que le es indicada por el usuario
2. Para el caso de Nación, esta información corresponde a todas aquellas nóminas que corresponden a un mismo mes, esto quiere decir que la fecha fin de la nómina este el mes que estoy solicitando.
4. Este archivo para algunos meses por ende contendrá 3 o 2 bisemanas juntas
5. El formato del archivo debe ser el siguiente:
	Póliza			Alfanumérico	7	Número de póliza Diferente de blancos.Diferente de cero.
	Tipo				Alfanumérico	1	Tipo de planilla	M = mensual ó A = adicional
	Libre				Alfanumérico	1	Blanco
	Año				Numérico		4	Año de la planilla	
	Libre				Alfanumérico	1	Blanco
	Mes				Numérico		2	Mes de la Planilla	
	*Cédula 			Alfanumérico	15	Cédula del trabajador Diferente de blancos.No existan registros duplicados. 
	*No. Asegurado	Alfanumérico	25	Número Asegurado C.C.S.S Según especificaciones que rigen para la C.C.S.S
	Nombre			Alfanumérico	15	Nombre del trabajador	
	Apellido1			Alfanumérico	15	1er Apellido 	
	Apellido2			Alfanumérico	15	2do Apellido	
	Salario			Numérico		10.2	Salario Mensual Diferente de cero si el campo días es mayor que cero.Salarios redondeados los céntimos.(léase 13 caracteres tomando en cuenta el punto decimal)
	Libre				Alfanumérico	1	Blanco	
	Días				Numérico		2	Días Laborados De 0 a 30 días
	Libre				Alfanumérico	1	Blanco	
	Horas			Numérico		3	Horas laboradas Ceros
	*Ocupación		Alfanumérico	5	Ocupación Código según lista de puestos del INS
*/


--- Parametros que deben incorporarse en la tabla RHParametros y deben leerse al iniciar la consulta

declare @f1 datetime, @f2 datetime

select @f1 = min(CPdesde)
   from  CalendarioPagos 
where CPmes = @CPmes
    and CPperiodo = @CPperiodo
    and Ecodigo =@Ecodigo

select  @f2= max(CPhasta)
   from  CalendarioPagos 
where CPmes = @CPmes
    and CPperiodo = @CPperiodo
    and Ecodigo =@Ecodigo


create table #reporte (
	DEid numeric null, 
	poliza varchar(7) null,
	tipoP char(1) null,
    tipoC char(2) null,
    cedula varchar(15) null,
    numseguro varchar(15) null,
    nombre char(15) null, 
    apellido1 char(15) null, 
    apellido2 char(15) null, 
	salario money null,
	dias  int null,
	horas  char(3) null,
    ocupacion char(10) null,
	puesto char(10) null
)


/* Insertar todos los empleados que tuvieron salario en el mes con el salario bruto de HSalarioEmpleado */ 

insert #reporte (tipoC, DEid, cedula,nombre,apellido1, apellido2, numseguro, poliza, tipoP, dias, horas, ocupacion, salario, puesto)
select 
	e.NTIcodigo, 
	h.DEid ,
	e.DEidentificacion,
	e.DEnombre,
	e.DEapellido1,
	e.DEapellido2,
	e.DEidentificacion,
    '0000000',
 	'M',       
    0,
    '001','',
	sum(h.SEsalariobruto),
	null
from CalendarioPagos c (index CalendarioPagos_01), HSalarioEmpleado h, DatosEmpleado e
where c.Ecodigo = @Ecodigo
  and c.CPperiodo = @CPperiodo
  and c.CPmes = @CPmes
  and c.CPid = h.RCNid 
  and h.DEid = e.DEid 
  and e.Ecodigo = @Ecodigo
group by  e.NTIcodigo, h.DEid, e.DEidentificacion, e.DEnombre, e.DEapellido1,e.DEapellido2

insert #reporte (tipoC, DEid, cedula,nombre,apellido1, apellido2, numseguro, poliza, tipoP,dias,horas, ocupacion, salario, puesto)
select 
	e.NTIcodigo, 
	dl.DEid ,
	e.DEidentificacion,
	e.DEnombre,
	e.DEapellido1,
	e.DEapellido2,
	e.DEidentificacion,
    '0000000',
 	'M',       
    0,
    '001','',
	0,
	null
from DLaboralesEmpleado dl, DatosEmpleado e, RHTipoAccion ta
where dl.Ecodigo = @Ecodigo
  and dl.DLfechaaplic between @f1 and @f2
  and ta.RHTid = dl.RHTid
  and ta.RHTcomportam = 2
  and e.DEid = dl.DEid
  and e.Ecodigo = @Ecodigo 
  and not exists(select 1 from #reporte r where r.DEid = e.DEid)

insert #reporte (tipoC, DEid, cedula,nombre,apellido1, apellido2, numseguro, poliza, tipoP,dias,horas, ocupacion, salario, puesto)
select 
	e.NTIcodigo, 
	dl.DEid ,
	e.DEidentificacion,
	e.DEnombre,
	e.DEapellido1,
	e.DEapellido2,
	e.DEidentificacion,
    '0000000',
 	'M',       
    0,
    '001','',
	0,
	null
from DLaboralesEmpleado dl, DatosEmpleado e, RHTipoAccion ta
where dl.Ecodigo = @Ecodigo
  and dl.DLfechaaplic between @f1 and @f2
  and dl.DLfvigencia < @f1 
  and ta.RHTid = dl.RHTid
  and ta.RHTcomportam = 2
  and e.DEid = dl.DEid
  and not exists(select 1 from #reporte r where r.DEid = e.DEid)

update #reporte 
	set puesto = (
		select RHPcodigo 
		from LineaTiempo b 
		where b.DEid = #reporte.DEid 
		  and b.LThasta = (
			select max(lt.LThasta)
			from LineaTiempo lt
			where lt.DEid = #reporte.DEid
			  and @f2 between lt.LTdesde and lt.LThasta)
		)


update #reporte 
	set puesto = (
		select RHPcodigo 
		from LineaTiempo b 
		where b.DEid = #reporte.DEid 
		  and b.LThasta = (
			select max(lt.LThasta)
			from LineaTiempo lt
			where lt.DEid = #reporte.DEid)
		)
where puesto is null

update #reporte
set ocupacion = RHPEcodigo
from RHPuestos r, RHPuestosExternos o
where r.Ecodigo = @Ecodigo
  and r.RHPcodigo = #reporte.puesto
  and o.RHPEid = r.RHPEid

update #reporte
set dias =  (select  isnull(sum(a.PEcantdias),0) 
                          from  HPagosEmpleado a, CalendarioPagos c
	where a.DEid = #reporte.DEid
            and a.PEtiporeg = 0
	  and c.Ecodigo = @Ecodigo
	  and c.CPperiodo =@CPperiodo
	  and c.CPmes = @CPmes
	  and c.CPid = a.RCNid           )


update #reporte
set dias = (case when dias  > 24 then 24 else dias end )


update #reporte
set salario = salario 
	+ isnull(
		(select sum(se.SEsalariobruto)
		     from SalarioEmpleado se, CalendarioPagos c
		  where se.DEid = #reporte.DEid
		      and c.CPid = se.RCNid
		      and c.CPperiodo = @CPperiodo
		      and c.CPmes = @CPmes
		)
		, 0)


/* Actualizar el monto de salario tomando en cuenta las incidencias aplicadas */
update #reporte
set salario = salario + isnull(
	(select sum(ic.ICmontores)
	from 
		HIncidenciasCalculo ic, 
		CalendarioPagos c,
		CIncidentes ci
	where ic.DEid = #reporte.DEid
	  and c.Ecodigo = @Ecodigo
	  and c.CPperiodo = @CPperiodo
	  and c.CPmes = @CPmes
	  and ic.RCNid = c.CPid
	  and ci.CIid = ic.CIid
	  and ci.CInocargas = 0), 0.00)

update #reporte
set salario = salario + isnull(
	(select sum(ic.ICmontores)
	from 
		IncidenciasCalculo ic, 
		CalendarioPagos c,
		CIncidentes ci
	where ic.DEid = #reporte.DEid
	  and c.Ecodigo = @Ecodigo
	  and c.CPperiodo = @CPperiodo
	  and c.CPmes = @CPmes
	  and ic.RCNid = c.CPid
	  and ci.CIid = ic.CIid
	  and ci.CInocargas = 0	), 0.00)

select 
    convert(char(7), poliza)  || 'M'  || ' '  ||
    convert(char(4),@CPperiodo) || ' '  ||
    replicate('0', 2-datalength(ltrim(rtrim(convert(char,@CPmes))))) + ltrim(rtrim(convert(char,@CPmes))) ||
    case tipoC when 'C'  then  '0'+convert(char(14),cedula) else  '1'+convert(char(14),cedula) end  ||
	convert(char(25),numseguro) ||
    convert(char(15),nombre) ||
    convert(char(15),apellido1) ||
    convert(char(15),apellido2) ||
	replicate('0', 13-datalength(ltrim(rtrim(convert(char,salario))))) + ltrim(rtrim(convert(char(13),salario)))  || ' '  ||
	convert(char(2), dias) || ' '  ||
    horas|| ocupacion as salida
from #reporte
order by nombre

drop table #reporte

set nocount off
1069	declare @check1 numeric
declare @check2 numeric
declare @check3 numeric

select @check1 = count(1) 
from #table_name# a, DatosEmpleado b
where 
        	a.cedula = b.DEidentificacion 
	and  b.Ecodigo = @Ecodigo


select @check2 = count(distinct incidencia)
from #table_name# a
group by cedula,  incidencia

select @check3 = count(distinct salario_base) 
from #table_name#
group by cedula


if (@check1 >= 1 and @check2 = 1  and @check3 = 1)
begin

insert RHComisiones
  (CPid, DEid, Ecodigo, DEidentificacion, RHCmontobase, RHCmontocomision)

  select CPid, DEid, @Ecodigo, cedula, salario_base, comision
  from #table_name# a,  DatosEmpleado b, CalendarioPagos c
  where
	a.cedula = b.DEidentificacion 
	and a.nomina = c.Tcodigo
	and a.fecha_pago = c.CPfpago

  insert RHComisionesDetalle
	(CPid, DEid, CIid, CIcodigo, RHCDmontocomision , CFid, Usucodigo, fechaalta)

  select CPid, DEid, CIid, incidencia, comision, CFid, @Usucodigo, getdate()
  from #table_name# a,  DatosEmpleado b, CalendarioPagos c, CIncidentes d
  where
	a.cedula = b.DEidentificacion 
	and a.nomina = c.Tcodigo
	and a.fecha_pago = c.CPfpago
	and a.incidencia = d.CIcodigo
	and d.Ecodigo = @Ecodigo

end

else
begin

  if (@check1 < 1 )
    select 'El empleado no existe', cedula 
    from #table_name# a, DatosEmpleado b
    where 
        	a.cedula != b.DEidentificacion 
	and  b.Ecodigo = @Ecodigo

  if (@check2 != 1)  
    select 'Existen incidencias repetidas'  , incidencia
    from #table_name# a, DatosEmpleado b
    where 
        	a.cedula = b.DEidentificacion 
	and  b.Ecodigo = @Ecodigo
    group by DEidentificacion,  incidencia


  if (@check3 != 1)

select 'Existen salarios base diferentes' , salario_base
from #table_name# a, DatosEmpleado b
where
        	a.cedula = b.DEidentificacion 
	and  b.Ecodigo = @Ecodigo


end	
1070		-- Script de generación de archivo payroll para Puerto Rico

select 
convert(varchar, cp.CPfpago, 112) Fecha, 
substring(e.DEidentificacion, 1, 3) ||  substring(e.DEidentificacion, 5, 2) || substring(e.DEidentificacion, 8, 8) Identificacion, 
substring((select Pvalor from RHParametros rp where rp.Ecodigo = cp.Ecodigo and rp.Pcodigo = 300), 1, 9) NoPatronal, 
substring(e.DEapellido1 || ' ' || e.DEapellido2 || ' ' || e.DEnombre, 1, 35) Nombre,
' ' filler1,
' ' filler2,
' ' filler3,
' ' filler4,
' ' filler5,
' ' filler6,
' ' filler7,
' ' filler8,
' ' filler9,
' ' filler10,
' ' filler11,
' ' filler12,
' ' filler13,
' ' filler14,
' ' filler15,
se.SEsalariobruto + se.SEincidencias - se.SEinorenta Taxable,
se.SEinorenta NonTaxable,
se.SEsalariobruto + se.SEincidencias TotalIncome,
convert(money, 
	coalesce((select sum(DCvalor) from HDeduccionesCalculo dc where dc.RCNid = se.RCNid and dc.DEid = se.DEid), 0.00) + 
	coalesce((select sum(CCvaloremp) from HCargasCalculo cc where cc.RCNid = se.RCNid and cc.DEid = se.DEid), 0.00)+ se.SErenta) Deducciones,
se.SEliquido NetIncome,
se.SEsalariobruto Wages,
0.00 Commisions,
0.00 Allowances,
0.00 Tips,
convert(money, coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo = 'K401'), 0.00)) d401K,
0.00 OtherRetirment,
0.00 Cafeteria,
0.00 Reimbursements,
0.00 CODA,
SErenta Witholding,
0.00 FICA,
convert(money, coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo = 'SS'), 0.00)) SocialSecurity,
convert(money, coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo = 'MD'), 0.00)) Medicare,
convert(money, coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo = 'SINOT'), 0.00)) Disability,
0.00 ChauferInsurance,
0 ChaufferWeeks,
convert(money, coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo not in ('SS', 'MD', 'SINOT', 'K401')), 0.00) + 
coalesce((select sum(DCvalor) from HDeduccionesCalculo dc where dc.RCNid = se.RCNid and dc.DEid = se.DEid), 0.00)) OtherDeductions
from CalendarioPagos cp, HSalarioEmpleado se, DatosEmpleado e
where cp.Ecodigo = @Ecodigo
   and cp.CPperiodo = @CPperiodo
   and cp.CPmes >= @CPmes
   and cp.CPmes <= @CPmes
   and se.RCNid = cp.CPid
   and e.DEid = se.DEid
order by 1, 4
1071		create table #empleados (
	empced     varchar(30) null,
	nopatr       varchar(30) null,
	notarj        varchar(30) null,
	empnomb  varchar(14) null,
	empapel    varchar(20) null,
	empadr1    varchar(35) null,
	empadr2    varchar(35) null,
	empcity      varchar(24) null,
	empstate    varchar(2) null,
	empzip       varchar(10) null,
	empmarital varchar(1) null,
	empchauf   varchar(1) null,
	emphouse  varchar(1) null,
	emplicen    varchar(10) null,
	empsssid   varchar(30) null,
	empretir     money null,
	empsinot    varchar(4) null,
	empagrno   varchar(1) null
)

insert #empleados
select distinct 
	substring(e.DEidentificacion, 1, 3) ||  substring(e.DEidentificacion, 5, 2) || substring(e.DEidentificacion, 8, 8), 
	substring((select Pvalor from RHParametros rp where rp.Ecodigo = cp.Ecodigo and rp.Pcodigo = 300), 1, 9),
	e.DEtarjeta,
	e.DEnombre,
	e.DEapellido1 || ' ' || e.DEapellido2,
	substring(e.DEdireccion, 1, charindex(char(10), e.DEdireccion)- 2),
	substring(e.DEdireccion, charindex(char(10), e.DEdireccion) + 1, 35),
	' ',
	'PR',
	' ',
	case when e.DEcivil = 1 then 'M' else 'S' end,
	'N',
	'N',
	' ',
	(select min(fe.FEidentificacion) from FEmpleado fe where fe.DEid = e.DEid and fe.Pid = 3),
	0.00,
	' ',
	'N'
from CalendarioPagos cp, HSalarioEmpleado se, DatosEmpleado e
where cp.Ecodigo = @Ecodigo
  and cp.CPperiodo = @CPperiodo
  and cp.CPmes >= @CPmes
  and cp.CPmes <= @CPmes
  and se.RCNid = cp.CPid
  and e.DEid = se.DEid

update #empleados
set 
	empcity = substring(empadr2, charindex(char(10), empadr2) + 1, 35),
	empadr2 = substring(empadr2, 1, charindex(char(10), empadr2) - 2)
where charindex(char(10), empadr2) > 1

update #empleados
set empcity = substring(empcity, 1, charindex(char(10), empcity) - 2)
where charindex(char(10), empcity) > 0
1072	 	create table ##empleados (
	empced     varchar(30) null,
	nopatr       varchar(30) null,
	notarj        varchar(30) null,
	empnomb  varchar(14) null,
	empapel    varchar(20) null,
	empadr1    varchar(35) null,
	empadr2    varchar(35) null,
	empcity      varchar(24) null,
	empstate    varchar(2) null,
	empzip       varchar(10) null,
	empmarital varchar(1) null,
	empchauf   varchar(1) null,
	emphouse  varchar(1) null,
	emplicen    varchar(10) null,
	empsssid   varchar(30) null,
	empretir     money null,
	empsinot    varchar(4) null,
	empagrno   varchar(1) null
)

insert ##empleados
select distinct 
	substring(e.DEidentificacion, 1, 3) ||  substring(e.DEidentificacion, 5, 2) || substring(e.DEidentificacion, 8, 8), 
	substring((select Pvalor from RHParametros rp where rp.Ecodigo = cp.Ecodigo and rp.Pcodigo = 300), 1, 9),
	e.DEtarjeta,
	e.DEnombre,
	e.DEapellido1 || ' ' || e.DEapellido2,
	substring(e.DEdireccion, 1, charindex(char(10), e.DEdireccion)- 2),
	substring(e.DEdireccion, charindex(char(10), e.DEdireccion) + 1, 35),
	' ',
	'PR',
	' ',
	case when e.DEcivil = 1 then 'M' else 'S' end,
	'N',
	'N',
	' ',
	(select min(fe.FEidentificacion) from FEmpleado fe where fe.DEid = e.DEid and fe.Pid = 3),
	0.00,
	' ',
	'N'
from CalendarioPagos cp, HSalarioEmpleado se, DatosEmpleado e
where cp.Ecodigo = @Ecodigo
  and cp.CPperiodo = @CPperiodo
  and cp.CPmes = @CPmes
  and se.RCNid = cp.CPid
  and e.DEid = se.DEid

update ##empleados
set 
	empcity = substring(empadr2, charindex(char(10), empadr2) + 1, 35),
	empadr2 = substring(empadr2, 1, charindex(char(10), empadr2) - 2)
where charindex(char(10), empadr2) > 1

update ##empleados
set empcity = substring(empcity, 1, charindex(char(10), empcity) - 2)
where charindex(char(10), empcity) > 0

select 
	empced,
	nopatr,
	notarj,
	empnomb,
	empapel,
	empadr1,
	empadr2,
	empcity,
	empstate,
	empzip,
	empmarital,
	empchauf,
	emphouse,
	emplicen,
	empsssid,
	empretir,
	empsinot,
	empagrno
from ##empleados

drop table ##empleados
1073		-- Script de generación de archivo payroll para Puerto Rico

select 
convert(varchar, cp.CPfpago, 112) Fecha, 
substring(e.DEidentificacion, 1, 3) ||  substring(e.DEidentificacion, 5, 2) || substring(e.DEidentificacion, 8, 8) Identificacion, 
substring((select Pvalor from RHParametros rp where rp.Ecodigo = cp.Ecodigo and rp.Pcodigo = 300), 1, 9) NoPatronal, 
substring(e.DEapellido1 || ' ' || e.DEapellido2 || ' ' || e.DEnombre, 1, 35) Nombre,
' ' filler1,
' ' filler2,
' ' filler3,
' ' filler4,
' ' filler5,
' ' filler6,
' ' filler7,
' ' filler8,
' ' filler9,
' ' filler10,
' ' filler11,
' ' filler12,
' ' filler13,
' ' filler14,
' ' filler15,
se.SEsalariobruto + se.SEincidencias - se.SEinorenta Taxable,
se.SEinorenta NonTaxable,
se.SEsalariobruto + se.SEincidencias TotalIncome,
convert(money, 
	coalesce((select sum(DCvalor) from HDeduccionesCalculo dc where dc.RCNid = se.RCNid and dc.DEid = se.DEid), 0.00) + 
	coalesce((select sum(CCvaloremp) from HCargasCalculo cc where cc.RCNid = se.RCNid and cc.DEid = se.DEid), 0.00)+ se.SErenta) Deducciones,
se.SEliquido NetIncome,
se.SEsalariobruto Wages,
0.00 Commisions,
0.00 Allowances,
0.00 Tips,
convert(money, coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo = 'K401'), 0.00)) d401K,
0.00 OtherRetirment,
0.00 Cafeteria,
0.00 Reimbursements,
0.00 CODA,
SErenta Witholding,
0.00 FICA,
convert(money, coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo = 'SS'), 0.00)) SocialSecurity,
convert(money, coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo = 'MD'), 0.00)) Medicare,
convert(money, coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo = 'SINOT'), 0.00)) Disability,
0.00 ChauferInsurance,
0 ChaufferWeeks,
convert(money, coalesce((select sum(CCvaloremp) from HCargasCalculo cc, DCargas dc, ECargas ec where cc.RCNid = se.RCNid and cc.DEid = se.DEid and dc.DClinea = cc.DClinea and ec.ECid = dc.ECid and ec.ECcodigo not in ('SS', 'MD', 'SINOT', 'K401')), 0.00) + 
coalesce((select sum(DCvalor) from HDeduccionesCalculo dc where dc.RCNid = se.RCNid and dc.DEid = se.DEid), 0.00)) OtherDeductions
from CalendarioPagos cp, HSalarioEmpleado se, DatosEmpleado e
where cp.Ecodigo = @Ecodigo
   and cp.CPperiodo = @CPperiodo
   and cp.CPmes = @CPmes
   and se.RCNid = cp.CPid
   and e.DEid = se.DEid
order by 1, 4
1167		select coalesce(a.DRNnombre,'') + '' + coalesce(a.DRNapellido1,'') + '' + coalesce(a.DRNapellido2,'') as Nombre,
         substring(a.CBcc,1,3) as T_Cuenta,
         coalesce(a.CBcc,'-1') as N_Cuenta,
         1 as Subcuenta,
         1 as T_Saldo,
         a.DRNliquido as Monto,
         b.ERNdescripcion as Detalle,
         a.DRIdentificacion as Ref_1,
         coalesce(a.DRNnombre,'') + '' + coalesce(a.DRNapellido1,'') + '' + coalesce(a.DRNapellido2,'') as Ref_2,
         0 as Cod_Contable
from DRNomina a, ERNomina b
where a.ERNid=@ERNid
and a.ERNid=b.ERNid

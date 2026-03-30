<!--- Válida el tipo de indentificación--->
<cf_dbfunction name="to_char"		args="id"  isNumber="true" returnvariable="lvarID">
<cf_dbfunction name="to_sdateDMY"	args="FechaDesde"  returnvariable="lvarFechaDesde">
<cf_dbfunction name="to_sdateDMY"	args="FechaHasta"  returnvariable="lvarFechaHasta">
<!---Segun lo que se importe puede utilizarse, o tipo de identificacion o tarjeta de marcas--->
<cfquery datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select '<strong>Error:</strong> Tipo de indentificación ' #_CAT# TI #_CAT# ' no es válido.<br/><strong>Datos del registro</strong> : Empleado(' #_CAT# CodigoEmpleado #_CAT# '), Identificación(' #_CAT# TI #_CAT# '), Fecha desde(' #_CAT# #lvarFechaDesde# #_CAT# '), Fecha hasta(' #_CAT# #lvarFechaHasta# #_CAT# ').<br /><strong>Error en el registro Num°:</strong> ' #_CAT# #lvarID#, 1
	from #table_name#
	where not TI in ('I','T')
</cfquery>

<!--- Válida la fecha desde y fecha hasta, que la fd no sea mayor a la fh--->

<cfquery datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select '<strong>Error:</strong> La fecha desde ' #_CAT# #lvarFechaDesde# #_CAT# ' no puede ser mayor a la fecha hasta ' #_CAT# #lvarFechaHasta# #_CAT# '.<br/><strong>Datos del registro</strong> : Empleado(' #_CAT# CodigoEmpleado #_CAT# '), Identificación(' #_CAT# TI #_CAT# '), Fecha desde(' #_CAT# #lvarFechaDesde# #_CAT# '), Fecha hasta(' #_CAT# #lvarFechaHasta# #_CAT# ').<br /><strong>Error en el registro Num°:</strong> ' #_CAT# #lvarID#, 2
	from #table_name#
	where FechaDesde > FechaHasta
</cfquery>

<!--- Valida traslape entre fechas de un mismo empleado --->
<cfquery datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select '<strong>Error:</strong> La fecha desde ' #_CAT# #lvarFechaDesde# #_CAT# ' y/o fecha hasta ' #_CAT# #lvarFechaHasta# #_CAT# 'esta traslapada con un registro a importar.<br/><strong>Datos del registro</strong> : Empleado(' #_CAT# CodigoEmpleado #_CAT# '), Identificación(' #_CAT# TI #_CAT# '), Fecha desde(' #_CAT# #lvarFechaDesde# #_CAT# '), Fecha hasta(' #_CAT# #lvarFechaHasta# #_CAT# ').<br /><strong>Error en el registro Num°:</strong> ' #_CAT# #lvarID#, 3
	from #table_name# tmp1
	where ( select count(1)
	  from #table_name# tmp2
	  where tmp1.TI = tmp2.TI 
	    and tmp1.CodigoEmpleado = tmp2.CodigoEmpleado
		and
		(
		  tmp1.FechaDesde between tmp2.FechaDesde and tmp2.FechaHasta
		  or
		  tmp1.FechaHasta between tmp2.FechaDesde and tmp2.FechaHasta
		  or
		  tmp2.FechaDesde between tmp1.FechaDesde and tmp1.FechaHasta
		  or
		  tmp2.FechaHasta between tmp1.FechaDesde and tmp1.FechaHasta
		)
		and tmp1.id <> tmp2.id
	  ) > 0
</cfquery>

<!--- Valida traslape entre fechas de un mismo empleado --->
<cf_dbfunction name="to_char"	args="count(1)"  isNumber="true" returnvariable="lvarCantidad">
<cfquery datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select '<strong>Error:</strong> El registro esta repetido ' #_CAT# #lvarCantidad# #_CAT# ' veces.<br/><strong>Datos del registro</strong> : Empleado(' #_CAT# CodigoEmpleado #_CAT# '), Identificación(' #_CAT# TI #_CAT# '), Fecha desde(' #_CAT# #lvarFechaDesde# #_CAT# '), Fecha hasta(' #_CAT# #lvarFechaHasta# #_CAT# ').<br /><strong>Error en el registro Num°:</strong> ' #_CAT# #lvarID#, 4
	from #table_name#
	group by TI, CodigoEmpleado, #lvarFechaDesde#, #lvarFechaHasta#, #lvarID#
	having count(1) > 1
</cfquery>

<!--- Valida el codigo de accion --->
<cfquery datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select '<strong>Error:</strong> El código de accion ' #_CAT# CodigoAccion #_CAT# ' no existe para esta empresa con un tipo de comportamiento de #lvarComportamiento#. O el usuario no posee permisos.<br/><strong>Datos del registro</strong> : Empleado(' #_CAT# CodigoEmpleado #_CAT# '), Identificación(' #_CAT# TI #_CAT# '), Fecha desde(' #_CAT# #lvarFechaDesde# #_CAT# '), Fecha hasta(' #_CAT# #lvarFechaHasta# #_CAT# ').<br /><strong>Error en el registro Num°:</strong> ' #_CAT# #lvarID#, 5
	from #table_name# tmp
	where not exists(
		select 1
		from RHTipoAccion ta
		left outer join RHUsuarioTipoAccion tb
		on tb.RHTid=ta.RHTid
		where ta.Ecodigo = #session.Ecodigo#
		  and ta.RHTcodigo = tmp.CodigoAccion
		  and ta.RHTcomportam = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.comportamiento#">
		  and coalesce(tb.Usucodigo,#session.Usucodigo#) = #session.Usucodigo#
	)
</cfquery>

<!--- Valida el codigo de RHItiporiesgo --->
<cfquery name="rsTipoRiesgo" datasource="sifcontrol">
	select RHIcodigo
	from RHItiporiesgo
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select '<strong>Error:</strong> El código de Tipo de Riesgo '  #_CAT# cast(TipoRiesgo as varchar) #_CAT#  ' no existe en el catalogo.<br /><strong>Error en el registro Num°:</strong>'  #_CAT# #lvarID#, 8
	from #table_name# tmp
	where TipoRiesgo not in (#valueList(rsTipoRiesgo.RHIcodigo)#)
</cfquery>
<!--- Valida el codigo de Consecuencia --->
<cfquery name="rsConsecuencia" datasource="sifcontrol">
	select RHIcodigo
	from RHIConsecuencia
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select '<strong>Error:</strong> El código de Consecuencia '  #_CAT# cast(Consecuencia as varchar) #_CAT#  ' no existe en el catalogo.<br /><strong>Error en el registro Num°:</strong>'  #_CAT# #lvarID#, 9
	from #table_name# tmp
	where Consecuencia not in (#valueList(rsConsecuencia.RHIcodigo)#)
</cfquery>
<!--- Valida el codigo de ControlIncapacidad --->
<cfquery name="rsControlIncapacidad" datasource="sifcontrol">
	select RHIcodigo
	from RHIControlIncapacidad
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select '<strong>Error:</strong> El código de Control de Incapacidad '  #_CAT# cast(ControlIncapacidad as varchar) #_CAT#  ' no existe en el catalogo.<br /><strong>Error en el registro Num°:</strong>'  #_CAT# #lvarID#, 10
	from #table_name# tmp
	where ControlIncapacidad not in (#valueList(rsControlIncapacidad.RHIcodigo)#)
</cfquery>

<!--- Valiada el código del empleado 
	  No se hace con un union ya que el campo Mensaje es de tipo text y este no permite hacer union
--->
<cfquery datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select '<strong>Error:</strong> El empleado con el código ' #_CAT# CodigoEmpleado #_CAT# ' y tipo de indentificación ' #_CAT# TI #_CAT# ' no existe ó no ha sido incluido en la linea del tiempo.<br/><strong>Datos del registro</strong> : Empleado(' #_CAT# CodigoEmpleado #_CAT# '), Identificación(' #_CAT# TI #_CAT# '), Fecha desde(' #_CAT# #lvarFechaDesde# #_CAT# '), Fecha hasta(' #_CAT# #lvarFechaHasta# #_CAT# ').<br /><strong>Error en el registro Num°:</strong> ' #_CAT# #lvarID#, 6
	from #table_name# tmp
	where not exists(
		select 1
		from DatosEmpleado de
			inner join LineaTiempo lt
				on lt.DEid = de.DEid
				  and tmp.FechaDesde between lt.LTdesde and lt.LThasta
		where de.Ecodigo = #session.Ecodigo#
		  and de.DEidentificacion = tmp.CodigoEmpleado
	)
	and tmp.TI = 'I'
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select '<strong>Error:</strong> El empleado con el código ' #_CAT# CodigoEmpleado #_CAT# ' y tipo de indentificación ' #_CAT# TI #_CAT# ' no existe ó no ha sido incluido en la linea del tiempo.<br/><strong>Datos del registro</strong> : Empleado(' #_CAT# CodigoEmpleado #_CAT# '), Identificación(' #_CAT# TI #_CAT# '), Fecha desde(' #_CAT# #lvarFechaDesde# #_CAT# '), Fecha hasta(' #_CAT# #lvarFechaHasta# #_CAT# ').<br /><strong>Error en el registro Num°:</strong> ' #_CAT# #lvarID#, 6
	from #table_name# tmp
	where not exists(
		select 1
		from DatosEmpleado de
			inner join LineaTiempo lt
				on lt.DEid = de.DEid
				  and tmp.FechaDesde between lt.LTdesde and lt.LThasta
		where de.Ecodigo = #session.Ecodigo#
		  and de.DEtarjeta = tmp.CodigoEmpleado
	)
	and tmp.TI = 'T'
</cfquery>


<!--- Valida datos existentes y traslape entre los datos a importar
      No se hace con un union ya que el campo Mensaje es de tipo text y este no permite hacer union
--->
<cfquery datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select '<strong>Error:</strong> El registro traslapa su fecha desde ' #_CAT# #lvarFechaDesde# #_CAT# ' y/o fecha hasta ' #_CAT# #lvarFechaHasta# #_CAT# ' con un registro pendiente de aplicar.<br/><strong>Datos del registro</strong> : Empleado(' #_CAT# CodigoEmpleado #_CAT# '), Identificación(' #_CAT# TI #_CAT# '), Fecha desde(' #_CAT# #lvarFechaDesde# #_CAT# '), Fecha hasta(' #_CAT# #lvarFechaHasta# #_CAT# ').<br /><strong>Error en el registro Num°:</strong> ' #_CAT# #lvarID#, 8
	from #table_name# tmp
		inner join DatosEmpleado de
		  on de.Ecodigo = #session.Ecodigo#
		  and de.DEidentificacion = tmp.CodigoEmpleado
		inner join RHTipoAccion ta
		  on ta.Ecodigo = #session.Ecodigo#
		  and ta.RHTcodigo = tmp.CodigoAccion
		  and ta.RHTcomportam = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.comportamiento#">
	where ( select count(1)
	  from RHAcciones a
	  where a.DEid = de.DEid 
	  	and a.RHTid = ta.RHTid
		and
		( 
		  tmp.FechaDesde between a.DLfvigencia and a.DLffin
		  or
		  tmp.FechaHasta between a.DLfvigencia and a.DLffin
		  or
		  a.DLfvigencia between tmp.FechaDesde and tmp.FechaHasta
		  or
		  a.DLffin between tmp.FechaDesde and tmp.FechaHasta
		)
	    ) > 0
	  	and tmp.TI = 'I'
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select '<strong>Error:</strong> El registro traslapa su fecha desde ' #_CAT# #lvarFechaDesde# #_CAT# ' y/o fecha hasta ' #_CAT# #lvarFechaHasta# #_CAT# ' con un registro pendiente de aplicar.<br/><strong>Datos del registro</strong> : Empleado(' #_CAT# CodigoEmpleado #_CAT# '), Identificación(' #_CAT# TI #_CAT# '), Fecha desde(' #_CAT# #lvarFechaDesde# #_CAT# '), Fecha hasta(' #_CAT# #lvarFechaHasta# #_CAT# ').<br /><strong>Error en el registro Num°:</strong> ' #_CAT# #lvarID#, 8
	from #table_name# tmp
		inner join DatosEmpleado de
		  on de.Ecodigo = #session.Ecodigo#
		  and de.DEtarjeta = tmp.CodigoEmpleado
		inner join RHTipoAccion ta
		  on ta.Ecodigo = #session.Ecodigo#
		  and ta.RHTcodigo = tmp.CodigoAccion
		  and ta.RHTcomportam = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.comportamiento#">
	where ( select count(1)
	  from RHAcciones a
	  where a.DEid = de.DEid 
	  	and a.RHTid = ta.RHTid
		and
		( 
		  tmp.FechaDesde between a.DLfvigencia and a.DLffin
		  or
		  tmp.FechaHasta between a.DLfvigencia and a.DLffin
		  or
		  a.DLfvigencia between tmp.FechaDesde and tmp.FechaHasta
		  or
		  a.DLffin between tmp.FechaDesde and tmp.FechaHasta
		)
	    ) > 0
	  	and tmp.TI = 'T'
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select '<strong>Error:</strong> El registro traslapa su fecha desde ' #_CAT# #lvarFechaDesde# #_CAT# ' y/o fecha hasta ' #_CAT# #lvarFechaHasta# #_CAT# ' con una accion(' #_CAT# (
		select RHTcodigo #_CAT# ' - ' #_CAT# RHTdesc
		  from RHSaldoPagosExceso speS
			inner join DLaboralesEmpleado le
				on le.DLlinea = speS.DLlinea
			inner join RHTipoAccion ta
				on ta.RHTid = le.RHTid
		  where speS.DEid = de.DEid 
			and speS.RHSPEanulado = 0
			and
			( 
			  tmp.FechaDesde between speS.RHSPEfdesde and speS.RHSPEfhasta
			  or
			  tmp.FechaHasta between speS.RHSPEfdesde and speS.RHSPEfhasta
			  or
			  speS.RHSPEfdesde between tmp.FechaDesde and tmp.FechaHasta
			  or
			  speS.RHSPEfhasta between tmp.FechaDesde and tmp.FechaHasta
			)) #_CAT# ') ya aplicada.<br/><strong>Datos del registro</strong> : Empleado(' #_CAT# CodigoEmpleado #_CAT# '), Identificación(' #_CAT# TI #_CAT# '), Fecha desde(' #_CAT# #lvarFechaDesde# #_CAT# '), Fecha hasta(' #_CAT# #lvarFechaHasta# #_CAT# ').<br /><strong>Error en el registro Num°:</strong> ' #_CAT# #lvarID#, 9
	from #table_name# tmp
		inner join DatosEmpleado de
		  on de.Ecodigo = #session.Ecodigo#
		  and de.DEidentificacion = tmp.CodigoEmpleado
	where ( select count(1)
	  from RHSaldoPagosExceso spe
	  where spe.DEid = de.DEid
	  	and spe.RHSPEanulado = 0
		and
		( 
		  tmp.FechaDesde between spe.RHSPEfdesde and spe.RHSPEfhasta
		  or
		  tmp.FechaHasta between spe.RHSPEfdesde and spe.RHSPEfhasta
		  or
		  spe.RHSPEfdesde between tmp.FechaDesde and tmp.FechaHasta
		  or
		  spe.RHSPEfhasta between tmp.FechaDesde and tmp.FechaHasta
		)
	    ) > 0
	  	and tmp.TI = 'I'
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select '<strong>Error:</strong> El registro traslapa su fecha desde ' #_CAT# #lvarFechaDesde# #_CAT# ' y/o fecha hasta ' #_CAT# #lvarFechaHasta# #_CAT# ' con una accion(' #_CAT# (select RHTcodigo #_CAT# ' - ' #_CAT# RHTdesc
		  from RHSaldoPagosExceso speS
			inner join DLaboralesEmpleado le
				on le.DLlinea = speS.DLlinea
			inner join RHTipoAccion ta
				on ta.RHTid = le.RHTid
		  where speS.DEid = de.DEid 
			and speS.RHSPEanulado = 0
			and
			( 
			  tmp.FechaDesde between speS.RHSPEfdesde and speS.RHSPEfhasta
			  or
			  tmp.FechaHasta between speS.RHSPEfdesde and speS.RHSPEfhasta
			  or
			  speS.RHSPEfdesde between tmp.FechaDesde and tmp.FechaHasta
			  or
			  speS.RHSPEfhasta between tmp.FechaDesde and tmp.FechaHasta
			)) #_CAT# ') ya aplicada.<br/><strong>Datos del registro</strong> : Empleado(' #_CAT# CodigoEmpleado #_CAT# '), Identificación(' #_CAT# TI #_CAT# '), Fecha desde(' #_CAT# #lvarFechaDesde# #_CAT# '), Fecha hasta(' #_CAT# #lvarFechaHasta# #_CAT# ').<br /><strong>Error en el registro Num°:</strong> ' #_CAT# #lvarID#, 9
	from #table_name# tmp
		inner join DatosEmpleado de
		  on de.Ecodigo = #session.Ecodigo#
		  and de.DEtarjeta = tmp.CodigoEmpleado
	where ( select count(1)
	  from RHSaldoPagosExceso spe
	  where spe.DEid = de.DEid 
	  	and spe.RHSPEanulado = 0
		and
		( 
		  tmp.FechaDesde between spe.RHSPEfdesde and spe.RHSPEfhasta
		  or
		  tmp.FechaHasta between spe.RHSPEfdesde and spe.RHSPEfhasta
		  or
		  spe.RHSPEfdesde between tmp.FechaDesde and tmp.FechaHasta
		  or
		  spe.RHSPEfhasta between tmp.FechaDesde and tmp.FechaHasta
		)
	    ) > 0
	  	and tmp.TI = 'T'
</cfquery>

<!--- Válida que la cantidad de vacaciones sea mayor a 0 --->
<cf_dbfunction name="to_char"	args="DiasIncapacidades"  isNumber="true" returnvariable="lvarDiasIncapacidades">
<cfquery datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select '<strong>Error:</strong> La cantidad de Incapacidades debe de ser mayor a 0. Incapacidades actuales: ' #_CAT# #lvarDiasIncapacidades# #_CAT# '.<br/><strong>Datos del registro</strong> : Empleado(' #_CAT# CodigoEmpleado #_CAT# '), Identificación(' #_CAT# TI #_CAT# '), Fecha desde(' #_CAT# #lvarFechaDesde# #_CAT# '), Fecha hasta(' #_CAT# #lvarFechaHasta# #_CAT# ').<br /><strong>Error en el registro Num°:</strong> ' #_CAT# #lvarID#, 10
	from #table_name#
	where DiasIncapacidades <= 0
</cfquery>
<cfquery name="err" datasource="#session.dsn#">
	select ErrorNum, Mensaje
	from #ERRORES_TEMP#
	order by ErrorNum
</cfquery>

<cfif err.recordcount eq 0>

	<!--- Averiguar si hay que utilizar la tabla salarial --->
	<cfquery name="rsTipoTabla" datasource="#Session.DSN#">
		select CSusatabla
		from ComponentesSalariales
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and CSsalariobase = 1
	</cfquery>
	<cfif rsTipoTabla.recordCount GT 0>
		<cfset usaEstructuraSalarial = rsTipoTabla.CSusatabla>
	<cfelse>
		<cfset usaEstructuraSalarial = 0>
	</cfif>
	<cfquery name="rsIncapacidadesLineas" datasource="#session.DSN#">
		select de.DEid, tmp.TI, tmp.FechaDesde, tmp.FechaHasta, tmp.Observaciones, tmp.DiasIncapacidades, ta.RHTespecial, 
			ta.RHTid, coalesce(ta.RHTporcPlazaCHK, 0) as RHTporcPlazaCHK, ta.RHTcsalariofijo, coalesce(ta.RHTporcsal,100) as  RHTporcsal, 
			coalesce(ta.RHTporc, 100) as RHTporc,
			tmp.TipoRiesgo, tmp.Consecuencia, tmp.ControlIncapacidad, tmp.FolioIncapacidad
		from #table_name# tmp
			inner join DatosEmpleado de
				on de.Ecodigo = #session.Ecodigo#
		  		  and de.DEidentificacion = tmp.CodigoEmpleado
			inner join RHTipoAccion ta
				on ta.Ecodigo = #session.Ecodigo#
				  and ta.RHTcodigo = tmp.CodigoAccion
		where tmp.TI = 'I'
		union
		select de.DEid, tmp.TI, tmp.FechaDesde, tmp.FechaHasta, tmp.Observaciones, tmp.DiasIncapacidades, ta.RHTespecial, 
			ta.RHTid, coalesce(ta.RHTporcPlazaCHK, 0) as RHTporcPlazaCHK, ta.RHTcsalariofijo, coalesce(ta.RHTporcsal,100) as  RHTporcsal, 
			coalesce(ta.RHTporc, 100) as RHTporc,
			tmp.TipoRiesgo, tmp.Consecuencia, tmp.ControlIncapacidad, tmp.FolioIncapacidad
		from #table_name# tmp
			inner join DatosEmpleado de
				on de.Ecodigo = #session.Ecodigo#
		  		  and de.DEtarjeta = tmp.CodigoEmpleado
			inner join RHTipoAccion ta
				on ta.Ecodigo = #session.Ecodigo#
				  and ta.RHTcodigo = tmp.CodigoAccion
		where tmp.TI = 'T'
	</cfquery>
	
	<cftransaction>
		<cfoutput query="rsIncapacidadesLineas">
			<cfset fnProcesoGuardar(
				DEid = rsIncapacidadesLineas.DEid,
				RHTid = rsIncapacidadesLineas.RHTid,
				FechaDesde = rsIncapacidadesLineas.FechaDesde,
				FechaHasta = rsIncapacidadesLineas.FechaHasta,
				DiasVacaciones = rsIncapacidadesLineas.DiasIncapacidades,
				Observaciones = rsIncapacidadesLineas.Observaciones,
				RHTespecial = rsIncapacidadesLineas.RHTespecial,
				RHTporcPlazaCHK = rsIncapacidadesLineas.RHTporcPlazaCHK,
				RHTcsalariofijo = rsIncapacidadesLineas.RHTcsalariofijo,
				RHTporcsal = rsIncapacidadesLineas.RHTporcsal,
				RHTporc = rsIncapacidadesLineas.RHTporc,
				usaEstructuraSalarial = usaEstructuraSalarial,
				RHItiporiesgo = rsIncapacidadesLineas.TipoRiesgo,
				RHIconsecuencia = rsIncapacidadesLineas.Consecuencia,
				RHIcontrolincapacidad = rsIncapacidadesLineas.ControlIncapacidad,
				RHfolio = rsIncapacidadesLineas.FolioIncapacidad
			)>
		</cfoutput>
	</cftransaction>
</cfif>
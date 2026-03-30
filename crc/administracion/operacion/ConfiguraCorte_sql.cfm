<cfparam name="modo" default="ALTA">

<cfset LvarPagina = "ConfiguraCorte.cfm">

<cfset AfectarA = ListToArray(form.AfectarA,',',false,false)>

<cftransaction>

<!--- Obtener el día condicional para adelantar el corte --->
<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
<cfset val = objParams.GetParametroInfo('30001455')>
<cfif val.codigo eq ''><cfthrow message="El parametro 30001455 no esta definido"></cfif>
<cfset adelantarSi = NumberFormat(val.valor,'0')>

<cfset afectado = "">

<cfloop array="#AfectarA#" index="i" item="itm">
	<cfset tipo = ListToArray(AfectarA[i],'_')>
	<cfset newVal = form["f_#tipo[2]#"]>
	<cfset oldVal = form["h_#tipo[2]#"]>

	<!--- Actualizar nuevo día de corte en parametros--->
	<cfquery datasource="#Session.DSN#">
		update CRCParametros set
			Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#newVal#">,
			Usumodif = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
			updatedat = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
		where Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tipo[2]#">
	</cfquery>

	<cfset diff = newVal - oldVal>

	<!--- Obtener informacion de los cortes existentes futuros--->
	<cfquery name="q_Par" datasource="#session.dsn#">
		select * from CRCCortes where Tipo = '#Tipo[1]#' and isNull(Status,0) = 0 and ecodigo = #session.ecodigo# order by fechafin asc;
	</cfquery>

	<!--- Si no existen cortes futuros, no continua la ejecucion del ciclo y pasa a la siguiente iteracion--->
	<cfif q_Par.recordCount eq 0>
		<cfcontinue />
	</cfif>

	<!--- Cantidad de cortes nuevos a generar--->
	<cfset numCortes = q_Par.recordCount - 1>

	<!--- Obtener informacion del corte actual--->
	<cfquery name="q_lastP" datasource="#session.dsn#">
		select top(1) id, fechafin, tipo from CRCCortes where Tipo = '#Tipo[1]#' and isNull(Status,0) = 0 and ecodigo = #session.ecodigo# order by fechafin asc;
	</cfquery>

	<!--- Si el dia de la fecha final del corte, no coincide con el valor del día de corte viejo, intenta con el corte siguiente a ese
		y vuelve a evaluar. Si coincide, toma este segundo registro como el "primero" y recalcula los cortes a partir de este.
		Esto por las 2 quincenas de vales para asegurar que al cambiar la fecha de corte, se afecte la quincena correspondiente.
		En caso de no coincidir en ningun caso, no continua la ejecucion del ciclo y pasa a la siguiente iteracion--->	
	<cfif DateFormat(q_lastP.fechafin,"d") neq oldVal && DateFormat(q_lastP.fechafin,"d") neq (oldVal - 1) && trim(q_lastP.tipo) eq 'D'>
		<cfquery name="q_lastP" datasource="#session.dsn#">
			select top(2) id, fechafin, tipo from CRCCortes where Tipo = '#Tipo[1]#' and isNull(Status,0) = 0 and ecodigo = #session.ecodigo# order by fechafin asc;
		</cfquery>
		<cfset q_lastP = queryGetRow(q_lastP, 2)>
		<cfif DateFormat(q_lastP.fechafin,"d") neq oldVal && DateFormat(q_lastP.fechafin,"d") neq (oldVal - 1) && trim(q_lastP.tipo) eq 'D'>
			<cfcontinue />
		</cfif>
		<cfset numCortes = numCortes - 1>
	</cfif>
	<cfset q_last = q_lastP>
	<!--- Eliminar los cortes a futuro--->
	<cfquery datasource="#session.dsn#">
		delete from CRCCortes where Tipo = '#Tipo[1]#' and isNull(Status,0) = 0 and fechainicio > '#q_last.fechafin#' and ecodigo = #session.ecodigo#;
	</cfquery>

	<!--- Generar la nueva fecha de corte--->
	<cfset newFin = "#DateFormat(q_last.fechafin,'yyyy-mm')#-#newVal#">
	<cfquery name="q_nuevaFecha" datasource="#session.dsn#">
		select '#newFin#' as newFin, DATEPART(dw, '#newFin#') as weekDay from CRCCortes where id = #q_last.id# and isNull(Status,0) = 0 and ecodigo = #session.ecodigo#;
	</cfquery>

	<cfif DateCompare(q_nuevaFecha.newFin, Now()) lt 0>
		<cfthrow message="No se puede recalendarizar el corte tipo [#Tipo[1]#] debido a que 
							su nueva fecha final [#DateFormat(q_nuevaFecha.newFin,'dd/mm/yyyy')#] 
							es anterior a la fecha actual [#DateFormat(Now(),'dd/mm/yyyy')#] - Los cambios en los cortes no serán aplicados">
	</cfif>

	<!--- Adelantar corte si es necesario segun el parametro 30001455 --->
	<cfif q_nuevaFecha.weekDay eq adelantarSi><cfset newFin = "#DateFormat(q_last.fechafin,'yyyy-mm')#-#newVal - 1#"></cfif>

	<!--- Actualizar nueva fecha de corte en registro actual --->
	<cfquery datasource="#session.dsn#">
		update  CRCCortes set fechafin = '#newFin#' where id = #q_last.id# and isNull(Status,0) = 0 and ecodigo = #session.ecodigo#;
	</cfquery>

	<!--- Generar nuevos cortes A partir de la ultima fecha--->
	<cfquery name="q_last" datasource="#session.dsn#">
		select top(1) id,fechafin, Dateadd(day,1,fechafin) as nuevoInicio from CRCCortes where id = #q_last.id#;
	</cfquery>
	
	<cfset CRCCorteFactory = createObject( "component","crc.Componentes.cortes.CRCCorteFactory")> 
  	<cfset CRCCorte = CRCCorteFactory.obtenerCorte(TipoProducto="#tipo[1]#",conexion="#session.dsn#", Ecodigo=session.ECodigo)>
	<cfset cortes = CRCCorte.GetCorteCodigos(fecha=q_last.nuevoInicio,parcialidades=numCortes)>
	
	<cfif not ListContains(afectado,Tipo[1])>	
		<!--- Obtener datos de los nuevos cortes--->
		<cfquery name="q_newPar" datasource="#session.dsn#">
			select * from CRCCortes where Tipo = '#Tipo[1]#' and isNull(Status,0) = 0 and ecodigo = #session.ecodigo#;
		</cfquery>
		<!--- Actualizar Fecha Inicio y Fin SV del corte actual --->
		<cfif q_newPar.RecordCount ge 3>
			<cfset newSV = queryGetRow(q_newPar,3)>
			<cfquery datasource="#session.dsn#">
				<!--- update  CRCCortes set fechafinSV = '#newSV.FechaFin#', FechaInicioSV='#newSV.FechaInicio#' where id = #q_last.id#; --->
				update  CRCCortes set fechafinSV = dateAdd(day, #diff#, fechafinSV), FechaInicioSV = dateAdd(day, #diff#, FechaInicioSV) where id = #q_last.id#; 
			</cfquery> 
		</cfif>
		
		<!--- Actualizar Fecha Inicio y Fin SV del corte cerrado --->
		<cfif q_newPar.RecordCount ge 2>
			<cfset newSV = queryGetRow(q_newPar,2)>
			<cfquery datasource="#session.dsn#">
				update  CRCCortes set FechaInicioSV = dateAdd(day, #diff#, FechaInicioSV), FechafinSV=dateAdd(day, #diff#, FechafinSV) where status=1 and tipo='#Tipo[1]#';
			</cfquery> 
			<!--- Verificar que el primer corte creado automaticamente no deje espacios contra la fecha fin el corte anterior a el --->
			<!--- <cfif q_last.nuevoInicio neq newSV.FechaInicio>
				<cfquery datasource="#session.dsn#">
					update CRCCortes set fechaInicio = '#q_last.nuevoInicio#' where id = #newSV.id#;
				</cfquery>
			</cfif> --->
		</cfif>

		<!--- Actualizar Fecha Inicio y Fin SV del corte vencido --->
		<cfif q_newPar.RecordCount ge 1>
			<cfset newSV = queryGetRow(q_newPar,1)>
			<cfquery datasource="#session.dsn#">
				update  CRCCortes set fechafinSV = dateAdd(day, #diff#, FechafinSV) where status=2 and tipo='#Tipo[1]#';
			</cfquery>
		</cfif>

		<cfset afectado = listAppend(afectado, Tipo[1])>
	</cfif>
</cfloop>
		
	

</cftransaction>


<!---VALIDADOR--->

<form action="<cfoutput>#LvarPagina#</cfoutput>" method="post" name="sql"> </form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

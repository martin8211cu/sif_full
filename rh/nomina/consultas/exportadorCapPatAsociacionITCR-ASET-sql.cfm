
<cfparam name="url.periodo" 		type="integer" 	default="-1">	<!----Periodo--->
<cfparam name="url.mes" 			type="integer"	default="-1">	<!----Mes--->
<cfparam name="url.calendariopago" 	type="string" 	default="-1">	<!---Calendario de pago---->
<cfparam name="url.historico" 		type="string" 	default="0">	<!---Son nominas historicas---->

<cf_dbfunction name="OP_concat" returnvariable="CAT" >

<cf_dbtemp name="TEMP_ASO_V1" returnvariable="ASOCIA" datasource="#session.dsn#">
    <cf_dbtempcol name="Codigo"  		type="varchar(10)" mandatory="no">
    <cf_dbtempcol name="Identificacion" type="varchar(20)" mandatory="no">
    <cf_dbtempcol name="Nombre" 		type="varchar(60)" mandatory="no">
    <cf_dbtempcol name="Monto"  		type="money" mandatory="no">
</cf_dbtemp>


<!---Cargas Capitalizacion Empleado exportador ASET--->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
                ecodigo="#session.Ecodigo#" pvalor="2561" default="-1" returnvariable="lvarCapEmpASET"/>

<!---Cargas Capitalizacion Patrono exportador ASET--->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
                ecodigo="#session.Ecodigo#" pvalor="2562" default="-1" returnvariable="lvarCapPatASET"/>


<!---Deducciones usadas exportador ASET--->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
                ecodigo="#session.Ecodigo#" pvalor="2563" default="-1" returnvariable="lvarDedEmpASET"/>


<!----Variables de traduccion---->
<cfinvoke Key="MSG_NoHayDatosParaLosFiltrosSeleccionados" Default="No hay datos para los filtros seleccionados" returnvariable="MSG_NoHayDatosParaLosFiltrosSeleccionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NoSeHaDefinidoElFormatoParaLaGeneracionDelArchivo" Default="No se ha definido el formato para la generación del archivo" returnvariable="MSG_NoSeHaDefinidoElFormatoParaLaGeneracionDelArchivo" component="sif.Componentes.Translate" method="Translate"/>
<cfset prefijo = ''>
<cfif isdefined("url.historico") and url.historico EQ 1>
	<cfset prefijo = 'H'>
</cfif>
<!----Verificar si existe calendario de pago---->
<cfquery name="rsExisteCalendario" datasource="#session.DSN#">
	select 1 from CalendarioPagos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("url.periodo") and url.periodo NEQ -1 and isdefined("url.mes") and url.mes NEQ -1>
			and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
			and CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
		<cfelseif isdefined("url.calendariopago") and url.calendariopago NEQ -1>
			and CPid in  (<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.calendariopago#" list="true">)
		</cfif>
</cfquery>

<cfif rsExisteCalendario.RecordCount EQ 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		select '#MSG_NoHayDatosParaLosFiltrosSeleccionados#' as Error
		from dual
	</cfquery>
<cfelse>
	<cfquery datasource="#session.DSN#">					
		<!---Cargas Patrono--->
		insert into #ASOCIA# (Codigo,Identificacion,Nombre, Monto)
		select ltrim(rtrim(dc.DCcodigo)),ltrim(rtrim(e.DEidentificacion))
			, ltrim(rtrim(e.DEapellido1)) #CAT# ' ' #CAT# ltrim(rtrim(e.DEapellido2)) #CAT# ' ' #CAT# ltrim(rtrim(e.DEnombre)) as Nombre
			,sum(coalesce(b.CCvalorpat,0)) as Monto
		from HSalarioEmpleado a
			inner join HCargasCalculo b
				on a.RCNid = b.RCNid
				and a.DEid = b.DEid
			inner join DCargas dc
				on b.DClinea=dc.DClinea
				and dc.DCcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lvarCapPatASET#" list="true">)
			inner join CalendarioPagos d
				on a.RCNid = d.CPid
				<cfif isdefined("url.periodo") and url.periodo NEQ -1 and isdefined("url.mes") and url.mes NEQ -1>
					and d.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
					and d.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
				<cfelseif isdefined("url.calendariopago") and url.calendariopago NEQ -1>
					and d.CPid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.calendariopago#" list="true">)
				</cfif>
			inner join DatosEmpleado e
				on a.DEid = e.DEid		
			group by e.DEidentificacion,ltrim(rtrim(e.DEapellido1)) #CAT# ' ' #CAT# ltrim(rtrim(e.DEapellido2)) #CAT# ' ' #CAT# ltrim(rtrim(e.DEnombre)), dc.DCcodigo
	</cfquery>
 
    <cf_dbfunction name="string_part" args="rtrim(Codigo)|1|6" 	returnvariable="LvarReferencia"  delimiters="|">
            <cf_dbfunction name="length"      args="#LvarReferencia#"  		returnvariable="LvarReferenciaL" delimiters="|" >
                    <cf_dbfunction name="sRepeat"     args="' '|6-coalesce(#LvarReferenciaL#,0)" 	returnvariable="LvarReferenciaS" delimiters="|">
                    
    <cf_dbfunction name="string_part" args="rtrim(Identificacion)|1|15" 	returnvariable="LvarIdentificacion"  delimiters="|">
            <cf_dbfunction name="length"      args="#LvarIdentificacion#"  		returnvariable="LvarIdentificacionL" delimiters="|" >
                    <cf_dbfunction name="sRepeat"     args="' '|15-coalesce(#LvarIdentificacionL#,0)" 	returnvariable="LvarIdentificacionS" delimiters="|">
    
    <cf_dbfunction name="string_part" args="rtrim(Nombre)|1|45" 	returnvariable="LvarNombre"  delimiters="|">
            <cf_dbfunction name="length"      args="#LvarNombre#" returnvariable="LvarNombreL" delimiters="|" >
                    <cf_dbfunction name="sRepeat"     args="' '|45-coalesce(#LvarNombreL#,0)" 	returnvariable="LvarNombreS" delimiters="|">
    
    <cf_dbfunction name="to_char" args="Monto" returnvariable="LvarMonto">
        <cf_dbfunction name="string_part" args="rtrim(#LvarMonto#)|1|10" 	returnvariable="LvarMontoStr"  delimiters="|">
            <cf_dbfunction name="length"      args="#LvarMontoStr#"  		returnvariable="LvarMontoStrL" delimiters="|" >
                    <cf_dbfunction name="sRepeat"     args="' '|10-coalesce(#LvarMontoStrL#,0)" 	returnvariable="LvarMontoStrLS" delimiters="|">
                    
    
    <cfquery name="ERR" datasource="#session.DSN#">
            Select    #preservesinglequotes(LvarIdentificacionS)# #CAT# rtrim(#preservesinglequotes(LvarIdentificacion)#)
            	#CAT# rtrim(#preservesinglequotes(LvarNombre)#) #CAT# #preservesinglequotes(LvarNombreS)#
                #CAT# #preservesinglequotes(LvarMontoStrLS)# #CAT# rtrim(#preservesinglequotes(LvarMontoStr)#)                 
            from #ASOCIA#
            order by Nombre,Identificacion
    </cfquery>   

</cfif>


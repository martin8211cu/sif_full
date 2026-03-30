
<cfset t = createObject("component", "sif.Componentes.Translate")>

<!--- Etiquetas de traduccion --->
<cfset LB_DatosAdjuntos = t.translate('LB_DatosAdjuntos','Datos Adjuntos','/rh/generales.xml')>

<cfif isdefined ('url.DEid') and not isdefined ('form.DEid') and len(trim(url.DEid)) gt 0 >
	<cfset form.DEid = url.DEid >
</cfif>

<!--- Valida si el empleado a consultar se encuentra en tabla DatosOferentes --->
<cfquery name="rsValidaEmpleado" datasource="#session.dsn#">
	select RHOid
	from DatosOferentes 
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>

<cfset isOferente = false>
<cfif rsValidaEmpleado.recordcount and len(trim(rsValidaEmpleado.RHOid))>
	<cfset fk = 'RHOid'>
	<cfset fkvalor = rsValidaEmpleado.RHOid>
	<cfset isOferente = true>
<cfelse>
	<cfset fk = 'DEid'>
	<cfset fkvalor = form.DEid>	
</cfif>

<cfset filtro = ""> 
<cfset lvHideDeleted = ''>
<cfset readonly = "false">

<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2727" default="0" returnvariable="LvarAprobarDatosAdjuntos"/>

<cfif isdefined('LvarAuto') and LvarAuto eq 1 > <!--- Si esta dentro de Autogestion --->
	<cfquery name="rsUsuario" datasource="#Session.DSN#">
		select u.Usucodigo
		from Usuario u
		inner join UsuarioReferencia ur
		   	on ur.Usucodigo = u.Usucodigo
		   	and ur.STabla = 'DatosEmpleado'
		   	inner join DatosEmpleado de
		    	on de.DEid = convert(numeric,ur.llave)
		inner join DatosPersonales dp
		   	on dp.datos_personales = u.datos_personales
		   	and dp.Pid = de.DEidentificacion    
		where de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">	
	</cfquery>

	<cfset lvUsucodigo = rsUsuario.Usucodigo>

	<!--- Indica que archivos subidos requieren aprobacion para ser vistos en el curriculum vitae y en curriculum externo --->
	<cfif LvarAprobarDatosAdjuntos> 
		<!--- Filtro mostrar archivos(aprobados) subidos x otros usuarios y archivos que el oferente haya subido ---> 
		<cfset filtro &= "(tipo = 'E' or (tipo = 'I' and aprobado = 1 and UsuCreador != #lvUsucodigo#) or (tipo = 'I' and UsuCreador = #lvUsucodigo#))"> 
		<cfset lvHideDeleted = 'aprobado eq 1'>
	</cfif>
<cfelseif isdefined("fromExpediente")>
	<!--- Indica que archivos subidos requieren aprobacion para ser vistos en el curriculum vitae y en curriculum externo --->
	<cfif LvarAprobarDatosAdjuntos> 
		<cfset lvHideDeleted = 'aprobado eq 1'>
	</cfif>
<cfelse> <!--- Curriculum Vitae del Personal Interno --->
	<!--- Indica que archivos subidos requieren aprobacion para ser vistos en el Curriculum Vitae del Personal Interno --->
	<cfif LvarAprobarDatosAdjuntos>
		<!--- Filtro mostrar aprobados ---> 
		<cfset filtro &= " aprobado = 1"> 
	</cfif>

	<cfset readonly = "true">	
</cfif>	

<cfset addDataColumns = ArrayNew(1)> 
<cfset arrayAppend(addDataColumns,getColumn("tipo","I","char"))>
<cfset arrayAppend(addDataColumns,getColumn("aprobado","0","bit"))>
<cfset arrayAppend(addDataColumns,getColumn("UsuCreador","#session.Usucodigo#","numeric"))>

<cfif isOferente>
	<cfset arrayAppend(addDataColumns,getColumn("DEid","#form.DEid#","numeric"))>
</cfif>

<cf_web_portlet_start border="true" titulo="#LB_DatosAdjuntos#" skin="#Session.Preferences.Skin#">
	<cf_jupload tabla="DatosOferentesArchivos" campo="DOAfile" nombre="DOAnombre" pk="DOAid" fk="#fk#" fkvalor="#fkvalor#" readonly="#readonly#" hideDeleted="#lvHideDeleted#" filter="#filtro#" addDataColumns="#addDataColumns#">
<cf_web_portlet_end>


<cffunction name="getColumn" output="false" returntype="Struct" returnformat="JSON">
	<cfargument name="name"  type="string" required="true">
	<cfargument name="value" type="string" required="true">
	<cfargument name="type"  type="string" required="true">

	<cfset var column = StructNew()> 
	<cfset column.name = Arguments.name>
	<cfset column.value = Arguments.value>
	<cfset column.type = Arguments.type>

	<cfreturn column>
</cffunction>	
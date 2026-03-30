<cfset def = QueryNew("TESid")>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.query" 		default="#def#" type="query">	<!--- consulta por defecto --->
<cfparam name="Attributes.name" 		default="TESid" type="string">	<!--- Nombre del código de la moneda --->
<cfparam name="Attributes.onChange" 	default="" type="string"> 		<!--- funciones javascript en el evento onchange --->
<cfparam name="Attributes.tabindex" 	default="" type="string"> 		<!--- número del tabindex --->
<cfparam name="Attributes.value" 		default="" type="string"> 
<cfparam name="Attributes.disabled" 	default="no" type="boolean"> 
<cfparam name="Attributes.tipo" 		default="P" type="string"> 		<!--- Preparador por defecto --->

<cfif isdefined('Session.Ecodigo')>
	<cfparam name="Attributes.Ecodigo" default="#Session.Ecodigo#" type="String"> <!--- Empresa --->
<cfelse>
	<cfparam name="Attributes.Ecodigo" default="" type="String"> <!--- Empresa --->
</cfif>

<cfif Len(Trim(Attributes.Ecodigo)) EQ 0>
	<cfabort>
</cfif>
 
<cfinvoke component="sif.tesoreria.Componentes.TESaplicacion" method="sbInicializaCatalogos">

<cfquery name="rsTesoreria" datasource="#Session.DSN#" >
	select 	TESid, 
			TEScodigo, 
			TESdescripcion
	  from 	Tesoreria t
	 where 	CEcodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	   and	EcodigoAdm 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	 order by TEScodigo
</cfquery>
<cfif rsTesoreria.recordCount EQ 0>
	<cf_errorCode	code = "50588" msg = "NO EXISTEN TESORERÍAS ADMINISTRADAS POR ESTA EMPRESA">
	<cfabort>
</cfif>
<cfif Attributes.tipo NEQ "">
	<cfquery name="rsTesoreria" datasource="#Session.DSN#" >
		select 	TESid, 
				TEScodigo, 
				TESdescripcion
		  from 	Tesoreria t
		 where 	CEcodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		   and	EcodigoAdm 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		   and (
					select count(1)
					  from TESusuarioOP u
					 where u.TESid = t.TESid
					   and u.Usucodigo = #session.Usucodigo#
					   and u.TESUOPpreparador = 1
				) > 0
		 order by TEScodigo
	</cfquery>
	<cfif rsTesoreria.recordCount EQ 0>
		<cfset Request.Error.Backs = 1>
		<cf_errorCode	code = "50589"
						msg  = "EL USUARIO '@errorDat_1@' NO TIENE AUTORIZACIÓN PARA PROCESAR ORDENES DE PAGO EN NINGUNA TESORERIA<BR>(Incluirlo en la opción 'Usuarios de Ordenes de Pago por Tesorería')"
						errorDat_1="#session.Usulogin#"
		>
		<cfabort>
	</cfif>
</cfif>

<cfoutput>
	<select 
		name="#Attributes.name#" 
		id="#Attributes.name#" 
		<cfif Attributes.disabled> disabled </cfif>
		<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
		<cfif Len(Trim(Attributes.onChange)) GT 0> onChange="javascript:#Attributes.onChange#"	</cfif>
	>
</cfoutput>

<cfif not isdefined("session.Tesoreria")>
	<cfset session.Tesoreria = structnew()>
</cfif>

<cfif ListLen('Attributes.query.columnList') GT 0 and trim(Attributes.query.TESid) NEQ "">
	<cfset Attributes.value = Attributes.query.TESid>
<cfelseif trim(Attributes.value) EQ "">
	<cfif isdefined("form.#Attributes.name#")>
		<cfset Attributes.value = form[attributes.name]>
	<cfelseif isdefined("session.tesoreria.#Attributes.name#")>
		<cfset Attributes.value = session.tesoreria[attributes.name]>
	</cfif>
</cfif>

<cfset LvarTESid = rsTesoreria.TESid>
<cfoutput query="rsTesoreria"> 
	<option value="#rsTesoreria.TESid#"
	<cfif Attributes.value NEQ "">
		<cfif trim(rsTesoreria.TESid) EQ trim(Attributes.value)>selected<cfset LvarTESid = rsTesoreria.TESid></cfif>
	</cfif>
	>						
		#rsTesoreria.TEScodigo# - #rsTesoreria.TESdescripcion#
	</option>
</cfoutput>
</select>

<cfset session.Tesoreria[Attributes.name] = LvarTESid>
<cfset form[Attributes.name] = LvarTESid>



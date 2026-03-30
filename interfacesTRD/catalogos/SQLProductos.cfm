<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsProductocodigo" datasource="#Session.DSN#">
			select CodigoICTS 
			from Productos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CodigoICTS = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CodigoICTS#">
		</cfquery>

		<cfif rsProductocodigo.RecordCount LTE 0>

			<cfquery name="insert" datasource="#Session.DSN#">
				insert into Departamentos (Ecodigo, CodigoICTS, Descripcion, LineaNegocio, CodigoProducto, TipoOperacion)
					values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> , 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CodigoICTS#"> , 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Descripcion#">, 
							 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddescripcion#">))
					)
			 </cfquery>
			<cfset modo="ALTA">
		<cfelse>
			<cfthrow detail="El registro que desea insertar ya existe.">
		</cfif>
			
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete CatProductos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
				and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#" >
				and Deptocodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Deptocodigo#">
		</cfquery>
		<cfset modo="BAJA">

	<cfelseif isdefined("Form.Cambio")>
		<cfif trim(Form.xDeptocodigo) NEQ trim(Form.Deptocodigo)>
			<cfquery name="rsDeptocodigoCambio" datasource="#Session.DSN#">
				select 1 
				from Departamentos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Deptocodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Deptocodigo#">
			</cfquery>
		
		<cfif isdefined("rsDeptocodigoCambio") and rsDeptocodigoCambio.RecordCount GT 0>
			<cfthrow detail="El C&oacute;digo que desea modificar ya existe.">
		</cfif>
	</cfif>

	<cf_dbtimestamp datasource="#session.dsn#"
			table="Departamentos"
			redirect="Departamentos.cfm"
			timestamp="#form.ts_rversion#"				
			field1="Ecodigo" 
			type1="integer" 
			value1="#session.Ecodigo#"
			field2="Dcodigo" 
			type2="integer" 
			value2="#form.Dcodigo#"
			field3="Deptocodigo" 
			type3="char" 
			value3="#form.xDeptocodigo#"
			>

		<cfquery name="delete" datasource="#Session.DSN#">
			update Departamentos 
			set Deptocodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Deptocodigo#">, 
				Ddescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddescripcion#">))
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and Dcodigo = <cfqueryparam value="#Form.Dcodigo#" cfsqltype="cf_sql_integer">
			  and Deptocodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.xDeptocodigo#">
		</cfquery>
		<cfset modo="CAMBIO">
		<cf_sifcomplementofinanciero action='update'
				tabla="Departamentos"
				form = "form"
				llave="#form.Dcodigo#" />				
		
	</cfif>
</cfif>

<form action="Departamentos.cfm<cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Dcodigo" type="hidden" value="<cfif isdefined("Form.Dcodigo")><cfoutput>#Form.Dcodigo#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
	<input type="hidden" name="desde" value="<cfif isdefined("form.desde")><cfoutput>#form.desde#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


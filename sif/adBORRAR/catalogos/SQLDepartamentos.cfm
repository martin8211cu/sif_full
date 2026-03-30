<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsDeptocodigo" datasource="#Session.DSN#">
			select Deptocodigo 
			from Departamentos
			where Ecodigo = #session.Ecodigo#
			and Deptocodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Deptocodigo#">
		</cfquery>

		<cfif rsDeptocodigo.RecordCount LTE 0>
			<cfquery name="rsCont" datasource="#Session.DSN#">
				select (coalesce(max(Dcodigo),0)+1) as Cont
				from Departamentos 
				where Ecodigo = #Session.Ecodigo#			
			</cfquery>

			<cfquery name="insert" datasource="#Session.DSN#">
				insert into Departamentos (Ecodigo, Dcodigo, Deptocodigo, Ddescripcion)
					values ( #session.Ecodigo#, 
							 #rsCont.Cont#, 
							 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Deptocodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Ddescripcion)#">
					)
			 </cfquery>
			<cfset modo="ALTA">
		<cfelse>
			<cf_errorCode	code = "50020" msg = "El registro que desea insertar ya existe.">
		</cfif>
			
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from Departamentos
			where Ecodigo = #Session.Ecodigo#
			  and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#" >
			  and Deptocodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Deptocodigo#">
		</cfquery>
		<cf_sifcomplementofinanciero action='delete'
					tabla="Departamentos"
					form = "form"
					llave="#form.Dcodigo#" />		
		<cfset modo="BAJA">

	<cfelseif isdefined("Form.Cambio")>
		<cfif trim(Form.xDeptocodigo) NEQ trim(Form.Deptocodigo)>
			<cfquery name="rsDeptocodigoCambio" datasource="#Session.DSN#">
				select 1 
				from Departamentos
				where Ecodigo = #session.Ecodigo#
				and Deptocodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Deptocodigo#">
			</cfquery>
		
		<cfif isdefined("rsDeptocodigoCambio") and rsDeptocodigoCambio.RecordCount GT 0>
			<cf_errorCode	code = "50021" msg = "El Código que desea modificar ya existe.">
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
			set Deptocodigo =  <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Deptocodigo#">, 
				Ddescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Ddescripcion)#">
			where Ecodigo = #Session.Ecodigo#
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
	<input name="modo" 		type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Dcodigo" 	type="hidden" value="<cfif isdefined("Form.Dcodigo")><cfoutput>#Form.Dcodigo#</cfoutput></cfif>">
    <input name="Pagina"	type="hidden" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
	<input name="desde"		type="hidden" value="<cfif isdefined("form.desde")><cfoutput>#form.desde#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
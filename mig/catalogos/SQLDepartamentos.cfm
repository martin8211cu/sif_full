<cfif isdefined ('form.Importar')>
	<cflocation url="DepartamentosImportador.cfm">
</cfif>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsDeptocodigo" datasource="#Session.DSN#">
			select Deptocodigo 
			from Departamentos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Deptocodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Deptocodigo#">
		</cfquery>
		<cfif rsDeptocodigo.RecordCount LTE 0>
			<cfquery name="rsCont" datasource="#Session.DSN#">
				select (coalesce(max(Dcodigo),0)+1) as Cont
				from Departamentos 
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">				
			</cfquery>
			<cfquery name="insert" datasource="#Session.DSN#">
				insert into Departamentos (Ecodigo, Dcodigo, Deptocodigo, Ddescripcion, MIGGid,BMusucodigo)
					values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> , 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCont.Cont#"> , 
							 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Deptocodigo#">, 
							 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddescripcion#">))
							 ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MIGGid#">,
							 #session.usucodigo#
					)
			 </cfquery>
			<cfset LvarCodigo=rsCont.Cont>
			<cfif isdefined ('form.Depto')>
				<cfoutput>
					<script language="JavaScript1.2">
						window.close();
						window.parent.opener.document.form3.Dcodigo.value=#LvarCodigo#;
					</script>
				</cfoutput>
				<cfabort>
			</cfif>
			<cfset modo="ALTA">
		<cfelse>
			<cf_errorCode	code = "50020" msg = "El registro que desea insertar ya existe.">
		</cfif>
			
	<cfelseif isdefined("Form.Baja")>
	
		<cfquery name="Valida" datasource="#Session.DSN#">
			select a.MIGMid, b.MIGMcodigo
			from MIGFiltrosmetricas a
				left join MIGMetricas b
					on a.MIGMid=b.MIGMid
					and a.Ecodigo=b.Ecodigo
			where a.MIGMdetalleid=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#" >
			and a.MIGMtipodetalle='D'
			and  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
		</cfquery>
		
		<cfquery name="ValidaCF" datasource="#Session.DSN#">
			select a.CFid,a.Dcodigo,a.CFcodigo
			from CFuncional a
				inner join Departamentos b
					on a.Dcodigo=b.Dcodigo
					and a.Ecodigo=b.Ecodigo
			where a.Dcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#" >
			and  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
		</cfquery>
		
		<cfquery name="ValidaResp" datasource="#Session.DSN#">
			select a.MIGReid,a.Dcodigo,b.MIGRcodigo
			from MIGResponsablesDepto a
				inner join MIGResponsables b
					on a.MIGReid=b.MIGReid
					and a.Ecodigo=b.Ecodigo
			where a.Dcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#" >
			and  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
		</cfquery>
		
		<cfquery name="ValidaFDatos" datasource="#Session.DSN#">
			select a.id_datos
			from F_Datos a
			where a.Dcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#" >
			and  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
		</cfquery>
		
		<cfif Valida.recordCount GT 0 or ValidaCF.recordCount GT 0 or ValidaResp.recordCount GT 0 or ValidaFDatos.recordcount GT 0>
			<cfthrow type="toUser" message="El Departamento no puede ser Eliminado ya que tiene Asociaciones">
		<cfelse>
			<cfquery name="delete" datasource="#Session.DSN#">
				delete from Departamentos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
					and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#" >
					and Deptocodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Deptocodigo#">
			</cfquery>
			<cfset modo="BAJA">
		</cfif>

	<cfelseif isdefined("Form.Cambio")>
		<cfif trim(Form.xDeptocodigo) NEQ trim(Form.Deptocodigo)>
			<cfquery name="rsDeptocodigoCambio" datasource="#Session.DSN#">
				select 1 
				from Departamentos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Deptocodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Deptocodigo#">
			</cfquery>
		
		<cfif isdefined("rsDeptocodigoCambio") and rsDeptocodigoCambio.RecordCount GT 0>
			<cf_errorCode	code = "50021" msg = "El Código que desea modificar ya existe.">
		</cfif>
	</cfif>

	<!---<cf_dbtimestamp datasource="#session.dsn#"
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
			>--->
		<cfquery name="delete" datasource="#Session.DSN#">
			update Departamentos 
			set Ddescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddescripcion#">))
			<cfif isdefined ('form.MIGGid') and form.MIGGid NEQ "">
				,MIGGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MIGGid#">
			</cfif>
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and Dcodigo = <cfqueryparam value="#Form.Dcodigo#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset modo="CAMBIO">
		<!---<cf_sifcomplementofinanciero action='update'
				tabla="Departamentos"
				form = "form"
				llave="#form.Dcodigo#" />--->				
		
	</cfif>
</cfif>

<form action="Departamentos.cfm" method="post" name="sql">
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




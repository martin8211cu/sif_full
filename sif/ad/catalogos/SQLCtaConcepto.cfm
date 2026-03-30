
<cfset params = "&Cid=#form.Cid#&Ccodigo=#form.Ccodigo#">
<cfif not isdefined("Form.Nuevo")>

	<cfif isdefined("Form.Alta")>
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select Ccodigo 
			from CuentasConceptos  
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TRIM(Form.Ccodigo)#">
				and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">
				and Cid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">				
		</cfquery>
				
		<cfif len(trim(rsExiste.Ccodigo)) EQ 0>
			<cfquery name="insert" datasource="#session.DSN#">
				insert into CuentasConceptos (Ecodigo, Dcodigo, Ccodigo, Cid, Ccuenta, Ccuentadesc)
					values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> , 				
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char"    value="#TRIM(Form.Ccodigo)#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">,					
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta1#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta2#">
					)
			</cfquery>
			<cfquery name="rsPagina" datasource="#session.DSN#">
				 select b.Dcodigo
				 from CuentasConceptos b, Departamentos c, CContables a
				 where b.Ccodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Ccodigo)#">
					and b.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
					and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and a.Ecodigo = b.Ecodigo 
					and a.Ccuenta = b.Ccuenta
					and a.Ecodigo = c.Ecodigo
					and b.Dcodigo = c.Dcodigo
				order by a.Ccuenta 
			</cfquery>
			<cfset row = 1>
			<cfif rsPagina.RecordCount LT 500>
				<cfloop query="rsPagina">
					<cfif rsPagina.Dcodigo EQ form.Dcodigo>
						<cfset row = rsPagina.currentrow>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
			<cfset form.pagina2 = Ceiling(row / form.MaxRows2)>
			<cfset params = params & '&Dcodigo=#form.Dcodigo#'>
		<cfelse>
			<cf_errorCode	code = "50019" msg = "El código del Regristro ya Existe.">
		</cfif>
		
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from CuentasConceptos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
				and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">
				and Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.Ccodigo)#" >
				and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
		</cfquery>
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
					table="CuentasConceptos"
					redirect="CtasConcepto.cfm"
					timestamp="#form.ts_rversion#"				
					field1="Ecodigo" 
					type1="integer" 
					value1="#session.Ecodigo#"
					field2="Dcodigo" 
					type2="integer" 
					value2="#form.Dcodigo#"
					field3="Ccodigo" 
					type3="char" 
					value3="#trim(form.Ccodigo)#"
					field4="Cid" 
					type4="numeric" 
					value4="#form.Cid#">

		<cfquery name="update" datasource="#session.DSN#">
			update CuentasConceptos  set 
				Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta1#">,
				Ccuentadesc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta2#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ccodigo#">
			  and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">
			  and Cid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
		</cfquery>	
		<cfset params = params & '&Dcodigo=#form.Dcodigo#'>			
	</cfif>
</cfif>
<cflocation url="CtasConcepto.cfm?Pagina=#Form.Pagina#&Pagina2=#Form.Pagina2#&filtro_Ccodigo=#form.filtro_Ccodigo#&filtro_Cdescripcion=#form.filtro_Cdescripcion#&hfiltro_Ccodigo=#form.hfiltro_Ccodigo#&hfiltro_Cdescripcion=#form.hfiltro_Cdescripcion#&fTipo=#form.fTipo##params#">
<!--- <cfoutput>
<form action="CtasConcepto.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="Ccodigo" type="hidden" value="<cfif isdefined("Form.Ccodigo")>#Form.Ccodigo#</cfif>">
		<input name="Cid" type="hidden" value="<cfif isdefined("Form.Cid")>#Form.Cid#</cfif>">
	<cfif modo neq 'ALTA'>
		<input name="Dcodigo" type="hidden" value="<cfif isdefined("Form.Dcodigo")>#Form.Dcodigo#</cfif>">
	</cfif>
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">		
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

 --->


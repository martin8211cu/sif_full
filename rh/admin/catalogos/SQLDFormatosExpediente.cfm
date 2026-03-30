<cfparam name="action" default="FormatosPrincipal.cfm">
<cfparam name="df_modo" default="ALTA">

<cfif not isdefined("form.NuevoD") >
	<!--- Caso 3: Agregar Detalle de Requisicion y opcionalmente modificar el encabezado --->
	<cfif isdefined("Form.AltaD")>
<!----
		declare @orden int
		select @orden = isnull(max(DFEorden), 0 ) + 10
		from DFormatosExpediente
		where EFEid=<cfqueryparam value="#form.EFEid#" cfsqltype="cf_sql_numeric">
--->		
		<cfquery name="rsOrden" datasource="#Session.DSN#">
			select coalesce(max(DFEorden), 0) + 10 as orden
			from DFormatosExpediente
			where EFEid=<cfqueryparam value="#form.EFEid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset orden = rsOrden.orden>

		<cfquery name="Insert" datasource="#Session.DSN#">		
			insert into DFormatosExpediente ( EFEid, DFEetiqueta, DFEfuente, DFEnegrita, DFEitalica, DFEsubrayado, DFEtamfuente, DFEcolor, Usucodigo, Ulocalizacion, DFEorden, DFEcaptura, ECEid )
			values ( <cfqueryparam value="#form.EFEid#" cfsqltype="cf_sql_numeric">,
					 '#form.DFEetiqueta#',
					 <cfqueryparam value="#form.DFEfuente#"  cfsqltype="cf_sql_varchar">,
					 <cfif isdefined("form.DFEnegrita")>1<cfelse>0</cfif>,
					 <cfif isdefined("form.DFEitalica")>1<cfelse>0</cfif>,
					 <cfif isdefined("form.DFEsubrayado")>1<cfelse>0</cfif>,
					 <cfqueryparam value="#form.DFEtamfuente#" cfsqltype="cf_sql_integer">,
					 <cfqueryparam value="#form.DFEcolor#"  cfsqltype="cf_sql_char">,
					 <cfqueryparam value="#session.Usucodigo#"     cfsqltype="cf_sql_numeric">,
					 <cfqueryparam value="#session.Ulocalizacion#" cfsqltype="cf_sql_numeric">,
					 <cfqueryparam value="#orden#" cfsqltype="cf_sql_numeric">,
					 <cfqueryparam value="#form.DFEcaptura#" cfsqltype="cf_sql_integer">,
					 <cfif form.DFEcaptura neq 0><cfqueryparam value="#form.ECEid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>
				   )
		</cfquery>
		<cfset df_modo="ALTA">
		<cfset action = "FormatosPrincipal.cfm">

	<!--- Caso 4: Modificar Detalle de Requisicion y opcionalmente modificar el encabezado --->			
	<cfelseif isdefined("Form.CambioD")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="DFormatosExpediente"
				redirect="form-DFormatosExpediente.cfm"
				timestamp="#form.dtimestamp#"
				field1="EFEid" 
				type1="numeric" 
				value1="#form.EFEid#"
				field2="DFElinea" 
				type2="numeric" 
				value2="#form.DFElinea#"
			>	
		<cfquery name="Update" datasource="#Session.DSN#">
			update DFormatosExpediente
			set DFEetiqueta  = <cfqueryparam value="#form.DFEetiqueta#"  cfsqltype="cf_sql_varchar">,
				DFEfuente    = <cfqueryparam value="#form.DFEfuente#"  cfsqltype="cf_sql_varchar">,
				DFEnegrita   = <cfif isdefined("form.DFEnegrita")>1<cfelse>0</cfif>,
				DFEitalica   = <cfif isdefined("form.DFEitalica")>1<cfelse>0</cfif>,
				DFEsubrayado = <cfif isdefined("form.DFEsubrayado")>1<cfelse>0</cfif>,
				DFEtamfuente = <cfqueryparam value="#form.DFEtamfuente#" cfsqltype="cf_sql_integer">,
				DFEcolor     = <cfqueryparam value="#form.DFEcolor#"  cfsqltype="cf_sql_char">,
				DFEcaptura   = <cfqueryparam value="#form.DFEcaptura#" cfsqltype="cf_sql_integer">,
				ECEid		 = <cfif form.DFEcaptura neq 0><cfqueryparam value="#form.ECEid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>
			where EFEid      = <cfqueryparam value="#Form.EFEid#"    cfsqltype="cf_sql_numeric">
			  and DFElinea   = <cfqueryparam value="#Form.DFElinea#" cfsqltype="cf_sql_numeric">
		</cfquery>
		
		<cfset df_modo="CAMBIO">
		<cfset action = "FormatosPrincipal.cfm">
		
	<!--- Caso 5: Borrar detalle de Requisicion --->
	<cfelseif isdefined("Form.BajaD")>
		<cfquery name="Delete" datasource="#Session.DSN#">
			delete from DFormatosExpediente
			where EFEid      = <cfqueryparam value="#Form.EFEid#"    cfsqltype="cf_sql_numeric">
			  and DFElinea   = <cfqueryparam value="#Form.DFElinea#" cfsqltype="cf_sql_numeric">
		</cfquery>
		
		<cfset df_modo="CAMBIO">
		<cfset action = "FormatosPrincipal.cfm">
	</cfif>
<cfelse>
	<cfset action = "FormatosPrincipal.cfm" >
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="ef_modo"   type="hidden" value="CAMBIO">
	<input name="df_modo"   type="hidden" value="<cfif isdefined("df_modo")>#df_modo#</cfif>">

	<input name="TEid"   type="hidden" value="<cfif isdefined("form.TEid")>#form.TEid#</cfif>">
	<input name="EFEid"   type="hidden" value="<cfif isdefined("form.EFEid")>#form.EFEid#</cfif>">

	<cfif df_modo neq 'ALTA' >
		<input name="DFElinea" type="hidden" value="<cfif isdefined("form.DFElinea")>#form.DFElinea#</cfif>">
	</cfif>	

	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
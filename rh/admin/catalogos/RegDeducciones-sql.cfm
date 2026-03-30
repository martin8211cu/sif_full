<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso"><!--- Permite validar el acceso según parametrizacion 2526--->
<cfset action = "RegDeducciones.cfm">
<cfset modo = "CAMBIO">
<cfset modoDet = "ALTA">

<cfif not isdefined("Form.btnNuevo") and not isdefined("Form.btnNuevoD")>
	<cfif isdefined("Form.btnAgregar")>
		<cfquery name="rsLote" datasource="#session.DSN#">
			select coalesce(max(EIDlote),0)+1 as lote
			from EIDeducciones
		</cfquery>

		<cfquery name="ABC_Deduccion" datasource="#Session.DSN#">
			insert into EIDeducciones (EIDlote, Ecodigo, TDid, SNcodigo, Usucodigo, Ulocalizacion, EIDfecha, EIDestado)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsLote.lote#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TDid#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				0
			)
		</cfquery>
		<cfset Form.EIDlote = rsLote.lote>
		<cfset modo = "CAMBIO">
		<cfset modoDet = "ALTA">

	<cfelseif isdefined("Form.btnAgregarD")>

		<cfif Form.DIDmetodo eq 3>
			<cfinvoke component="rh.componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="14600706" default="0" returnvariable="vUMI"/>
			<cfif vUMI lte 0>
				<cfthrow message="Parametro Din&aacute;mico RH." detail="No se ha configurado el Parametro para la Unidad Mixta Infonavit (UMI) con el codigo: 14600706, Proceso Cancelado!">
			</cfif>
		</cfif>
		<cfquery name="ABC_Deduccion" datasource="#Session.DSN#">
			insert into DIDeducciones (EIDlote, DIDidentificacion, DIDreferencia, DIDmetodo, DIDvalor, DIDfechaini, DIDfechafin, DIDmonto, DIDcontrolsaldo)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.EIDlote#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.DIDreferencia#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DIDmetodo#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DIDvalor#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DIDfechaini)#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DIDfechafin)#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DIDmonto#">,
				<cfif isdefined("Form.DIDcontrolsaldo")>1<cfelse>0</cfif>
			)				
		</cfquery>
		<cfset modo = "CAMBIO">
		<cfset modoDet = "ALTA">


	<cfelseif isdefined("Form.btnEliminar")>
		<cfquery name="ABC_Deduccion" datasource="#Session.DSN#">
			delete from DIDeducciones
			where exists( select 1
			from EIDeducciones a
			where DIDeducciones.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.EIDlote#">
			and DIDeducciones.EIDlote = a.EIDlote
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
		</cfquery>
		<cfquery name="ABC_Deduccion" datasource="#Session.DSN#">
			delete from EIDeducciones 
			where EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.EIDlote#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfset modo = "ALTA">
		<cfset modoDet = "ALTA">
		<cfset action = "ListaDeducciones.cfm">

	<cfelseif isdefined("Form.btnEliminarD")>
		<cfquery name="ABC_Deduccion" datasource="#Session.DSN#">
			delete from DIDeducciones
			where exists( select 1
			from EIDeducciones a
			where DIDeducciones.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.EIDlote#">
			and DIDeducciones.DIDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DIDid#">
			and DIDeducciones.EIDlote = a.EIDlote
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
		</cfquery>
		<cfset modo = "CAMBIO">
		<cfset modoDet = "ALTA">

	<cfelseif isdefined("Form.btnCambiarD")>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="DIDeducciones"
			redirect="RegDeducciones.cfm"
			timestamp="#form.ts_rversion#"
			field1="DIDid" 
			type1="numeric" 
			value1="#form.DIDid#">
		
		<cfif Form.DIDmetodo eq 3>
			<cfinvoke component="rh.componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="14600706" default="0" returnvariable="vUMI"/>
			<cfif vUMI lte 0>
				<cfthrow message="Parametro Din&aacute;mico RH." detail="No se ha configurado el Parametro para la Unidad Mixta Infonavit (UMI) con el codigo: 14600706, Proceso Cancelado!">
			</cfif>
		</cfif>
		
		<cfquery name="ABC_Deduccion" datasource="#Session.DSN#">
			update DIDeducciones
			   set DIDidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DEidentificacion#">,
				   DIDreferencia = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DIDreferencia#">, 
				   DIDmetodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DIDmetodo#">, 
				   DIDvalor = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DIDvalor#">, 
				   DIDfechaini = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DIDfechaini)#">,
				   DIDfechafin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DIDfechafin)#">,
				   DIDmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DIDmonto#">, 
				<cfif isdefined("Form.DIDcontrolsaldo")>
				   DIDcontrolsaldo = 1
				<cfelse>
				   DIDcontrolsaldo = 0
				</cfif>
			from EIDeducciones a
			where DIDeducciones.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.EIDlote#">
			and DIDeducciones.DIDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DIDid#">				
			and DIDeducciones.EIDlote = a.EIDlote
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfset modo = "CAMBIO">
		<cfset modoDet = "ALTA">
	</cfif>
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<cfif modo EQ "CAMBIO" and isdefined("Form.EIDlote") and Len(Trim(Form.EIDlote)) NEQ 0>
		<input name="EIDlote" type="hidden" value="#Form.EIDlote#">
	</cfif>
	<cfif modoDet EQ "CAMBIO" and isdefined("Form.DIDid") and Len(Trim(Form.DIDid)) NEQ 0>
		<input name="DIDid" type="hidden" value="#Form.DIDid#">
	</cfif>
	<cfif isdefined("Form.btnBuscar")>
		<input name="btnBuscar" type="hidden" value="Buscar">
		<cfif isdefined("Form.DEidentificacion") and Len(Trim(Form.DEidentificacion)) NEQ 0>
			<input name="DEid" type="hidden" value="#Form.DEid#">
			<input name="DEidentificacion" type="hidden" value="#Form.DEidentificacion#">
		</cfif>
		<cfif isdefined("Form.DIDreferencia") and Len(Trim(Form.DIDreferencia)) NEQ 0>
			<input name="DIDreferencia" type="hidden" value="#Form.DIDreferencia#">
		</cfif>
		<cfif isdefined("Form.DIDmetodo")>
			<input name="DIDmetodo" type="hidden" value="#Form.DIDmetodo#">
		</cfif>
		<cfif isdefined("Form.DIDfechaini") and Len(Trim(Form.DIDfechaini)) NEQ 0>
			<input name="DIDfechaini" type="hidden" value="#Form.DIDfechaini#">
		</cfif>
		<cfif isdefined("Form.DIDfechafin") and Len(Trim(Form.DIDfechafin)) NEQ 0>
			<input name="DIDfechafin" type="hidden" value="#Form.DIDfechafin#">
		</cfif>
	</cfif>
	<cfif action EQ "RegDeducciones.cfm">
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
	</cfif>
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

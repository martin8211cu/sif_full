<!------------------------------------- if del Mantenimiento de fechas de inactivación de la cuenta  -------------------------------->
<cfif isDefined("btnAceptar") or isDefined("btnCambiar") or isDefined("btnBorrar.X") >

	<cfif isDefined("btnAceptar")>
		<cfquery name="A_CInactivas" datasource="#Session.DSN#">
			insert INTO CPInactivas (CPcuenta, CPIdesde, CPIhasta, Usucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.CPIdesde)#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.CPIhasta)#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			)		
		</cfquery>
	
	<cfelseif isDefined("btnCambiar")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="CPInactivas" 
			redirect="CuentasFinancieras.cfm?Cmayor=#Form.Cmayor#&Formato=#Form.formato#"
			timestamp="#form.ts_rversion#"
			field1="CPcuenta,numeric,#form.CPcuenta#"
			field2="CPIid,numeric,#form.CPIid#">
						
		<cfquery name="C_CInactivas" datasource="#Session.DSN#">
			update CPInactivas set
				CPIdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.CPIdesde)#">, 
				CPIhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.CPIhasta)#">, 
				Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			where CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">
			and CPIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPIid#">		
		</cfquery>
		
	<cfelseif isDefined("btnBorrar.X")>
		<cfquery name="B_CInactivas" datasource="#Session.DSN#">
			delete from CPInactivas 
			where CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">
			and CPIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPIid#">
		</cfquery>
	</cfif>
		
<!------------------------------------------ if del mantenimiento de la cuenta contable ----------------------------------------->	
<cfelseif isDefined("btnCambiar") >

<cfelseif not isdefined("Form.Nuevo")>

	<cfif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="CPresupuesto" 
			redirect="CuentasFinancieras.cfm?Cmayor=#Form.Cmayor#&Formato=#Form.formato#"
			timestamp="#form.ts_rversion#"
			field1="CPcuenta,numeric,#form.CPcuenta#"
			field2="Ecodigo,numeric,#session.Ecodigo#">			
			
		<cfquery name="SelCPresupuesto" datasource="#Session.DSN#">
			update CPresupuesto set 				
				   CPdescripcionF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPdescripcionF#" null="#Len(Trim(Form.CPdescripcionF)) EQ 0 OR (Trim(Form.CPdescripcion) EQ Trim(Form.CPdescripcionF))#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">
		</cfquery>
	</cfif>			

</cfif>

<cfoutput>

<form action="CuentasPresupuesto.cfm?Cmayor=#Form.Cmayor#&Formato=#Form.formato#" method="post" name="sql">
	<input name="CPcuenta" type="hidden" value="<cfif isdefined('Form.CPcuenta')>#Form.CPcuenta#</cfif>">
	<input name="Cmayor" type="hidden" value="<cfif isdefined('Form.Cmayor')>#Form.Cmayor#</cfif>">
	<input name="formato" type="hidden" value="<cfif isdefined('Form.formato')>#Form.formato#</cfif>">
	<cfif not isdefined("form.Nuevo")>
		<input name="Pagina" type="hidden" value="<cfif isdefined('Form.Pagina')>#Form.Pagina#</cfif>">	
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

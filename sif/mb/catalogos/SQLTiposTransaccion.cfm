<!---Redireccion modulo TCE o Bancos--->

<cfset LvarIrATiposTransaccion = "../../mb/catalogos/TiposTransaccion.cfm">
<cfset LvarIrAformTiposTransaccion = "../../mb/catalogos/formTiposTransaccion.cfm">
<cfset LvarABTtce = 0>
<cfif isdefined("LvarTCESQLTiposTransaccion")>
	<cfset LvarIrATiposTransaccion = "../../tce/catalogos/TCETiposTransaccion.cfm">
	<cfset LvarIrAformTiposTransaccion = "../../tce/catalogos/TCEformTiposTransaccion.cfm">
	<cfset LvarABTtce = 1>
</cfif>
<!--- <cf_dump var="#form#"> --->
<cfparam  name="modo" default="ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
	
			<cfquery name="rsCodigoValido" datasource="#session.dsn#">
				select count(1) as Total
				from BTransacciones
				where BTcodigo = upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.BTcodigo#">) 										
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			
			<cfif #rsCodigoValido.Total# eq 0>
			
				<cfquery name="ABC_TiposTransaccion" datasource="#Session.DSN#">
					insert into BTransacciones (Ecodigo, BTcodigo, BTdescripcion, BTtipo,BTtipoEst, BTtce, BTMetdoPago)
					values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
						upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.BTcodigo#">), 										
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.BTdescripcion#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.BTtipo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.BTtipoEst#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#LvarABTtce#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.MtdoPago#">
					)								
				</cfquery>
	
				<cfset modo="ALTA">
				
			<cfelse>
				<cfthrow message="EL CODOGO INGRESADO YA FUE ASIGNADO A UN TIPO DE TRANSACCION">
			</cfif>
		<cfelseif isdefined("Form.Baja")>						
			<cfquery name="ABC_TiposTransaccion" datasource="#Session.DSN#">
				delete from BTransacciones 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BTid#">			
			</cfquery> 	  
			<cfset modo="ALTA">
			<cf_sifcomplementofinanciero action='delete'
				tabla="BTransacciones"
				form = "form1"
				llave="#Form.BTid#" />	
				
		<cfelseif isdefined("Form.Cambio")>
			
			<cfquery name="checkAvailable" datasource="#session.dsn#">
				select count(1) as Total from BTransacciones
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
				  and BTcodigo = upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.BTcodigo#">)
				  and BTid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BTid#">
			</cfquery>
				
			<cfif #checkAvailable.Total# eq 0>
				<cf_dbtimestamp datasource="#session.dsn#"
						table="BTransacciones"
						redirect="#LvarIrAformTiposTransaccion#"
						timestamp="#form.ts_rversion#"
						field1="BTid" 
						type1="numeric" 
						value1="#form.BTid#"
						>
						
				<cfquery name="ABC_TiposTransaccion" datasource="#Session.DSN#">
					update BTransacciones set
						BTcodigo 		= upper(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.BTcodigo#">),
						BTdescripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.BTdescripcion#">,
						BTtipo 			= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.BTtipo#">,
						BTtipoEst 		= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.BTtipoEst#">,
						BTMetdoPago     = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.MtdoPago#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BTid#">
					  and BTtce = <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarABTtce#">	
					  
				</cfquery>	
				<cf_sifcomplementofinanciero action='update'
					tabla="BTransacciones"
					form = "form1"
					llave="#Form.BTid#" />				
				<cfset modo="ALTA">
			
			<cfelse>
				<cfthrow message="EL CODOGO INGRESADO YA FUE ASIGNADO A UN TIPO DE TRANSACCION">
			</cfif>
		</cfif>			
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>


<!---Redireccion TiposTransaccion.cfm o TCETiposTransaccion.cfm--->
<form action="<cfoutput>#LvarIrATiposTransaccion#</cfoutput>" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif modo neq 'ALTA'>
		<input name="BTid" type="hidden" value="<cfif isdefined("Form.BTid")><cfoutput>#Form.BTid#</cfoutput></cfif>">	
	</cfif>

	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
	<input name="desde" type="hidden" value="<cfif isdefined("session.modulo")><cfoutput>#session.modulo#</cfoutput></cfif>">	
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


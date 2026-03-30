<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->

<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 21 de julio del 2005
	Motivo: Se hizo una modificación en la llave de la tabla BTransaccionesEq, ahora son cuatro campos 
			(Ecodigo,Bid,BTid,BTEcodigo). Se hicieron los cambios en cada consulta.
	Modificado por Gustavo Fonseca H.
		Fecha: 13-10-2005.
		Motivo: Se valida que no tenga una EQUIVALENCIA con las mismas caracterías del registro que se va a insertar.
		Esto por que se debe permitir N transacciones "mías" a solo 1 del Banco.
	Modificado por Gustavo Fonseca H.
		Fecha: 14-10-2005.
		Motivo: se cambió el nombre del campo del form BTEdescripcion por BTEdescripcion2.
	Modificado por Gustavo Fonseca H.
		Fecha: 26-10-2005.
		Motivo: Se modifica para que agregue campos hidden(_xxxx) para que pueda modificar y eliminar bien.
 --->
 
<!---  <cfdump var="#form#">
 <cf_dump var="#url#"> --->
 
<cfset LvarTBEquiva = "TBEquivalentes.cfm">
<cfif isdefined("LvarTCETBSQLEq")>
    <cfset LvarTBEquiva = "TCETransaccionesBancoEquiva.cfm">
</cfif>

<cfparam  name="modo" default="ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="BTEinser" datasource="#session.DSN#">
				insert into BTransaccionesEq (Ecodigo, Bid, BTid, BTEcodigo, BTEdescripcion, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.BTEcodigo#">, 										
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.BTEdescripcion2#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)								
			</cfquery>
			<cfset modo="ALTA">

		<cfelseif isdefined("Form.Baja")>
			<cfquery name="BTEdelete" datasource="#session.DSN#">
				delete from BTransaccionesEq
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form._Bid#">
				  and BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form._BTid#">
				  and BTEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form._BTEcodigo#">				  
			</cfquery>
			<cfset modo="ALTA">

		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="BTEupdate" datasource="#session.DSN#">
				update BTransaccionesEq set
					BTEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.BTEcodigo#">,
					BTEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.BTEdescripcion2#">,
					BTid = <cfqueryparam cfsqltype="cf_sql_char" value="#form.BTid#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form._Bid#">				  
				  and BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form._BTid#">
				  and BTEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form._BTEcodigo#">
			</cfquery>
			<cfset modo="CAMBIO">				  				  
		</cfif>			
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
<cfelse>
	<cfset form.BTEcodigo = "">
</cfif>
<!---invo--->
<form action="<cfoutput>#LvarTBEquiva#</cfoutput>" method="post" name="sql">
	<cfoutput>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'ALTA'>
		<input name="Bid" type="hidden" value="<cfif isdefined("Form.Bid")>#Form.Bid#</cfif>">
		<input name="BTid" type="hidden" value="<cfif isdefined("Form.BTid")>#Form.BTid#</cfif>">
		<input name="BTEcodigo" type="hidden" value="<cfif isdefined("Form.BTEcodigo") and LEN(form.BTEcodigo) GT 0>#Form.BTEcodigo#</cfif>">	
	<cfelseif modo NEQ 'ALTA'>
		<input name="Bid" type="hidden" value="<cfif isdefined("Form._Bid")>#Form._Bid#</cfif>">
		<input name="BTid" type="hidden" value="<cfif isdefined("Form._BTid")>#Form._BTid#</cfif>">
		<input name="BTEcodigo" type="hidden" value="<cfif isdefined("Form._BTEcodigo") and LEN(form._BTEcodigo) GT 0>#Form._BTEcodigo#</cfif>">	
	
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
	</cfoutput>
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

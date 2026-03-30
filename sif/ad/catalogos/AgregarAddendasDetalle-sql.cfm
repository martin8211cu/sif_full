<cfset modo = 'ALTA'>

<cfif not isdefined("Form.Nuevo")>
    <cfif isdefined("Form.Alta")>
        <cfquery name="rsAlta" datasource="#Session.DSN#">
			insert into AddendasDetalle (ADDid, CODIGO, VALOR, TIPO)
			values(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ADDid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CodigoDetalle#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ValorDetalle#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TipoDetalle#">			 
			)
		</cfquery>
		<cfset modo="ALTA">
    <cfelseif isdefined("Form.Baja")>
		<cfquery name="rsBaja" datasource="#Session.DSN#">
			delete from AddendasDetalle
			where ADDDetalleid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ADDDetalleid#">
		    and ADDid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ADDid#">
		</cfquery>
		<cfset modo="BAJA">
    <cfelseif isdefined("Form.Cambio")>
			<cfquery name="rsCambio" datasource="#Session.DSN#">
				update AddendasDetalle set
			    CODIGO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CodigoDetalle#">,
                VALOR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ValorDetalle#">,
                TIPO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TipoDetalle#">
				where ADDDetalleid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ADDDetalleid#">
		        and ADDid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ADDid#">
			</cfquery>		
		<cfset modo="CAMBIO">
    </cfif>
</cfif>

<form action="AgregarAddendasDetalle.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
    <input name="ADDid" type="hidden" value="<cfif isdefined("form.ADDid")>#form.ADDid#</cfif>">
    <input name="ADDDetalleid" type="hidden" value="<cfif isdefined("form.ADDDetalleid")>#form.ADDDetalleid#</cfif>">
</cfoutput>		
</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>

<!---
<cfoutput>#form.CodigoDetalle#</cfoutput>
<cfoutput>#form.ValorDetalle#</cfoutput>
<cfoutput>#form.ADDid#</cfoutput>
<cfoutput>#form.ADDDetalleid#</cfoutput>
--->
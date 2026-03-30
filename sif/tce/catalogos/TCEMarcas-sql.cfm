<cfset modo = 'ALTA'>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>

		<cfif isdefined("form.CBTTid") and len(form.CBTTid) gt 0>
			<cfset Var_Tipo = form.CBTTid>
		<cfelse>		
		
		</cfif>
		<!--- insertar un tipo de tarjeta--->
		<cfquery name="rsAlta" datasource="#Session.DSN#">
			insert into CBTMarcas (CBTMarca, CBTMascara, BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBTMarca#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBTMascara#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			)
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
	<!--- Verificar que la marca de Tarjeta no este relacionado con ninguna tarjeta de Credito --->
    	<cfquery name="rsTCESQL" datasource="#session.dsn#">
            select count(1) as cantidad
            from CBTarjetaCredito
            where CBTMid = <cfqueryparam value="#Form.CBTMid#" cfsqltype="cf_sql_numeric">
        </cfquery>
		<cfif rsTCESQL.cantidad EQ 0>
			<!---borrar la marca de tarjeta--->
            <cfquery name="rsBaja" datasource="#Session.DSN#">
                delete from CBTMarcas
                    where CBTMid = <cfqueryparam value="#Form.CBTMid#" cfsqltype="cf_sql_numeric">
            </cfquery>
            <cfset modo="BAJA">
        <cfelse>
        	<cf_errorCode	code = "90210" msg = "La marca de tarjeta seleccionada, esta asociada a una Tarjeta de Cr&eacute;dito! Proceso Cancelado!">
        </cfif>
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="CBTMarcas" 
			redirect="TCEMarcas.cfm"
			timestamp="#form.ts_rversion#"		
			field1="CBTMid" 
			type1="numeric" 
			value1="#form.CBTMid#">		
			
	<!--- actualiza el tipo de tarjeta---->		

		<cfquery name="rsCambio" datasource="#Session.DSN#">
			update CBTMarcas set 
				CBTMarca    = <cfqueryparam value="#Form.CBTMarca#" cfsqltype="cf_sql_varchar">,
				CBTMascara    = <cfqueryparam value="#Form.CBTMascara#" cfsqltype="cf_sql_varchar">, 
				BMUsucodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where CBTMid = <cfqueryparam value="#Form.CBTMid#" cfsqltype="cf_sql_numeric">
		</cfquery>	
	
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<form action="TCEMarcas.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="CBTMid" type="hidden" value="<cfif isdefined("Form.CBTMid") and modo NEQ 'ALTA'>#Form.CBTMid#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</cfoutput>		
</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>

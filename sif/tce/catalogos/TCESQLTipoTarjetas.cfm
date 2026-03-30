
<cfset modo = 'ALTA'>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>

		<cfif isdefined("form.CBTTid") and len(form.CBTTid) gt 0>
			<cfset Var_Tipo = form.CBTTid>
		<cfelse>		
		
		</cfif>
		<!--- insertar un tipo de tarjeta--->
		<cfquery name="rsAlta" datasource="#Session.DSN#">
			insert into CBTipoTarjetaCredito (Ecodigo, CBTTDescripcion, CBTTcodigo, BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBTTDescripcion#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBTTcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			)
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<!--- Verificar que el tipo de Tarjeta no este relacionado con ninguna tarjeta de Credito --->
    	<cfquery name="rsTCESQL" datasource="#session.dsn#">
            select count(1) as cantidad
            from CBTarjetaCredito
            where CBTTid = <cfqueryparam value="#Form.CBTTid#" cfsqltype="cf_sql_numeric">
        </cfquery>
        <cfif rsTCESQL.cantidad EQ 0>
		<!---borrar el tipo de tarjeta--->
            <cfquery name="rsBaja" datasource="#Session.DSN#">
                delete from CBTipoTarjetaCredito
                where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
                    and CBTTid = <cfqueryparam value="#Form.CBTTid#" cfsqltype="cf_sql_numeric">
            </cfquery>
            <cfset modo="BAJA">
        <cfelse>
        	<cf_errorCode	code = "90210" msg = "El tipo de tarjeta seleccionado, esta asociado a una Tarjeta de Cr&eacute;dito! Proceso Cancelado!">
        </cfif>
	<cfelseif isdefined("Form.Cambio")>
		<!---<cf_dbtimestamp
			datasource="#session.dsn#"
			table="CBTipoTarjetaCredito" 
			redirect="TCETipoTarjetas.cfm"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo,integer,#session.Ecodigo#"			
			field2="CBTTid,integer,#form.CBTTid#">	--->		
			
	<!--- actualiza el tipo de tarjeta---->		
			
		<cfquery name="rsCambio" datasource="#Session.DSN#">
			update CBTipoTarjetaCredito set
				CBTTDescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBTTDescripcion#">, 
                CBTTcodigo      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBTTcodigo#">,
				BMUsucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where Ecodigo       = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and CBTTid      = <cfqueryparam value="#Form.CBTTid#" cfsqltype="cf_sql_numeric">
		</cfquery>	
	
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<form action="TCETipoTarjetas.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="CBTTid" type="hidden" value="<cfif isdefined("Form.CBTTid") and modo NEQ 'ALTA'>#Form.CBTTid#</cfif>">
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

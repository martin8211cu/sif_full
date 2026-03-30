
<cfset modo = 'ALTA'>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>

	 	<cfquery name="rsVerificarCodigo" datasource="#session.dsn#">
            select count(1) as cantidad
            from RH_OtrosPatronos
            where OPcodigo = <cfqueryparam value="#Form.OPcodigo#" cfsqltype="cf_sql_varchar">
			and 	Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        </cfquery>
		
		<cfif rsVerificarCodigo.cantidad EQ 0>
		<!--- insertar ---->
		<cfquery name="rsAlta" datasource="#Session.DSN#">
			insert into RH_OtrosPatronos (OPcodigo, OPdescripcion, Ecodigo, BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OPcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OPdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
		</cfquery>
        <cfelse>
    			<cfset errs="El c&oacute;digo de Patrono <b>'#Form.OPcodigo#'</b> que desea insertar ya existe.<br>Por favor digite otro c&oacute;digo">
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrTitle=#URLEncodedFormat('Acci&oacute;n No permitida')#&ErrMsg=Se ha presentado el siguiente inconveniente:<br>&ErrDet=#URLEncodedFormat(errs)#" addtoken="no">
				<cfabort>
        </cfif>
		

		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
    	<cfquery name="rsVerificar" datasource="#session.dsn#">
            select count(1) as cantidad
            from SalariosOtrosPatronos
            where OPid = <cfqueryparam value="#Form.OPid#" cfsqltype="cf_sql_numeric">
        </cfquery>
        <cfif rsVerificar.cantidad EQ 0>
            <cfquery name="rsBaja" datasource="#Session.DSN#">
                delete from RH_OtrosPatronos
                where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
                    and OPid = <cfqueryparam value="#Form.OPid#" cfsqltype="cf_sql_numeric">
            </cfquery>
            <cfset modo="BAJA">
        <cfelse>
    			<cfset errs="El patrono que desea eliminar est&aacute; asociado a alg&uacute;n empleado, por lo tanto no puede eliminarlo">
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrTitle=#URLEncodedFormat('Acci&oacute;n No permitida')#&ErrMsg=No puede eliminar este Patrono<br>&ErrDet=#URLEncodedFormat(errs)#" addtoken="no">
				<cfabort>
        </cfif>
	<cfelseif isdefined("form.Cambio")>
		<cfquery name="rsCambio" datasource="#Session.DSN#">
			update RH_OtrosPatronos set
				OPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OPcodigo#">, 
                OPdescripcion      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OPdescripcion#">,
				BMUsucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where Ecodigo       = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and OPid      = <cfqueryparam value="#form.OPid#" cfsqltype="cf_sql_numeric">
		</cfquery>	
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<form action="MantOtrosPatronos.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="OPid" type="hidden" value="<cfif isdefined("Form.OPid") and modo NEQ 'ALTA'>#Form.OPid#</cfif>">
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

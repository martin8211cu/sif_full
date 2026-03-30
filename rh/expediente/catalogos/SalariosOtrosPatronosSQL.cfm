<cfif isdefined ('form.DAlta') and Form.DAlta eq "Agregar">
		<cfquery name="rs1" datasource="#session.dsn#">
			select 1
			from SalariosOtrosPatronos 
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			and OPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OPid#">
		</cfquery>
		
		<cfif rs1.RecordCount GT 0>
		<cfset Errs="El Empleado <b>#form.nombreemp#</b> ya existe asociado al Patrono que intenta registrar <br><br><u>Sugerencia</u>: Busque al empleado filtrando por identificaci&oacute;n y Patrono, seguidamente modifique el monto correspondiente">
		<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrTitle=#URLEncodedFormat('Acci&oacute;n No permitida')#&ErrMsg=No puede duplicar un registro:<br>&ErrDet=#URLEncodedFormat(Errs)#" addtoken="no">
		<cfabort>
		
		<cfelse>

		<cfset LvarTC = replace(form.SalarioBase,",","","ALL")>
		<cftransaction>
		<cfquery name="rs" datasource="#session.dsn#">
			Insert into SalariosOtrosPatronos(DEid,OPid,SalarioBase, Ecodigo, BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OPid#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#LvarTC#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
		</cfquery>
		</cftransaction>
		</cfif>
		<cfset form.modo="ALTA">
</cfif>
<cfif isdefined ('form.DCambio') and Form.DCambio eq "Modificar">	
	<cfset LvarTC = replace(form.SalarioBase,",","","ALL")>
	<cftransaction>
	<cfquery name="rs" datasource="#session.dsn#">
			UPDATE SalariosOtrosPatronos
			SET 
				OPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OPid#">,
				SalarioBase = <cfqueryparam cfsqltype="cf_sql_money" value="#LvarTC#">, 
				Ecodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				BMUsucodigo=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">

			WHERE
				DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				and OPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.OPid#">
		</cfquery>
		</cftransaction>
</cfif>


<cfif isdefined("form.btnEliminar")><!---BORRAR INCIDENCIA---->
		<cfif isdefined("form.chk") and len(trim(form.chk)) >
			<cfloop list="#form.chk#" index="i">
				<cftransaction>
				<cfset vnDatos = ListToArray(i,'|')>	
				<cfset varDEid=vnDatos[3]>
				<cfset varOPid=vnDatos[8]>
					<cfquery datasource="#session.DSN#">
					DELETE 
					FROM SalariosOtrosPatronos
					WHERE DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#varDEid#">
						and OPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#varOPid#">
					</cfquery>		
				</cftransaction>
			</cfloop>
		</cfif>
</cfif>
		
<cfif isdefined ('form.modo') and Form.modo eq "BAJA">
	<cftransaction>
	<cfquery datasource="#session.dsn#">
		DELETE FROM SalariosOtrosPatronos
		where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	</cfquery>
	</cftransaction>
</cfif>

<form action="SalariosOtrosPatronos.cfm" method="post" name="SQLform">

</form>
<html>
<head>
<title>Salarios Otros Patronos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<script language="JavaScript" type="text/javascript">document.SQLform.submit();</script>
</body>
</html>

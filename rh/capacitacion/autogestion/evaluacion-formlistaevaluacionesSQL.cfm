<cfif isdefined("form.BOTON") and form.BOTON EQ 'Terminar'>
	<cfif isdefined("form.chk") and len(form.chk) gt 0>
		<cfset arrRHCRids = ListToArray(form.chk)>
		<cfloop from="1" to="#ArrayLen(arrRHCRids)#" index="i">
			<cfquery datasource="#session.dsn#">
				update RHEvaluadoresCalificacion
					set RHECestado = 10
				from UsuarioReferencia u
				where RHEvaluadoresCalificacion.RHRCid = #arrRHCRids[i]#
					and RHEvaluadoresCalificacion.DEid = convert(numeric,u.llave)
					and u.STabla = 'DatosEmpleado'
					and u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					and u.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigosdc#">
			</cfquery>
		</cfloop>
	</cfif>
</cfif>
<cflocation url="evaluacion.cfm">
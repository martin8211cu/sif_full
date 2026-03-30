
	<cfif isDefined("form.RHIid6")>
		<cfquery name="rs6" datasource="#session.DSN#">
		update RHInconsistencias
		set 
			<cfif isDefined("form.check6")>
				RHIjustificada = 1
			<cfelse>
				RHIjustificada = 0
			</cfif>
			
			<cfif isDefined("form.justificacion6")>
			,RHIjustificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.justificacion6)#">
			</cfif>
			
		where  RHIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid6#">
		</cfquery>
	</cfif>
	
	<cfif isDefined("form.RHIid7")>
		<cfquery name="rs7" datasource="#session.DSN#">
		update RHInconsistencias
		set 
			<cfif isDefined("form.check7")>
				RHIjustificada = 1
			<cfelse>
				RHIjustificada = 0
			</cfif>
			
			<cfif isDefined("form.justificacion7")>
			,RHIjustificacion =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.justificacion7)#">
			</cfif>
			
		where  RHIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid7#">
		</cfquery>
	</cfif>
	
	<script language="JavaScript1.2" type="text/javascript">
	window.opener.location.reload();
	window.close();
	</script>
	
<!--- <cflocation url="DetalleInconsistenciasJsemanales.cfm?RHCMid=#form.RHCMid#"> --->

<!--- <cfquery name="rsJustificadas" datasource="#session.DSN#">
		select RHIid
		from RHInconsistencias 
		where  RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
		and  RHIjustificada = 0
</cfquery>
<cfif rsJustificadas.RecordCount EQ 0>
	<cfquery name="rsUpdate" datasource="#session.DSN#">
		Update RHControlMarcas
		set RHCMinconsistencia = 0
		where  RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
	</cfquery>
	
	<script language="JavaScript1.2" type="text/javascript">
	window.opener.location.reload();
	window.close();
	</script>
	
<cfelse>
	<cflocation url="DetalleInconsistenciasJsemanales.cfm?RHCMid=#form.RHCMid#">
</cfif>  --->



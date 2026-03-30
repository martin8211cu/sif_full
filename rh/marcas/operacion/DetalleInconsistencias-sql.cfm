
<cfif isDefined("form.RHIid0")>
		<cfquery name="rs0" datasource="#session.DSN#">
		update RHInconsistencias
		set 
			<cfif isDefined("form.check0")>
				RHIjustificada = 1
			<cfelse>
				RHIjustificada = 0
			</cfif>
			
			<cfif isDefined("form.justificacion0")>
			,RHIjustificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.justificacion0)#">
			</cfif>
			
		where  RHIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid0#">
		</cfquery>
</cfif>

<cfif isDefined("form.RHIid1")>
		<cfquery name="rs1" datasource="#session.DSN#">
		update RHInconsistencias
		set 
			<cfif isDefined("form.check1")>
				RHIjustificada = 1
			<cfelse>
				RHIjustificada = 0
			</cfif>
			
			<cfif isDefined("form.justificacion1")>
			,RHIjustificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.justificacion1)#">
			</cfif>
			
		where  RHIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid1#">
		</cfquery>
</cfif>

<cfif isDefined("form.RHIid2")>
		<cfquery name="rs2" datasource="#session.DSN#">
		update RHInconsistencias
		set 
			<cfif isDefined("form.check2")>
				RHIjustificada = 1
			<cfelse>
				RHIjustificada = 0
			</cfif>
			
			<cfif isDefined("form.justificacion2")>
			,RHIjustificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.justificacion2)#">
			</cfif>
			
		where  RHIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid2#">
		</cfquery>
</cfif>
<cfif isDefined("form.RHIid3")>
		<cfquery name="rs3" datasource="#session.DSN#">
		update RHInconsistencias
		set 
			<cfif isDefined("form.check3")>
				RHIjustificada = 1
			<cfelse>
				RHIjustificada = 0
			</cfif>
			
			<cfif isDefined("form.justificacion3")>
			,RHIjustificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.justificacion3)#">
			</cfif>
			
		where  RHIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid3#">
		</cfquery>
</cfif>
<cfif isDefined("form.RHIid4")>
		<cfquery name="rs4" datasource="#session.DSN#">
		update RHInconsistencias
		set 
			<cfif isDefined("form.check4")>
				RHIjustificada = 1
			<cfelse>
				RHIjustificada = 0
			</cfif>
			
			<cfif isDefined("form.justificacion4")>
			,RHIjustificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.justificacion4)#">
			</cfif>
			
		where  RHIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid4#">
		</cfquery>
</cfif>
<cfif isDefined("form.RHIid5")>
		<cfquery name="rs5" datasource="#session.DSN#">
		update RHInconsistencias
		set 
			<cfif isDefined("form.check5")>
				RHIjustificada = 1
			<cfelse>
				RHIjustificada = 0
			</cfif>
			
			<cfif isDefined("form.justificacion5")>
			,RHIjustificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.justificacion5)#">
			</cfif>
			
		where  RHIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid5#">
		</cfquery>
</cfif>
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
			,RHIjustificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.justificacion7)#">
			</cfif>
			
		where  RHIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIid7#">
		</cfquery>
</cfif>

<!--- <cflocation url="DetalleInconsistencias.cfm?RHCMid=#form.RHCMid#"> --->


<cfquery name="rsJustificadas" datasource="#session.DSN#">
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
	<cflocation url="DetalleInconsistencias.cfm?RHCMid=#form.RHCMid#">
</cfif> 



<!---  --->


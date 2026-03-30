<cfif isdefined ('form.RechazarDet')>
	<cfquery name="rec" datasource="#session.dsn#">
		update RHEmpleadoCurso 
		set RHECestado=20,
		RHECjustRechazo='#form.just#'
		where RHECid=#form.RHECid#
	</cfquery>

</cfif>
<cfif isdefined ('form.Aprobar')>
	<cfif isdefined('form.chk')>
		<cfloop list="#form.chk#" index="LvarRHECid">
			<cfquery name="rsVerif" datasource="#session.dsn#">
				select c.RHCid from RHEmpleadoCurso ec
				inner join RHCursos c
				on c.RHCid=ec.RHCid
				and ec.RHECid=#LvarRHECid#
				and c.RHCfdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> 
			</cfquery>
			<cfif len(trim(rsVerif.RHCid)) gt 0>
				<cfthrow message="No se puede realizar el proceso de aprobación debido a que el curso ya fue iniciado. Proceso Cancelado!!">
			</cfif>
			<cfquery name="rec" datasource="#session.dsn#">
				update RHEmpleadoCurso 
				set RHECestado=30
				where RHECid=#LvarRHECid#
			</cfquery>
		</cfloop>
	</cfif>
	<cflocation url="apruebaMatricula.cfm">
</cfif>
<script language="JavaScript" type="text/javascript">
		<cfoutput>
		if (window.opener.document.form1) {
			if (window.opener.document.form1.reloadPage)
			window.opener.document.form1.reloadPage.value = "1";
			window.opener.document.form1.action = '';
			window.opener.document.form1.submit();
			window.close();
		}
		</cfoutput>
	</script>


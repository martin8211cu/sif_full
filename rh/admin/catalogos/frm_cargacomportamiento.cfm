<cfif isdefined("url.RHCOid") and len(trim(url.RHCOid))>
	<cfquery name="rsComportamiento" datasource="#session.DSN#">
		select 	a.RHCOid, a.RHCOcodigo, a.RHCOdescripcion, a.RHCOpeso,
				b.RHGNid, b.RHGNcodigo, b.RHGNdescripcion 
		from RHComportamiento a 	
			inner join RHGrupoNivel b
				on a.RHGNid = b.RHGNid
		where RHCOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCOid#">
	</cfquery>
	<cfoutput>
		<cfif rsComportamiento.RecordCount NEQ 0>
			<script type="text/javascript">
				window.parent.document.form1.RHCOid.value = '#rsComportamiento.RHCOid#';
				window.parent.document.form1.RHCOcodigo.value = '#JSStringFormat(rsComportamiento.RHCOcodigo)#';
				window.parent.document.form1.RHCOdescripcion.value = '#JSStringFormat(rsComportamiento.RHCOdescripcion)#';
				window.parent.document.form1.RHCOpeso.value = '#LSNumberFormat(rsComportamiento.RHCOpeso,"99.99")#';
				window.parent.document.form1.RHGNid.value = '#JSStringFormat(rsComportamiento.RHGNid)#';
				window.parent.document.form1.RHGNcodigo.value = '#JSStringFormat(rsComportamiento.RHGNcodigo)#';
				window.parent.document.form1.RHGNdescripcion.value = '#JSStringFormat(rsComportamiento.RHGNdescripcion)#';
			</script>
		</cfif>
	</cfoutput>
</cfif>
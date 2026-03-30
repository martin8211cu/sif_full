<cfif isdefined("form.id_inst") and len(trim(form.id_inst))>
	<cfquery name="inst" datasource="#session.tramites.dsn#">
		select codigo_inst, nombre_inst
		from TPInstitucion
		where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
	</cfquery>
	<cfoutput>
		<table width="100%" cellpadding="5" cellspacing="0" bgcolor="##CCCCCC" border="0" style="border:1px solid black">
		  <tr>
			<td align="center" valign="middle">
				<font size="3" color="##003399">
				<strong>Instituci&oacute;n:&nbsp;#trim(inst.codigo_inst)# - #inst.nombre_inst#</strong>
				</font>
			</td>
		  </tr>
		</table>
	</cfoutput>
</cfif>

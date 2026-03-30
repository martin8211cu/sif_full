<cfquery name="rsInfoGeneral" datasource="#Session.DSN#">
	select a.Ecodigo, a.METSid, a.MESid, b.METSdesc, c.MESdesc, d.METEetiq, e.METEdesc, isnull(count(f.MEEid),0) as cantidadEntidades
	from MEServicioEmpresa a, METipoServicio b, MEServicio c, MEServicioEntidad d, METipoEntidad e, MEEntidad f
	where c.MESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MESid#">
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and e.METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
	  and f.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and b.METSid = a.METSid
	  and c.MESid = a.MESid
	  and d.MESid = c.MESid
	  and d.METEid = e.METEid
	  and f.METEid =* e.METEid
	group by a.Ecodigo, a.METSid, a.MESid, b.METSdesc, c.MESdesc, d.METEetiq, e.METEdesc
</cfquery>
<cfoutput>
<FONT face="arial, helvetica, verdana" size=2>Su #rsInfoGeneral.METSdesc# hoy en d&iacute;a cuenta con #rsInfoGeneral.cantidadEntidades# #rsInfoGeneral.METEdesc#.</FONT><br>
<br>
</cfoutput>
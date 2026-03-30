<!---<cfoutput>#url.METRid#-#url.MEEidentificacion2#</cfoutput>--->
<cfif isdefined("url.METRid") and Len(Trim(url.METRid)) NEQ 0 and isdefined("url.MEEidentificacion2") and Len(Trim(url.MEEidentificacion2)) NEQ 0>
	<cfquery name="rsEntidadRel" datasource="#url.conexion#">
		<cfif url.METRid neq "-1">
			select convert(varchar, c.MEEid) as MEEid2, c.MEEidentificacion, c.MEEapellido1 + ' ' + c.MEEapellido2 + ' ' + c.MEEnombre as NombreCompleto, b.METEid, b.METEdesc, a.METRid, a.MERPdescripcion
			from MERelacionesPermitidas a, METipoEntidad b, MEEntidad c
			where a.METRid = #url.METRid# --Relacion
			and c.MEEidentificacion = '#url.MEEidentificacion2#' --Identificación
			and a.METEidrel = b.METEid
			and b.METEid = c.METEid
			order by c.MEEapellido1, c.MEEapellido2, c.MEEnombre
		<cfelse>
			select convert(varchar, c.MEEid) as MEEid2, c.MEEidentificacion, c.MEEapellido1 + ' ' + c.MEEapellido2 + ' ' + c.MEEnombre as NombreCompleto
			from MEEntidad c
			where c.MEEidentificacion = '#url.MEEidentificacion2#' --Identificación
			order by c.MEEapellido1, c.MEEapellido2, c.MEEnombre
		</cfif>
	</cfquery>
	<cfoutput>
	<script language="JavaScript" type="text/javascript">
	<cfif rsEntidadRel.Recordcount>
		parent.ctlMEEid2.value = "#rsEntidadRel.MEEid2#";
		parent.ctlMEEidentificacion2.value = "#rsEntidadRel.MEEidentificacion#";
		parent.ctlMEEnombre2.value = "#rsEntidadRel.NombreCompleto#";
	<cfelse>
		parent.ctlMEEid2.value = "";
		parent.ctlMEEidentificacion2.value = "";
		parent.ctlMEEnombre2.value = "";
	</cfif>
	</script>
	</cfoutput>
</cfif>

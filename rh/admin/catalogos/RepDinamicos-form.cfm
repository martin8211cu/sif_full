<cfif isdefined("url.Cid") and len(trim(url.Cid)) gt 0>
	<cfset form.Cid=url.Cid>
</cfif>
<cfif isdefined("url.modoD") and len(trim(url.modoD)) gt 0>
	<cfset modoD=url.modoD>
</cfif>
<cfif isdefined('form.Cid') and len(trim(form.Cid)) gt 0 and modoD NEQ 'ALTA'>
	<cfquery name="rsFormD" datasource="#session.DSN#">
		select *
		from RHReportesDinamicoC
		where Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
	</cfquery>
</cfif>
<cfoutput>
<form name="form2" action="RepDinamicos-sql.cfm" method="post">
	<cfoutput>
    <input name="RHRDEid" type="hidden" value="<cfif isdefined('form.RHRDEid')>#form.RHRDEid#</cfif>">
    <input name="Cid" type="hidden" value="<cfif isdefined('form.Cid')>#form.Cid#</cfif>">
    </cfoutput>

<table width="100%" cellpadding="0" cellspacing="0">

	<tr>
   		<td align="right"><strong>#LB_DESCRIPCION#:</strong>&nbsp;</td>
        <td><input name="Cdescripcion" type="text" tabindex="1" size="60" value="<cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA'>#rsFormD.Cdescripcion#</cfif>"></td>
    </tr>
	<tr>
   		<td align="right"><strong>#LB_TIPO#:</strong>&nbsp;</td>
        <td>
			<cfif modoD neq 'CAMBIO'>
			 <select name="Ctipo"  <cfif modoD eq 'CAMBIO'>disabled="disabled"</cfif>>
			 	<option value="2" <cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA' and rsFormD.Ctipo eq 2>selected="selected"</cfif>>#LB_Empleado#</option>
				<option value="3" <cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA' and rsFormD.Ctipo eq 3>selected="selected"</cfif>>#LB_Nomina#</option>
				<option value="4" <cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA' and rsFormD.Ctipo eq 4>selected="selected"</cfif>>#LB_InformacionSalarial#</option>
				<option value="1" <cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA' and rsFormD.Ctipo eq 1>selected="selected"</cfif>>#LB_Sumarizar#</option>
				<option value="20" <cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA' and rsFormD.Ctipo eq 20>selected="selected"</cfif>>#LB_Totalizar#</option>
				<option value="10" <cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA' and rsFormD.Ctipo eq 10>selected="selected"</cfif>>#LB_Formular#</option>
				
			 </select> 
		 	<cfelse>
			
			 	<cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA' and rsFormD.Ctipo eq 1><cfset LB_Tipo ='#LB_Sumarizar#'></cfif>
			 	<cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA' and rsFormD.Ctipo eq 2><cfset LB_Tipo ='#LB_Empleado#'></cfif>
				<cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA' and rsFormD.Ctipo eq 3><cfset LB_Tipo ='#LB_Nomina#'></cfif>
				<cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA' and rsFormD.Ctipo eq 4><cfset LB_Tipo ='#LB_InformacionSalarial#'></cfif>
				<cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA' and rsFormD.Ctipo eq 10><cfset LB_Tipo ='#LB_Formular#'></cfif>
				<cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA' and rsFormD.Ctipo eq 20><cfset LB_Tipo ='#LB_Totalizar#'></cfif>
				#LB_Tipo#
				<input type="hidden" name="Ctipo" value="#rsFormD.Ctipo#" />
			</cfif>
		</td>
    </tr>
	<tr>
   		<td align="right">&nbsp;</td>
        <td><input name="Cmostrar" type="checkbox" <cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA' and rsFormD.Cmostrar eq 0><cfelse>checked="checked"</cfif>><strong>#LB_MOSTRAR#:</strong>&nbsp;</td>
    </tr>
	<tr>
   		<td align="right"><strong>#LB_ORDEN#:</strong>&nbsp;</td>
		<cfset maxOrden = 1>
		<cfquery name="rsMaxOrden" datasource="#session.DSN#">
			select  max(Corden)+1 as ultimoOrden
			from RHReportesDinamicoC
			where RHRDEid = #form.RHRDEid#
		</cfquery>
		<cfif rsMaxOrden.recordcount and len(trim(rsMaxOrden.ultimoOrden)) gt 0>
			<cfset maxOrden = rsMaxOrden.ultimoOrden>
		</cfif>
        <td><input name="Corden" type="text" tabindex="1" size="2" value="<cfif modo NEQ 'ALTA' and modoD NEQ 'ALTA'>#rsFormD.Corden#<cfelse>#maxOrden#</cfif>"></td>
    </tr>
    <tr>
    	<td colspan="2"><cf_botones modo="#modoD#" sufijo='D' form="form2" tabindex="1"></td>
    </tr>
	<cfif modoD eq 'CAMBIO'>
    <tr>
    	<td colspan="2" align="center"><input type="submit" class="btnNormal" name="btnConfigurarColumna" value="#LB_ConfigurarColumna#" /> </td>
    </tr>
	</cfif>
    <tr>
    	<td colspan="2">&nbsp;</td>
   </tr>
</table>
</form>
</cfoutput>
<cf_qforms form="form2"  objForm='objForm2'>
  <cf_qformsrequiredfield args="Cdescripcion,#MSG_DESCRIPCION#">
  <cf_qformsrequiredfield args="Corden,#LB_ORDEN#">
</cf_qforms>
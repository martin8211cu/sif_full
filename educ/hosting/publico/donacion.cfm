<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Donaciones
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="pMenu.cfm">
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navBarItems = ArrayNew(1)>
	<cfset navBarLinks = ArrayNew(1)>
	<cfset navBarStatusText = ArrayNew(1)>
		
	<cfinclude template="pNavegacion.cfm">

<!---
	<cfif isdefined("session.MEEid") and Len(session.MEEid) NEQ 0 and session.MEEid NEQ 0>
		<cfquery name="donaciones" datasource="#session.dsn#" >
			select a.MEDdonacion, a.MEDfecha, a.MEDimporte, a.MEDmoneda, coalesce(c.MEEnombre, 'Anónimo') as MEEnombre,
				a.MEDforma_pago, a.MEDdescripcion, b.MEDnombre
			from MEDDonacion a, MEDProyecto b, MEEntidad c
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a.MEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.MEEid#" >
			  and a.MEDproyecto = b.MEDproyecto
			  and (a.MEDforma_pago = 'S' or a.MEDimporte != 0)
			  and c.MEEid =* a.MEEid
			order by MEDfecha desc
		</cfquery>
		<cfif donaciones.RecordCount eq 0 >
			<cflocation url="donacion_registro2.cfm">
		</cfif>
	</cfif>
--->

	<table width="89%" border="0" cellpadding="0" cellspacing="0" >
    	<tr>
    	  <td width="1%" nowrap><font size="2">&nbsp;<img src="/cfmx/sif/imagenes/Computer01_T2.gif" width="31" height="31"></font></td>
    	  <td colspan="2" nowrap><font size="2"><b>Operaciones</b></font></td>
    	  <td width="1%" nowrap><font size="2"><img src="/cfmx/sif/imagenes/Graficos02_T.gif"></font></td>
    	  <td colspan="2" nowrap><font size="2"><b>Consultas</b></font></td>
   	  </tr>
    	<tr>
    	  <td width="1%" nowrap>&nbsp;</td>
    	  <td width="1%" align="right" valign="middle" nowrap ><a href="donacion_registro.cfm"><img src="/cfmx/sif/imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
    	  <td valign="middle" nowrap><a href="donacion_registro.cfm">Registro de Donaciones</a></td>
    	  <td width="1%" nowrap>&nbsp;</td>
    	  <td width="1%" align="right" valign="middle" nowrap><a href="donacion_listado.cfm"><img src="/cfmx/sif/imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
    	  <td valign="middle" nowrap><a href="donacion_listado.cfm">Listado de Donaciones</a></td>


		<tr>
        	<td width="1%" nowrap>&nbsp;</td>
			<td align="right" valign="middle" nowrap>&nbsp;</td>
			<td valign="middle" nowrap>&nbsp;</td>
			<td width="1%" nowrap>&nbsp;</td>
			<td width="1%" align="right" valign="middle" nowrap>&nbsp;</td>
			<td valign="middle" nowrap>&nbsp;</td>
		</tr>

		<tr>
        	<td width="1%" nowrap>&nbsp;</td>
			<td valign="middle" nowrap>&nbsp;</a></td>		
			<td valign="middle" nowrap>&nbsp;</a></td>		
        	<td width="1%" nowrap>&nbsp;</td>
			<td width="1%" align="right" valign="middle" nowrap>&nbsp;</td>
			<td valign="middle" nowrap>&nbsp;</td>
		</tr>

	</table>
</cf_templatearea>
</cf_template>
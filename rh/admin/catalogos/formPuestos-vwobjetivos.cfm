	<!--- Consultas --->

<!--- Form --->

<cfquery name="rsForm" datasource="#session.DSN#">
<!--- 	select a.RHTPid, a.RHPcodigo, a.RHPdescpuesto, 
			a.RHOcodigo, b.RHOdescripcion, 
			a.RHTPid, c.RHTPdescripcion, 
			d.ts_rversion, d.RHDPobjetivos
	from RHPuestos a, RHOcupaciones b, RHTPuestos c, RHDescriptivoPuesto d
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
		and a.RHOcodigo*=b.RHOcodigo
		and a.RHTPid*=c.RHTPid
		and a.Ecodigo*=d.Ecodigo
		and a.RHPcodigo*=d.RHPcodigo --->
		
	select a.RHTPid, coalesce(a.RHPcodigoext, a.RHPcodigo) as RHPcodigoext, a.RHPcodigo, a.RHPdescpuesto, a.RHOcodigo, 
            b.RHOdescripcion, a.RHTPid, c.RHTPdescripcion,d.ts_rversion, d.RHDPobjetivos
	from RHPuestos a 
	left outer join  RHOcupaciones b
		on  (a.RHOcodigo = b.RHOcodigo) 
	left outer join RHTPuestos c
		on (a.RHTPid = c.RHTPid) 
	left outer join RHDescriptivoPuesto d 
		on (a.Ecodigo = d.Ecodigo and 
			   a.RHPcodigo = d.RHPcodigo)
	where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 and a.RHPcodigo= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
</cfquery>
<cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
	<tr> 
      <td colspan="2">
		<cfif len(trim(rsForm.RHDPobjetivos)) GT 0 >
			#trim(rsForm.RHDPobjetivos)#
		<cfelse>
				<cf_translate key="MSG_NoSeHaDefinido">No se ha definido</cf_translate>
		</cfif>
      </td>
    </tr>	
	<tr>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	</tr>
  </table>
</cfoutput>
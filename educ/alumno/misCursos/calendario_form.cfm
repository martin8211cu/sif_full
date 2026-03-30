<cfparam name="form.tipoRep" default="1">

<cfquery name="rsCalen" datasource="#Session.DSN#">
	Select convert(varchar,isnull(CEVfechaReal,CEVfechaPlan), 103) as Fecha
		, cce.CEcodigo
		, CEnombre
		, CEVnombre
		, CEVpeso
		, CCEporcentaje
	from  CursoConceptoEvaluacion cce
		, ConceptoEvaluacion ce
		, CursoEvaluacion cev
	where cce.Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and cce.CEcodigo=ce.CEcodigo
		and cce.Ccodigo=cev.Ccodigo
		and cce.PEcodigo=cev.PEcodigo
		and ce.CEcodigo=cev.CEcodigo
		<cfif form.tipoRep EQ 1>		<!--- Por Fecha --->
			order by isnull(CEVfechaReal,CEVfechaPlan)		
		<cfelseif form.tipoRep EQ 2>	<!--- Por Consepto de Evaluacion --->
			order by ce.CEcodigo,isnull(CEVfechaReal,CEVfechaPlan)
		</cfif>
</cfquery> 

<cfoutput>
	<form name="formCalendario" method="post" action="">
		<input type="hidden" name="Ccodigo" value="#form.Ccodigo#">
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
      <cfif isdefined('rsCalen') and rsCalen.recordCount GT 0>
        <tr>
          <td width="1%">&nbsp;</td>
          <td width="1%">&nbsp;</td>
          <td colspan="2"><input type="radio" name="tipoRep" onClick="javascript: tipoReporte(this);" value="1" <cfif form.tipoRep EQ 1> checked</cfif>>
        Por Fecha </td>
          <td colspan="2"><input type="radio" name="tipoRep" onClick="javascript: tipoReporte(this);" value="2" <cfif form.tipoRep EQ 2> checked</cfif>>
            Por Concepto de Evaluacion</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr bgcolor="##DBDBDB">
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td width="14%" align="center"><strong>Fecha</strong></td>
          <td width="35%" align="center"><strong>Contribuci&oacute;n (%)</strong></td>
          <td colspan="2" align="center"><strong>Actividades</strong></td>
        </tr>
        <cfset contri = 0>
        <cfset totContri = 0>
		<cfset totPorcen = 0>
		<cfset concepto = "">		
        <cfloop query="rsCalen">

			<cfset contri = (CEVpeso * CCEporcentaje) / 100> 			
			
          <cfif form.tipoRep EQ 1>	<!--- Por Fecha --->
			  <tr class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td align="center">#Fecha#</td>
				<td align="center" nowrap>#LSNumberFormat(CEVpeso,',9.00')# de #LSNumberFormat(CCEporcentaje,',9.00')# = #LSNumberFormat(contri,',9.00')# </td>
				<td colspan="2"><font color="##0000FF">#rsCalen.CEnombre#</font>- #rsCalen.CEVnombre#</td>
			  </tr>
		  <cfelse>	<!--- Por Concepto --->						  
            <cfif concepto NEQ rsCalen.CEcodigo>
              <cfset concepto = rsCalen.CEcodigo>
			  <cfif totContri NEQ 0 and totPorcen NEQ 0>
				<tr bgcolor="##CEBEA6">
					<td colspan="3">&nbsp;</td>
					<td align="center"><strong>#LSNumberFormat(totPorcen,',9.00')# = #LSNumberFormat(totContri,',9.00')#</strong></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>					
				</tr>
			  </cfif>			  
              <tr bgcolor="##D9DDBD">
                <td>&nbsp;</td>
                <td colspan="5"><strong>#rsCalen.CEnombre#</strong> (#CCEporcentaje#)</td>
              </tr>
				<cfset totContri = 0>
				<cfset totPorcen = 0>				
            </cfif>		  
			<cfset totContri = totContri + contri>
			<cfset totPorcen = totPorcen + CEVpeso>				
			
			<tr class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td align="center">#Fecha#</td>
				<td align="center">#LSNumberFormat(CEVpeso,',9.00')# = #LSNumberFormat(contri,',9.00')#</td>
				<td colspan="2">#CEVnombre#</td>
			</tr>			
          </cfif>
        </cfloop>
		  <cfif form.tipoRep EQ 2 and totContri NEQ 0 and totPorcen NEQ 0>
			<tr bgcolor="##CEBEA6">
				<td colspan="3">&nbsp;</td>
				<td align="center"><strong>#LSNumberFormat(totPorcen,',9.00')# = #LSNumberFormat(totContri,',9.00')#</strong></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>					
			</tr>
		  </cfif>		
        <cfelse>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td colspan="4" align="center"><strong>No existen registros de actividades
              para este curso.</strong></td>
        </tr>
      </cfif>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td width="28%">&nbsp;</td>
        <td width="21%">&nbsp;</td>
      </tr>
    </table>
  </form>
</cfoutput>

<script language="JavaScript" type="text/javascript">
	function tipoReporte(){
		document.formCalendario.submit();
	}
</script>
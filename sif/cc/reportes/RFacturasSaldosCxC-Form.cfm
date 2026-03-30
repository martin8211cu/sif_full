<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha Desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha Hasta','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Cliente','/sif/generales.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Documentos con saldo','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','/sif/generales.xml')>
<cfset LB_Todas = t.Translate('LB_Todos','Todas','/sif/generales.xml')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
<cfset LB_EnLinea = t.Translate('LB_EnLinea','En l&iacute;nea (HTML)')>

<!---<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select a.CCTcodigo, a.CCTdescripcion from CCTransacciones a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.CCTpago = 0
	order by CCTcodigo
</cfquery> --->


<cfif isdefined('form.SNcodigo') and LEN(TRIM(form.SNcodigo))>
	<cfquery name="rsSocio" datasource="#session.DSN#">
		select *
		from SNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		  and SNtiposocio  in ( 'A','C')
	</cfquery>
</cfif>



<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<form name="form1" method="post" action="RFacturaSaldosCxC-Sql.cfm"
	onSubmit="funcValidacionEmpty();return false;">

  <table width="80%" border="0" cellpadding="1" cellspacing="1" align="center">
	<tr>
	  <td colspan="6" nowrap>
	  </td>
	</tr>
	<tr>
	  <td nowrap>&nbsp;</td>
	  <td nowrap align="right"><strong><cfoutput>#LB_Fecha_Desde#:</cfoutput></strong>&nbsp;</td>
	  <td nowrap><cf_sifcalendario name="fechaIni" value="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1"></td>
	</tr>
	<tr>
	  <td nowrap>&nbsp;</td>
	  <td nowrap align="right"><strong><cfoutput>#LB_Fecha_Hasta#:</cfoutput></strong>&nbsp;</td>
	  <td nowrap><cf_sifcalendario name="fechaFin" value="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1"></td>
	</tr>
	<tr>
	  <td nowrap>&nbsp;</td>
	  <td nowrap align="right"><strong><cfoutput>#LB_SocioNegocio#:</cfoutput></strong>&nbsp;</td>
	  <td nowrap>
	  	<cfif isdefined('form.SNcodigo') and LEN(TRIM(form.SNcodigo))>
			<cf_sifsociosnegocios2 ClientesAmbos="SI" SNcodigo="SNcodigo" SNnombre="SNnombre" SNnumero="SNnumero" idquery="#rsSocio.SNcodigo#">
		<cfelse>
			<cf_sifsociosnegocios2 ClientesAmbos="SI" SNcodigo="SNcodigo" SNnombre="SNnombre" SNnumero="SNnumero" SNtiposocio ="C" >
		</cfif>
	  </td>
	</tr>
	<tr>
	  <td nowrap>&nbsp;</td>
	  <td align="right" nowrap><strong><cfoutput>#LB_Documento#:</cfoutput></strong>&nbsp;</td>
	 	<td nowrap>
		 <input type="text" name="Documento" id="Documento" value="">
		</td>
	</tr>
	<tr>
	<tr>
		<td nowrap>&nbsp;</td>
		<td align="right" nowrap><strong><cfoutput>#LB_Saldo#:</cfoutput></strong>&nbsp;</td>
		<td nowrap>
		 <input type="checkbox" name="Saldo" id="Saldo" value="1">
		</td>
	</tr>
    <cfoutput>
		<td nowrap>&nbsp;</td>
	  	<td nowrap align="right"><strong>#LB_Formato#</strong>&nbsp;</td>
	  	<td nowrap>
			<select name="formato" tabindex="1">
				<option value="html">#LB_EnLinea#</option>
				<option value="pdf">Adobe PDF</option>
				<option value="xls">Microsoft Excel</option>
			</select>
		</td>
    </cfoutput>
	</tr>
  <tr>
    <td colspan="4">&nbsp;</td>
	</tr>
  <tr>
	<td colspan="6">
		<cf_botones values="Consultar,Limpiar" tabindex="1">
		<!--- <div align="center">
			<input type="submit" name="Submit" value="Consultar">&nbsp;
			<input type="reset" name="Limpiar" value="Limpiar" >
		</div> --->
	</td>
  </tr>
  </table>
</form>


<cfoutput>
<cf_qforms form = 'form1'>
<script language="javascript" type="text/javascript">

objForm.SNcodigo.required=true;
	objForm.SNcodigo.description='#LB_SocioNegocio#';
	objForm.FechaI.required=true;
	objForm.FechaI.description='#LB_Fecha_Desde#';
	objForm.FechaF.required=true;
	objForm.FechaF.description='#LB_Fecha_Hasta#';


</script>


</cfoutput>
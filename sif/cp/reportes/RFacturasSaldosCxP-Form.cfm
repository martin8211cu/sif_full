<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha Desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha Hasta','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Documentos con saldo por Socio','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','/sif/generales.xml')>
<cfset LB_Todas = t.Translate('LB_Todos','Todas','/sif/generales.xml')> 
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
<cfset LB_EnLinea = t.Translate('LB_EnLinea','En l&iacute;nea (HTML)')> 


<cfif isdefined("url.formatos") and not isdefined("form.formatos")>
	<cfset form.formatos = url.formatos>
</cfif>

<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>

<cfif isdefined("url.fechaIni") and not isdefined("form.fechaIni")>
	<cfset form.fechaIni = url.fechaIni>
</cfif>

<cfif isdefined("url.fechaFin") and not isdefined("form.fechaFin")>
	<cfset form.fechaFin = url.fechaFin>
</cfif>

<cfif isdefined("url.LvarRecibo") and not isdefined("form.LvarRecibo")>
	<cfset form.LvarRecibo = url.LvarRecibo>
</cfif>

<cfif isdefined("url.chk_DocSaldo") and not isdefined("form.chk_DocSaldo")>
	<cfset form.chk_DocSaldo = url.chk_DocSaldo>
</cfif>

<cfif isdefined('form.SNcodigo') and LEN(TRIM(form.SNcodigo))>
	<cfquery name="rsSocio" datasource="#session.DSN#">
		select *
		from SNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		  and SNtiposocio  in ( 'A','P')
	</cfquery>
</cfif>

<cfquery name="rsOficinas" datasource="#session.DSN#">
	Select Ocodigo, Oficodigo, Odescripcion
	from Oficinas
	where Ecodigo = #Session.Ecodigo#
	order by Odescripcion
</cfquery>



<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<form name="form1" method="post" action="RFacturaSaldosCxP-Sql.cfm" 
	onSubmit="javascript:
		var f = document.form1; 
		f.SNnombre.disabled = false;">
				
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
			<cf_sifsociosnegocios2 SNcodigo="SNcodigo" SNnombre="SNnombre" SNnumero="SNnumero" idquery="#rsSocio.SNcodigo#">
		<cfelse>
			<cf_sifsociosnegocios2 SNcodigo="SNcodigo" SNnombre="SNnombre" SNnumero="SNnumero" SNtiposocio ="P" >
		
		</cfif>
	  </td>
	</tr>
	<tr>
	  <td nowrap>&nbsp;</td>
	  <td align="right" nowrap><strong><cfoutput>#LB_Documento#:</cfoutput></strong>&nbsp;</td>
	 	<td nowrap><cfoutput>
		 <input name="Documento" id="Documento" type="text" value="<cfif isdefined("form.Documento") and len(trim(form.Documento))>#form.Documento#</cfif>" size="50" tabindex="1">	   </cfoutput>
		</td>
	</tr>
	<tr>
		<td nowrap>&nbsp;</td>
		<td align="right" nowrap><strong>Oficina</strong>:</td>
		<td>
	        <select name="Ocodigo" id="Ocodigo" tabindex="1">
	        	<option value="-1">-- Todas --</option>
				<cfif isdefined('rsOficinas') and rsOficinas.recordCount GT 0>
	                <cfoutput query="rsOficinas">
	                    <option value="#rsOficinas.Ocodigo#">#rsOficinas.Odescripcion#</option>
	                </cfoutput>
	            </cfif>
			</select>
		</td>
	</tr>
	<tr>
		<td nowrap>&nbsp;</td>
		<td align="right" nowrap><strong><cfoutput>#LB_Saldo#:</cfoutput></strong>&nbsp;</td>
		<td nowrap> 
		<input type="checkbox" name="chk_DocSaldo" <cfif isdefined('form.chk_DocSaldo')>checked</cfif>   value="1" tabindex="1">&nbsp;	
		</td>
	</tr>
	<tr>
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
	objForm.fechaIni.required=true;
	objForm.fechaIni.description='#LB_Fecha_Desde#';
	objForm.fechaFin.required=true;
	objForm.fechaFin.description='#LB_Fecha_Hasta#';

function funcLimpiar()
{
	location.reload();
}
</script>


</cfoutput>



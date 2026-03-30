<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Futuros Abiertos'>

<!---Obtiene la lista de codigos ICTS de empresas relacionadas al Ecodigo Actual--->
<cfset Bpreicts = Application.dsinfo.preicts.schema>
<cfquery name="rsCodICTS" datasource="sifinterfaces">
	select CodICTS, b.acct_full_name
	from int_ICTS_SOIN a, #Bpreicts#..account b
	where EcodigoSDCSoin = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	and a.CodICTS = convert(varchar,b.acct_num)
</cfquery>

<cfif isdefined("url.FechaI") and not isdefined("form.FechaI")>
	<cfset form.FechaI = url.FechaI>
</cfif>

<cfif isdefined("url.FechaF") and not isdefined("form.FechaF")>
	<cfset form.FechaF = url.FechaF>
</cfif>

<cfoutput>
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td valign="top" align="center">
			<fieldset><legend>Datos del Proceso</legend>
	<form name="form1" method="post" action="index.cfm" onsubmit="return waitmsg();">
				<table  width="100%" align="center" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="2">&nbsp;</td></tr>
					<!--- CAMBIO PARA EXTRAER DATOS DE MAS DE UNA EMPRESA ICTS POR CADA EMPRESA EN SIF --->
					<tr>
						<td align="center" nowrap="nowrap" colspan="2">Seleccione Empresa ICTS a procesar:</td>
					</tr>
					<tr>
						<td colspan="2" align="center">
							<select name="CodICTS">
								<cfloop query="rsCodICTS">
									<option value="#rsCodICTS.CodICTS#"> #rsCodICTS.acct_full_name# </option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr> <td>&nbsp;  </td> </tr>
					<tr>
						<td align="right"><strong>Fecha&nbsp;Mercado:</strong></td>
						<td >
							<cfif isdefined("form.FechaI") and len(trim(form.FechaI))>
								<cf_sifcalendario form="form1" value="#form.FechaI#" name="FechaI" tabindex="1"> 
							<cfelse>	
								<cfset LvarFecha = createdate(year(now()),month(now()),1)>
								<cf_sifcalendario form="form1" value="#DateFormat(LvarFecha, 'dd/mm/yyyy')#" name="FechaI" tabindex="1"> 
							</cfif>
						</td>
					</tr>
					
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2"><cf_botones values="Generar" names="Generar" tabindex="1"></td></tr>
				</table>
	</form>
	<form name="formwait" style="display:none" action="javascript:void(0)" onsubmit="return 0">
	<center>
<table width="412" border="0" style="background-color:##E9E3FD; height:120px ">
  <tr>
    <td width="48" align="center"><img src='../generales/loading.gif' width="32" height="32" border="0" loop="-1" /></td>
    <td width="6">&nbsp;</td>
    <td width="338" align="center"><strong>Extrayendo información, por favor espere unos momentos ...</strong> </td>
  </tr>
</table>
</center>
</form>
				</fieldset>
			</td>	
		</tr>
	</table>
</cfoutput>
<cf_web_portlet_end>
<cf_qforms form = 'form1'>
<script language="javascript" type="text/javascript">
function waitmsg(){
	document.form1.style.display = 'none';
	document.formwait.style.display = '';
	return true;
}
	objForm.FechaI.required=true;
	objForm.FechaI.description='Fecha Desde';
</script>
<cf_templatefooter>

<!--- 
	Creado por Marco Saborío
		Fecha: 23-01-2007
 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Documentos NoFact de Producto'>

<cfif isdefined("url.FechaI") and not isdefined("form.FechaI")>
	<cfset form.FechaI = url.FechaI>
</cfif>

<cfif isdefined("url.FechaF") and not isdefined("form.FechaF")>
	<cfset form.FechaF = url.FechaF>
</cfif>

<cfoutput>
	<form name="form1" method="post" action="ProcNoFactProd.cfm" onsubmit="return waitmsg();">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td valign="top" align="center">
			<fieldset><legend>Datos del Proceso</legend>
				<table  width="100%" align="center" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td align="right"><strong>Fecha&nbsp;Desde:</strong></td>
						<td >
							<cfif isdefined("form.FechaI") and len(trim(form.FechaI))>
								<cf_sifcalendario form="form1" value="#form.FechaI#" name="FechaI" tabindex="1"> 
							<cfelse>	
								<cfset LvarFecha = createdate(year(now()),month(now()),1)>
								<cf_sifcalendario form="form1" value="#DateFormat(LvarFecha, 'dd/mm/yyyy')#" name="FechaI" tabindex="1"> 
							</cfif>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Fecha Hasta:</strong></td>
						<td>
							<cfif isdefined("form.FechaF") and len(trim(form.FechaF))>
								<cf_sifcalendario form="form1" value="#form.FechaF#" name="FechaF" tabindex="1"> 
							<cfelse>
								<cf_sifcalendario form="form1" value="#DateFormat(Now(),'dd/mm/yyyy')#" name="FechaF" tabindex="1"> 
							</cfif>
						</td>
					</tr>
					
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2"><cf_botones values="Generar" names="Generar" tabindex="1"></td></tr>
				</table>
				</fieldset>
			</td>	
		</tr>
	</table>
	</form>
		<form name="formwait" style="display:none" action="javascript:void(0)" onsubmit="return 0">
		<center>
			<table width="412" border="0" style="background-color:##E9E3FD; height:120px ">
				<tr>
					<td width="48" align="center"><img src='generales/loading.gif' width="32" height="32" border="0" loop="-1" /></td>
			    	<td width="6">&nbsp;</td>
					<td width="338" align="center"><strong>Extrayendo información, por favor espere unos momentos ...</strong> </td>
			 	</tr>
			</table>
		</center>
	</form>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form1'>
<script language="javascript" type="text/javascript">
	objForm.FechaI.required=true;
	objForm.FechaI.description='Fecha Desde';
	objForm.FechaF.required=true;
	objForm.FechaF.description='Fecha Hasta';
</script>

<script language="javascript" type="text/javascript">
function waitmsg(){
	document.form1.style.display = 'none';
	document.formwait.style.display = '';
	return true;
}
</script>
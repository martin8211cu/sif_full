<!--- ABG. 
		CAMBIO PARA EXTRACCION DE DATOS DE MAS DE UNA EMPRESA ICTS POR CADA EMPRESA EN SIF
		04 DE NOVIEMBRE DE 2008 --->

<!---Obtiene la lista de codigos ICTS de empresas relacionadas al Ecodigo Actual--->
<cfset Bpreicts = Application.dsinfo.preicts.schema>
<cfquery name="rsCodICTS" datasource="sifinterfaces">
	select CodICTS, b.acct_full_name
	from int_ICTS_SOIN a, #Bpreicts#..account b
	where EcodigoSDCSoin = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	and a.CodICTS = convert(varchar,b.acct_num)
</cfquery>

<cfparam name="titulo">

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#titulo#'>

<cfif isdefined("directorio") AND NOT FindNoCase("complementonf",directorio)>
<cfif isdefined("session.FechaI") and not isdefined("form.FechaI")>
	<cfset form.FechaI = session.FechaI>
</cfif>
<cfif isdefined("session.FechaF") and not isdefined("form.FechaF")>
	<cfset form.FechaF = session.FechaF>
</cfif>

<cfif isdefined("url.FechaI") and not isdefined("form.FechaI")>
	<cfset form.FechaI = url.FechaI>
</cfif>
<cfif isdefined("url.FechaF") and not isdefined("form.FechaF")>
	<cfset form.FechaF = url.FechaF>
</cfif>
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
					<cfif isdefined("directorio") AND NOT FindNoCase("complementonf",directorio)>
						<cfif Not FindNoCase('nofact', directorio)>
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
						</cfif>
						<tr>
							<td align="right"><strong>Fecha Hasta:</strong></td>
							<td>
								<cfif isdefined("form.FechaF") and len(trim(form.FechaF))>
									<cf_sifcalendario form="form1" value="#form.FechaF#" name="FechaF" tabindex="1"> 
								<cfelseif FindNoCase('nofact', directorio)>
									<!--- El ultimo fin de mes para los NOFACT --->
									<cfset FinDeMes = DateAdd("d", -1, CreateDate(Year(Now()), Month(Now()), 1))>
									<cf_sifcalendario form="form1" value="#DateFormat(FinDeMes,'dd/mm/yyyy')#" name="FechaF" tabindex="1"> 
								<cfelse>
									<!--- La fecha de hoy mes para los FACT --->
									<cf_sifcalendario form="form1" value="#DateFormat(Now(),'dd/mm/yyyy')#" name="FechaF" tabindex="1"> 	
								</cfif>
							</td>
						</tr>
					<cfelse>
						<tr>
							<td align="right" colspan="2">
								<center>
									<strong>ESTA OPCIÓN GENERA LOS DOCUMENTOS DE COMPLEMENTO NOFACT </strong>
									<BR />
									<strong>DOCUMENTOS DE TIPO ESTIMACIÓN CON CODIGO DE TRANSACCION </strong>
									<br />
									<strong>XS O ZS, LOS CUALES DEBERAN SER REVERSADOS AL INICIAR </strong>
									<br />
									<strong>EL SIGUIENTE CICLO CONTABLE </strong>
								</center>
							</td>
						</tr>
					</cfif>
						
					
					
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
<cfif Not FindNoCase('nofact', directorio)>
	objForm.FechaI.required=true;
	objForm.FechaI.description='Fecha Desde';
</cfif>
	objForm.FechaF.required=true;
	objForm.FechaF.description='Fecha Hasta';
</script>
<cf_templatefooter>

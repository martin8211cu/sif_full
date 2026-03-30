<!----  Realizado por: Rebeca Corrales Alfaro
        fecha: 04/07/2005
		Motivo: Creación del Catálogo de Valores por Oficina
		Modificado por:
--->		

<!---   ********************* Paso de URL a form  ************************************************ --->
<cfif isdefined('url.IncVal') and not isdefined('form.IncVal')>
	<cfparam name="form.IncVal" default="#url.IncVal#">
</cfif>
<cfif isdefined('url.PCDcatid') and not isdefined('form.PCDcatid')>
	<cfparam name="form.PCDcatid" default="#url.PCDcatid#">
</cfif>
<cfif isdefined('url.PCEcatid') and not isdefined('form.PCEcatid')>
	<cfparam name="form.PCEcatid" default="#url.PCEcatid#">
</cfif>
<cfif isdefined('url.PCEcodigo') and not isdefined('form.PCEcodigo')>
	<cfparam name="form.PCEcodigo" default="#url.PCEcodigo#">
</cfif>
<cfif isdefined('url.PCEdescripcion') and not isdefined('form.PCEdescripcion')>
	<cfparam name="form.PCEdescripcion" default="#url.PCEdescripcion#">
</cfif>
<cfif isdefined('url.PCDvalor') and not isdefined('form.PCDvalor')>
	<cfparam name="form.PCDvalor" default="#url.PCDvalor#">
</cfif>
<cfif isdefined('url.PCDdescripcion') and not isdefined('form.PCDdescripcion')>
	<cfparam name="form.PCDdescripcion" default="#url.PCDdescripcion#">
</cfif>
<!--- ******* Si el modo es de tipo Cambio, realiza la consulta (query) a la tabla Oficinas ******--->
<cfset LvarIncVal = "">
<cfif isdefined("Form.IncVal")>
	<cfset LvarIncVal = ",1 as IncVal">
</cfif>

<cfquery name="rsLista" datasource="#Session.DSN#">
	Select '#Form.PCEcatid#' as PCEcatid ,'#Form.PCDdescripcion#' as PCDdescripcion,'#Form.PCDvalor#' as PCDvalor,
		'#Form.PCEdescripcion#' as PCEdescripcion, '#Form.PCEcodigo#' as PCEcodigo,
		'#Form.PCDcatid#' as PCDcatid,pcdo.Ocodigo as Ocodigo_pcdo,o.Ocodigo,
		 Oficodigo, Odescripcion #LvarIncVal#
		 
	from Oficinas o
		left outer join PCDCatalogoValOficina pcdo
			on pcdo.Ecodigo=o.Ecodigo
				and pcdo.Ocodigo=o.Ocodigo
				and PCDcatid = <cfqueryparam value="#form.PCDcatid#" cfsqltype="cf_sql_numeric">
	where o.Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>		

<!--- ******************** Asigna a la variable navegacion los filtros  ************************--->
<cfset navegacion = "">
<cfif isdefined("form.PCDcatid") and len(trim(form.PCDcatid)) >
	<cfset navegacion = navegacion & "&PCDcatid=#form.PCDcatid#">
</cfif>
<cfif isdefined("form.PCEcatid") and len(trim(form.PCEcatid)) >
	<cfset navegacion = navegacion & "&PCEcatid=#form.PCEcatid#">
</cfif>
<cfif isdefined("form.PCEcodigo") and len(trim(form.PCEcodigo)) >
	<cfset navegacion = navegacion & "&PCEcodigo=#form.PCEcodigo#">
</cfif>
<cfif isdefined("form.PCEdescripcion") and len(trim(form.PCEdescripcion)) >
	<cfset navegacion = navegacion & "&PCEdescripcion=#form.PCEdescripcion#">
</cfif>
<cfif isdefined("form.PCDvalor") and len(trim(form.PCDvalor)) >
	<cfset navegacion = navegacion & "&PCDvalor=#form.PCDvalor#">
</cfif>
<cfif isdefined("form.PCDdescripcion") and len(trim(form.PCDdescripcion)) >
	<cfset navegacion = navegacion & "&PCDdescripcion=#form.PCDdescripcion#">
</cfif>
<style type="text/css">
	<!--
	.style21 {font-size: 14px; font-family: "Times New Roman", Times, serif; }
	.style27 {font-size: 12px; font-family: "Times New Roman", Times, serif; }
	-->
</style>


	<cf_templateheader title="Plan de Cuentas - Oficinas por Valor">
	<cf_templatecss>
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Oficinas por Valor">
				<cfinclude template="../../portlets/pNavegacion.cfm">
					<!---  ***************** Se encarga de pintar el encabezado  ***************** --->
					<cfoutput>
						<form method="post" name="filtros" action="#GetFileFromPath(GetTemplatePath())#" class="AreaFiltro" style="margin:0;">
							<input type="hidden" name="PCEcatid" value="#form.PCEcatid#">
							<input type="hidden" name="PCDcatid" value="#form.PCDcatid#">
							<cfif isdefined("Form.IncVal")>
								<input type="hidden" name="IncVal" value="#form.IncVal#">
							</cfif>

							<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
									<td colspan="3">
										<strong>
											<span class="style21">C&oacute;digo:</span>
										</strong>&nbsp;
											<span class="style21">#form.PCEcodigo# #form.PCEdescripcion#</span>
											
									</td>
								</tr>
								<tr>
									<td width="1%">&nbsp;</td>
									<td width="38%"><strong><span class="style21">Valor:#Form.PCDvalor# #Form.PCDdescripcion#
									</span></strong></td>
									 <td width="61%">
									 	<strong>
										</strong>&nbsp;
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
                                </tr>
								<tr>
									<td colspan="3"><strong>
										<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);">
										<label for="chkTodos"><span class="style27">Seleccionar Todas</span></label>
                                        
									</td>
								</tr>
							</table>
						</form>
					</cfoutput>
					<!--- ******************** Se encarga de pintar la lista  ******************** --->
					
					<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="Oficodigo, Odescripcion"/>
						<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
						<cfinvokeargument name="formatos" value="V,V"/>
						<cfinvokeargument name="align" value="left, left"/>
						<cfinvokeargument name="ajustar" value="S"/>
						<cfinvokeargument name="irA" value="ValoresxOficinas-sql.cfm"/>
						<cfinvokeargument name="checkboxes" value="S"/>
						<cfinvokeargument name="keys" value="Ocodigo"/>
						<cfinvokeargument name="formname" value="form1"/>
						<cfinvokeargument name="botones" value="Regresar, Asignar"/>
						<cfinvokeargument name="checkedcol" value="Ocodigo_pcdo"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/> 
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="maxRows" value="25"/> 
					</cfinvoke>
					<!--- ******** Se encarga de generar las funciones de Asignar y Marcar ************ --->
					<script language="javascript" type="text/javascript">
						function Marcar(c) {
							if (c.checked) {
								for (counter = 0; counter < document.form1.chk.length; counter++)
								{
									if ((!document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
										{  document.form1.chk[counter].checked = true;}
								}
								if ((counter==0)  && (!document.form1.chk.disabled)) {
									document.form1.chk.checked = true;
								}
							}
							else {
								for (var counter = 0; counter < document.form1.chk.length; counter++)
								{
									if ((document.form1.chk[counter].checked) && (!document.form1.chk[counter].disabled))
										{  document.form1.chk[counter].checked = false;}
								};
								if ((counter==0) && (!document.form1.chk.disabled)) {
									document.form1.chk.checked = false;
								}
							};
						}
						function funcAsignar(){
							var Asigna = false;
							if (document.form1.chk) {
								if (document.form1.chk.value) {
									Asigna = document.form1.chk.checked;
								} else {
									for (var i=0; i<document.form1.chk.length; i++) {
										if (document.form1.chk[i].checked) { 
											Asigna = true;
											break;
										}
									}
								}
							}
							document.form1.PCDCATID.value = '<cfoutput>#Form.PCDcatid#</cfoutput>';
							document.form1.PCECATID.value = '<cfoutput>#Form.PCEcatid#</cfoutput>';
							document.form1.PCDDESCRIPCION.value = '<cfoutput>#Form.PCDdescripcion#</cfoutput>';
							document.form1.PCDVALOR.value = '<cfoutput>#Form.PCDvalor#</cfoutput>';
							document.form1.PCEDESCRIPCION.value = '<cfoutput>#Form.PCEdescripcion#</cfoutput>';
							document.form1.PCECODIGO.value = '<cfoutput>#Form.PCEcodigo#</cfoutput>';
							if (confirm("¿Está seguro de que desea Asignar las Oficinas seleccionadas?")) {
								document.form1.submit();
							}
							else{ return false; }
						}
						function funcRegresar() {
							document.filtros.action = 'Catalogos.cfm';
							document.filtros.submit();
							return false;
						}
					</script>
				<cf_web_portlet_end>
	<cf_templatefooter>	  
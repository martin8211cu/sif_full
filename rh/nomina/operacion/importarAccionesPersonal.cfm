<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>	
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<cf_templatecss>
<script language="JavaScript" type="text/JavaScript">
	<!--
	function MM_reloadPage(init) {  //reloads the window if Nav4 resized
	  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
		document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
	  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
	}
	MM_reloadPage(true);
	//-->
</script>

<!----===========================================---->
<!----TRADUCCION								----->
<!----===========================================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ImportarAccionesP"
	Default="Importar Acciones Personales"
	returnvariable="LB_ImportarAccionesP"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Regresar"
	Default="Regresar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Regresar"/>
<!----===========================================---->		
<cfparam name="form.comportamiento" default="3">	  
<cfset lvarEIcodigo = "">
<cfswitch expression="#form.comportamiento#">
	<cfcase value="1">
		<cfset lvarEIcodigo = "">
	</cfcase>
	<cfcase value="2">
		<cfset lvarEIcodigo = "">
	</cfcase>
	<cfcase value="3">
		<cfset lvarEIcodigo = "IAMVACACIONE">
	</cfcase>
	<cfcase value="4">
		<cfset lvarEIcodigo = "">
	</cfcase>
	<cfcase value="5">
		<cfset lvarEIcodigo = "IAMINCAPACID">
	</cfcase>
	<cfcase value="6">
		<cfset lvarEIcodigo = "">
	</cfcase>
	<cfcase value="7">
		<cfset lvarEIcodigo = "">
	</cfcase>
	<cfcase value="8">
		<cfset lvarEIcodigo = "">
	</cfcase>
	<cfcase value="9">
		<cfset lvarEIcodigo = "">
	</cfcase>
	<cfcase value="10">
		<cfset lvarEIcodigo = "">
	</cfcase>
	<cfcase value="11">
		<cfset lvarEIcodigo = "">
	</cfcase>
	<cfcase value="12">
		<cfset lvarEIcodigo = "">
	</cfcase>
	<cfcase value="13">
		<cfset lvarEIcodigo = "AFALTA">
	</cfcase>
	<cfdefaultcase>
		<cfset lvarEIcodigo = "IAMVACACIONE">
	</cfdefaultcase>
</cfswitch>
<!---<cf_dump var="#form.comportamiento#"> --->
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">                  		  
			<cf_web_portlet_start border="true" titulo="#LB_ImportarAccionesP#" skin="#Session.Preferences.Skin#">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
					<tr><td colspan="3" align="center">&nbsp;</td></tr>
					<tr>
						<td align="center" width="2%">&nbsp;</td>
						<td align="center" valign="top" width="60%">
							<cf_sifFormatoArchivoImpr EIcodigo = "#lvarEIcodigo#">
						</td>							
						<td valign="top">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
								<tr><form name="formComp" method="post" action="importarAccionesPersonal.cfm">
									<td>Comportamiento:</td>
									<td>
										<select name="comportamiento" onchange="javascript: document.formComp.submit()">
											<option value="0" <cfif form.comportamiento eq 0 >selected</cfif>>--- <cf_translate key="LB_select">seleccione</cf_translate> ---</option>
											<!---<option value="1" <cfif form.comportamiento eq 1 >selected</cfif> ><cf_translate key="LB_RHTcomportam1">Nombramiento</cf_translate></option>
											<option value="2" <cfif form.comportamiento eq 2 >selected</cfif> ><cf_translate key="LB_RHTcomportam2">Cese</cf_translate></option>--->
											<option value="3" <cfif form.comportamiento eq 3 >selected</cfif> ><cf_translate key="LB_RHTcomportam3">Vacaciones</cf_translate></option>
											<!---<option value="4" <cfif form.comportamiento eq 4 >selected</cfif> ><cf_translate key="LB_RHTcomportam4">Permiso</cf_translate></option>--->
											<option value="5" <cfif form.comportamiento eq 5 >selected</cfif> ><cf_translate key="LB_RHTcomportam5">Incapacidad</cf_translate></option>
											<!---<option value="6" <cfif form.comportamiento eq 6 >selected</cfif> ><cf_translate key="LB_RHTcomportam6">Cambio</cf_translate></option>
											<option value="7" <cfif form.comportamiento eq 7 >selected</cfif> ><cf_translate key="LB_RHTcomportam7">Anulaci&oacute;n</cf_translate></option>
											<option value="8" <cfif form.comportamiento eq 8 >selected</cfif> ><cf_translate key="LB_RHTcomportam8">Aumento</cf_translate></option>
											<option value="9" <cfif form.comportamiento eq 9 >selected</cfif> ><cf_translate key="LB_RHTcomportam9">Cambio de Empresa</cf_translate></option>
											<option value="12" <cfif form.comportamiento eq 12 >selected</cfif> ><cf_translate key="LB_RHTcomportam12">Recargos Plaza</cf_translate></option> --->
											<option value="13" <cfif form.comportamiento eq 13 >selected</cfif> ><cf_translate key="LB_RHTcomportam13">Ausencias / Faltas</cf_translate></option>
										</select>
										
									</td>
								</form></tr>
								<tr><td colspan="2">
									<cfif len(trim(lvarEIcodigo)) gt 0>
										<cf_sifimportar EIcodigo="#lvarEIcodigo#" mode="in">
											<cf_sifimportarparam name="comportamiento" value="#form.comportamiento#">
										</cf_sifimportar>
									<cfelse>
										Importador No Definido
									</cfif>
								</td></tr>
							</table>
						</td>
					</tr>													
					<tr>
						<td colspan="3" align="center">
							<input type="button" name="Regresar" value="<cfoutput>#BTN_Regresar#</cfoutput>" onClick="javascript:location.href='Acciones-lista.cfm'">
						</td>
					</tr>				
					<tr><td colspan="3" align="center">&nbsp;</td></tr>
				</table>
			<cf_web_portlet_end>
		</td>	
	</tr>
</table>	
<cf_templatefooter>
<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 10-3-2006.
		Motivo: Se corrige la navegación del form por tabs para que tenga un orden lógico.
 --->



	<cf_templateheader title="Cuentas por Tipo de Reporte">

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Cuentas por Tipo de Reporte">
			<cfinclude template="/home/menu/pNavegacion.cfm">
			
			<cfset modo = "ALTA">
			<cfset currentPage = GetFileFromPath(GetTemplatePath())>
			<cfset navegacion = "">
			
			<cfparam name="form.tab" default="1">
			<cfif isdefined("Url.PageNum_lista1") and Len(Trim(Url.PageNum_lista1))>
				<cfparam name="Form.PageNum_lista1" default="#Url.PageNum_lista1#">
			</cfif>
			<cfif isdefined("Url.fCGARepid") and Len(Trim(Url.fCGARepid))>
				<cfparam name="Form.fCGARepid" default="#Url.fCGARepid#">
			</cfif>
			<cfif isdefined("Url.fCmayor") and Len(Trim(Url.fCmayor))>
				<cfparam name="Form.fCmayor" default="#Url.fCmayor#">
			</cfif>
			<cfif isdefined("Url.fCtipo") and Len(Trim(Url.fCtipo))>
				<cfparam name="Form.fCtipo" default="#Url.fCtipo#">
			</cfif>
			<cfif isdefined("Url.fCsubtipo") and Len(Trim(Url.fCsubtipo))>
				<cfparam name="Form.fCsubtipo" default="#Url.fCsubtipo#">
			</cfif>
			<cfif isdefined("Url.fCGARctaBalance") and Len(Trim(Url.fCGARctaBalance))>
				<cfparam name="Form.fCGARctaBalance" default="#Url.fCGARctaBalance#">
			</cfif>

			<cfif isdefined("Form.fCGARepid") and Len(Trim(Form.fCGARepid))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fCGARepid=" & Form.fCGARepid>
			</cfif>
			<cfif isdefined("Form.fCmayor") and Len(Trim(Form.fCmayor))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fCmayor=" & Form.fCmayor>
			</cfif>
			<cfif isdefined("Form.fCtipo") and Len(Trim(Form.fCtipo))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fCtipo=" & Form.fCtipo>
			</cfif>
			<cfif isdefined("Form.fCsubtipo") and Len(Trim(Form.fCsubtipo))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fCsubtipo=" & Form.fCsubtipo>
			</cfif>
			<cfif isdefined("Form.fCGARctaBalance") and Len(Trim(Form.fCGARctaBalance))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fCGARctaBalance=" & Form.fCGARctaBalance>
			</cfif>
			<form name="form1" action="CuentasTipoRep_Option.cfm" method="post">
				<input name="tab" type="hidden" value="<cfif isdefined("form.tab") and len(trim(form.tab))><cfoutput>#form.tab#</cfoutput></cfif>">
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
				  <tr>
				  	<td colspan="2" align="center" class="ayuda">
						<strong>Escoja el tipo de reporte por el cual se desea consultar.</strong>
					</td>
				  </tr>
				  <tr>
				  	<td colspan="2">
						&nbsp;
					</td>
				  </tr>
				  <tr>
				  	<td style="width:30%">&nbsp;</td>
					<td>
						<input type="radio" name="fCGARepid" value="1">
					  	 Reporte de Gastos por Area Responsabilidad
						 <script language="javascript" type="text/javascript">
							document.form1.fCGARepid.checked= "true";
						</script>
					</td>
				  </tr>
				  <tr>
				  	<td>&nbsp;</td>
					<td>
						<input type="radio" name="fCGARepid" value="2" >
						Estado de Resultados por Area Responsabilidad
					</td>
				  </tr>
  				  <tr>
				  	<td colspan="2">
						&nbsp;
					</td>
				  </tr>
				  <tr>
				  	<td align="center" colspan="2">
						<input type="submit" name="btnSiguiente" value="Siguiente">
					</td>
					
				  </tr>
				</table>
			</form>

		<cf_web_portlet_end>
		
	<cf_templatefooter>

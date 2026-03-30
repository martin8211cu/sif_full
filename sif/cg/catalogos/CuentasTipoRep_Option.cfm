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
			
			<cfif isdefined("Url.tab") and Len(Trim(Url.tab))>
				<cfparam name="Form.tab" default="#Url.tab#">
			</cfif>
			
			<cfparam name="form.tab" default="1">
			<cfif isdefined("Url.PageNum_lista1") and Len(Trim(Url.PageNum_lista1))>
				<cfparam name="Form.PageNum_lista1" default="#Url.PageNum_lista1#">
			</cfif>
			<cfif isdefined("form.CGARepid") and Len(Trim(form.CGARepid))>
				<cfparam name="Form.fCGARepid" default="#form.CGARepid#">
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

			<cfquery name="rsTiposRep" datasource="#Session.DSN#">
				select CGARepid, CGARepDes
				from CGAreasTipoRep
				where CGARepid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fCGARepid#">
			</cfquery>
			<table width="100%" border="0" cellspacing="0" cellpadding="2">
				<tr>
					<td colspan="4" class="tituloAlterno" align="center" style="text-transform: uppercase; ">
						Agregar Nueva Cuenta por Tipo de Reporte
					</td>
		  		</tr>
				<tr>
					<td align="right" colspan="3" class="tituloAlterno" style="text-transform: uppercase; "><strong>Tipo Reporte:</strong>
						<cfif isdefined("Form.cgarepid") and len(Form.cgarepid)><cfset modo="Cambio"></cfif>
						<cfoutput query="rsTiposRep">
							#rsTiposRep.CGARepDes#
						</cfoutput>				
					</td>
				</tr>
				<tr>
					<td align="center" valign="top" height="600">
						<cf_tabs width="99%">
							<cf_tab text="Cuentas de Mayor a Considerar" selected="#form.tab eq 1#">
								<table width="100%" border="0" cellspacing="0" cellpadding="2">
									<tr>
										<td>
											<cfinclude template="CuentasTipoRep-form.cfm">
										</td>
									</tr>
									<tr> 
										<td><cfinclude template="CuentasTipoRep-lista.cfm"></td>
									</tr>
								</table>
							</cf_tab>
							<cf_tab text="Detalle de Cuentas a Eliminar" selected="#form.tab eq 2#">
								<table width="100%" border="0" cellspacing="0" cellpadding="2">
									<tr>
										<td>
											<cfinclude template="CuentasTipoEli-form.cfm">
										</td>
									</tr>
									<tr> 
										<td><cfinclude template="CuentasTipoEli-lista.cfm"></td>
									</tr>
								</table>
							</cf_tab>
						</cf_tabs>
					</td>
				</tr>
			</table>

		<cf_web_portlet_end>
		
	<cf_templatefooter>

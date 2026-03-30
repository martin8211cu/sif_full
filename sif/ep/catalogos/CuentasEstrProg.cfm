
<cf_templateheader title="Cuentas por Estructura Programática">

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Cuentas por Estructura Programática">
			<cfinclude template="/home/menu/pNavegacion.cfm">

			<cfset modo = "ALTA">
			<cfset currentPage = GetFileFromPath(GetTemplatePath())>
			<cfset navegacion = "">

			<cfif isdefined("Url.tab") and Len(Trim(Url.tab))>
				<cfparam name="Form.tab" default="#Url.tab#">
			</cfif>

			<cfparam name="form.tab" default="6">
			<cfif isdefined("Url.PageNum_lista1") and Len(Trim(Url.PageNum_lista1))>
				<cfparam name="Form.PageNum_lista1" default="#Url.PageNum_lista1#">
			</cfif>

			<cfif isdefined("form.ID_Estr") and Len(Trim(form.ID_Estr))>
				<cfparam name="Form.fID_Estr" default="#form.ID_Estr#">
			</cfif>

			<cfif isdefined("form.ID_Grupo") and Len(Trim(form.ID_Grupo))>
				<cfparam name="Form.fID_Grupo" default="#form.ID_Grupo#">
			</cfif>

			<cfif isdefined("Url.fID_Estr") and Len(Trim(Url.fID_Estr))>
				<cfparam name="Form.fID_Estr" default="#Url.fID_Estr#">
			</cfif>

			<cfif isdefined("Url.fCGEPCtaMayor") and Len(Trim(Url.fCGEPCtaMayor))>
				<cfparam name="Form.fCGEPCtaMayor" default="#Url.fCGEPCtaMayor#">
			</cfif>

			<cfif isdefined("Url.fCGEPctaGrupo") and Len(Trim(Url.fCGEPctaGrupo))>
				<cfparam name="Form.fCGEPctaGrupo" default="#Url.fCGEPctaGrupo#">
			</cfif>

			<cfif isdefined("Url.fCGEPctaTipo") and Len(Trim(Url.fCGEPctaTipo))>
				<cfparam name="Form.fCGEPctaTipo" default="#Url.fCGEPctaTipo#">
			</cfif>

			<cfif isdefined("Url.CGEPctaBalance") and Len(Trim(Url.CGEPctaBalance))>
				<cfparam name="Form.CGEPctaBalance" default="#Url.CGEPctaBalance#">
			</cfif>

			<cfif isdefined("Url.fCGEPDescrip") and Len(Trim(Url.fCGEPDescrip))>
				<cfparam name="Form.fCGEPDescrip" default="#Url.fCGEPDescrip#">
			</cfif>

			<cfif isdefined("Url.fCGEPInclCtas") and Len(Trim(Url.fCGEPInclCtas))>
				<cfparam name="Form.fCGEPInclCtas" default="#Url.fCGEPInclCtas#">
			</cfif>

			<cfif isdefined("Url.fID_EstrCtaVal") and Len(Trim(Url.fID_EstrCtaVal))>
				<cfparam name="Form.fID_EstrCtaVal" default="#Url.fID_EstrCtaVal#">
			</cfif>

			<cfif isdefined("Url.ID_EstrCta") and Len(Trim(Url.ID_EstrCta))>
				<cfparam name="Form.ID_EstrCta" default="#Url.ID_EstrCta#">
			</cfif>
			<cfif isdefined("Url.ID_EstrCtaDet") and Len(Trim(Url.ID_EstrCtaDet))>
				<cfparam name="Form.ID_EstrCtaDet" default="#Url.ID_EstrCtaDet#">
			</cfif>
			<cfif isdefined("Form.fID_Estr") and Len(Trim(Form.fID_Estr))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fID_Estr=" & Form.fID_Estr>
			</cfif>
			<cfif isdefined("Form.fID_Grupo") and Len(Trim(Form.fID_Grupo))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fID_Grupo=" & Form.fID_Grupo>
			</cfif>
			<cfif isdefined("Form.fCGEPCtaMayor") and Len(Trim(Form.fCGEPCtaMayor))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fCmayor=" & Form.fCGEPCtaMayor>
			</cfif>
			<cfif isdefined("Form.fCGEPctaTipo") and Len(Trim(Form.fCGEPctaTipo))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fCtipo=" & Form.fCGEPctaTipo>
			</cfif>
			<cfif isdefined("Form.fCGEPctaGrupo") and Len(Trim(Form.fCGEPctaGrupo))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fCsubtipo=" & Form.fCGEPctaGrupo>
			</cfif>
			<cfif isdefined("Form.fCGARctaBalance") and Len(Trim(Form.fCGARctaBalance))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fCGARctaBalance=" & Form.fCGARctaBalance>
			</cfif>
			<cfif isdefined("Form.fCGEPDescrip") and Len(Trim(Form.fCGEPDescrip))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fCGEPDescrip=" & Form.fCGEPDescrip>
			</cfif>
			<cfif isdefined("Form.fCGEPInclCtas") and Len(Trim(Form.fCGEPInclCtas))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fCGEPInclCtas=" & Form.fCGEPInclCtas>
            </cfif>
			<cfif isdefined("Form.fID_EstrCtaVal") and Len(Trim(Form.fID_EstrCtaVal))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fID_EstrCtaVal=" & Form.fID_EstrCtaVal>
            </cfif>

			<cfset myArrayList = ListToArray(form.FID_ESTR,",")>
			<cfset fID_Estr = myArrayList[1]>
			<cfquery name="rsTiposRep" datasource="#Session.DSN#">
				select ID_Estr, EPcodigo, EPdescripcion
				from CGEstrProg
				where ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fID_Estr#">

			</cfquery>
            <cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">

			<table width="100%" border="0" cellspacing="0" cellpadding="2">
				<tr>
					<td colspan="4" class="tituloAlterno" align="center" style="text-transform: uppercase; ">
						Agregar Nueva Cuenta por Tipo de Reporte
					</td>
		  		</tr>
				<tr>
					<td align="right" colspan="3" class="tituloAlterno" style="text-transform: uppercase; "><strong>Tipo Estructura:</strong>
						<cfif isdefined("Form.ID_EstrCta") and len(Form.ID_EstrCta)><cfset modo="Cambio"></cfif>
						<cfoutput query="rsTiposRep">
							#rsTiposRep.EPdescripcion#
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td align="center" valign="top" height="600">
						<cf_tabs width="99%">
							<cf_tab text="Configuración de Grupos" selected="#form.tab eq 6#">
								<table width="100%" border="0" cellspacing="0" cellpadding="2">
									<tr>
										<td>
											<cfinclude template="CatGrupoPadreCtas-form.cfm">
										</td>
									</tr>
									<tr>
										<td><cfinclude template="CatGrupoPadreCtas-lista.cfm"></td>
									</tr>
								</table>
							</cf_tab>
							<cf_tab text="Grupos Cuentas de Mayor" selected="#form.tab eq 1#">
								<table width="100%" border="0" cellspacing="0" cellpadding="2">
									<tr>
										<td>
											<cfinclude template="CatGrupoCtasMayor-form.cfm">
										</td>
									</tr>
									<tr>
										<td><cfinclude template="CatGrupoCtasMayor-lista.cfm"></td>
									</tr>
								</table>
							</cf_tab>
							<cf_tab text="Cuentas de Mayor a Considerar" selected="#form.tab eq 2#">
								<table width="100%" border="0" cellspacing="0" cellpadding="2">
									<tr>
										<td>
											<cfinclude template="CuentasEstrProg-form.cfm">
										</td>
									</tr>
									<tr>
										<td><cfinclude template="CuentasEstrProg-lista.cfm"></td>
									</tr>
								</table>
							</cf_tab>
							<cf_tab text="Detalle de Cuentas a Incluir/Excluir" selected="#form.tab eq 3#">
								<table width="100%" border="0" cellspacing="0" cellpadding="2">
									<tr>
										<td><cfinclude template="CuentasIncExc-form.cfm"></td>
									</tr>
									<tr>
										<td><cfinclude template="CuentasIncExc-lista.cfm"></td>
									</tr>
								</table>
							</cf_tab>
							<cf_tab text="Clasificadores de Cuentas" selected="#form.tab eq 4#">
								<table width="100%" border="0" cellspacing="0" cellpadding="2">
									<tr>
										<td><cfinclude template="ValoresEstrProg-form.cfm"></td>
									</tr>
									<tr>
										<td><cfinclude template="ValoresEstrProg-lista.cfm"></td>
									</tr>
									<tr>
										<td><cfinclude template="ValoresEstrProgD-form.cfm"></td>
									</tr>
									<tr>
										<td><cfinclude template="ValoresEstrProgD-lista.cfm"></td>
									</tr>
                                    <cfif isdefined("form.chcHijo") and form.chcHijo eq '1' and
									isdefined("form.ID_DEstrCtaVal") and len(trim(form.ID_DEstrCtaVal))>
                                        <tr>
                                            <td><cfinclude template="ValDetEstrProgD-form.cfm"></td>
                                        </tr>
                                        <tr>
                                            <td><cfinclude template="ValDetEstrProgD-lista.cfm"></td>
                                        </tr>
                                    </cfif>
								</table>
							</cf_tab>
							<cf_tab text="Clasificación del Catálogo" selected="#form.tab eq 5#">
								<table width="100%" border="0" cellspacing="0" cellpadding="2">
									<tr>
										<td><cfinclude template="ClasificacionCatCont-form.cfm"></td>
									</tr>
								</table>
							</cf_tab>
<!---							<cf_tab text="Selecci&oacute;n Valores al Plan de Cuentas" selected="#form.tab eq 5#">
								<table width="100%" border="0" cellspacing="0" cellpadding="2">
									<tr>
										<td><cfinclude template="ValoresEstrProgD-form.cfm"></td>
									</tr>
									<tr>
										<td><cfinclude template="ValoresEstrProgD-lista.cfm"></td>
									</tr>
								</table>
							</cf_tab>---->
						</cf_tabs>
					</td>
				</tr>
			</table>

		<cf_web_portlet_end>

	<cf_templatefooter>

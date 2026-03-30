<cfset modo = "ALTA">
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_EmpresasFormato"
Default="Empresas / Formato"
returnvariable="LB_EmpresasFormato"/>	

<!--- Querys para hacer lista --->
<cfquery name="rsLista1" datasource="asp">
	select  CEnombre,Enombre,Ecodigo
	from CuentaEmpresarial, Empresa 
	where CuentaEmpresarial.CEcodigo = Empresa.CEcodigo	
	and Ereferencia is not null
	order by Ereferencia
</cfquery>

<cfquery name="rsEImportadorEmpresa" datasource="sifcontrol">	
	select Ecodigo,EIid  
	from EImportadorEmpresa 
</cfquery>

<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#LB_EmpresasFormato#</cfoutput>
	</cf_templatearea>
	<cf_templatearea name="body">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_EmpresasFormato#'>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<cfinclude template="/sif/portlets/pNavegacion.cfm">					
						</td>
					</tr>
				</table>					
				<table width="100%"  border="0">
					<tr>
						<td  valign="top" width="50%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
								<tr>

									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Empresa"
									Default="Empresa"
									returnvariable="LB_Empresa"/>	
									
									<form name="fBusqueda" method="post">
										<td width="7%" align="center"><strong><cfoutput>#LB_Empresa#</cfoutput>:</strong></td>
										<td width="7%" align="left">
											<input name="FEnombre" type="text" size="70" maxlength="70" 
											value="<cfif isDefined("form.FEnombre")><cfoutput>#form.FEnombre#</cfoutput></cfif>"
											onFocus="this.select()">&nbsp;
										</td>											
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Filtrar"
										Default="Filtrar"
										returnvariable="BTN_Filtrar"/>
										
										<td width="15%" align="center"><input name="btnFiltrar" type="submit" value="<cfoutput>#BTN_Filtrar#</cfoutput>"></td>
										<td width="58%" align="left">&nbsp;</td>
										<input name="EIid"  type="hidden" value="<cfif isdefined("form.EIid")><cfoutput>#Form.EIid#</cfoutput></cfif>">
										<input name="modo" type="hidden">
									</form>
								</tr>
							</table>	
							
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td  colspan="4">
										<cfquery name="rsLista"  dbtype="query">	
											select  CEnombre,Enombre,rsEImportadorEmpresa.Ecodigo as CEcodigo ,EIid
											from rsLista1, rsEImportadorEmpresa 
											where rsLista1.Ecodigo = rsEImportadorEmpresa.Ecodigo
											and EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
											<cfif isdefined("form.FEnombre")  and Len(Trim(form.FEnombre)) NEQ 0>
												and UPPER(Enombre) like '%#Ucase(Form.FEnombre)#%'
											</cfif>
											order by CEnombre,Enombre
										</cfquery>

										<cfinvoke
											component="sif.Componentes.pListas"
											method="pListaQuery"
											returnvariable="pListaRet"
												cortes ="CEnombre"
												query="#rsLista#"
												desplegar="Enombre"
												etiquetas="#LB_Empresa#"
												formatos="S,"
												align="left"
												ajustar="N"
												checkboxes="N"
												irA="IMP_EmpresasXFormato.cfm"
												keys="CEcodigo,EIid"
												showEmptyListMsg="true"
												maxrows="10" />
									</td>								
								</tr> 
							</table>
						</td>
						<td valign="top"><cfinclude template="formEmpresasXFormatos.cfm"></td>
					</tr>
				</table>	
				<cf_web_portlet_end>
			</td>
	  	</tr>
	</table>
	</cf_templatearea>
</cf_template>

<script language="javascript" type="text/javascript">
</script>
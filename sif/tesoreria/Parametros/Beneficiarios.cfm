<!--- 
	Creado por Gustavo Fonseca Hernández.
		Fecha: 10-6-2005.
		Motivo: Creación del Mantenimiento para beneficiarios.
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 26-7-2005.
		Motivo: Se incluyen las Cuentas destino del benefiario. Se incluyen filtros y navegación para la lista.	
 --->


<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="15">

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cf_templateheader title="Mantenimiento a Beneficiarios de Contado">
	<cf_web_portlet_start titulo="Mantenimiento a Beneficiarios de Contado">
		<style type="text/css">
		<!--
		.style1 {
			color: #FF0000;
			font-weight: bold;
		}
		-->
		</style>

		<cf_navegacion name="fTESBeneficiarioId">
		<cf_navegacion name="fTESBeneficiario">
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
		<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
			<cfset form.Pagina = url.Pagina>
		</cfif>
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
		<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
			<cfset form.Pagina = url.PageNum_Lista>
		</cfif>
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
		<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
			<cfset form.Pagina = form.PageNum>
		</cfif>
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
		<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
			<cfset form.Pagina2 = url.Pagina2>
		</cfif>
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
		<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
			<cfset form.Pagina2 = url.PageNum_Lista2>
		</cfif>
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
		<cfif isdefined("url.PageNum2") and len(trim(url.PageNum2))>
			<cfset form.Pagina2 = url.PageNum2>
		</cfif>
		<cfif isdefined('url.fTESBeneficiario') and not isdefined('form.fTESBeneficiario')>
			<cfset form.fTESBeneficiario = url.fTESBeneficiario>
		</cfif>
		<cfif isdefined('url.fTESBeneficiarioID') and not isdefined('form.fTESBeneficiarioID')>
			<cfset form.fTESBeneficiarioID = url.fTESBeneficiarioID>
		</cfif>
		<cfif isdefined('url.TESBId') and not isdefined('form.TESBId')>
			<cfset form.TESBId = url.TESBId>
		</cfif>
		<table width="100%" border="0" cellspacing="6">
			<tr>
				<td  nowrap valign="top" width="100%">
					<form name="formlista" action="Beneficiarios.cfm" method="post">
						<cfoutput>
						<input name="Pagina" type="hidden" value="#form.Pagina#">
						<table border="0" cellpadding="1" cellspacing="0" class="tituloAlterno" width="100%">
							 <tr>
								<td nowrap align="right" width="20%">
									<strong>Trabajar con Tesorería:</strong>&nbsp;
								</td>
								<td align="left" colspan="6">
									<cf_cboTESid tipo="" onchange="this.form.submit();" tabindex="1">
								</td>
							</tr>	
							<tr>
								<td align="right"><strong>Identificaci&oacute;n:</strong></td>
								<td width="10%" align="left">
									<input name="fTESBeneficiarioId" type="text" size="15" maxlength="30" tabindex="1"
										value="<cfif isdefined("form.fTESBeneficiarioId") and len(trim(form.fTESBeneficiarioId))>#form.fTESBeneficiarioId#</cfif>">
								</td>
								<td align="right"><strong>Nombre:</strong></td>
								<td align="left">
									<input name="fTESBeneficiario" type="text"  size="20" maxlength="255" tabindex="1"
										value="<cfif isdefined("form.fTESBeneficiario") and len(trim(form.fTESBeneficiario))>#form.fTESBeneficiario#</cfif>">
								</td>
								<td>
									<cf_botones exclude="ALTA,CAMBIO,BAJA,LIMPIAR" include="btnFiltrar"  includevalues="Filtrar" tabindex="1" >
									<!--- <input name="btnFiltro" type="submit" value="Filtrar"> --->
								</td>	
							</tr>
						</table>
						</cfoutput>
					
					<cfinclude template="../../Utiles/sifConcat.cfm">
					<cf_dbfunction name="spart" args="TESBeneficiario,1,28" returnvariable="LvarSubstring">
					<cf_dbfunction name="length" args="TESBeneficiario" returnvariable="LenTESBeneficiario">
					<cfquery datasource="#session.dsn#" name="lista">
						select TESBeneficiarioId, case when TESBactivo=1 then 'ACTIVO' end as Status,
							case when #LenTESBeneficiario# > 30 then #LvarSubstring# #_Cat# ' ...' else TESBeneficiario end as TESBeneficiario, 
							TESBid,
							case TESBtipoId when 'F' then 'Física' when 'J' then 'Jurídica' when 'E' then 'Extranjero' else '???' end as TESBtipoId
						  from TESbeneficiario 
						 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
						 
						 <cfif isdefined("form.fTESBeneficiarioId") and len(trim(form.fTESBeneficiarioId))>
							and upper(TESBeneficiarioId) like '%#ucase(form.fTESBeneficiarioId)#%'
						 </cfif>
						 <cfif isdefined("form.fTESBeneficiario") and len(trim(form.fTESBeneficiario))>
							and upper(TESBeneficiario) like '%#ucase(form.fTESBeneficiario)#%'
						 </cfif>
		
					</cfquery>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
						query="#lista#"
						desplegar="TESBeneficiarioId, TESBeneficiario, TESBtipoId, Status"
						etiquetas="Identificación, Beneficiario, Tipo Beneficiario, Status"
						formatos="S,S,S,S"
						ajustar="true"
						showEmptyListMsg="yes"
						align="left,left,left,left"
						ira="Beneficiarios_form.cfm"
						botones="Nuevo"
						MaxRows="#form.MaxRows#"
						navegacion="#navegacion#"
						keys="TESBid"
						incluyeForm="false"
						formName="formlista"
					/>		
					</form>
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
	<script language="JavaScript" type="text/javascript">
		function funcNuevo(){
			var parametros = "<cfoutput>Pagina=#form.Pagina#&fTESbeneficiario=<cfif isdefined('form.fTESbeneficiario')>#form.fTESbeneficiario#</cfif>&fTESbeneficiarioID=<cfif isdefined('form.fTESbeneficiarioID')>#form.fTESbeneficiarioID#</cfif></cfoutput>";
			location.href ='Beneficiarios_form.cfm?' + parametros;
			return false;
		}
	</script>
<cf_templatefooter>


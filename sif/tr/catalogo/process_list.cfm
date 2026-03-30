<cfparam name="session.WfPackageBaseName" type="string" default="">
<cfif Len(session.WfPackageBaseName)>
	<cfinvoke component="sif.Componentes.Workflow.plantillas" method="CrearPkg" returnvariable="WfPackage">
		<cfinvokeargument name="PackageBaseName" value="#session.WfPackageBaseName#">
	</cfinvoke>
	<cfset PackageId = WfPackage.PackageId>
<cfelse>
	<cfset PackageId = 0>
</cfif>


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Definir_Tramites"
Default="Definir Tr&aacute;mites"
returnvariable="LB_titulo"/> 

<cf_templateheader title="#Request.Translate('LB_DefinirTramites','Definir Tr&aacute;mites','/sif/generales.xml')#">

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_DefinirTramites"
		Default="Definir Tr&aacute;mite"
		returnvariable="LB_DefinirTramites"/>

    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_DefinirTramites#'>


<cfinclude template="/home/menu/pNavegacion.cfm">

<cfoutput><div style="background-color:##ededed;"><br>
&nbsp;&nbsp;&nbsp;<strong><cf_translate key="LB_SelececcioneUnTramite">Seleccione un tr&aacute;mite</cf_translate></strong><br>
<br></div>
</cfoutput>
<cfparam name="PageNum_ProcessList" default="1">
<cfquery datasource="#session.dsn#" name="ProcessList">
	select
		a.ProcessId, a.Name, a.Created, a.Version,
		b.PackageId, b.Name as PackageName, b.Description as PackageDescription,
		a.PublicationStatus,
		(select count(1) from WfxProcess xp where xp.ProcessId = a.ProcessId) as WfxProcessCount,
		(select count(1) from WfActivity ac where ac.ProcessId = a.ProcessId and ac.ReadOnly = 0) as WfActivityCount
	from WfProcess a join WfPackage b on a.PackageId = b.PackageId
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif PackageId>
	  and a.PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PackageId#">
	</cfif>
	<cfif isdefined("form.PackageIdFiltro") and len(trim(form.PackageIdFiltro))>
		and a.PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PackageIdFiltro#"> 
	</cfif>
	<cfif isdefined("form.PublicationStatusFiltro") and len(trim(form.PublicationStatusFiltro))>
		and a.PublicationStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PublicationStatusFiltro#">		
	<cfelseif not isdefined("form.PublicationStatusFiltro")>
		and a.PublicationStatus  in ('RELEASED','UNDER_REVISION')
	</cfif>
	<!-------->
	order by b.PackageId,a.PublicationStatus,b.Name,a.Name, a.ProcessId
</cfquery>
<cfset MaxRows_ProcessList=10>
<cfset StartRow_ProcessList=Min((PageNum_ProcessList-1)*MaxRows_ProcessList+1,Max(ProcessList.RecordCount,1))>
<cfset EndRow_ProcessList=Min(StartRow_ProcessList+MaxRows_ProcessList-1,ProcessList.RecordCount)>
<cfset TotalPages_ProcessList=Ceiling(ProcessList.RecordCount/MaxRows_ProcessList)>
<cfif Len(session.WfPackageBaseName) is 0>
	<cfset new_action = 'process_new_template.cfm'>
	<cfset new_method = 'get'>
<cfelse>
	<cfset new_action = 'process_new.cfm'>
	<cfset new_method = 'post'>
</cfif>

		<table border="0" cellpadding="2" cellspacing="0" width="100%">
		  <cfquery name="rsTiposTramite" datasource="#session.DSN#">
			 select PackageId, Description
			 from WfPackage 
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  </cfquery>
		  <tr>
			<td colspan="7">		
				<table width="100%" cellpadding="0" cellspacing="0" bgcolor="#ededed">
					<tr>
						<form name="form2" action="" method="post">
							<td width="6%" align="right" nowrap><strong><cf_translate key="LB_Estado" XmlFile="/sif/generales.xml">Estado</cf_translate>:&nbsp;</strong></td>
							<td width="15%">
								<select name="PublicationStatusFiltro" tabindex="1">
									<option value="" <cfif not isdefined("form.PublicationStatusFiltro") or len(trim(form.PublicationStatusFiltro))>selected</cfif>>--- <cf_translate key="CMB_Todos" XmlFile="/sif/generales.xml">Todos</cf_translate> ---</option>
									<option value="RELEASED" 	<cfif isdefined("form.PublicationStatusFiltro") and form.PublicationStatusFiltro EQ 'RELEASED'>selected</cfif>><cf_translate key="CMB_Aprob">Aprobado</cf_translate></option>
									<option value="UNDER_TEST" 	<cfif isdefined("form.PublicationStatusFiltro") and form.PublicationStatusFiltro EQ 'UNDER_TEST'>selected</cfif>><cf_translate key="CMB_SeEstaApr">Se est&aacute; probando</cf_translate> </option>
									<option value="UNDER_REVISION" <cfif isdefined("form.PublicationStatusFiltro") and form.PublicationStatusFiltro EQ 'UNDER_REVISION'>selected</cfif>><cf_translate key="CMB_EnConstruc">En construcci&oacute;n</cf_translate></option>
									<option value="RETIRED" <cfif isdefined("form.PublicationStatusFiltro") and form.PublicationStatusFiltro EQ 'RETIRED'>selected</cfif>><cf_translate key="CMB_Retirado">Retirado</cf_translate></option>
								</select>
							</td>
							<cfif not PackageId>
								<td width="17%" align="right" nowrap><strong><cf_translate key="LB_TipoDeTramite">Tipo de tr&aacute;mite</cf_translate>:&nbsp;</strong></td>
								<td width="30%">
									<select name="PackageIdFiltro" tabindex="1">						
										<option value="" selected>--- <cf_translate key="LB_Todos" XmlFile="/sif/generales.xml">Todos</cf_translate> ---</option>
										<cfloop query="rsTiposTramite">
											<option value="<cfoutput>#rsTiposTramite.PackageId#</cfoutput>" <cfif isdefined("form.PackageIdFiltro") and form.PackageIdFiltro EQ rsTiposTramite.PackageId>selected</cfif>><cfoutput>#rsTiposTramite.Description#</cfoutput></option>
										</cfloop>
									</select>	
								</td>
							</cfif>
							<td width="8%">
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Filtrar"
								Default="Filtrar"
								XmlFile="/sif/generales.xml"
								returnvariable="BTN_Filtrar"/>
								<input type="submit" name="btn_filtrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>" tabindex="1">
							</td>
						</form>
						<cfoutput>						
							<form name="form1" method="#new_method#" action="#new_action#">
								<td width="22%" valign="middle"> 
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_NuevoTramite"
									Default="Nuevo Tr&aacute;mite"
									returnvariable="BTN_NuevoTramite"/>
									<input type="submit" name="Submit" value="#BTN_NuevoTramite#&gt;&gt;" tabindex="1">
							  </td>
							</form>
						</cfoutput>
						<td width="2%">&nbsp;</td>
					</tr>
					<tr><td>&nbsp;</td></tr>	
				</table>
			</td>
		  </tr>
		  <tr>
			<td class="tituloListas"><cf_translate key="LB_Tramite" XmlFile="/sif/generales.xml">Tr&aacute;mite</cf_translate></td>
			<td class="tituloListas"><cf_translate key="LB_Creado">Creado</cf_translate></td>
			<td class="tituloListas" align="center"><cf_translate key="LB_Version">Versi&oacute;n</cf_translate></td>
			<td class="tituloListas">&nbsp;</td>
			<td class="tituloListas">
			<span title="PublicationStatus" style="background-color:#c0c0c0">&nbsp;&nbsp;&nbsp;&nbsp;</span>
			<cf_translate key="LB_Estado" XmlFile="/sif/generales.xml">Estado</cf_translate></td>
			<td class="tituloListas" align="center"><cf_translate key="LB_NumeroDeActividades">N&uacute;mero de actividades</cf_translate></td>
			<td class="tituloListas" align="center"><cf_translate key="LB_TramitesAsociados">Tr&aacute;mites iniciados</cf_translate> </td>
		  </tr>
		  <cfif ProcessList.RecordCount EQ 0>
			<tr><td colspan="7" align="center"><strong>----- <cf_translate key="MSG_NoSeEncontraronRegistros" XmlFile="/sif/generales.xml">No se encontraron registros</cf_translate> -----</strong></td></tr>
		  <cfelse>
			  <cfoutput query="ProcessList" startRow="#StartRow_ProcessList#" maxRows="#MaxRows_ProcessList#" group="PackageId">
			  <tr class="tituloListas"><td colspan="7"><strong>#HTMLEditFormat(ProcessList.PackageDescription)#</strong></td></tr>
			  <cfoutput>
				<tr class='<cfif ProcessList.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>' 
					onClick="location.href='process.cfm?ProcessId=#ProcessList.ProcessId#'"
					style="cursor:pointer"
					onMouseOver="this.style.backgroundColor = 'skyblue';"
					onMouseOut="this.style.backgroundColor = '';">
				  <td>&nbsp;&nbsp;<!---indent--->#HTMLEditFormat(ProcessList.Name)#</td>
				  <td>#DateFormat(ProcessList.Created, 'dd/mm/yyyy')#</td>
				  <td align="center">#HTMLEditFormat(Replace(ProcessList.Version,' ','','all'))#</td>
				  <td align="right" >
				  <cfif ProcessList.PublicationStatus is 'RELEASED'>
				  <!---
					<span title="RELEASED" style="background-color:##66CC00">&nbsp;&nbsp;&nbsp;</span>--->
					<img src="lock.gif" width="12" height="14" border="0" align="absmiddle">
				  <cfelseif ProcessList.PublicationStatus is 'UNDER_TEST'>
					<!---<span title="UNDER_TEST" style="background-color:##CCCC00">&nbsp;&nbsp;&nbsp;</span>--->
				  <cfelseif ProcessList.PublicationStatus is 'UNDER_REVISION'>
					<!---<span title="UNDER_REVISION" style="background-color:##993333">&nbsp;&nbsp;&nbsp;</span>--->
				  <cfelseif ProcessList.PublicationStatus is 'RETIRED'>
					<!---<span title="RETIRED" style="background-color:##CCCCCC">&nbsp;&nbsp;&nbsp;</span>--->
					<img src="lock.gif" width="12" height="14" border="0" align="absmiddle">
				  <cfelse>
				  </cfif></td>
				  <td align="left" >
				  <cfif ProcessList.PublicationStatus is 'RELEASED'>
					<span title="RELEASED" style="background-color:##66CC00">&nbsp;&nbsp;&nbsp;</span>
					<cf_translate key="LB_Aprobado">Aprobado</cf_translate>
				  <cfelseif ProcessList.PublicationStatus is 'UNDER_TEST'>
					<span title="UNDER_TEST" style="background-color:##CCCC00">&nbsp;&nbsp;&nbsp;</span>
					<cf_translate key="LB_SeEstaProbando">Se est&aacute; probando</cf_translate>
				  <cfelseif ProcessList.PublicationStatus is 'UNDER_REVISION'>
					<span title="UNDER_REVISION" style="background-color:##993333">&nbsp;&nbsp;&nbsp;</span>
					<cf_translate key="LB_EnConstruccion">En construcci&oacute;n</cf_translate>
				  <cfelseif ProcessList.PublicationStatus is 'RETIRED'>
					<span title="RETIRED" style="background-color:##CCCCCC">&nbsp;&nbsp;&nbsp;</span>
					<cf_translate key="LB_Retirados">Retirados</cf_translate>
				  <cfelse>#ProcessList.PublicationStatus#
				  </cfif></td>
				  <td  align="center">#ProcessList.WfActivityCount#</td>
				  <td  align="center"><cfif ProcessList.WfxProcessCount>#ProcessList.WfxProcessCount#<cfelse>-</cfif></td>
				</tr>
				</cfoutput>
			  </cfoutput>
			</cfif> 
			<tr><td colspan="">&nbsp;</td></tr>
			<tr>
			  <td colspan="7" align="center">
				<cfoutput>		
				  <form name="form1" method="#new_method#" action="#new_action#">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_NuevoTramite"
						Default="Nuevo Tr&aacute;mite"
						returnvariable="BTN_NuevoTramite"/>
					<input type="submit" name="Submit" value="#BTN_NuevoTramite#&gt;&gt;" tabindex="1">
				  </form>
				</cfoutput>
			</td>
			</tr>
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>
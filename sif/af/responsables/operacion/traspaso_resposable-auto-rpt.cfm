<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_ConfirmeQueDesea" 		Default="Confirme que desea" 	  returnvariable="MSG_ConfirmeQueDesea"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_LosDocumentosMarcados" 	Default="los documentos marcados" returnvariable="MSG_LosDocumentosMarcados"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Transferir" 			Default="Transferir" 			  returnvariable="MSG_Transferir"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Recibir" 				Default="Recibir" 				  returnvariable="MSG_Recibir"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Rechazar" 				Default="Rechazar" 				  returnvariable="MSG_Rechazar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="TAB_DocumentosAsignados"    Default="Documentos Asignados" 	  returnvariable="TAB_DocumentosAsignados"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="TAB_DocumentosPorRecibir"   Default="Documentos Por Recibir"  returnvariable="TAB_DocumentosPorRecibir"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Placa" 					Default="Placa" 				  returnvariable="LB_Placa"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" 			Default="Descripci&oacute;n"      returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" 					Default="Fecha" 				  returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estado" 					Default="Estado" 			 	  returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Rechazado" 				Default="Rechazado" 			  returnvariable="LB_Rechazado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Normal" 					Default="Normal" 				  returnvariable="LB_Normal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Recibir" 				Default="Recibir" 				  returnvariable="BTN_Recibir"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Rechazar" 				Default="Rechazar" 				  returnvariable="BTN_Rechazar"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Documentos" 			Default="Documento(s)" 			  returnvariable="MSG_Documentos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Empleado" 				Default="Empleado" 				  returnvariable="MSG_Empleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Fecha" 					Default="Fecha" 				  returnvariable="MSG_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Transferir" 		    Default="Transferir" 			  returnvariable="BTN_Transferir"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Documentos" 			Default="Documento(s)" 			  returnvariable="MSG_Documentos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RequiereAprobacionDelEncargadoDelCentrodeCustodia" Default="Requiere aprobación del<br> encargado del centro de custodia" returnvariable="LB_RequiereAprobacionDelEncargadoDelCentrodeCustodia"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RequiereAprobacionDelEncargadoDelCentroFuncional"  Default="Requiere aprobación del<br> encargado del centro funcional" returnvariable="LB_RequiereAprobacionDelEncargadoDelCentroFuncional"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RequiereAprobacionDelEmpleado" Default="Requiere Aprobación del empleado" returnvariable="LB_RequiereAprobacionDelEmpleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RequiereDeSuAprobacion"        Default="Requiere de su Aprobación" returnvariable="LB_RequiereDeSuAprobacion"/>			
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name="now" returnvariable="hoy">

<cfquery name="rsTipoAprobacion" datasource="#session.dsn#">
	select Pvalor as TAprob
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 990
		and Mcodigo = 'AF'
</cfquery>			
<cfif rsTipoAprobacion.recordcount eq 0>
	<cfset TAprob = 0>
<cfelse>
	<cfset TAprob = rsTipoAprobacion.TAprob>
</cfif>

<cfsetting enablecfoutputonly="yes" showdebugoutput="no" requesttimeout="36000">
	<cfsavecontent variable="qryLista">
		<cf_dbfunction name="to_char" args="AFTRid" returnvariable="LvarAFTRid">
		<cf_dbfunction name="to_char" args="afr.Aid" returnvariable="LvarAid">
		<cfif isdefined("TAprob") and TAprob eq 0>
		<cfoutput>
				select act.Aplaca,
				coalesce(afr.CRDRdescdetallada, afr.CRDRdescripcion, act.Adescripcion) as Descripcion, 
				afr.AFRfini,
				 case 
				 when not exists(select 1 from AFTResponsables aftr where aftr.AFRid = afr.AFRid) then '#LB_Normal#' 
				 when not exists(select 1 from AFTResponsables aftr where aftr.AFRid = afr.AFRid and aftr.AFTRestado <> 20)then '#LB_Rechazado#' 
				 else 
					  case 
					  when exists(select 1 from AFTResponsables aftr where aftr.AFRid = afr.AFRid and aftr.AFTRaprobado1 = 0) 
						 then 
								 '#LB_RequiereAprobacionDelEncargadoDelCentroFuncional#<br> ' #_Cat# 
									  (  select MAX( cf.CFcodigo #_Cat#  '-' #_Cat# cf.CFdescripcion )
										 from AFTResponsables aftr
											inner join CFuncional cf
											  on cf.CFid = aftr.AFTRCFid1
									  where aftr.AFRid = afr.AFRid
									  and aftr.AFTRaprobado1 = 0)
					  when exists (select 1 from AFTResponsables aftr where aftr.AFRid = afr.AFRid and aftr.AFTRaprobado2 = 0 ) 
						 then 
								 '#LB_RequiereAprobacionDelEncargadoDelCentroFuncional#<br> ' #_Cat# 
									  (
 									  select MAX(cf.CFcodigo #_Cat#  '-' #_Cat#  cf.CFdescripcion)
										 from AFTResponsables aftr
											inner join CFuncional cf
											  on cf.CFid = aftr.AFTRCFid2
										where aftr.AFRid = afr.AFRid
										  and aftr.AFTRaprobado2 = 0)
					  else 
								 '#LB_RequiereAprobacionDelEmpleado#<br>' #_Cat# 
								 (select de.DEidentificacion #_Cat#  '-' #_Cat#  de.DEnombre #_Cat# ' ' #_Cat#  de.DEapellido1
									from AFTResponsables aftr
									  inner join DatosEmpleado de
											on de.DEid = aftr.DEid
								  where aftr.AFRid = afr.AFRid)
					  end end as Estado
				from 	AFResponsables afr
				 inner join Activos act
					  on act.Ecodigo = afr.Ecodigo
					  and act.Aid = afr.Aid	
				where afr.Ecodigo = #Session.Ecodigo#
					 and afr.DEid = #url.DEid#
					 and #hoy#  between afr.AFRfini and afr.AFRffin
				 order by act.Aplaca	
			</cfoutput>
	<cfelse>
		<cfoutput>
			select act.Aplaca,	
				afr.AFRid, 
				coalesce(afr.CRDRdescdetallada, 
				afr.CRDRdescripcion, act.Adescripcion) as Descripcion, 
				afr.AFRfini,
				case 
				when not exists (
						select 1
						from AFTResponsables aftr
						where aftr.AFRid = afr.AFRid
				) then '#LB_Normal#' 
				when not exists (
						select 1
						from AFTResponsables aftr
						where aftr.AFRid = afr.AFRid
						and aftr.AFTRestado <> 20
				) then '#LB_Rechazado#' 
				else 
					case 
					when exists (
							select 1
							from AFTResponsables aftr
							where aftr.AFRid = afr.AFRid
							and aftr.AFTRaprobado2 = 0
					) then 
						'#LB_RequiereAprobacionDelEncargadoDelCentrodeCustodia#<br> ' #_Cat#  
							coalesce( (
										select MAX(crcc.CRCCcodigo #_Cat#  '-' #_Cat# crcc.CRCCdescripcion)
															  from AFTResponsables aftr
																	inner join CRCentroCustodia crcc
																		 on crcc.CRCCid = aftr.CRCCid
																		 and crcc.Ecodigo = #session.ecodigo#
															  where aftr.AFRid         = afr.AFRid
																 and aftr.AFTRaprobado2 = 0
																 and aftr.Usucodigo     = #Session.Usucodigo#),'')
					else 
						'#LB_RequiereAprobacionDelEmpleado#<br>' #_Cat# 
							(select de.DEidentificacion #_Cat#  '-' #_Cat# de.DEnombre #_Cat#  ' ' #_Cat#  de.DEapellido1
							  from AFTResponsables aftr
								inner join DatosEmpleado de
									on de.DEid = aftr.DEid
							where aftr.AFRid = afr.AFRid)
					end
				end as Estado,
				'<a href=''javascript: ver(' #_Cat# #LvarAid# #_Cat# ');''><img src=''/cfmx/sif/imagenes/find.small.png'' border=''0''></a>' as ver,
				case when exists (select 1
									  from AFTResponsables aftr
									 where aftr.AFRid = afr.AFRid) then AFRid
				else -1
				end as lr,
				case 
				when exists (
						select 1
						from AFTResponsables aftr
						where aftr.AFRid = afr.AFRid
						and AFTRestado = 20
				) then '<a href=''##'' onclick=''javascript:document.lista.eliminar.value=' #_Cat# 
						(select #LvarAFTRid#
						from AFTResponsables aftr
						where aftr.AFRid = afr.AFRid) #_Cat# 
						';document.lista.submit();''><img src=''/cfmx/sif/imagenes/delete.small.png'' border=''0'' width=''16'' height=''16'' /></a>'
				else ''
				end as img
		from AFResponsables afr
				inner join Activos act
					on act.Ecodigo = afr.Ecodigo
					and act.Aid = afr.Aid		
		where afr.Ecodigo = #Session.Ecodigo#
				and afr.DEid = #url.DEid#
				and #hoy#
				between afr.AFRfini and afr.AFRffin
				order by act.Aplaca		
		</cfoutput>
		</cfif>
	</cfsavecontent>

<!--- Pintado de los botones de regresar, impresión y exportar a excel. --->
<cf_htmlreportsheaders
	irA=""
	title="Lista de Activos" 
	back = "no"
	close= "yes"
	download="no"
	filename="ListadoActivos#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">

<cfhtmlhead text="
<style type='text/css'>
td {  font-size: xx-small; font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: normal}
a {
	text-decoration: none;
	color: ##000000;
}
.listaNon { background-color:##FFFFFF; vertical-align:middle; padding-left:5px;}
.listaPar { background-color:##FAFAFA; vertical-align:middle; padding-left:5px;}	.tituloSub {  font-weight: bolder; text-align: center; vertical-align: middle; font-size: small; border-color: black black ##CCCCCC; border-style: inset; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 1px; border-left-width: 0px}
.tituloListas {

	font-weight: bolder;
	vertical-align: middle;
	padding: 2px;
	background-color: ##F5F5F5;
}
</style>">

	<cfquery datasource="#session.DSN#" name="rsEmpresa">
		select 
			Edescripcion,ts_rversion,
			Ecodigo
		from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	
	<cfquery datasource="#session.DSN#" name="rsFuncionario">
		select 
			DEnombre  #_Cat# ' ' #_Cat#  DEapellido1  #_Cat# ' ' #_Cat#DEapellido2  as NombreCompleto
		from DatosEmpleado
		where Ecodigo =  #session.Ecodigo#
		and DEid  = #url.DEid#
	</cfquery>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="14%">
			  <cfinvoke
					 component="sif.Componentes.DButils"
					 method="toTimeStamp"
					 returnvariable="tsurl" arTimeStamp="#rsEmpresa.ts_rversion#"> </cfinvoke>
			      <cfoutput>
						<img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#&amp;ts=#tsurl#" alt="logo" width="190" height="110" border="0" class="iconoEmpresa"/>
					</cfoutput>					
			</td>
		</tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td nowrap class="tituloSub" align="center"><font size="4">Lista de Activos</font></td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
		<tr>
			<td align="center" colspan="5"><font size="2"><strong><cfoutput>Funcionario:&nbsp;#rsFuncionario.NombreCompleto#</cfoutput></strong></font></td>
		</tr>					

		<tr>
			<td colspan="5" align="center"><font size="2"><strong>Fecha:&nbsp;</strong><cfoutput>#LSDateFormat(now(),'dd/mm/yyyy')#</cfoutput>&nbsp;<strong>Hora:&nbsp;</strong><cfoutput>#TimeFormat(Now(),'medium')#</cfoutput></font></td>
	  </tr>	
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr class="tituloListas">
			<td nowrap><strong><font size="2">Placa</font></strong></td>
			<td nowrap><strong><font size="2">Descripci&oacute;n</font></strong></td>
			<td nowrap><strong><font size="2">Fecha</font></strong></td>
			<td nowrap><strong><font size="2">Estado</font></strong></td>
		</tr>
</cfoutput>

<cftry>
	<cfflush interval="512">
	<cf_jdbcquery_open name="rsLista" datasource="#session.DSN#">
		<cfoutput>#qryLista#</cfoutput>
	</cf_jdbcquery_open>
	<cfset class  = "">
	<cfoutput query="rsLista">
		<cfif class neq "listaNon">
			<cfset class = "listaNon">
		<cfelse>
			<cfset class = "listaPar">
		</cfif>
		<tr class="#class#">
			<td nowrap>&nbsp;#Aplaca#</td>
			<td nowrap>&nbsp;#Descripcion#</td>
			<td nowrap>&nbsp;#LSDateFormat(AFRfini, 'dd/mm/yyyy')#</td>
			<td nowrap="nowrap" width="10%">&nbsp;#Estado#</td>
		</tr>
	</cfoutput>
	<cfcatch type="any">
		<cf_jdbcquery_close>
		<cfthrow object="#cfcatch#">
	</cfcatch>
</cftry>
<cf_jdbcquery_close>

<cfoutput>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td nowrap align="center"><strong>--Fin de la Lista--</strong></td>
	  </tr>
	</table>
</cfoutput>
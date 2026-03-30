<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 21 de julio del 2005
	Motivo: Se agregó un filtro para la lista de las cuentas de mayor. 
			Se agregó un nuevo campo para desplegar en la lista, el campo de Revaluable.
			
	Modificado por: Ana Villavicencio
	Fecha: 12 de agosto del 2005
	Motivo: la lista de las cuentas estaba mal ubicada, cuando se oponia un filtro, colocaba la lista en el centro, horizontalmente.
			se abrego un td para arreglar el error.
			
 --->
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

<cfif isdefined("url.CmayorF") and Len(Trim(url.CmayorF))>
	<cfparam name="Form.CmayorF" default="#url.CmayorF#">
</cfif>
<cfif isdefined("url.CdescripcionF") and Len(Trim(url.CdescripcionF))>
	<cfparam name="Form.CdescripcionF" default="#url.CdescripcionF#">
</cfif>
<cfif isdefined("url.CtipoF") and Len(Trim(url.CtipoF))>
	<cfparam name="Form.CtipoF" default="#url.CtipoF#">
</cfif>

<cf_navegacion name="CmayorF" default="" session>
<cf_navegacion name="CdescripcionF" default="" session>
<cf_navegacion name="CtipoF" default="" session>

<cfif isdefined("session.modulo") and session.modulo EQ "CG">
	<cfinclude template="../../portlets/pNavegacionCG.cfm">
<cfelseif isdefined("session.modulo") and session.modulo EQ "AD">
	<cfinclude template="../../portlets/pNavegacionAD.cfm">
</cfif>
<cfparam name="addCols" default="">
<cf_templateheader title="SIF - Cuentas de Mayor"> 
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cuentas de Mayor'>	
		<table style="width:20%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td valign="top" style="width:20%">
					<cfinclude template="CtasMayorFiltro.cfm">
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
						tabla="CtasMayor" 
						columnas="Cmayor, Cdescripcion, Ctipo,
							case 
							when Ctipo = 'A' then 'Activo' 
							when Ctipo = 'P' then 'Pasivo' 
							when Ctipo = 'C' then 'Capital'
							when Ctipo = 'I' then 'Ingreso' 
							when Ctipo = 'G' then 'Gasto' 
							when Ctipo = 'O' then 'Orden'  
							else ''
							end as Tipo,
							case when Crevaluable = 0 then  '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'  else  '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' end as Revaluable
							#preserveSingleQuotes(addCols)#"
						desplegar="Cmayor, Cdescripcion, Tipo, Revaluable"
						etiquetas="Cuenta, Descripción, Tipo, Revalua"
						formatos=""
						filtro="Ecodigo=#session.Ecodigo# #filtro# order by Cmayor"
						align="left, left, left,center"
						checkboxes="N"
						keys="Cmayor"
						ira="CuentasMayor.cfm"
						navegacion="#navegacion#"
						PageIndex="10">
					</cfinvoke>
				</td>
				<td valign="top" style="width:20%">
					<cfinclude template="formCuentasMayor.cfm">
				</td>
				<td valign="top" align="right">
					<cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="300" url="Cuentas_Mayor.htm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>
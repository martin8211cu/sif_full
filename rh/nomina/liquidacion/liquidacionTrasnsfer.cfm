<cfquery name="rsParam" datasource="#session.DSN#">
	select coalesce(Pvalor,'#session.Ecodigo#') as  Pvalor
	from  RHParametros 
	where Pcodigo = 590 
	and Ecodigo   =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nombre_proceso" Default="Mov. de Conceptos de Liquidaci&oacute;n Entre Empresas" returnvariable="nombre_proceso"/> 
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	
	<cf_web_portlet_start titulo='#nombre_proceso#'>
		<cfoutput>#pNavegacion#</cfoutput>
		<cfif isdefined('rsParam.Pvalor') and len(trim('rsParam.Pvalor')) and rsParam.Pvalor neq session.Ecodigo >
			<cfif isdefined('Form.DLlinea') and len(trim('Form.DLlinea')) and IsNumeric(Form.DLlinea)>
			   <cfinclude template="liquidacionTrasnsfer-form.cfm">	
			<cfelse>
				<cfinclude template="liquidacionTrasnsfer-lista.cfm">
			</cfif>
			
		<cfelse>
			<cfoutput>
			<table width="100%" cellpadding="3" cellspacing="0" class="areaFiltro">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td align="center"><cf_translate key="Error_Misma_Empresa">Usted esta trabajando con la emprea origen para hacer movimientos de conceptos de liquidaci&oacute;n entre empresas (#session.Enombre#). No puede realizar movimientos a ella misma.</cf_translate></td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
			</cfoutput>		
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>

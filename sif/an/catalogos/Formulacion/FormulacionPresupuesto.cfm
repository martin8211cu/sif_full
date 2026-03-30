<!---
Modulo: Anexos Finacientos
Opcion:Formulación de control de Presupuesto
Codigo: ANFORPRE  
26 de Marzo del 2009
--->
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Definici&oacute;n de Formulaciones de Control de Presupuesto para Anexos Financieros" returnvariable="LB_Titulo" xmlfile="FormulacionPresupuesto.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Codigo" 	default="C&oacute;digo" 
returnvariable="LB_Codigo" xmlfile="FormulacionPresupuesto.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Descripcion" 	default="Descripci&oacute;n" 
returnvariable="LB_Descripcion" xmlfile="FormulacionPresupuesto.xml"/>
<cfset LvarTit = "Definición de Formulaciones de Control de Presupuesto para Anexos Financieros">
<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td colspan="2">
					<cfinclude template="/sif/portlets/pNavegacion.cfm">
				</td>
			</tr>
			<tr> 
				<td valign="top"> 
					<cfquery name="rsLista" datasource="#session.DSN#">
						 select  ANFid,ANFcodigo,ANFdescripcion
   							from ANformulacion
						 where Ecodigo= #session.Ecodigo#
						 <cfif isdefined ('form.filtro_ANFcodigo') and len(trim(form.filtro_ANFcodigo)) gt 0>
						 	and lower(ANFcodigo) like lower('%#form.filtro_ANFcodigo#%')
						 </cfif>
						  <cfif isdefined ('form.filtro_ANFdescripcion') and len(trim(form.filtro_ANFdescripcion)) gt 0>
						 	and lower(ANFdescripcion) like lower('%#form.filtro_ANFdescripcion#%')
						 </cfif>
					</cfquery>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
						<cfinvokeargument name="query" 			  value="#rsLista#"/>
						<cfinvokeargument name="desplegar"  	  value="ANFcodigo,ANFdescripcion"/>
						<cfinvokeargument name="etiquetas"  	  value="#LB_Codigo#,#LB_Descripcion#"/>
						<cfinvokeargument name="formatos"   	  value="S,S"/>
						<cfinvokeargument name="align" 			  value="left,left"/>
						<cfinvokeargument name="ajustar"   		  value="N"/>
						<cfinvokeargument name="irA"              value="FormulacionPresupuesto.cfm"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="keys"             value="ANFid"/>
						<cfinvokeargument name="mostrar_filtro"   value="true"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
					</cfinvoke>
				</td>
				<td width="55%">
					<cfinclude template="FormulacionPresupuesto-form.cfm">
				</td>
			</tr>
	 	</table>
	<cf_web_portlet_end>
<cf_templatefooter>
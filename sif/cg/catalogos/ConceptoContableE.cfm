<cf_templateheader title="Contabilidad General">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Conceptos Contables'>
		<cfif isdefined("session.modulo") and session.modulo EQ "CG">
			<cfinclude template="../../portlets/pNavegacionCG.cfm">
		<cfelseif isdefined("session.modulo") and session.modulo EQ "AD">
			<cfinclude template="../../portlets/pNavegacionAD.cfm">
		</cfif>			
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr> 
			<td valign="top"> 
				 <cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
					<cfinvokeargument name="tabla" 				value="ConceptoContableE"/>
					<cfinvokeargument name="columnas" 			value="Cconcepto, Cdescripcion"/>
					<cfinvokeargument name="desplegar" 			value="Cconcepto, Cdescripcion"/>
					<cfinvokeargument name="etiquetas" 			value="Código, Descripción del Concepto"/>
					<cfinvokeargument name="formatos" 			value="S,S"/>
					<cfinvokeargument name="filtro"				value="Ecodigo= #Session.Ecodigo#"/>
					<cfinvokeargument name="align" 				value="left,left"/>
					<cfinvokeargument name="ajustar" 			value="N,N"/>
					<cfinvokeargument name="checkboxes" 		value="N"/>
					<cfinvokeargument name="keys" 				value="Cconcepto"/>
					<cfinvokeargument name="irA" 				value="ConceptoContableE.cfm"/>
					<cfinvokeargument name="mostrar_filtro" 	value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
				 </cfinvoke>
			</td>				
			<td valign="top">
			  	<cfinclude template="formConceptoContableE.cfm">
			 </td>
			 <td valign="top" align="right">
			 	<cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Concepto_contable.htm">	
			 </td>
		 	</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
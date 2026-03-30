<!--- <cfdump var="#Session.Ecodigo#"> --->

<cfinvoke key="LB_Titulo" default="Asignacion de Metodo de Pago " returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate"
xmlfile="CatalogoMtdoPago.xml"/>
<cfinvoke key="LB_Clave" default="Clave" returnvariable="LB_Clave" component="sif.Componentes.Translate" method="Translate"
xmlfile="CatalogoMtdoPago.xml"/>
<cfinvoke key="LB_Concepto" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate"
xmlfile="CatalogoMtdoPago.xml"/>
<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<cfinclude template="../../../portlets/pNavegacionCG.cfm">
		<cfset filtro = "">
		<cfset navegacion = "">

			<cfset IRA = 'list.cfm'>

			<cfquery name="rsQueryConsulta" datasource="#session.DSN#">
				SELECT tmp.TESTMPtipo, tmp.TESTMPdescripcion, mtd.Clave, mtd.Concepto 
				FROM TEStipoMedioPago tmp LEFT OUTER JOIN CEMtdoPago mtd
				ON tmp.TESTMPMtdoPago = mtd.Clave
				ORDER BY TESTMPtipo
			</cfquery>

			<!--- <cf_dump var="#rsQueryConsulta#"> --->
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top" width="55%">

					<cfinvoke
					 	component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet"> 
						<cfinvokeargument name="query" value="#rsQueryConsulta#"/> 
						<cfinvokeargument name="desplegar" value="TESTMPtipo,TESTMPdescripcion,Clave,Concepto"/> 
						<cfinvokeargument name="etiquetas" value="Tipo,Descripci&oacute;n,Clave SAT, M&eacute;todo de pago SAT"/> 
						<cfinvokeargument name="formatos" value="S,S,S,S"/> 
						<cfinvokeargument name="align" value="center,left,center,left"/> 
						<cfinvokeargument name="ajustar" value="N"/> 
						<cfinvokeargument name="checkboxes" value="N"/> 
						<cfinvokeargument name="irA" value="#IRA#"/>
						<cfinvokeargument name="keys" value="TESTMPtipo"/> 
						<cfinvokeargument name="showEmptyListMsg" value="true"/>						
						<!--- <cfinvokeargument name="cortes" value="tipo"/> --->
						<cfinvokeargument name="maxrows" value="30"/>
						<cfinvokeargument name="PageIndex" value="2"/>
						<cfinvokeargument name="usaAjax" value="true"/>
						<cfinvokeargument name="conexion" value="#session.dsn#"/>
				 </cfinvoke>
				</td>
				<td valign="top">
					<cfinclude template="form.cfm">
				</td>
		 	</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">

<cf_templatecss>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Evaluacion180Jefe"
		Default="Evaluaci&oacute;n del Desempe&ntilde;o de Jefaturas"
		returnvariable="LB_Evaluacion180Jefe"/>	
	<cf_web_portlet_start titulo="#LB_Evaluacion180Jefe#" border="true" skin="#Session.Preferences.Skin#">
	<cfinclude template="../../../../portlets/pNavegacion.cfm">

	<cfquery name="rsEmpleadosJefes" datasource="#session.DSN#">
		select a.DEid  from RHRegistroEvaluadoresE  a
		where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>

	<cfset  altura = (rsEmpleadosJefes.RecordCount * 25) +  450> 
	
	<TABLE  width="100%"  cellspacing="0" cellpadding="0" border="0">
		<TBODY>
			<TR vAlign=top>
				<TD>
					<cfoutput>
					<IFRAME 
						id="DETALLE_DERECHA" 
						name="DETALLE_DERECHA"
						marginWidth="0"
						marginheight="0"
						src="Evaluacion_instrucciones.cfm?REID=#form.REID#&personas=#rsEmpleadosJefes.RecordCount#" 
						frameBorder="0"
						width="980"
						scrolling="no"
						height="#altura#">
					</IFRAME>
					</cfoutput>
				</TD>
			</TR>
		</TBODY>
	</TABLE>
  	<cf_web_portlet_end>
<cf_templatefooter>	

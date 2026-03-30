<!---►►►Variables de Navegacion◄◄◄--->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfset modo = 'ALTA'>
<cfset modoD = 'ALTA'>
<cfif isdefined('url.RHRPTNid') and not isdefined('form.RHRPTNid')>
	<cfset form.RHRPTNid = url.RHRPTNid>
</cfif>
<cfif isdefined('url.RHCRPTid') and not isdefined('form.RHCRPTid')>
	<cfset form.RHCRPTid = url.RHCRPTid>
</cfif>
<cfif isdefined('form.RHCRPTid') and form.RHCRPTid GT 0>
	<cfset modoD = 'CAMBIO'>
</cfif>
<cfif isdefined('form.RHRPTNid') and form.RHRPTNid GT 0>
	<cfset modo = 'CAMBIO'>
</cfif>
<cfset filtro 	  = 'RHRPTNid =' & form.RHRPTNid>
<cfset navegacion = '&RHRPTNid=' & form.RHRPTNid>
<cf_dbfunction name="sPart" args="RHCRPTdescripcion$1$50" returnvariable="RHCRPTdescripcion" delimiters="$">
<!---►►►Variables de Traduccion◄◄◄ --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Anno" 				Default="Año" 					returnvariable="LB_Anno"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CODIGO"				Default="Código" 				returnvariable="LB_CODIGO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DESCRIPCION" 		Default="Descripción" 			returnvariable="LB_DESCRIPCION"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Incidencias" 		Default="Incidencias" 			returnvariable="LB_Incidencias"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Deducciones" 		Default="Deducciones" 			returnvariable="LB_Deducciones"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ConceptoDePago" 		Default="Concepto de Pago" 		returnvariable="LB_ConceptoDePago"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ConceptosDePago" 	Default="Conceptos de Pago" 	returnvariable="LB_ConceptosDePago"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Deduccion" 			Default="Deducción" 			returnvariable="LB_Deduccion"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_CODIGO" 			Default="Código" 				returnvariable="MSG_CODIGO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DESCRIPCION" 		Default="Descripción" 			returnvariable="MSG_DESCRIPCION"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Carga" 				Default="Carga" 				returnvariable="LB_Carga"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cargas" 				Default="Cargas" 				returnvariable="LB_Cargas"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" 	Default="Recursos Humanos" 		returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" 	Default="#nav__SPdescripcion#" 	returnvariable="LB_nav__SPdescripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Origendedatos" 		Default="Origen de datos" 		returnvariable="LB_Origendedatos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DebeSeleccionarUnConceptoDePago" Default="Debe seleccionar un concepto de pago" returnvariable="MSG_DebeSeleccionarUnConceptoDePago"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DebeSeleccionarUnaDeduccion" 	 Default="Debe seleccionar una deducción" 		returnvariable="MSG_DebeSeleccionarUnaDeduccion"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DebeSeleccionarUnaCarga" 		 Default="Debe seleccionar una Carga" 			returnvariable="MSG_DebeSeleccionarUnaCarga"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DeseaEliminarElRegistro" 		 Default="Desea eliminar el registro?" 			returnvariable="MSG_DeseaEliminarElRegistro"/>	

<!---►►►Consultas de Generales◄◄◄ --->
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
    	select RHRPTNcodigo, RHRPTNdescripcion
        from RHReportesNomina
        where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
          and RHRPTNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRPTNid#">
    </cfquery>
    <cfif modoD NEQ 'ALTA'>
		<cfquery name="rsFormD" datasource="#session.DSN#">
        	select RHCRPTcodigo,RHCRPTdescripcion, RHRPTNOrigen
            from RHColumnasReporte  
            where RHRPTNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRPTNid#">
              and RHCRPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCRPTid#">
        </cfquery>
	</cfif>
</cfif>
<cf_templateheader title="#LB_RecursosHumanos#">
    <cfoutput>#pNavegacion#</cfoutput>
  	<cf_web_portlet_start border="true" titulo="#LB_nav__SPdescripcion#" skin="#session.preferences.skin#" >
        <table width="100%" cellpadding="0" cellspacing="0">
        	<tr><td colspan="2" align="center">
			<cfoutput>
            	<form name="form1" method="post" action="ReportesDinamicos-sql.cfm">
            		<input name="RHRPTNid" type="hidden" value="<cfif isdefined('form.RHRPTNid')>#RHRPTNid#</cfif>">
                    	<table width="75%" cellpadding="2" cellspacing="2" border="0">
                            <tr>
                           	  	<td width="25%" align="right"><strong>#LB_CODIGO#:</strong>&nbsp;</td>
                                <td width="75%">
                                  	<input name="RHRPTNcodigo" type="text" tabindex="1" value="<cfif modo NEQ 'ALTA'>#rsForm.RHRPTNcodigo#</cfif>"/>
                                </td>
                            </tr>
                            <tr>
                           	  	<td width="25%" align="right"><strong>#LB_DESCRIPCION#:</strong>&nbsp;</td>
                                <td width="75%">
 									<input name="RHRPTNdescripcion" type="text" tabindex="1" size="60" value="<cfif modo NEQ 'ALTA'>#rsForm.RHRPTNdescripcion#</cfif>"/>
                                </td>
                            </tr>
                            <tr><td colspan="2" align="center"><cf_botones modo="#modo#" regresar="ReportesDinamicos-lista.cfm" tabindex="1"></td></tr>
                            <tr><td colspan="2">&nbsp;</td></tr>
                      	</table>
				</form>
			</cfoutput>
            </td></tr>
            <cfif modo NEQ 'ALTA'>
			<tr>
				<td width="50%" valign="top">
                    <cfinvoke component="rh.Componentes.pListas" method="pListaRH" returnvariable="pListaEduRet">
                        <cfinvokeargument name="tabla" 		value="RHColumnasReporte"/>
                        <cfinvokeargument name="columnas" 	value="RHRPTNid,RHCRPTid,RHCRPTcodigo,#PreserveSingleQuotes(RHCRPTdescripcion)# as RHCRPTdescripcion"/>
                        <cfinvokeargument name="desplegar" 	value="RHCRPTcodigo,RHCRPTdescripcion"/>
                        <cfinvokeargument name="etiquetas" 	value="#LB_CODIGO#, #LB_DESCRIPCION#"/>
                        <cfinvokeargument name="formatos" 	value="S,S"/>
                        <cfinvokeargument name="filtro" 	value="#filtro# order by RHCRPTcodigo "/>
                        <cfinvokeargument name="align" 		value="left, left"/>
                        <cfinvokeargument name="ajustar" 	value="N"/>
                        <cfinvokeargument name="irA" 		value="ReportesDinamicos.cfm"/>
                        <cfinvokeargument name="keys" 		value="RHCRPTid"/>
                        <cfinvokeargument name="debug" 		value="N"/>
                        <cfinvokeargument name="navegacion" value="#navegacion#"/>
                  	</cfinvoke>
				</td>
				<td width="50%" valign="top">
					<cfinclude template="ReportesDinamicos-form.cfm">
				</td>
			</tr>
            </cfif>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form="form1" objForm='objForm1'>
	<cf_qformsrequiredfield args="RHRPTNcodigo,#MSG_CODIGO#">
    <cf_qformsrequiredfield args="RHRPTNdescripcion,#MSG_DESCRIPCION#">
</cf_qforms>  
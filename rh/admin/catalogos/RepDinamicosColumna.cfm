<!---►►►Variables de Navegacion◄◄◄--->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfset modo = 'ALTA'>
<cfset modoD = 'ALTA'>
<cfif isdefined('url.RHRDEid') and not isdefined('form.RHRDEid')>
	<cfset form.RHRDEid = url.RHRDEid>
</cfif>
<cfif isdefined('url.Cid') and not isdefined('form.Cid')>
	<cfset form.RHRDCid = url.Cid>
</cfif>

<cfif isdefined('form.Cid') and form.Cid GT 0>
	<cfset modoD = 'CAMBIO'>
</cfif>
<cfif isdefined('form.RHRDEid') and form.RHRDEid GT 0>
	<cfset modo = 'CAMBIO'>
</cfif>
<cfset filtro =''>
<cfset navegacion=''>
<cfif isdefined('form.RHRDEid') and form.RHRDEid GT 0>
	<cfset filtro 	  = 'RHRDEid =' & form.RHRDEid>
	<cfset navegacion = '&RHRDEid=' & form.RHRDEid>
</cfif>	

<!---►►►Variables de Traduccion◄◄◄ --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Anno" 				Default="Año" 					returnvariable="LB_Anno"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CODIGO"				Default="Código" 				returnvariable="LB_CODIGO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DESCRIPCION" 		Default="Descripción" 			returnvariable="LB_DESCRIPCION"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ORDEN" 				Default="Orden" 			r	eturnvariable="LB_ORDEN"/>		
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CORPORATIVO" 		Default="Corporativo" 			returnvariable="LB_CORPORATIVO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MOSTRAR"	 			Default="Visible" 				returnvariable="LB_MOSTRAR"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TIPO"	 			Default="Tipo" 					returnvariable="LB_TIPO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ORDEN"	 			Default="Orden" 				returnvariable="LB_ORDEN"/>
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
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ConfigurarColumna" 	Default="Configurar Columna" 	returnvariable="LB_ConfigurarColumna"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Origendedatos" 		Default="Origen de datos" 		returnvariable="LB_Origendedatos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DebeSeleccionarUnConceptoDePago" Default="Debe seleccionar un concepto de pago" returnvariable="MSG_DebeSeleccionarUnConceptoDePago"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DebeSeleccionarUnaDeduccion" 	 Default="Debe seleccionar una deducción" 		returnvariable="MSG_DebeSeleccionarUnaDeduccion"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DebeSeleccionarUnaCarga" 		 Default="Debe seleccionar una Carga" 			returnvariable="MSG_DebeSeleccionarUnaCarga"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DeseaEliminarElRegistro" 		 Default="Desea eliminar el registro?" 			returnvariable="MSG_DeseaEliminarElRegistro"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Modulo" 		 					 Default="Modulo" 			returnvariable="LB_Modulo"/>	
<cfset t=createObject("component", "sif.Componentes.Translate")>
<cfset LB_Empleado = t.translate('LB_Empleado','Empleado','/rh/generales.xml')>
<cfset LB_Si = t.translate('LB_Si','Si','/rh/generales.xml')>
<cfset LB_No = t.translate('LB_No','No','/rh/generales.xml')>
<cfset LB_Sumarizar = t.translate('LB_Sumarizar','Sumarizar','/rh/generales.xml')>
<cfset LB_Nomina = t.translate('LB_Nomina','Nómina','/rh/generales.xml')>
<cfset LB_InformacionSalarial = t.translate('LB_InformacionSalarial','Información salarial')>
<cfset LB_Empresa= t.translate('LB_Empresa','Empresa','/rh/generales.xml')>
<cfset LB_Formular = t.translate('LB_Formular','Formular','/rh/generales.xml')>
<cfset LB_Totalizar = t.translate('LB_Totalizar','Totalizar','/rh/generales.xml')>

<!---►►►Consultas de Generales◄◄◄ --->
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
    	select RHRDEcodigo, RHRDEdescripcion
        from RHReportesDinamicoE
        where RHRDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRDEid#">
    </cfquery>
</cfif>
<cf_templateheader>
  	<cf_web_portlet_start>

        <table width="100%" cellpadding="0" cellspacing="0">
        	<tr><td colspan="2" align="center">
			<cfoutput>
            	<form name="form1" method="post" action="RepDinamicos-sql.cfm">
            		<input name="RHRDEid" type="hidden" value="<cfif isdefined('form.RHRDEid')>#RHRDEid#</cfif>">
                    	<table width="75%" cellpadding="2" cellspacing="2" border="0">
                            <tr>
                           	  	<td width="25%" align="right"><strong>#LB_CODIGO#:</strong>&nbsp;</td>
                                <td width="75%">
                                  	<input name="RHRDEcodigo" type="text" maxlength="14" tabindex="1" value="<cfif modo NEQ 'ALTA'>#rsForm.RHRDEcodigo#</cfif>"/>
                                </td>
                            </tr>
                            <tr>
                           	  	<td width="25%" align="right"><strong>#LB_DESCRIPCION#:</strong>&nbsp;</td>
                                <td width="75%">
 									<input name="RHRDEdescripcion" type="text" tabindex="1" size="60" value="<cfif modo NEQ 'ALTA'>#rsForm.RHRDEdescripcion#</cfif>"/>
                                </td>
                            </tr>
							<tr>
								<td width="25%" align="right"><strong>#LB_Modulo#:</strong>&nbsp;</td>
                                <td width="75%">
									<select name="Modulo" id="Modulo">
										<option value="RH"><cf_translate key="LB_EsUsadoEnNomina">Es usado en Nomina</cf_translate></option>
										<option value="TE"><cf_translate key="LB_EsUsadoEnTesoreria">Es usado en Tesorería</cf_translate></option>
									</select>
								</td>
							</tr>
                            <tr><td colspan="2" align="center"><cf_botones modo="#modo#" regresar="RepDinamicos.cfm" tabindex="1"></td></tr>
                            <tr><td colspan="2">&nbsp;</td></tr>
                      	</table>
				</form>
			</cfoutput>
            </td></tr>
            <cfif modo NEQ 'ALTA'>
			<tr>
				<td  width="50%" valign="top">

					<cf_dbfunction name="sPart" args="Cdescripcion$1$50" returnvariable="Cdescripcion" delimiters="$">
					
                    <cfinvoke component="rh.Componentes.pListas" method="pListaRH" >
                        <cfinvokeargument name="tabla" 		value="RHReportesDinamicoC"/>
                        <cfinvokeargument name="columnas" 	value="RHRDEid,Cid,Corden,
																	case Cmostrar when 1 then '#LB_Si#' else '#LB_No#' end as Cmostrar,
																	case 
																		when  Ctipo = 1 then '#LB_Sumarizar#' 
																		when  Ctipo = 2 then '#LB_Empleado#' 
																		when  Ctipo = 3 then '#LB_Nomina#' 
																		when  Ctipo = 4 then '#LB_InformacionSalarial#' 
																		when  Ctipo = 9 then '#LB_Empresa#' 
																		when  Ctipo = 10 then '#LB_Formular#' 
																		when  Ctipo = 20 then '#LB_Totalizar#' 
																	end as Ctipo 
																	,#PreserveSingleQuotes(Cdescripcion)# as Cdescripcion"/>
                        <cfinvokeargument name="desplegar" 	value="Cdescripcion,Cmostrar,Ctipo,Corden"/>
                        <cfinvokeargument name="etiquetas" 	value="#LB_DESCRIPCION#,#LB_MOSTRAR#,#LB_TIPO#,#LB_ORDEN#"/>
                        <cfinvokeargument name="formatos" 	value="S,S,S,S"/>
                        <cfinvokeargument name="filtro" 	value="#filtro# order by Corden asc "/>
                        <cfinvokeargument name="align" 		value="left,center,center,center"/>
                        <cfinvokeargument name="ajustar" 	value="N"/>
						<cfinvokeargument name="maxrows" 	value="50"/>
                        <cfinvokeargument name="irA" 		value="RepDinamicosColumna.cfm"/>
                        <cfinvokeargument name="keys" 		value="Cid"/>
                        <cfinvokeargument name="debug" 		value="N"/>
                        <cfinvokeargument name="navegacion" value="#navegacion#"/>
                  	</cfinvoke>
				</td>
				<td width="50%" valign="top">
					<cfinclude template="RepDinamicos-form.cfm">
				</td>
			</tr>
            </cfif>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form="form1" objForm='objForm1'>
	<cf_qformsrequiredfield args="RHRDEcodigo,#MSG_CODIGO#">
    <cf_qformsrequiredfield args="RHRDEdescripcion,#MSG_DESCRIPCION#">
</cf_qforms>  
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Retenciones"
	Default="Retenciones"
	returnvariable="LB_Retenciones"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConceptoDePago"
	Default="Concepto de Pago"
	returnvariable="LB_ConceptoDePago"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Metodo"
	Default="M&eacute;todo"
	returnvariable="LB_Metodo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Horas"
	Default="Horas"
	returnvariable="LB_Horas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Dias"
	Default="D&iacute;as"
	returnvariable="LB_Dias"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Importe"
	Default="Importe"
	returnvariable="LB_Importe"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Calculo"
	Default="C&aacute;lculo"
	returnvariable="LB_Calculo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Porcentaje"
	Default="Porcentaje"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Porcentaje"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Retencion"
	Default="Retenci&oacute;n"
	returnvariable="LB_Retencion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Obligatoria"
	Default="Obligatoria"
	returnvariable="LB_Obligatoria"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Prioridad"
	Default="Prioridad"
	returnvariable="LB_Prioridad"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoSeEncontraronRegistros"
	Default="No se encontraron registros"
	returnvariable="vNoRegistros"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeRetenciones"
	Default="Lista de Retenciones"
	returnvariable="LB_ListaDeRetenciones"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Socio"
	Default="Socio"
	returnvariable="LB_Socio"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElPorcentajeDebeEstarEntre0Y100"
	Default="El porcentaje debe estar entre 0 y 100"
	returnvariable="MSG_ElPorcentajeDebeEstarEntre0Y100"/>	


<cfif isdefined('url.CIid') and url.CIid GT 0 and not isdefined('form.CIid')>
	<cfset form.CIid = url.CIid>
</cfif>
<!--- CONSULTAS --->
<!--- DATOS DE LA CINCIDENCIA --->
<cfquery name="rsCIncidencia" datasource="#session.DSN#">
	select CIcodigo,CIdescripcion,CItipo
	from CIncidentes
	where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
</cfquery>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="javascript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>                  
	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.cache_empresarial = 0>
	  

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">		    	            
				
				<cf_web_portlet_start titulo="#LB_Retenciones#">
				  	<cfinclude template="/rh/portlets/pNavegacion.cfm">
		            <table width="100%" border="0" cellspacing="0" cellpadding="0">
			            <tr>
							<td colspan="2">
								<cfoutput>
								<table width="75%" cellpadding="2" cellspacing="2" align="center" border="0">
									<tr><td colspan="2">&nbsp;</td></tr>
									<tr>
										<td align="right"><strong>#LB_ConceptoDePago#:&nbsp</strong></td>
										<td>#rsCIncidencia.CIcodigo# - #rsCIncidencia.CIdescripcion#</td>
									</tr>
									<tr>
										<td align="right"><strong>#LB_Metodo#:&nbsp</strong></td>
										<td>
											<cfif rsCIncidencia.CItipo EQ 0> #LB_Horas#
											<cfelseif rsCIncidencia.CITipo EQ 1>#LB_Dias#
											<cfelseif rsCIncidencia.CITipo EQ 2>#LB_Importe#
											<cfelseif rsCIncidencia.CITipo EQ 3>#LB_Calculo#
											</cfif>
										</td>
									</tr>
									<tr><td colspan="2">&nbsp;</td></tr>
								</table>
								</cfoutput>
							</td>
						</tr>
		            	<tr valign="top"> 
		                	<td width="50%"> 
			                	<cfset navegacion = "">
			                	<cfif isdefined("Form.CIid") and Len(Trim(Form.CIid)) NEQ 0>
									<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CIid=" & Form.CIid>
				                </cfif>
								<!-----LISTA DE LAS RENTENCIONES DEL CONCEPTO DE PAGO----->	
								<cfinvoke 
								 component="rh.Componentes.pListas"
								 method="pListaRH"
								 returnvariable="pListaRet">
									<cfinvokeargument name="tabla" value="RHDeduccionesReb"/>
									<cfinvokeargument name="columnas" value="CIid,TDid,Porcentaje,SNcodigo,Descripcion"/>
									<cfinvokeargument name="desplegar" value="Descripcion,Porcentaje"/>
									<cfinvokeargument name="etiquetas" value="#LB_Descripcion#,#LB_Porcentaje#"/>
									<cfinvokeargument name="formatos" value="S,M"/>
									<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# and CIid = #form.CIid# order by Descripcion"/>
									<cfinvokeargument name="align" value="left, left"/>
									<cfinvokeargument name="ajustar" value=""/>
									<cfinvokeargument name="checkboxes" value="N"/>
									<cfinvokeargument name="irA" value="Retenciones.cfm"/>
									<cfinvokeargument name="filtrar_automatico" value="true">
									<cfinvokeargument name="mostrar_filtro" value="true">
									<cfinvokeargument name="keys" value="TDid">
									<cfinvokeargument name="navegacion" value="#navegacion#"/>
								</cfinvoke>
		                	</td>
		                	<td width="50%"><cfinclude template="Retenciones-form.cfm"></td>
		              	</tr>
           				<tr valign="top"><td colspan="2">&nbsp;</td></tr>
		            </table>
			  	<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>

<script>
	<cfoutput>
	function funcFiltrar(){
		document.lista.CIID.value= #form.CIid#;
		return true;
	}
	</cfoutput>
</script>
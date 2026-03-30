<!--- CONCEPTOS DE PAGOS QUE SE EXCLUYEN EN EL CALCULO DE LAS CARGAS PATRONALES EN EL DETALLE DE LA CARGA --->
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RegistroDeExcepcionesDeConceptosDePago" Default="Registro de Excepciones de Conceptos de Pago" returnvariable="LB_RegistroDeExcepcionesDeConceptosDePago" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_RecursosHumanos" 	Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CODIGO" Default="C&oacute;digo" XmlFile="/rh/generales.xml" returnvariable="LB_CODIGO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DESCRIPCION" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ValorEmpleado" Default="Valor Empleado" returnvariable="LB_ValorEmpleado" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ValorPatrono" Default="Valor Patrono" returnvariable="LB_ValorPatrono" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_METODO" Default="Método" XmlFile="/rh/generales.xml" returnvariable="LB_METODO" component="sif.Componentes.Translate" method="Translate"/>				
<cfinvoke Key="LB_ConceptoDePago" Default="Concepto de Pago" returnvariable="LB_ConceptoDePago" component="sif.Componentes.Translate" method="Translate"/>				
<cfinvoke Key="MSG_NoHayRegistrosRelacionados" Default="No hay registros relacionados" returnvariable="MSG_NoHayRegistrosRelacionados" component="sif.Componentes.Translate" method="Translate"/>				
<cfinvoke Key="LB_TITULOCONLISCONCEPTOSPAGO" Default="Lista de Conceptos de Pago" returnvariable="LB_TITULOCONLISCONCEPTOSPAGO"component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_ConceptoDePago" Default="Concepto de Pago" returnvariable="MSG_ConceptoDePago" component="sif.Componentes.Translate" method="Translate"/>				
<cfinvoke Key="LB_DetalleCarga" Default="Detalle Carga" returnvariable="LB_DetalleCarga" component="sif.Componentes.Translate" method="Translate"/>				
<cfinvoke Key="LB_Carga" Default="Carga" returnvariable="LB_Carga" component="sif.Componentes.Translate" method="Translate"/>				
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined('url.ECid') and LEN(TRIM(url.ECid)) and not isdefined('form.ECid')>
	<cfset form.ECid = url.ECid>
</cfif>
<cfif isdefined('url.DClinea') and LEN(TRIM(url.DClinea)) and not isdefined('form.DClinea')>
	<cfset form.DClinea = url.DClinea>
</cfif>	
<cfset navegacion = "">
<cfif isdefined("Form.ECid") and Len(Trim(Form.ECid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ECid=" & Form.ECid>
</cfif>
<cfif isdefined("Form.DClinea") and Len(Trim(Form.DClinea)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DClinea=" & Form.DClinea>
</cfif>
<!--- DATOS DEL DETALLE --->
<cfquery name="rsCarga" datasource="#session.DSN#">
	select *
	from ECargas a
	inner join DCargas b
		on b.ECid = a.ECid
	where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
	  and b.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">
</cfquery>

<cf_templateheader title="#LB_RecursosHumanos#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cfparam name="filtro" default=" ">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_RegistroDeExcepcionesDeConceptosDePago#">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td colspan="2">
					<cfset Regresar = "CargasOP.cfm?ECid=#ECid#&DClinea=#DClinea#&modoDet=CAMBIO">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
				</td>          
			</tr>	
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="2">
					<table align="center">
						<tr>
							<td colspan="2"><cfoutput><strong>#LB_Carga#:</strong>&nbsp;#rsCarga.ECcodigo# - #rsCarga.ECdescripcion#</cfoutput></td>
						</tr>
						<tr>
							<td colspan="2"><cfoutput><strong>#LB_DetalleCarga#:</strong>&nbsp;#rsCarga.DCcodigo# - #rsCarga.DCdescripcion#</cfoutput></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>					
			<tr> 
				<td valign="top" nowrap width="50%">
					<cf_dbfunction name="to_char" returnvariable="CIid_char" args="a.CIid">
					<cf_dbfunction name="concat" returnvariable="imagen" args="<img border=''0'' src=''/cfmx/rh/imagenes/Borrar01_S.gif'' onClick=javascript:funcEliminar('''+#CIid_char#+''')>" delimiters="+">

					<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaRH"
						returnvariable="pListaRel">
						<cfinvokeargument name="tabla" value="DCTDeduccionExcluir a
																inner join CIncidentes b
																	on b.CIid = a.CIid 
																	and b.Ecodigo = #session.Ecodigo#
																inner join DCargas c
																	on c.DClinea = a.DClinea"/>
						<cfinvokeargument name="columnas" value="a.DClinea,
																 ECid,
																 a.CIid as CIidL,
																 CIcodigo as CIcodigoL,
																 CIdescripcion as CIdescripcionL,
																 '#imagen#' as eliminar"/>
						<cfinvokeargument name="desplegar" value="CIcodigoL,CIdescripcionL,eliminar"/>
						<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#, "/>
						<cfinvokeargument name="formatos" value="S,S,U"/>
						<cfinvokeargument name="filtro" value="a.DClinea = #form.DClinea#
																order by a.DClinea	"/>
						<cfinvokeargument name="align" value="left,left,center"/>
						<cfinvokeargument name="ajustar" value=""/>				
						<cfinvokeargument name="irA" value="SQLProvisiones.cfm"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="debug" value="N"/>
						<cfinvokeargument name="maxRows" value="30"/>
						<cfinvokeargument name="keys" value="DClinea,CIidL"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="filtrar_por" value="CIcodigo,CIdescripcion,eliminar"/>
						<cfinvokeargument name="EmptyListMsg" value="#MSG_NoHayRegistrosRelacionados#"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="showLink" value="false"/>
					</cfinvoke>	
				</td>
				<td valign="top" nowrap  width="50%" align="center"><cfinclude template="formProvisiones.cfm"></td>
			</tr>			
		</table>	
	<cf_web_portlet_end>
<cf_templatefooter>
<script>
	function funcFiltrar(){
		document.lista.ECID.value = '<cfoutput>#form.ECid#</cfoutput>';
		document.lista.DCLINEA.value = '<cfoutput>#form.DCLINEA#</cfoutput>';
		<cfif isdefined('form.CIid')>
		document.lista.CIIDL.value = '<cfoutput>#form.CIidL#</cfoutput>'
		</cfif>
		return true;
	}
	function funcEliminar(vCIidL){
		document.lista.ECID.value = '<cfoutput>#form.ECid#</cfoutput>';
		document.lista.DCLINEA.value = '<cfoutput>#form.DCLINEA#</cfoutput>';
		document.lista.CIIDL.value = vCIidL;
		document.lista.action = 'SQLProvisiones.cfm';
		document.lista.submit()
	}
</script>
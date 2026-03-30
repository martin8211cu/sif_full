<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PrioridadDeDeduccion" 	default="C&oacute;digo Prioridad Deducci&oacute;n"returnvariable="LB_CodPrioridadDeDeduccion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PrioridadDeDeduccion" 	default="Orden Prioridad Deducci&oacute;n"returnvariable="LB_PrioridadDeDeduccion"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_AdministracionDeNomina" 	default="Administración de Nómina" 	returnvariable="LB_AdministracionDeNomina"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CODIGO" 					default="C&oacute;digo" 			returnvariable="LB_CODIGO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DESCRIPCION"				default="Descripci&oacute;n" 		returnvariable="LB_DESCRIPCION"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Orden" 					default="C&oacute;digo"				returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Orden" 					default="Orden" 					returnvariable="LB_Orden"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_RecursosHumanos" 		default="Recursos Humanos" 			returnvariable="LB_RecursosHumanos">

<cf_templateheader title="#LB_RecursosHumanos#">
	<cfinclude template="/rh/Utiles/params.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#">
    <cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
			  <tr>
				<td valign="top" width="45%">
                	<!---ljs 20121008 esta seccion es para incluir los tipos de prioridad ya definidos en el catalogo tipo deduccion 
                    se ejecuta solo la primera vez cuando se carga el formulario para compatibilidad clientes antiguos--->
                    <cfquery datasource="#session.DSN#" name="rsRHPrioridadDed">
                    	select * from RHPrioridadDed where Ecodigo = #Session.Ecodigo#
                    </cfquery>
                    <cfif isdefined('rsRHPrioridadDed') and rsRHPrioridadDed.RecordCount EQ 0>
                   		<cf_dbfunction name="OP_Concat"	Returnvariable = "concat">
                    	<cftransaction>
                    		<!--- Por error de Datos, No se puede permitir que el campo Fecha y Monto este con valor 1, solo uno de los dos --->	
                    		<cfquery datasource="#session.DSN#" name="CorreccionDatos">
                    				update TDeduccion
                    					set TDordfecha=null
                    				Where TDordfecha=1
                    					and TDordmonto=1
                    					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">
                    		</cfquery>
                            
                    		<!--- Por error de Datos, No se puede permitir que el Ordenamiento de los datos base esté en nulo --->	
                    		<cfquery datasource="#session.DSN#" name="CorreccionDatos">
                    				update TDeduccion
                    					set TDordfecha=1
                    				Where TDordfecha is null
                    					and TDordmonto is null
                    					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">
                    		</cfquery>
                            
                    		
                            <cfquery datasource="#session.DSN#" name="rsInsertUpdate">
                            insert into RHPrioridadDed (RHPDcodigo, Ecodigo, RHPDdescripcion, RHPDorden, RHPDordmonto, RHPDordfecha, Usucodigo, BMUsucodigo)
                                select distinct 
                                case 
                                    when coalesce(a.TDordmonto,0) = 1 then (a.TDprioridad * 10) + 1
                                    when coalesce(a.TDordmonto,0) = 2 then (a.TDprioridad * 10) + 2
                                    when coalesce(a.TDordfecha,0) = 1 then (a.TDprioridad * 10) + 3
                                    when coalesce(a.TDordfecha,0) = 2 then (a.TDprioridad * 10) + 4
                                end as Prioridad
                                , <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">
                                , case 
                                    when coalesce(a.TDordmonto,0) = 1 then 'Prioridad ' #concat#  <cf_dbfunction name="to_char"	args="(a.TDprioridad * 10) + 1"  >
                                    when coalesce(a.TDordmonto,0) = 2 then 'Prioridad ' #concat#  <cf_dbfunction name="to_char"	args="(a.TDprioridad * 10) + 2"  >
                                    when coalesce(a.TDordfecha,0) = 1 then 'Prioridad ' #concat#  <cf_dbfunction name="to_char"	args="(a.TDprioridad * 10) + 3"  >
                                    when coalesce(a.TDordfecha,0) = 2 then 'Prioridad ' #concat#  <cf_dbfunction name="to_char"	args="(a.TDprioridad * 10) + 4"  >
                                end as descripcion
                                , case 
                                    when coalesce(a.TDordmonto,0) = 1 then (a.TDprioridad * 10) + 1
                                    when coalesce(a.TDordmonto,0) = 2 then (a.TDprioridad * 10) + 2
                                    when coalesce(a.TDordfecha,0) = 1 then (a.TDprioridad * 10) + 3
                                    when coalesce(a.TDordfecha,0) = 2 then (a.TDprioridad * 10) + 4
                                end as Orden
                                ,TDordmonto
                                ,TDordfecha
                                , -1
                                , null
                                from TDeduccion a
                                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">
                                order by Prioridad
                            </cfquery>
                            
                            <cfquery datasource="#session.DSN#" name="rsInsertUpdate">
                                update TDeduccion set TDprioridad = 
                                    case 
                                        when coalesce(TDordmonto,0) = 1 then (TDprioridad * 10) + 1
                                        when coalesce(TDordmonto,0) = 2 then (TDprioridad * 10) + 2
                                        when coalesce(TDordfecha,0) = 1 then (TDprioridad * 10) + 3
                                        when coalesce(TDordfecha,0) = 2 then (TDprioridad * 10) + 4
                                    end 
                                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">
                            </cfquery>
                        </cftransaction>
                    </cfif>
				    <cfset t=createObject("component", "sif.Componentes.Translate")>
                    <cfset RAD_MontoAscendente = t.translate('RAD_MontoAscendente','Monto ascendente')>
                    <cfset RAD_MontoDescendente = t.translate('RAD_MontoDescendente','Monto descendente')>
                    <cfset RAD_FechaAscendente = t.translate('RAD_FechaAscendente','Fecha ascendente')>
                    <cfset RAD_FechaDescendente = t.translate('RAD_FechaDescendente','Fecha descendente')>
                    <cfset LB_Criterio = t.translate('LB_Criterio','Criterio')>

                    <cfset LvarCriterios = "                  
										case 
											when RHPDordmonto  = 1
												then '#RAD_MontoAscendente#'
											when RHPDordmonto  = 2
												then '#RAD_MontoDescendente#'
											when RHPDordfecha  = 1
												then '#RAD_FechaAscendente#'
											when RHPDordfecha  = 2
												then '#RAD_FechaDescendente#'
										end ">
                    
                    <cf_translatedata name="get" tabla="RHPrioridadDed" col="RHPDdescripcion" returnvariable="LvarRHPDdescripcion">
					<cfinvoke component="rh.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
						<cfinvokeargument name="conexion" value="#Session.DSN#"/>
						<cfinvokeargument name="columnas" value="RHPDid, RHPDcodigo, #LvarRHPDdescripcion# as RHPDdescripcion, RHPDordfecha, RHPDorden,#PreserveSingleQuotes(LvarCriterios)# as Criterios" />
						<cfinvokeargument name="tabla" 				value="RHPrioridadDed"/>
						<cfinvokeargument name="desplegar" 			value="RHPDcodigo, RHPDdescripcion, RHPDorden, Criterios"/>
						<cfinvokeargument name="etiquetas" 			value="#LB_Codigo#,#LB_DESCRIPCION#, #LB_Orden# ,#LB_Criterio#"/>
						<cfinvokeargument name="formatos" 			value="S,S,S,S"/>
						<cfinvokeargument name="align" 				value="left,left, center,left"/>
						<cfinvokeargument name="irA" 				value="PrioridadDeduccion.cfm"/>
						<cfinvokeargument name="filtro" 			value="Ecodigo = #Session.Ecodigo# order by RHPDorden"/>
						<cfinvokeargument name="ajustar" 			value="N"/>
						<cfinvokeargument name="keys" 				value="RHPDid"/>
						<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
						<cfinvokeargument name="mostrar_filtro" 	value="false"/>
                        <cfinvokeargument name="translatedatacols"  value="RHPDdescripcion"/>
						<cfinvokeargument name="filtrar_automatico" value="false"/>
					</cfinvoke>
				</td>
				<td valign="top" width="55%" align="center"><cfinclude template="formPrioridadDeduccion.cfm"></td>
			  </tr>
			</table>
	<cf_web_portlet_end>
<cf_templatefooter>
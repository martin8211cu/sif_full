<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Administracion de Cuentas" returnvariable="LB_Title"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="Titulo" returnvariable="LB_Titulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Monto" Default="Monto" returnvariable="LB_Monto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescuentoInicial" Default="% Descuento Inicial" returnvariable="LB_DescuentoInicial"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PenalizacionDia" Default="% Penalizacion por dia" returnvariable="LB_PenalizacionDia"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Orden" Default="Orden" returnvariable="LB_Orden"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripcion" returnvariable="LB_Descripcion"/>
<cfinvoke  key="BTN_Regresar" default="Regresar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Regresar" xmlfile="/crc/generales.xml"/>
<cfinvoke  key="BTN_Filtrar" default="Filtrar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Filtrar" xmlfile="/crc/generales.xml"/>
<cfinvoke  key="BTN_Limpiar" default="Limpiar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Limpiar" xmlfile="/crc/generales.xml"/>

<cfset strFIltro = " and (1=1 or s.disT = 1 or s.TarjH = 1 or s.Mayor = 1)">
<cfif isdefined('form.Numero') and form.Numero neq ""><cfset strFIltro = "#strFIltro# and c.Numero like '%#form.Numero#%'"></cfif>
<cfif isdefined('form.SNid') and form.SNid neq ""><cfset strFIltro = "#strFIltro# and SNegociosSNid = #form.SNid#"></cfif>
<cfif isdefined('form.AplicaVales') and isdefined('form.Categoria') and  form.Categoria neq ""><cfset strFIltro = "#strFIltro# and CRCCategoriaDistid = #form.Categoria#"></cfif>
<cfif isdefined('form.Estado') and form.Estado neq ""><cfset strFIltro = "#strFIltro# and CRCEstatusCuentasid = #form.Estado#"></cfif>

<cfsavecontent variable="strTipo">
	<cfif isdefined('form.AplicaVales')>
		or Tipo = 'D'
	</cfif>
	<cfif isdefined('form.AplicaTC')>
		or Tipo = 'TC'
	</cfif>
	<cfif isdefined('form.AplicaTM')>
		or Tipo = 'TM'
	</cfif>
</cfsavecontent>
<cfif trim(strTipo) neq ""> <cfset strFIltro="#strFIltro# and(1=2 #strTipo#)"></cfif>

<cfset parentEntrancePoint="CuentasAdmin.cfm">

<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
		<!--- <cfdump var="#form#"> --->
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td>
					<cfinclude template="/home/menu/pNavegacion.cfm">
				</td>
			</tr>
			<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
			<cfset val = objParams.getParametroInfo('30200711')>
			<cfif val.codigo eq ''><cfthrow message="El parametro [30200711 - Rol de administradores de credito] no existe"></cfif>
			<cfif val.valor eq ''><cfthrow message="El parametro [30200711 - Rol de administradores de credito] no esta definido"></cfif>
			
			<cfquery name="checkRol" datasource="#session.dsn#">
				select * from UsuarioRol where 
						    Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.usucodigo#">  
						and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#val.valor#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#"> 
			</cfquery>
			<cfif checkRol.recordCount neq 0>
				<tr>
					<td>
						<!---<cfdump var="#form#"> --->
						<cfif isdefined('form.id')>
							<cfif isdefined('form.whatToDo')>
								<cfif form.whatToDo neq "">
									<cfinclude template="Cuentas_sql.cfm">
								</cfif>
							</cfif>
							<cfinclude template="Cuentas_form.cfm">
						<cfelse>
							<cfinclude template="Cuentas_lista.cfm">
						</cfif>
					</td>
				</tr>
			<cfelse>
				<cfthrow message="No cuentas con los permisos para realizar esta operacion">
			</cfif>
			<tr>
				<td>
					&nbsp;
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
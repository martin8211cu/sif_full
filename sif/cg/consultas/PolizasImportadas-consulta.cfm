<!--- JMRV. Transferencia de Polizas entre Empresas. 17/12/2014. Inicio. --->

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<!--- Tags para la traduccion --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_titulo" Default= "Consulta Estatus de P&oacute;lizas" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_titulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estatus" Default= "Estatus" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_Estatus"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PolizaOrigen" Default= "P&oacute;liza Origen" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_PolizaOrigen"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Poliza" Default= "P&oacute;liza" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_Poliza"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_fecha" Default= "Fecha" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_fechaInicio" Default= "Fecha Inicio" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_fechaInicio"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_fechaFin" Default= "Fecha Fin" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_fechaFin"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default= "Descripci&oacute;n" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Periodo" Default= "Periodo" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_Periodo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mes" Default= "Mes" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_Mes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_EstatusN" Default= "Todos" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_EstatusN"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estatus0" Default= "No procesada" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_Estatus0"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estatus1" Default= "Transferida" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_Estatus1"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estatus5" Default= "Error al procesar" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_Estatus5"/>

<cf_templateheader title="#LB_titulo#">
	<cf_web_portlet_start titulo="#LB_titulo#">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">

		<!--- Origen de las polizas --->
		<cfset EmpresaOrigen  = 15>
		<cfset OficinaOrigen  = 3>

		<!--- Captura los datos de la consulta si vienen por url --->
		<cfset param = "">

		<cfif isdefined("form.Poliza") and Len(Trim(form.Poliza))>
			<cfset Poliza = form.Poliza>
			<cfset param = param & "&Poliza=" & form.Poliza>
		<cfelseif isdefined("url.Poliza") and Len(Trim(url.Poliza))>
			<cfset Poliza = url.Poliza>
			<cfset param = param & "&Poliza=" & url.Poliza>
		</cfif>

		<cfif isdefined("form.fechaInicio") and Len(Trim(form.fechaInicio))>
			<cfset fechaInicio = LSDateFormat(form.fechaInicio,'yyyy-mm-dd') & ' 00:00:00.000'>
			<cfset param = param & "&fechaInicio=" & fechaInicio>
		<cfelseif isdefined("url.fechaInicio") and Len(Trim(url.fechaInicio))>
			<cfset fechaInicio = url.fechaInicio>
			<cfset param = param & "&fechaInicio=" & url.fechaInicio>
		</cfif>

		<cfif isdefined("form.fechaFin") and Len(Trim(form.fechaFin))>
			<cfset fechaFin = LSDateFormat(form.fechaFin,'yyyy-mm-dd') & ' 00:00:00.000'>
			<cfset param = param & "&fechaFin=" & fechaFin>
		<cfelseif isdefined("url.fechaFin") and Len(Trim(url.fechaFin))>
			<cfset fechaFin = url.fechaFin>
			<cfset param = param & "&fechaFin=" & url.fechaFin>
		</cfif>

		<cfif isdefined("form.fecha") and Len(Trim(form.fecha))>
			<cfset fecha = LSDateFormat(form.fecha,'yyyy-mm-dd') & ' 00:00:00.000'>
			<cfset param = param & "&fecha=" & fecha>
		<cfelseif isdefined("url.fecha") and Len(Trim(url.fecha))>
			<cfset fecha = url.fecha>
			<cfset param = param & "&fecha=" & url.fecha>
		</cfif>

		<cfif isdefined("form.Estatus") and Len(Trim(form.Estatus))>
			<cfset Estatus = form.Estatus>
			<cfset param = param & "&Estatus=" & form.Estatus>
		<cfelseif isdefined("url.Estatus") and Len(Trim(url.Estatus))>
			<cfset Estatus = url.Estatus>
			<cfset param = param & "&Estatus=" & url.Estatus>
		</cfif>

		<!--- Form para Consulta --->
		<cfoutput>
			<form name="form1" method="post" action="PolizasImportadas-consulta.cfm">
				<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
			  	<tr><td><p>&nbsp;</p></td></tr>
			  	<tr> 
			  		<td><cfoutput>#LB_PolizaOrigen#</cfoutput>:&nbsp;
			        	<input  name="Poliza" type="text" tabindex="1" value="" size="20" maxlength="30">
						<div align="right"></div>
			  		</td> 
			  		<td align="right" nowrap><cfoutput>#LB_Estatus#:</cfoutput>&nbsp;</td>
					<td>
						<select name="Estatus" default="-1"> 
							<option value="-1">--- <cfoutput>#LB_EstatusN#</cfoutput> ---</option>
							<option value="0"><cfoutput>#LB_Estatus0#</cfoutput></option> 
							<option value="1"><cfoutput>#LB_Estatus1#</cfoutput></option> 
							<option value="5"><cfoutput>#LB_Estatus5#</cfoutput></option> 
						</select>
					</td>
			  		<td align="right" nowrap><cfoutput>#LB_fechaInicio#</cfoutput>:&nbsp;</td>
			    	<td>
			        <cf_sifcalendario name="fechaInicio" value="" form="form1" tabindex="1">
			    	</td>
			    
				    <td align="right" nowrap>&nbsp;&nbsp;<cfoutput>#LB_fecha#</cfoutput>:&nbsp;</td>
				    <td>
			        <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fecha" value="">
			     	</td>
			  	</tr>
			  	<tr>
			  		<td></td>
			  		<td></td>
			  		<td></td>
			  		<td align="right" nowrap><cfoutput>#LB_fechaFin#</cfoutput>:&nbsp;</td>
			    	<td>
			        <cf_sifcalendario name="fechaFin" value="" form="form1"  tabindex="1">
			    	</td>
			    </tr> 
			    <tr>
			    	<td></td>
			    	<td></td>
			    	<td></td>
			    	<td></td>
			    	<td></td>
			    	<td></td>
					<td align="center">
						<input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
					</td>
			  	</tr>
				</table>
			</form>
		</cfoutput>

		<!--- Consulta --->
		<cfquery name="rsListaQRY" datasource="#Session.DSN#">
			select 	case 	when he.PolizaTransferida = 0 then 'No procesada'
										when (he.PolizaTransferida = 1 and pt.IDE18 is not null) then 
											case
												when (select (1) from HEContables 
															where Ecodigo = #session.Ecodigo#
															and IDcontable = pt.IDcontable) is not null
												then 'Aplicada' 
												when (select (1) from EContables 
															where Ecodigo = #session.Ecodigo#
															and IDcontable = pt.IDcontable) is not null
												then 'Transferida a Documentos Contables'
												else 'Transferida a Importacion de Documentos' 
											end
										when (he.PolizaTransferida = 1 and pt.IDE18 is null) then 'Transferida a motor de interfaces'
										when he.PolizaTransferida = 2 then 'Error en las cuentas'
										when he.PolizaTransferida = 3 then 'Error en las monedas'
										when he.PolizaTransferida = 4 then 'Error en tipo de cambio'
										else 'Error al procesar'
					end as Estatus, 
						(select Edocumento from EContables 
						where Ecodigo = #session.Ecodigo#
						and IDcontable = pt.IDcontable
						union 
						select Edocumento from HEContables 
						where Ecodigo = #session.Ecodigo#
						and IDcontable = pt.IDcontable)
					as Poliza, 
					he.Edocumento as PolizaOrigen, he.Edescripcion as Descripcion, he.Eperiodo as Periodo, 
					he.Emes as Mes, he.Efecha as Fecha, he.IDcontable

			from HEContables he
			inner join HDContables hd
				on  hd.Ecodigo    = he.Ecodigo
				and hd.IDcontable = he.IDcontable
			left join PolizasTransferidas pt
				on  pt.IDcontableOri = he.IDcontable
				and pt.EcodigoOri = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaOrigen#">
			where he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaOrigen#">
			and   hd.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#OficinaOrigen#"> <!--- Traer todo lo que haga referencia a la of MEX--->
			and not he.ECtipo = 1  <!--- Excluye polizas de Cierre de Periodo Fiscal ---> 
			and not he.ECtipo = 11 <!--- Excluye polizas de Cierre de Periodo Corporativo --->
				<cfif isdefined("Poliza") and Poliza neq "">
			and he.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(Poliza)#">
				</cfif>
				<cfif isdefined("fechaInicio") and fechaInicio neq "">
			and he.Efecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#fechaInicio#">
				</cfif>
				<cfif isdefined("fechaFin") and fechaFin neq "">
			and he.Efecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#fechaFin#">
				</cfif>
				<cfif isdefined("fecha") and fecha neq "">
			and he.Efecha = <cfqueryparam cfsqltype="cf_sql_date" value="#fecha#">
				</cfif>
				<cfif isdefined("Estatus") and Estatus neq "" and Estatus neq -1 and Estatus neq 5>
			and he.PolizaTransferida = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Estatus#">
				<cfelseif isdefined("Estatus") and Estatus eq 5>
			and he.PolizaTransferida in (2,3,4,5) <!--- Todos los errores --->
				</cfif>
			group by 	he.Edocumento, he.Edescripcion, he.Eperiodo, he.Emes, he.Efecha, he.IDcontable,
								pt.IDcontable, he.PolizaTransferida, pt.IDE18
			order by he.Efecha desc, he.Edocumento desc
		</cfquery>

		<!--- Resultados de Consulta --->
		<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
		    <td>		
				  <cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaQuery"
					 returnvariable="pListaRet">
					  <cfinvokeargument name="query" value="#rsListaQRY#"/>
					  <cfinvokeargument name="desplegar" value="Estatus,PolizaOrigen,Poliza,Descripcion,Periodo,Mes,Fecha"/>
					  <cfinvokeargument name="etiquetas" value="#LB_Estatus#,#LB_PolizaOrigen#,#LB_Poliza#,#LB_Descripcion#,#LB_Periodo#,#LB_Mes#,#LB_fecha#"/>
					  <cfinvokeargument name="formatos" value="V,V,V,V,V,V,D"/>
					  <cfinvokeargument name="align" value="left, left, left, left, left, left, left"/>
					  <cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N"/>
					  <cfinvokeargument name="keys" value="IDcontable,Poliza"/>
					  <cfinvokeargument name="navegacion" value="#param#"/>
					  <cfinvokeargument name="PageIndex" value="1"/>
					  <cfinvokeargument name="checkboxes" value="N"/>
					  <cfinvokeargument name="showEmptyListMsg" value="true"/>
					  <cfinvokeargument name="showLink" value="false"/>
					  <cfinvokeargument name="checkall" value="S"/>
				  </cfinvoke>		
				</td>
		  </tr>
		</table>

	<cf_web_portlet_end>
<cf_templatefooter>

<!--- JMRV. Transferencia de Polizas entre Empresas. 17/12/2014. Fin. --->
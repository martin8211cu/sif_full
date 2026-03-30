<!--- 
Creado por Jose Gutierrez 
	07/03/2018
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','Reporte de Pagos x Cliente')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Filtros del Reporte')>
<cfset LB_FechaDesde	= t.Translate('LB_FechaDesde','Fecha desde')>
<cfset LB_FechaHasta	= t.Translate('LB_FechaHasta','Fecha hasta')>
<cfset LB_Corte			= t.Translate('LB_Corte','Corte')>
<cfset LB_TipoCuenta	= t.Translate('LB_TipoCuenta','Tipo de Cuenta')>
<cfset LB_Resumen		= t.Translate('LB_Resumen','Solo Resumen')>
<cfset LB_Numero		= t.Translate('LB_Numero','Numero de Cuenta')>
<cfset LB_Nombre		= t.Translate('LB_Nombre','Nombre')>
<cfset LB_Cuenta		= t.Translate('LB_Cuenta','Socio de Negocio')>
<cfset LB_Estado		= t.Translate('LB_Estado','Estado')>


<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>


<cf_templateheader title="#LB_TituloH#">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_TituloH#'>


<cfquery name="q_TipoCuenta" datasource="#session.DSN#">
	select 
		rtrim(ltrim(c.tipo)) as tipo,
		case rtrim(ltrim(c.tipo))
			when 'D' then 'Distribuidor'
			when 'TC' then 'Tarjeta Credito'
			when 'TM' then 'Tarjeta Mayorista'
		end as Descripcion
	from (select distinct(tipo) from CRCCuentas where Ecodigo = #session.Ecodigo#) as c;
</cfquery>

<cfquery name="rsEstados" datasource="#Session.DSN#">
	select id,Descripcion,Orden from CRCEstatusCuentas
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	order by Orden
</cfquery>

<!---
<cfquery name="q_EstadoCuenta" datasource="#session.DSN#">
	select 
		c.CRCEstatusCuentasid, e.Descripcion
	from (select distinct(CRCEstatusCuentasid) from CRCCuentas where Ecodigo = #session.Ecodigo#) as c
		inner join CRCEstatusCuentas e
			on e.id = c.CRCEstatusCuentasid
</cfquery>
--->

<cfinclude template="../../../sif/Utiles/sifConcat.cfm">
<form name="form1" action="reportePagosCliente_sql.cfm?p=0" method="post">
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr align="center">
		<td valign="top">
		<fieldset>
		<b> #LB_DatosReporte# </b>
		
		</b>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr align="center">
					<td>
						<!---<strong>#LB_SNegocio#:&nbsp;</strong>--->
						<cfset tipoSN = "D">
						<strong>#LB_Cuenta#:&nbsp;</strong>
						<cf_conlis
							title="#LB_Cuenta#"
							Campos="SNid, SNnombre"
							Desplegables="N,S"
							Modificables="N,N"
							Size="10,30"
							tabindex="2"
							Tabla="CRCCuentas cc inner join SNegocios sn on sn.SNid = SNegociosSNid"
							Columnas="distinct(SNid) as SNid,SNnombre"
							form="form1"
							Filtro="sn.Ecodigo = #Session.Ecodigo#
									order by SNnombre"
							Desplegar="SNnombre"
							Etiquetas="#LB_Nombre#"
							filtrar_por="SNnombre"
							Formatos="S"
							Align="left"
							Asignar="SNid,SNnombre"
							Asignarformatos="S,S"/>
							
					</td>
				</tr>
				<tr align="center">
					<td><strong>#LB_TipoCuenta#:&nbsp;</strong>
						<select name="tipoCta">
								<option value="">Todos</option>
							<cfloop query="#q_TipoCuenta#">
								<option value="#q_TipoCuenta.tipo#">#q_TipoCuenta.Descripcion#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr align="center">
					<td nowrap>
						<strong>#LB_Estado#:&nbsp;</strong>
						<select name="estado">
							<option value="">Todos</option>
							<cfloop query="rsEstados">
								<option value="#rsEstados.id#">#rsEstados.Descripcion#</option>
							</cfloop>
						</select>
					</td>
					 <td>

					 </td>
				</tr>
				<tr>
					<td align="center">
						<strong>#LB_FechaDesde#:&nbsp;</strong>
						<cfset fechaDes = LSDateFormat(Now(),'dd/mm/yyyy')>
						<cf_sifcalendario form="form1" value="" name="fechaDesde" tabindex="1">
					</td>
				</tr>
				<tr>
					<td align="center">
						<strong>#LB_FechaHasta#:&nbsp;</strong>
						<cfset fechaHas = LSDateFormat(Now(),'dd/mm/yyyy')>
						<cf_sifcalendario form="form1" value="#fechaHas#" name="fechaHasta" tabindex="1">
					</td>
				</tr>
				<tr>
					<td align="center">
						<input type="checkbox" name="resumen">
						<strong>#LB_Resumen#</strong>
					</td>
				</tr>
				<!---
				<tr align="center">
					<td><strong>#LB_EstadoCuenta#:&nbsp;</strong>
						<cfloop query="#q_EstadoCuenta#">
							<input type="checkbox" name="EstatusCuentaID" value="#q_EstadoCuenta.CRCEstatusCuentasid#" checked><b><i>&nbsp;#q_EstadoCuenta.Descripcion#&emsp;&emsp;</i></b></option>
						</cfloop>
					</td>
				</tr>
				--->
				<tr><td><br></td></tr>
				<tr>
					<td >
						<cf_botones values="Generar" names="Generar"  tabindex="1">
					</td>
				</tr>
			</table>
			</fieldset>
		</td>	
	</tr>
</table>
	
</form>
<cf_web_portlet_end>			

<cf_templatefooter>

</cfoutput>
 



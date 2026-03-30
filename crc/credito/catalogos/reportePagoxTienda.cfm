<!--- 
Creado por Jose Gutierrez 
	07/03/2018
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','Reporte Pago por Tienda')>
<cfset TIT_ReportPagxTie 	= t.Translate('TIT_ReportPagxTie','Reporte Pago por Tienda')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Filtros del Reporte')>
<cfset LB_SNegocio 		= t.Translate('LB_SNegocio','Socio de Negocio')>
<cfset LB_FechaDesde	= t.Translate('LB_FechaDesde','Fecha desde')>
<cfset LB_FechaHasta	= t.Translate('LB_FechaHasta','Fecha hasta')>
<cfset LB_Corte			= t.Translate('LB_Corte','Corte')>
<cfset LB_Tienda 		= t.Translate('LB_Cuenta', 'Tienda')>
<cfset LB_Numero 		= t.Translate('LB_Numero', 'N&uacute;mero')>
<cfset LB_Nombre 		= t.Translate('LB_Nombre', 'Nombre')>
<cfset LB_Tipo 			= t.Translate('LB_Tipo', 'Tipo')>
<cfset LB_Cuenta 		= t.Translate('LB_Cuenta', 'Cuenta')>
<cfset LB_Seleccione 	= t.Translate('LB_Seleccione', 'Seleccione')>
<cfset LB_Resumen 		= t.Translate('LB_Resumen', 'Solo Resumen')>
<cfset LB_TipoCuenta	= t.Translate('LB_TipoCuenta','Tipo de Cuenta')>
<cfset LB_Estado		= t.Translate('LB_Estado','Estado')>

<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>


<cf_templateheader title="#LB_TituloH#">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_ReportPagxTie#'>


<!---<cfquery name="rsCorte" datasource="#session.DSN#">
	select distinct Corte 
	from CRCTransaccion
	where Ecodigo = #session.Ecodigo#
	and Rtrim(Ltrim(isNull(Corte,''))) <> ''
</cfquery>--->

<cfquery name="rsCorte" datasource="#session.DSN#">
	select Codigo, FechaInicio, FechaFin 
	from CRCCortes
	where Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ecodigo, Ocodigo, Odescripcion from Oficinas
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="rsEstados" datasource="#Session.DSN#">
	select id,Descripcion,Orden from CRCEstatusCuentas
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	order by Orden
</cfquery>
 

<cfinclude template="../../../sif/Utiles/sifConcat.cfm">
<form name="form1" action="reportePagoxTienda_sql.cfm?p=0" method="post">
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td align="center">
			<fieldset>
				<b>#LB_DatosReporte#</b>
			</fieldset>
			<table  width="30%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr align="left">
					<td>
						<!---<strong>#LB_SNegocio#:&nbsp;</strong>--->
						<cfset tipoSN = "D">
						<strong>#LB_Cuenta#:&nbsp;</strong>
						<cf_conlis
							title="#LB_Cuenta#"
							Campos="Numero, SNnombre"
							Desplegables="S,S"
							Modificables="S,N"
							Size="10,30"
							tabindex="2"
							Tabla="CRCCuentas cc inner join SNegocios sn on sn.SNid = SNegociosSNid"
							Columnas="SNid,Numero,SNnombre, Tipo = case 
									when Tipo = 'D' then 'Distribuidor'
									when Tipo = 'TC' then 'Tarjeta de Credito'
									when Tipo = 'TM' then 'Tarjeta Mayorista' 
									end"
							form="form1"
							Filtro="sn.Ecodigo = #Session.Ecodigo#
									order by SNnombre"
							Desplegar="Numero, SNnombre, Tipo"
							Etiquetas="#LB_Numero#, #LB_Nombre#, #LB_Tipo#"
							filtrar_por="Numero, SNnombre, Tipo"
							Formatos="S,S,S"
							Align="left, left, left"
							Asignar="SNid,Numero,SNnombre, Tipo"
							Asignarformatos="S,S,S,S"/>
							
					</td>
				</tr>

				<tr align="left">
					 <td width="10%" nowrap>
					 	<strong>#LB_Tienda#:</strong>
						<select name="tienda">
				            <option value="">#LB_Seleccione#</option>
				          <cfloop query="rsOficinas">
				              <option value="#rsOficinas.Ocodigo#">#rsOficinas.Odescripcion#</option>
				          </cfloop> 
				      	</select>
					 </td> 
					 <td>

					 </td>
				</tr>
				<tr align="left">
					<td width="10%" nowrap>
						<strong>#LB_TipoCuenta#:&nbsp;</strong>
						<select name="tipoCta">
							<option value="">Todos</option>
							<option value="D">Distribuidor</option>
							<option value="TC">Tarjeta Credito</option>
							<option value="TM">Tarjeta Mayorista</option>
						</select>
					</td>
					 <td>

					 </td>
				</tr>
				<tr align="left">
					<td width="10%" nowrap>
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
				<tr align="left">
					<td>
						<strong>#LB_FechaDesde#:&nbsp;</strong>
						<cfset fechaDes = LSDateFormat(Now(),'dd/mm/yyyy')>
						<cf_sifcalendario form="form1" value="" name="fechaDesde" tabindex="1">
					</td>
				</tr>
				<tr align="left">
					<td>
						<strong>#LB_FechaHasta#:&nbsp;</strong>
						<cfset fechaHas = LSDateFormat(Now(),'dd/mm/yyyy')>
						<cf_sifcalendario form="form1" value="#fechaHas#" name="fechaHasta" tabindex="1">
					</td>
				</tr>
				<tr align="left">
					<td>
					<strong><cfoutput>#LB_Corte#:&nbsp;</cfoutput></strong>
					 <select name="corte" id="corte" tabindex="1">
					 	<option selected="true" value="">Todos</option>
						<cfloop query="rsCorte"> 
							<option value="#Codigo#">#rsCorte.Codigo# (#LSDateFormat(rsCorte.FechaInicio,'dd/mm/yyyy')# - #LSDateFormat(rsCorte.FechaFin,'dd/mm/yyyy')#)</option>
						</cfloop> 
					  </select>
					</td>
				</tr>
				<tr>
					<td align="center">
						<input type="checkbox" name="resumen">
						<strong>#LB_Resumen#</strong>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr align="center">
					<td>
					<cf_botones values="Generar" names="Generar"  tabindex="1">
					</td>
				</tr>
			</table>
		</td>	
	</tr>
</table>
	
</form>
<cf_web_portlet_end>			

<cf_templatefooter>

</cfoutput>



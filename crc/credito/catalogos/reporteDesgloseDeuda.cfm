<!--- 
Creado por Jose Gutierrez 
	07/03/2018
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','Reporte de Saldos Vencidos')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Filtros del Reporte')>
<cfset LB_TipoCuenta	= t.Translate('LB_TipoCuenta','Tipo de Cuenta')>
<cfset LB_EstadoCuenta	= t.Translate('LB_EstadoCuenta','Estado de Cuenta')>
<cfset LB_Alerta		= t.Translate('LB_Alerta','Este reporte se calcula con base en ULTIMO CORTE CERRADO')>
<cfset LB_Resumen 		= t.Translate('LB_Resumen', 'Solo Resumen')>

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

<cfquery name="q_EstadoCuenta" datasource="#session.DSN#">
	select 
		c.CRCEstatusCuentasid, e.Descripcion
	from (select distinct(CRCEstatusCuentasid) from CRCCuentas where Ecodigo = #session.Ecodigo#) as c
		inner join CRCEstatusCuentas e
			on e.id = c.CRCEstatusCuentasid
</cfquery>

<cfinclude template="../../../sif/Utiles/sifConcat.cfm">
<form name="form1" action="reporteDesgloseDeuda_sql.cfm?p=0" method="post" >
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset>
		<b> #LB_DatosReporte# </b>
		
		</b>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
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
					<td><strong>#LB_EstadoCuenta#:&nbsp;</strong>
						<cfloop query="#q_EstadoCuenta#">
							<input type="checkbox" name="EstatusCuentaID" value="#q_EstadoCuenta.CRCEstatusCuentasid#" checked><b><i>&nbsp;#q_EstadoCuenta.Descripcion#&emsp;&emsp;</i></b></option>
						</cfloop>
					</td>
				</tr>
				<tr><td><br></td></tr>
				<tr align="center">
					<td>
						<b><font color="blue">#LB_Alerta#</font></b>
					</td>
				</tr>
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
 



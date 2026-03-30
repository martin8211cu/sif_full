
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="prontuario"
	Default="Prontuario de Nminas"
	returnvariable="prontuario"/>

<cfset LvarFileName = "Prontuario#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cfoutput>
<cf_htmlReportsHeaders 
title="#prontuario#" 
filename="#LvarFileName#"
param="&url.OrderBy=#url.OrderBy#&FechaHasta=#url.FechaHasta#&FechaDesde=#url.FechaDesde#"
irA="prontuario.cfm" 
>
</cfoutput>
<style type="text/css">
	.RLTtopline {
		border-bottom-width: 1px;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: red;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000;
		font-size:11px;
		font-family:Arial;
		background-color: #CCCCCC;		
	}	
	
	.LTtopline {
		border-color: red;
		border-bottom-width: 0px;
		border-right-width: 0px;
		border-left-width: 0px;
		border-top-width: 0px;
		border-style: solid;
		font-size:11px;
		font-family:Arial;
	}	
	
	.Completoline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
</style>

<cfflush interval="512">
<cfsetting requesttimeout="36000">

<cfoutput>
	<table width="100%" align="center" cellpadding="0" cellspacing="4" border="0">
		<tr class="RLTtopline">
			<td nowrap="nowrap"><cf_translate  key="LB_Cedula">C&eacute;dula</cf_translate></td>
			<td nowrap="nowrap"><cf_translate  key="LB_tarjeta">Tarjeta</cf_translate></td>
			<td nowrap="nowrap"><cf_translate  key="LB_Nombre">Nombre</cf_translate></td>
			<td nowrap="nowrap"><cf_translate  key="LB_Nombre">Ingreso</cf_translate></td>
			<td nowrap="nowrap"><cf_translate  key="LB_Nombre">Categoria</cf_translate></td>
			<td nowrap="nowrap"><cf_translate  key="LB_Nombre">CentroFuncional</cf_translate></td>
			<td nowrap="nowrap"><cf_translate  key="LB_Nombre">Puesto</cf_translate></td>
			<td nowrap="nowrap"><cf_translate  key="LB_Nombre">SalarioAccion</cf_translate></td>
			<cfif not isdefined("url.ckResumido")>
				<td nowrap="nowrap"><cf_translate  key="LB_Puesto">N&oacute;mina</cf_translate></td>
				<td nowrap="nowrap"><cf_translate  key="LB_calendario">Calendario</cf_translate></td>
				<td nowrap="nowrap"><cf_translate  key="LB_fecha_desde">Desde</cf_translate></td>
				<td nowrap="nowrap"><cf_translate  key="LB_fecha_hasta">Hasta</cf_translate></td>
			</cfif>
			<td ><cf_translate  key="LB_fecha_tipo">Tipo</cf_translate></td>
			<cfif not isdefined("url.ckResumido")>
				<td nowrap="nowrap"><cf_translate  key="LB_fecha_codigo">C&oacute;digo</cf_translate></td>
				<td nowrap="nowrap"><cf_translate  key="LB_descripcion">Descripci&oacute;n</cf_translate></td>
			</cfif>
			<td ><cf_translate  key="LB_monto">Monto</cf_translate></td>
			<cfif not isdefined("url.ckResumido")>
				<td nowrap="nowrap"><cf_translate  key="LB_CentroCosto">Centro Costo</cf_translate></td>
			</cfif>
		</tr>
		<cfloop query="EmpleadosAMostrar">
			<cfquery dbtype="query" name="rsdatos">
				select* from rsdatosHistoricos where DEid=#EmpleadosAMostrar.DEid#
			</cfquery>
				<cfloop query="rsdatos">
						<tr class="LTtopline">
							<td  nowrap align="left">#trim(EmpleadosAMostrar.cedula)#</td>
							<td  nowrap="nowrap" align="left">#trim(EmpleadosAMostrar.DEtarjeta)#</td>
							<td  nowrap class="LTtopline" align="left">#trim(EmpleadosAMostrar.nombre)#</td>
							<td  nowrap="nowrap" align="left">#LSDateFormat(EmpleadosAMostrar.Ingreso,'dd-mm-yyyy')#</td>
							<td  nowrap="nowrap" align="left">#trim(EmpleadosAMostrar.Categoria)#</td>
							<td  nowrap="nowrap" align="left">#trim(EmpleadosAMostrar.CentroFuncional)#</td>
							<td  nowrap="nowrap" align="left">#trim(EmpleadosAMostrar.Puesto)#</td>
							<td  nowrap="nowrap" align="right">#LSNumberFormat(EmpleadosAMostrar.Salario,',.00')#</td>
							<cfif not isdefined("url.ckResumido")>
								<td  nowrap="nowrap" align="left">#trim(EmpleadosAMostrar.Nomina)#</td>
								<td  nowrap="nowrap" align="left">#trim(EmpleadosAMostrar.CPcodigo)#</td>
								<td  nowrap="nowrap" align="left">#LSDateFormat(EmpleadosAMostrar.CPdesde,'dd-mm-yyyy')#</td>
								<td  nowrap="nowrap" align="left">#LSDateFormat(EmpleadosAMostrar.CPhasta,'dd-mm-yyyy')#</td>
							</cfif>
							<td  align="left">#trim(rsdatos.tipo)#</td>
							<cfif not isdefined("url.ckResumido")>
								<td nowrap="nowrap"  align="left">#trim(rsdatos.codigo)#</td>
								<td nowrap="nowrap" align="left">#trim(rsdatos.descripcion)#</td>
							</cfif>
							<td nowrap="nowrap" align="right">#LSNumberFormat(rsdatos.monto,',.00')#</td>
							<cfif not isdefined("url.ckResumido")>
								<td nowrap="nowrap" align="left">#trim(rsdatos.CFcodigo)# -#trim(rsdatos.CFdescripcion)#</td>
								<td nowrap="nowrap" align="left"></td
							></cfif>
						</tr>	
				</cfloop>	
		</cfloop>
		<tr>
			<td nowrap="nowrap" bgcolor="##CCCCCC" colspan="25" align="right" class="Completoline">&nbsp;</td>
		</tr>
	</table>
	
	
</cfoutput>


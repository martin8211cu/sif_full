  
<cfif isdefined('form.CPid1') and LEN(TRIM(form.CPid1))>
	<cfset CPid = form.CPid1>
	<cfset CPcodigo = form.CPcodigo1>
	<cfset Tcodigo = form.Tcodigo1>
<cfelseif isdefined('form.CPid2') and LEN(TRIM(CPid2))>
	<cfset CPid = form.CPid2>
	<cfset CPcodigo = form.CPcodigo2>
	<cfset Tcodigo = form.Tcodigo2>
</cfif>
<cfset prefijo = ''>
<!--- SE VERIFICA CON CUAL TIPO DE NOMINA SE VA A TIRAR EL REPORTE, NOMINAS APLICADAS O SIN APLICAR --->
<cfif isdefined('form.TipoNomina')>
	<cfset prefijo = 'H'>
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select distinct a.DEid, a.DEidentificacion,
		<cf_dbfunction name="concat" args="DEapellido1,' ',DEapellido2,', ',DEnombre" > as nombre,
		DEinfo1,
		a.DEdato2, 
		b.SEliquido,
        ba.Bdescripcion, 
		a.CBcc,
		DEidentificacion,
		EVfantig
	from DatosEmpleado a
    inner join Bancos ba on a.Bid = ba.Bid <!---SML. Modificacion para agregar el Banco--->
	inner join #prefijo#SalarioEmpleado b
		on a.DEid = b.DEid
		and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
	inner join CalendarioPagos cp
		on cp.CPid = b.RCNid
	inner join LineaTiempo lt
		on lt.DEid = a.DEid
		and ((lt.LThasta >= cp.CPdesde and lt.LTdesde <= cp.CPhasta) 
		  or (lt.LTdesde <= cp.CPhasta and lt.LThasta >= cp.CPdesde))
	inner join RHPlazas p
		on p.RHPid = lt.RHPid
	inner join EVacacionesEmpleado ve
		on ve.DEid = a.DEid
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by nombre
</cfquery>

<!--- Busca el nombre de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Datos de la nomina --->
<cfquery name="rsNomina" datasource="#session.DSN#">
	select CPhasta, CPdesde, CPfpago
	from CalendarioPagos
	where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
</cfquery>
<cfset formatos = "excel">
<!---<cfif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 1>
	<cfset formatos = "flashpaper">
<cfelseif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 2>
	<cfset formatos = "pdf">
<cfelseif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 3>
	<cfset formatos = "excel">
</cfif>
---><!---<cf_dump var="#rsReporte#">--->
<form name="form1" action="RepPagoBancos.cfm">
<cfif formatos EQ 'excel'>
	<cfif  isdefined("formatos") and formatos eq "excel">
		<cfcontent type="application/msexcel">
		<cfheader 	name="Content-Disposition" 
		value="attachment;filename=RepNominaBARODASA_#session.Usucodigo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
	</cfif>
		<style>
			h1.corte {
				PAGE-BREAK-AFTER: always;}
			.tituloAlterno {
				font-size:16px;
				font-weight:bold;
				text-align:center;}
			.titulo_empresa2 {
				font-size:14px;
				font-weight:bold;
				text-align:center;}
			.titulo_reporte {
				font-size:12px;
				font-style:italic;
				text-align:center;}
			.titulo_filtro {
				font-size:10px;
				font-style:italic;
				text-align:center;}
			.titulolistas {
				font-size:10px;
				font-weight:bold;
				background-color:#CCCCCC;
				}
			.titulo_columnar {
				font-size:10px;
				font-weight:bold;
				background-color:#CCCCCC;
				text-align:right;}
			.listaCorte {
				font-size:10px;
				font-weight:bold;
				background-color:#CCCCCC;
				text-align:left;}
			.total {
				font-size:10px;
				font-weight:bold;
				background-color:#C5C5C5;
				text-align:right;}

			.detalle {
				font-size:10px;
				text-align:left;}
			.detaller {
				font-size:10px;
				text-align:right;}
			.detallec {
				font-size:10px;
				text-align:center;}	
				
			.mensaje {
				font-size:10px;
				text-align:center;}
			.paginacion {
				font-size:10px;
				text-align:center;}
		</style>

<cfoutput>
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr><td align="center" colspan="4" class="detallec"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
		<tr>
			<td align="center" colspan="4" class="detallec"><strong><cf_translate key="LB_Periodo">Per&iacute;odo</cf_translate>: #LSDateFormat(rsNomina.CPdesde,'dd-mm-yyyy')# a #LSDateFormat(rsNomina.CPhasta,'dd-mm-yyyy')#</strong></td>
		</tr>
		<tr><td align="center" colspan="4" class="detallec"><strong><cf_translate key="LB_DiaDePago">D&iacute;a de Pago</cf_translate>: #LSDateFormat(rsNomina.CPfpago,'dd-mm-yyyy')#</strong></td></tr>
		<tr class="titulo_columnar">
			<td align="center" width="30">Identificacion</td>
			<td align="center" width="250"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>
			<td align="right" width="100"><cf_translate key="LB_TotalAPagar">Total a Pagar</cf_translate></td>
            <td align="center" width="100"><cf_translate key="LB_Banco">Banco</cf_translate></td>
			<td align="center" width="150"><cf_translate key="LB_Cuenta">Cuenta</cf_translate></td>
		</tr>
		<cfset TotalAPagar = 0.00>
		<cfset TotalGralAPagar = 0.00>
		<cfset contadorlineas = 1>
		<cfset contadorlineas2 = 1>
		<cfloop query="rsReporte">
			<cfif (form.Cantlineas GT 0 and contadorlineas GT form.CantLineas and rsReporte.CurrentRow NEQ 1)>
				<cfif isdefined('form.MontoxPagina')>
					<tr class="total">
						<td class="detalle" colspan="2"><cf_translate key="LB_Total">Total</cf_translate></td>
						<td class="detaller">#LSNumberFormat(TotalAPagar, ',9.00')#</td>
						<td class="detaller">&nbsp;</td>
					</tr>
					<tr><td colspan="4">&nbsp;</td></tr>
					<cfset TotalAPagar = 0.00>
				</cfif>
					<tr><td align="center" colspan="4" class="detallec"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
					<tr>
						<td align="center" colspan="4" class="detallec"><strong><cf_translate key="LB_Periodo">Per&iacute;odo</cf_translate>: #LSDateFormat(rsNomina.CPhasta,'mmm-dd-yyyy')# a #LSDateFormat(rsNomina.CPdesde,'mmm-dd-yyyy')#</strong></td>
					</tr>
					<tr><td align="center" colspan="4" class="detallec"><strong><cf_translate key="LB_DiaDePago">D&iacute;a de Pago</cf_translate>: #LSDateFormat(rsNomina.CPfpago,'mmm-dd-yyyy')#</strong></td></tr>
					<tr class="titulo_columnar">
						<td align="center" width="30">Identificacion</td>
						<td align="center" width="250"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>
						<td align="right" width="100"><cf_translate key="LB_TotalAPagar">Total a Pagar</cf_translate></td>
                        <td align="center" width="100"><cf_translate key="LB_Banco">Banco</cf_translate></td>
						<td align="center" width="150"><cf_translate key="LB_Cuenta">Cuenta</cf_translate></td>
					</tr>
				<cfset contadorlineas = 1>  
			</cfif> 
			  <tr <cfif rsReporte.EVfantig GTE rsNomina.CPdesde and rsReporte.EVfantig LTE rsNomina.CPhasta>bgcolor="F2F200"</cfif>>
				<td class="detalle" width="30">#rsReporte.DEidentificacion#</td>
				<td class="detalle" width="250">
					<cfif LEN(TRIM(rsReporte.DEinfo1))>
						#rsReporte.DEinfo1#
					<cfelse>
					#rsReporte.nombre#
					</cfif>
				</td>
				<td class="detaller" width="100">#LSNumberFormat(rsReporte.SEliquido, ',9.00')#</td>
                <td class="detalle" width="150">#rsReporte.Bdescripcion#</td>
				<td class="detalle" width="150">#rsReporte.CBcc#</td>
			  </tr>
			<cfset TotalAPagar = TotalAPagar + rsReporte.SEliquido>
			<!---TOTALES GENERALES--->
			<cfset TotalGralAPagar = TotalGralAPagar + rsReporte.SEliquido>
			<cfset contadorlineas = contadorlineas + 1>  
			<cfset contadorlineas2 = contadorlineas2 + 1>  
		</cfloop>
		<cfif isdefined('form.MontoxPagina')>
			<tr class="total">
				<td class="detalle" colspan="2"><cf_translate key="LB_Total">Total</cf_translate></td>
				<td class="detaller">#LSNumberFormat(TotalAPagar, ',9.00')#</td>
				<td class="detaller">&nbsp;</td>
			</tr>
		</cfif>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td class="total" colspan="2"><cf_translate key="LB_TotalGeneral">Total General</cf_translate></td>
			<td class="total">#LSNumberFormat(TotalGralAPagar, ',9.00')#</td>
			<td class="total">&nbsp;</td>
			<td class="total">&nbsp;</td>
		</tr>

	</table>
</cfoutput>			
<!---<cfelse>
	<cfreport format="#formatos#" template="RepPagoBancos_Desp.cfr" query="rsReporte" overwrite="yes">
		<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
			<cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
		</cfif>
		<cfif isdefined('rsNomina') and rsNomina.RecordCount GT 0>
			<cfreportparam name="FechaD" value="#rsNomina.CPdesde#">
			<cfreportparam name="FechaH" value="#rsNomina.CPhasta#">
			<cfreportparam name="FechaP" value="#rsNomina.CPfpago#">
		</cfif>
		<cfreportparam name="usuario" value="#session.datos_personales.Nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#">
	</cfreport>
---></cfif>
</form>




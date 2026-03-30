<cfset FileName = "UsuarioSolicitudesPagoXEmpresa">
<cfset FileName = FileName & Session.Usucodigo & DateFormat(Now(),'yyyymmdd') & TimeFormat(Now(),'hhmmss') & '.xls'>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cf_htmlreportsheaders title="Reporte de Usuarios de Solicitudes de Pago por Empresa" 
	filename="#FileName#" 
	ira="ReporteUsuarioSolPago.cfm">


	<cfset LvarImgChecked  	 = "<img border=""0"" src=""/cfmx/sif/imagenes/checked.gif"">">
	<cfset LvarImgUnchecked	 = "<img border=""0"" src=""/cfmx/sif/imagenes/unchecked.gif"">">

	<cfif len(trim(form.filtro_CFid)) and form.filtro_CFid NEQ "-1">
		<cfset LvarFiltro_CF = "and tu.CFid = #form.filtro_CFid#">
	<cfelse>
		<cfset LvarFiltro_CF = "">
	</cfif>
	
	<cfset filtro = "">
	<cfif isdefined("form.Usulogin") and len(trim(form.Usulogin))>
		<cfset filtro = filtro & " and Usulogin = '#form.Usulogin#'">
	</cfif>
	<cfif isdefined("form.TESUSPsolicitante") and len(trim(form.TESUSPsolicitante))>
		<cfset filtro = filtro & " and TESUSPsolicitante = #form.TESUSPsolicitante#">
	</cfif>
	<cfif isdefined("form.TESUSPaprobador") and len(trim(form.TESUSPaprobador))>
		<cfset filtro = filtro & " and TESUSPaprobador = #form.TESUSPaprobador#">
	</cfif>
	<cfif isdefined("form.TESUSPmontoMax") and len(trim(form.TESUSPmontoMax))>
		
		<cfset LvarTESUSPmontoMax = replace(form.TESUSPmontoMax,',', '','All')>
		<cfset filtro = filtro & " and TESUSPmontoMax <= #LvarTESUSPmontoMax#">
	</cfif>
	<cfif isdefined("form.TESUSPcambiarTES") and len(trim(form.TESUSPcambiarTES))>
		<cfset filtro = filtro & " and TESUSPcambiarTES = #form.TESUSPcambiarTES#">
	</cfif>
	
	
	<table cellpadding="0" cellspacing="0" border="0" style="width:100%">
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="7" align="center" class="niv1"><cfoutput>#session.Enombre#</cfoutput></td>
		  <td colspan="1" class="niv4" align="right" style="width:1%">Fecha:&nbsp;<cfoutput>#dateformat(now(), 'dd/mm/yyyy')#</cfoutput></td>
		</tr>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="7" align="center" class="niv2">Reporte de Usuarios de Solicitudes de Pago por Empresa</td>
		  <td colspan="1" class="niv4" align="right">Usuario:&nbsp;<cfoutput>#session.Usulogin#</cfoutput> </td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
	</table>
	
	
	<cfquery name="rs" datasource="#session.DSN#">
		select distinct
			tu.Usucodigo
			, cf.CFcodigo
			, cf.CFcodigo #LvarCNCT# ' - ' #LvarCNCT# cf.CFdescripcion as CentroFuncional
			, u.Usulogin
			, dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usuario
			, case
				when tu.TESUSPsolicitante = 1 
					then 'SI'
					else 'NO'
			  end as Solicitante
			, case
				when tu.TESUSPaprobador = 1 
					then 'SI'
					else 'NO'
			  end as Aprobador
			, tu.TESUSPmontoMax as montoMaximo
			, case 
				when tu.TESUSPcambiarTES = 1 
					then 'SI'
					else 'NO'
			  end as CambiarTES
			from  TESusuarioSP tu
				inner join Usuario u
					inner join DatosPersonales dp
					   on dp.datos_personales = u.datos_personales
					on u.Usucodigo = tu.Usucodigo
				inner join CFuncional cf
					on cf.CFid = tu.CFid 
			  
			where tu.Ecodigo = #session.Ecodigo# 
				#LvarFiltro_CF# 
				#PreserveSingleQuotes(filtro)# 
			order by cf.CFcodigo, u.Usulogin
	
	</cfquery>
	
<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.titulo_empresa {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.titulo_reporte {
		font-size:12px;
		font-weight:bold;
		text-align:center;}
	.titulo_filtro {
		font-size:10px;
		font-weight:bold;
		text-align:center;}
	.titulo_columna {
		font-size:11px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.titulo_columnar {
		font-size:11px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.detalle {
		font-size:11px;
		mso-number-format:"\@";
		text-align:left;}
	.detaller {
		font-size:10px;
		text-align:right;}
	.mensaje {
		font-size:10px;
		text-align:center;}
	.paginacion {
		font-size:10px;
		text-align:center;}
	.xl29
		{font-size:10px;
		mso-number-format:"\@";
		white-space:normal;}		
</style>
	<table cellpadding="0" cellspacing="0" border="0" style="width:100%">
		<tr class="titulo_columna">
			<td>Usuario</td> 
			<td>Nombre</td>
			<td>Solicitante</td>
			<td>Aprobador</td> 
			<td>Monto Maximo<BR>a Aprobar</td> 
			<td>Puede Cambiar<BR>Tesorería</td>
		</tr>		
		<cfoutput query="rs" group="CentroFuncional"> 

				<tr class="titulo_columnar">
					<td colspan="6">&nbsp;&nbsp;&nbsp;&nbsp;#CentroFuncional#</td>
				</tr>
				<cfoutput>
					<tr class="detalle">
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#Usulogin#</td> 
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#Usuario#</td>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#Solicitante#</td>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#Aprobador#</td> 
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#montoMaximo#</td> 
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#CambiarTES#</td>
					</tr>
				</cfoutput>	

		</cfoutput>
		<tr valign="top" align="center"><td colspan="6" nowrap>***************************** Fin de la Consulta *********************************</td></tr>
	</table>	
	
	
	


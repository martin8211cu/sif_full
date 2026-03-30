<!--- <cf_dump var="#form#"> --->
<cfsetting requesttimeout="3600">

<!--- Exporta el Contenido a Excel --->
<cfif isDefined("form.toExcel")>
	<cfif form.toExcel eq "true">
		<cfcontent type="application/vnd.ms-excel">
	</cfif>
</cfif>
	
<!--- Consultas --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
 	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfsavecontent variable="myquery">
	<cfoutput>
	select a.PCRid, 
		   a.Cmayor, 
		   a.PCEMid, 
		   a.OficodigoM, 
		   a.PCRref, 
		   a.PCRdescripcion, 
		   a.PCRregla, 
		   case when a.PCRvalida = 1 then 'Si' else 'No' end as PCRvalida, 
		   a.PCRdesde, 
		   a.PCRhasta, 
		   (select coalesce(count(1), 0) 
		    from PCReglas x 
		    where x.Ecodigo = a.Ecodigo
		      and x.PCRref = a.PCRid
		      and x.PCRid <> a.PCRid
		   ) as cantNivel2
	from PCReglas a
	where a.Ecodigo = #Session.Ecodigo#
		and (a.PCRref is null or a.PCRid = a.PCRref)
		<cfif isdefined("form.oficodigo") and Len(Trim(form.oficodigo))>
			and upper(a.OficodigoM) like '#UCase(Trim(form.oficodigo))#%'
		</cfif>	
		<cfif isdefined("form.cmayor_ccuenta1") and Len(Trim(form.cmayor_ccuenta1)) and isdefined("form.cmayor_ccuenta2") and Len(Trim(form.cmayor_ccuenta2))>
			and upper(a.Cmayor) between
				'#UCase(Trim(form.cmayor_ccuenta1))#' and
				'#UCase(Trim(form.cmayor_ccuenta2))#'
		</cfif>
	order by a.OficodigoM, a.Cmayor, a.PCRregla
	</cfoutput>
</cfsavecontent>

<!--- Filtros --->
<cfset ocodigoD = "(No definida)">
<cfset cuentaIniD = "(No definida)">
<cfset cuentaFinD = "(No definida)">
<cfif isDefined("form.oficodigo") and len(trim(form.oficodigo))>
	<cfset ocodigoD = form.oDescripcion>
</cfif>
<cfif isDefined("form.cmayor_ccuenta1") and len(trim(form.cmayor_ccuenta1))>
	<cfset cuentaIniD = form.cuenta1Desc & " (" & form.cmayor_ccuenta1 & ")">
</cfif>
<cfif isDefined("form.cmayor_ccuenta2") and len(trim(form.cmayor_ccuenta2))>
	<cfset cuentaFinD = form.cuenta2Desc & " (" & form.cmayor_ccuenta2 & ")">
</cfif>

<!--- Estilos --->
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
		font-size:10px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.titulo_columnar {
		font-size:10px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;}
	.detalle {
		font-size:10px;
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
</style>

<!--- Variables --->
<cfif isDefined("form.toExcel") and form.toExcel eq "true"> <!--- Total de líneas por página --->	
	<cfset MaxLineasReporte = 9999999>
<cfelse><cfset MaxLineasReporte = 60>
</cfif>
<cfset nLnEncabezado = 9>		 <!--- Total de líneas del encabezado --->
<cfset nCols = 5>				 <!--- Total de columnas del encabezado --->

<!--- Botones --->
<cfif not isDefined("form.toExcel")>
	<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
	<table id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0">
		<cfoutput>
		<tr> 
			<td colspan="#nCols#" align="right" nowrap>
				<a href="javascript:regresar();" tabindex="-1">
					<img src="/cfmx/sif/imagenes/back.gif"
					alt="Regresar"
					name="regresar"
					border="0" align="absmiddle">
				</a>				
				<a href="javascript:imprimir();" tabindex="-1">
					<img src="/cfmx/sif/imagenes/impresora.gif"
					alt="Imprimir"
					name="imprimir"
					border="0" align="absmiddle">
				</a>
				<a id="EXCEL" href="javascript:SALVAEXCEL();" tabindex="-1">
					<img src="/cfmx/sif/imagenes/Cfinclude.gif"
					alt="Salvar a Excel"
					name="SALVAEXCEL"
					border="0" align="absmiddle">
				</a>
			</td>
		</tr>
		<tr><td  colspan="#nCols#"><hr></td></tr>
		</cfoutput>
	</table>
</table>
</cfif>

<!--- Llena el Encabezado --->
<cfsavecontent variable="Encabezado">
<cfoutput>
	<tr><td colspan="#nCols#" class="titulo_empresa">#rsEmpresa.Edescripcion#</td></tr>
	<tr><td colspan="#nCols#" class="titulo_reporte">Reporte de Reglas</td></tr>
	<tr><td colspan="#nCols#" class="titulo_filtro">Cuenta Inicial: #cuentaIniD# - Cuenta Final: #cuentaFinD#</td></tr>
	<tr><td colspan="#nCols#" class="titulo_filtro">Oficina: #ocodigoD#</td></tr>
	<tr><td colspan="#nCols#" class="paginacion">#trim(LSDateFormat(Now(),'dd/mm/yyyy'))# #trim(LSTimeFormat(Now(),'HH:mm:ss'))#</td></tr>	
	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="#nCols#" align="center"><hr></td></tr>
	<tr>
		<td class="titulo_columna">Oficina</td>
		<td class="titulo_columna">Regla</td>
		<td class="titulo_columnar">V&aacute;lida</td>
		<td class="titulo_columnar">Desde</td>
		<td class="titulo_columnar">Hasta</td>
	</tr>
	<tr><td colspan="#nCols#" align="center"><hr></td></tr>
</cfoutput>
</cfsavecontent>

<!--- Pinta el Reporte --->
<table width="100%" cellpadding="0" cellspacing="0" border="0">
<cfoutput>

	<!--- Encabezado --->
	#Encabezado#

	<cftry>
		<cfflush interval="16000">
		<cf_jdbcquery_open name="rsReporte" datasource="#session.DSN#">
			<cfoutput>#myquery#</cfoutput>
		</cf_jdbcquery_open>
			
		<!--- Detalle --->
		<cfset contador = nLnEncabezado>
		<cfloop query="rsReporte">

			<cfif isdefined("form.chkVerHijas")>
					
				<cfset LvarPCRid = PCRid>
				
				<!--- Obtiene las hijas --->
				<cfsavecontent variable="myqueryhijas">
					<cfoutput>
					select a.PCRid, 
						   a.Cmayor, 
						   a.PCEMid, 
						   a.OficodigoM, 
						   a.PCRref, 
						   a.PCRdescripcion, 
						   a.PCRregla, 
						   case when a.PCRvalida = 1 then 'Si' else 'No' end as PCRvalida, 
						   a.PCRdesde, 
						   a.PCRhasta, 
						   (select coalesce(count(1), 0) 
							from PCReglas x 
							where x.Ecodigo = a.Ecodigo
							  and x.PCRref = a.PCRid
							  and x.PCRid <> a.PCRid
						   ) as cantNivel2
					from PCReglas a
					where a.Ecodigo = #Session.Ecodigo#
						and a.PCRref = #LvarPCRid#
					order by a.OficodigoM, a.Cmayor, a.PCRregla
					</cfoutput>
				</cfsavecontent>			
				
				<cf_jdbcquery_open name="rsReportehijas" datasource="#session.DSN#">
					<cfoutput>#myqueryhijas#</cfoutput>
				</cf_jdbcquery_open>	
			
			</cfif>		
			
			<cfif contador gte MaxLineasReporte>
				<tr class="corte"><td colspan="#nCols#" nowrap>&nbsp;</td></tr>
				#Encabezado#
				<cfset contador = nLnEncabezado>
			</cfif>
			<tr>				
				<td class="detalle">#trim(OficodigoM)#</td>
				<td class="detalle">#trim(PCRregla)#</td>
				<td class="detaller">#trim(PCRvalida)#</td>
				<td class="detaller">#trim(LSDateFormat(PCRdesde,'dd/mm/yyyy'))#</td>
				<td class="detaller">#trim(LSDateFormat(PCRhasta,'dd/mm/yyyy'))#</td>
			</tr>
			
			<cfif isdefined("form.chkVerHijas")>
			
				<cfloop query="rsReportehijas">
				<tr>
					<td class="detalle" bgcolor="##FCF8F8" width="15%" nowrap>&nbsp;&nbsp;&nbsp;#trim(OficodigoM)#</td>
					<td class="detalle" bgcolor="##FCF8F8" width="40%" nowrap>#trim(PCRregla)#</td>
					<td class="detaller" bgcolor="##FCF8F8" width="15%" nowrap>#trim(PCRvalida)#</td>
					<td class="detaller" bgcolor="##FCF8F8" width="15%" nowrap>#trim(LSDateFormat(PCRdesde,'dd/mm/yyyy'))#</td>
					<td class="detaller" bgcolor="##FCF8F8" width="15%" nowrap>#trim(LSDateFormat(PCRhasta,'dd/mm/yyyy'))#</td>
				</tr>
				</cfloop>
			
			</cfif>
			
			<cfset contador = contador + 1>
		</cfloop>
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
	</cftry>
	<cf_jdbcquery_close>
</cfoutput>
</table>

<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
<cfoutput>
	<tr><td colspan="#nCols#" align="center">&nbsp;</td></tr>
	<tr><td colspan="#nCols#" class="paginacion"> - Fin del Reporte - </td></tr>
</cfoutput>
</table>

<cfoutput>
<form name="FormExcel" id="FormExcel" method="post" action="ReglasRep.cfm">
	<input type="hidden" name="toExcel" id="toExcel" value="false">
	<input type="hidden" name="CMayor_CCuenta1" value="<cfif isDefined("form.CMayor_CCuenta1")>#form.CMayor_CCuenta1#</cfif>">
	<input type="hidden" name="CMayor_CCuenta2" value="<cfif isDefined("form.CMayor_CCuenta2")>#form.CMayor_CCuenta2#</cfif>">
	<input type="hidden" name="Consultar" value="<cfif isDefined("form.Consultar")>#form.Consultar#</cfif>">
	<input type="hidden" name="Cuenta1Desc" value="<cfif isDefined("form.Cuenta1Desc")>#form.Cuenta1Desc#</cfif>">
	<input type="hidden" name="Cuenta2Desc" value="<cfif isDefined("form.Cuenta2Desc")>#form.Cuenta2Desc#</cfif>">
	<input type="hidden" name="ocodigo" value="<cfif isDefined("form.ocodigo")>#form.ocodigo#</cfif>">
	<input type="hidden" name="oficodigo" value="<cfif isDefined("form.oficodigo")>#form.oficodigo#</cfif>">
	<input type="hidden" name="oDescripcion" value="<cfif isDefined("form.oDescripcion")>#form.oDescripcion#</cfif>">
</form>
</cfoutput>

<!--- Manejo de los Botones --->
<script language="javascript1.2" type="text/javascript">
	function regresar() {
		history.back();
	}

	function imprimir() {
		var tablabotones = document.getElementById("tablabotones");
        tablabotones.style.display = 'none';
		window.print();
        tablabotones.style.display = '';
	}

	function SALVAEXCEL() {
		var fExcel = document.getElementById("FormExcel");
		var btnExcel = document.getElementById("toExcel");
		btnExcel.value = 'true';
		fExcel.submit();
	}
</script>

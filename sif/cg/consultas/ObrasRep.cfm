<!--- Exporta el contenido a Excel --->
<cfif isDefined("form.toExcel")>
	<cfif form.toExcel eq "true">
		<cfcontent type="application/vnd.ms-excel">
	</cfif>
</cfif>

<!--- Quers --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
 	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cffunction name="fnCrearTmpColumnas" access="private" returntype="string" output="false">
    <cf_dbtemp name="columna1" returnvariable="columnas">
		<cf_dbtempcol name="Columna"  			type="numeric" mandatory="yes" identity='true'>
		<cf_dbtempcol name="Grupo" 				type="numeric"  	 	mandatory="yes">
		<cf_dbtempcol name="PCCDvalor"			type="varchar(20)" 	 	mandatory="no">
		<cf_dbtempcol name="PCCDdescripcion" 	type="varchar(80)" 	 	mandatory="no">
	</cf_dbtemp>
	<cfreturn columnas>
</cffunction>	


<!--- 
	Adecuacion temporal para el funcionamiento del Reporte. 
	Se sumariza SIEMPRE el ultimo nivel de la cuenta, y se mayoriza al nivel anterior
	Siempre y cuando la cuenta seleccionada TENGA mascara.
	Se asume que debe solicitarse en pantalla 
--->
<cfquery name="rsNiveles" datasource="#Session.DSN#">
	select 
		m.PCEMid as Mascara,
			coalesce((
					select max(n.PCNid)
					from PCNivelMascara n
					where n.PCEMid = m.PCEMid
					), 1)
			as Niveles
	from CtasMayor m
	where m.Ecodigo = #Session.Ecodigo#
	  and m.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cmayor_ccuenta1#">
</cfquery>

<cfif not isdefined("rsNiveles") or rsNiveles.recordcount LT 1 or len(rsNiveles.Mascara) LT 1>
	<cf_errorCode	code = "50237" msg = "La Cuenta seleccionada NO tiene Máscara Asociada. NO se permite generar el Reporte para esta cuenta">
	<cfreturn>
</cfif>

<cfset columnas = fnCrearTmpColumnas()>

<cfset NivelDetalle = 1>
<cfset NivelMayor = 0>

<cfif isdefined("rsNiveles") and len(rsNiveles.Mascara) GT 0>
	<cfset NivelDetalle = rsNiveles.Niveles>
	<cfset NivelMayor = NivelDetalle - 1>

	<cfif isdefined("form.cbonivel") and len(form.cbonivel)>
		
		<cfif form.cbonivel lte NivelMayor>
			<cfset NivelMayor = form.cbonivel>
		</cfif>
				
	</cfif>

</cfif>


<cfquery datasource="#session.DSN#">
	insert into #columnas#
			(Grupo, PCCDvalor, PCCDdescripcion)
	select 
			PCCDclaid, PCCDvalor, PCCDdescripcion
	from PCClasificacionD
	where PCCEclaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.reporte#"> 
	order by PCCDvalor
</cfquery>

<cfquery datasource="#session.DSN#">
	insert into #columnas#
			(Grupo, PCCDvalor, PCCDdescripcion)
	select 
		0, 
        'N/A', 
        'NO APLICA'
     from dual
</cfquery>

<cfquery name="rsColumnas" datasource="#session.DSN#">
	select Columna, Grupo, PCCDvalor , upper(PCCDdescripcion) as PCCDdescripcion
	from #columnas#
	order by Columna
</cfquery>

<cfset MaxColumnas = rsColumnas.recordcount>
<cfset totales = structNew()>
<cfloop index="i" from="1" to="#MaxColumnas#">
	<cfset totales[i] = 0.00>
</cfloop>

<cfset valores = structNew()>
<cfloop query="rsColumnas">
	<cfset valores[rsColumnas.Columna] = rsColumnas.PCCDvalor>
</cfloop>

<!--- Prosesa el combo de Oficinas --->
<cfif isdefined("form.ubicacion")>

	<cfif form.ubicacion eq "">
	
		<cfset listaEmp = Session.Ecodigo>
		
	<cfelse>

		<cfset listaub = listtoarray(form.ubicacion)>
		<cfset vgrp = listaub[1]>
		<cfswitch expression="#vgrp#">
		<cfcase value="ge">
		
			<cfquery name="rsGEmpresas" datasource="#session.DSN#">
				select ge.GEnombre
				from AnexoGEmpresa ge
					join AnexoGEmpresaDet gd
						on ge.GEid = gd.GEid
				where ge.CEcodigo = #session.CEcodigo#
				  and gd.Ecodigo = #session.Ecodigo#
				  and ge.GEid = #listaub[2]#
				order by ge.GEnombre
			</cfquery>
					
			<cfquery name="rsLstGEmpresas" datasource="#session.DSN#">
				select Ecodigo
				from AnexoGEmpresa a, AnexoGEmpresaDet b
				where a.GEid = b.GEid
				  and a.CEcodigo = #session.CEcodigo#  
				  and b.GEid = #listaub[2]#
			</cfquery>
			
			<cfset listaEmp = "">
			<cfoutput query="rsLstGEmpresas">
				<cfif listaEmp eq "">
					<cfset listaEmp = rsLstGEmpresas.Ecodigo>
				<cfelse>
					<cfset listaEmp = listaEmp & "," & rsLstGEmpresas.Ecodigo>
				</cfif>				
			</cfoutput>
			
			<cfoutput>
			#listaEmp#
			</cfoutput>
	
			<cfset secciontitulo = "Grupo de Empresas: " & rsGEmpresas.GEnombre>
		</cfcase>
		<cfcase value="go">
			
			<cfquery name="rsGOficina" datasource="#session.DSN#">
				select GOnombre
				from AnexoGOficina
				where Ecodigo = #session.Ecodigo#
				  and GOid = #listaub[2]# 
				order by GOnombre
			</cfquery>	
			
			<cfquery name="rsLstGOficina" datasource="#session.DSN#">
				Select Ocodigo
				from AnexoGOficinaDet
				where Ecodigo = #session.Ecodigo#
				  and GOid = #listaub[2]# 
			</cfquery>	
			
			<cfif rsLstGOficina.recordcount gt 0>
			
				<cfset listaOf = "">
				<cfoutput query="rsLstGOficina">
					<cfif listaOf eq "">
						<cfset listaOf = rsLstGOficina.Ocodigo>
					<cfelse>
						<cfset listaOf = listaOf & "," & rsLstGOficina.Ocodigo>
					</cfif>	
				</cfoutput>
			
			</cfif>		
	
			<cfset secciontitulo = "Grupo de Oficinas: " & rsGOficina.GOnombre>
			
		</cfcase>
		<cfcase value="of">
		
			<cfquery name="rsOficina" datasource="#session.DSN#">
				select Ocodigo, Oficodigo, Odescripcion
				from Oficinas
				where Ecodigo = #session.Ecodigo#
				  and Ocodigo = #listaub[2]#
				order by Oficodigo, Odescripcion
			</cfquery>
	
			<cfset listaOf = "">
			<cfif rsOficina.recordcount gt 0>
				<cfset listaOf = rsOficina.Ocodigo>
			</cfif>	
	
			<cfset secciontitulo = "Oficina: " & rsOficina.Oficodigo & " - " & rsOficina.Odescripcion>
		</cfcase>
		</cfswitch>

	</cfif>
	
</cfif>

<!--- Con el query anterior se generan los encabezados de la tabla --->

<!---
	Obtener el monto por cada cuenta y columna.  
	Se debe llenar un arreglo de totales
	cada vez que cambia la cuenta, con los montos en cero,
	y asignar los valores para cada una de las cuentas.
	Se genera la tabla con los valores del arrego de totales
	En esta forma, se generan los datos de TODAS las columnas
--->
<cfsavecontent variable="myquery">
	<cfoutput>
		select 
			a.Cuenta, 
			a.PCCDvalor as PCCDvalor,
			sum(a.Saldo) as Saldo, 
			((select min(c.Cformato) from CContables c where c.Ccuenta = a.Cuenta)) as CuentaFormato
		from (
				select 
					cu2.Ccuentaniv as Cuenta, 
					cu.PCDcatid as PCDcatid, 
					coalesce((
						select min(cl.PCCDvalor) 
						from PCDClasificacionCatalogo cc 
								inner join PCClasificacionD cl
									on cl.PCCDclaid = cc.PCCDclaid
						where cc.PCDcatid = cu.PCDcatid 
						  and cc.PCCEclaid = #form.reporte#
						), 'N/A') 
					as PCCDvalor,
					#form.reporte# as PCCEclaid, 
							coalesce((
								select sum(DLdebitos - CLcreditos) 
								from SaldosContables s 
								where s.Ccuenta = c.Ccuenta 
								  <cfif isdefined("listaOf") and len(listaOf)>	
								  	and Ocodigo in (#listaOf#)
								  </cfif>
								  <cfif isdefined("listaEmp") and len(listaEmp)>
								  	and Ecodigo in (#listaEmp#)	
								  </cfif>								  
								  and s.Speriodo = #form.periodo#
								  and s.Smes     >= #form.mes#
								  and s.Smes     <= #form.mesfin#
								), 0.00)
					as Saldo, 
					c.Ecodigo
				from CContables c
					inner join PCDCatalogoCuenta cu
								inner join PCDCatalogoCuenta cu2
								  on cu2.Ccuenta = cu.Ccuenta
								 and cu2.PCDCniv = #NivelMayor#
						 on cu.Ccuenta = c.Ccuenta
						and cu.PCDCniv = #NivelDetalle#
				where c.Ecodigo = #session.Ecodigo#
				  and c.Cmayor = '#form.cmayor_ccuenta1#'
			) a
		group by a.Cuenta, a.PCCDvalor
		having sum(a.Saldo) <> 0
		order by 4, 2
	</cfoutput>
</cfsavecontent>

<!--- Filtros --->
<cfset periodoD = "(No definido)">
<cfset mesIniD  = "(No definido)">
<cfset mesFinD  = "(No definido)">
<cfset cuentaD  = "(No definida)">
<cfif isDefined("form.periodo") and len(trim(form.periodo))>
	<cfset periodoD = form.periodo>
</cfif>
<cfif isDefined("form.mes") and len(trim(form.mes))>
	<cfset mesIniD = form.mesDesde>
</cfif>
<cfif isDefined("form.mesfin") and len(trim(form.mesfin))>
	<cfset mesFinD = form.mesHasta>
</cfif>
<cfif isDefined("form.cmayor_ccuenta1") and len(trim(form.cmayor_ccuenta1))>
	<cfset cuentaD = "(" & form.cmayor_ccuenta1 & ") " & form.cuentaDescrip>
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
<cfset nCols = MaxColumnas+1>  	<!--- Total de columnas del encabezado. --->

<!--- Botones --->
<cfif not isDefined("form.toExcel")>
	<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
	<table id="tablabotones" align="center" width="100%" cellpadding="2" cellspacing="0" border="0">
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
</cfif>

<!--- Pinta el Encabezado --->
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
	<cfoutput>
	<tr><td colspan="#nCols#" class="titulo_empresa">#rsEmpresa.Edescripcion#</td></tr>
	<tr><td colspan="#nCols#" class="titulo_reporte">Reporte Gesti&oacute;n de Obras</td></tr>
	<tr><td colspan="#nCols#" class="titulo_filtro">Cuenta #cuentaD#</td></tr>
	<cfif isdefined("secciontitulo") and len(secciontitulo)>
		<tr><td colspan="#nCols#" class="titulo_filtro">#secciontitulo#</td></tr>
	</cfif>	
	<tr><td colspan="#nCols#" class="titulo_filtro">desde #mesIniD# hasta #mesFinD# del #periodoD#</td></tr>
	<tr><td colspan="#nCols#" align="center"><hr></td></tr>
	<tr>
		<td align="left"><strong>CUENTA</strong></td>
		<cfloop query="rsColumnas">
			<td align="right"><strong>#PCCDdescripcion#</strong></td>
		</cfloop>
	</tr>
	<tr><td colspan="#nCols#" align="center"><hr></td></tr>
	</cfoutput>
	
	<cfset primerregistro = true>
	<cfset CuentaAnterior = "">
	<cfset FormatoAnterior = "">
	<cftry>
	
		<cfset Lvarcontador = 0>
		<cfflush interval="16">
		<cf_jdbcquery_open name="rsLineas" datasource="#session.DSN#">
			<cfoutput>#myquery#</cfoutput>
		</cf_jdbcquery_open>
	
	
		<cfoutput query="rsLineas">
			<cfif primerregistro>
				<cfset CuentaAnterior = Cuenta>
				<cfset FormatoAnterior = CuentaFormato>
				<cfset primerregistro = false>
			</cfif>
			<cfif CuentaAnterior NEQ Cuenta>
				<!--- Imprimir los TD de la tabla con los valores del arreglo --->
				<tr>
					<td>#FormatoAnterior#</td>
					<cfloop index="i" from="1" to="#MaxColumnas#">
						<td align="<cfif #i# eq 0>left<cfelse>right</cfif>">#LSNumberFormat(totales[i], ",.00")#</td>
					</cfloop>
				</tr>
				<!--- Inicializar en cero el arreglo de montos por columna --->
				<cfloop index="i" from="1" to="#MaxColumnas#">
					<cfset totales[i] = 0>
				</cfloop>
		
				<cfset CuentaAnterior = Cuenta>
				<cfset FormatoAnterior = CuentaFormato>
			</cfif>

			<!--- buscar en arreglo de valores[]  con el dato de PCCDvalor --->
			<cfset Columna = MaxColumnas>
			<cfloop index="i" from="1" to="#MaxColumnas#">
				<cfif valores[i] EQ PCCDvalor>
					<cfset Columna = i>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfset totales[Columna] = Saldo>
		
			<cfset Lvarcontador = Lvarcontador + 1>
		</cfoutput>
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
	</cftry>
	<cf_jdbcquery_close>
	
	<!--- Imprimir la última linea de la tabla --->
	<cfif Lvarcontador gt 0>
	<tr>
		<cfoutput>
			<td>#FormatoAnterior#</td>
			<cfloop index="i" from="1" to="#MaxColumnas#"> <!--- MaxLineas --->
				<td align="<cfif #i# eq 0>left<cfelse>right</cfif>">#LSNumberFormat(totales[i], ",.00")#</td>
			</cfloop>
		</cfoutput>
	</tr>
	<cfelse>
	<cfset clsp = #MaxColumnas# + 1>
	<tr>		
		<td colspan="<cfoutput>#clsp#</cfoutput>" align="center">-- No hay datos para mostrar --</td>
	</tr>	
	</cfif>
</table>

<cfoutput>
<form name="FormExcel" id="FormExcel" method="post" action="ObrasRep.cfm">
	<input type="hidden" name="toExcel" id="toExcel" value="false">
	<input type="hidden" name="cmayor_ccuenta1" value="<cfif isDefined("form.CMayor_CCuenta1")>#form.CMayor_CCuenta1#</cfif>">
	<input type="hidden" name="mes" value="<cfif isDefined("form.Mes")>#form.Mes#</cfif>">
	<input type="hidden" name="mesfin" value="<cfif isDefined("form.Mesfin")>#form.Mesfin#</cfif>">
	<input type="hidden" name="periodo" value="<cfif isDefined("form.Periodo")>#form.Periodo#</cfif>">
	<input type="hidden" name="reporte" value="<cfif isDefined("form.Reporte")>#form.Reporte#</cfif>">

	<input type="hidden" name="cbonivel" value="<cfif isDefined("form.cbonivel")>#form.cbonivel#</cfif>">
	<input type="hidden" name="ubicacion" value="<cfif isDefined("form.ubicacion")>#form.ubicacion#</cfif>">

	<input type="hidden" name="MesDesde" value="<cfif isDefined("form.MesDesde")>#form.MesDesde#</cfif>">
	<input type="hidden" name="MesHasta" value="<cfif isDefined("form.MesHasta")>#form.MesHasta#</cfif>">
	<input type="hidden" name="Consultar" value="<cfif isDefined("form.Consultar")>#form.Consultar#</cfif>">
	<input type="hidden" name="CuentaDescrip" value="<cfif isDefined("form.CuentaDescrip")>#form.CuentaDescrip#</cfif>">
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
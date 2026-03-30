<!--- Reporte de Analisis de Información de Planes de Cuenta
	  Objetivo:
			Presentar un informe matricial que permita analizar la información de uno de los catálogos
			de información contra otro catálogo del plan de cuenta, o presentando información matricial entre uno de los catálogos 
			y cuentas de mayor.
	  Consultas para llenado de combos de selección de reporte:
	  Combos: 
		a. Tipo de Reporte:  
			1 - Matriz de Catalogos
			2 - Catalogo / Cuenta de Mayor
			3 - Cuenta de Mayor / Catálogo
		b. Catalogos seleccionados en la tabla PCCubo.
		c. Cuentas de mayor requeridas --->
 <cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="An&aacute;lisis por Cat&aacute;logos" 
returnvariable="LB_Titulo" xmlfile="AnexoMatrizCatalogos.xml"/>
 <cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_TipoReporte" 	default="Tipo de Reporte" 
returnvariable="LB_TipoReporte" xmlfile="AnexoMatrizCatalogos.xml"/>
 <cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_PrimerCatalogo" 	default="Primer  Cat&aacute;logo" 
returnvariable="LB_PrimerCatalogo" xmlfile="AnexoMatrizCatalogos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_CatalogoSecundario" 	default="Cat&aacute;logo Secundario" 
returnvariable="LB_CatalogoSecundario" xmlfile="AnexoMatrizCatalogos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_CatalogoSecundario" 	default="Cat&aacute;logo Secundario" 
returnvariable="LB_CatalogoSecundario" xmlfile="AnexoMatrizCatalogos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Periodo" 	default="Periodo" 
returnvariable="LB_Periodo" xmlfile="AnexoMatrizCatalogos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Mes" 	default="Mes" 
returnvariable="LB_Mes" xmlfile="AnexoMatrizCatalogos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_CuentaDesde" 	default="Cuenta Desde" 
returnvariable="LB_CuentaDesde" xmlfile="AnexoMatrizCatalogos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_CuentaHasta" 	default="Cuenta Hasta" 
returnvariable="LB_CuentaHasta" xmlfile="AnexoMatrizCatalogos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Oficina" 	default="Oficina" 
returnvariable="LB_Oficina" xmlfile="AnexoMatrizCatalogos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Grupos" 	default="Grupos" 
returnvariable="LB_Grupos" xmlfile="AnexoMatrizCatalogos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_OficinaAdicional" 	default="Oficina Adicional" 
returnvariable="LB_OficinaAdicional" xmlfile="AnexoMatrizCatalogos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Porcentaje" 	default="Porcentaje" 
returnvariable="LB_Porcentaje" xmlfile="AnexoMatrizCatalogos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Porcentaje" 	default="Porcentaje" 
returnvariable="LB_Porcentaje" xmlfile="AnexoMatrizCatalogos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="CHK_EliminarColumnasEnCero" 	default="Eliminar Columnas en Cero" 
returnvariable="CHK_EliminarColumnasEnCero" xmlfile="AnexoMatrizCatalogos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="CHK_EliminarFilasEnCero" 	default="Eliminar Filas en Cero" 
returnvariable="CHK_EliminarFilasEnCero" xmlfile="AnexoMatrizCatalogos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="CHK_MostrarSoloMovimientosDelPeriodo" 	default="Mostrar Solo Movimientos del Periodo" returnvariable="CHK_MostrarSoloMovimientosDelPeriodo" xmlfile="AnexoMatrizCatalogos.xml"/>
 <cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Botones1" 	default="Aceptar, Cargar, Regresar" 
returnvariable="LB_Botones1" xmlfile="AnexoMatrizCatalogos.xml"/>
 <cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Botones2" 	default="Cargar, Regresar" 
returnvariable="LB_Botones2" xmlfile="AnexoMatrizCatalogos.xml"/>
 <cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Mensaje" 	default="No se ha procesado la configuración o aún no está llena la estructura de control.  No puede ejecutar el reporte a&uacute;n." 
returnvariable="LB_Mensaje" xmlfile="AnexoMatrizCatalogos.xml"/>
 
<cfsetting requesttimeout="1800">
<cfset LvarCargado   = false>
<cfset LvarCcuenta   = 0>
<cfset LvarCcantidad = 0>
<cfset LvarUfecha  = "NUNCA">

<cfquery name="rsCatalogos" datasource="#session.dsn#">
	select cu.PCEcatid, cat.PCEcodigo, cat.PCEdescripcion
	from PCCubo cu
		inner join PCECatalogo cat
		on cat.PCEcatid = cu.PCEcatid
	where cu.Ecodigo = #session.Ecodigo#
	  and cu.PCEcatid is not null
</cfquery>

<cfquery name="rsPeriodos" datasource="#session.dsn#">
	select distinct Speriodo as Speriodo
	from CGPeriodosProcesados
	where Ecodigo = #session.Ecodigo#
	order by Speriodo desc
</cfquery>

<cfquery name="rsCuentas" datasource="#session.dsn#">
	select Cmayor, Cdescripcion
	from CtasMayor
	where Ecodigo = #session.Ecodigo#
	order by Cmayor
</cfquery>

<cfquery name="rsOficinas" datasource="#session.dsn#">
	select Ocodigo, Oficodigo, <cf_dbfunction name="sPart" args="Odescripcion,1, 25"> as Odescripcion 
	from Oficinas 
	where Ecodigo = #session.ecodigo#
	order by Oficodigo
</cfquery>

<cfquery name="rsGOficinas" datasource="#session.dsn#">
	select 
			  e.GOid as GOid
			, e.GOcodigo as GOcodigo
			, <cf_dbfunction name="sPart" args="e.GOnombre,1, 25"> as GOnombre
			, 
				(( 
					select count(1)
					from AnexoGOficinaDet d
					where d.GOid = e.GOid
			 	)) as Cantidad
	from AnexoGOficina e
	where e.Ecodigo = #session.Ecodigo#
	  and 
				(( 
					select count(1)
					from AnexoGOficinaDet d
					where d.GOid = e.GOid
			 	)) > 0
	order by e.GOcodigo
</cfquery>

<cfquery name="rsUltimaCuenta" datasource="#session.dsn#">
	select 
		PCDCfecha, Ccuenta
	from PCCuboFecha
	where Ecodigo = #session.Ecodigo#
</cfquery>

<cfif rsUltimaCuenta.recordcount GT 0 and len(trim(rsUltimaCuenta.Ccuenta)) GT 0 and rsUltimaCuenta.Ccuenta GT 0>
	<cfset LvarCargado   = true>
	<cfset LvarCcuenta   = rsUltimaCuenta.Ccuenta>
	<cfset LvarUfControl = rsUltimaCuenta.PCDCfecha>
	<cfset LvarUfecha    = dateformat(rsUltimaCuenta.PCDCfecha, "DD/MM/YYYY")>

	<cfquery name="rsCuentasPend" datasource="#session.dsn#">
		select count(1) as Cantidad
		from CContables c
		where Ecodigo = #session.Ecodigo#
		  and Cmovimiento ='S'
		  and Ccuenta > #LvarCcuenta#
	</cfquery>
	<cfset LvarCcantidad = 	rsCuentasPend.Cantidad>
</cfif> 

<cfif LvarCargado EQ true and LvarCcantidad GT 0>
	<cfset botones ="Aceptar, Cargar, Regresar">
<cfelseif LvarCargado EQ false>
	<cfset botones ="Cargar, Regresar">
<cfelse>
	<cfset botones ="Aceptar, Regresar">
</cfif>


<cfif not(isdefined('url.Cargar') and url.Cargar eq "1")>
	<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start titulo="#LB_Titulo#">
		<cfinclude template="/home/menu/pNavegacion.cfm">
</cfif>
		<form name="form1" action="AnexoMatrizCatalogos-ReporteCat.cfm" method="post">
			<cfif isdefined('url.Cargar') and url.Cargar eq "1">
				<cfset recargar = CargarCuboCatalogos()>
				<cfif recargar>
					<script language="javascript1.2" type="text/javascript">
						{
							document.form1.action='AnexoMatrizCatalogos.cfm';
							document.form1.submit();
						}
					</script>
					<cfabort>
				</cfif>
			</cfif>
			<table align="center" cellpadding="0" cellspacing="0" width="100%" border="0">
				<tr>
					<td colspan="4">&nbsp;</td>
				</tr>
				<cfif not LvarCargado>
					<tr>
						<td colspan="4" align="center" style="color:#FF0000"><cfoutput>#LB_Mensaje#</cfoutput></td>
					</tr>
				<cfelseif LvarCcantidad GT 0 and datediff('d', LvarUfControl, now()) GT 5>
					<tr>
						<cfoutput>
						<td colspan="4" align="center" style="color:##FF0000">Precacui&oacute;n: Existen #numberformat(LvarCcantidad, ",.")# nuevas cuentas no identificadas para este reporte. La &uacute;ltima ejecuci&oacute;n se realiz&oacute; el #LvarUfecha#.</td>
						</cfoutput>
					</tr>
				</cfif>
				<tr>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td align="right"><strong><cfoutput>#LB_TipoReporte#:&nbsp;</cfoutput></strong></td>
					<td colspan="3">
						<select name="TipoReporte" id="TipoReporte" tabindex="0">
							<option value="2">Catalogo  /  Cuenta</option>
							<option value="3">Cuenta    /  Catalogo</option>
							<option value="1">Catalogo  /  Catalogo</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right"><cfoutput><strong>#LB_PrimerCatalogo#:&nbsp;</strong></cfoutput></td>
					<td colspan="3">
						<select name="LvarCatalogo1" id="LvarCatalogo1" tabindex="1">
							<cfoutput query="rsCatalogos">
								<option value="#rsCatalogos.PCEcatid#">#rsCatalogos.PCEcodigo# - (#rsCatalogos.PCEdescripcion#)</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right"><cfoutput><strong>#LB_CatalogoSecundario#:&nbsp;</strong></cfoutput></td>
					<td colspan="3">
						<select name="LvarCatalogo2" id="LvarCatalogo2" tabindex="2">
							<cfoutput query="rsCatalogos">
								<option value="#rsCatalogos.PCEcatid#">#rsCatalogos.PCEcodigo# - (#rsCatalogos.PCEdescripcion#)</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td align="right"><cfoutput><strong>#LB_Periodo#:&nbsp;</strong></cfoutput></td>
					<td colspan="3">
						<select name="Periodo" id="Periodo" tabindex="3">
							<cfoutput query="rsPeriodos">
								<option value="#rsPeriodos.SPeriodo#">#rsPeriodos.Speriodo#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
			
				<tr>
					<td align="right"><cfoutput><strong>#LB_Mes#:&nbsp;</strong></cfoutput></td>
					<td colspan="3">
						<cfoutput>
						<select name="Mes" id="Mes" tabindex="3">
							<cfloop index="x" from="1" to="12">
								<option value="#x#">#x#</option>
							</cfloop>
						</select>
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td align="right"><cfoutput><strong>#LB_CuentaDesde#:&nbsp;</strong></cfoutput></td>
					<td colspan="3">
						<cfoutput>
						<select name="CtaMayor1" id="CtaMayor1" tabindex="6">
							<option value=" " selected="selected"> </option>
							<cfloop query="rsCuentas">
								<option value="#rsCuentas.Cmayor#">#rsCuentas.Cmayor# - #rsCuentas.Cdescripcion#</option>
							</cfloop>
						</select>
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td align="right"><cfoutput><strong>#LB_CuentaHasta#:&nbsp;</strong></cfoutput></td>
					<td colspan="3">
						<cfoutput>
						<select name="CtaMayor2" id="CtaMayor2" tabindex="7">
							<option value=" " selected="selected"> </option>
							<cfloop query="rsCuentas">
								<option value="#rsCuentas.Cmayor#">#rsCuentas.Cmayor# - #rsCuentas.Cdescripcion#</option>
							</cfloop>
						</select>
						</cfoutput>
					</td>
				</tr>
		
				<tr>
					<td align="right"><strong><cfoutput>#LB_Oficina#:&nbsp;</cfoutput></strong></td>
					<td colspan="3">
						<cfoutput>
						<select name="Oficina" id="Oficina" tabindex="8">
							<option value=" " selected="selected"> Todas o Grupo Oficinas</option>
							<cfloop query="rsOficinas">
								<option value="#rsOficinas.Ocodigo#">#rsOficinas.Oficodigo# - #rsOficinas.Odescripcion#</option>
							</cfloop>
						</select>
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td align="right"><strong><cfoutput>#LB_Grupos#:&nbsp;</cfoutput></strong></td>
					<td colspan="3">
						<cfoutput>
						<select name="GOficina" id="GOficina" tabindex="9">
							<option value=" " selected="selected"> {Oficina Seleccionada} </option>
							<cfloop query="rsGOficinas">
								<option value="#rsGOficinas.GOid#">#rsGOficinas.GOcodigo# - #rsGOficinas.GOnombre#</option>
							</cfloop>
						</select>
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td align="right"><strong><cfoutput>#LB_OficinaAdicional#:&nbsp;</cfoutput></strong></td>
					<td>
						<cfoutput>
						<select name="OficinaAdicional" id="OficinaAdicional" tabindex="10">
							<option value=" " selected="selected"> Ninguna</option>
							<cfloop query="rsOficinas">
								<option value="#rsOficinas.Ocodigo#">#rsOficinas.Oficodigo# - #rsOficinas.Odescripcion#</option>
							</cfloop>
						</select>
						</cfoutput>
					</td>
					<td align="right"><strong><cfoutput>#LB_Porcentaje#:&nbsp;</cfoutput></strong></td>
					<td><input type="text" name="Porcentaje" maxlength="12" /></td>
				</tr>
				<tr>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3"><input type="checkbox" name="chkEliminarColCero" />
					<strong><cfoutput>#CHK_EliminarColumnasEnCero#</cfoutput></strong></td> 
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3"><input type="checkbox" name="chkEliminarFilCero" />
					<strong><cfoutput>#CHK_EliminarFilasEnCero#</cfoutput></strong></td> 
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3"><input type="checkbox" name="chkSoloPeriodo" />
					<strong><cfoutput>#CHK_MostrarSoloMovimientosDelPeriodo#</cfoutput></strong></td> 
				</tr>
				<tr>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="4" align="center">
						<cf_botones values="#botones#">
					</td>
				</tr>
			</table>
		</form>
<cfif not(isdefined('url.Cargar') and url.Cargar eq "1")>
	<cf_web_portlet_end>
	<cf_templatefooter>
</cfif>
<cf_qforms form="form1">
<script language="javascript1" type="text/javascript">
	function funcRegresar()
	{
		document.form1.action='/cfmx/home/menu/modulo.cfm?s=SIF&m=AN'
	}		
		objForm.TipoReporte.description = "Tipo de Reporte";
		objForm.LvarCatalogo1.description = "Primer Catalogo";
		objForm.LvarCatalogo2.description = "Segundo Catalogo";
		
	function habilitarValidacion() 
	{
		objForm.TipoReporte.required = true;
		objForm.LvarCatalogo1.required = true;
		objForm.LvarCatalogo2.required = true;
		objForm.Periodo.required = true;
		objForm.Mes.required = true;
	}
	function funcCargar(){
		document.form1.action='AnexoMatrizCatalogos.cfm?cargar=1'
	}
</script>

<cffunction name="CargarCuboCatalogos" access="private" output="yes">
	<cfquery name="rsUltimaCuenta" datasource="#session.dsn#">
		select 
			PCDCfecha, Ccuenta
		from PCCuboFecha
		where Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfset LvarCcuenta = 0>
	<cfif rsUltimaCuenta.recordcount GT 0 and len(trim(rsUltimaCuenta.Ccuenta)) GT 0 and rsUltimaCuenta.Ccuenta GT 0>
		<cfset LvarCcuenta   = rsUltimaCuenta.Ccuenta>
	<cfelse>
		<cfquery datasource="#session.dsn#">
			insert into PCCuboFecha (Ecodigo, PCDCfecha, Ccuenta)
			values (#session.Ecodigo#, null, 0)
		</cfquery>
	</cfif>


	<cfquery name="rsColumnas" datasource="#session.dsn#">
		select 
			PCCcolumna,	PCEcatid, PCcatdep
		from PCCubo
		where Ecodigo = #session.Ecodigo#
		  and PCEcatid is not null
		order by PCCcolumna
	</cfquery>

	<cfif rsColumnas.recordcount LT 1>
		<cfreturn true>
	</cfif>

	<cfset LvarColumnaCubo = arraynew(1)>
	<cfset LvarColumna = 0>

	<cfloop query="rsColumnas">
		<cfset LvarColumna   = rsColumnas.PCCcolumna>
		<cfset LvarColumnaCubo[LvarColumna] = rsColumnas.PCEcatid>
	</cfloop>


	<cfquery name="rsCuentasPend" datasource="#session.dsn#">
		select count(1) as Cantidad
		from CContables c
		where Ecodigo = #session.Ecodigo#
		  and Cmovimiento ='S'
		  and Ccuenta > #LvarCcuenta#
	</cfquery>

	<cfset LvarCantidadCuentas = rsCuentasPend.Cantidad>
	 
	<cfquery name="rsCuentasPend" datasource="#session.dsn#">
		select c.Ccuenta, c.Cformato
		from CContables c
		where Ecodigo = #session.Ecodigo#
		  and Cmovimiento ='S'
		  and Ccuenta > #LvarCcuenta#
		order by Ccuenta
	</cfquery>

	<cfoutput><p>Procesando las Cuentas Pendientes en el Control de Cuentas ...</p></cfoutput>
	<cfflush interval="20">

	<cfset LvarProcesadas = 0>

	<cfloop query="rsCuentasPend" >
		<!--- Obtener los datos de cada uno de los catalogos y grabar la tabla PCCuentaCubo --->
		<cfset LvarCuentaProceso = rsCuentasPend.Ccuenta>
		<cfset LvarProcesadas = LvarProcesadas + 1>
		<cfoutput><p>&nbsp;&nbsp;Cuenta: #rsCuentasPend.Cformato#   (#LvarProcesadas# de #LvarCantidadCuentas#  :  #numberformat(LvarProcesadas * 100 / LvarCantidadCuentas,",0.00")#) %</p></cfoutput>		
		<cfquery datasource="#session.dsn#">
			insert into PCCuentaCubo (
				Ccuenta, Ecodigo, Cmayor 
				<cfif LvarColumna GTE 1>,PCDcatid01</cfif>
				<cfif LvarColumna GTE 2>,PCDcatid02</cfif>
				<cfif LvarColumna GTE 3>,PCDcatid03</cfif> 
				<cfif LvarColumna GTE 4>,PCDcatid04</cfif> 
				<cfif LvarColumna GTE 5>,PCDcatid05</cfif> 
				<cfif LvarColumna GTE 6>,PCDcatid06</cfif> 
				<cfif LvarColumna GTE 7>,PCDcatid07</cfif> 
				<cfif LvarColumna GTE 8>,PCDcatid08</cfif> 
				<cfif LvarColumna GTE 9>,PCDcatid09</cfif> 
				<cfif LvarColumna GTE 10>,PCDcatid10</cfif>
			)
			select 
				c.Ccuenta, c.Ecodigo, c.Cmayor
				<cfif LvarColumna GTE 1>, ((select min(PCDcatid) from PCDCatalogoCuenta cc where cc.Ccuenta = c.Ccuenta and cc.PCEcatid = #LvarColumnaCubo[1]#))</cfif>
				<cfif LvarColumna GTE 2>, ((select min(PCDcatid) from PCDCatalogoCuenta cc where cc.Ccuenta = c.Ccuenta and cc.PCEcatid = #LvarColumnaCubo[2]#))</cfif>
				<cfif LvarColumna GTE 3>, ((select min(PCDcatid) from PCDCatalogoCuenta cc where cc.Ccuenta = c.Ccuenta and cc.PCEcatid = #LvarColumnaCubo[3]#))</cfif> 
				<cfif LvarColumna GTE 4>, ((select min(PCDcatid) from PCDCatalogoCuenta cc where cc.Ccuenta = c.Ccuenta and cc.PCEcatid = #LvarColumnaCubo[4]#))</cfif> 
				<cfif LvarColumna GTE 5>, ((select min(PCDcatid) from PCDCatalogoCuenta cc where cc.Ccuenta = c.Ccuenta and cc.PCEcatid = #LvarColumnaCubo[5]#))</cfif> 
				<cfif LvarColumna GTE 6>, ((select min(PCDcatid) from PCDCatalogoCuenta cc where cc.Ccuenta = c.Ccuenta and cc.PCEcatid = #LvarColumnaCubo[6]#))</cfif> 
				<cfif LvarColumna GTE 7>, ((select min(PCDcatid) from PCDCatalogoCuenta cc where cc.Ccuenta = c.Ccuenta and cc.PCEcatid = #LvarColumnaCubo[7]#))</cfif> 
				<cfif LvarColumna GTE 8>, ((select min(PCDcatid) from PCDCatalogoCuenta cc where cc.Ccuenta = c.Ccuenta and cc.PCEcatid = #LvarColumnaCubo[8]#))</cfif> 
				<cfif LvarColumna GTE 9>, ((select min(PCDcatid) from PCDCatalogoCuenta cc where cc.Ccuenta = c.Ccuenta and cc.PCEcatid = #LvarColumnaCubo[9]#))</cfif> 
				<cfif LvarColumna GTE 10>, ((select min(PCDcatid) from PCDCatalogoCuenta cc where cc.Ccuenta = c.Ccuenta and cc.PCEcatid = #LvarColumnaCubo[10]#))</cfif>
			from CContables c
			where c.Ccuenta = #LvarCuentaProceso#
			  and not exists(
				select 1
				from PCCuentaCubo cu
				where cu.Ccuenta = c.Ccuenta
			   )
		</cfquery>
		<!---  Borrar si todas las columnas están en nulo ( no interesa el registro ) --->
		<cfquery datasource="#session.dsn#">
			delete from PCCuentaCubo
			where Ccuenta = #LvarCuentaProceso#
			  and PCDcatid01 is null
			  and PCDcatid02 is null
			  and PCDcatid03 is null
			  and PCDcatid04 is null
			  and PCDcatid05 is null
			  and PCDcatid06 is null
			  and PCDcatid07 is null
			  and PCDcatid08 is null
			  and PCDcatid09 is null
			  and PCDcatid10 is null
		</cfquery>
		<!--- Actualiza la tabla de Control de Cubo --->
		<cfquery datasource="#session.dsn#">
			update PCCuboFecha
			set Ccuenta = #LvarCuentaProceso#
			where Ecodigo = #session.Ecodigo#
		</cfquery>

	</cfloop>
	<!--- Actualiza la tabla de Control de Cubo --->
	<cfquery datasource="#session.dsn#">
		update PCCuboFecha
		set PCDCfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		where Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfreturn true>
</cffunction>

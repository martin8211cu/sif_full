<cfsetting requesttimeout="3600">
<!---
	Reporte para Anexos Financieros
	Objetivo:
		Presentar un informe matricial de análisis de cuentas contables 
		que permita relacionar el valor de dos catálogos y entregar su saldo o movimiento en un mes específico
		El informe generado será exportado a Anexos Financieros para su presentación en formato de Hoja Electrónica de Cálculo
	Procesamiento:
		Según la elección del usuario, se preparan tres tipos de formato
			Tipo de Reporte:
				1.  Reporte de Matriz de Catalogo     / Catalogo
				2.  Reporte de Matriz de Catalogo     / Cuenta Mayor
				3.  Reporte de Matriz de Cuenta Mayor / Catalogo
		a.  Se obtienen las columnas que se deben de procesar y se genera un arreglo en memoria 
		b.  Se obtienen las filas que se deben de procesar
		c.  Por Fila, se procesan los datos de cada una de las columnas con el valor corrrespondiente a la matriz,
			obteniendo los datos de la tabla SaldosContables para el año y mes seleccionado por el usuario
		Se define 30 minutos de timeout para la generación del reporte pues debe de procesar las cuentas de movimiento
		para permitir el análisis de los catálogos.

	<!--- 
		Generación del informe
		Se procesa en HTML y en un archivo, 
		para que se vea en pantalla pero pueda ser "bajado" a disco
		sin requerir el reprocesamiento
	--->

	<cfif isdefined("form.NombreArchivo") and len(trim(form.nombreArchivo)) GT 0>
		<!--- 
			Se procesa el archivo existente.
			No se genera nuevamente el archivo
		--->
	</cfif>
--->

<cfset LvarTiempoInicioG = gettickcount()>
<cfset MatrizCatalogo_Param()>  		<!--- Determina y Procesa los parámetros del informe ---> 
<cfset MatrizCatalogo_Oficinas()>		<!--- Determina y Procesa las oficinas seleccinadas para el informe --->
<cfset MatrizCatalogo_GenColumnas()>	<!--- Procesa la información requerida para las columnas el informe --->
<cfset MatrizCatalogo_GenFilas()>		<!--- Procesa la información requerida para las filas del informe --->

<cfset LvarPeriodoReporte = " #ObtieneNombreMes(LvarMes)# / #LvarPeriodo# ">
<cfif LvarTipoReporte EQ 1>
	<cfset LvarNombreReporte = "Saldos de #ObtieneNombreCatalogo(form.LvarCatalogo1, 'Titulo')# por #ObtieneNombreCatalogo(form.LvarCatalogo2, 'Titulo')#">
<cfelseif LvarTipoReporte EQ 2>
	<cfset LvarNombreReporte = "Saldos de #ObtieneNombreCatalogo(form.LvarCatalogo1, 'Titulo')# por Cuenta">
<cfelseif LvarTipoReporte EQ 3>
	<cfset LvarNombreReporte = "Saldos de Cuenta por #ObtieneNombreCatalogo(form.LvarCatalogo1, 'Titulo')#">
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Reporte de Saldos por Catalogos</title>
</head>
<body>

<cf_htmlReportsHeaders 
		title="AnalisisxCatalogos" 
		filename="AnalisisxCatalogos#dateformat(now(),'dd/mm/yyyy')#.xls"
		irA="AnexoMatrizCatalogos.cfm">
<table border="0" bordercolor="#999999" cellspacing="0" cellpadding="2">
	<cfoutput>
	<tr><td colspan="#LvarColumnas#" align="center">&nbsp;</td></tr>
	<tr><td colspan="#LvarColumnas#" align="center"><strong>#Session.Enombre#</strong></td></tr>
	<tr><td colspan="#LvarColumnas#" align="center"><strong>#LvarNombreReporte#</strong></td></tr>
	<tr><td colspan="#LvarColumnas#" align="center"><strong>#LvarPeriodoReporte#</strong></td></tr>
	<cfif LvarTituloOficina NEQ "">
		<tr><td colspan="#LvarColumnas#" align="center"><strong>#LvarTituloOficina#</strong></td></tr>
	</cfif>
	<tr><td colspan="#LvarColumnas#" align="center">&nbsp;</td></tr>
	<cfif LvarClasificacion NEQ "">
		<tr><td colspan="#LvarColumnas#" align="center">#LvarClasificacion#</td></tr>
		<tr><td colspan="#LvarColumnas#" align="center">&nbsp;</td></tr>
	</cfif>
	</cfoutput>
	<cfflush interval="64">
	<cfif len(trim(LvarClasificacionColID)) GT 0 and LvarClasificacionColID NEQ -1>
		<!---  Incluir ( Pintar en la tabla ) las clasificaciones de las columnas - si existe - para el tipo de informe --->
		<cfset LvarColAnt = 2>
		<cfset LvarColor = 1>
		<cfoutput>
		<tr>
			<td>&nbsp;</td>
			<td align="right"><strong>#LvarClasificacionColDes#:&nbsp;&nbsp;</strong></td>
			<cfloop index="Columna" from="4" to="#LvarColumnas#" step="1">
				<cfif ColumnasReporteCodigoClas[Columna] neq ColumnasReporteCodigoClas[Columna-1]>
					<td colspan="#Columna-LvarColAnt -1#" align="center" <cfif LvarColor EQ 1>bgcolor="##999999"</cfif>><strong>&nbsp;#ColumnasReporteCodigoClas[Columna-1]#</strong></td>
					<cfset LvarColAnt = Columna - 1>
					<cfif LvarColor EQ 2><cfset LvarColor =  1><cfelse><cfset LvarColor = 2></cfif>
				</cfif>
			</cfloop>
			<td colspan="#LvarColumnas-LvarColAnt#" align="center" <cfif LvarColor EQ 1>bgcolor="##999999"</cfif>><strong>&nbsp;#ColumnasReporteCodigoClas[LvarColumnas]#</strong></td>			
		</tr>
		</cfoutput>
	</cfif>
	
	<!---  Generar (Pintar en la tabla ) la información de las columnas en la página HTML --->
	<cfoutput>
	<tr>
		<cfif LvarTipoReporte EQ 3>
			<td nowrap="nowrap" bgcolor="##999999"><strong>Cuenta</strong></td>
		<cfelse>
			<td bgcolor="##999999"><strong>#ObtieneNombreCatalogo(form.LvarCatalogo1, 'Columna')#</strong></td>
		</cfif>
		<td bgcolor="##999999"><strong>Descripci&oacute;n</strong></td>
		<cfloop index="Columna" from="3" to="#LvarColumnas#" step="1">
			<td nowrap="nowrap" align="right" bgcolor="##999999"><strong>&nbsp;#ColumnasReporteValor[Columna]#</strong></td>
		</cfloop>
		<td nowrap="nowrap" align="right" bgcolor="##999999"><strong>&nbsp;Total</strong></td>
		<!--- <td nowrap="nowrap" align="right"><strong>&nbsp;Tiempo</strong></td> --->
	</tr>
	</cfoutput>

	<!--- Procesa las filas del reporte --->
	<cfset LvarClasificaAnt = "">
	<cfloop query="rsFilas">

		<cfset LvarFila			= rsFilas.Fila>
		<cfset LvarDescripcion	= rsFilas.Descripcion>
		<cfset LvarClasifica	= rsFilas.CodigoClas>
		<cfset LvarID			= rsFilas.ID>

		<cfset LvarTiempoInicioF = gettickcount()>
		<cfset LvarTotalFila   = 0.00>

		<cfif LvarTipoReporte EQ 3>
			<cfset rsResultado = ObtieneFilaCuenta(LvarFila)>
		<cfelse>
			<cfset rsResultado = ObtieneFilaCatalogo(LvarID)>
		</cfif>

		<cfset LvarMostrarFila = true>
		<cfif LvarEliminarFilCero>
			<cfquery name="rsEliminarFilCero" dbtype="query">
				select count(1) as Cantidad
				from rsResultado
				where Saldo <> 0
			</cfquery>
			<cfif rsEliminarFilCero.Cantidad EQ 0 or rsEliminarFilCero.recordcount EQ 0>
				<cfset LvarMostrarFila = false>
			</cfif>
		</cfif>

		<cfif LvarMostrarFila>
			<cfif LvarClasificaAnt NEQ LvarClasifica and LvarClasificacionFilID NEQ -1>
				<cfoutput>
					<cfif LvarClasificaAnt NEQ "">
						<cfset LvarTotalFila         = 0.00>
						<tr>
							<td>&nbsp;</td>
							<td style="font:Arial, Helvetica, sans-serif x-large italic"><strong>SubTotal:</strong></td>
							<cfloop index="Columna" from="3" to="#LvarColumnas#" step="1">
								<td nowrap="nowrap" align="right">#numberformat(ValorColumna[Columna], ",0.00")#</td>
								<cfset LvarTotalFila         = LvarTotalFila + ValorColumna[Columna]>
								<cfset ValorColumna[Columna] = 0.00>
							</cfloop>
							<td nowrap="nowrap" align="right">#numberformat(LvarTotalFila, ",0.00")#</td>
							<cfset LvarTotalFila = 0.00>
						</tr>
						<tr>
							<td colspan="#LvarColumnas#">&nbsp;</td>
						</tr>
					</cfif>
					<cfset LvarClasificaAnt = LvarClasifica>
					<tr>
						<td>&nbsp;</td>
						<td colspan="2" style="font:Arial, Helvetica, sans-serif x-large italic"><strong>#rsFilas.DescripcionClas#</strong></td>
					</tr>
				</cfoutput>
			</cfif>
			<cfoutput>
				<tr>
					<td nowrap="nowrap">&nbsp;#LvarFila#</td>
					<td nowrap="nowrap">#LvarDescripcion#</td>
					<cfloop index="Columna" from="3" to="#LvarColumnas#" step="1">
						<cfif LvarTipoReporte NEQ 2>
							<cfquery name="rsCelda" dbtype="query">
								select Saldo as Saldo
								from rsResultado
								where Columna = #ColumnasReporteID[Columna]#
							</cfquery>
						<cfelse>						
							<cfquery name="rsCelda" dbtype="query">
								select Saldo as Saldo
								from rsResultado
								where Columna = '#ColumnasReporteID[Columna]#'
							</cfquery>
						</cfif>
						<cfif rsCelda.recordcount GT 0>
							<td nowrap="nowrap" align="right">#numberformat(rsCelda.Saldo, ",0.00")#</td>
							<cfset ValorColumna[Columna] = ValorColumna[Columna] + rsCelda.Saldo>
							<cfset TotalColumna[Columna] = TotalColumna[Columna] + rsCelda.Saldo>
							<cfset LvarTotalFila         = LvarTotalFila + rsCelda.Saldo>
						<cfelse>
							<td nowrap="nowrap" align="right">0.00</td>
						</cfif>
					</cfloop>
					<td nowrap="nowrap" align="right">#numberformat(LvarTotalFila, ",0.00")#</td>
					<cfset LvarTotalFila = 0.00>
					<!--- <td nowrap="nowrap" align="right">#numberformat(gettickcount()-LvarTiempoInicioF,",9")#</td> ---> 
				</tr>
			</cfoutput>
		</cfif>
	</cfloop>
	<cfset LvarTotalFila         = 0.00>
	<cfif LvarClasificacionFilID NEQ -1>
		<cfif LvarClasificaAnt NEQ "">
			<tr>
				<td>&nbsp;</td>
				<td style="font:Arial, Helvetica, sans-serif x-large italic"><strong>SubTotal:</strong></td>
				<cfloop index="Columna" from="3" to="#LvarColumnas#" step="1">
					<cfoutput><td nowrap="nowrap" align="right">#numberformat(ValorColumna[Columna], ",0.00")#</td></cfoutput>
					<cfset LvarTotalFila = LvarTotalFila + ValorColumna[Columna]>
				</cfloop>
				<cfoutput><td nowrap="nowrap" align="right">#numberformat(LvarTotalFila, ",0.00")#</td></cfoutput>
			</tr>
		</cfif>
	</cfif>
	<cfset LvarTotalFila         = 0.00>
	<cfoutput>
	<tr>
		<td colspan="#LvarColumnas#">&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="##999999">&nbsp;</td>
		<td nowrap="nowrap" bgcolor="##999999" style="font:Arial, Helvetica, sans-serif x-large italic"><strong>Total:</strong></td>
		<cfloop index="Columna" from="3" to="#LvarColumnas#" step="1">
			<td  bgcolor="##999999" nowrap="nowrap" align="right"><strong>#numberformat(TotalColumna[Columna], ",0.00")#</strong></td>
			<cfset LvarTotalFila = LvarTotalFila + TotalColumna[Columna]>
		</cfloop>
		<td bgcolor="##999999" nowrap="nowrap" align="right"><strong>#numberformat(LvarTotalFila, ",0.00")#</strong></td>
	</tr>
	</cfoutput>

	<cfoutput>
		<tr><td colspan="#LvarColumnas#" align="center">&nbsp;</td></tr>
		<tr><td colspan="#LvarColumnas#" align="center">&nbsp;</td></tr>
		<tr>
			<td colspan="#LvarColumnas#" align="right">Generado: #dateformat(now(), 'd/mm/yyyy hh:mm:ss')#</td>
		</tr>
		<tr>
			<td colspan="#LvarColumnas#" align="right">Tiempo: #numberformat(gettickcount()-LvarTiempoInicioG,",9")#</td>
		</tr>
	</cfoutput>
</table>
</body>
</html>

<cffunction name="MatrizCatalogo_Param" output="false">
	<!--- 
		Definición de los parámetros del reporte.
		Se asignan valores por defecto en caso de que no se reciban por form 
	--->
	<cfset LvarTipoReporte	        = 2>
	<cfset LvarPeriodo        	    = 0>
	<cfset LvarMes          	    = 0>
	<cfset LvarCatalogo1    	    = 0>
	<cfset LvarCatalogo2      	    = 0>
	<cfset LvarEliminarColCero	    = false>
	<cfset LvarEliminarFilCero	    = false>
	<cfset LvarPrimerMesFiscal      = 1>
	<cfset LvarPeriodoFiscal  = 0>
	<cfset LvarSoloPeriodo 			= false>

	<cfif  isdefined("form.Periodo") and isnumeric(form.Periodo)> 
		<cfset LvarPeriodo             = form.Periodo>
		<cfset LvarPeriodoFiscal = form.Periodo>
	</cfif>
	<cfif  isdefined("form.Mes") and isnumeric(form.Mes)>
		<cfset LvarMes       = form.Mes>
	</cfif>
	<cfif  isdefined("form.LvarCatalogo1") and isnumeric(form.LvarCatalogo1)>
		<cfset LvarCatalogo1 = form.LvarCatalogo1>
	</cfif>
	<cfif  isdefined("form.LvarCatalogo2") and isnumeric(form.LvarCatalogo2)>
		<cfset LvarCatalogo2 = form.LvarCatalogo2>
	</cfif>
	<cfif  isdefined("form.CtaMayor1") and len(trim(form.CtaMayor1))>
		<cfset LvarCtaMayor1 = form.CtaMayor1>
	</cfif>
	<cfif  isdefined("form.CtaMayor2") and len(trim(form.CtaMayor2))>
		<cfset LvarCtaMayor2 = form.CtaMayor2>
	</cfif>
	<cfif  isdefined("form.TipoReporte")>
		<cfset LvarTipoReporte = form.TipoReporte>
	</cfif>
	<cfif  isdefined("form.chkEliminarColCero")>
		<cfset LvarEliminarColCero = true>
	</cfif>
	<cfif  isdefined("form.chkEliminarFilCero")>
		<cfset LvarEliminarFilCero = true>
	</cfif>
	<cfif  isdefined("form.chkSoloPeriodo")>
		<cfset LvarSoloPeriodo = true>
	</cfif>
	<cfquery name="rsMesCierreFiscal" datasource="#session.dsn#">
		select Pvalor as Mes
		from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = 45
	</cfquery>
	<cfif rsMesCierreFiscal.recordcount EQ 1 and len(trim(rsMesCierreFiscal.Mes)) GT 0 and rsMesCierreFiscal.Mes NEQ 12>
		<cfset LvarPrimerMesFiscal = rsMesCierreFiscal.Mes + 1>
	</cfif>
	<cfif LvarPrimerMesFiscal GT LvarMes>
		<cfset LvarPeriodoFiscal = LvarPeriodo - 1>
	</cfif>
</cffunction>

<cffunction name="MatrizCatalogo_Oficinas" access="private" output="false">
	<!--- 
		Determinar si el reporte es por oficina o grupo de oficinas 
		Si se requiere un grupo de oficinas, se asignan a la variable
		LvarOcodigo con un "and Ocodigo in ( ... )"
	--->
	
	<cfset LvarOcodigo = "">
	<cfset LvarPorcentaje = "">
	<cfset LvarTituloOficina = "">
	
	<cfif isdefined("form.Oficina") and len(trim(form.Oficina)) NEQ 0>
		<cfset LvarOcodigo = " and s.Ocodigo = #form.Oficina# ">
		<cfquery name="rsOficinas" datasource="#session.dsn#">
			select Ocodigo, Oficodigo, Odescripcion 
			from Oficinas 
			where Ecodigo = #session.ecodigo#
			  and Ocodigo = #form.Oficina#
			order by Oficodigo
		</cfquery>
		<cfset LvarTituloOficina = rsOficinas.Odescripcion>
	
	<cfelseif isdefined("form.GOficina") and len(trim(form.GOficina)) NEQ 0>
		<cfquery name="rsGOficinas" datasource="#session.dsn#">
			select 
				e.GOnombre as GOnombre
			from AnexoGOficina e
			where e.GOid = #form.GOficina#
		</cfquery>

		<cfset LvarTituloOficina = rsGOficinas.GOnombre>

		<cfquery name="rsGOficinaDet" datasource="#session.dsn#">
			select Ocodigo
			from AnexoGOficinaDet
			where GOid = #form.GOficina#	
		</cfquery>
		<cfset LvarOcodigo = " and s.Ocodigo in (">
		<cfloop query="rsGOficinaDet">
			<cfset LvarOcodigo = LvarOcodigo & " #rsGOficinaDet.Ocodigo#, ">
		</cfloop>
		<cfif isdefined("form.OficinaAdicional") and len(trim(form.OficinaAdicional)) GT 0>
			<cfif isdefined("form.Porcentaje") and len(trim(form.Porcentaje)) and isnumeric(form.Porcentaje)>
				<cfif form.Porcentaje > 0 and form.Porcentaje <= 100>
					<cfset LvarOcodigo = LvarOcodigo & " #form.OficinaAdicional#, ">
					<cfset LvarPorcentaje = " * case when s.Ocodigo = #form.OficinaAdicional# then #numberformat(form.Porcentaje / 100, '9.0000')# else 1.00 end ">
				</cfif>
			</cfif>
		</cfif>
		<cfset LvarOcodigo = left(LvarOcodigo, len(LvarOcodigo) - 2) & ")">
	</cfif>	
</cffunction>

<cffunction name="MatrizCatalogo_GenColumnas" access="private" output="false">
	<!---
		Determinar las columnas requeridas en la estructura de Cuentas
	--->
	<cfquery name="rsPCcubo1" datasource="#session.dsn#">
		select PCCcolumna
		from PCCubo
		where Ecodigo = #session.Ecodigo#
		  and PCEcatid = #LvarCatalogo1#
	</cfquery>
	
	<cfquery name="rsPCcubo2" datasource="#session.dsn#">
		select PCCcolumna
		from PCCubo
		where Ecodigo = #session.Ecodigo#
		  and PCEcatid = #LvarCatalogo2#
	</cfquery>
	
	<cfset PCDcatidref1 = "">
	<cfset PCDcatidref2 = "">
	<cfset PCDcatidrefFil = "">
	<cfset PCDcatidrefCol = "">
	
	
	<cfif rsPCcubo1.recordcount GT 0>
		<cfset PCDcatidref1 = "cu.PCDcatid" & numberformat(rsPCcubo1.PCCcolumna, '00')>
	</cfif>
	
	<cfif rsPCcubo2.recordcount GT 0>
		<cfset PCDcatidref2 = "cu.PCDcatid" & numberformat(rsPCcubo2.PCCcolumna, '00')>
	</cfif>

	<cfif LvarTipoReporte EQ 1>
		<cfset PCDcatidrefFil = PCDcatidref1>
		<cfset PCDcatidrefCol = PCDcatidref2>
	<cfelse>
		<cfset PCDcatidrefFil = PCDcatidref1>
		<cfset PCDcatidrefCol = PCDcatidref1>
	</cfif>

	<!---
		Determinar las columnas del informe según los parámetros
		Si la columna está clasificada, se presenta en el informe agrupada por clasificacion y con encabezado
	--->
	
	<cfset LvarClasificacionColID = -1>
	<cfset LvarClasificacionColDes = "">
	
	<cfif LvarTipoReporte EQ 2>
		<cfquery name="rsColumnas" datasource="#session.dsn#">
			select 
				  Cmayor 										as Valor
				, Cmayor 										as ID
				, 'zzzzzzzzzzz9-' 								as CodigoClas
				, 'No Clasificado' 								as DescripcionClas
			from CtasMayor
			where Ecodigo = #session.Ecodigo#
			<cfif isdefined("LvarCtaMayor1")>
			  and Cmayor      >= '#LvarCtaMayor1#'
			</cfif>
			<cfif isdefined("LvarCtaMayor2")>
			  and Cmayor      <= '#LvarCtaMayor2#'
			</cfif>
			order by Cmayor
		</cfquery>
	<cfelse>
		<cfquery name="rsClasifica" datasource="#session.dsn#">
			select e.PCCEdescripcion, e.PCCEclaid 
			from PCEClasificacionCatalogo cc
				inner join PCClasificacionE e
				on e.PCCEclaid = cc.PCCEclaid
			<cfif LvarTipoReporte EQ 1>
			where cc.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCatalogo2#">
			<cfelse>
			where cc.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCatalogo1#">
			</cfif>
		</cfquery>
	
		<cfif rsClasifica.recordcount GT 0>
			<cfset LvarClasificacionColID   = rsClasifica.PCCEclaid>
			<cfset LvarClasificacionColDes = rsClasifica.PCCEdescripcion>
		</cfif>
	
		<cfquery name="rsColumnas" datasource="#session.dsn#">
			select 
				  c2.PCDvalor 										as Valor 
				, c2.PCDcatid 										as ID
				, coalesce(cc.PCCDvalor, 'N/A')			 			as CodigoClas
				, coalesce(cc.PCCDvalor, 'zzzzzzzzzzz9-') 			as OrdenClas
				, coalesce(cc.PCCDdescripcion, 'No Clasificado') 	as DescripcionClas
			from PCDCatalogo c2
				left outer join PCDClasificacionCatalogo cd
					inner join PCClasificacionD cc
					on cc.PCCDclaid = cd.PCCDclaid
				on  cd.PCCEclaid = #LvarClasificacionColID#
				and cd.PCDcatid = c2.PCDcatid
			<cfif LvarTipoReporte EQ 1>
			where c2.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCatalogo2#">
			<cfelse>
			where c2.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCatalogo1#">
			</cfif>
			  and (c2.Ecodigo is null or c2.Ecodigo = #session.Ecodigo#)
			order by OrdenClas, c2.PCDvalor
		</cfquery>
	</cfif>
	
	<cfset ValorColumna = arraynew(1)>
	<cfset TotalColumna = arraynew(1)>
	<cfset arrayset(ValorColumna, 1, 200, 0)>
	<cfset arrayset(TotalColumna, 1, 200, 0)>
	
	<cfset ColumnasReporteID = arraynew(1)>
	<cfset ColumnasReporteCodigoClas = arraynew(1)>
	<cfset ColumnasReporteValor = arraynew(1)>
	<cfset ColumnasReporteID[1] = -1>
	<cfset ColumnasReporteCodigoClas[1] = "">
	<cfset ColumnasReporteID[2] = -1>
	<cfset ColumnasReporteCodigoClas[2] = "">
	
	<cfset LvarColumnas = 2>
	<cfloop query="rsColumnas">
	
		<cfset LvarUsarColumna = true>

		<cfif LvarEliminarColCero>
			<cfif LvarTipoReporte NEQ 2>
				<cfquery name="rsUsarColumna" datasource="#session.dsn#">
					select sum(
						coalesce((
								select sum(s.SLinicial + s.DLdebitos - s.CLcreditos)
								from SaldosContables s
								where  s.Ccuenta	= cu.Ccuenta
								and s.Ecodigo		= cu.Ecodigo
								and s.Speriodo	    = #LvarPeriodo#
								and s.Smes		    = #LvarMes#
								#LvarOcodigo#
								and (s.SLinicial + s.DLdebitos - s.CLcreditos) <> 0
							), 0) 
						<cfif LvarSoloPeriodo>
							- coalesce((
								select sum(s.SLinicial)
								from SaldosContables s
								where  s.Ccuenta	= cu.Ccuenta
								and s.Ecodigo		= cu.Ecodigo
								and s.Speriodo		= #LvarPeriodoFiscal#
								and s.Smes			= #LvarPrimerMesFiscal#
								and s.SLinicial  <> 0
								#LvarOcodigo#
							), 0) 
						</cfif>
						) as Saldo
					from PCCuentaCubo cu
					where #PCDcatidrefcol#  = #rsColumnas.ID#
					  and cu.Ecodigo	    = #session.Ecodigo#
					<cfif isdefined("LvarCtaMayor1")>
					  and cu.Cmayor         >= '#LvarCtaMayor1#'
					</cfif>
					<cfif isdefined("LvarCtaMayor2")>
					  and cu.Cmayor         <= '#LvarCtaMayor2#'
					</cfif>
				</cfquery>
			<cfelse>
				<cfquery name="rsUsarColumna" datasource="#session.dsn#">
					select sum( 
						coalesce((
								select sum(s.SLinicial + s.DLdebitos - s.CLcreditos)
								from SaldosContables s
								where  s.Ccuenta	= cu.Ccuenta
								and s.Ecodigo		= cu.Ecodigo
								and s.Speriodo	    = #LvarPeriodo#
								and s.Smes		    = #LvarMes#
								#LvarOcodigo#
								and (s.SLinicial + s.DLdebitos - s.CLcreditos) <> 0
							), 0) 
						<cfif LvarSoloPeriodo>
							- coalesce((
								select sum(s.SLinicial)
								from SaldosContables s
								where  s.Ccuenta	= cu.Ccuenta
								and s.Ecodigo		= cu.Ecodigo
								and s.Speriodo		= #LvarPeriodoFiscal#
								and s.Smes			= #LvarPrimerMesFiscal#
								and s.SLinicial  <> 0
								#LvarOcodigo#
							), 0) 
						</cfif>
						) as Saldo
					from PCCuentaCubo cu
					where cu.Cmayor         = '#rsColumnas.ID#'
					  and cu.Ecodigo	    = #session.Ecodigo#
				</cfquery>
			</cfif>

			<cfif rsUsarColumna.recordcount LT 1 or len(trim(rsUsarColumna.Saldo)) eq 0 or rsUsarColumna.Saldo EQ 0>
				<cfset LvarUsarColumna = false>
			</cfif>
		</cfif>

		<cfif LvarUsarColumna>
			<cfset LvarColumnas = LvarColumnas + 1>
		
			<cfset ColumnasReporteCodigoClas[LvarColumnas]  = rsColumnas.CodigoClas>
			<cfset ColumnasReporteValor[LvarColumnas] = rsColumnas.Valor>
			<cfset ColumnasReporteID[LvarColumnas]    = rsColumnas.ID>
			
			<cfset ValorColumna[LvarColumnas] = 0.00>
			<cfset TotalColumna[LvarColumnas] = 0.00>
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="MatrizCatalogo_GenFilas" access="private" output="false">
	<!---
			Determinar las filas del informe.
			Si se tiene una clasificación definida, se ordena por la clasificación para mostrarla como cortes de control
	--->
	
	<cfset LvarClasificacion = "">
	<cfset LvarClasificacionFilID = -1>
	<cfif LvarTipoReporte NEQ 3>
		<cfquery name="rsClasifica" datasource="#session.dsn#">
			select e.PCCEdescripcion, e.PCCEclaid 
			from PCEClasificacionCatalogo cc
				inner join PCClasificacionE e
				on e.PCCEclaid = cc.PCCEclaid
			where cc.PCEcatid = #LvarCatalogo1#
		</cfquery>
	
		<cfif rsClasifica.recordcount GT 0>
			<cfset LvarClasificacion = "Clasificado por: #rsClasifica.PCCEdescripcion#">
			<cfset LvarClasificacionFilID = rsClasifica.PCCEclaid>
		</cfif>
	
		<cfquery name="rsFilas" datasource="#session.dsn#">
			select 
				  c1.PCDvalor 										as Fila 
				, c1.PCDdescripcion									as Descripcion
				, coalesce(cc.PCCDvalor, 'zzzzzzzzzzz9-') 			as CodigoClas
				, coalesce(cc.PCCDdescripcion, 'No Clasificado') 	as DescripcionClas
				, c1.PCDcatid										as ID
			from PCDCatalogo c1
				left outer join PCDClasificacionCatalogo cd
					inner join PCClasificacionD cc
					on cc.PCCDclaid = cd.PCCDclaid
				on cd.PCCEclaid = #LvarClasificacionFilID#
				and cd.PCDcatid = c1.PCDcatid
			where c1.PCEcatid    = #LvarCatalogo1#
			  and (c1.Ecodigo is null or c1.Ecodigo = #session.Ecodigo#)
			order by coalesce(cc.PCCDvalor, '99999999999'), c1.PCDvalor
		</cfquery>
	<cfelse>
		<cfquery name="rsFilas" datasource="#session.dsn#">
			select 
				  cm.Cmayor	 								as Fila 
				, cm.Cdescripcion							as Descripcion
				, 'zzzzzzzzzzz9-'							as CodigoClas
				, ' '										as DescripcionClas
				, cm.Cmayor									as ID
			from CtasMayor cm
			where cm.Ecodigo = #session.Ecodigo#
			<cfif isdefined("LvarCtaMayor1")>
			  and cm.Cmayor      >= '#LvarCtaMayor1#'
			</cfif>
			<cfif isdefined("LvarCtaMayor2")>
			  and cm.Cmayor      <= '#LvarCtaMayor2#'
			</cfif>
			order by cm.Cmayor
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="ObtieneFilaCatalogo" returntype="query" output="false">
	<cfargument name="Fila" type="numeric" required="yes">

	<cfif LvarTipoReporte EQ 1>
		<cfquery name="rsResultado" datasource="#session.dsn#">
			select Columna, sum(Saldo) as Saldo
			from 
			(
				select 
					#PCDcatidrefCol#		as Columna,
					cu.Ccuenta				as Cuenta,
					coalesce((
						select 
								sum( (s.SLinicial + s.DLdebitos - s.CLcreditos) #LvarPorcentaje# )
								from SaldosContables s
								where s.Ccuenta			= cu.Ccuenta
								  and s.Ecodigo			= cu.Ecodigo 	
								  and s.Speriodo		= #LvarPeriodo#
								  and s.Smes			= #LvarMes#
								  #LvarOcodigo#
						), 0)
					<cfif LvarSoloPeriodo>
						- coalesce((
							select 
								sum( s.SLinicial  #LvarPorcentaje# )
								from SaldosContables s
								where s.Ccuenta			= cu.Ccuenta
								  and s.Ecodigo			= cu.Ecodigo 	
								  and s.Speriodo		= #LvarPeriodoFiscal#
								  and s.Smes			= #LvarPrimerMesFiscal#
								  #LvarOcodigo#
						), 0)
					</cfif>
					as Saldo
				from PCCuentaCubo cu
				where #PCDcatidrefFil# 	= #Arguments.Fila#
				  and cu.Ecodigo      	= #session.Ecodigo#
				<cfif isdefined("LvarCtaMayor1")>
				  and cu.Cmayor      >= '#LvarCtaMayor1#'
				</cfif>
				<cfif isdefined("LvarCtaMayor2")>
				  and cu.Cmayor      <= '#LvarCtaMayor2#'
				</cfif>
				  and #PCDcatidrefCol# is not null
			) as Tabla
			group by Columna
		</cfquery>
	<cfelse>
		<cfquery name="rsResultado" datasource="#session.dsn#">
			select Columna, sum(Saldo) as Saldo
			from 
			(
				select 
					cu.Cmayor 		as Columna,
					cu.Ccuenta		as Cuenta,
					coalesce((
							select 
								sum( (s.SLinicial + s.DLdebitos - s.CLcreditos) #LvarPorcentaje# )
								from SaldosContables s
								where s.Ccuenta			= cu.Ccuenta
								  and s.Ecodigo			= cu.Ecodigo 	
								  and s.Speriodo		= #LvarPeriodo#
								  and s.Smes			= #LvarMes#
								  #LvarOcodigo#
						), 0)
					<cfif LvarSoloPeriodo>
						- coalesce((
							select 
								sum( s.SLinicial  #LvarPorcentaje# )
								from SaldosContables s
								where s.Ccuenta			= cu.Ccuenta
								  and s.Ecodigo			= cu.Ecodigo 	
								  and s.Speriodo		= #LvarPeriodoFiscal#
								  and s.Smes			= #LvarPrimerMesFiscal#
								  #LvarOcodigo#
						), 0)
					</cfif>
					 as Saldo
				from PCCuentaCubo cu
				where #PCDcatidrefFil# 	= #Arguments.Fila#
				  and cu.Ecodigo      	= #session.Ecodigo#
				<cfif isdefined("LvarCtaMayor1")>
				  and cu.Cmayor      >= '#LvarCtaMayor1#'
				</cfif>
				<cfif isdefined("LvarCtaMayor2")>
				  and cu.Cmayor      <= '#LvarCtaMayor2#'
				</cfif>
			) as Tabla
			group by Columna
		</cfquery>
	</cfif>
	<cfreturn rsResultado>
</cffunction>

<cffunction name="ObtieneFilaCuenta" returntype="query" output="false">
	<cfargument name="Fila" type="string" required="yes">
	<cfquery name="rsResultado" datasource="#session.dsn#">
		select Columna, sum(Saldo) as Saldo
		from 
		(
			select 
				#PCDcatidrefCol#	as Columna,
				coalesce((
						select 
							sum( (s.SLinicial + s.DLdebitos - s.CLcreditos) #LvarPorcentaje# )
							from SaldosContables s
							where s.Ccuenta			= cu.Ccuenta
							  and s.Ecodigo			= cu.Ecodigo 	
							  and s.Speriodo		= #LvarPeriodo#
							  and s.Smes			= #LvarMes#
							  #LvarOcodigo#
					), 0)
				<cfif LvarSoloPeriodo>
					- coalesce((
						select 
							sum( s.SLinicial  #LvarPorcentaje# )
							from SaldosContables s
							where s.Ccuenta			= cu.Ccuenta
							  and s.Ecodigo			= cu.Ecodigo 	
							  and s.Speriodo		= #LvarPeriodoFiscal#
							  and s.Smes			= #LvarPrimerMesFiscal#
							  #LvarOcodigo#
					), 0)
				</cfif>
				as Saldo
			from PCCuentaCubo cu
			where cu.Cmayor		= '#Arguments.Fila#'
			  and cu.Ecodigo	= #session.Ecodigo#
			  and #PCDcatidrefCol# is not null
		) as Tabla
		group by Columna
	</cfquery>
	<cfreturn rsResultado>
</cffunction>

<cffunction name="ObtieneNombreCatalogo" returntype="string" output="false">
	<cfargument name="PCEcatid" type="numeric" required="yes">
	<cfargument name="Ubicacion" type="string" required="yes">

	<cfset LvarNombreCatalogo = "">
	<cfset LvarPosicion = 0>

	<cfquery name="rsCatalogos" datasource="#session.dsn#">
		select cat.PCEcatid, cat.PCEcodigo, cat.PCEdescripcion
		from PCECatalogo cat
		where cat.PCEcatid = #arguments.PCEcatid#
	</cfquery>

	<cfset LvarNombreCatalogo = rsCatalogos.PCEdescripcion>

	<cfif lcase(arguments.ubicacion) EQ 'titulo'>
		<cfset LvarPosicionParentesis = find("(", LvarNombreCatalogo, 7)>
		<cfif LvarPosicionParentesis GT 7>
			<cfset LvarNombreCatalogo = left(LvarNombreCatalogo, LvarPosicionParentesis - 1)>
		</cfif>
	</cfif>

	<cfif lcase(arguments.ubicacion) EQ 'columna'>
		<cfset LvarPosicionParentesis = find("(", LvarNombreCatalogo, 2)>
		<cfset LvarPosicionEspacio    = find(" ", LvarNombreCatalogo, 2)>
		<cfif LvarPosicionParentesis GT 5>
			<cfif LvarPosicionParentesis GT LvarPosicionEspacio >
				<cfset LvarPosicion = LvarPosicionEspacio - 1>
			<cfelse>
				<cfset LvarPosicion = LvarPosicionParentesis - 1>
			</cfif>
		<cfelseif LvarPosicionEspacio GT 5>
				<cfset LvarPosicion = LvarPosicionEspacio - 1>
		</cfif>
		<cfif LvarPosicion GT 4>
			<cfset LvarNombreCatalogo = trim(left(LvarNombreCatalogo, LvarPosicion))>
		</cfif>
	</cfif>
	<cfreturn '#LvarNombreCatalogo#'>
</cffunction>

<cffunction name="ObtieneNombreMes" access="private" output="false" returntype="string">
	<cfargument name="NumeroMes" type="numeric" required="yes">

	<cfset LvarNombreDelMes = numberformat(Arguments.Numeromes, "00")>

	<cfquery name="rsNombreMes" datasource="sifcontrol">
		select vs.VSdesc as Mes
		from Idiomas i, VSidioma vs 
		where i.Icodigo = '#session.idioma#'
		  and vs.VSgrupo = 1
		  and vs.Iid = i.Iid
		  and vs.VSvalor = '#Arguments.NumeroMes#'
	</cfquery>
	
	<cfif rsNombreMes.recordcount EQ 1>
		<cfset LvarNombreDelMes = rsNombreMes.Mes>
	<cfelse>
		<cfswitch expression="#Arguments.NumeroMes#">

			<cfcase value=1>
				<cfset LvarNombreDelmes = 'Enero'>
			</cfcase>

			<cfcase value=2>
				<cfset LvarNombreDelmes = 'Febrero'>
			</cfcase>

			<cfcase value=3>
				<cfset LvarNombreDelmes = 'Marzo'>
			</cfcase>

			<cfcase value=4>
				<cfset LvarNombreDelmes = 'Abril'>
			</cfcase>

			<cfcase value=5>
				<cfset LvarNombreDelmes = 'Mayo'>
			</cfcase>

			<cfcase value=6>
				<cfset LvarNombreDelmes = 'Junio'>
			</cfcase>

			<cfcase value=7>
				<cfset LvarNombreDelmes = 'Julio'>
			</cfcase>

			<cfcase value=8>
				<cfset LvarNombreDelmes = 'Agosto'>
			</cfcase>

			<cfcase value=9>
				<cfset LvarNombreDelmes = 'Septiembre'>
			</cfcase>

			<cfcase value=10>
				<cfset LvarNombreDelmes = 'Octubre'>
			</cfcase>

			<cfcase value=11>
				<cfset LvarNombreDelmes = 'Noviembre'>
			</cfcase>

			<cfcase value=12>
				<cfset LvarNombreDelmes = 'Diciembre'>
			</cfcase>
		</cfswitch>
	</cfif>
	<cfreturn "#LvarNombreDelmes#">
</cffunction>

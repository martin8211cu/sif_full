<!---<cf_templateheader title="LB_RecursosHumanos">--->
<!---<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="LB_RegistroDeCargasObreroPatronales">--->

<!--- 0. Path del centro funcional, si se muestra dependencias, y si se selecciono centro funcional --->
<cfif isdefined("url.CFid") and len(trim(url.CFid)) >
	<cfquery name="rs_path" datasource="#session.DSN#">
		select CFcodigo, CFdescripcion, CFpath as path
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
	</cfquery>
</cfif>

<!--- 1. Creacion y llenado de tabla de periodos y meses a ser consultados --->
<!--- 1.1 creacion tabla de periodos a ser consultados (de momento 4 años, hacia atras del periodo en curso) --->
<cf_dbtemp name="tbl_principal" returnvariable="tbl_principal">
	<cf_dbtempcol name="periodo" 				type="int"  mandatory="yes">
	<cf_dbtempcol name="mes" 					type="int"  mandatory="yes">
	<cf_dbtempcol name="total_empleados"		type="float"	mandatory="yes">
	<cf_dbtempcol name="total_ingresos"			type="float"	mandatory="yes">
	<cf_dbtempcol name="total_renuncias"		type="float"	mandatory="yes">
	<cf_dbtempcol name="total_despidos"			type="float"	mandatory="yes">
</cf_dbtemp>
<!--- 1.1 llenado de la tabla --->
<cfloop from="#year(now())-3#" to="#year(now())#" index="p">
	<cfloop from="1" to="12" index="m">
		<!--- 1.1.1 calculo total empleados al inicio de cada mes  --->
		<cfquery datasource="#session.DSN#" name="rs_total">
			select coalesce(count(1), 0) as empleados
			from LineaTiempo lt			
				inner join RHPlazas p
					on p.RHPid=lt.RHPid
				inner join CFuncional cf
					on cf.CFid=p.CFid
				<cfif isdefined("url.CFid") and len(trim(url.CFid))>
					and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
					<cfif isdefined("url.dependencias")>
						or cf.CFpath like '#rs_path.path#%'
					</cfif>
					)
				</cfif>
			where <cfqueryparam cfsqltype="cf_sql_date" value="#dateadd('d', -1, createdate(p,m,1))#"> between lt.LTdesde and lt.LThasta
		</cfquery>	
		
		<!--- 1.1.2 calculo de ingresos para periodo/mes en proceso --->		
		<cfquery datasource="#session.DSN#" name="rs_ingresos">
			select coalesce(count(1), 0) as cantidad
			from DLaboralesEmpleado a
				inner join RHPlazas p
					on p.RHPid=a.RHPid
				inner join CFuncional cf
					on cf.CFid=p.CFid
				<cfif isdefined("url.CFid") and len(trim(url.CFid))>
					and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
					<cfif isdefined("url.dependencias")>
						or cf.CFpath like '#rs_path.path#%'
					</cfif>
					)
				</cfif>
			where RHTid in (	select RHIDllave
								from RHIndicadoresDetalle
								where RHIDtipo='A' 	
								  and RHIcodigo=5 )	<!--- indicador de ingresos --->
			  and <cf_dbfunction name="date_part"   args="YY,a.DLfvigencia"> = <cfqueryparam cfsqltype="cf_sql_integer" value="#p#">
			  and <cf_dbfunction name="date_part"   args="MM,a.DLfvigencia"> = <cfqueryparam cfsqltype="cf_sql_integer" value="#m#">
		</cfquery>

		<!--- 1.1.3 calculo de renuncias para periodo/mes en proceso --->		
		<cfquery datasource="#session.DSN#" name="rs_renuncias">
			select coalesce(count(1), 0) as cantidad
			from DLaboralesEmpleado a
				inner join RHPlazas p
					on p.RHPid=a.RHPid
				inner join CFuncional cf
					on cf.CFid=p.CFid
				<cfif isdefined("url.CFid") and len(trim(url.CFid))>
					and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
					<cfif isdefined("url.dependencias")>
						or cf.CFpath like '#rs_path.path#%'
					</cfif>
					)
				</cfif>
			where RHTid in (	select RHIDllave
								from RHIndicadoresDetalle
								where RHIDtipo = 'A' 	
								  and RHIcodigo = 15 )	<!--- indicador de renuncias --->
			  and <cf_dbfunction name="date_part"   args="YY,a.DLfvigencia"> = <cfqueryparam cfsqltype="cf_sql_integer" value="#p#">			  
			  and <cf_dbfunction name="date_part"   args="MM,a.DLfvigencia"> = <cfqueryparam cfsqltype="cf_sql_integer" value="#m#">
		</cfquery>

		<!--- 1.1.4 calculo de despidos para periodo/mes en proceso --->		
		<cfquery datasource="#session.DSN#" name="rs_despidos">
			select coalesce(count(1), 0) as cantidad
			from DLaboralesEmpleado a
				inner join RHPlazas p
					on p.RHPid=a.RHPid
				inner join CFuncional cf
					on cf.CFid=p.CFid
				<cfif isdefined("url.CFid") and len(trim(url.CFid))>
					and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
					<cfif isdefined("url.dependencias")>
						or cf.CFpath like '#rs_path.path#%'
					</cfif>
					)
				</cfif>
			where RHTid in (	select RHIDllave
								from RHIndicadoresDetalle
								where RHIDtipo='A' 	
								  and RHIcodigo = 20 )	<!--- indicador de despidos --->
			  and <cf_dbfunction name="date_part"   args="YY,a.DLfvigencia"> = <cfqueryparam cfsqltype="cf_sql_integer" value="#p#">
			  and <cf_dbfunction name="date_part"   args="MM,a.DLfvigencia"> = <cfqueryparam cfsqltype="cf_sql_integer" value="#m#">
		</cfquery>

		<!--- inserta la tabla principal --->
		<cfquery datasource="#session.DSN#">
			insert into #tbl_principal#(periodo, mes, total_empleados, total_ingresos, total_renuncias, total_despidos)
			values (#p#, 
					#m#, 
					<cfqueryparam cfsqltype="cf_sql_float" value="#rs_total.empleados#">, 
					<cfqueryparam cfsqltype="cf_sql_float" value="#rs_ingresos.cantidad#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#rs_renuncias.cantidad#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#rs_despidos.cantidad#"> )
		</cfquery>
	</cfloop>
</cfloop>

<!--- 3. Creacion y llenado de tabla de resumen por periodo --->
<!--- 3.1 creacion tabla de resumen de periodo (se basa en la tabla de 1) --->
<cf_dbtemp name="tbl_periodo" returnvariable="tbl_periodo">
	<cf_dbtempcol name="periodo" type="int"  mandatory="yes">
</cf_dbtemp>

<!--- 3.1 Llenado de tabla --->
<cfquery datasource="#session.DSN#">
	insert into #tbl_periodo#(periodo)
	select distinct	periodo
	from #tbl_principal#
</cfquery>

<cfquery name="rs" datasource="#session.DSN#">
	select periodo, mes, total_empleados, total_ingresos, total_renuncias, total_despidos
	from  #tbl_principal#
	order by periodo, mes
</cfquery>

<cfquery name="rs2" datasource="#session.DSN#">
	select distinct periodo
	from  #tbl_principal#
	order by periodo
</cfquery>

<cfquery name="rs3" dbtype="query">
	select total_empleados
	from  rs
	where periodo= #year(now())-3#
	and mes = 1
</cfquery>

<cfsavecontent variable="data_xml_new" >
	<data>
		<cfoutput><variable name="#xmlformat('EmpleadosInicial')#"></cfoutput>
		<row><column><cfoutput>#xmlformat(rs3.total_empleados)#</cfoutput></column></row>
		</variable>

		<cfoutput><variable name="#xmlformat('DatosPeriodoMes')#"></cfoutput>
		<cfoutput query="rs">
		<row>
			<column>#xmlformat(rs.periodo)#</column>
			<column>#xmlformat(rs.mes)#</column>
			<column>#xmlformat(rs.total_ingresos)#</column>
			<column>#xmlformat(rs.total_renuncias)#</column>
			<column>#xmlformat(rs.total_despidos)#</column>
		</row>
		</cfoutput>
		</variable>

		<cfoutput><variable name="#xmlformat('DatosPeriodo')#"></cfoutput>
		<cfoutput query="rs2">
		<row><column>#xmlformat(rs2.periodo)#</column></row>
		</cfoutput>
		</variable>
		
		<cfif isdefined("rs_path") and rs_path.recordcount gt 0>
			<cfoutput><variable name="#xmlformat('DatosCFuncional')#"></cfoutput>
			<cfoutput query="rs_path">
			<row><column>#xmlformat(trim('Centro Funcional:'))# #xmlformat(trim(rs_path.CFcodigo))#-#xmlformat(rs_path.CFdescripcion)#</column></row>
			</cfoutput>
			</variable>
		</cfif>
	</data>
</cfsavecontent>

	<cfif isdefined("url.detalle")>
		<cfset parametrosr = "">
		<cfif isdefined("url.CFid") and len(trim(url.CFid))>
			<cfset parametrosr= parametrosr & "&CFid=#url.CFid#"> 
		</cfif>
		<cfif isdefined("url.dependencias")>
			<cfset parametrosr= parametrosr & "&dependencias=#url.dependencias#"> 
		</cfif>
		<cf_htmlReportsHeaders 
			irA="tasa-rotacion.cfm"
			FileName="tasaRotacion.xls"			
			title="Tasa de Rotacion de Personal"
			param="#parametrosr#">
		<script type="text/javascript" language="javascript1.2">
			function fnImgBack(){
				<cfoutput>location.href = 'tasa-rotacion.cfm?1=1'+'#parametrosr#';</cfoutput>
			}
		</script>

		<cfinvoke Key="LB_Tasa_de_Rotacion_de_Personal" Default="Tasa de Rotaci&oacute;n de Personal" returnvariable="LB_IndRotacion" component="sif.Componentes.Translate" method="Translate"/>
		<style>
			.borde{
				border-right:1px solid black;
				border-bottom:1px solid black;
			}
		</style>
		
		<cfquery name="rs_idiomas" datasource="#session.DSN#">
			select <cf_dbfunction name="to_number" args="b.VSvalor"> as v, VSdesc as m
			from Idiomas a
				inner join VSidioma b
				on b.Iid = a.Iid
				and b.VSgrupo = 1
			where Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.idioma#">
			order by <cf_dbfunction name="to_number" args="b.VSvalor">			
		</cfquery>
		<cfset lista_meses = valuelist(rs_idiomas.m) >
		<cfif listlen(lista_meses) neq 12 >
			<cfset lista_meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre' >
		</cfif>

		<table width="80%" align="center" cellpadding="1" cellspacing="0">
			<tr>
				<td colspan="6" align="center"><strong style="font-size:16px; font-variant:small-caps;"><cf_translate key="LB_DetalleDeTasaDeRotacionDePersonal">Detalle de Tasa de Rotaci&oacute;n de Personal</cf_translate></strong></td>			
			</tr>
			<tr><td>&nbsp;</td></tr>

			<tr style="background-color:#FFFFCC;">
				<td width="12%"><strong><cf_translate key="LB_Mes">Mes</cf_translate></strong></td>
				<td width="19%"><strong><cf_translate key="LB_CantEmpleados">Cant. Empleados</cf_translate></strong></td>
				<td width="19%" align="center"><strong><cf_translate key="LB_Ingresos">Ingresos</cf_translate></strong></td>
				<td width="18%" align="center"><strong><cf_translate key="LB_Renuncias">Renuncias</cf_translate></strong></td>
				<td width="16%" align="right"><strong><cf_translate key="LB_Despidos">Despidos</cf_translate></strong></td>
				<td width="16%" align="right"><strong><cf_translate key="LB_TotalSalidas">Total Salidas</cf_translate></strong></td>
			</tr>

			<cfoutput query="rs" group="periodo">
				<tr style="background-color:##F1F1F1"><td colspan="6" style=" border-bottom:1px solid black;">
					<strong><cf_translate key="LB_Periodo">Periodo</cf_translate>:&nbsp;#periodo#</strong>
				</td></tr>
				<cfoutput>
					<tr>
						<td class="borde" style="border-left:1px solid black;">#listgetat(lista_meses, rs.mes)#</td>
						<td class="borde" align="right">#total_empleados#</td>
						<td class="borde" align="right">#xmlformat(rs.total_ingresos)#</td>
						<td class="borde" align="right">#xmlformat(rs.total_renuncias)#</td>
						<td class="borde" align="right">#xmlformat(rs.total_despidos)#</td>
						<td class="borde" align="right">#xmlformat(rs.total_despidos+rs.total_renuncias)#</td>
					</tr>
				</cfoutput>
			</cfoutput>
		</table>
	<cfelse>
		<!--- 
			El nombre del archivo XML debe ser unico, formado con la combinación de llaves que hacen a la informacion unica,
			para que todos los usuarios que ven el archivo con la misma combinación de llaves vean la misma informacion
			En este caso la combinacion es el IdEmpleado con el IdPuesto
		--->
		<cfset irA = "">
		<cfif isdefined("url.CFid") and len(trim(url.CFid))>
			<cfset irA = irA & "&CFid=#url.CFid#">
		</cfif>
		<cfif isdefined("url.dependencias")>
			<cfset irA = irA & "&dependencias=#url.dependencias#">
		</cfif>
		<cfoutput>
		<cf_viewFlash 
			movie = "rotacion" 
			XMLfilename = "Rotacion2008_#session.Usucodigo#" 
			XMLvalue = "#data_xml_new#"
			path = "rh/indicadores/rotacion"
			irA="/cfmx/rh/indicadores/rotacion/tasa-rotacion.cfm?detalle=true#irA#" >
		</cfoutput>
	</cfif>		

	    <!---            <cf_web_portlet_end>--->
<!---<cf_templatefooter>--->
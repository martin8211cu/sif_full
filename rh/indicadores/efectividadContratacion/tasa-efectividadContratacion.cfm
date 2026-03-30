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
	<cf_dbtempcol name="periodo" 				type="int"  	mandatory="yes">
	<cf_dbtempcol name="mes" 					type="int"  	mandatory="yes">
	<cf_dbtempcol name="total_contrataciones"	type="float"	mandatory="yes">
	<cf_dbtempcol name="total_salidas_prueba"	type="float"	mandatory="yes">
</cf_dbtemp>

<cf_dbtemp name="tbl_datos" returnvariable="tbl_datos">
	<cf_dbtempcol name="DEid" 				type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="desde" 				type="datetime"	mandatory="yes">
	<cf_dbtempcol name="hasta" 				type="datetime"	mandatory="yes">
	<cf_dbtempcol name="periodo_ingreso"	type="int"  	mandatory="yes">
	<cf_dbtempcol name="mes_ingreso" 		type="int"  	mandatory="yes">
	<cf_dbtempcol name="en_firme" 			type="int"  	mandatory="no">
	<cf_dbtempcol name="periodo_salida" 	type="int"  	mandatory="yes">
	<cf_dbtempcol name="mes_salida" 		type="int"  	mandatory="yes">
</cf_dbtemp>

<!--- 1.1 llenado de la tabla --->
<cfloop from="#year(now())-3#" to="#year(now())#" index="p">
	<cfloop from="1" to="12" index="m">
		<!--- inserta la tabla principal --->
		<cfquery datasource="#session.DSN#">
			insert into #tbl_principal#(periodo, mes, total_contrataciones, total_salidas_prueba)
			values (#p#, #m#, 0, 0 )
		</cfquery>
	</cfloop>
</cfloop>

<!--- 3. Creacion y llenado de tabla de resumen por periodo --->
<!--- 3.1 creacion tabla de resumen de periodo (se basa en la tabla de 1) --->
<cf_dbtemp name="tbl_periodo" returnvariable="tbl_periodo">
	<cf_dbtempcol name="periodo" type="int" mandatory="yes">
</cf_dbtemp>
<!---  Llenado de tabla --->
<cfquery datasource="#session.DSN#">
	insert into #tbl_periodo#(periodo)
	select distinct	periodo
	from #tbl_principal#
	where periodo >= #year(now())-3#
</cfquery>

<!--- 3.2  Llenado de la tabla de datos de contrataciones --->
<cfset fecha_inicio = createdate(year(now())-4,6,1)  >
<cfset fecha_fin = createdate(year(now()),12,31)  >
<cfquery datasource="#session.DSN#" name="d">
	insert into #tbl_datos#(DEid, desde, hasta, periodo_ingreso, mes_ingreso, periodo_salida, mes_salida)
	select lt.DEid, 
		 lt.LTdesde, 
		 lt.LThasta, 
		 <cf_dbfunction name="date_part"   args="YY,lt.LTdesde"> as periodo_ingreso,
		 <cf_dbfunction name="date_part"   args="MM,lt.LTdesde"> as mes_ingreso,
		 <cf_dbfunction name="date_part"   args="YY,lt.LThasta"> as periodo_salida, 
		 <cf_dbfunction name="date_part"   args="MM,lt.LThasta"> as mes_salida	
	from LineaTiempo lt
		inner join RHIndicadoresDetalle i
			on i.RHIDllave = lt.RHTid
			and i.RHIcodigo = 45
	  		and i.RHIDtipo='A'
		<cfif isdefined("url.CFid") and len(trim(url.CFid))>
			inner join RHPlazas p
				on p.RHPid=lt.RHPid				
			inner join CFuncional cf
				on cf.CFid=p.CFid						
				and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
						<cfif isdefined("url.dependencias")>
							or cf.CFpath like '#rs_path.path#%'
						</cfif>
					)
		</cfif>			
	where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and lt.LTdesde = (	select min(lt2.LTdesde)
							from LineaTiempo lt2, RHTipoAccion ta2
							where lt2.DEid=lt.DEid	
							  and ta2.RHTid=i.RHIDllave	
							  and ta2.RHTcomportam=1
							  and ta2.RHTpfijo=1 )
		<!--- poner rango de tiempo de los 4 años y un unos 6 meses antes del año primero --->
		and <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_fin#"> >= lt.LTdesde
		and <cfqueryparam cfsqltype="cf_sql_date" value="#fecha_inicio#"> <= lt.LThasta
	order by lt.DEid
</cfquery>

<cfquery datasource="#session.DSN#">
	update #tbl_datos#
	set en_firme = 	(coalesce((	select min(1) 
								from LineaTiempo lt, RHTipoAccion ta
								where lt.DEid=#tbl_datos#.DEid
									and ta.RHTid=lt.RHTid
									and ta.RHTcomportam = 1
									and lt.LTdesde > #tbl_datos#.hasta
									and abs(<cf_dbfunction name="datediff" args="lt.LTdesde, #tbl_datos#.hasta">) between 0 and 30), 0))
</cfquery>

<cfquery datasource="#session.DSN#">
	update #tbl_principal#
	set total_contrataciones = (	select count(1)
									from #tbl_datos#
									where periodo_ingreso = #tbl_principal#.periodo 
										and mes_ingreso = #tbl_principal#.mes 
								),
		total_salidas_prueba = ( 	select count(1)
									from #tbl_datos#
									where en_firme = 0
										and periodo_salida = #tbl_principal#.periodo 
										and mes_salida = #tbl_principal#.mes 
								)

</cfquery>

<cfquery name="rs" datasource="#session.DSN#">
	select periodo, mes, total_contrataciones, total_salidas_prueba
	from #tbl_principal#
	order by periodo, mes 
</cfquery>

<cfquery name="rs2" datasource="#session.DSN#">
	select distinct periodo
	from  #tbl_principal#
	order by periodo
</cfquery>

<cfset lista_meses = 'ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SET,OCT,NOV,DIC' >

<cfsavecontent variable="data_xml_new" >
	<data>
		<cfoutput><variable name="#xmlformat('DatosPeriodoMes')#"></cfoutput>
		<cfoutput query="rs">
		<row>
			<column>#xmlformat(rs.periodo)#</column>
			<column>#xmlformat(listgetat(lista_meses,rs.mes))#</column>
			<column><cfif rs.total_contrataciones gt 0>#xmlformat(rs.total_contrataciones)#<cfelse>#xmlformat('0.000001')#</cfif></column>
			<column>#xmlformat(rs.total_salidas_prueba)#</column>
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
		<cfinvoke Key="LB_Tasa_de_Efectividad_de_Contratacion" Default="Tasa de Efectividad de Contrataci&oacute;n" returnvariable="LB_IndEfectividad" component="sif.Componentes.Translate" method="Translate"/>
		<cfset parametrosr = "">
		<cfif isdefined("url.CFid") and len(trim(url.CFid))>
			<cfset parametrosr= parametrosr & "&CFid=#url.CFid#"> 
		</cfif>
		<cfif isdefined("url.dependencias")>
			<cfset parametrosr= parametrosr & "&dependencias=#url.dependencias#"> 
		</cfif>
		<cf_htmlReportsHeaders 
			irA="tasa-efectividadContratacion.cfm"
			FileName="tasaefectividadContratacion.xls"
			method="url"
			title="#LB_IndEfectividad#"
			param="#parametrosr#">
		<script type="text/javascript" language="javascript1.2">
			function fnImgBack(){
				<cfoutput>location.href = 'tasa-efectividadContratacion.cfm?1=1'+'#parametrosr#';</cfoutput>
			}
		</script>
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
				<td colspan="3" align="center"><strong style="font-size:16px; font-variant:small-caps;"><cf_translate key="LB_DetalleDeTasaDeEfectividadDeContratacion">Detalle de Tasa de Efectividad de Contrataci&oacute;n</cf_translate></strong></td>			
			</tr>
			<tr><td>&nbsp;</td></tr>

			<tr style="background-color:#FFFFCC;">
				<td width="12%"><strong><cf_translate key="LB_Mes">Mes</cf_translate></strong></td>
				<td width="19%" align="center"><strong><cf_translate key="LB_TotalContrataciones">Total de Contrataciones</cf_translate></strong></td>
				<td width="16%" align="right"><strong><cf_translate key="LB_TotalSalidasEnPeriodoDePrueba">Total Salidas en per&iacute;odo de prueba</cf_translate></strong></td>
			</tr>

			<cfoutput query="rs" group="periodo">
				<tr style="background-color:##F1F1F1"><td colspan="3" style=" border-bottom:1px solid black;">
					<strong><cf_translate key="LB_Periodo">Periodo</cf_translate>:&nbsp;#rs.periodo#</strong>
				</td></tr>
				<cfoutput>
					<tr>
						<td class="borde" style="border-left:1px solid black;">#listgetat(lista_meses, rs.mes)#</td>
						<td class="borde" align="right">#rs.total_contrataciones#</td>
						<td class="borde" align="right">#xmlformat(rs.total_salidas_prueba)#</td>
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
				movie = "efectividad" 
				XMLfilename = "efectividad2008_#session.Usucodigo#" 
				XMLvalue = "#data_xml_new#"
				path = "rh/indicadores/efectividadContratacion" 
				irA="/cfmx/rh/indicadores/efectividadContratacion/tasa-efectividadContratacion.cfm?detalle=true#irA#" >
		</cfoutput>
	</cfif>
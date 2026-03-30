<cfcomponent>
	<!---Pregfijo de las tablas para saber si se van a consultar las tablas historicas o las que estan en proceso.--->
	<cfset pref = ''>

	<!--- VARIABLES DE TRADUCCION --->
	<cfinvoke key="LB_Boleta_Pago" 	default="Boleta de Pago" returnvariable="LB_Boleta" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" />
	<cfinvoke key="LB_SalarioBruto" default="Salario Bruto" returnvariable="LB_SalarioBruto" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" />
	<cfinvoke key="LB_Retroactivos" default="RETROACTIVOS" returnvariable="LB_Retroactivos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" />
	<!---Obtener Pais para la etiqueta de renta----->
	<cfquery name="rsPais" datasource="#session.DSN#">
		select Pvalor from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 2020
	</cfquery>
	<cfif trim(rsPais.Pvalor) EQ 'RH_CalculoNominaRentaMEX.cfc'>
		<cfinvoke key="LB_Renta" 		default="ISPT" returnvariable="LB_Renta" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" />
	<cfelse>
		<cfinvoke key="LB_Renta" 		default="Renta" returnvariable="LB_Renta" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" />
	</cfif>
	<cfinvoke key="LB_GenerarArchivoTexto" default="Generar archivo de texto" returnvariable="LB_GenerarArchivoTexto" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" />
	<!--- FIN VARIABLES DE TRADUCCION --->

	<!---Obtener cual formato de boleta se esta usando----->
	<cfquery name="rsParametro" datasource="#session.DSN#">
		select coalesce(Pvalor,'10') as Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 720
	</cfquery>

	<!-----==========================================================================================--->
	<!----==================================== CONSULTAS  ==========================================---->
	<!-----==========================================================================================--->
	<!----TABLA TEMPORAL DE TRABAJO---->
	<cf_dbtemp name="BTEMPConceptosv1" returnvariable="TMPConceptos" datasource="#session.DSN#">
	   <cf_dbtempcol name="DEid"			type="numeric"  mandatory="yes">
	   <cf_dbtempcol name="RCNid"			type="numeric"  mandatory="yes">
	   <cf_dbtempcol name="descconcepto"	type="varchar(255)"	mandatory="no">
	   <cf_dbtempcol name="cantconcepto"   	type="varchar(50)"	mandatory="no">
	   <cf_dbtempcol name="montoconcepto"   type="money"	mandatory="no">
	   <cf_dbtempcol name="pagina"          type="int"	    mandatory="no">
	   <cf_dbtempcol name="linea"           type="int"		mandatory="no">
	   <cf_dbtempcol name="columna"         type="int"		mandatory="no">
	   <cf_dbtempcol name="descconceptoB"	type="varchar(255)"	mandatory="no">
	   <cf_dbtempcol name="cantconceptoB"   type="varchar(50)"	mandatory="no">
	   <cf_dbtempcol name="montoconceptoB"  type="money"	mandatory="no">

	   <cf_dbtempcol name="nomina"  		type="varchar(100)"	mandatory="no">
	   <cf_dbtempcol name="desdenomina"  	type="datetime"	mandatory="no">
	   <cf_dbtempcol name="hastanomina"  	type="datetime"	mandatory="no">
	   <cf_dbtempcol name="empleado"  		type="varchar(255)"	mandatory="no">
	   <cf_dbtempcol name="cuenta"  		type="varchar(100)"	mandatory="no">
	   <cf_dbtempcol name="EtiquetaCuenta"  type="varchar(100)"	mandatory="no">
	   <cf_dbtempcol name="departamento"  	type="varchar(150)"	mandatory="no">
	   <cf_dbtempcol name="puntoventa"  	type="varchar(255)"	mandatory="no">
	   <cf_dbtempcol name="devengado"  		type="money"	mandatory="no">
	   <cf_dbtempcol name="deducido"  		type="money"	mandatory="no">
	   <cf_dbtempcol name="neto"  			type="money"	mandatory="no">

	   <cf_dbtempcol name="orden"         	type="int"		mandatory="no">
	   <cf_dbtempcol name="lineasEmp"       type="int"		mandatory="no">

	   <cf_dbtempcol name="incidencia"       type="int"		mandatory="no">
	   <cf_dbtempcol name="especie"          type="int"		mandatory="no">
	   <cf_dbtempcol name="resumeCargas"     type="int"		mandatory="no">
	   <!---indica si las cargas se muestran de forma resumida o no. CarolRS--->
	   <cf_dbtempcol name="resumeCargasDesc" type="varchar(100)" mandatory="no">
	   <!---en caso de que la impresion de la boleta se haga de forma resumida se debe mostrar esta descripcion.--->
	</cf_dbtemp>

	<!---============== FUNCION INSERTA LINEAS A LA TEMPORAL QUE LUEGO SE PINTA ==============---->
	<cffunction name="funcInsertaLinea" >
		<cfargument name="DEid" type="numeric">
		<cfargument name="RCNid" type="numeric">
		<cfargument name="descconcepto" type="string" default="">
		<cfargument name="cantconcepto" type="string" default="0">
		<cfargument name="montoconcepto" type="numeric" default="0">
		<cfargument name="linea" type="numeric" default="0">
		<cfargument name="columna" type="numeric" default="1">
		<cfargument name="empleado" type="string" default="">
		<cfargument name="cuenta" type="string" default="">
		<cfargument name="etiquetacuenta" type="string" default="">
		<cfargument name="departamento" type="string" default="">
		<cfargument name="puntoventa" type="string" default="">
		<cfargument name="orden" type="numeric" default="1">
		<cfargument name="forzar" type="boolean" default="false">
		<cfargument name="incidencia" type="numeric" default="0">
		<cfargument name="especie" type="numeric" default="0">
		<cfargument name="resumeCargas" type="numeric" default="0">
		<cfargument name="resumeCargasDesc" type="string" default="">


		<cfif arguments.columna EQ 1>

			<cfquery datasource="#session.DSN#">
				insert into #TMPConceptos# (DEid,RCNid,descconcepto,cantconcepto,montoconcepto,linea,columna,nomina,
											desdenomina,hastanomina,empleado,cuenta,departamento,puntoventa,orden,EtiquetaCuenta,incidencia,especie,resumeCargas,resumeCargasDesc)
				values(<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.RCNid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(arguments.descconcepto)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.cantconcepto#">,
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#arguments.montoconcepto#">,
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.linea#">,
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.columna#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(rsNomina.RCDescripcion)#">,
						<cfqueryparam cfsqltype="cf_sql_date" 		value="#trim(rsNomina.RCdesde)#">,
						<cfqueryparam cfsqltype="cf_sql_date" 		value="#trim(rsNomina.RChasta)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.empleado#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.cuenta#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.departamento#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.puntoventa#">,
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.orden#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.etiquetacuenta#">,
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.incidencia#">,
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.especie#">,
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.resumeCargas#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.resumeCargasDesc#">
						)
			</cfquery>
			<cfset VN_CUENTALINEAS = VN_CUENTALINEAS + 1><!---Aumentar las lineas columna 1--->
		<cfelse>
			<cfquery name="rsExiste" datasource="#session.DSN#">
				select 1 from #TMPConceptos#
				where columna = 1
					and linea = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.linea#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and especie = 0
			</cfquery>
			<cfif rsExiste.RecordCount NEQ 0 and NOT arguments.forzar>
				<cfquery datasource="#session.DSN#">
					update #TMPConceptos#
						set descconceptoB = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.descconcepto)#">,
							cantconceptoB = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cantconcepto#">,
							montoconceptoB = <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.montoconcepto#">,
							resumeCargas = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.resumeCargas#">,
							resumeCargasDesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.resumeCargasDesc#">
					where columna = 1
						and linea = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.linea#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
						and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				</cfquery>
			<cfelse>
				<cfquery datasource="#session.DSN#">
					insert into #TMPConceptos# (DEid,RCNid,descconceptoB,cantconceptoB,montoconceptoB,linea,columna,nomina,
											desdenomina,hastanomina,empleado,cuenta,departamento,puntoventa,orden,incidencia,especie,resumeCargas,resumeCargasDesc)
					values(<cfqueryparam  cfsqltype="cf_sql_numeric" 	value="#arguments.DEid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.RCNid#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(arguments.descconcepto)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.cantconcepto#">,
							<cfqueryparam cfsqltype="cf_sql_money" 		value="#arguments.montoconcepto#">,
							<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.linea#">,
							<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.columna#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(rsNomina.RCDescripcion)#">,
							<cfqueryparam cfsqltype="cf_sql_date" 		value="#trim(rsNomina.RCdesde)#">,
							<cfqueryparam cfsqltype="cf_sql_date" 		value="#trim(rsNomina.RChasta)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.empleado#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.cuenta#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.departamento#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.puntoventa#">,
							<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.orden#">,
							<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.incidencia#">,
							<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.especie#">,
							<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.resumeCargas#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.resumeCargasDesc#">
							)
				</cfquery>
			</cfif>
			<cfset VN_CUENTALINEAS_2 = VN_CUENTALINEAS_2 + 1><!---Aumentar las lineas columna 2--->
		</cfif>
<!---
<cf_dumptable var="#TMPConceptos#">
--->
	</cffunction>
	<!---============== FUNCION OBTIENE SALARIO BRUTO, INSERTA EN TEMPORAL ==============---->
	<cffunction name="funcSalBrutoRelacion">
		<cfargument name="DEid" 		  type="numeric" required="yes">
		<cfargument name="RCNid" 		  type="numeric" required="yes">
		<cfargument name="empleado" 	  type="string" required="no">
		<cfargument name="cuenta" 		  type="string" required="no">
		<cfargument name="etiquetacuenta" type="string" required="no">
		<cfargument name="departamento"   type="string" required="no">
		<cfargument name="puntoventa"	  type="string" required="no">
		<cfargument name="orden" 		  type="numeric" required="no">

		<cfquery name="rsSalBrutoRelacion" datasource="#Session.DSN#">
			select
			coalesce(sum(PEmontores),0) as Monto,
					<cf_dbfunction name="to_char" args="coalesce(sum(PEcantdias),0)"> as cantidad,

				<!---	case when coalesce(sum(PEcantdias * (PEsalarioref/30)),0) = 0
						then <cf_dbfunction name="to_char" args="coalesce(sum(PEmontores),0)">
						else <cf_dbfunction name="to_char" args="coalesce(sum(PEcantdias * (PEsalarioref/30)),0)">
					end as Monto, --->

					d.CSdescripcion
			from #pref#PagosEmpleado a
				inner join LineaTiempo b
					on a.LTid = b.LTid
				inner join DLineaTiempo c
					on b.LTid = c.LTid
				inner join ComponentesSalariales d
					on c.CSid = d.CSid
					and d.CSsalariobase = 1
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and a.PEtiporeg = 0
			group by d.CSdescripcion
		</cfquery>

		<cfif rsSalBrutoRelacion.RecordCount EQ 0>
			<cfquery name="rsSalBrutoRelacion" datasource="#Session.DSN#">
				select 0.00 as Monto,
						0 as cantidad,
						d.CSdescripcion
				from #pref#SalarioEmpleado a
					inner join #pref#RCalculoNomina rc
						on a.RCNid = rc.RCNid
					inner join  LineaTiempo b
						on (rc.RCdesde between LTdesde and LThasta or rc.RChasta between LTdesde and LThasta)
						and a.DEid = b.DEid
					inner join DLineaTiempo c
						on b.LTid = c.LTid
					inner join ComponentesSalariales d
						on c.CSid = d.CSid
						and d.CSsalariobase = 1
				where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				group by d.CSdescripcion
			</cfquery>
		</cfif>

		<cfquery name="cantidad_horas" datasource="#Session.DSN#">
		   select RHJtipoPago, <cfif len(trim(rsSalBrutoRelacion.Monto))><cfqueryparam cfsqltype="cf_sql_money"
				value="#rsSalBrutoRelacion.Monto#"><cfelse>0.00</cfif> / (case when  lt.LTsalario = 0 then 1
				else lt.LTsalario /<cf_dbfunction name="to_float" args="tn.FactorDiasSalario"> / j.RHJhoradiaria  end) as cantidad
		   from LineaTiempo lt, TiposNomina tn, RHJornadas j,HRCalculoNomina rc
		   where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
								   and rc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
								   and rc.RCdesde between lt.LTdesde and lt.LThasta
								   and lt.Tcodigo = tn.Tcodigo
								   and lt.RHJid = j.RHJid
								   and lt.Ecodigo = tn.Ecodigo
								   and tn.Ecodigo = j.Ecodigo
								   and tn.Ttipopago = 0
	   </cfquery>

	 <!---  cantidad_horascantidad_horas

	   <cfdump var="#cantidad_horas#">   --->


		<cfquery name="cantidad_dias" datasource="#Session.DSN#">
			select <cf_dbfunction name="to_char" args="coalesce(sum(PEcantdias),0)"> as cantidad
			from #pref#PagosEmpleado a
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and a.PEtiporeg = 0
				and a.PEmontores != 0
		</cfquery>

		<cfif cantidad_horas.RHJtipoPago EQ 1>
			<cfset cantidad = #NumberFormat(cantidad_horas.cantidad,'___.__')#>
		<cfelse>
			<cfset cantidad = cantidad_dias.cantidad>
		</cfif>

		 <!---???Cantidad de Dias NO laborados???--->
		<cfset DiasNoLaborados  = 0>
		<cfset MontoNoLaborados = 0>
		<cfif listfind('50',rsParametro.Pvalor)>

			<cfquery name="rsDiasNoLaborados" datasource="#Session.DSN#">
				select Coalesce(sum(PEcantdias),0) as dias,
					   Coalesce(sum(Coalesce(PEsalarioref,0) / <cf_dbfunction name="to_float" args="Coalesce(c.FactorDiasSalario,'1')"> * PEcantdias),0) as monto
					from #pref#PagosEmpleado a
					 inner join #pref#RCalculoNomina b
						on a.RCNid = b.RCNid
					 inner join TiposNomina c
						on c.Ecodigo = b.Ecodigo
					   and c.Tcodigo = b.Tcodigo
				  where a.DEid  	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					and a.RCNid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and a.PEtiporeg  = 0
					and a.PEmontores = 0
			</cfquery>

			<cfset DiasNoLaborados = rsDiasNoLaborados.dias>
			<cfset MontoNoLaborados = rsDiasNoLaborados.monto>
		 </cfif>

		 <!---
		 <cfdump var="#MontoNoLaborados#">
		 <cf_dump var="#rsSalBrutoRelacion#">
		 --->

		<!---====== Insertar en la temporal ======----->
		<cfif rsSalBrutoRelacion.RecordCount NEQ 0>
			<!---<cfif rsSalBrutoRelacion.Monto GT 0>--->
				<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,'#rsSalBrutoRelacion.CSdescripcion#',0,rsSalBrutoRelacion.Monto,VN_CUENTALINEAS,1,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden)>

				<cfset salariobrutorelacion = rsSalBrutoRelacion.Monto>
			<!---</cfif>--->
		<cfelse>
			<cfset salariobrutorelacion = 0>
		</cfif>

		<!---rsSalBrutoRelacion
        <cfdump var="#rsSalBrutoRelacion#">--->


        <cfif #vDebug# >
        	rsSalBrutoRelacion
        	<cfdump var="#rsSalBrutoRelacion#">
        </cfif>



	</cffunction>
	<!---============== FUNCION OBTIENE RETROACTIVOS LOS INSERTA EN TEMPORAL ==============---->
	<cffunction name="funcRetroactivos">
		<cfargument name="DEid" type="numeric" required="yes">
		<cfargument name="RCNid" type="numeric" required="yes">
		<cfargument name="empleado" type="string" required="no">
		<cfargument name="cuenta" type="string" required="no">
		<cfargument name="etiquetacuenta" type="string" required="no">
		<cfargument name="departamento" type="string" required="no">
		<cfargument name="puntoventa" type="string" required="no">
		<cfargument name="orden" type="numeric" required="no">

		<cfquery name="rsRetroactivos" datasource="#Session.DSN#">
			select coalesce(sum(PEmontores),0) as Monto, <cf_dbfunction name="to_char" args="sum(PEcantdias)"> as cantidad
			from #pref#PagosEmpleado a
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			and a.PEtiporeg > 0
			and a.PEmontores != 0
		</cfquery>
		<!---====== Insertar en la temporal ======----->
		<cfif rsRetroactivos.RecordCount NEQ 0 and rsRetroactivos.Monto NEQ 0>
			<cfif rsParametro.Pvalor EQ 30><!----Cuando el calculo es para la boleta de 1/2 de Coopelesca--->
				<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,'#LB_Retroactivos#','',rsRetroactivos.Monto,VN_CUENTALINEAS,1
									,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden)>
			<cfelse>
				<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,'#LB_Retroactivos#','#rsRetroactivos.cantidad#',rsRetroactivos.Monto,VN_CUENTALINEAS,1
											,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden)>
			</cfif>
		</cfif>
		<cfif rsRetroactivos.RecordCount NEQ 0>
			<cfset retroactivos = rsRetroactivos.Monto>
		</cfif>
        <cfif #vDebug# >
        	rsRetroactivos
        	<cfdump var="#rsRetroactivos#">
        </cfif>


	</cffunction>
	<!---============== FUNCION OBTIENE DEDUCCIONES,RENTA EMPLEADO LO INSERTA EN TEMPORAL ==============---->
	<cffunction name="funcSalarioEmpleado">
		<cfargument name="DEid" type="numeric" required="yes">
		<cfargument name="RCNid" type="numeric" required="yes">
		<cfargument name="empleado" type="string" required="no">
		<cfargument name="cuenta" type="string" required="no">
		<cfargument name="etiquetacuenta" type="string" required="no">
		<cfargument name="departamento" type="string" required="no">
		<cfargument name="puntoventa" type="string" required="no">
		<cfargument name="orden" type="numeric" required="no">


		<cfquery name="rsSalarioEmpleado" datasource="#Session.DSN#">
			select SErenta, SEcargasempleado, SEdeducciones
			from #pref#SalarioEmpleado
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
		</cfquery>

		<!---====== Insertar en la temporal ======----->
		<cfif rsSalarioEmpleado.RecordCount NEQ 0 and rsSalarioEmpleado.SErenta NEQ 0>
			<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,'#LB_Renta#','',rsSalarioEmpleado.SErenta,VN_CUENTALINEAS_2,2
										,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden)>
		</cfif>

		<cfif rsSalarioEmpleado.RecordCount NEQ 0>
			<cfset deducciones = rsSalarioEmpleado.SErenta + rsSalarioEmpleado.SEcargasempleado + rsSalarioEmpleado.SEdeducciones>
		</cfif>

		<cfif #vDebug# >
        	rsSalarioEmpleado
        	<cfdump var="#rsSalarioEmpleado#">
        </cfif>

	</cffunction>
	<!---============== FUNCION OBTIENE CARGAS LABORALES LAS INSERTA EN TEMPORAL ==============---->
	<cffunction name="funcCargas" output="true">
		<cfargument name="DEid" type="numeric" required="yes">
		<cfargument name="RCNid" type="numeric" required="yes">
		<cfargument name="empleado" type="string" required="no">
		<cfargument name="cuenta" type="string" required="no">
		<cfargument name="etiquetacuenta" type="string" required="no">
		<cfargument name="departamento" type="string" required="no">
		<cfargument name="puntoventa" type="string" required="no">
		<cfargument name="orden" type="numeric" required="no">

		<cfquery name="rsCargasResumidas" datasource="#Session.DSN#">
			select 	sum(coalesce(CCvaloremp,0)) as CCvaloremp,
					DEid,
					ECcodigo,
					ECdescripcion,
					case when sum(coalesce(ECresumido,0)) > 0 <!---indica si las cargas se muestran de forma resumida o no. CarolRS--->
					then 1 else 0  end as ECresumido
			from #pref#CargasCalculo a, DCargas b, ECargas c
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			  and a.DClinea = b.DClinea
			  and b.ECid = c.ECid
			  and CCvaloremp <> 0
			  and ECresumido = 1
			group by DEid,ECcodigo,ECdescripcion
		</cfquery>
		<cfloop query="rsCargasResumidas">
			<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,rsCargasResumidas.ECdescripcion,'',rsCargasResumidas.CCvaloremp,VN_CUENTALINEAS_2,2
										,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden,false,0,0,rsCargasResumidas.ECresumido, rsCargasResumidas.ECdescripcion)>
		</cfloop>

		<cfquery name="rsCargas" datasource="#Session.DSN#">
			select 	sum(coalesce(CCvaloremp,0)) as CCvaloremp,
					DCdescripcion,
					DEid,
					ECcodigo,
					ECdescripcion,
					case when sum(coalesce(ECresumido,0)) > 0 <!---indica si las cargas se muestran de forma resumida o no. CarolRS--->
					then 1 else 0  end as ECresumido
			from  #pref#CargasCalculo a, DCargas b, ECargas c
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			  and a.DClinea = b.DClinea
			  and b.ECid = c.ECid
			  and CCvaloremp <> 0
			  and coalesce(ECresumido,0) = 0
			group by DEid,ECcodigo,ECdescripcion,DCdescripcion
		</cfquery>

		<!---====== Insertar en la temporal ======----->
		<cfloop query="rsCargas">
			<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,rsCargas.DCdescripcion,'',rsCargas.CCvaloremp,VN_CUENTALINEAS_2,2
										,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden,false,0,0,rsCargas.ECresumido, rsCargas.ECdescripcion)>
		</cfloop>

		<cfif #vDebug# >
        	rsCargas
        	<cfdump var="#rsCargas#">
        </cfif>

	</cffunction>
	<!---============== FUNCION OBTIENE DEDUCCIONES LAS INSERTA EN TEMPORAL ==============---->
	<cffunction name="funcDeducciones">
		<cfargument name="DEid" type="numeric" required="yes">
		<cfargument name="RCNid" type="numeric" required="yes">
		<cfargument name="empleado" type="string" required="no">
		<cfargument name="cuenta" type="string" required="no">
		<cfargument name="etiquetacuenta" type="string" required="no">
		<cfargument name="departamento" type="string" required="no">
		<cfargument name="puntoventa" type="string" required="no">
		<cfargument name="orden" type="numeric" required="no">

		<cfquery name="rsDeducciones" datasource="#Session.DSN#">
			<!---
			select 	a.Did as Did,
					coalesce(a.DCvalor,0) as DCvalor,
					a.DCinteres,
					a.DCcalculo,
					b.Ddescripcion,
					b.Dvalor,
					b.Dmetodo,
					a.DCsaldo,
					b.Dcontrolsaldo,
					b.Dreferencia
			---->
			select 	a.DEid, b.TDid,							<!---ERBG Corrección en la descripción del Subsidio al salario 03/03/2014--->
					sum(coalesce(a.DCvalor,0)) as DCvalor,
					b.Ddescripcion
			from #pref#DeduccionesCalculo a, DeduccionesEmpleado b
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				and a.Did = b.Did
				and a.DCvalor != 0
			group by a.DEid,b.TDid,b.Ddescripcion
			<!---order by b.Dreferencia--->
		</cfquery>
        <!---ERBG Corrección en la descripción del Subsidio al salario Inicia 03/03/2014--->
		<!---Parametro RH de subsidio salario--->
        <cfquery datasource="#Session.DSN#" name="rsDeduccion">
        	select Pvalor as TDid,Pdescripcion  from RHParametros where Pcodigo = 2033 and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        </cfquery>
        <!---Deduccion asociada al parametro--->
        <cfquery datasource="#Session.DSN#" name="rsTDeduccion">
        	select * from TDeduccion where TDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDeduccion.TDid#">  and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        </cfquery>
        <!---ERBG Corrección en la descripción del Subsidio al salario Fin 03/03/2014--->

		<!---====== Insertar en la temporal ======----->
		<cfloop query="rsDeducciones">
        	<!---ERBG Corrección en la descripción del Subsidio al salario Inicia 03/03/2014--->
        	<cfset Descripcion = #rsDeducciones.Ddescripcion#>
        	<cfif rsDeducciones.TDid eq rsDeduccion.TDid>
                <cfset Descripcion = #rsTDeduccion.TDdescripcion#>
        	</cfif>
            <!---ERBG Corrección en la descripción del Subsidio al salario Fin 03/03/2014--->
			<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,#Descripcion#,'',rsDeducciones.DCvalor,VN_CUENTALINEAS_2,2
										,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden,false)>
		</cfloop>

        <cfif #vDebug# >
        	rsDeducciones
        	<cfdump var="#rsDeducciones#">
        </cfif>

	</cffunction>
	<!---============== FUNCION OBTIENE INCIDENCIAS LAS INSERTA EN TEMPORAL ==============---->
	<cffunction name="funcIncidencias">
		<cfargument name="DEid" type="numeric" required="yes">
		<cfargument name="RCNid" type="numeric" required="yes">
		<cfargument name="empleado" type="string" required="no">
		<cfargument name="cuenta" type="string" required="no">
		<cfargument name="etiquetacuenta" type="string" required="no">
		<cfargument name="departamento" type="string" required="no">
		<cfargument name="puntoventa" type="string" required="no">
		<cfargument name="orden" type="numeric" required="no">

		<cfif rsParametro.Pvalor EQ 30><!----Cuando el calculo es para la boleta de 1/2 de Coopelesca--->
			<cfquery name="rsIncidenciasCalculo" datasource="#Session.DSN#">
				select 	a.DEid,
						case when a.ICmontoant <> 0 then
							<cf_dbfunction name="concat" args="'AJUSTE',' ',b.CIdescripcion">
						else
							b.CIdescripcion
						end as CIdescripcion,
						sum(coalesce(a.ICmontores,0)) as Monto,
						sum(coalesce(a.ICmontores,0)) as ICmontores,
						<cf_dbfunction name="to_char" args="sum(case when a.ICmontoant <> 0 then
							null
						else
							(case when CItipo < 2 then
								coalesce(ICvalor,0)
							else
								null
							end)
						end
						)"> as Valor <!---Cantidad---> <!----sum((case when CItipo < 2 then ICvalor else null end))--->
				from #pref#IncidenciasCalculo a, CIncidentes b, ComponentesSalariales c
				where a.CIid = b.CIid
					and a.CIid = c.CIid
					and c.CSsalarioEspecie = 0
					and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				group by a.DEid,
						 case when a.ICmontoant <> 0 then
							 <cf_dbfunction name="concat" args="'AJUSTE',' ',b.CIdescripcion">
						else
							b.CIdescripcion
						end
			</cfquery>
		<cfelse>
			<cfquery name="rsIncidenciasCalculo" datasource="#Session.DSN#">
				select a.DEid,
					b.CIdescripcion,
					sum(coalesce(a.ICmontores,0)) as Monto,
					sum((case when CItipo < 2 then ICvalor else 0 end)) as Valor,
					sum(coalesce(a.ICmontores,0)) as ICmontores
				from #pref#IncidenciasCalculo a
					 inner join CIncidentes b
						on a.CIid = b.CIid
					left outer join ComponentesSalariales c
						on a.CIid = c.CIid
						and c.CSsalarioEspecie = 0
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					and a.ICmontores != 0
				group by a.DEid,b.CIdescripcion
			</cfquery>

			<cfquery name="rsIncidenciasCalculo"  dbtype="query">
				select * from rsIncidenciasCalculo
				   where Monto <> 0
			</cfquery>
		</cfif>

		<cfif rsIncidenciasCalculo.recordCount GT 0>
			<!---<cfset montoIncidencias = rsIncidenciasCalculo.Monto + Iif(Len(Trim(retroactivos)), DE(retroactivos), DE("0.00"))>--->
			<!---====== Insertar en la temporal ======----->
			<cfloop query="rsIncidenciasCalculo">
				<cfset montoIncidencias = montoIncidencias + (rsIncidenciasCalculo.Monto)>
				<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,rsIncidenciasCalculo.CIdescripcion,'#rsIncidenciasCalculo.Valor#',rsIncidenciasCalculo.ICmontores,VN_CUENTALINEAS,1
											,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden,false,1,0)>
			</cfloop>
			<cfset montoIncidencias = montoIncidencias + Iif(Len(Trim(retroactivos)), DE(retroactivos), DE("0.00"))>
		<cfelse>
			<cfset montoIncidencias = 0.00 + Iif(Len(Trim(retroactivos)), DE(retroactivos), DE("0.00"))>
		</cfif>

        <cfif #vDebug# >
        	rsIncidenciasCalculo
        	<cfdump var="#rsIncidenciasCalculo#">
        </cfif>
	</cffunction>


	<!---============== FUNCION OBTIENE INCIDENCIAS ESPECIE LAS INSERTA EN TEMPORAL ==============---->
	<cffunction name="funcIncidenciasEspecie">
		<cfargument name="DEid" type="numeric" required="yes">
		<cfargument name="RCNid" type="numeric" required="yes">
		<cfargument name="empleado" type="string" required="no">
		<cfargument name="cuenta" type="string" required="no">
		<cfargument name="etiquetacuenta" type="string" required="no">
		<cfargument name="departamento" type="string" required="no">
		<cfargument name="puntoventa" type="string" required="no">
		<cfargument name="orden" type="numeric" required="no">

		<cfif rsParametro.Pvalor EQ 30><!----Cuando el calculo es para la boleta de 1/2 de Coopelesca--->
			<cfquery name="rsIncidenciasCalculoEspecie" datasource="#Session.DSN#">
				select 	a.DEid,
						case when a.ICmontoant <> 0 then
							<cf_dbfunction name="concat" args="'AJUSTE',' ',b.CIdescripcion">
						else
							b.CIdescripcion
						end as CIdescripcion,
						sum(coalesce(a.ICmontores,0)) as Monto,
						sum(coalesce(a.ICmontores,0)) as ICmontores,
						<cf_dbfunction name="to_char" args="sum(case when a.ICmontoant <> 0 then
							null
						else
							(case when CItipo < 2 then
								coalesce(ICvalor,0)
							else
								null
							end)
						end
						)"> as Valor <!---Cantidad---> <!----sum((case when CItipo < 2 then ICvalor else null end))--->
				from #pref#IncidenciasCalculo a, CIncidentes b, ComponentesSalariales c
				where a.CIid = b.CIid
					and a.CIid = c.CIid
					and c.CSsalarioEspecie = 1
					and a.ICmontores > 0
					and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				group by a.DEid,
						 case when a.ICmontoant <> 0 then
							 <cf_dbfunction name="concat" args="'AJUSTE',' ',b.CIdescripcion">
						else
							b.CIdescripcion
						end
			</cfquery>
		<cfelse>
			<cfquery name="rsIncidenciasCalculoEspecie" datasource="#Session.DSN#">
				select 	a.DEid,
						b.CIdescripcion,
						sum(coalesce(a.ICmontores,0)) as Monto,
						sum((case when CItipo < 2 then ICvalor else 0 end)) as Valor,
						round(sum(coalesce(a.ICmontores,0)),0) as ICmontores			<!---se agrega el round al monto de la incidencia especie para que se pinte monto completo EUNICE mexico lo solicito y Nelson lo aprobo--->
				from #pref#IncidenciasCalculo a, CIncidentes b, ComponentesSalariales c
				where a.CIid = b.CIid
					and a.CIid = c.CIid
					and c.CSsalarioEspecie = 1
					and a.ICmontores <> 0
					and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					and a.ICmontores != 0
					and coalesce(a.ICespecie,0) = 0
				group by a.DEid,b.CIdescripcion
				<!---order by a.DEid,b.CIdescripcion--->
			union
				select 	a.DEid,
						b.CIdescripcion,
						sum(coalesce(a.ICmontores,0)) as Monto,
						sum((case when CItipo < 2 then ICvalor else 0 end)) as Valor,
						round(sum(coalesce(a.ICmontores,0)),0) as ICmontores			<!---se agrega el round al monto de la incidencia especie para que se pinte monto completo EUNICE mexico lo solicito y Nelson lo aprobo--->
				from #pref#IncidenciasCalculo a, CIncidentes b
				where a.CIid = b.CIid
					and a.ICmontores <> 0
					and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					and a.ICmontores != 0
					and coalesce(a.ICespecie,0) = 0
					and b.CIespecie = 1
				group by a.DEid,b.CIdescripcion
				<!---order by a.DEid,b.CIdescripcion--->
			</cfquery>
		</cfif>

		<cfif rsIncidenciasCalculoEspecie.recordCount GT 0>
			<!---<cfset montoIncidencias = rsIncidenciasCalculo.Monto + Iif(Len(Trim(retroactivos)), DE(retroactivos), DE("0.00"))>--->
			<!---====== Insertar en la temporal ======----->
			<cfloop query="rsIncidenciasCalculoEspecie">
				<cfset montoIncidenciasEspecie = montoIncidenciasEspecie + (rsIncidenciasCalculoEspecie.Monto)>
				<cfset x= funcInsertaLinea(arguments.DEid,
											arguments.RCNid,
											rsIncidenciasCalculoEspecie.CIdescripcion,
											<!---'#rsIncidenciasCalculo.Valor#',--->
											'',
											rsIncidenciasCalculoEspecie.ICmontores,
											VN_CUENTALINEAS,
											1,
											arguments.empleado,
											arguments.cuenta,
											arguments.etiquetacuenta,
											arguments.departamento,
											arguments.puntoventa,
											arguments.orden,
											false,
											1,
											1)>
			</cfloop>
			<!--- <cfset montoIncidenciasEspecie = montoIncidenciasEspecie + Iif(Len(Trim(retroactivos)), DE(retroactivos), DE("0.00"))> --->
		<cfelse>
			<!--- <cfset montoIncidenciasEspecie = 0.00 + Iif(Len(Trim(retroactivos)), DE(retroactivos), DE("0.00"))> --->
			<cfset montoIncidenciasEspecie = 0.00 >
		</cfif>

        <cfif #vDebug# >
        	rsIncidenciasCalculoEspecie
        	<cfdump var="#rsIncidenciasCalculoEspecie#">
        </cfif>

           <!---<cf_dump var = "#montoIncidenciasEspecie#"> --->
	</cffunction>

	<!---============== FUNCION OBTIENE las Faltas o Tipos de Accion ==============---->
	<cffunction name="funcFaltas">
		<cfargument name="DEid" 			type="numeric" required="yes">
		<cfargument name="RCNid" 			type="numeric" required="yes">
		<cfargument name="empleado" 		type="string"  required="no">
		<cfargument name="cuenta" 			type="string"  required="no">
		<cfargument name="etiquetacuenta" 	type="string"  required="no">
		<cfargument name="departamento" 	type="string"  required="no">
		<cfargument name="puntoventa" 		type="string"  required="no">
		<cfargument name="orden" 			type="numeric" required="no">

		<cfquery name="rsFaltas" datasource="#Session.DSN#">
				select sum(PEcantdias * coalesce(RHTfactorfalta,1)) as PEcantdias, ((sum(Coalesce(PEsalarioref,0) / <cf_dbfunction name="to_float" args="Coalesce(c.FactorDiasSalario,'1')"> * PEcantdias))* coalesce(RHTfactorfalta,1)) as monto, d.RHTdesc
					from #pref#PagosEmpleado a
					 inner join #pref#RCalculoNomina b
						on a.RCNid = b.RCNid
					 inner join TiposNomina c
						on c.Ecodigo = b.Ecodigo
					   and c.Tcodigo = b.Tcodigo
					 inner join RHTipoAccion d
						on d.RHTid = a.RHTid
						and d.RHTcomportam = 13
				  where a.DEid  	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					and a.RCNid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and a.PEtiporeg  = 0
				 group by d.RHTdesc,coalesce(RHTfactorfalta,1)
		</cfquery>

		<!---====== Insertar en la temporal ======----->
        <!---ljiemenez se comenta para que no se incluya en el pintado de las boletas de el descuento de las faltas
        a peticion de Eunice --->
		<!---<cfloop query="rsFaltas">
			<cfset descripcion = rsFaltas.RHTdesc & '('&#LSnumberFormat(rsFaltas.PEcantdias,99.999)# & 'D)'>
			<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,descripcion,0,rsFaltas.monto,VN_CUENTALINEAS_2,2
										,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden,false)>
		</cfloop>--->

         <cfif #vDebug# >
        	rsFaltas
        	<cfdump var="#rsFaltas#">
        </cfif>

	</cffunction>


	<cffunction name="getConceptosPago" returntype="any" access="public">
		<cfargument name="CPid" 			type="numeric" required="yes">
		<cfargument name="DEidList" 		type="string"  required="yes">
		<cfargument name="Historico" 		type="string"  default="yes">

		<cfif Arguments.Historico EQ 'yes'>
			<cfset pref = 'H'>
		</cfif>

		<!---============== DATOS DE LA NOMINA ==============---->
		<cfquery name="rsNomina" datasource="#Session.DSN#">
			select RCNid, c.CPfpago, a.RCdesde, a.RChasta, a.RCDescripcion, b.Tdescripcion
			from #pref#RCalculoNomina a, TiposNomina b, CalendarioPagos c
			where a.Tcodigo = b.Tcodigo
			and a.RCNid = c.CPid
			and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPid#">
			and a.Ecodigo = b.Ecodigo
		</cfquery>

		<!---============== PARA C/EMPLEADO INSERTAR LOS DIFERENTES RUBROS EN LA TEMPORAL ==============---->
		<cfset VN_ORDEN = 1>											<!---Valor de ordenamiento del query--->
		<cfloop list="#Arguments.DEidList#" index="id">							<!---<cfloop query="rsEmpleadosNomina">--->
			<cfquery name="rsEncabEmpleado" datasource="#Session.DSN#">	<!---Datos del empleado--->
				select {fn concat (ltrim(rtrim(coalesce(DEtarjeta,''))), {fn concat('   ',{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, coalesce(de.DEapellido2,'') )}, ' ' )}, de.DEnombre )})})}as nombreEmpl	, DEemail, DEidentificacion, NTIdescripcion
						,DEinfo1
						,case CBTcodigo when 1 then '<b>Cuenta de Ahorros No.:</b>' else '<b>Cuenta Corriente No.:</b>' end as EtiquetaCuenta
						,de.DEcuenta as cuenta
						,{fn concat('El monto detallado en este documento fu depositado a su cuenta ',
							{fn concat(case CBTcodigo when 1 then 'Cuenta de Ahorros No.:' else 'Cuenta Corriente No.:' end, de.DEcuenta)}
						)} as Etiqueta2
				from DatosEmpleado de, NTipoIdentificacion ti
				where de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
				and de.NTIcodigo = ti.NTIcodigo
			</cfquery>

			<cfquery name="rsDepto" datasource="#session.DSN#"><!---Departamento--->
				select 	b.Dcodigo,
						d.Deptocodigo, d.Ddescripcion
				from LineaTiempo a
					inner join RHPlazas b
						on  a.RHPid = b.RHPid
					inner join CFuncional c
						on b.CFid = c.CFid
					left outer join Departamentos d
						on c.Dcodigo = d.Dcodigo
						and d.Ecodigo = a.Ecodigo
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
					 and LTdesde = (Select max(LTdesde)
									from LineaTiempo e
									where a.DEid = e.DEid
										and e.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsNomina.RCdesde#">
										and e.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsNomina.RChasta#">)
			</cfquery>
			<cfset vDebug = "false">
			<cfset VN_CUENTALINEAS = 1>			<!---Lineas de la columna izquierda (+)--->
			<cfset VN_CUENTALINEAS_2 = 1>		<!---Lineas de la columna derecha (-)--->
			<cfset salariobrutorelacion = 0>	<!---Salario bruto del empleado--->
			<cfset montoIncidencias = 0>		<!---Monto sumatoria de incidencias--->
			<cfset montoIncidenciasEspecie = 0>	<!---Monto sumatoria de incidencias Especie--->
			<cfset retroactivos = 0>			<!---Monto sumatoria retroactivos--->
			<cfset pagos = 0>					<!---Monto Devengado por el empleado--->
			<cfset deducciones = 0>				<!---Monto sumatoria de las deducciones--->
			<cfset liquido = 0>					<!---Monto salario liquido (Devengado - Deducciones)--->

			<cfset ejecuta =  funcSalBrutoRelacion(id,CPid,rsEncabEmpleado.nombreEmpl,rsEncabEmpleado.cuenta,rsEncabEmpleado.EtiquetaCuenta,rsDepto.Ddescripcion,rsEncabEmpleado.DEinfo1,VN_ORDEN)><!---Salario bruto relacion (+)--->
			<cfset ejecuta =  funcRetroactivos(id,CPid,rsEncabEmpleado.nombreEmpl,rsEncabEmpleado.cuenta,rsEncabEmpleado.EtiquetaCuenta,rsDepto.Ddescripcion,rsEncabEmpleado.DEinfo1,VN_ORDEN)><!---Retroactivos(+)--->
			<cfset ejecuta =  funcIncidencias(id,CPid,rsEncabEmpleado.nombreEmpl,rsEncabEmpleado.cuenta,rsEncabEmpleado.EtiquetaCuenta,rsDepto.Ddescripcion,rsEncabEmpleado.DEinfo1,VN_ORDEN)><!---Incidencias(+)--->
			<cfset ejecuta =  funcIncidenciasEspecie(id,CPid,rsEncabEmpleado.nombreEmpl,rsEncabEmpleado.cuenta,rsEncabEmpleado.EtiquetaCuenta,rsDepto.Ddescripcion,rsEncabEmpleado.DEinfo1,VN_ORDEN)><!---Incidencias(+)--->
			<cfset ejecuta =  funcSalarioEmpleado(id,CPid,rsEncabEmpleado.nombreEmpl,rsEncabEmpleado.cuenta,rsEncabEmpleado.EtiquetaCuenta,rsDepto.Ddescripcion,rsEncabEmpleado.DEinfo1,VN_ORDEN)><!---Salario empleado(-)--->
			<cfset ejecuta =  funcDeducciones(id,CPid,rsEncabEmpleado.nombreEmpl,rsEncabEmpleado.cuenta,rsEncabEmpleado.EtiquetaCuenta,rsDepto.Ddescripcion,rsEncabEmpleado.DEinfo1,VN_ORDEN)><!---Deducciones empleado(-)--->
			<cfset ejecuta =  funcCargas(id,CPid,rsEncabEmpleado.nombreEmpl,rsEncabEmpleado.cuenta,rsEncabEmpleado.EtiquetaCuenta,rsDepto.Ddescripcion,rsEncabEmpleado.DEinfo1,VN_ORDEN)><!---Cargas laborales empleado(-)--->
			<cfif listfind('50',rsParametro.Pvalor)>
				<cfset ejecuta =  funcFaltas(id,CPid,rsEncabEmpleado.nombreEmpl,rsEncabEmpleado.cuenta,rsEncabEmpleado.EtiquetaCuenta,rsDepto.Ddescripcion,rsEncabEmpleado.DEinfo1,VN_ORDEN)><!---Faltas(-)--->
			</cfif>

			<cfset montoIncidencias = montoIncidencias + montoIncidenciasEspecie>
			<cfif salariobrutorelacion NEQ "" and montoIncidencias NEQ "">
				<cfset pagos = salariobrutorelacion + montoIncidencias><!---Salario devengado (+)---->
				<cfset liquido = (salariobrutorelacion + montoIncidencias) - (deducciones)><!---Neto---->
			</cfif>

			<cfquery datasource="#session.DSN#"><!---Actualizar montos generales (Devengado,Deducido,Neto)--->
				update #TMPConceptos#
					set devengado = <cfqueryparam cfsqltype="cf_sql_money" value="#pagos#">,
						deducido = <cfqueryparam cfsqltype="cf_sql_money" value="#deducciones#">,
						neto = <cfqueryparam cfsqltype="cf_sql_money" value="#liquido#">,
						lineasEmp = (select count(1) from #TMPConceptos#
									where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
										and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
									)
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
					and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
			</cfquery>

			<cfset VN_ORDEN = VN_ORDEN + 1><!---Ordenamiento de los datos para mantener el order by del query rsEmpleadosNomina segun los filtros de la consulta---->
		</cfloop>

        <cfif #vDebug#>
        	<cf_dump var="fin de DEBUG">
        </cfif>

		<!---<cf_dumptable var="#TMPConceptos#">--->
		<cfreturn #TMPConceptos#>

	</cffunction>

</cfcomponent>
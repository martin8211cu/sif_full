<cfsetting requesttimeout="8600">
<cfparam name="CPid" default="">
<cfparam name="CFidI" default="">
<cfparam name="nomail" default="0">
<cfparam name="chk" default="">
<cfparam name="historico" default="0">

<cfset vs_prefijo = ''>
<cfif historico EQ 1>
	<cfset vs_prefijo = 'H'>
</cfif>

<!-----==========================================================================================--->
<!----============================= OBTENER LOS DATOS (NUEVAMENTE) ==============================---->
<!-----==========================================================================================--->
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Boleta_Pago" default="Boleta de Pago" returnvariable="LB_Boleta" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" /> 
<cfinvoke key="LB_SalarioBruto" default="Salario Bruto" returnvariable="LB_SalarioBruto" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" /> 
<cfinvoke key="LB_Retroactivos" default="RETROACTIVOS" returnvariable="LB_Retroactivos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" /> 
<cfinvoke key="LB_Renta" default="IMPUESTO RENTA EMPLEADOS" returnvariable="LB_Renta" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" /> 
<cfinvoke key="LB_GenerarArchivoTexto" default="Generar archivo de texto" returnvariable="LB_GenerarArchivoTexto" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" /> 
<!--- FIN VARIABLES DE TRADUCCION --->

<!-----==========================================================================================--->
<!----==================================== CONSULTAS  ==========================================---->
<!-----==========================================================================================--->
<!----TABLA TEMPORAL DE TRABAJO---->
<cf_dbtemp name="TEMPConceptos" returnvariable="TMPConceptosX" datasource="#session.DSN#">
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
   <cf_dbtempcol name="desdenomina"  	type="date"	mandatory="no">
   <cf_dbtempcol name="hastanomina"  	type="date"	mandatory="no">
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

	<cfif arguments.columna EQ 1>
		<cfquery datasource="#session.DSN#">
			insert into #TMPConceptosX# (DEid,RCNid,descconcepto,cantconcepto,montoconcepto,linea,columna,nomina,
										desdenomina,hastanomina,empleado,cuenta,departamento,puntoventa,orden,EtiquetaCuenta)
			values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.descconcepto)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cantconcepto#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.montoconcepto#">,				
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.linea#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.columna#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsNomina.RCDescripcion)#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#trim(rsNomina.RCdesde)#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#trim(rsNomina.RChasta)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.empleado#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cuenta#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.departamento#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.puntoventa#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orden#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.etiquetacuenta#">
					)

		</cfquery>
		<cfset VN_CUENTALINEAS = VN_CUENTALINEAS + 1><!---Aumentar las lineas columna 1--->	
	<cfelse>
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select 1 from #TMPConceptosX#
			where columna = 1
				and linea = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.linea#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
		</cfquery>
		<cfif rsExiste.RecordCount NEQ 0>
			<cfquery datasource="#session.DSN#">
				update #TMPConceptosX#
					set descconceptoB = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.descconcepto)#">,
						cantconceptoB = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cantconcepto#">,
						montoconceptoB = <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.montoconcepto#">
				where columna = 1
					and linea = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.linea#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.DSN#">
				insert into #TMPConceptosX# (DEid,RCNid,descconceptoB,cantconceptoB,montoconceptoB,linea,columna,nomina,
										desdenomina,hastanomina,empleado,cuenta,departamento,puntoventa,orden)
				values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.descconcepto)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cantconcepto#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.montoconcepto#">,				
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.linea#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.columna#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsNomina.RCDescripcion)#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#trim(rsNomina.RCdesde)#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#trim(rsNomina.RChasta)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.empleado#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cuenta#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.departamento#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.puntoventa#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orden#">
						)
			</cfquery>
		</cfif>
		<cfset VN_CUENTALINEAS_2 = VN_CUENTALINEAS_2 + 1><!---Aumentar las lineas columna 2--->	
	</cfif>	
</cffunction>
<!---============== FUNCION OBTIENE SALARIO BRUTO, INSERTA EN TEMPORAL ==============---->
<cffunction name="funcSalBrutoRelacion">
	<cfargument name="DEid" type="numeric" required="yes">
	<cfargument name="RCNid" type="numeric" required="yes">
	<cfargument name="empleado" type="string" required="no">
	<cfargument name="cuenta" type="string" required="no">
	<cfargument name="etiquetacuenta" type="string" required="no">
	<cfargument name="departamento" type="string" required="no">
	<cfargument name="puntoventa" type="string" required="no">
	<cfargument name="orden" type="numeric" required="no">
	
	<cfquery name="rsSalBrutoRelacion" datasource="#Session.DSN#">		
		select coalesce(sum(PEmontores),0) as Monto, 
				<cf_dbfunction name="to_char" args="sum(PEcantdias)"> as cantidad,
				d.CSdescripcion
		from #vs_prefijo#PagosEmpleado a
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
		from #vs_prefijo#SalarioEmpleado a
			inner join HRCalculoNomina rc
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
	   select Ttipopago, <cfif len(trim(rsSalBrutoRelacion.Monto))><cfqueryparam cfsqltype="cf_sql_money"
			value="#rsSalBrutoRelacion.Monto#"><cfelse>0.00</cfif> / ( lt.LTsalario /<cf_dbfunction name="to_float" args="tn.FactorDiasSalario"> / j.RHJhoradiaria) as cantidad
	   from LineaTiempo lt, TiposNomina tn, RHJornadas j, #vs_prefijo#RCalculoNomina rc
	   where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
							   and rc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
							   and rc.RCdesde between lt.LTdesde and lt.LThasta
							   and lt.Tcodigo = tn.Tcodigo
							   and lt.RHJid = j.RHJid
							   and lt.Ecodigo = tn.Ecodigo
							   and tn.Ecodigo = j.Ecodigo
							   and tn.Ttipopago = 0
	</cfquery>
	
    <cfquery name="cantidad_dias" datasource="#Session.DSN#">		
		select <cf_dbfunction name="to_char" args="sum(PEcantdias)"> as cantidad
		from #vs_prefijo#PagosEmpleado a
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			and a.PEtiporeg = 0
			and a.PEmontores != 0
	</cfquery>	
   
	<cfif cantidad_horas.Ttipopago EQ 0>
		<cfset cantidad = #NumberFormat(cantidad_horas.cantidad,'___.__')#>
	<cfelse>
		<cfset cantidad = cantidad_dias.cantidad>
	</cfif>
		
	<!---====== Insertar en la temporal ======----->
	<cfif rsSalBrutoRelacion.RecordCount NEQ 0>
		<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,'#rsSalBrutoRelacion.CSdescripcion#',cantidad,rsSalBrutoRelacion.Monto,VN_CUENTALINEAS,1,
									arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden)>
					
	</cfif>
		<cfset salariobrutorelacion = rsSalBrutoRelacion.Monto>	
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
		select coalesce(sum(PEmontores),0) as Monto, 
				<cf_dbfunction name="to_char" args="sum(PEcantdias)"> as cantidad				
		from #vs_prefijo#PagosEmpleado a
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
		and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
		and a.PEtiporeg > 0
		and a.PEmontores != 0
	</cfquery>	
	<!---====== Insertar en la temporal ======----->
	<cfif rsRetroactivos.RecordCount NEQ 0 and rsRetroactivos.Monto NEQ 0>
		<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,'#LB_Retroactivos#','',rsRetroactivos.Monto,VN_CUENTALINEAS,1
									,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden)>
	</cfif>
	<cfif rsRetroactivos.RecordCount NEQ 0>
		<cfset retroactivos = rsRetroactivos.Monto>
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
		from #vs_prefijo#SalarioEmpleado 
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
</cffunction>
<!---============== FUNCION OBTIENE CARGAS LABORALES LAS INSERTA EN TEMPORAL ==============---->
<cffunction name="funcCargas">
	<cfargument name="DEid" type="numeric" required="yes">
	<cfargument name="RCNid" type="numeric" required="yes">
	<cfargument name="empleado" type="string" required="no">
	<cfargument name="cuenta" type="string" required="no">
	<cfargument name="etiquetacuenta" type="string" required="no">
	<cfargument name="departamento" type="string" required="no">
	<cfargument name="puntoventa" type="string" required="no">
	<cfargument name="orden" type="numeric" required="no">
	
	<cfquery name="rsCargas" datasource="#Session.DSN#">
		<!----select a.DClinea as DClinea, coalesce(CCvaloremp,0) as CCvaloremp, CCvalorpat, DCdescripcion, ECauto---->
		select 	sum(coalesce(CCvaloremp,0)) as CCvaloremp, 
				DCdescripcion,
				DEid	
		from #vs_prefijo#CargasCalculo a, DCargas b, ECargas c
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
		  and a.DClinea = b.DClinea
		  and b.ECid = c.ECid
		  <!----and CCvaloremp is not null---->
		  and CCvaloremp <> 0
		group by DEid,DCdescripcion    	
	</cfquery>
	<!---====== Insertar en la temporal ======----->
	<cfloop query="rsCargas">		
		<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,rsCargas.DCdescripcion,'',rsCargas.CCvaloremp,VN_CUENTALINEAS_2,2
									,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden)>
	</cfloop>	
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
		<!----
		select a.Did as Did, coalesce(a.DCvalor,0) as DCvalor, 
			   a.DCinteres, a.DCcalculo, b.Ddescripcion, 
			   b.Dvalor, b.Dmetodo, b.Dcontrolsaldo, b.Dreferencia
		----->
		select 	a.DEid,
				sum(coalesce(a.DCvalor,0)) as DCvalor, 
				b.Ddescripcion			   						   
		from #vs_prefijo#DeduccionesCalculo a, DeduccionesEmpleado b
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			and a.Did = b.Did
			and a.DCvalor != 0
		group by a.DEid,b.Ddescripcion	
		<!---order by b.Dreferencia--->
	</cfquery>
	<!---====== Insertar en la temporal ======----->
	<cfloop query="rsDeducciones">		
		<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,rsDeducciones.Ddescripcion,'',rsDeducciones.DCvalor,VN_CUENTALINEAS_2,2
									,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden)>
	</cfloop>		
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
															)"> as Valor
				<!----sum((case when CItipo < 2 then coalesce(ICvalor,0) else 0 end)) as Valor---->
		from #vs_prefijo#IncidenciasCalculo a, CIncidentes b
		where a.CIid = b.CIid
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			and a.ICmontores != 0
		group by a.DEid,
				 case when a.ICmontoant <> 0 then
					 <cf_dbfunction name="concat" args="'AJUSTE',' ',b.CIdescripcion">
				else
					b.CIdescripcion
				end
		<!---
		select 	a.DEid,
				b.CIdescripcion, 
				sum(coalesce(a.ICmontores,0)) as Monto, 
				sum((case when CItipo < 2 then ICvalor else 0 end)) as Valor,			   	
				sum(coalesce(a.ICmontores,0)) as ICmontores											
		from #vs_prefijo#IncidenciasCalculo a, CIncidentes b
		where a.CIid = b.CIid
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			and a.ICmontores != 0
		group by a.DEid,b.CIdescripcion
		---->			
	</cfquery>

	<cfif rsIncidenciasCalculo.recordCount GT 0>				
		<!---====== Insertar en la temporal ======----->
		<cfloop query="rsIncidenciasCalculo">		
			<cfset montoIncidencias = montoIncidencias + (rsIncidenciasCalculo.Monto)>
			<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,rsIncidenciasCalculo.CIdescripcion,'#rsIncidenciasCalculo.Valor#',rsIncidenciasCalculo.ICmontores,VN_CUENTALINEAS,1
										,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden)>
		</cfloop>
		<cfset montoIncidencias = montoIncidencias + Iif(Len(Trim(retroactivos)), DE(retroactivos), DE("0.00"))>
	<cfelse>
		<cfset montoIncidencias = 0.00 + Iif(Len(Trim(retroactivos)), DE(retroactivos), DE("0.00"))>
	</cfif>			
</cffunction>


<!---============== DATOS DE LA NOMINA ==============---->
<cfquery name="rsNomina" datasource="#Session.DSN#">
	select RCNid, c.CPfpago, a.RCdesde, a.RChasta, a.RCDescripcion, b.Tdescripcion
	from #vs_prefijo#RCalculoNomina a, TiposNomina b, CalendarioPagos c
	where a.Tcodigo = b.Tcodigo
	and a.RCNid = c.CPid
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
	and a.Ecodigo = b.Ecodigo
</cfquery>

<!---============== PARA C/EMPLEADO INSERTAR LOS DIFERENTES RUBROS EN LA TEMPORAL ==============---->
<cfset VN_ORDEN = 1><!---Valor de ordenamiento del query--->
<cfloop list="#chk#" index="id"><!---<cfloop query="rsEmpleadosNomina">--->
	<cfquery name="rsEncabEmpleado" datasource="#Session.DSN#"><!---Datos del empleado--->
		select {fn concat (ltrim(rtrim(coalesce(DEtarjeta,''))), {fn concat('   ',{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )})})}as nombreEmpl	, DEemail, DEidentificacion, NTIdescripcion
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
	
	<cfset VN_CUENTALINEAS = 1>		<!---Lineas de la columna izquierda (+)--->
	<cfset VN_CUENTALINEAS_2 = 1>	<!---Lineas de la columna derecha (-)--->		
	<cfset salariobrutorelacion = 0><!---Salario bruto del empleado--->
	<cfset montoIncidencias = 0><!---Monto sumatoria de incidencias--->
	<cfset retroactivos = 0>	<!---Monto sumatoria retroactivos--->
	<cfset pagos = 0>			<!---Monto Devengado por el empleado--->
	<cfset deducciones = 0>		<!---Monto sumatoria de las deducciones--->
	<cfset liquido = 0>			<!---Monto salario liquido (Devengado - Deducciones)--->
		
	<cfset ejecuta = funcSalBrutoRelacion(id,CPid,rsEncabEmpleado.nombreEmpl,rsEncabEmpleado.cuenta,rsEncabEmpleado.EtiquetaCuenta,rsDepto.Ddescripcion,rsEncabEmpleado.DEinfo1,VN_ORDEN)><!---Salario bruto relacion (+)--->
	<cfset ejecuta = funcRetroactivos(id,CPid,rsEncabEmpleado.nombreEmpl,rsEncabEmpleado.cuenta,rsEncabEmpleado.EtiquetaCuenta,rsDepto.Ddescripcion,rsEncabEmpleado.DEinfo1,VN_ORDEN)><!---Retroactivos(+)--->
	<cfset ejecuta =  funcIncidencias(id,CPid,rsEncabEmpleado.nombreEmpl,rsEncabEmpleado.cuenta,rsEncabEmpleado.EtiquetaCuenta,rsDepto.Ddescripcion,rsEncabEmpleado.DEinfo1,VN_ORDEN)><!---Incidencias(+)--->	 
	<cfset ejecuta =  funcSalarioEmpleado(id,CPid,rsEncabEmpleado.nombreEmpl,rsEncabEmpleado.cuenta,rsEncabEmpleado.EtiquetaCuenta,rsDepto.Ddescripcion,rsEncabEmpleado.DEinfo1,VN_ORDEN)><!---Salario empleado(-)--->
	<cfset ejecuta =  funcCargas(id,CPid,rsEncabEmpleado.nombreEmpl,rsEncabEmpleado.cuenta,rsEncabEmpleado.EtiquetaCuenta,rsDepto.Ddescripcion,rsEncabEmpleado.DEinfo1,VN_ORDEN)><!---Cargas laborales empleado(-)--->
	<cfset ejecuta =  funcDeducciones(id,CPid,rsEncabEmpleado.nombreEmpl,rsEncabEmpleado.cuenta,rsEncabEmpleado.EtiquetaCuenta,rsDepto.Ddescripcion,rsEncabEmpleado.DEinfo1,VN_ORDEN)><!---Deducciones empleado(-)--->	

	<cfif salariobrutorelacion NEQ "" and montoIncidencias NEQ "">
		<cfset pagos = salariobrutorelacion + montoIncidencias><!---Salario devengado (+)---->
		<cfset liquido = (salariobrutorelacion + montoIncidencias) - (deducciones)><!---Neto---->
	</cfif>
	
	<cfquery datasource="#session.DSN#"><!---Actualizar montos generales (Devengado,Deducido,Neto)--->
		update #TMPConceptosX#
			set devengado = <cfqueryparam cfsqltype="cf_sql_money" value="#pagos#">,
				deducido = <cfqueryparam cfsqltype="cf_sql_money" value="#deducciones#">,
				neto = <cfqueryparam cfsqltype="cf_sql_money" value="#liquido#">,
				lineasEmp = (select count(1) from #TMPConceptosX#
							where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
								and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
							)
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
	</cfquery>	

	<cfset VN_ORDEN = VN_ORDEN + 1><!---Ordenamiento de los datos para mantener el order by del query rsEmpleadosNomina segun los filtros de la consulta---->
</cfloop>


<cfquery name="rsEtiquetaPie" datasource="#session.DSN#">
	select Mensaje from MensajeBoleta 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
</cfquery>

<cfquery name="ConceptosPago" datasource="#session.DSN#">
	select *
	from #TMPConceptosX#
	where devengado != 0
	order by orden,DEid,linea
</cfquery>
<!-----==========================================================================================--->
<!-----================================= FIN DE OBTENER LOS DATOS ===============================----->
<!-----==========================================================================================--->

<!-----==========================================================================================--->
<!-----================================= GENERAR ARCHIVO DE DATOS ===============================----->
<!-----==========================================================================================--->
<style>
	td{font-family:"Courier New", Courier, monospace; font-size:14pt;}
</style>
<!---Traduccion--->
<cfinvoke  Key="LB_Boleta_Pago" Default="Boleta de Pago" returnvariable="LB_Boleta_Pago" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Boleta_Pago" Default="Boleta de Pago" returnvariable="LB_Boleta_Pago" component="sif.Componentes.Translate" method="Translate"/>											
<cfinvoke  Key="LB_NombreEmpleado" Default="Nombre Empleado" returnvariable="LB_NombreEmpleado" component="sif.Componentes.Translate" method="Translate"/>											
<cfinvoke  Key="LB_CentroFuncional" Default="Centro Funcional" returnvariable="LB_CentroFuncional" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Devengado" Default="Devengado" returnvariable="LB_Devengado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Nomina" Default="Nómina" returnvariable="LB_Nomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Deducciones" Default="Deducciones" returnvariable="LB_Deducciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Periodo" Default="Periodo" returnvariable="LB_Periodo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Del" Default="Del" returnvariable="LB_Del" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_al" Default="al" returnvariable="LB_al" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Neto" Default="Neto" returnvariable="LB_Neto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Ingresos" Default="Ingresos" returnvariable="LB_Ingresos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Cantidad" Default="Cantidad" returnvariable="LB_Cantidad" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke  Key="LB_Monto" Default="Monto" returnvariable="LB_Monto" component="sif.Componentes.Translate" method="Translate"/>

<cfset lineaslleva = 0>	<!---Lineas por boleta--->
<cfset lineaspagina = 0><!---Lineas por pagina--->
<cfset boletas = 1>		<!---Total de paginas de todo--->

<cfset hilera = ''>

<cfoutput query="ConceptosPago" group="DEid">	
	<!---=================== ENCABEZADO ===================---->	
	<cfquery name="rsEmpleado" datasource="#session.DSN#">
		select <cf_dbfunction name="concat" args="DEapellido1,' ',DEapellido2,' ',DEnombre"> as empleado
		from DatosEmpleado
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptosPago.DEid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif ConceptosPago.CurrentRow EQ 1>
		<cfset hilera = hilera & '#chr(27)##chr(67)##chr(33)#'>
	</cfif>
	<cfset hilera = hilera & '#trim(session.Enombre)#'& IIf(len(trim(session.Enombre)) LT 69, DE(RepeatString(' ', 69-(len(trim(session.Enombre))))), DE(''))>		
	<cfset hilera = hilera & '#LSDateFormat(now(),'dd-mm-yyyy')# #LSTimeFormat(Now(),'hh:mm:ss')#'>		
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	<cfset hilera = hilera & '#trim(LB_Boleta_Pago)#'& IIf(len(trim(LB_Boleta_Pago)) LT 88, DE(RepeatString(' ', 88-(len(trim(LB_Boleta_Pago))))), DE(''))>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	<!---
	<cfset hilera = hilera & RepeatString(' ', 88)><!---Linea en blanco---->
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	---->			
	<!---Nombre Empleado---->
	<cfif len(trim(LB_NombreEmpleado)) GTE 16>
		<cfset hilera = hilera & '#trim(Mid(LB_NombreEmpleado,1,16))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_NombreEmpleado)#' & IIf(len(trim(LB_NombreEmpleado)) LT 16, DE(RepeatString(' ', 16-(len(trim(LB_NombreEmpleado))))), DE('')) & ': '>
	</cfif>
	<cfif len(trim(rsEmpleado.empleado)) GTE 42>
		<cfset hilera = hilera & '#trim(Mid(rsEmpleado.empleado,1,42))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(rsEmpleado.empleado)#' & IIf(len(trim(rsEmpleado.empleado)) LT 42, DE(RepeatString(' ', 42-(len(trim(rsEmpleado.empleado))))), DE(''))>
	</cfif>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
	<!----Centro Funcional/Devengado--->	
	<cfif len(trim(LB_CentroFuncional)) GTE 16>
		<cfset hilera = hilera & '#trim(Mid(LB_CentroFuncional,1,16))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_CentroFuncional)#' & IIf(len(trim(LB_CentroFuncional)) LT 16, DE(RepeatString(' ', 16-(len(trim(LB_CentroFuncional))))), DE('')) & ': '>
	</cfif>
	<cfif len(trim(ConceptosPago.departamento)) GTE 42>
		<cfset hilera = hilera & '#trim(Mid(ConceptosPago.departamento,1,42))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(ConceptosPago.departamento)#' & IIf(len(trim(ConceptosPago.departamento)) LT 42, DE(RepeatString(' ', 42-(len(trim(ConceptosPago.departamento))))), DE(''))>
	</cfif>
	<cfif len(trim(LB_Devengado)) GTE 11>
		<cfset hilera = hilera & '#trim(Mid(LB_Devengado,1,11))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Devengado)#' & IIf(len(trim(LB_Devengado)) LT 11, DE(RepeatString(' ', 11-(len(trim(LB_Devengado))))), DE('')) & ': '>
	</cfif>
	<cfif len(trim(ConceptosPago.devengado)) GTE 15>
		<cfset hilera = hilera & '#trim(Mid(LSNumberFormat(ConceptosPago.devengado, '999,999,999,999,999.99'),1,15))#'>
	<cfelse>
		<cfset hilera = hilera &  IIf(len(trim(LSNumberFormat(ConceptosPago.devengado, '999,999,999,999,999.99'))) LT 15, DE(RepeatString(' ', 15-(len(trim(LSNumberFormat(ConceptosPago.devengado, '999,999,999,999,999.99')))))), DE('')) & '#trim(LSNumberFormat(ConceptosPago.devengado, '999,999,999,999,999.99'))#'>
	</cfif>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>		
	<!----Nomina/Deducciones--->
	<cfif len(trim(LB_Nomina)) GTE 16>
		<cfset hilera = hilera & '#trim(Mid(LB_Nomina,1,16))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Nomina)#' & IIf(len(trim(LB_Nomina)) LT 16, DE(RepeatString(' ', 16-(len(trim(LB_Nomina))))), DE('')) & ': '>
	</cfif>
	<cfif len(trim(ConceptosPago.nomina)) GTE 42>
		<cfset hilera = hilera & '#trim(Mid(ConceptosPago.nomina,1,42))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(ConceptosPago.nomina)#' & IIf(len(trim(ConceptosPago.nomina)) LT 42, DE(RepeatString(' ', 42-(len(trim(ConceptosPago.nomina))))), DE(''))>
	</cfif>
	<cfif len(trim(LB_Deducciones)) GTE 11>
		<cfset hilera = hilera & '#trim(Mid(LB_Deducciones,1,11))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Deducciones)#' & IIf(len(trim(LB_Deducciones)) LT 11, DE(RepeatString(' ', 11-(len(trim(LB_Deducciones))))), DE('')) & ': '>
	</cfif>
	<cfif len(trim(ConceptosPago.deducido)) GTE 15>
		<cfset hilera = hilera & '#trim(Mid(LSNumberFormat(ConceptosPago.deducido, '999,999,999,999,999.99'),1,15))#'>		
	<cfelse>
		<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(ConceptosPago.deducido, '999,999,999,999,999.99'))) LT 15, DE(RepeatString(' ', 15-(len(trim(LSNumberFormat(ConceptosPago.deducido, '999,999,999,999,999.99')))))), DE('')) & '#trim(LSNumberFormat(ConceptosPago.deducido, '999,999,999,999,999.99'))#'>
	</cfif>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>		
	<!----Periodo/Neto ---->
	<cfif len(trim(LB_Periodo)) GTE 16>
		<cfset hilera = hilera & '#trim(Mid(LB_Periodo,1,16))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Periodo)#' & IIf(len(trim(LB_Periodo)) LT 16, DE(RepeatString(' ', 16-(len(trim(LB_Periodo))))), DE('')) & ': '>
	</cfif>
	<cfset hilera = hilera & '#trim(LB_Del)# #LSDateFormat(desdenomina,'dd/mm/yyyy')# #trim(LB_al)# #LSDateFormat(hastanomina,'dd/mm/yyyy')#' & RepeatString(' ',14)>	
	<cfif len(trim(LB_Neto)) GTE 11>
		<cfset hilera = hilera & '#trim(Mid(LB_Neto,1,11))#: '>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Neto)#' & IIf(len(trim(LB_Neto)) LT 11, DE(RepeatString(' ', 11-(len(trim(LB_Neto))))), DE('')) & ': '>
	</cfif>
	<cfif len(trim(ConceptosPago.neto)) GTE 15>
		<cfset hilera = hilera & '#trim(Mid(LSNumberFormat(ConceptosPago.neto, '999,999,999,999,999.99'),1,15))#'>		
	<cfelse>
		<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(ConceptosPago.neto, '999,999,999,999,999.99'))) LT 15, DE(RepeatString(' ', 15-(len(trim(LSNumberFormat(ConceptosPago.neto, '999,999,999,999,999.99')))))), DE('')) & '#trim(LSNumberFormat(ConceptosPago.neto, '999,999,999,999,999.99'))#'>
	</cfif>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	<cfset hilera = hilera & RepeatString(' ', 88)><!---Linea en blanco---->
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>		
	<!---Etiquetas detalle componentes--->
	<cfif len(trim(LB_Ingresos)) GTE 22>
		<cfset hilera = hilera & '#trim(Mid(LB_Ingresos,1,22))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Ingresos)#' & IIf(len(trim(LB_Ingresos)) LT 22, DE(RepeatString(' ', 22-(len(trim(LB_Ingresos))))), DE(''))>
	</cfif>
	<cfif len(trim(LB_Cantidad)) GTE 8>
		<cfset hilera = hilera & '#trim(Mid(LB_Cantidad,1,8))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Cantidad)#' & IIf(len(trim(LB_Cantidad)) LT 8, DE(RepeatString(' ', 8-(len(trim(LB_Cantidad))))), DE(''))>
	</cfif>
	<cfif len(trim(LB_Monto)) GTE 14>
		<cfset hilera = hilera & '#trim(Mid(LB_Monto,1,13))# '>	
	<cfelse>
		<cfset hilera = hilera & IIf(len(trim(LB_Monto)) LT 14, DE(RepeatString(' ', 14-(len(trim(LB_Monto))))), DE('')) & '#trim(LB_Monto)# '>
	</cfif>		
	<cfif len(trim(LB_Deducciones)) GTE 28>
		<cfset hilera = hilera & '#trim(Mid(LB_Deducciones,1,28))#'>
	<cfelse>
		<cfset hilera = hilera & '#trim(LB_Deducciones)#' & IIf(len(trim(LB_Deducciones)) LT 28, DE(RepeatString(' ', 28-(len(trim(LB_Deducciones))))), DE('')) >
	</cfif>
	<cfif len(trim(LB_Monto)) GTE 14>
		<cfset hilera = hilera & ' #trim(Mid(LB_Monto,1,14))#'>
	<cfelse>
		<cfset hilera = hilera & IIf(len(trim(LB_Monto)) LT 14, DE(RepeatString(' ', 14-(len(trim(LB_Monto))))), DE('')) & ' #trim(LB_Monto)#'>
	</cfif>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	<cfset hilera = hilera & RepeatString('-', 88)>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
	<!---=================== DETALLE ===================---->
	<cfset contador = 0><!---Contador de cantidad de conceptos (Maximo 12)---->
	<cfoutput>
		<cfif contador LTE 12>
			<!---Ingresos--->
			<cfif len(trim(ConceptosPago.descconcepto)) GTE 21>
				<cfset hilera = hilera & '#trim(Mid(ConceptosPago.descconcepto,1,21))# '>
			<cfelse>
				<cfset hilera = hilera & '#trim(ConceptosPago.descconcepto)#' & IIf(len(trim(ConceptosPago.descconcepto)) LT 22, DE(RepeatString(' ', 22-(len(trim(ConceptosPago.descconcepto))))), DE(''))>
			</cfif>
			<cfif len(trim(ConceptosPago.cantconcepto)) GTE 8>
				<cfset hilera = hilera & '#trim(Mid(ConceptosPago.cantconcepto,1,8))#'>
			<cfelse>
				<cfset hilera = hilera & '#trim(ConceptosPago.cantconcepto)#' & IIf(len(trim(ConceptosPago.cantconcepto)) LT 8, DE(RepeatString(' ', 8-(len(trim(ConceptosPago.cantconcepto))))), DE(''))>
			</cfif>
					
			<cfif len(trim(ConceptosPago.montoconcepto)) GTE 14>
				<cfset hilera = hilera & '#trim(Mid(LSNumberFormat(ConceptosPago.montoconcepto,'999,999,999,999,999.99'),1,14))# '>			
			<cfelse>
				<cfif ConceptosPago.montoconcepto NEQ 0 and len(trim(ConceptosPago.descconcepto)) NEQ 0>
					<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(ConceptosPago.montoconcepto,'999,999,999,999,999.99'))) LT 14, DE(RepeatString(' ', 14-(len(trim(LSNumberFormat(ConceptosPago.montoconcepto,'999,999,999,999,999.99')))))), DE('')) & '#trim(LSNumberFormat(ConceptosPago.montoconcepto,'999,999,999,999,999.99'))# '>
				<cfelseif len(trim(ConceptosPago.descconcepto)) NEQ 0>
					<cfset hilera = hilera & IIf(len(trim(LSNumberFormat(ConceptosPago.montoconcepto,'999,999,999,999,999.99'))) LT 14, DE(RepeatString(' ', 14-(len(trim(LSNumberFormat(ConceptosPago.montoconcepto,'999,999,999,999,999.99')))))), DE('')) & '#trim(LSNumberFormat(ConceptosPago.montoconcepto,'999,999,999,999,999.99'))# '>
				<cfelse>
					<cfset hilera = hilera & RepeatString(' ',15)> 
				</cfif>
			</cfif>

			<!---Deducciones---->		
			<cfset vn_concepto ='#ConceptosPago.descconceptoB#'>
			<cfif len(trim(ConceptosPago.descconceptoB)) NEQ 0 and trim(ConceptosPago.montoconceptoB) LT 0 >	
				<cfset vn_concepto = 'DEVOLUCION #ConceptosPago.descconceptoB#' >
			</cfif>	
			<cfif len(trim(vn_concepto)) GTE 28>
				<cfset hilera = hilera & '#trim(Mid(vn_concepto,1,28))#'>
			<cfelse>
				<cfset hilera = hilera & '#trim(vn_concepto)#' & IIf(len(trim(vn_concepto)) LT 28, DE(RepeatString(' ', 28-(len(trim(vn_concepto))))), DE('')) >
			</cfif>	
			
			<!---
			<cfif len(trim(ConceptosPago.descconceptoB)) GTE 28>
				<cfset hilera = hilera & '#trim(Mid(ConceptosPago.descconceptoB,1,28))#'>
			<cfelse>
				<cfset hilera = hilera & '#trim(ConceptosPago.descconceptoB)#' & IIf(len(trim(ConceptosPago.descconceptoB)) LT 28, DE(RepeatString(' ', 28-(len(trim(ConceptosPago.descconceptoB))))), DE('')) >
			</cfif>		
			----->
			<cfif len(trim(ConceptosPago.montoconceptoB)) GTE 14>
				<cfset hilera = hilera & ' #trim(Mid(ConceptosPago.montoconceptoB,1,14))#'>			
			<cfelse>
				<cfif ConceptosPago.montoconceptoB NEQ 0 and len(trim(ConceptosPago.descconceptoB)) NEQ 0>
					<cfset hilera = hilera & IIf(len(trim(trim(LSNumberFormat(ConceptosPago.montoconceptoB,'999,999,999,999,999.99')))) LT 14, DE(RepeatString(' ', 14-(len(trim(trim(LSNumberFormat(ConceptosPago.montoconceptoB,'999,999,999,999,999.99'))))))), DE('')) & ' #trim(LSNumberFormat(ConceptosPago.montoconceptoB,'999,999,999,999,999.99'))#'>
				<cfelseif len(trim(ConceptosPago.descconceptoB)) NEQ 0>
					<cfset hilera = hilera & IIf(len(trim(trim(LSNumberFormat(ConceptosPago.montoconceptoB,'999,999,999,999,999.99')))) LT 14, DE(RepeatString(' ', 14-(len(trim(trim(LSNumberFormat(ConceptosPago.montoconceptoB,'999,999,999,999,999.99'))))))), DE('')) & ' #trim(LSNumberFormat(ConceptosPago.montoconceptoB,'999,999,999,999,999.99'))#'>
				<cfelse>
					<cfset hilera = hilera & RepeatString(' ',15)> 
				</cfif>
			</cfif>
			<cfset hilera = hilera & '#chr(13)##chr(10)#'>
		</cfif> 	
		<cfset contador = contador+1>
	</cfoutput>			
	<!---Rellenar---->
	<cfif contador LT 14>
		<cfset cantrellenar= 14-contador>
		<cfloop index="i" from="1" to="#cantrellenar#">
			<cfset hilera = hilera & RepeatString(' ', 88)>
			<cfset hilera = hilera & '#chr(13)##chr(10)#'>				
			<!---<cfset hilera = hilera & 'Contador:#contador#'>
			<cfset hilera = hilera & '#chr(13)##chr(10)#'>---->
		</cfloop>	
	</cfif>
	<cfset hilera = hilera & RepeatString('-', 88)>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	<!----Mensaje---->
	<cfset hilera = hilera & '#trim(Mid(HTMLEditFormat(rsEtiquetaPie.Mensaje),1,88))#'>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	<cfset hilera = hilera & '#trim(Mid(HTMLEditFormat(rsEtiquetaPie.Mensaje),89,88))#'>
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
	<cfset hilera = hilera & '#trim(Mid(HTMLEditFormat(rsEtiquetaPie.Mensaje),177,88))#'>
	<!---Rellenar para alcanzar 28 lineas--->		
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>	
	<cfset hilera = hilera & RepeatString(' ', 88)>
	<!---Agregar chr(27) chr(12) al final de c/boleta para forzar salto de pagina--->
	<cfset hilera = hilera & '#chr(27)##chr(12)#'>	
	<!---<cfset hilera = hilera & '#chr(13)##chr(10)#'>--->
	<!----Agregar chr(27) chr(67) chr(33)---->
	<!----<cfset hilera = hilera & '#chr(27)##chr(67)##chr(33)#'>--->
</cfoutput>
<!----======== Guarda la linea en el archivo txt ========---->
<cfset archivo = "#trim(session.Usucodigo)#_#hour(now())##minute(now())##second(now())#">
<cfset txtfile = GetTempFile(getTempDirectory(), 'BOLETA')>	
<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">
<cfheader name="Content-Disposition" value="attachment;filename=BoletasPago.txt">
<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">
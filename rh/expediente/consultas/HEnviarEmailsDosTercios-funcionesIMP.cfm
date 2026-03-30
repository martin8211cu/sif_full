	<!--- FUNCIONES--->
<cffunction name="funcInsertaLinea" >
	<cfargument name="DEid" type="numeric">
	<cfargument name="RCNid" type="numeric">
	<cfargument name="descconcepto" type="string" default="">
	<cfargument name="cantconcepto" type="string" default="0">
	<cfargument name="montoconcepto" type="numeric" default="0">
	<cfargument name="linea" type="numeric" default="0">
	<cfargument name="columna" type="numeric" default="1">
	<cfargument name="saldoDeducc" type="numeric" defalut="0" required="no" >
	<cfargument name="controlaSaldo" type="numeric" defalut="0" required="no" >

	<cfif arguments.columna EQ 1>
		<cfquery datasource="#session.DSN#">
			insert into #TMPConceptosRX# (DEid,RCNid,descconcepto,cantconcepto,montoconcepto,linea,columna,nomina,
										desdenomina,hastanomina,empleado,cuenta,departamento,puntoventa,EtiquetaCuenta, saldoDeducc, controlaSaldo)
			values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.descconcepto)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cantconcepto#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.montoconcepto#">,				
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.linea#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.columna#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(RCalculoNomina.RCDescripcion)#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#trim(RCalculoNomina.RCdesde)#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#trim(RCalculoNomina.RChasta)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabEmpleado.nombreEmpl#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabEmpleado.cuenta#">,					
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDepto.Ddescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabEmpleado.DEinfo1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabEmpleado.EtiquetaCuenta#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.saldoDeducc#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.controlaSaldo#">
					)
		</cfquery>
		<cfset VN_CUENTALINEAS = VN_CUENTALINEAS + 1><!---Aumentar las lineas columna 1--->	
	<cfelse>
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select 1 from #TMPConceptosRX#
			where columna = 1
				and linea = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.linea#">
		</cfquery>
		<cfif rsExiste.RecordCount NEQ 0>
			<cfquery datasource="#session.DSN#">
				update #TMPConceptosRX#
					set descconceptoB = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.descconcepto)#">,
						cantconceptoB = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cantconcepto#">,
						montoconceptoB = <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.montoconcepto#">,
						saldoDeducc = <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.saldoDeducc#">,
						controlaSaldo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.controlaSaldo#">
				where columna = 1
					and linea = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.linea#">
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.DSN#">
				insert into #TMPConceptosRX# (DEid,RCNid,descconceptoB,cantconceptoB,montoconceptoB,linea,columna,nomina,
										desdenomina,hastanomina,empleado,cuenta,departamento,puntoventa,EtiquetaCuenta, saldoDeducc, controlaSaldo)
				values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.descconcepto)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cantconcepto#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.montoconcepto#">,				
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.linea#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.columna#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(RCalculoNomina.RCDescripcion)#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#trim(RCalculoNomina.RCdesde)#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#trim(RCalculoNomina.RChasta)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabEmpleado.nombreEmpl#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabEmpleado.cuenta#">,					
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDepto.Ddescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabEmpleado.DEinfo1#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabEmpleado.EtiquetaCuenta#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.saldoDeducc#">,
					    <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.controlaSaldo#">
						)
			</cfquery>
		</cfif>
		<cfset VN_CUENTALINEAS_2 = VN_CUENTALINEAS_2 + 1><!---Aumentar las lineas columna 2--->	
	</cfif>		
</cffunction>

<cffunction access="private" name="prepararCorreo" output="true" returntype="string">
	<!--- PARÃMETROS--->
	<cfargument name="DEid" required="yes" type="numeric">
	<cfargument name="RCNid" required="yes" type="numeric">
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" 
	key="LB_Boleta_Pago"
	Default="Boleta de Pago"
	returnvariable="LB_Boleta"/> 
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" 
	key="LB_SalarioBruto"
	Default="Salario bruto"
	returnvariable="LB_SalarioBruto"/> 
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" 
	key="LB_Retroactivos"
	Default="RETROACTIVOS"
	returnvariable="LB_Retroactivos"/> 
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" 
	key="LB_Renta"
	Default="IMPUESTO RENTA EMPLEADOS"
	returnvariable="LB_Renta"/> 

	<cfquery name="nombre" datasource="#session.DSN#">
		select CSdescripcion as salario
		from ComponentesSalariales
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and CSsalariobase = 1
	</cfquery>
	<cfif isdefined("nombre") and nombre.RecordCount NEQ 0>
		<cfset LB_SalarioBruto = nombre.salario>
	</cfif>

	<!---============================================================ TABLA TEMPORAL DE TRABAJO ============================================================---->
	<cf_dbtemp name="TMPConceptos2RX" returnvariable="TMPConceptosRX" datasource="#session.DSN#">
	   <cf_dbtempcol name="DEid"			type="numeric"  mandatory="yes">
	   <cf_dbtempcol name="RCNid"			type="numeric"  mandatory="yes">
	   <cf_dbtempcol name="descconcepto"	type="varchar(255)"	mandatory="no">
	   <cf_dbtempcol name="saldoDeducc"     type="money"	mandatory="no">
   	   <cf_dbtempcol name="controlaSaldo"	type="numeric"  mandatory="no">   
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
	   
	    <cf_dbtempcol name="lineasEmp"       type="int"		mandatory="no">

	</cf_dbtemp>
	
	<cfset VN_CUENTALINEAS = 1>
	<cfset VN_CUENTAPAGINAS = 1>
	<cfset VN_CUENTALINEAS_2 = 1>
	
	<!---Obtener cual formato de boleta se esta usando----->
	<cfquery name="rsParametro" datasource="#session.DSN#">
		select coalesce(Pvalor,'10') as Pvalor
		from RHParametros 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 720
	</cfquery>
	
	<cfquery name="rsEncabEmpleado" datasource="#Session.DSN#">
		select 	{fn concat (ltrim(rtrim(coalesce(DEtarjeta,''))), {fn concat('   ',{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )})})}as nombreEmpl	, DEemail, DEidentificacion, NTIdescripcion
				,DEinfo1
				,case CBTcodigo when 1 then '<b>Cuenta de Ahorros No:</b>' else '<b>Cuenta Corriente No:</b>' end as EtiquetaCuenta
				,de.DEcuenta as cuenta
				,{fn concat('El monto detallado en este documento fuÃ© depositado a su cuenta ', 
					{fn concat(case CBTcodigo when 1 then 'de Ahorros No.' else 'Corriente No.' end, de.DEcuenta)}
				)} as Etiqueta2
		from DatosEmpleado de, NTipoIdentificacion ti
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and de.NTIcodigo = ti.NTIcodigo
	</cfquery>
	
	<cfset Titulo = "#LB_Boleta#: " & RCalculoNomina.RCDescripcion & ' - '& rsEncabEmpleado.nombreEmpl>
	
	<!----======== DEPARTAMENTO ========--->
	<cfquery name="rsDepto" datasource="#session.DSN#">
		select 	b.Dcodigo,			
				d.Deptocodigo, d.Ddescripcion
		from LineaTiempo a
			inner join RHPlazas b
				on  a.RHPid = b.RHPid
			inner join CFuncional c
				on b.CFid = c.CFid
			left outer join Departamentos d
				on c.Dcodigo = d.Dcodigo
				and c.Ecodigo = d.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">		
			<!----and a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
			and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">---->
			and LTdesde = (Select max(LTdesde) 
							from LineaTiempo e 
							where a.DEid = e.DEid
								and e.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
								and e.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">)
	</cfquery>	
	
	<cfquery name="rsSalBrutoMensual" datasource="#Session.DSN#">
		select coalesce(PEsalario,0) as PEsalario
		from HPagosEmpleado a
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and a.PEtiporeg = 0
		and a.PEdesde = (
			select max(PEdesde)
			from PagosEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			and PEtiporeg = 0
		)
	</cfquery>
	
	<cfquery name="rsSalBrutoRelacion" datasource="#Session.DSN#">
		select coalesce(sum(PEmontores),0) as Monto,<cf_dbfunction name="to_char" args="sum(PEcantdias)"> as cantidad
		from HPagosEmpleado a
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			and a.PEtiporeg = 0
			and a.PEsalario != 0
	</cfquery>
	
	<!---====== Insertar en la temporal ======----->	
	<cfif rsSalBrutoRelacion.RecordCount NEQ 0>
		<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,'#LB_SalarioBruto#','#rsSalBrutoRelacion.cantidad#',rsSalBrutoRelacion.Monto,VN_CUENTALINEAS,1,0,0)>
	</cfif>
	
	<cfquery name="rsRetroactivos" datasource="#Session.DSN#">
		select coalesce(sum(PEmontores),0) as Monto, <cf_dbfunction name="to_char" args="sum(PEcantdias)"> as cantidad
		from HPagosEmpleado a
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and a.PEtiporeg > 0
	</cfquery>

	<!---====== Insertar en la temporal ======----->
	<cfif rsRetroactivos.RecordCount NEQ 0 and rsRetroactivos.Monto NEQ 0>
		<cfif rsParametro.Pvalor EQ 30><!----Cuando el calculo es para la boleta de 1/2 de Coopelesca--->
			<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,'#LB_Retroactivos#','',rsRetroactivos.Monto,VN_CUENTALINEAS,1,0,0)>
		<cfelse>
			<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,'#LB_Retroactivos#','#rsRetroactivos.cantidad#',rsRetroactivos.Monto,VN_CUENTALINEAS,1,0,0)>
		</cfif>
	</cfif>
	
	<cfquery name="rsSalarioEmpleado" datasource="#Session.DSN#">
		select SErenta, SEcargasempleado, SEdeducciones
		from HSalarioEmpleado 
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
	</cfquery>
	
	<!---====== Insertar en la temporal ======----->
	<cfif rsSalarioEmpleado.RecordCount NEQ 0 and rsSalarioEmpleado.SErenta NEQ 0>
		<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,'#LB_Renta#','',rsSalarioEmpleado.SErenta,VN_CUENTALINEAS_2,2,0,0)>
	</cfif>
		
	<cfif rsParametro.Pvalor EQ 30><!----Cuando el calculo es para la boleta de 1/2 de Coopelesca--->
		<cfquery name="rsIncidenciasCalculo" datasource="#Session.DSN#">
			select 	a.DEid,
					case when a.ICmontoant <> 0 then
						<cf_dbfunction name="concat" args="'AJUSTE',' ',b.CIdescripcion">
					else
						b.CIdescripcion
					end as CIdescripcion,	 					
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
															)"> as ICvalor
					<!----sum((case when CItipo < 2 then coalesce(a.ICvalor,0)
						else 0 end)
					  ) as ICvalor---->
			from HIncidenciasCalculo a, CIncidentes b
			where a.CIid = b.CIid
				and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and a.ICmontores != 0
			group by a.DEid,
					 case when a.ICmontoant <> 0 then
						 <cf_dbfunction name="concat" args="'AJUSTE',' ',b.CIdescripcion">
					else
						b.CIdescripcion
					end	
		</cfquery>
	<cfelse>	
		<cfquery name="rsIncidenciasCalculo" datasource="#Session.DSN#">
			<!---
			select  <cf_dbfunction name="to_char" args="ICid"  > as ICid, b.CIdescripcion, a.ICfecha, 
				   (case when CItipo < 2 then a.ICvalor
					else null end) as ICvalor, 
				   (case when (CItipo < 2 and a.ICvalor > 0) then round(a.ICmontores/(a.ICvalor*1.00), 2) 
						 when (CItipo = 3 and a.ICvalor > 0) then a.ICvalor
				   else null end) as ICvalorcalculado, 
				   a.ICmontores, a.ICcalculo
			----->	
			select  a.DEid,
					b.CIdescripcion, 
				   sum((case when CItipo < 2 then a.ICvalor
						else 0 end)
					  ) as ICvalor, 			   
				   sum(coalesce(a.ICmontores,0)) as ICmontores
			from HIncidenciasCalculo a, CIncidentes b
			where a.CIid = b.CIid
				and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and a.ICmontores != 0
			group by a.DEid,b.CIdescripcion
			<!----order by b.CIcodigo--->
		</cfquery>
	</cfif><!---Fin del parametro 30--->
	
	<cfif rsIncidenciasCalculo.recordCount GT 0>
		<cfquery name="rsSumIncidencias" dbtype="query">
			select sum(ICmontores) as Monto
			from rsIncidenciasCalculo
		</cfquery>
		
		<cfset montoIncidencias = rsSumIncidencias.Monto + Iif(Len(Trim(rsRetroactivos.Monto)), DE(rsRetroactivos.Monto), DE("0.00"))>
		
		<!---====== Insertar en la temporal ======----->
		<cfloop query="rsIncidenciasCalculo">		
			<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,rsIncidenciasCalculo.CIdescripcion,'#rsIncidenciasCalculo.ICvalor#',rsIncidenciasCalculo.ICmontores,VN_CUENTALINEAS,1,0,0)>
		</cfloop>
	
	<cfelse>
		<cfset montoIncidencias = 0.00 + Iif(Len(Trim(rsRetroactivos.Monto)), DE(rsRetroactivos.Monto), DE("0.00"))>
	</cfif>			
	
	<cfquery name="rsTotalesResumido" dbtype="query">
		select #rsSalBrutoRelacion.Monto# + #montoIncidencias# as Pagos,
			   SErenta + SEcargasempleado + SEdeducciones as Deducciones,
			   (#rsSalBrutoRelacion.Monto# + #montoIncidencias#) - (SErenta + SEcargasempleado + SEdeducciones) as Liquido
		from rsSalarioEmpleado
	</cfquery>
	
	<cfquery name="rsCargas" datasource="#Session.DSN#">
		<!---
		select 	<cf_dbfunction name="to_char" args="a.DClinea"  >  as DClinea, 
				CCvaloremp, 
				CCvalorpat, 
				DCdescripcion, 
				ECauto
		---->
		select 	sum(coalesce(CCvaloremp,0)) as CCvaloremp, 
				DCdescripcion
		from HCargasCalculo a, DCargas b, ECargas c
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		  and a.DClinea = b.DClinea
		  and b.ECid = c.ECid
		  and CCvaloremp is not null
		  and CCvaloremp <> 0
		group by DCdescripcion  
	</cfquery>
	
	<!---====== Insertar en la temporal ======----->
	<cfloop query="rsCargas">	
		<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,rsCargas.DCdescripcion,'',rsCargas.CCvaloremp,VN_CUENTALINEAS_2,2,0,0)>
	</cfloop>
	
	<cfquery name="rsSumCargas" dbtype="query">
		select sum(CCvaloremp) as cargas
		from rsCargas
	</cfquery>
	<cfif rsSumCargas.recordCount GT 0>
		<cfset SumCargas = rsSumCargas.cargas>
	<cfelse>
		<cfset SumCargas = 0.00>
	</cfif>
	
	<cfquery name="rsDeducciones" datasource="#Session.DSN#">				
		select 	sum(a.DCvalor) as DCvalor, 
				b.Ddescripcion, 
				b.Dreferencia,
					
				b.Dcontrolsaldo,
				b.Did   		
								
		from HDeduccionesCalculo a, DeduccionesEmpleado b
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and a.Did = b.Did
		group by 	b.Ddescripcion, 
					b.Dreferencia,						
					b.Dcontrolsaldo,
					b.Did  			
										
		order by b.Dreferencia
	</cfquery>
	<!---	<cf_dump var="#rsDeducciones#">--->
		
	<!---====== Insertar en la temporal ======----->	
	<cfloop query="rsDeducciones">	
	
		<cfif rsDeducciones.Dcontrolsaldo EQ 1> 
		
				<cfquery name="rsSaldo" datasource="#Session.DSN#">				
					select 	sum(a.DCvalor) as DCvalor, 
						b.Ddescripcion, 
						b.Dreferencia,
							
						b.Dcontrolsaldo,   		   	
						a.DCsaldo
										
					from HDeduccionesCalculo a, DeduccionesEmpleado b
					where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and a.Did = b.Did
					group by 	b.Ddescripcion, 
							b.Dreferencia,								
							b.Dcontrolsaldo,
							a.DCsaldo,
							b.Did  			
												
				order by b.Dreferencia
			</cfquery>	
		
						
			<cfset saldoDeducc = rsSaldo.DCsaldo - rsSaldo.DCvalor>	
			<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,rsDeducciones.Ddescripcion,'',rsDeducciones.DCvalor,VN_CUENTALINEAS_2,2,#saldoDeducc#,rsDeducciones.Dcontrolsaldo)>
		<cfelse>
			<cfset x= funcInsertaLinea(arguments.DEid,arguments.RCNid,rsDeducciones.Ddescripcion,'',rsDeducciones.DCvalor,VN_CUENTALINEAS_2,2,0,0)>
		</cfif>
		
	</cfloop>
	
	<cfquery name="rsSumDeducciones" dbtype="query">
		select sum(DCvalor) as deduc
		from rsDeducciones
	</cfquery>
	<cfif rsSumDeducciones.recordCount GT 0>
		<cfset SumDeducciones = rsSumDeducciones.deduc>
	<cfelse>
		<cfset SumDeducciones = 0.00>
	</cfif>
	
	<cfquery name="rsDetalleMovimientos" datasource="#Session.DSN#">
		select 
			case when a.DLfvigencia is not null then <cf_dbfunction name="date_format" args="a.DLfvigencia,DD/MM/YY"> else '&nbsp;' end as Vigencia,
			case when a.DLffin is not null then <cf_dbfunction name="date_format" args="a.DLffin,DD/MM/YY">  else '&nbsp;' end as Finalizacion,
			<cf_dbfunction name="to_char" args="a.DLsalario"  >  as DLsalario, 
			<cf_dbfunction name="to_char" args="a.DLsalarioant"  >  as DLsalarioant, 
			<cf_dbfunction name="date_format" args="a.DLfechaaplic,DD/MM/YY">  as FechaAplicacion,
			b.RHTdesc as Descripcion
		from DLaboralesEmpleado a, RHTipoAccion b, HRCalculoNomina c
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		and a.RHTid = b.RHTid
		and a.Ecodigo = b.Ecodigo
		and a.Ecodigo = c.Ecodigo
		and a.DLfechaaplic between c.RCdesde and c.RChasta
		order by a.DLfechaaplic
	</cfquery>
	
	<!--- ================================================================== --->
	<!--- Calculo de salario por hora  										 ---> 
	<!--- ================================================================== --->
	<cfquery name="rsDias" datasource="#Session.DSN#">
		select <cf_dbfunction name="to_float" args="FactorDiasSalario"> as dias, r.RChasta
		from TiposNomina t, HRCalculoNomina r
		where t.Ecodigo = r.Ecodigo
		  and t.Tcodigo = r.Tcodigo
		  and r.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfif isdefined('rsSalBrutoMensual') and rsSalBrutoMensual.RecordCount EQ 0>
		<cfset vSalarioBruto = rsSalBrutoMensual.PEsalario >
	<cfelse>
		<cfset vSalarioBruto = 0>
	</cfif>
	<cfif isdefined('rsDias') and rsDias.RecordCount GT 0>
		<cfset vDiasNomina = rsDias.dias >
	<cfelse>
		<cfset vDiasNomina = 0>
	</cfif>


	<cfset vHorasDiarias = 0 >
	<cfquery name="rsHoras" datasource="#session.DSN#" >
		select RHJhoradiaria, RHJornadahora
		from RHJornadas a, LineaTiempo b
		where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		and a.Ecodigo = #Session.Ecodigo#
		and b.Ecodigo = #Session.Ecodigo#
		and a.RHJid = b.RHJid
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDias.RChasta#"> between LTdesde and LThasta 
	</cfquery>
	<cfif isdefined('rsHoras') and rsHoras.RecordCount GT 0>
		<cfset vHorasDiarias = rsHoras.RHJhoradiaria >
		<cfset vJornadaporHora = rsHoras.RHJornadahora>
	<cfelse>
		<cfset vHorasDiarias = 0>
		<cfset vJornadaporHora = 0>	
	</cfif>
	<cfif vSalarioBruto GT 0 and vDiasNomina GT 0 and vHorasDiarias GT 0>
		<cfset vSalarioHora = (vSalarioBruto/vDiasNomina)/vHorasDiarias >	
	<cfelse>
		<cfset vSalarioHora = 0>
	</cfif>	
	
	<!--- ================================================================== --->
	<!--- ================================================================== --->
	<cfquery datasource="#session.DSN#">
		update #TMPConceptosRX#
			set devengado = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalesResumido.Pagos#">,
				deducido = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalesResumido.Deducciones#">,
				neto = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalesResumido.Liquido#">,
				lineasEmp = (select count(1) from #TMPConceptosRX#
							where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
								and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
							)
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
	</cfquery>
	
	<cfquery name="ConceptosPago" datasource="#session.DSN#">
		select 	* 
		from #TMPConceptosRX#
		where (	devengado != 0 or 
				deducido != 0 or
				neto != 0)
		order by DEid,linea
	</cfquery>
	
	<cfquery name="rsEtiquetaPie" datasource="#session.DSN#">
		select Mensaje from MensajeBoleta 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
	</cfquery>

	<!--- ARMA EL EMAIL--->
	<cfset vb_pagebreak = false>	
	<cfinclude template="../../expediente/consultas/FormatoBoletaPagoDosTerciosImp.cfm">		
	<cfsavecontent variable="info">
		<cfoutput>
			#DETALLE#			
		</cfoutput>
	</cfsavecontent>
	<cfreturn info>
</cffunction>

<cffunction access="private" name="enviarCorreo" output="true" returntype="boolean">
	<cfargument name="from" required="yes" type="string">
	<cfargument name="to" required="yes" type="string">
	<cfargument name="subject" required="yes" type="string">
	<cfargument name="message" required="yes" type="string">
	
	
	<!--- ENVÃA EL EMAIL --->

	
	<cfset errores = 0>
	
	<cftry>
		<cfquery datasource="asp">
			insert into SMTPQueue 
				(SMTPremitente, SMTPdestinatario, SMTPasunto,
				SMTPtexto, SMTPhtml)
			 values(
			 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.from)#">,
			 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.to)#">,
			 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#subject#">,
			 	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.message#">,
				1)
		</cfquery><!---
		<cfmail from="#Arguments.from#" to="#Arguments.to#" subject="#subject#" type="html">
			#Arguments.message#
		</cfmail>--->
		<cfcatch type="any">
			<cfset errores = errores + 1>
			<cfoutput>Error: Tipo: #cfcatch.type#, <br>Mensaje: #cfcatch.Message#, <br>Detalle: #cfcatch.Detail#</cfoutput>
			<cfabort>
		</cfcatch>
	</cftry>
	
	<cfreturn errores eq 0>
</cffunction>

<cffunction access="private" name="getRHPvalor" output="false" returntype="string">
	<cfargument name="Pcodigo" required="yes" type="string">
	<cfquery name="rs" datasource="#session.dsn#">
		select Pvalor
		from RHParametros
		where Ecodigo = #session.Ecodigo#
		and Pcodigo = #Arguments.Pcodigo#
	</cfquery>
<!---	<cf_dump var="#rs#">--->
	<cfreturn rs.Pvalor>
</cffunction>

<cffunction access="private" name="getEmailFromAdmin" output="false" returntype="string">
	<cfargument name="UsucodigoAdmin" required="yes" type="numeric">
	<cfquery name="rs" datasource="asp">
		select b.Pemail1 as Email
		from Usuario a, DatosPersonales b
		where a.Usucodigo = #Arguments.UsucodigoAdmin#
		and a.datos_personales = b.datos_personales
	</cfquery>

	<cfreturn rs.Email>
</cffunction>

<cffunction access="private" name="getEmailFromJefe" output="false" returntype="string">
	<cfargument name="DEid" required="yes" type="numeric">
		
	<cfset mail = ''>
	<cfquery name="rsRHPid" datasource="#session.dsn#">
		select RHPid
		from LineaTiempo 
		where DEid = #Arguments.DEid#
			and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta
	</cfquery>
	
	<cfif rsRHPid.RecordCount NEQ 0 and len(trim(rsRHPid.RHPid))>
		<cfquery name="rsCFid" datasource="#session.dsn#">
			select CFid
			from RHPlazas 
			where RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHPid.RHPid#">
		</cfquery>
		<cfif rsCFid.RecordCount NEQ 0 and len(trim(rsCFid.CFid))>		
			<cfquery name="rsRHPid2" datasource="#session.dsn#">
				select RHPid 
				from CFuncional 
				where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFid.CFid#">
			</cfquery>
	
			<cfif rsRHPid2.RecordCount NEQ 0 and len(trim(rsRHPid2.RHPid))>		
				<cfquery name="rsDEid" datasource="#session.dsn#">
					select min(DEid) as DEid
					from LineaTiempo 
					where Ecodigo = #session.Ecodigo#
						and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHPid2.RHPid#">
						and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta
				</cfquery>
				<cfif rsDEid.RecordCount NEQ 0 and len(trim(rsDEid.DEid))>
					<cfquery name="rs" datasource="#session.dsn#">
						select DEemail as Email
						from DatosEmpleado 
						where DEid = #rsDEid.DEid#
					</cfquery>
				</cfif>
				<cfif isdefined("rs.Email") and rs.RecordCount NEQ 0 and len(trim(rs.Email))>
					<cfset mail = '#rs.Email#'>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	<cfreturn mail>
	<!----
	<cfquery name="rs" datasource="#session.dsn#">
		declare @RHPid numeric,
			@CFid numeric,
			@DEid numeric
		
		select @RHPid = RHPid
		from LineaTiempo 
		where DEid = #Arguments.DEid#
		 and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta
		 
		select @CFid = CFid
		from RHPlazas 
		where RHPid = @RHPid
		 
		select @RHPid = RHPid 
		from CFuncional 
		where CFid = @CFid
		 
		select @DEid = min(DEid)
		from LineaTiempo 
		where Ecodigo = #session.Ecodigo#
		and RHPid = @RHPid
		and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta
		
		select DEemail as Email
		from DatosEmpleado 
		where DEid = @DEid
	</cfquery>
	---->
</cffunction>


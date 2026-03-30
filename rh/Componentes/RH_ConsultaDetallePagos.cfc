<cfcomponent>
		<cfsetting requesttimeout="8600">
		
		<cfparam name="formato" default="Flashpaper">
		<cfparam name="CPid" default="">
		
		<!--- VARIABLES DE TRADUCCION --->
		<cfinvoke key="LB_SalarioBruto" default="Salario Bruto" returnvariable="LB_SalarioBruto" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" /> 
		<cfinvoke key="LB_Retroactivos" default="RETROACTIVOS" returnvariable="LB_Retroactivos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" /> 
		<cfinvoke key="LB_Renta" 		default="ISPT" returnvariable="LB_Renta" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" /> 
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
		<cf_dbtemp name="BTEMPConceptos" returnvariable="TMPConceptos" datasource="#session.DSN#">
		   <cf_dbtempcol name="Tipo"			type="varchar(50)"  mandatory="yes">
		   <cf_dbtempcol name="CInorenta"		type="int"  		mandatory="yes">		<!---es gravable?  0 = si, 1 = no--->
		   <cf_dbtempcol name="DEid"			type="numeric"  	mandatory="yes">
		   <cf_dbtempcol name="RCNid"			type="numeric"  	mandatory="yes">
		   <cf_dbtempcol name="descconcepto"	type="varchar(255)"	mandatory="no">
		   <cf_dbtempcol name="cantconcepto"   	type="varchar(50)"	mandatory="no">
		   <cf_dbtempcol name="montoconcepto"   type="money"		mandatory="no">
		   <cf_dbtempcol name="pagina"          type="int"	    	mandatory="no">
		   <cf_dbtempcol name="linea"           type="int"			mandatory="no">
		   <cf_dbtempcol name="columna"         type="int"			mandatory="no">
		   <cf_dbtempcol name="descconceptoB"	type="varchar(255)"	mandatory="no">
		   <cf_dbtempcol name="cantconceptoB"   type="varchar(50)"	mandatory="no">
		   <cf_dbtempcol name="montoconceptoB"  type="money"		mandatory="no">
		
		   <cf_dbtempcol name="nomina"  		type="varchar(100)"	mandatory="no">
		   <cf_dbtempcol name="desdenomina"  	type="datetime"		mandatory="no">
		   <cf_dbtempcol name="hastanomina"  	type="datetime"		mandatory="no">
		   <cf_dbtempcol name="empleado"  		type="varchar(255)"	mandatory="no">
		   <cf_dbtempcol name="cuenta"  		type="varchar(100)"	mandatory="no">
		   <cf_dbtempcol name="EtiquetaCuenta"  type="varchar(100)"	mandatory="no">
		   <cf_dbtempcol name="departamento"  	type="varchar(150)"	mandatory="no">
		   <cf_dbtempcol name="puntoventa"  	type="varchar(255)"	mandatory="no">
		   <cf_dbtempcol name="devengado"  		type="money"		mandatory="no">
		   <cf_dbtempcol name="deducido"  		type="money"		mandatory="no">
		   <cf_dbtempcol name="neto"  			type="money"		mandatory="no">
		   
		   <cf_dbtempcol name="orden"         	type="int"			mandatory="no">
		   <cf_dbtempcol name="lineasEmp"       type="int"			mandatory="no">
		   
		   <cf_dbtempcol name="incidencia"       type="int"			mandatory="no">
		   <cf_dbtempcol name="especie"          type="int"			mandatory="no">
		   <cf_dbtempcol name="resumeCargas"     type="int"			mandatory="no">			<!---indica si las cargas se muestran de forma resumida o no. CarolRS--->
		   <cf_dbtempcol name="resumeCargasDesc" type="varchar(100)" mandatory="no">		<!---en caso de que la impresion de la boleta se haga de forma resumida se debe mostrar esta descripcion.--->
		   
		</cf_dbtemp>
		
		<!---============== FUNCION INSERTA LINEAS A LA TEMPORAL QUE LUEGO SE PINTA ==============---->
		<cffunction name="funcInsertaLinea" >
			<cfargument name="Tipo" 			type="string" default="-1">
			<cfargument name="CInorenta" 		type="numeric" default="1">					<!---es gravable?  0 = si, 1 = no--->
			<cfargument name="DEid" 			type="numeric">
			<cfargument name="RCNid" 			type="numeric">
			<cfargument name="descconcepto" 	type="string" default="">
			<cfargument name="cantconcepto" 	type="string" default="0">
			<cfargument name="montoconcepto" 	type="numeric" default="0">
			<cfargument name="linea" 			type="numeric" default="0">
			<cfargument name="columna" 			type="numeric" default="1">
			<cfargument name="empleado" 		type="string" default="">
			<cfargument name="cuenta" 			type="string" default="">
			<cfargument name="etiquetacuenta" 	type="string" default="">
			<cfargument name="departamento" 	type="string" default="">
			<cfargument name="puntoventa" 		type="string" default="">
			<cfargument name="orden" 			type="numeric" default="1">
			<cfargument name="forzar" 			type="boolean" default="false">
			<cfargument name="incidencia" 		type="numeric" default="0">
			<cfargument name="especie" 			type="numeric" default="0">
			<cfargument name="resumeCargas" 	type="numeric" default="0">
			<cfargument name="resumeCargasDesc" type="string" default="">
				
				<cfquery datasource="#session.DSN#">
					insert into #TMPConceptos# (Tipo,CInorenta,DEid,RCNid,descconcepto,cantconcepto,montoconcepto,linea,columna,nomina,
												desdenomina,hastanomina,empleado,cuenta,departamento,puntoventa,orden,EtiquetaCuenta,incidencia,especie,resumeCargas,resumeCargasDesc)
					values(<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.Tipo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.CInorenta#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.DEid#">,
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
				select <!---coalesce(sum(PEmontores),0) as Monto, --->
						<cf_dbfunction name="to_char" args="coalesce(sum(PEcantdias),0)"> as cantidad,
						<cf_dbfunction name="to_char" args="coalesce(sum(PEcantdias * (PEsalarioref/30)),0)"> as Monto,
						d.CSdescripcion
				from HPagosEmpleado a
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
					from HSalarioEmpleado a
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
			   
				
			<cfquery name="cantidad_dias" datasource="#Session.DSN#">		
				select <cf_dbfunction name="to_char" args="coalesce(sum(PEcantdias),0)"> as cantidad
				from HPagosEmpleado a
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
			
			 <!---►►►Cantidad de Dias NO laborados◄◄◄--->  	
			<cfset DiasNoLaborados  = 0>
			<cfset MontoNoLaborados = 0>
			<cfif listfind('50',rsParametro.Pvalor)>
				<cfquery name="rsDiasNoLaborados" datasource="#Session.DSN#">		
					select Coalesce(sum(PEcantdias),0) as dias, 
						   Coalesce(sum(Coalesce(PEsalarioref,0) / <cf_dbfunction name="to_number" args="Coalesce(c.FactorDiasSalario,'1')"> * PEcantdias),0) as monto
						from HPagosEmpleado a
						 inner join HRCalculoNomina b
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
				
			<!---====== Insertar en la temporal ======----->
			<cfif rsSalBrutoRelacion.RecordCount NEQ 0>
				<!---Nota: el salario bruto se marca como CInorenta = 0, es decir que si es gravable en ISPT--->
				<cfset x= funcInsertaLinea('SalBruto',0, arguments.DEid,arguments.RCNid,'#rsSalBrutoRelacion.CSdescripcion#',cantidad+DiasNoLaborados,rsSalBrutoRelacion.Monto+MontoNoLaborados,VN_CUENTALINEAS,1,
											arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden)>
							
				<cfset salariobrutorelacion = rsSalBrutoRelacion.Monto>			
			<cfelse>
				<cfset salariobrutorelacion = 0>
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
				from HPagosEmpleado a
				where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and a.PEtiporeg > 0
				and a.PEmontores != 0
			</cfquery>	
			<!---====== Insertar en la temporal ======----->
			<cfif rsRetroactivos.RecordCount NEQ 0 and rsRetroactivos.Monto NEQ 0>
				<cfif rsParametro.Pvalor EQ 30><!----Cuando el calculo es para la boleta de 1/2 de Coopelesca--->
					<cfset x= funcInsertaLinea('Retroactivo',1,arguments.DEid,arguments.RCNid,'#LB_Retroactivos#','',rsRetroactivos.Monto,VN_CUENTALINEAS,1
										,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden)>
				<cfelse>
					<cfset x= funcInsertaLinea('Retroactivo',1,arguments.DEid,arguments.RCNid,'#LB_Retroactivos#','#rsRetroactivos.cantidad#',rsRetroactivos.Monto,VN_CUENTALINEAS,1
												,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden)>
				</cfif>							
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
				from HSalarioEmpleado 
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			</cfquery>
			<!---====== Insertar en la temporal ======----->
			<cfif rsSalarioEmpleado.RecordCount NEQ 0 and rsSalarioEmpleado.SErenta NEQ 0>
				<cfset x= funcInsertaLinea('Renta',1,arguments.DEid,arguments.RCNid,'#LB_Renta#','',rsSalarioEmpleado.SErenta,VN_CUENTALINEAS_2,2
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
			
			<cfquery name="rsCargasResumidas" datasource="#Session.DSN#">
				select 	sum(coalesce(CCvaloremp,0)) as CCvaloremp, 
						DEid,
						ECcodigo,
						ECdescripcion,
						case when sum(coalesce(ECresumido,0)) > 0 <!---indica si las cargas se muestran de forma resumida o no. CarolRS--->
						then 1 else 0  end as ECresumido
				from HCargasCalculo a, DCargas b, ECargas c
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				  and a.DClinea = b.DClinea
				  and b.ECid = c.ECid
				  and CCvaloremp <> 0
				  and ECresumido = 1
				group by DEid,ECcodigo,ECdescripcion
			</cfquery>
			
			<cfloop query="rsCargasResumidas">		
				<cfset x= funcInsertaLinea('cargasResum',1,arguments.DEid,arguments.RCNid,rsCargasResumidas.ECdescripcion,'',rsCargasResumidas.CCvaloremp,VN_CUENTALINEAS_2,2
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
				from  HCargasCalculo a, DCargas b, ECargas c
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				  and a.DClinea = b.DClinea
				  and b.ECid = c.ECid
				  and CCvaloremp <> 0
				   and ECresumido = 0
				group by DEid,ECcodigo,ECdescripcion,DCdescripcion 
			</cfquery>
			
			
		
		
			<!---====== Insertar en la temporal ======----->
			<cfloop query="rsCargas">		
				<cfset x= funcInsertaLinea('cargas',1,arguments.DEid,arguments.RCNid,rsCargas.DCdescripcion,'',rsCargas.CCvaloremp,VN_CUENTALINEAS_2,2
											,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden,false,0,0,rsCargas.ECresumido, rsCargas.ECdescripcion)>
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
				select 	a.DEid,
						sum(coalesce(a.DCvalor,0)) as DCvalor, 
						b.Ddescripcion
				from HDeduccionesCalculo a, DeduccionesEmpleado b
				where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					and a.Did = b.Did
					and a.DCvalor != 0
				group by a.DEid,b.Ddescripcion
				<!---order by b.Dreferencia--->
			</cfquery>
			
			<!---====== Insertar en la temporal ======----->
			<cfloop query="rsDeducciones">		
				<cfset x= funcInsertaLinea('Deduccion',1,arguments.DEid,arguments.RCNid,rsDeducciones.Ddescripcion,'',rsDeducciones.DCvalor,VN_CUENTALINEAS_2,2 
											,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden,false)>
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
		
			<cfif rsParametro.Pvalor EQ 30><!----Cuando el calculo es para la boleta de 1/2 de Coopelesca--->
				<cfquery name="rsIncidenciasCalculo" datasource="#Session.DSN#">
					select 	a.DEid,
							b.CInorenta,								<!---es gravable?  0 = si, 1 = no--->
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
					from HIncidenciasCalculo a, CIncidentes b, ComponentesSalariales c
					where a.CIid = b.CIid
						and a.CIid = c.CIid
						and c.CSsalarioEspecie = 0
						and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					group by a.DEid,b.CInorenta,
							 case when a.ICmontoant <> 0 then
								 <cf_dbfunction name="concat" args="'AJUSTE',' ',b.CIdescripcion">
							else
								b.CIdescripcion
							end
				</cfquery>		
			<cfelse>	
				<cfquery name="rsIncidenciasCalculo" datasource="#Session.DSN#">
					select a.DEid,
						b.CInorenta,									<!---es gravable?  0 = si, 1 = no--->
						b.CIdescripcion,
						sum(coalesce(a.ICmontores,0)) as Monto, 
						sum((case when CItipo < 2 then ICvalor else 0 end)) as Valor,			   	
						sum(coalesce(a.ICmontores,0)) as ICmontores		
					from HIncidenciasCalculo a
						 inner join CIncidentes b
							on a.CIid = b.CIid
						left outer join ComponentesSalariales c
							on a.CIid = c.CIid
							and c.CSsalarioEspecie = 0
					where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
						and a.ICmontores != 0
					group by a.DEid,b.CInorenta,b.CIdescripcion
				</cfquery>
				
				<cfquery name="rsIncidenciasCalculo"  dbtype="query">
					select * from rsIncidenciasCalculo
					   where Monto > 0
				</cfquery>
			</cfif>
			
			<cfif rsIncidenciasCalculo.recordCount GT 0>		
				<!---<cfset montoIncidencias = rsIncidenciasCalculo.Monto + Iif(Len(Trim(retroactivos)), DE(retroactivos), DE("0.00"))>--->
				<!---====== Insertar en la temporal ======----->
				<cfloop query="rsIncidenciasCalculo">		
					<cfset montoIncidencias = montoIncidencias + (rsIncidenciasCalculo.Monto)>
					<cfset x= funcInsertaLinea('Incidencia',#rsIncidenciasCalculo.CInorenta#,arguments.DEid,arguments.RCNid,rsIncidenciasCalculo.CIdescripcion,'#rsIncidenciasCalculo.Valor#',rsIncidenciasCalculo.ICmontores,VN_CUENTALINEAS,1
												,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden,false,1,0)>
				</cfloop>
				<cfset montoIncidencias = montoIncidencias + Iif(Len(Trim(retroactivos)), DE(retroactivos), DE("0.00"))>
			<cfelse>
				<cfset montoIncidencias = 0.00 + Iif(Len(Trim(retroactivos)), DE(retroactivos), DE("0.00"))>
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
					from HIncidenciasCalculo a, CIncidentes b, ComponentesSalariales c
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
							sum(coalesce(a.ICmontores,0)) as ICmontores					
					from HIncidenciasCalculo a, CIncidentes b, ComponentesSalariales c
					where a.CIid = b.CIid
						and a.CIid = c.CIid
						and c.CSsalarioEspecie = 1
						and a.ICmontores <> 0
						and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
						and a.ICmontores != 0
						and a.ICespecie = 0
					group by a.DEid,b.CIdescripcion
					<!---order by a.DEid,b.CIdescripcion--->		
				</cfquery>
				
			</cfif>
			
			<cfif rsIncidenciasCalculoEspecie.recordCount GT 0>		
				<!---<cfset montoIncidencias = rsIncidenciasCalculo.Monto + Iif(Len(Trim(retroactivos)), DE(retroactivos), DE("0.00"))>--->
				<!---====== Insertar en la temporal ======----->
				<cfloop query="rsIncidenciasCalculoEspecie">		
					<cfset montoIncidencias = montoIncidencias + (rsIncidenciasCalculoEspecie.Monto)>
					<cfset x= funcInsertaLinea('IncidenciasEspecie',1,arguments.DEid,
												arguments.RCNid,
												rsIncidenciasCalculoEspecie.CIdescripcion,
												'#rsIncidenciasCalculo.Valor#',
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
				<cfset montoIncidencias = montoIncidencias + Iif(Len(Trim(retroactivos)), DE(retroactivos), DE("0.00"))>
			<cfelse>
				<cfset montoIncidencias = 0.00 + Iif(Len(Trim(retroactivos)), DE(retroactivos), DE("0.00"))>
			</cfif>			
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
					select sum(PEcantdias) as PEcantdias, ((sum(Coalesce(PEsalarioref,0) / <cf_dbfunction name="to_number" args="Coalesce(c.FactorDiasSalario,'1')"> * PEcantdias))* coalesce(RHTfactorfalta,1)) as monto, d.RHTdesc
						from HPagosEmpleado a
						 inner join HRCalculoNomina b
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
			<cfloop query="rsFaltas">	
				<cfset descripcion = rsFaltas.RHTdesc & ' (' & rsFaltas.PEcantdias & ' Dias)'>
				<cfset x= funcInsertaLinea('Faltas',1,arguments.DEid,arguments.RCNid,descripcion,0,rsFaltas.monto,VN_CUENTALINEAS_2,2
											,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden,false)>
			</cfloop>
		</cffunction>
		
		
		 <!---====== Obtiene los datos de la tabla de Parámetros segun el pcodigo ======----->
		<cffunction name="ObtenerDato" returntype="query">
			<cfargument name="pcodigo" type="numeric" required="true">	
			<cfquery name="rs" datasource="#session.DSN#">
				select Pvalor
				from RHParametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
				  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pcodigo#">
			</cfquery>
			<cfreturn #rs#>
		</cffunction>
		
		<!---============== FUNCION OBTIENE DEDUCCIONES SUBSIDIO SALARIO==============---->
		<cffunction name="funcDeduccionesSubSal">
			<cfargument name="DEid" type="numeric" required="yes">
			<cfargument name="RCNid" type="numeric" required="yes">
			<cfargument name="empleado" type="string" required="no">
			<cfargument name="cuenta" type="string" required="no">
			<cfargument name="etiquetacuenta" type="string" required="no">
			<cfargument name="departamento" type="string" required="no">
			<cfargument name="puntoventa" type="string" required="no">
			<cfargument name="orden" type="numeric" required="no">
		
			
			<cfset PvalorCPagoSubsidio  = ObtenerDato(2033)>
			
			<cfif PvalorCPagoSubsidio.RecordCount GT 0 and trim(PvalorCPagoSubsidio.Pvalor) neq '' >
			
				<cfquery name="rsDeducciones" datasource="#Session.DSN#">
					select 	a.DEid,
							sum(coalesce(a.DCvalor,0)) as DCvalor, 
							b.Ddescripcion
					from HDeduccionesCalculo a, DeduccionesEmpleado b
					where a.Did = b.Did
						and a.DCvalor != 0
						and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
						and a.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PvalorCPagoSubsidio.Pvalor#">
					group by a.DEid,b.Ddescripcion
				</cfquery>
				
			</cfif>
			
			<!---====== Insertar en la temporal ======----->
			<cfloop query="rsDeducciones">		
				<cfset x= funcInsertaLinea('DeduccionSubSal',1,arguments.DEid,arguments.RCNid,rsDeducciones.Ddescripcion,'',rsDeducciones.DCvalor,VN_CUENTALINEAS_2,2 
											,arguments.empleado,arguments.cuenta,arguments.etiquetacuenta,arguments.departamento,arguments.puntoventa,arguments.orden,false)>
			</cfloop>
		</cffunction>
		
		
		<!---============== FUNCION OBTIENE DEDUCCIONES SUBSIDIO SALARIO==============---->
		<cffunction name="funcConsultarDetallesSalariales" returntype="any">
			<cfargument name="CPid" 	type="numeric" required="yes">
			<cfargument name="nomail" 	type="numeric" required="no" 	default="0">
			<cfargument name="DSN" 		type="string" required="no" 	default="#Session.DSN#">
			<cfargument name="Ecodigo" 	type="numeric" required="no" 	default="#Session.Ecodigo#">
			
			
		
			<!--- DATOS DE LA NOMINA ---->
			<cfquery name="rsNomina" datasource="#Arguments.DSN#">
				select RCNid, c.CPfpago, a.RCdesde, a.RChasta, a.RCDescripcion, b.Tdescripcion
				from HRCalculoNomina a, TiposNomina b, CalendarioPagos c
				where a.Tcodigo = b.Tcodigo
				and a.RCNid = c.CPid
				and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPid#">
				and a.Ecodigo = b.Ecodigo
			</cfquery>
			
			<!--- PARA C/EMPLEADO INSERTAR LOS DIFERENTES RUBROS EN LA TEMPORAL ---->
			<cfset VN_ORDEN = 1><!---Valor de ordenamiento del query--->
			
			<cf_dbfunction name="concat" args="e.DEnombre,e.DEapellido1,e.DEapellido2" returnvariable="Lvar_Nombre" >
			<cfquery name="rsEmpleadosNomina" datasource="#Arguments.DSN#">		
				select 	distinct a.DEid,
						#Lvar_Nombre# as Empleado
						,e.	DEidentificacion
						,a.DEid as Chequeado
						,e.DEnombre,DEapellido1
				from HSalarioEmpleado a
					inner join HRCalculoNomina rc
						on a.RCNid = rc.RCNid
					inner join  LineaTiempo b
						on (rc.RCdesde between LTdesde and LThasta or rc.RChasta between LTdesde and LThasta)
						and a.DEid = b.DEid
					inner join RHPlazas c 
						on b.RHPid = c.RHPid
						and b.Ecodigo = c.Ecodigo
					inner join DatosEmpleado e
						on a.DEid = e.DEid
						<cfif isdefined("Arguments.nomail") and Arguments.nomail EQ 1>								<!----Solo los empleados que no tienen EMAIL---->
							and (ltrim(rtrim(e.DEemail)) is null or ltrim(rtrim(e.DEemail)) = '')
						</cfif>
				where a.RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPid#">	
				order by e.DEnombre,e.DEapellido1
			</cfquery>
			
			<cfloop query="rsEmpleadosNomina">
				
				<cfset id= rsEmpleadosNomina.DEid>
				<cfquery name="rsEncabEmpleado" datasource="#Arguments.DSN#"><!---Datos del empleado--->
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
			
				<cfquery name="rsDepto" datasource="#Arguments.DSN#"><!---Departamento--->
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
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
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
				<cfif salariobrutorelacion NEQ "" and montoIncidencias NEQ "">
					<cfset pagos = salariobrutorelacion + montoIncidencias>							<!---Salario devengado (+)---->
					<cfset liquido = (salariobrutorelacion + montoIncidencias) - (deducciones)>		<!---Neto---->
				</cfif>
				
				<cfquery datasource="#session.DSN#"><!---Actualizar montos generales (Devengado,Deducido,Neto)--->
					update #TMPConceptos#
						set devengado = <cfqueryparam cfsqltype="cf_sql_money" value="#pagos#">,
							deducido = <cfqueryparam cfsqltype="cf_sql_money" value="#deducciones#">,
							neto = <cfqueryparam cfsqltype="cf_sql_money" value="#liquido#">,
							lineasEmp = (select count(1) from #TMPConceptos#
										where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
											and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPid#">
										)
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
						and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPid#">
				</cfquery>	
			
				<cfset VN_ORDEN = VN_ORDEN + 1><!---Ordenamiento de los datos para mantener el order by del query rsEmpleadosNomina segun los filtros de la consulta---->
			</cfloop>
			
			<cfreturn #TMPConceptos#>
		</cffunction>
</cfcomponent>


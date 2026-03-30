<!--- PARÁMETROS--->
<cfif isdefined("url.RCNid") and not isdefined("form.RCNid")>	
	<cfset form.RCNid = url.RCNid >
</cfif>

<cfif isdefined("url.DEid") and not isdefined("form.DEid")>	
	<cfset form.DEid = url.DEid >
</cfif>

<cfif isdefined("url.Tcodigo") and not isdefined("form.Tcodigo")>	
	<cfset form.Tcodigo = url.Tcodigo >
</cfif>

<cfif isdefined("url.chkIncidencias") and not isdefined("form.chkIncidencias")>	
	<cfset form.chkIncidencias = url.chkIncidencias >
</cfif>

<cfif isdefined("url.chkCargas") and not isdefined("form.chkCargas")>	
	<cfset form.chkCargas = url.chkCargas >
</cfif>

<cfif isdefined("url.chkDeducciones") and not isdefined("form.chkDeducciones")>	
	<cfset form.chkDeducciones = url.chkDeducciones >
</cfif>

<!---Obtener cual formato de boleta se esta usando----->
<cfquery name="rsParametro" datasource="#session.DSN#">
	select coalesce(Pvalor,'10') as Pvalor
	from RHParametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 720
</cfquery>


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" 
key="LB_Boleta_Pago"
Default="Boleta de Pago"
returnvariable="LB_Boleta"/> 

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
Default="Renta"
returnvariable="LB_Renta"/>

<!---============================================================ TABLA TEMPORAL DE TRABAJO ============================================================---->
<cf_dbtemp name="TMPConceptosRRX" returnvariable="TMPConceptosRX" datasource="#session.DSN#">
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
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsNomina.RCDescripcion)#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#trim(rsNomina.RCdesde)#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#trim(rsNomina.RChasta)#">,
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
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsNomina.RCDescripcion)#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#trim(rsNomina.RCdesde)#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#trim(rsNomina.RChasta)#">,
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

<!--- CONSULTAS --->
<cfquery name="rsMoneda" datasource="#Session.DSN#">
	select Miso4217, Msimbolo
	from Monedas a, HRCalculoNomina b, TiposNomina c 
	where b.Tcodigo = c.Tcodigo 
	and a.Mcodigo = c.Mcodigo 
	and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
</cfquery>

<cfquery name="rsNomina" datasource="#Session.DSN#">
	select c.CPfpago, a.RCdesde, a.RChasta, a.RCDescripcion, b.Tdescripcion
	from HRCalculoNomina a, TiposNomina b, CalendarioPagos c
	where a.Tcodigo = b.Tcodigo
	and a.RCNid = c.CPid
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
</cfquery>

<cfset Titulo = "#LB_Boleta#: " & rsNomina.RCDescripcion>

<cfquery name="rsEncabEmpleado" datasource="#Session.DSN#">
	select {fn concat (ltrim(rtrim(coalesce(DEtarjeta,''))), {fn concat('   ',{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )})})}as nombreEmpl	, DEemail, DEidentificacion, NTIdescripcion
			,DEinfo1
			,case CBTcodigo when 1 then '<b>Cuenta de Ahorros No:</b>' else '<b>Cuenta Corriente No:</b>' end as EtiquetaCuenta
			,de.DEcuenta as cuenta
			,{fn concat('El monto detallado en este documento fué depositado a su cuenta ', 
				{fn concat(case CBTcodigo when 1 then 'de Ahorros No.' else 'Corriente No.' end, de.DEcuenta)}
			)} as Etiqueta2
	from DatosEmpleado de, NTipoIdentificacion ti
	where de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	and de.NTIcodigo = ti.NTIcodigo
</cfquery>

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
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">		
		<!----
		and a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsNomina.RCdesde#">
		and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsNomina.RChasta#">---->
		and LTdesde = (Select max(LTdesde) 
						from LineaTiempo e 
						where a.DEid = e.DEid
							and e.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsNomina.RCdesde#">
							and e.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsNomina.RChasta#">)
</cfquery>

<cfquery name="rsSalBrutoMensual" datasource="#Session.DSN#">
	select coalesce(PEsalario,0) as PEsalario
	from HPagosEmpleado a
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.PEtiporeg = 0
	and a.PEdesde = (
		select max(PEdesde)
		from HPagosEmpleado
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		and PEtiporeg = 0
	)
</cfquery>

<cfquery name="rsSalBrutoRelacion" datasource="#Session.DSN#">
	select coalesce(sum(PEmontores),0) as Monto, <cf_dbfunction name="to_char" args="sum(PEcantdias)"> as cantidad
	from HPagosEmpleado a
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		and a.PEtiporeg = 0
		and a.PEsalario != 0
</cfquery>

<cfquery name="nombre" datasource="#session.DSN#">
	select CSdescripcion as salario
	from ComponentesSalariales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and CSsalariobase = 1 
</cfquery>
<cfif nombre.RecordCount NEQ 0>
	<cfset LB_SalarioBruto = nombre.salario>
<cfelse>
	<cfinvoke component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" 
		key="LB_SalarioBruto"Default="Salario bruto"returnvariable="LB_SalarioBruto"/> 
</cfif>
<!---====== Insertar en la temporal ======----->
<cfif rsSalBrutoRelacion.RecordCount NEQ 0>

	<cfset x= funcInsertaLinea(form.DEid,Form.RCNid,'#LB_SalarioBruto#','#rsSalBrutoRelacion.cantidad#',rsSalBrutoRelacion.Monto,VN_CUENTALINEAS,1,0,0)>
		
</cfif>

<cfquery name="rsRetroactivos" datasource="#Session.DSN#">
	select coalesce(sum(PEmontores),0) as Monto, <cf_dbfunction name="to_char" args="sum(PEcantdias)"> as cantidad
	from HPagosEmpleado a
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.PEtiporeg > 0
</cfquery>

<!---====== Insertar en la temporal ======----->
<cfif rsRetroactivos.RecordCount NEQ 0 and rsRetroactivos.Monto NEQ 0>
	<cfif rsParametro.Pvalor EQ 30><!----Cuando el calculo es para la boleta de 1/2 de Coopelesca--->
		<cfset x= funcInsertaLinea(form.DEid,Form.RCNid,'#LB_Retroactivos#','',rsRetroactivos.Monto,VN_CUENTALINEAS,1,0,0)>
	<cfelse>	
		<cfset x= funcInsertaLinea(form.DEid,Form.RCNid,'#LB_Retroactivos#','#rsRetroactivos.cantidad#',rsRetroactivos.Monto,VN_CUENTALINEAS,1,0,0)>
	</cfif>
</cfif>

<cfquery name="rsSalarioEmpleado" datasource="#Session.DSN#">
	select SErenta, SEcargasempleado, SEdeducciones
	from HSalarioEmpleado 
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>

<!---====== Insertar en la temporal ======----->
<cfif rsSalarioEmpleado.RecordCount NEQ 0 and rsSalarioEmpleado.SErenta NEQ 0>
	<cfset x= funcInsertaLinea(form.DEid,Form.RCNid,'#LB_Renta#','',rsSalarioEmpleado.SErenta,VN_CUENTALINEAS_2,2,0,0)>
</cfif>

<cfif rsParametro.Pvalor EQ 30><!----Cuando el calculo es para la boleta de 1/2 de Coopelesca--->
	<cfquery name="rsIncidenciasCalculo" datasource="#Session.DSN#">
		select 	a.DEid,
				case when a.ICmontoant <> 0 then
					<cf_dbfunction name="concat" args="'AJUSTE',' ',b.CIdescripcion">
				else
					b.CIdescripcion
				end as CIdescripcion,	 
				sum(coalesce(a.ICmontores,0)) as Monto, 
				<cf_dbfunction name="to_char" args="sum(case when a.ICmontoant <> 0 then
															null
														else
															(case when CItipo < 2 then 
																coalesce(ICvalor,0) 
															else 
																null 
															end)
														end
														)"> as Valor, 
				<!----sum((case when CItipo < 2 then coalesce(ICvalor,0) else 0 end)) as Valor,	---->
				sum(coalesce(a.ICmontores,0)) as ICmontores
		from HIncidenciasCalculo a, CIncidentes b
		where a.CIid = b.CIid
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		group by a.DEid,
				 case when a.ICmontoant <> 0 then
					 <cf_dbfunction name="concat" args="'AJUSTE',' ',b.CIdescripcion">
				else
					b.CIdescripcion
				end	
	</cfquery>
<cfelse>
	<cfquery name="rsIncidenciasCalculo" datasource="#Session.DSN#">
		select 	a.DEid,
				b.CIdescripcion, 
				sum(coalesce(a.ICmontores,0)) as Monto, 
				sum((case when CItipo < 2 then ICvalor else 0 end)) as Valor,			   	
				sum(coalesce(a.ICmontores,0)) as ICmontores					
		from HIncidenciasCalculo a, CIncidentes b
		where a.CIid = b.CIid
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		group by a.DEid,b.CIdescripcion	
		<!---order by a.ICfecha--->
	</cfquery>
</cfif>

<cfif rsIncidenciasCalculo.recordCount GT 0>
	<cfquery name="rsSumIncidencias" dbtype="query">
		select sum(ICmontores) as Monto
		from rsIncidenciasCalculo
	</cfquery>
	
	<cfset montoIncidencias = rsSumIncidencias.Monto + Iif(Len(Trim(rsRetroactivos.Monto)), DE(rsRetroactivos.Monto), DE("0.00"))>

	<!---====== Insertar en la temporal ======----->
	<cfloop query="rsIncidenciasCalculo">		
		<cfset x= funcInsertaLinea(form.DEid,Form.RCNid,rsIncidenciasCalculo.CIdescripcion,'#rsIncidenciasCalculo.Valor#',rsIncidenciasCalculo.ICmontores,VN_CUENTALINEAS,1,0,0)>
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
	select 	<!---a.DClinea as DClinea, --->
			sum(coalesce(CCvaloremp,0)) as CCvaloremp, 
			DCdescripcion, 
			a.DEid,
			c.ECid,
			c.ECresumido			
	from HCargasCalculo a, DCargas b, ECargas c
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	  and a.DClinea = b.DClinea
	  and b.ECid = c.ECid
	  and CCvaloremp is not null
	  and CCvaloremp <> 0
	group by DCdescripcion, a.DEid, c.ECid, c.ECresumido 	
	order by c.ECid			
</cfquery>

<cfset	idBandera = "">
<cfloop query="rsCargas">
    <cfif rsCargas.ECresumido is 1>		
	       <cfif idBandera is not #rsCargas.ECid#>
	         <cfquery name="rsCargasResumido" datasource="#Session.DSN#">			     
					select e.ECdescripcion as descripcion, sum(cc.CCvaloremp) as empleado
					from HCargasCalculo cc, ECargas e, DCargas d
					where cc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
				  	and cc.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					and e.ECid = #rsCargas.ECid#
				  	and cc.DClinea = d.DClinea
				  	and e.ECid = d.ECid  
				  	and e.Ecodigo = #Session.Ecodigo#					
                    and cc.CCvaloremp is not null
		            and cc.CCvaloremp <> 0					
					group by e.ECdescripcion, e.ECid 				  	 
	         </cfquery>			
			  			
			<!---====== Insertar en la temporal ======----->
			<cfset x= funcInsertaLinea(form.DEid,Form.RCNid,rsCargasResumido.descripcion,'',rsCargasResumido.empleado,VN_CUENTALINEAS_2,2,0,0)>
			<cfset	idBandera=#rsCargas.ECid# >	
	      </cfif>
	<cfelse>
	<cfset x= funcInsertaLinea(form.DEid,Form.RCNid,rsCargas.DCdescripcion,'',rsCargas.CCvaloremp,VN_CUENTALINEAS_2,2,0,0)>
	</cfif>			
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
	select sum(coalesce(a.DCvalor,0)) as DCvalor, 
		   b.Ddescripcion, 
		   b.Dreferencia,		   
		   b.Dcontrolsaldo,
		   b.Did 
		   
	from HDeduccionesCalculo a, DeduccionesEmpleado b
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and a.Did = b.Did
	group by 	b.Ddescripcion, 
		   		b.Dreferencia
													
	order by b.Dreferencia	
</cfquery> 
	

<cfloop query="rsDeducciones">
	<!---====== Insertar en la temporal ======----->
	<cfif rsDeducciones.Dcontrolsaldo EQ 1> 
			
			<cfquery name="rsSaldo" datasource="#Session.DSN#">	
				select sum(coalesce(a.DCvalor,0)) as DCvalor, 
						   b.Ddescripcion, 
						   b.Dreferencia,
						   
						   b.Dcontrolsaldo,   
						   a.DCsaldo
						   
					from HDeduccionesCalculo a, DeduccionesEmpleado b
					where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
						and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">				
						and a.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Did#"> 
						and a.Did = b.Did
					group by 	b.Ddescripcion, 
								b.Dreferencia,
								b.Dcontrolsaldo,   
								a.DCsaldo
												
					order by b.Dreferencia	
			</cfquery> 			
	
		<cfset saldoDeducc = rsSaldo.DCsaldo-rsSaldo.DCvalor>			  
		<cfset x= funcInsertaLinea(form.DEid,Form.RCNid,rsDeducciones.Ddescripcion,'',rsDeducciones.DCvalor,VN_CUENTALINEAS_2,2,#saldoDeducc#,rsDeducciones.Dcontrolsaldo)>	
	<cfelse>
	    <cfset x= funcInsertaLinea(form.DEid,Form.RCNid,rsDeducciones.Ddescripcion,'',rsDeducciones.DCvalor,VN_CUENTALINEAS_2,2,0,0)>		
	</cfif>
	
</cfloop>

	<cfquery name="rsEtiquetaPie" datasource="#session.DSN#">
		select Mensaje from MensajeBoleta 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		update #TMPConceptosRX#
			set devengado = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalesResumido.Pagos#">,
				deducido = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalesResumido.Deducciones#">,
				neto = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalesResumido.Liquido#">,
				lineasEmp = (select count(1) from #TMPConceptosRX#
							where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
								and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
							)
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
	</cfquery>

	<cfquery name="ConceptosPago" datasource="#session.DSN#">
		select 	* 
		from #TMPConceptosRX#
		where (	devengado != 0 or 
				deducido != 0 or
				neto != 0)
		order by DEid, linea
	</cfquery>

	<!--- ================================================================== --->
	<!--- ================================================================== --->

	<!---=================== --->
	<cfset vb_pagebreak = false>
	<cfinclude template="FormatoBoletaPagoDosTerciosImp.cfm">

	<cfsavecontent variable="info">
		<html>
			<head>
			<title>&nbsp;</title>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
			</head>		
			<body>				
				<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
					<tr><td><cfoutput>#DETALLE#</cfoutput></td></tr>
				</table>				
			</body>
		</html>
	</cfsavecontent>
	
	<!----<cfoutput>#info#</cfoutput>---->

<!--- ENVÍA EL EMAIL --->
<cfinclude template="../../pago/operacion/EnviarEmails-funciones.cfm">

<cfscript>
	dequien = getRHPvalor(190);
	if (len(trim(dequien)) gt 0)
	{
		paraquien = "";
		enviarAlAdmin = getRHPvalor(170);
		if ( len(trim(enviarAlAdmin)) gt 0 and enviarAlAdmin eq 1 )
		{
			admin = getRHPvalor(180);
			if ( len(trim(admin)) gt 0 ) {
				paraquien = getEmailFromAdmin(admin);
			}
		}
		else
		{
			if ( len(trim(rsEncabEmpleado.DEemail)) gt 0 )
			{
				paraquien = rsEncabEmpleado.DEemail;
			}
			else
			{
				emailJefe = getEmailFromJefe(Form.DEid);
				if ( len(trim(emailJefe)) gt 0 )
				{
					paraquien = emailJefe;
				}
				else
				{
					admin = getRHPvalor(180);
					if ( len(trim(admin)) gt 0 ) {
						paraquien = getEmailFromAdmin(admin);
					}
				}
			}
		}
		
		mensaje = info;
				
		if ( len(trim(paraquien)) gt 0 )
		{
			enviarCorreo(dequien , paraquien, titulo, mensaje);
		}
	}
</cfscript>

<!--- RETORNA A LA PANTALLA --->
<html>
<head>
</head>
<body>
<cfoutput>

<form action="HResultadoCalculo.cfm" method="get" name="form1">
	<input type="hidden" name="RCNid" value="#form.RCNid#">
	<input type="hidden" name="Tcodigo" value="#Form.Tcodigo#">
	<input type="hidden" name="DEid" value="#form.DEid#">
	<input type="hidden" name="CPcodigo" value="#Form.CPcodigo#">
	<!---<input type="hidden" name="Regresar" value="/cfmx/rh/nomina/consultas/ConsultaRCalculo.cfm">--->
	<cfif isdefined("form.Regresar") and trim(form.Regresar) neq 'HistoricoPagos.cfm' >
		<input type="hidden" name="Regresar" value="#form.regresar#">
	</cfif>

	<cfif isDefined("Form.chkIncidencias")>
		<input type="hidden" name="chkIncidencias" value="1">
	</cfif>

	<cfif isDefined("Form.chkCargas")>
		<input type="hidden" name="chkCargas" value="1">
	</cfif>

	<cfif isDefined("Form.chkDeducciones")>
		<input type="hidden" name="chkDeducciones" value="1">
	</cfif>

	<input type="hidden" name="enviado" id="enviado" value="true">
</form>

</cfoutput>
<script language="javascript" type="text/javascript">
	document.form1.submit();
</script>

</body>
</html>


<cftransaction> 
	<cf_dbtemp name="kfc" returnvariable="BACKfc" datasource="#session.dsn#">
		<cf_dbtempcol name="NumRegistro"  		   type="numeric" identity="yes">
		<cf_dbtempcol name="TipoRegistro" 		   type="char(1)" mandatory="no">
		<cf_dbtempcol name="NumeroPlan"   		   type="char(4)" mandatory="no">	
		<cf_dbtempcol name="NumeroEnvio"  		   type="char(5)" mandatory="no">			
		<cf_dbtempcol name="NumeroReferencia"  	 type="char(20)" mandatory="no">			
		<cf_dbtempcol name="NumeroRegistro"  	   type="char(5)" mandatory="no">		
		<cf_dbtempcol name="Periodo"  			     type="char(4)" mandatory="no">
		<cf_dbtempcol name="Mes"  				       type="char(2)" mandatory="no">
		<cf_dbtempcol name="Dia"  				       type="char(2)" mandatory="no">		
		<cf_dbtempcol name="SalLiquido"			     type="numeric(18,0)" mandatory="no">			
		<cf_dbtempcol name="TotalRegistros"		   type="char(5)" mandatory="no">		
		<cf_dbtempcol name="CodReg"				       type="numeric(1)"  mandatory="no">
		<cf_dbtempcol name="NombreFunc"			     type="char(35)" mandatory="no">
		<cf_dbtempcol name="Concepto"			       type="char(28)" mandatory="no">
		<cf_dbtempcol name="CodigoError"		     type="char(30)" mandatory="no">
		<cf_dbtempcol name="CuentaBancaria"		   type="char(9)"  mandatory="no">
		<!--- falta descripcion de la nomina --->	
		<cf_dbtempkey cols="NumRegistro">
	</cf_dbtemp>
	
	
<!--- Número de Plan (tipo de contrato con el BAC) --->
			<cfquery name="NumeroPlan" datasource="#session.dsn#">
				select CBcc
				from   CuentasBancos 
				where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
				and Bid=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
			</cfquery>
			<cfif len(NumeroPlan.CBcc) EQ 0>
				<cfthrow message = "El Código de Cliente (Número de Plan) de la Cuenta Bancaria no ha sido definido, Ingrese al Catálogo de Bancos e indique dicho código">
				<cfabort>
			</cfif>
			<cfset NumeroPlan = Mid(rtrim(NumeroPlan.CBcc),1,4)>
			<cfif Len(NumeroPlan) LT 4>
				 <cfset NumeroPlan = repeatstring('0', 4-len(NumeroPlan)) & NumeroPlan>
			</cfif>
			
	<!--- Consecutivo de Archivo--->
			<cfquery name="Consecutivo" datasource="#session.DSN#">
				select Pvalor as NumArch
				from RHParametros 
				where Pcodigo = 210 
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			
			<cfset Consecutivo = Consecutivo.NumArch>			
			<cfif Consecutivo LTE 0 >
				<cfquery name="rsInsertB" datasource="#session.DSN#">
					insert into RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
					values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 210, 'Consecutivo de Archivo de Planilla', '1')
				</cfquery>
			</cfif>
	
			<cfquery name="Consecutivo" datasource="#session.DSN#">
				select Pvalor as NumArch 
				from RHParametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				 and Pcodigo = 210
			</cfquery>
			<cfset bArchivo = Mid(rtrim(Consecutivo.NumArch),1,5)>
			<cfif Len(bArchivo) LT 5>
				 <cfset bArchivo = repeatstring('0', 5-len(bArchivo)) & bArchivo>
			</cfif>
			
			<cfquery name="rsNumReg" datasource="#session.dsn#">
				select count(1) as NumRegistros
				from DRNomina a, ERNomina b, DatosEmpleado c
				Where a.ERNid=b.ERNid
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
				and a.DEid=c.DEid
				and c.Bid is not null
				and a.DRNestado=1  <!--- Marcados como para Pagar --->
			</cfquery>

			<cfset TipoNomina='P'>
			<cfif rsNumReg.NumRegistros EQ 0>
				<cfquery name="rsNumReg" datasource="#session.dsn#">
					select count(1) as NumRegistros
					from HDRNomina a, HERNomina b, DatosEmpleado c
					Where a.ERNid=b.ERNid
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
					and a.DEid=c.DEid
					and c.Bid is not null
					and a.HDRNestado=1	<!--- Marcados como para Pagar --->
				</cfquery>	
				<cfset TipoNomina='H'>		
			</cfif>
			<cfset NumReg = Mid(rtrim(rsNumReg.NumRegistros),1,5)>
			<cfif Len(NumReg) LT 5>
				 <cfset NumReg = repeatstring('0', 5-len(NumReg)) & NumReg>
			</cfif>
	<!--- INSERTA EL ENCABEZADO --->
	<cfquery name="rsInsert" datasource="#session.DSN#">
				insert into #BACKfc# (TipoRegistro, 
											NumeroPlan, 
											NumeroEnvio, 
											NumeroReferencia, 
											NumeroRegistro, 
											Periodo, 
											Mes, 
											Dia, 
											SalLiquido, 
											TotalRegistros, 
											Concepto, 
											CodigoError,
											NombreFunc,
											CuentaBancaria,
											CodReg)
<cfif TipoNomina EQ 'P'> 								
					select 			rtrim('B') as TipoReg, 
											'#NumeroPlan#' as NumeroPlan,
											'#bArchivo#' as NumeroEnvio,
											<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 30)#"> as Referencia,
											'00000' as NumReg,
											rtrim(<cf_dbfunction name="date_format" args="ERNfdeposito,YYYY">) as Periodo,
											rtrim(<cf_dbfunction name="date_format" args="ERNfdeposito,MM">) as Mes,
											rtrim(<cf_dbfunction name="date_format" args="ERNfdeposito,DD">) as Dia,
											0 as TotalLiquidos,
											<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 5-len(NumReg)) & NumReg#"> as TotalRegistros,
											<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 28)#"> as Concepto,
											<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 1)#"> as Reservado,
											<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 35)#"> as NombreBeneficiario,
											'' as Cuenta,
											0 as CodReg
					from 					CalendarioPagos a, ERNomina b
					Where					a.CPid=b.RCNid
					and 					ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
<cfelse>
					select 			rtrim('B') as TipoReg, 
											'#NumeroPlan#' as NumeroPlan,
											'#bArchivo#' as NumeroEnvio,
											<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 30)#"> as Referencia,
											'00000' as NumReg,
											rtrim(<cf_dbfunction name="date_format" args="HERNfdeposito,YYYY">) as Periodo,
											rtrim(<cf_dbfunction name="date_format" args="HERNfdeposito,MM">) as Mes,
											rtrim(<cf_dbfunction name="date_format" args="HERNfdeposito,DD">) as Dia,
											0 as TotalLiquidos,
											<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 5-len(NumReg)) & NumReg#"> as TotalRegistros,
											<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 28)#"> as Concepto,
											<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 1)#"> as Reservado,
											<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 35)#"> as NombreBeneficiario,
											'' as Cuenta,
											0 as CodReg
					from 					CalendarioPagos a, HERNomina b
					Where					a.CPid=b.RCNid
					and 					ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
</cfif>
</cfquery> 
<!--- Concatenador --->
<cf_dbfunction name="OP_concat" returnvariable="CAT" >
	<!--- INSERTA EL DETALLE --->
	<cfquery name="rsInsert" datasource="#session.DSN#">
				insert into #BACKfc# (TipoRegistro, 
										NumeroPlan, 
										NumeroEnvio ,
					  				NumeroReferencia,
										NumeroRegistro,
						      	Periodo, 
										Mes, 
										Dia, 
										SalLiquido, 
										TotalRegistros,
										Concepto,
							   		CodigoError,
										NombreFunc,
							    	CuentaBancaria,
										CodReg )
<cfif TipoNomina EQ 'P'> 
				select 			rtrim('T') AS TipoReg,
										rtrim('#NumeroPlan#') as NumeroPlan,
										rtrim('#bArchivo#') as NumeroArchivo,
										rtrim(coalesce(DEcuenta,' ')) as Identificacion,
										rtrim('00000') as NumeroReg,
										rtrim(<cf_dbfunction name="date_format" args="ERNfdeposito,YYYY">) as Periodo,
										rtrim(<cf_dbfunction name="date_format" args="ERNfdeposito,MM">) as Mes,
										rtrim(<cf_dbfunction name="date_format" args="ERNfdeposito,DD">) as Dia,
						      	        DRNliquido*100 as Liquido,
										rtrim('00000') as TotalRegistros,
									  <cf_dbfunction name="string_part" args="rtrim(ERNdescripcion)|1|28" 	delimiters="|"> as ERNdescripcion,					    
										<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 1)#"> as Reservado,
										<cf_dbfunction name="string_part" args="rtrim(coalesce(upper(DEapellido1),'')) #CAT# ' ' #CAT# rtrim(coalesce(upper(DEapellido2),'')) #CAT# ' ' #CAT# rtrim(coalesce(upper(DEnombre),''))|1|35" 	 delimiters="|">,								
										' ' as Cuenta,
										1 as CodReg  
				from 					CalendarioPagos a, ERNomina b, DRNomina c, DatosEmpleado d
				Where					a.CPid=b.RCNid
				and 					b.ERNid=c.ERNid
				and						c.DEid=d.DEid
				and 					d.Bid is not null				
				and 					c.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
				and 					c.DRNestado=1  <!--- Marcados como para Pagar --->
<cfelse>
				select 			rtrim('T') AS TipoReg,
										rtrim('#NumeroPlan#') as NumeroPlan,
										rtrim('#bArchivo#') as NumeroArchivo,
										rtrim(coalesce(DEcuenta,' ')) as Identificacion,
										rtrim('00000') as NumeroReg,
										rtrim(<cf_dbfunction name="date_format" args="HERNfdeposito,YYYY">) as Periodo,
										rtrim(<cf_dbfunction name="date_format" args="HERNfdeposito,MM">) as Mes,
										rtrim(<cf_dbfunction name="date_format" args="HERNfdeposito,DD">) as Dia,
										HDRNliquido*100 as Liquido,
										rtrim('00000') as TotalRegistros,
										 <cf_dbfunction name="string_part" args="	rtrim(HERNdescripcion)|1|28" 	delimiters="|"> as HERNdescripcion,										
										<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 1)#"> as Reservado,
										<cf_dbfunction name="string_part" args="rtrim(coalesce(upper(DEapellido1),'')) #CAT# ' ' #CAT# rtrim(coalesce(upper(DEapellido2),'')) #CAT# ' ' #CAT# rtrim(coalesce(upper(DEnombre),''))|1|35" 	 delimiters="|">,		
										' ' as Cuenta,
										1 as CodReg
				from 					CalendarioPagos a, HERNomina b, HDRNomina c, DatosEmpleado d
				Where					a.CPid=b.RCNid
				and 					b.ERNid=c.ERNid
				and						c.DEid=d.DEid
				and 					d.Bid is not null					
				and 					c.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
				and 					c.HDRNestado=1  <!--- Marcados como para Pagar --->
</cfif>
		</cfquery>  
		
		<!--- Actualizar El NumeroRegistro		 --->
		<cfquery name="rsAct1" datasource="#session.DSN#">
				update #BACKfc#
				set NumeroRegistro=<cf_dbfunction name="to_char"  args="(NumRegistro-1),0">
		</cfquery>
		<!--- Total de Salarios  --->
		<cfquery name="rsAct1" datasource="#session.DSN#">
				update #BACKfc#
				set SalLiquido= (Select Sum(SalLiquido)
								 from #BACKfc#
								 Where CodReg=1)
				Where CodReg=0
		</cfquery>		
		

	

<cf_dbfunction name="string_part" args="rtrim(NumeroReferencia)|1|20" 	returnvariable="LvarReferencia"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarReferencia#"  		returnvariable="LvarReferenciaL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|20-coalesce(#LvarReferenciaL#,0)" 	returnvariable="LvarReferenciaS" delimiters="|">
				
<cf_dbfunction name="string_part" args="rtrim(NumeroRegistro)|1|5" 	returnvariable="LvarNumeroRegistro"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarNumeroRegistro#"  		returnvariable="LvarNumeroRegistroL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|5-coalesce(#LvarNumeroRegistroL#,0)" 	returnvariable="LvarNumeroRegistroS" delimiters="|">

<cf_dbfunction name="to_char" args="SalLiquido" returnvariable="LvarSalLiq">
	<cf_dbfunction name="string_part" args="rtrim(#LvarSalLiq#)|1|13" 	returnvariable="LvarSalLiqStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarSalLiqStr#"  		returnvariable="LvarSalLiqStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|13-coalesce(#LvarSalLiqStrL#,0)" 	returnvariable="LvarSalLiqStrLS" delimiters="|">
<cf_dbfunction name="string_part" args="TotalRegistros|1|5" 	returnvariable="LvarTotalRegistros"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarTotalRegistros#"  		returnvariable="LvarTotalRegistrosL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|5-#LvarTotalRegistrosL#" 	returnvariable="LvarTotalRegistrosS" delimiters="|">

  <cf_dbfunction name="string_part" args="Concepto|1|28" 	returnvariable="LvarConcepto"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarConcepto#"  		returnvariable="LvarConceptoL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|28-coalesce(#LvarConceptoL#,0)" 	returnvariable="LvarConceptoS" delimiters="|"> 
				
<cf_dbfunction name="string_part" args="NombreFunc|1|35" 	returnvariable="LvarNombreFunc"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarNombreFunc#"  		returnvariable="LvarNombreFuncL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|35-coalesce(#LvarNombreFuncL#,0)" 	returnvariable="LvarNombreFuncS" delimiters="|">
				
<cf_dbfunction name="string_part" args="CuentaBancaria|1|9" 	returnvariable="LvarCuentaBancaria"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarCuentaBancaria#"  		returnvariable="LvarCuentaBancariaL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|9-coalesce(#LvarCuentaBancariaL#,0)" 	returnvariable="LvarCuentaBancariaS" delimiters="|">

  <cfquery name="ERR" datasource="#session.DSN#">
	Select  TipoRegistro #CAT# 
			    NumeroPlan #CAT#
			    NumeroEnvio #CAT#
			    rtrim(#preservesinglequotes(LvarReferencia)#) #CAT# #preservesinglequotes(LvarReferenciaS)# #CAT#
			    #preservesinglequotes(LvarNumeroRegistroS)# #CAT# rtrim(#preservesinglequotes(LvarNumeroRegistro)#) #CAT#
			    Periodo #CAT#
			    Mes #CAT#
					Dia #CAT#
					#preservesinglequotes(LvarSalLiqStrLS)# #CAT# rtrim(#preservesinglequotes(LvarSalLiqStr)#) #CAT#
					case when TotalRegistros='00000' then
						'     '
					else TotalRegistros
					end #CAT#
				
					(#preservesinglequotes(LvarConcepto)#) #CAT# #preservesinglequotes(LvarConceptoS)# #CAT# 
			 		'   '  #CAT#
					(#preservesinglequotes(LvarNombreFunc)#) #CAT# #preservesinglequotes(LvarNombreFuncS)#  #CAT# 
			  	(#preservesinglequotes(LvarCuentaBancaria)#)#CAT# #preservesinglequotes(LvarCuentaBancariaS)# as Salida 
				<!---#preservesinglequotes(LvarTotalRegistrosS)# #CAT# rtrim(#preservesinglequotes(LvarTotalRegistros)#) #CAT# --->
			
				
		from #BACKfc#
		order by CodReg 
  </cfquery> 
<cfset Conse = Consecutivo.NumArch + 1>
<cfquery name="Act" datasource="#session.DSN#">
	update  RHParametros
	set Pvalor= '#Conse#'
	Where Pcodigo=210
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>


</cftransaction>
<!--- NOTA: ESTE EXPORTADOR FUE SOLICITADO A ULTIMA HORA PARA REALIZAR EL PAGO CORRESPONDIENTE A LAS COOPERATIVAS 
Y A LA ASOCIACION, LOS CODIGOS DE LOS RUBROS A TOMAR EN CUENTA Y LAS CÈDULAS JURIDICAS FUERON "QUEMADOS"(PARA MAYOR 
RAPIDEZ DEL DESARROLLO)Y SON EXCLUSIVOS DE BNVITAL.--->
<cftransaction> 
	<cf_dbtemp name="BNcoop2" returnvariable="BNVitalcoop" datasource="#session.dsn#">	
		<cf_dbtempcol name="NumRegistro"  		   type="numeric" identity="yes">	
		<cf_dbtempcol name="ConstanteEncab"   	   type="char(1)" mandatory="no">	
		<cf_dbtempcol name="ConstanteDetall"   	   type="char(1)" mandatory="no">	
		<cf_dbtempcol name="NumEmpresa"  		   type="char(4)" mandatory="no">	
		<cf_dbtempcol name="SalLiquido"			   type="numeric(12,0)" mandatory="no">				
		<cf_dbtempcol name="NumeroRegistro"  	   type="char(4)" mandatory="no">			
		<cf_dbtempcol name="TipoIdent" 	           type="char(1)" mandatory="no"><!---1 Persona Física Nacional, 2 Empresa, 3 Extranjero--->
		<cf_dbtempcol name="Cedula" 	           type="char(15)" mandatory="no">	
		<cf_dbtempcol name="CodReg"				   type="numeric(1)" mandatory="no">
		<cf_dbtempcol name="CodigoError"		   type="char(30)" mandatory="no">	
		<cf_dbtempcol name="TotalRegistros"		   type="char(4)" mandatory="no">	
		<!--- falta descripcion de la nomina --->	
		<cf_dbtempkey cols="NumRegistro">
	</cf_dbtemp>
	
	<cfset ConstanteEncab="1">
	<cfset ConstanteDetall="2">

	<cfquery name="ClienteBanco" datasource="#session.DSN#">
    	select Bcodigocli  as patrono
		from Bancos 
	    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">   
	    and <cf_dbfunction name ="length" args="Bcodigocli"> > 0
    </cfquery>
	 
    <cfset Errs2 = ''>
	<cfif ClienteBanco.RecordCount GT 0>	
		<cfif len(trim(ClienteBanco.patrono)) NEQ 4>
			<cfset Errs2 =  Errs2 & 'El C&oacute;digo de Patrono"'&ClienteBanco.patrono&'" debe tener 4 digitos <br>'>
		</cfif>
    <cfelse>
		<cfset Errs2 =  Errs2 & 'No se ha definido el C&oacute;digo de Patrono. <br>'>
	</cfif>
	
	<cfset TipoNomina = 'P'> 
	<cfquery name="rsRCNid" datasource="#session.DSN#">
    	select RCNid
		from ERNomina 
	    where ERNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
	</cfquery>
	<cfif rsRCNid.RecordCount EQ 0>
		<cfset TipoNomina = 'H'> 
		<cfquery name="rsRCNid" datasource="#session.DSN#">
	    	select RCNid
			from HERNomina 
		    where ERNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
		</cfquery>
	</cfif>
	
	<cfif rsRCNid.Recordcount EQ 0>
		<cfset Errs2 =  Errs2 & 'No existe la nomina enproceso, ni en el historial <br>'>
	</cfif>
	
	<!--- INSERTA EL ENCABEZADO --->
	<cfquery datasource="#session.DSN#">
		insert into #BNVitalcoop# (
							 ConstanteEncab,											
							 NumEmpresa,
							 SalLiquido, 
							 TotalRegistros,
							 CodReg
							 )
		<cfif TipoNomina EQ 'P'> 								
			select 			
					'#ConstanteEncab#',	
					'#trim(ClienteBanco.Patrono)#',																			
					0 ,
					0,<!--- <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 4-len(NumReg)) & NumReg#"> as TotalRegistros, --->
					0														
			from 	CalendarioPagos a, ERNomina b
			Where	a.CPid=b.RCNid
			and 	ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
		
		<cfelse>
			select 			
					'#ConstanteEncab#',
					'#trim(ClienteBanco.Patrono)#',									
					0 ,
					0,<!--- <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 4-len(NumReg)) & NumReg#"> as TotalRegistros,--->
					0
			from 	CalendarioPagos a, HERNomina b
			Where	a.CPid=b.RCNid
			and 	ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
		</cfif>
	</cfquery> 
	
	<!--- INSERTA EL DETALLES --->
	<!--- Concatenador --->
	<cf_dbfunction name="OP_concat" returnvariable="CAT" >
	
	<!--- 1 Persona Física Nacional, 2 Empresa*, 3 Extranjero --->
	<!--- INSERTA PAGO A ASEVITAL --->
	<cfquery datasource="#session.DSN#">
			insert into #BNVitalcoop# (
								 ConstanteDetall,									 
								 TipoIdent,		
								 Cedula,									 		
								 SalLiquido, 																
						   		 CodReg )
			select '#ConstanteDetall#',
								'2',
								'300224803700' as cedula,  	<!--- cedula juridica de ASEVITAL. codigo quemado en forma temporal--->		
						      	sum(x.monto)*100 as Liquido,																 			    
								1 as CodReg  
					from (	
					select 'asevital Pat', sum( coalesce(Montores,0)) as monto
					from RCuentasTipo 
					where Referencia in (14)
					and RCNid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRCNid.RCNid#">
					and tiporeg=55
					group by 'asevital Pat'
					UNION
					--CARGAS
					select 'asevital Emp', sum( coalesce(Montores,0)) as monto
					from RCuentasTipo 
					where Referencia in (15)
					and RCNid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRCNid.RCNid#">
					and tiporeg = 50
					group by 'asevital Emp'
					UNION
					--DEDUCCIONES
					select 'asevital Pres', sum( coalesce(a.DCValor,0))as monto
					from HDeduccionesCalculo a
					  inner join DeduccionesEmpleado b
					  on b.Did = a.Did
					  and b.TDid in (142,3)
					where a.RCNid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRCNid.RCNid#">
					 and b.TDid in (142,3)
					group by 'asevital Pres'
					UNION
					select 'asevital Aho', sum( coalesce(a.DCValor,0))as monto
					from HDeduccionesCalculo a
					  inner join DeduccionesEmpleado b
					  on b.Did = a.Did
					  and b.TDid in (143,9)
					where a.RCNid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRCNid.RCNid#">
					 and b.TDid in (143,9)
					group by 'asevital Aho'
				)x 
	</cfquery> 
	
	<!--- INSERTA PAGO A ADEVAN --->
	<cfquery datasource="#session.DSN#">
			insert into #BNVitalcoop# (
								 ConstanteDetall,									 
								 TipoIdent,		
								 Cedula,									 		
								 SalLiquido, 																
						   		 CodReg)
			select '#ConstanteDetall#',
								'2',
								'300209966200' as cedula,  	<!--- cedula juridica de ASEVITAL. codigo quemado en forma temporal--->		
						      	sum(x.monto)*100 as Liquido,																 			    
								1 as CodReg 
					from (	
					select 'Adevan', sum( coalesce(a.DCValor,0)) as monto
						from HDeduccionesCalculo a
						  inner join DeduccionesEmpleado b
						  on b.Did = a.Did
						  and b.TDid in (4)
						where a.RCNid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRCNid.RCNid#">
						 and b.TDid in (4)
						group by 'Adevan'
				)x 
	</cfquery>	
		
	<!--- INSERTA PAGO A COOPEBANA --->
	<cfquery datasource="#session.DSN#">
			insert into #BNVitalcoop# (
								 ConstanteDetall,									 
								 TipoIdent,		
								 Cedula,									 		
								 SalLiquido, 																
						   		 CodReg)
			select '#ConstanteDetall#',
								'2',
								'300405680400' as cedula,  	<!--- cedula juridica de ASEVITAL. codigo quemado en forma temporal--->		
						      	sum(x.monto)*100 as Liquido,																 			    
								1 as CodReg   
					from (	
					select 'Coopebana', sum( coalesce(a.DCValor,0)) as monto
						from HDeduccionesCalculo a
						  inner join DeduccionesEmpleado b
						  on b.Did = a.Did
						  and b.TDid in (6)
						where a.RCNid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRCNid.RCNid#">
						 and b.TDid in (6)
						group by 'Coopebana'
					
				)x 
	</cfquery>	
	
	<!--- INSERTA PAGO A COOPEBANACIO --->
	<cfquery datasource="#session.DSN#">
			insert into #BNVitalcoop# (
								 ConstanteDetall,									 
								 TipoIdent,		
								 Cedula,									 		
								 SalLiquido, 																
						   		 CodReg)
			select '#ConstanteDetall#',
								'2',
								'300405146000' as cedula,  	<!--- cedula juridica de ASEVITAL. codigo quemado en forma temporal--->		
						      	sum(x.monto)*100 as Liquido,																 			    
								1 as CodReg   
					from (	
						select 'Coopebanacio', sum( coalesce(a.DCValor,0)) as monto
						from HDeduccionesCalculo a
						  inner join DeduccionesEmpleado b
						  on b.Did = a.Did
						  and b.TDid in (144,7,141)
						where a.RCNid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRCNid.RCNid#">
						 and b.TDid in (144,7,141)
						group by 'Coopebanacio'
				)x 
	</cfquery>	
	<!--- INSERTA PAGO A FONDO SOCORRO MUTUO --->
	<cfquery datasource="#session.DSN#">
			insert into #BNVitalcoop# (
								 ConstanteDetall,									 
								 TipoIdent,		
								 Cedula,									 		
								 SalLiquido, 																
						   		 CodReg )
			select '#ConstanteDetall#',
								'2',
								'300220308900' as cedula,  	<!--- cedula juridica de ASEVITAL. codigo quemado en forma temporal--->		
						      	sum(x.monto)*100 as Liquido,																 			    
								1 as CodReg   
					from (	
						select 'Fondo Socorro Mutuo', sum( coalesce(a.DCValor,0)) as monto
						from HDeduccionesCalculo a
						  inner join DeduccionesEmpleado b
						  on b.Did = a.Did
						  and b.TDid in (5)
						where a.RCNid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRCNid.RCNid#">
						 and b.TDid in (5)
						group by 'Fondo Socorro Mutuo'
				)x 
	</cfquery>	
		
	<!--- Actualizar El NumeroRegistro --->
	<cfquery  datasource="#session.DSN#">
			update #BNVitalcoop#
			set NumeroRegistro=<cf_dbfunction name="to_char"  args=" NumRegistro-1"> <!---(NumRegistro-1),0 --->
	</cfquery>
	
	<!--- Total de Salarios  --->
	<cfquery  datasource="#session.DSN#">
			update #BNVitalcoop#
			set SalLiquido= (Select Sum(SalLiquido)
							 from #BNVitalcoop#
							 Where CodReg=1)
			Where CodReg=0
	</cfquery>
	
	<!--- Actualizar El TotalRegistros --->
	<cfquery  datasource="#session.DSN#" name="rsCantReg">
		select NumeroRegistro as cantidad 
		from #BNVitalcoop#
		where SalLiquido > 0
	</cfquery>
	
	<cfquery  datasource="#session.DSN#">
			update #BNVitalcoop#
			set TotalRegistros=<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 4-len(rsCantReg.RecordCount-1)) & rsCantReg.RecordCount-1#"> 
			Where CodReg=0
	</cfquery>
	
	
	<cfquery  datasource="#session.DSN#">
			Select Sum(SalLiquido)
			 from #BNVitalcoop#
			 Where CodReg=1
	</cfquery>
			
	<cfquery  datasource="#session.DSN#">
			Select Sum(SalLiquido)
					 from #BNVitalcoop#
					 Where CodReg=1
	</cfquery>
	
<cf_dbfunction name="to_char" args="SalLiquido" returnvariable="LvarSalLiq">
	<cf_dbfunction name="string_part" args="rtrim(#LvarSalLiq#)|1|12" 	returnvariable="LvarSalLiqStr"  delimiters="|">
		<cf_dbfunction name="length" args="#LvarSalLiqStr#"  		returnvariable="LvarSalLiqStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|12-coalesce(#LvarSalLiqStrL#,0)" 	returnvariable="LvarSalLiqStrLS" delimiters="|">

<cf_dbfunction name="string_part" args="TotalRegistros|1|4" 	returnvariable="LvarTotalRegistros"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarTotalRegistros#"  		returnvariable="LvarTotalRegistrosL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|4-#LvarTotalRegistrosL#" 	returnvariable="LvarTotalRegistrosS" delimiters="|">
							
<cf_dbfunction name="string_part" args="rtrim(Cedula)|1|15" 	returnvariable="LvarCedula"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarCedula#"  		returnvariable="LvarCedulaL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|15-#LvarCedulaL#" 	returnvariable="LvarCedulaS" delimiters="|">				
				
 <cfquery name="ERR" datasource="#session.DSN#">
  select rtrim(ConstanteEncab) #CAT# 
        rtrim(NumEmpresa) #CAT# 
        #preservesinglequotes(LvarSalLiqStrLS)# #CAT# rtrim(#preservesinglequotes(LvarSalLiqStr)#)  #CAT#
  		 TotalRegistros as salida
  from #BNVitalcoop#
  where CodReg=0
  and SalLiquido > 0
  
  Union   
  select  rtrim(ConstanteDetall) #CAT# 
  		  rtrim(TipoIdent)  #CAT# 
		  rtrim(#preservesinglequotes(LvarCedula)#) #CAT# #preservesinglequotes(LvarCedulaS)# #CAT#
		  #preservesinglequotes(LvarSalLiqStrLS)# #CAT# rtrim(#preservesinglequotes(LvarSalLiqStr)#)  as Salida
  
  from #BNVitalcoop#
  where CodReg=1
  and SalLiquido > 0
  
  </cfquery> 

</cftransaction>
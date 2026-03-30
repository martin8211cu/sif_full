
<cftransaction> 
	<cf_dbtemp name="BN" returnvariable="BNTEC" datasource="#session.dsn#">	
		<cf_dbtempcol name="NumRegistro"  		   type="numeric" identity="yes">	
		<cf_dbtempcol name="ConstanteEncab"   	   type="char(5)" mandatory="no">	
		<cf_dbtempcol name="ConstanteDetall"   	   type="char(1)" mandatory="no">	
		<cf_dbtempcol name="SalLiquido"			   type="numeric(12,0)" mandatory="no">				
		<cf_dbtempcol name="NumeroRegistro"  	   type="char(4)" mandatory="no">			
		<cf_dbtempcol name="TipoIdent" 	           type="char(1)" mandatory="no">
		<cf_dbtempcol name="Cedula" 	           type="char(15)" mandatory="no">	
		<cf_dbtempcol name="CodReg"				   type="numeric(1)"  mandatory="no">
		<cf_dbtempcol name="CodigoError"		   type="char(30)" mandatory="no">	
		<cf_dbtempcol name="TotalRegistros"		   type="char(4)" mandatory="no">					
		<!--- falta descripcion de la nomina --->	
		<cf_dbtempkey cols="NumRegistro">
	</cf_dbtemp>
	
	<cfset ConstanteEncab="12477">
	<cfset ConstanteDetall="2">

						
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
	<cfset NumReg = Mid(rtrim(rsNumReg.NumRegistros),1,4)>
	<cfif Len(NumReg) LT 4>
		 <cfset NumReg = repeatstring('0', 4-len(NumReg)) & NumReg>
	</cfif>
	
	
	<!--- INSERTA EL ENCABEZADO --->
	<cfquery datasource="#session.DSN#">
				insert into #BNTEC# (
									 ConstanteEncab,											
									 SalLiquido, 
									 NumeroRegistro,
									 TotalRegistros,
									<!--- CodigoError,	--->										
								     CodReg)
<cfif TipoNomina EQ 'P'> 								
					select 			
									'#ConstanteEncab#',																			
									0 ,
									'0000' as NumReg,	
									<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 4-len(NumReg)) & NumReg#"> as TotalRegistros,										
									<!---<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 1)#"> as Reservado,		--->								
									0 as CodReg
																					
					from 					CalendarioPagos a, ERNomina b
					Where					a.CPid=b.RCNid
					and 					ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
<cfelse>
					select 			
									'#ConstanteEncab#',										
									0 ,
									'0000' as NumReg,	
									<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 4-len(NumReg)) & NumReg#"> as TotalRegistros,										
								<!---	<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 1)#"> as Reservado,	--->										
									0 as CodReg
											
					from 					CalendarioPagos a, HERNomina b
					Where					a.CPid=b.RCNid
					and 					ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
</cfif>
</cfquery> 

<!--- Concatenador --->
<cf_dbfunction name="OP_concat" returnvariable="CAT" >

	<!--- INSERTA EL DETALLE --->
	<cfquery datasource="#session.DSN#">
				insert into #BNTEC# (
									 ConstanteDetall,									 
									 TipoIdent,		
									 Cedula,									 		
									 SalLiquido, 																
							   	<!---	 CodigoError,				--->					
									 CodReg )
										
										
<cfif TipoNomina EQ 'P'> 
				select 			
								'#ConstanteDetall#',
								d.NTIcodigo,
								d.DEidentificacion as cedula,  			
						      	DRNliquido*100 as Liquido,																 			    
							<!---	<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 1)#"> as Reservado,--->
								1 as CodReg  
								
				from 					CalendarioPagos a, ERNomina b, DRNomina c, DatosEmpleado d
				Where					a.CPid=b.RCNid
				and 					b.ERNid=c.ERNid
				and						c.DEid=d.DEid
				and 					d.Bid is not null				
				and 					c.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
				and 					c.DRNestado=1  <!--- Marcados como para Pagar --->
<cfelse>
				select 			
								'#ConstanteDetall#',
								d.NTIcodigo,
								d.DEidentificacion as cedula,  	
								HDRNliquido*100 as Liquido,																								
							<!---	<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 1)#"> as Reservado,--->
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
		<cfquery  datasource="#session.DSN#">
				update #BNTEC#
				set NumeroRegistro=<cf_dbfunction name="to_char"  args="(NumRegistro-1),0">
		</cfquery>			
		<!--- Total de Salarios  --->
		<cfquery  datasource="#session.DSN#">
				update #BNTEC#
				set SalLiquido= (Select Sum(SalLiquido)
								 from #BNTEC#
								 Where CodReg=1)
				Where CodReg=0
		</cfquery>		
		
		<!--- Actualiza el tipo de Identificacion , Si es "I"= Indocumentado o "P"=Pasaporte o "R"=Residente o "T"=Permiso de trabajo es de tipo Extranjero si no es        Costarricense --->
		<cfquery datasource="#session.DSN#">
				update #BNTEC#
				set TipoIdent = (select Case 
								 when TipoIdent in ('C','G') then '1' 
								 when TipoIdent in ('I', 'P', 'R', 'T') then '3'
								 else '1'
								 end
				                 from #BNTEC# banco2
								 Where CodReg=1
								 and banco2.Cedula = #BNTEC#.Cedula )
				Where CodReg=1
		</cfquery>	
		

<cf_dbfunction name="to_char" args="SalLiquido" returnvariable="LvarSalLiq">
	<cf_dbfunction name="string_part" args="rtrim(#LvarSalLiq#)|1|12" 	returnvariable="LvarSalLiqStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarSalLiqStr#"  		returnvariable="LvarSalLiqStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|12-coalesce(#LvarSalLiqStrL#,0)" 	returnvariable="LvarSalLiqStrLS" delimiters="|">

<cf_dbfunction name="string_part" args="TotalRegistros|1|4" 	returnvariable="LvarTotalRegistros"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarTotalRegistros#"  		returnvariable="LvarTotalRegistrosL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|4-#LvarTotalRegistrosL#" 	returnvariable="LvarTotalRegistrosS" delimiters="|">
				
<cf_dbfunction name="string_part" args="rtrim(NumeroRegistro)|1|4" 	returnvariable="LvarNumeroRegistro"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarNumeroRegistro#"  		returnvariable="LvarNumeroRegistroL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|4-coalesce(#LvarNumeroRegistroL#,0)" 	returnvariable="LvarNumeroRegistroS" delimiters="|">
								
<cf_dbfunction name="string_part" args="rtrim(Cedula)|1|15" 	returnvariable="LvarCedula"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarCedula#"  		returnvariable="LvarCedulaL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|15-#LvarCedulaL#" 	returnvariable="LvarCedulaS" delimiters="|">				
			
				
  <cfquery name="ERR" datasource="#session.DSN#">
  select rtrim(ConstanteEncab) #CAT# 
         #preservesinglequotes(LvarSalLiqStrLS)# #CAT# rtrim(#preservesinglequotes(LvarSalLiqStr)#) #CAT#
  		 TotalRegistros
  from #BNTEC#
  where CodReg=0
  
  Union   
  select  rtrim(ConstanteDetall) #CAT# 
          rtrim(TipoIdent)  #CAT# 
		  rtrim(#preservesinglequotes(LvarCedula)#) #CAT# #preservesinglequotes(LvarCedulaS)# #CAT#
		  #preservesinglequotes(LvarSalLiqStrLS)# #CAT# rtrim(#preservesinglequotes(LvarSalLiqStr)#)  as Salida
  
  from #BNTEC#
  where CodReg=1  	
  </cfquery> 

	

</cftransaction>
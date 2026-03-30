
<cftransaction> 
	<cf_dbtemp name="BN" returnvariable="BNVital" datasource="#session.dsn#">	
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
		and Bid =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">   
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
    					
	<cfquery name="rsNumReg" datasource="#session.dsn#">
		select count(1) as NumRegistros
		from DRNomina a, ERNomina b, DatosEmpleado c
		Where a.ERNid=b.ERNid
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
		and a.DEid=c.DEid
		and c.Bid is not null
		and a.DRNestado=1  <!--- Marcados como para Pagar --->
		and a.DRNLiquido > 0
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
			and a.HDRNLiquido > 0
		</cfquery>	
		<cfset TipoNomina='H'>		
	</cfif>
	<cfset NumReg = Mid(rtrim(rsNumReg.NumRegistros),1,4)>
	<cfif Len(NumReg) LT 4>
		 <cfset NumReg = repeatstring('0', 4-len(NumReg)) & NumReg>
	</cfif>
	
	<!--- INSERTA EL ENCABEZADO --->
	<cfquery datasource="#session.DSN#">
		insert into #BNVital# (
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
					<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 4-len(NumReg)) & NumReg#"> as TotalRegistros,
					0
																			
			from 	CalendarioPagos a, ERNomina b
			Where	a.CPid=b.RCNid
			and 	ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
		
		<cfelse>
			select 			
					'#ConstanteEncab#',
					'#trim(ClienteBanco.Patrono)#',									
					0 ,
					<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 4-len(NumReg)) & NumReg#"> as TotalRegistros,
					0
			from 	CalendarioPagos a, HERNomina b
			Where	a.CPid=b.RCNid
			and 	ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
		</cfif>
	</cfquery> 
 
	<!--- Concatenador --->
	<cf_dbfunction name="OP_concat" returnvariable="CAT" >
	
	<!--- INSERTA EL DETALLE --->
	<cfquery datasource="#session.DSN#">
				insert into #BNVital# (
									 ConstanteDetall,									 
									 TipoIdent,		
									 Cedula,									 		
									 SalLiquido, 																
							   		 CodReg )
										
			<cfif TipoNomina EQ 'P'> 
				select 			
								'#ConstanteDetall#',
								d.NTIcodigo,
								d.DEidentificacion as cedula,  			
						      	DRNliquido*100 as Liquido,																 			    
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
		
	<cfquery name="rsQ"  datasource="#session.DSN#">
		select 			
								'#ConstanteDetall#',
								d.NTIcodigo,
								d.DEidentificacion as cedula,  	
								HDRNliquido*100 as Liquido,																								
								1 as CodReg
										
				from 					CalendarioPagos a, HERNomina b, HDRNomina c, DatosEmpleado d
				Where					a.CPid=b.RCNid
				and 					b.ERNid=c.ERNid
				and						c.DEid=d.DEid
				and 					d.Bid is not null					
				and 					c.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
				and 					c.HDRNestado=1  <!--- Marcados como para Pagar --->
	</cfquery>
	
	<!--- Actualizar El NumeroRegistro		 --->
	<cfquery  datasource="#session.DSN#">
			update #BNVital#
			set NumeroRegistro=<cf_dbfunction name="to_char"  args=" NumRegistro-1"> <!---(NumRegistro-1),0 --->
	</cfquery>	
			
	<!--- Total de Salarios  --->
	<cfquery  datasource="#session.DSN#">
			update #BNVital#
			set SalLiquido= (Select Sum(SalLiquido)
							 from #BNVital#
							 Where CodReg=1)
			Where CodReg=0
	</cfquery>
	
	<cfquery  datasource="#session.DSN#">
			Select Sum(SalLiquido)
			 from #BNVital#
			 Where CodReg=1
	</cfquery>
			
	<cfquery  datasource="#session.DSN#">
			Select Sum(SalLiquido)
					 from #BNVital#
					 Where CodReg=1
	</cfquery>
	
	<!--- Actualiza el tipo de Identificacion , Si es "I"= Indocumentado o "P"=Pasaporte o "R"=Residente o "T"=Permiso de trabajo es de tipo Extranjero si no es        Costarricense --->
	<!--- 1 Persona Física Nacional, 2 Empresa, 3 Extranjero --->
	<cfquery datasource="#session.DSN#">
			update #BNVital#
			set TipoIdent = (select Case 
								when TipoIdent is null then '2' 
								when TipoIdent in ('C') then '1' 
							 	else '3'
							 	end
			                 from #BNVital# banco2
							 Where CodReg=1
							 and banco2.Cedula = #BNVital#.Cedula )
			Where CodReg=1
	</cfquery>	
	
	<!--- Actualizar El TotalRegistros --->
	<cfquery  datasource="#session.DSN#" name="rsCantReg">
		select NumeroRegistro as cantidad 
		from #BNVital#
		where SalLiquido > 0
	</cfquery>
	
	<cfquery  datasource="#session.DSN#">
			update #BNVital#
			set TotalRegistros=<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 4-len(rsCantReg.RecordCount-1)) & rsCantReg.RecordCount-1#"> 
			Where CodReg=0
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
  from #BNVital#
  where CodReg=0
  and SalLiquido > 0
  
  Union   
  select  rtrim(ConstanteDetall) #CAT# 
  		  rtrim(TipoIdent)  #CAT# 
		  rtrim(#preservesinglequotes(LvarCedula)#) #CAT# #preservesinglequotes(LvarCedulaS)# #CAT#
		  #preservesinglequotes(LvarSalLiqStrLS)# #CAT# rtrim(#preservesinglequotes(LvarSalLiqStr)#)  as Salida
  
  from #BNVital#
  where CodReg=1
  and SalLiquido > 0
  
  </cfquery> 

</cftransaction>
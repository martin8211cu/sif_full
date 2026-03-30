<cftransaction> 
	<cf_dbtemp name="BCAC" returnvariable="BCAC_TEC" datasource="#session.dsn#">	
		<cf_dbtempcol name="NumeroReferencia"  	     type="char(7)" mandatory="no">			
		<cf_dbtempcol name="CuentaBancaria"		     type="char(12)"  mandatory="no">
		<cf_dbtempcol name="BCCorrienteyBCAhorros"   type="char(3)" mandatory="no">	
		<cf_dbtempcol name="TipoMov"                 type="char(1)" mandatory="no">	        <!--- Me falta --->		
		<cf_dbtempcol name="SalLiquido"			     type="numeric(17,2)" mandatory="no">	<!--- Con punto para separador de decimales verificar --->
		<cf_dbtempcol name="Comentario"			     type="char(50)" mandatory="no">				
		<cf_dbtempcol name="CodigoError"		     type="char(30)" mandatory="no">			
	</cf_dbtemp>
	
	<!--- Concatenador --->
	<cf_dbfunction name="OP_concat" returnvariable="CAT" >	
				
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
			<cfquery name="rsFechayBanco" datasource="#session.dsn#">
				select min( a.DRNper) as ano , min (a.DRNmes) as mes,min( b.Bid) as Bid
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
				
				<cfquery name="rsFechayBanco" datasource="#session.dsn#">
					select  min( a.HDRNper) as ano , min (a.HDRNmes) as mes,min( b.Bid) as Bid
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
										
			<cfset mes = '#rsFechayBanco.mes#'  >
			<cfset LvarReferencia = '#rsFechayBanco.ano#'>
			
	         <cfquery name="rsVerificaCta1" datasource="#session.DSN#">
                select 1
                from DatosEmpleado
                where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> 
                  and (DEcuenta is null or CBTcodigo is null)
            </cfquery>
            <cfquery name="rsVerificaCta2" datasource="#session.DSN#">
                select 1
                from DatosEmpleado
                where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> 
                  and <cf_dbfunction name="length" args="rtrim(DEcuenta)"> > 12
            </cfquery>
            <cfif rsVerificaCta1.RecordCount GT 0>
                <cfquery name="ERR" datasource="#session.DSN#">
                    select 'SE HAN PRODUCCIDO LOS SIGUIENTES ERRORES:',1
                    union
                    select {fn concat(DEidentificacion
                            ,{fn concat(' ' 
                            ,{fn concat(DEnombre
                            ,{fn concat(DEapellido1
                            ,case when CBTcodigo is null then ' No se a definido tipo de cuenta(Ahorro o Corriente)' when DEcuenta is null then ' No se a definido la cuenta' else '' end
                            )})})})},2
                    from DatosEmpleado
                    where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> 
                      and (DEcuenta is null or CBTcodigo is null)
                </cfquery>
            </cfif>
             <cfif rsVerificaCta2.RecordCount GT 0>
                <cfquery name="ERR" datasource="#session.DSN#">
                    select 'SE HAN PRODUCCIDO LOS SIGUIENTES ERRORES:',1
                    union
                    select {fn concat(DEidentificacion
                            ,{fn concat(' ' 
                            ,{fn concat(DEnombre
                            ,{fn concat(DEapellido1
                            ,' El número de dígitos de la cuenta debe ser 12'
                            )})})})},2
                    from DatosEmpleado
                    where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> 
                      and <cf_dbfunction name="length" args="rtrim(DEcuenta)"> > 12
                </cfquery>
            </cfif>
			<cfif rsVerificaCta1.RecordCount EQ 0 and rsVerificaCta2.RecordCount EQ 0>
					<!--- La cuenta de la empresa el Tecnologico la guardara en el campo Codigo de cliente en el catalogo de Bancos --->			
                    <cfquery name="rsBanco" datasource="#session.dsn#">
                    select Bcodigocli 
                    from Bancos
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and Bid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
                    </cfquery>
                     
                    <cfset CuentaEmpresa = '#rsBanco.Bcodigocli#'>
                    
                    <!--- INSERTA EL ENCABEZADO --->
                    <cfquery datasource="#session.DSN#">
                        insert into #BCAC_TEC# (NumeroReferencia, 
                                              CuentaBancaria,
                                              BCCorrienteyBCAhorros,									  									  
                                              TipoMov,											  																		  											
                                              SalLiquido, 										  										
                                              Comentario
                                              )
                                                    
                    <cfif TipoNomina EQ 'P'> 								
                            select 													
                                                    '#LvarReferencia#' #CAT# '-' #CAT# <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 2-len(mes)) & mes#">,
                                                    '#CuentaEmpresa#',
                                                    'BCC' as BCCorrienteyBCAhorros,																						
                                                    'D' as TipoMov, 																						
                                                    0 as TotalLiquidos,																					
                                                    <cf_dbfunction name="string_part" args="rtrim(ERNdescripcion)|1|50" 	delimiters="|"> as ERNdescripcion		
                                                    
                                                    
                            from 					CalendarioPagos a, ERNomina b
                            Where					a.CPid=b.RCNid
                            and 					ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
                    <cfelse>
                            select 												
                                                    '#LvarReferencia#' #CAT# '-' #CAT# <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 2-len(mes)) & mes#">,
                                                    '#CuentaEmpresa#',
                                                    'BCC' as BCCorrienteyBCAhorros,											
                                                    'D' as TipoMov, 																							
                                                    0 as TotalLiquidos,																						
                                                    <cf_dbfunction name="string_part" args="rtrim(HERNdescripcion)|1|50" 	delimiters="|"> as ERNdescripcion		
                                                    
                                                    
                            from 					CalendarioPagos a, HERNomina b
                            Where					a.CPid=b.RCNid
                            and 					ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
                    </cfif>
            
                </cfquery> 			
                    
                    
        
            <!--- INSERTA EL DETALLE --->
            <cfquery datasource="#session.DSN#">
                        insert into #BCAC_TEC# (TipoMov,
                                                NumeroReferencia,																				
                                                SalLiquido, 											
                                                Comentario,										
                                                CuentaBancaria,
                                                BCCorrienteyBCAhorros )
        <cfif TipoNomina EQ 'P'> 
                            select 		
                                    'C',
                                    '#LvarReferencia#' #CAT# '-' #CAT# <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 2-len(mes)) & mes#">,																	
                                    DRNliquido as Liquido,										
                                    <cf_dbfunction name="string_part" args="rtrim(ERNdescripcion)|1|50" 	delimiters="|"> as ERNdescripcion,											  			    		<!---	<cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring(' ', 1)#"> as Reservado,--->
                                    rtrim(coalesce(DEcuenta, ' ')) as Cuenta,
                                    case when d.CBTcodigo = 0 then 'BCC' else 'BCA' end
                                                
                        from 					CalendarioPagos a, ERNomina b, DRNomina c, DatosEmpleado d
                        Where					a.CPid=b.RCNid
                        and 					b.ERNid=c.ERNid
                        and						c.DEid=d.DEid
                        and 					d.Bid is not null				
                        and 					c.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
                        and 					c.DRNestado=1  <!--- Marcados como para Pagar --->
                         and d.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
        <cfelse>
                            select 	
                                    'C',
                                    '#LvarReferencia#' #CAT# '-' #CAT# <cfqueryparam cfsqltype="cf_sql_char" value="#repeatstring('0', 2-len(mes)) & mes#">,								
                                    HDRNliquido as Liquido,
                                    <cf_dbfunction name="string_part" args="	rtrim(HERNdescripcion)|1|50" 	delimiters="|"> as HERNdescripcion,										
                                    rtrim(coalesce(DEcuenta,' ')) as Cuenta,
                                    case when d.CBTcodigo = 0 then 'BCC' else 'BCA' end
                        from 					CalendarioPagos a, HERNomina b, HDRNomina c, DatosEmpleado d
                        Where					a.CPid=b.RCNid
                        and 					b.ERNid=c.ERNid
                        and						c.DEid=d.DEid
                        and 					d.Bid is not null					
                        and 					c.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
                        and 					c.HDRNestado=1  <!--- Marcados como para Pagar --->
                         and d.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
        </cfif>
                </cfquery>  
                
        <!--- Total de Salarios  --->
        <cfquery datasource="#session.DSN#">
            update #BCAC_TEC#
            set SalLiquido= (Select Sum(SalLiquido)
                             from #BCAC_TEC#
                             Where TipoMov='C')
            Where TipoMov='D'
        </cfquery>		
                
                    
        <cf_dbfunction name="string_part" args="rtrim(NumeroReferencia)|1|7" 	returnvariable="LvarReferencia"  delimiters="|">
                <cf_dbfunction name="length"      args="#LvarReferencia#"  		returnvariable="LvarReferenciaL" delimiters="|" >
                        <cf_dbfunction name="sRepeat"     args="''|7-coalesce(#LvarReferenciaL#,0)" 	returnvariable="LvarReferenciaS" delimiters="|">
                        
         <cf_dbfunction name="to_char" args="SalLiquido" returnvariable="LvarSalLiq">
            <cf_dbfunction name="string_part" args="rtrim(#LvarSalLiq#)|1|17" 	returnvariable="LvarSalLiqStr"  delimiters="|">
                <cf_dbfunction name="length"      args="#LvarSalLiqStr#"  		returnvariable="LvarSalLiqStrL" delimiters="|" >
                        <cf_dbfunction name="sRepeat"     args="'0'|17-coalesce(#LvarSalLiqStrL#,0)" 	returnvariable="LvarSalLiqStrLS" delimiters="|">
                        
        <cf_dbfunction name="string_part" args="rtrim(CuentaBancaria)|1|12" 	returnvariable="LvarCuentaBancaria"  delimiters="|">
                <cf_dbfunction name="length"      args="#LvarCuentaBancaria#"  		returnvariable="LvarCuentaBancariaL" delimiters="|" >
                        <cf_dbfunction name="sRepeat"     args="'0'|12-coalesce(#LvarCuentaBancariaL#,0)" 	returnvariable="LvarCuentaBancariaS" delimiters="|">									
        
        <cf_dbfunction name="string_part" args="Comentario|1|50" 	returnvariable="LvarComentario"  delimiters="|">
                <cf_dbfunction name="length"      args="#LvarComentario#"  		returnvariable="LvarComentarioL" delimiters="|" >
                        <cf_dbfunction name="sRepeat"     args="' '|50-coalesce(#LvarComentarioL#,0)" 	returnvariable="LvarComentarioS" delimiters="|"> 
            
                                
        <cf_dbfunction name="string_part" args="BCCorrienteyBCAhorros|1|3" 	returnvariable="LvarBCCorrienteyBCAhorros"  delimiters="|">
                <cf_dbfunction name="length"      args="#LvarBCCorrienteyBCAhorros#"  		returnvariable="LvarBCCorrienteyBCAhorrosL" delimiters="|" >
                        <cf_dbfunction name="sRepeat"     args="' '|3-coalesce(#LvarBCCorrienteyBCAhorrosL#,0)" 	returnvariable="LvarBCCorrienteyBCAhorrosS" delimiters="|">				
        
          <cfquery name="ERR" datasource="#session.DSN#">  
            Select  
                   rtrim(#preservesinglequotes(LvarReferencia)#) #CAT# #preservesinglequotes(LvarReferenciaS)# #CAT#
                  (#preservesinglequotes(LvarCuentaBancariaS)#)#CAT# #preservesinglequotes(LvarCuentaBancaria)# #CAT#
                   rtrim(#preservesinglequotes(LvarBCCorrienteyBCAhorros)#) #CAT# #preservesinglequotes(LvarBCCorrienteyBCAhorrosS)# #CAT#
                   TipoMov	#CAT#
                   #preservesinglequotes(LvarSalLiqStrLS)# #CAT# rtrim(#preservesinglequotes(LvarSalLiqStr)#) #CAT#									
                  (#preservesinglequotes(LvarComentario)#) #CAT# #preservesinglequotes(LvarComentarioS)#  
                     
              from #BCAC_TEC#
              where TipoMov= 'D'
              
              union
          
            Select  
                    rtrim(#preservesinglequotes(LvarReferencia)#) #CAT# #preservesinglequotes(LvarReferenciaS)# #CAT#
                    (#preservesinglequotes(LvarCuentaBancariaS)#)#CAT# #preservesinglequotes(LvarCuentaBancaria)# #CAT#
                    rtrim(#preservesinglequotes(LvarBCCorrienteyBCAhorros)#) #CAT# #preservesinglequotes(LvarBCCorrienteyBCAhorrosS)# #CAT#
                    TipoMov	#CAT#		
                    #preservesinglequotes(LvarSalLiqStrLS)# #CAT# rtrim(#preservesinglequotes(LvarSalLiqStr)#) #CAT#									
                    (#preservesinglequotes(LvarComentario)#) #CAT# #preservesinglequotes(LvarComentarioS)#  as salida
            from #BCAC_TEC#
            where TipoMov = 'C'	
           
          </cfquery> 
  	</cfif>
</cftransaction>

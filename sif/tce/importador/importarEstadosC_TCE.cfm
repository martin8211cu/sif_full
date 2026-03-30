<!--- DEFINICIONES INICIALES --->
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
	<cfset bcheck1 = false> <!---- Empresa ------>
	<cfset bcheck2 = false> <!---- tarjeta habiente ------>
	<cfset bcheck3 = false> <!---- Cuenta TCE ------>
	<cfset bcheck4 = false> <!---- Tipo de Tarjeta ------>
	<cfset bcheck5 = false> <!---- Fecha estado de cuenta------>
	<cfset bcheck6 = false> <!---- Oficina ------>
    <cfset bcheck7 = false> <!---- Saldo Ant. Pesos ------>
 	<cfset bcheck8 = false> <!---- Saldo Ant. Dolares ------>
    <cfset bcheck9 = false> <!---- Saldo Act. Pesos ------>
	<cfset bcheck10 = false> <!---- Saldo Act. Dolares ------>
	<cfset bcheck11 = false> <!---- Det. Movimiento ------>
	<cfset bcheck12 = false> <!---- RFC Movimiento ------>
	<cfset bcheck13 = false> <!---- Num. Referencia ------>
	<cfset bcheck14 = false> <!---- Importe Pesos ------>
	<cfset bcheck15 = false> <!---- Importe Dolares ------>

<!--- VALIDACIONES --->
	<!--- Check1. Validar que la empresa sea correcta--->
	<cfquery name="rsCheck1" datasource="#session.DSN#">
	 select count(1) as check1
		from #table_name# a
		where a.Empresa <> #session.ecodigo#
	</cfquery>
    <cfif #rsCheck1.check1# gt 0>
       <cfset bcheck1 = rsCheck1.check1 gt 0>   
    </cfif>     
  	<!--- Check2. Validar que la tarjeta exista --->
	<cfquery name="rsCheck2" datasource="#session.DSN#">
   	select count(1) as check2
		from #table_name# a
		where not exists ( select 1 
				from CBTarjetaCredito b 
				where a.CuentaTCE =  b.CBTNumTarjeta
                and b.Ecodigo = #session.ecodigo#
        )
	</cfquery>
		<cfset bcheck2 = rsCheck2.check2 gt 0>

<!--- ERRORES --->
<cfif  bcheck1>
	<cfquery name="ERR" datasource="#session.DSN#">
		select 'Existe mas de una empresa en el archivo' as Error , a.Empresa		
		from #table_name# a
		where a.Empresa <> #session.ecodigo#
	</cfquery>
<cfelseif bcheck2>    
   <cfquery name="ERR" datasource="#session.DSN#">
		select 'La cuenta no existe' as Error , a.CuentaTCE				
		from #table_name# a
		where not exists ( select 1 
				from CBTarjetaCredito b 
				where a.CuentaTCE =  b.CBTNumTarjeta
                and b.Ecodigo = #session.ecodigo#
        )
	</cfquery>  
</cfif>    

       <!---- Para EC en modeda local Creditos---->
       <cfquery name="rsECLoc" datasource="#session.dsn#">
          select distinct CuentaTCE
          from #table_name# 
          where SaldoActMonLoc > 0.00 and tipoMov = 'C'
        </cfquery>        
        <cfquery name="rsMonLoc" datasource="#session.dsn#">
             select Mcodigo
             from Empresas 
             where Ecodigo = #session.Ecodigo#
        </cfquery>        
		<cfif rsMonLoc.recordcount eq 0 > 
               <cfthrow message="No existe una moneda local definida para la empresa">
        </cfif>
        <cfif rsECLoc.recordcount gt 0>      
                <cfloop query="rsECLoc">  
                        <!---Obtengo los CBid ----->
                        <cfquery name="rslocTCE" datasource="#session.dsn#">
                          Select b.CBid
                           from CBTarjetaCredito a 
                                  inner join CuentasBancos b 
                                  on a.CBTCid = b.CBTCid
                              where 
                            a.CBTNumTarjeta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECLoc.CuentaTCE#">
                            and b.Mcodigo = #rsMonLoc.Mcodigo#
                       </cfquery>
                       
                       <cfif rslocTCE.recordcount eq 0>
                           <cfthrow message="No se encontro la Cuenta Bancaria para la tarjeta: #rsECLoc.CuentaTCE#.">
                       <cfelse>                                           
                           <cfquery name="rsCBidEC" datasource="#session.dsn#">
                               select CBid  from ECuentaBancaria where CBid =  #rslocTCE.CBid#
                           </cfquery> 
                       </cfif>
                       
                       <!----Si ya existe un CBid en EcuentaBancaria------>
                       <cfif rsCBidEC.recordcount neq 0>            
                                
                                   <!--- Fecha del estado de cuenta  ---->                       
                                   <cfquery name="rsFecha1" datasource="#session.dsn#">
                                     select 
                                      <cf_dbfunction name="to_datetime"	args="FechaEstadoCta" YMD="true">  as FechaEstadoCta				
                                    from #table_name# a 
                                          where CuentaTCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECLoc.CuentaTCE#"> and 
                                          SaldoActMonLoc > 0.00  and tipoMov = 'C'
                                   </cfquery> 
                                    <cfif len(trim(rsFecha1.FechaEstadoCta)) eq 0>
                                         <cfthrow message="La fecha del estado de cuenta esta vacío #rsECLoc.CuentaTCE#">
                                    </cfif>   
                                    
                                    <cfset PeriodoLoc= #DatePart("yyyy", rsFecha1.FechaEstadoCta)#>  <!----Periodo (Año) del estado de cuenta----->
                                    <cfset MesLocal= #DatePart("m", rsFecha1.FechaEstadoCta)#>       <!----Mes del estado de cuenta----->                           
							   
							   <!----Obtengo la fecha de EC registradas para CBid----->
                               <cfquery name="rsFechaLoc" datasource="#session.dsn#">
                               select ECid from ECuentaBancaria where CBid =  #rslocTCE.CBid# 
                               and ECdesde < '#rsFecha1.FechaEstadoCta#'  
                               and EChasta > '#rsFecha1.FechaEstadoCta#'  
                               </cfquery>               
                               
							   <cfif rsFechaLoc.recordcount gt 0>
                                   <cfquery name="ERR" datasource="#session.DSN#">
                                                select distinct CuentaTCE,'La cuenta ya ha sido registrada para este periodo-mes.Proceso Cancelado!' as Error 
                                                from #table_name# 
                                                where CuentaTCE = <cfqueryparam value="#rsECLoc.CuentaTCE#" cfsqltype="cf_sql_varchar"> and tipoMov = 'C'                
                                             </cfquery>  
                                   <cfset bcheck3 =  true>           
                               </cfif>                           
                               
                       </cfif>          
               </cfloop>
      </cfif> 
                   
     <!---- Para EC en modeda Extranjera Creditos ---->
       <cfquery name="rsECExt" datasource="#session.dsn#">
          select distinct CuentaTCE
          from #table_name# 
          where SaldoActMonOri > 0.00 and tipoMov = 'C'
        </cfquery>     
      
        <!---- Obtengo los dolares ---->
        <cfquery name="rsMonExt" datasource="#session.dsn#">
         Select Mcodigo 
         from Monedas 
         where Miso4217 = 'USD'
         and Ecodigo = #session.Ecodigo#
        </cfquery>             
		<cfif rsMonExt.recordcount eq 0 > 
               <cfthrow message="No existe una moneda Extranjera definida para la empresa">
        </cfif>
        <cfif rsECExt.recordcount gt 0>      
          <cfloop query="rsECExt">         
				<!---Obtengo los CBid ----->
                <cfquery name="rsExtTCE" datasource="#session.dsn#">
                  Select b.CBid
                   from CBTarjetaCredito a 
                          inner join CuentasBancos b 
                          on a.CBTCid = b.CBTCid
                      where 
                    a.CBTNumTarjeta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECExt.CuentaTCE#">
                    and b.Mcodigo = #rsMonExt.Mcodigo#
               </cfquery>               
              <cfif rsExtTCE.recordcount eq 0>
                 <cfthrow message="No se encontro la Cuenta Bancaria para la tarjeta: #rsECExt.CuentaTCE#.">
              <cfelse>                                      
			   <cfquery name="rsCBidEC" datasource="#session.dsn#">
                   select distinct CBid  from ECuentaBancaria where CBid =  #rsExtTCE.CBid#
               </cfquery>                
             </cfif>  
               
               <!----Si ya existe un CBid en EcuentaBancaria------>
               <cfif rsCBidEC.recordcount neq 0>                
                              
                            
                            <!--- Fecha del estado de cuenta  ---->                       
                           <cfquery name="rsFecha2" datasource="#session.dsn#">
                             select 
                             <cf_dbfunction name="to_datetime"	args="FechaEstadoCta" YMD="true">  as FechaEstadoCta							
                            from #table_name# a 
                                  where CuentaTCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECExt.CuentaTCE#"> and 
                                  SaldoActMonOri > 0.00  
                                  and tipoMov = 'C'
                           </cfquery>                            
                            <cfif len(trim(rsFecha2.FechaEstadoCta)) eq 0>
                                <cfthrow message="En el estado de cuenta para la tarjeta: #rsECExt.CuentaTCE#, la fecha esta vacío.">
                            </cfif> 
                            <cfset PeriodoExt= #DatePart("yyyy", rsFecha2.FechaEstadoCta)#> <!--- Periodo (Año) para el que quiero subir el estado de cuenta---->
                            <cfset MesExt= #DatePart("m", rsFecha2.FechaEstadoCta)#>        <!--- Mes para el que quiero subir el estado de cuenta---->
      
                                    
						   <!----Obtengo la fecha de EC registradas para CBid----->
                           <cfquery name="rsFechaExt" datasource="#session.dsn#">
                               select ECid from ECuentaBancaria where CBid =  #rsExtTCE.CBid# 
                               and ECdesde < <cf_jdbcquery_param value="#rsFecha2.FechaEstadoCta#" cfsqltype="cf_sql_date">     
                               and EChasta > <cf_jdbcquery_param value="#rsFecha2.FechaEstadoCta#" cfsqltype="cf_sql_date">                             
                           </cfquery>     
                          
                           <cfif rsFechaExt.recordcount gt 0>
                               <cfquery name="ERR" datasource="#session.DSN#">
                                select  distinct CuentaTCE, 'La cuenta ya ha sido registrada para este periodo-mes.Proceso Cancelado!' as Error 				
                                from #table_name# 
                                where CuentaTCE = <cfqueryparam value="#rsECExt.CuentaTCE#" cfsqltype="cf_sql_varchar">     
                                and tipoMov = 'C'              
                               </cfquery>  
                            <cfset bcheck3 =  true>      
                          </cfif>                                                        
               </cfif>  
          </cfloop> 
       </cfif>
        <!---- Para EC en modeda local Debitos---->
       <cfquery name="rsECLoc" datasource="#session.dsn#">
          select distinct CuentaTCE
          from #table_name# 
          where SaldoActMonLoc > 0.00 and tipoMov = 'D'
        </cfquery>        
        <cfquery name="rsMonLoc" datasource="#session.dsn#">
             select Mcodigo
             from Empresas 
             where Ecodigo = #session.Ecodigo#
        </cfquery>        
		<cfif rsMonLoc.recordcount eq 0 > 
               <cfthrow message="No existe una moneda local definida para la empresa">
        </cfif>
        <cfif rsECLoc.recordcount gt 0>      
                <cfloop query="rsECLoc">  
                        <!---Obtengo los CBid ----->
                        <cfquery name="rslocTCE" datasource="#session.dsn#">
                          Select b.CBid
                           from CBTarjetaCredito a 
                                  inner join CuentasBancos b 
                                  on a.CBTCid = b.CBTCid
                              where 
                            a.CBTNumTarjeta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECLoc.CuentaTCE#">
                            and b.Mcodigo = #rsMonLoc.Mcodigo#
                       </cfquery>
                       
                       <cfif rslocTCE.recordcount eq 0>
                           <cfthrow message="No se encontro la Cuenta Bancaria para la tarjeta: #rsECLoc.CuentaTCE#.">
                       <cfelse>                                           
                           <cfquery name="rsCBidEC" datasource="#session.dsn#">
                               select CBid  from ECuentaBancaria where CBid =  #rslocTCE.CBid#
                           </cfquery> 
                       </cfif>
                       
                       <!----Si ya existe un CBid en EcuentaBancaria------>
                       <cfif rsCBidEC.recordcount neq 0>            
                               
                                 <!--- Fecha del estado de cuenta  ---->                       
                                   <cfquery name="rsFecha1" datasource="#session.dsn#">
                                     select <cf_dbfunction name="to_date00"	args="FechaEstadoCta">  as FechaEstadoCta,
                                     <cf_dbfunction name="to_datetime"	args="FechaEstadoCta" YMD="true">  as FechaEstadoCta				
                                    from #table_name# a 
                                          where CuentaTCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECExt.CuentaTCE#"> and 
                                          SaldoActMonLoc > 0.00  and tipoMov = 'D'
                                   </cfquery> 
                                    <cfif len(trim(rsFecha1.FechaEstadoCta)) eq 0>
                                     <cfthrow message="La fecha del estado de cuenta esta vacío #rsECExt.CuentaTCE#">
                                    </cfif>                                 
                                   
                                   <cfset PeriodoLoc= #DatePart("yyyy", rsFecha1.FechaEstadoCta)#>
                                   <cfset MesLocal= #DatePart("m", rsFecha1.FechaEstadoCta)#>     
                              
							   
							   <!----Obtengo la fecha de EC registradas para CBid----->
                               <cfquery name="rsFechaLoc" datasource="#session.dsn#">
                               select ECid from ECuentaBancaria where CBid =  #rslocTCE.CBid# 
                               and ECdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsFecha1.FechaEstadoCta#">
                               and EChasta > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsFecha1.FechaEstadoCta#">
                             <!---  and 	<cf_dbfunction name="date_part"	args="YYYY, ECfecha"> = #PeriodoLoc#
                               and  <cf_dbfunction name="date_part"	args="MM, ECfecha"> = #MesLocal#--->
                               </cfquery>               
                             
							   <cfif rsFechaLoc.recordcount gt 0>
                                   <cfquery name="ERR" datasource="#session.DSN#">
                                                select distinct CuentaTCE,'La cuenta ya ha sido registrada para este periodo-mes.Proceso Cancelado!' as Error 
                                                from #table_name# 
                                                where CuentaTCE = <cfqueryparam value="#rsECLoc.CuentaTCE#" cfsqltype="cf_sql_varchar"> and tipoMov = 'D'                
                                             </cfquery>  
                                <cfset bcheck3 =  true>      
                             </cfif>                                                        
                   </cfif>  
              </cfloop> 
       </cfif>
                   
     <!---- Para EC en modeda Extranjera  Debitos ---->
       <cfquery name="rsECExt" datasource="#session.dsn#">
          select distinct CuentaTCE
          from #table_name# 
          where SaldoActMonOri > 0.00 and tipoMov = 'D'
        </cfquery>     
      
        <!---- Obtengo los dolares ---->
        <cfquery name="rsMonExt" datasource="#session.dsn#">
         Select Mcodigo 
         from Monedas 
         where Miso4217 = 'USD'
         and Ecodigo = #session.Ecodigo#
        </cfquery>             
		<cfif rsMonExt.recordcount eq 0 > 
               <cfthrow message="No existe una moneda Extranjera definida para la empresa">
        </cfif>
        <cfif rsECExt.recordcount gt 0>      
          <cfloop query="rsECExt">         
				<!---Obtengo los CBid ----->
                <cfquery name="rsExtTCE" datasource="#session.dsn#">
                  Select b.CBid
                   from CBTarjetaCredito a 
                          inner join CuentasBancos b 
                          on a.CBTCid = b.CBTCid
                      where 
                    a.CBTNumTarjeta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECExt.CuentaTCE#">
                    and b.Mcodigo = #rsMonExt.Mcodigo#
               </cfquery>               
              <cfif rsExtTCE.recordcount eq 0>
                 <cfthrow message="No se encontro la Cuenta Bancaria para la tarjeta: #rsECExt.CuentaTCE#.">
              <cfelse>                                      
			   <cfquery name="rsCBidEC" datasource="#session.dsn#">
                   select distinct CBid  from ECuentaBancaria where CBid =  #rsExtTCE.CBid#
               </cfquery>                
             </cfif>  
               
               <!----Si ya existe un CBid en EcuentaBancaria------>
               <cfif rsCBidEC.recordcount neq 0>                
                                
                            
                            <!--- Fecha del estado de cuenta  ---->                       
                           <cfquery name="rsFecha2" datasource="#session.dsn#">
                             select <!---<cf_dbfunction name="to_date00"	args="FechaEstadoCta">  as FechaEstadoCta--->
                             <cf_dbfunction name="to_datetime"	args="FechaEstadoCta" YMD="true">  as FechaEstadoCta				
                            from #table_name# a 
                                  where CuentaTCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECExt.CuentaTCE#"> and 
                                  SaldoActMonOri > 0.00 
                                  and tipoMov = 'D' 
                           </cfquery> 
                            <cfif len(trim(rsFecha2.FechaEstadoCta)) eq 0>
                               <cfthrow message="La fecha del estado de cuenta esta vacío #rsECExt.CuentaTCE#">
                            </cfif> 
                            
                            <cfset PeriodoExt= #DatePart("yyyy", rsFecha2.FechaEstadoCta)#>
                            <cfset MesExt    = #DatePart("m", rsFecha2.FechaEstadoCta)#>                                                                                   
                            
                                                
						   <!----Obtengo la fecha de EC registradas para CBid----->
                           <cfquery name="rsFechaExt" datasource="#session.dsn#">
                               select ECid from ECuentaBancaria where CBid =  #rsExtTCE.CBid# 
                               and ECdesde < '#rsFecha2.FechaEstadoCta#'
                               and EChasta > '#rsFecha2.FechaEstadoCta#'
                              <!--- and 	<cf_dbfunction name="date_part"	args="YYYY, ECfecha"> = #PeriodoExt#
                               and <cf_dbfunction name="date_part"	args="MM, ECfecha"> = #MesExt#--->                               
                           </cfquery> 
                                                                                              
                           <cfif rsFechaExt.recordcount gt 0>
                               <cfquery name="ERR" datasource="#session.DSN#">
                                            select  distinct CuentaTCE, 'La cuenta ya ha sido registrada para este periodo-mes.Proceso Cancelado!' as Error 				
                                            from #table_name# 
                                            where CuentaTCE = <cfqueryparam value="#rsECExt.CuentaTCE#" cfsqltype="cf_sql_varchar">    
                                            and tipoMov = 'D'             
                               </cfquery>  
                            <cfset bcheck3 =  true>      
                      </cfif>                                                        
               </cfif>  
          </cfloop> 
       </cfif>      

<cfif not bcheck1 and not bcheck2 and not bcheck3 >
	<cftransaction>

<!----------********************************************************************************---->    
       <!---- Obtengo el resumen de las lineas  en moneda local ----->  
<!----------********************************************************************************---->           
       
        <cfquery name="rsCuentasLoc" datasource="#session.dsn#">
          select distinct CuentaTCE
          from #table_name# 
          where SaldoActMonLoc > 0.00 and tipoMov = 'C'
        </cfquery>  
        
        <cfquery name="rsMonedaLocal" datasource="#session.dsn#">
         select Mcodigo
         from Empresas 
         where Ecodigo = #session.Ecodigo#
        </cfquery>
       <cfif rsMonedaLocal.recordcount eq 0>
          <cfthrow message="La moneda Local no se pudo obtener. proceso cancelado!">
        </cfif>
			<cfif rsCuentasLoc.recordcount gt 0 >
             <cfloop query="rsCuentasLoc">
                   <cfquery name="rsDatosLoc" datasource="#session.dsn#">
                      Select a.Bid, b.CBid , a.CBTCfechacorte as DiaCorte  
                       from CBTarjetaCredito a 
                              inner join CuentasBancos b 
                              on a.CBTCid = b.CBTCid
                          where 
                        a.CBTNumTarjeta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentasLoc.CuentaTCE#">
                        and b.Mcodigo = #rsMonedaLocal.Mcodigo#
                   </cfquery>
                   <cfif len(trim(rsDatosLoc.Bid)) eq 0>
                       <cfthrow message="Para la cuenta en moneda local: #rsCuentasLoc.CuentaTCE# , no se pudo obtener el banco. Proceso cancelado!">
                   </cfif>
                    <cfif len(trim(rsDatosLoc.CBid)) eq 0>
                       <cfthrow message="Para la cuenta en moneda local: #rsCuentasLoc.CuentaTCE# , no se pudo obtener la cuenta bancaria. Proceso cancelado!">
                   </cfif>
                   <cfif len(trim(rsDatosLoc.DiaCorte)) eq 0>
                        <cfthrow message="Para la cuenta en moneda local: #rsCuentasLoc.CuentaTCE#, no se pudo obtener el día de corte. Proceso cancelado!">
                   <cfelse>
                         <cfset LvarDiaCorte = rsDatosLoc.DiaCorte>
                   </cfif>
                                     
                    <cfquery name="rsFechaEC" datasource="#session.dsn#">
                     select FechaEstadoCta
                    from #table_name# a 
                          where CuentaTCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentasLoc.CuentaTCE#"> and 
                          SaldoActMonLoc > 0.00 and tipoMov = 'C'                   </cfquery>                
                    <cfset LvarYear =  Left(#rsFechaEC.FechaEstadoCta#,4)>
                    <cfset LvarMes  =  Left(#rsFechaEC.FechaEstadoCta#,6)>
                    <cfset LvarMes  =  Right(#LvarMes#,2)>
                    
                    <cfset LvarFechaCorte= createdate(LvarYear,LvarMes,LvarDiaCorte)>             
                    <cfset LvarFechaAnt = dateadd("m",-1,LvarFechaCorte)>
                    <cfset LvarFechaAnt = dateadd("d",+1,LvarFechaAnt)>
                    <cfset LvarFechas = "Desde: #dateFormat(LvarFechaAnt,'DD/MM/YYYY')# - hasta: #dateFormat(LvarFechaCorte,'DD/MM/YYYY')#">                                     
                   
                    <cfquery name="rsInserMovLoc" datasource="#session.dsn#">
                       select distinct <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDatosLoc.Bid#"> as Bid,                                
                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDatosLoc.CBid#"> as CBid
                        from #table_name# a 
					          where 
                                    CuentaTCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentasLoc.CuentaTCE#"> and 
                                    SaldoActMonLoc > 0.00  
                    </cfquery>             
                   <cfif rsInserMovLoc.recordcount eq 1>
                        <cfquery name="ERR" datasource="#session.DSN#">
                            insert into ECuentaBancaria (   Bid, 
                                                            ECfecha, 
                                                            CBid,
                                                            ECsaldoini,
                                                            ECsaldofin,
                                                            ECdebitos,
                                                            ECcreditos,                                                                                                               
                                                            ECdescripcion,
                                                            ECusuario,
                                                            ECdesde ,
                                                            EChasta,                                                       
                                                            ECaplicado,
                                                            EChistorico,
                                                            ECobservacion, 
                                                            ECStatus 
                                                         ) 
                                                         values
                                                         (
                                                          <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsInserMovLoc.Bid#">,
                                                          '#rsFechaEC.FechaEstadoCta#',
                                                          #rsInserMovLoc.CBid#,
                                                          <cfqueryparam cfsqltype="cf_sql_money" value="0.00">,
                                                          <cfqueryparam cfsqltype="cf_sql_money" value="0.00">,
                                                          <cfqueryparam cfsqltype="cf_sql_money" value="0.00">,   
                                                          <cfqueryparam cfsqltype="cf_sql_money" value="0.00">,
                                                          <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarFechas#"> ,
                                                          <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usulogin#">,
                                                          <cf_dbfunction name="to_datetime"	args="#LvarFechaAnt#" YMD="false">,
                                                          <cf_dbfunction name="to_datetime"	args="#LvarFechaCorte#" YMD="false">,
                                                          'N',
                                                          'N',   
                                                          'Desde importador EC -Tarjetas de credito',
                                                          <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                                                         )
    
                           <cf_dbidentity1 datasource="#session.DSN#">				
                          </cfquery>
                       <cf_dbidentity2 datasource="#session.DSN#" name="ERR">
                   
                    <cfset LvarEncabezado = ERR.identity >
                   <cfquery name="rsMovCreditos" datasource="#session.dsn#">
                    select   
                        SaldoAntMonLoc, 
                       (SaldoActMonLoc *-1) as SaldoActMonLoc 
                     from #table_name# a 
					    where 
                           CuentaTCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentasLoc.CuentaTCE#"> 
                      and SaldoActMonLoc > 0.00 
                      and tipoMov = 'C'                     
                    </cfquery>
                    <cfif rsMovCreditos.recordcount gt 0>
                      <cfquery name="rsUpdC" datasource="#session.dsn#">
                          update ECuentaBancaria
                          set   
                             ECsaldoini = #rsMovCreditos.SaldoAntMonLoc#,
                             ECsaldofin = ECsaldofin + #rsMovCreditos.SaldoActMonLoc#,                             
                             ECcreditos = #rsMovCreditos.SaldoActMonLoc#
                          where  ECid =  #LvarEncabezado# 
                     </cfquery>                        
                   </cfif>  
                   <cfquery name="rsMovDebitos" datasource="#session.dsn#">
                      select 
                         SaldoAntMonLoc, 
                         SaldoActMonLoc                             
                      from #table_name# a 
                          where 
                            CuentaTCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentasLoc.CuentaTCE#"> 
                    and SaldoActMonLoc > 0.00  
                    and tipoMov = 'D'                     
                   </cfquery>
                   <cfif rsMovDebitos.recordcount gt 0>
                       <cfquery name="rsUpdC" datasource="#session.dsn#">
                            update ECuentaBancaria
                              set   
                                 ECsaldoini = #rsMovDebitos.SaldoAntMonLoc#,
                                <!--- ECsaldofin = ECsaldofin + #rsMovDebitos.SaldoActMonLoc#,  --->                            
                                 ECdebitos = #rsMovDebitos.SaldoActMonLoc#
                              where  ECid =  #LvarEncabezado# 
                       </cfquery>
                  </cfif> 
                    
           </cfif>                       
                   <cfquery name="rsBanco" datasource="#session.dsn#">
                    select Bdescripcion from Bancos 
                    where Bid = #rsDatosLoc.Bid#
                   </cfquery>

                   <cfquery name="rsTMB" datasource="#session.dsn#">
                    select BTEcodigo from TransaccionesBanco 
                    where Bid = #rsDatosLoc.Bid#
                    and BTEtce = 1
                    and BTEtipo = 'C'    
                   </cfquery>
                   <cfif rsTMB.recordcount eq 0>
                       <cfthrow message="No existe una transacción de tipo 'Credito' en tarjeta de crédito para el banco:#rsBanco.Bdescripcion#. Proceso cancelado!">
                   </cfif>
                   
                    <cfquery name="ERR" datasource="#session.DSN#">
                        insert into DCuentaBancaria (ECid, 
                                                     BTEcodigo,  
                                                     Documento, 
                                                     DCfecha, 
                                                     DCmontoori, 
                                                     DCmontoloc, 
                                                     DCReferencia, 
                                                     DCtipocambio, 
                                                     DCtipo, 
                                                     DCconciliado,
                                                     Ecodigo,
                                                     Bid) 
                        select <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarEncabezado#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTMB.BTEcodigo#">,
                                <cf_dbfunction name="spart" args="a.Detalle,1,20">,
                                FechaEstadoCta, 
                                ImporteLoc,
                                ImporteLoc, 
                                NumRFC, 
                                1.00, 
                                'C', 
                                'N', 
                                #session.Ecodigo#,
                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDatosLoc.Bid#">
                        from #table_name# a 
                     where ImporteLoc > 0.00
                     and SaldoActMonLoc = 0
                     and CuentaTCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentasLoc.CuentaTCE#">
                     and tipoMov = 'C'
                    </cfquery>  
                           
                    <cfquery name="ERR" datasource="#session.DSN#">
                        insert into DCuentaBancaria (ECid, 
                                                     BTEcodigo,  
                                                     Documento, 
                                                     DCfecha, 
                                                     DCmontoori, 
                                                     DCmontoloc, 
                                                     DCReferencia, 
                                                     DCtipocambio, 
                                                     DCtipo, 
                                                     DCconciliado,
                                                     Ecodigo,
                                                     Bid) 
                        select <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarEncabezado#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTMB.BTEcodigo#">,
                                <cf_dbfunction name="spart" args="a.Detalle,1,20">,
                                FechaEstadoCta, 
                                ImporteLoc,
                                ImporteLoc, 
                                NumRFC, 
                                1.00, 
                                'D', 
                                'N', 
                                #session.Ecodigo#,
                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDatosLoc.Bid#">
                        from #table_name# a 
                     where ImporteLoc > 0.00
                     and SaldoActMonLoc = 0
                     and CuentaTCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentasLoc.CuentaTCE#">
                     and tipoMov = 'D'
                    </cfquery>  
                               
            </cfloop> 
          </cfif>   

<!--------------**************************************************************-------------------------> 
    <!---- Obtengo el resumen de las lineas  en moneda Origen ----->       	
<!--------------**************************************************************------------------------->
        <cfquery name="rsCuentasOri" datasource="#session.dsn#">
          select distinct CuentaTCE
          from #table_name# 
          where SaldoActMonOri > 0.00 and tipoMov = 'C'
        </cfquery>  
        <!---- Obtengo los dolares ---->
        <cfquery name="rsDolares" datasource="#session.dsn#">
         Select Mcodigo 
         from Monedas 
         where Miso4217 = 'USD'
         and Ecodigo = #session.Ecodigo#
        </cfquery>
        <cfif rsDolares.recordcount eq 0>
          <cfthrow message="La moneda Dolares, no se pudo obtener. proceso cancelado!">
        </cfif>
        
			<cfif rsCuentasOri.recordcount gt 0 >
             <cfloop query="rsCuentasOri">
                   <cfquery name="rsDatosOri" datasource="#session.dsn#">
                        Select a.Bid, b.CBid, a.CBTCfechacorte as DiaCorte    
                       from CBTarjetaCredito a 
                              inner join CuentasBancos b 
                              on a.CBTCid = b.CBTCid                            
                          where 
                        a.CBTNumTarjeta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentasOri.CuentaTCE#">
                        and b.Mcodigo = #rsDolares.Mcodigo#
                        and a.Ecodigo = #session.Ecodigo#
                   </cfquery>
                   <cfif len(trim(rsDatosOri.Bid)) eq 0 >
                       <cfthrow message="Para la cuenta en dolares: #rsCuentasOri.CuentaTCE#, no se pudo obtener el banco. Proceso cancelado!">
                   </cfif>
                   <cfif len(trim(rsDatosOri.CBid)) eq 0 >
                       <cfthrow message="Para la cuenta en dolares: #rsCuentasOri.CuentaTCE#, no se pudo obtener la cuenta bancaria. Proceso cancelado!">
                   </cfif>
                  
                   <cfif len(trim(rsDatosOri.DiaCorte)) eq 0>
                        <cfthrow message="Para la cuenta en dolares: #rsCuentasOri.CuentaTCE#, no se pudo obtener el día de corte. Proceso cancelado!">
                   <cfelse>
                         <cfset LvarDiaCorte = rsDatosOri.DiaCorte>
                   </cfif>
                                     
                    <cfquery name="rsFechaEC" datasource="#session.dsn#">
                     select FechaEstadoCta
                    from #table_name# a 
                          where CuentaTCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentasOri.CuentaTCE#"> and 
                          SaldoActMonOri > 0.00  and tipoMov = 'C'
                   </cfquery>                
                    <cfset LvarYear =  Left(#rsFechaEC.FechaEstadoCta#,4)>
                    <cfset LvarMes  =   Left(#rsFechaEC.FechaEstadoCta#,6)>
                    <cfset LvarMes  =   Right(#LvarMes#,2)>
                    
                    <cfset LvarFechaCorte= createdate(LvarYear,LvarMes,LvarDiaCorte)>             
                    <cfset LvarFechaAnt = dateadd("m",-1,LvarFechaCorte)>
                    <cfset LvarFechaAnt = dateadd("d",+1,LvarFechaAnt)>
                    <cfset LvarFechas = "Desde: #dateFormat(LvarFechaAnt,'DD/MM/YYYY')# - hasta: #dateFormat(LvarFechaCorte,'DD/MM/YYYY')#">
            
                     <cfquery name="rsMovOri" datasource="#session.dsn#">
                          select distinct <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDatosOri.Bid#"> as Bid,                                 
                                  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDatosOri.CBid#"> as CBid      
                             from #table_name# a 
                               where CuentaTCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentasOri.CuentaTCE#"> and 
                                SaldoActMonOri > 0.00                                           
                     </cfquery>                                      
                      <cfif  rsMovOri.recordcount eq 1>
                         <cfloop query="rsMovOri">
                            <cfquery name="ERR" datasource="#session.DSN#">
                                insert into ECuentaBancaria (   Bid, 
                                                                ECfecha, 
                                                                CBid,
                                                                ECsaldoini,
                                                                ECsaldofin,
                                                                ECdebitos,
                                                                ECcreditos,
                                                                ECdescripcion,
                                                                ECusuario,
                                                                ECdesde ,
                                                                EChasta,                                                            
                                                                ECaplicado,
                                                                EChistorico,
                                                                ECobservacion, 
                                                                ECStatus )
                                                                values
                                                                (
                                                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMovOri.Bid#">,
                                                                '#rsFechaEC.FechaEstadoCta#',
                                                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMovOri.CBid#">,
                                                                <cfqueryparam cfsqltype="cf_sql_money" value="0.00">,
                                                                <cfqueryparam cfsqltype="cf_sql_money" value="0.00">,
                                                                <cfqueryparam cfsqltype="cf_sql_money" value="0.00">,   
                                                                <cfqueryparam cfsqltype="cf_sql_money" value="0.00">,                                                               
                                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarFechas#">,
                                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usulogin#">,
                                                                <cf_dbfunction name="to_datetime"	args="#LvarFechaAnt#" YMD="false">,
                                                                <cf_dbfunction name="to_datetime"	args="#LvarFechaCorte#" YMD="false">,                                                                
                                                                'N',
                                                                'N',                                                        
                                                                'Desde importador EC -Tarjetas de credito ',
                                                                 <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                                                                )                                
                               <cf_dbidentity1 datasource="#session.DSN#">				
                              </cfquery>
                            <cf_dbidentity2 datasource="#session.DSN#" name="ERR">
                           
                            <cfset LvarEncabezado = ERR.identity >
                            
                           </cfloop>
                           
                           <cfquery name="rsUpdCred" datasource="#session.dsn#">
                            select 
                                    SaldoAntMonOri , 
                                    (SaldoActMonOri *-1) as SaldoActMonOri,                                                                       
                                    (SaldoActMonOri *-1) as SaldoActMonOri                                        
                                from #table_name# a 
                                   where 
                                     CuentaTCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentasOri.CuentaTCE#"> and 
                                     SaldoActMonOri > 0.00 
                                     and tipoMov = 'C'
                            </cfquery>                            
                            <cfif rsUpdCred.recordcount gt 0> 
                               <cfquery name="ERRCreditos" datasource="#session.DSN#">
                                update ECuentaBancaria  
                                 set 
                                  ECsaldoini = #rsUpdCred.SaldoAntMonOri#,
                                  ECsaldofin = ECsaldofin + #rsUpdCred.SaldoActMonOri#,
                                  ECcreditos =  #rsUpdCred.SaldoActMonOri#                              
                                where ECid =  #LvarEncabezado#              
                               </cfquery>   
                            </cfif>     
                           
                           <cfquery name="rsUpdDeb" datasource="#session.dsn#">
                            select 
                                    SaldoAntMonOri , 
                                     SaldoActMonOri
                                from #table_name# a 
                                   where 
                                     CuentaTCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentasOri.CuentaTCE#"> and 
                                     SaldoActMonOri > 0.00 
                                     and tipoMov = 'D'
                            </cfquery>                            
                            <cfif rsUpdDeb.recordcount gt 0> 
                               <cfquery name="ERRDebitos" datasource="#session.DSN#">
                                update ECuentaBancaria  
                                 set 
                                  ECsaldoini =  #rsUpdDeb.SaldoAntMonOri# ,
                                 <!--- ECsaldofin = ECsaldofin + #rsUpdDeb.SaldoActMonOri# ,--->
                                  ECdebitos = #rsUpdDeb.SaldoActMonOri# 
                               where ECid =  #LvarEncabezado#                        
                               </cfquery>   
                            </cfif>         
                            
                   </cfif>
                   
                   <cfquery name="rsBanco" datasource="#session.dsn#">
                    select Bdescripcion from Bancos 
                    where Bid = #rsDatosOri.Bid#
                   </cfquery>
                   
                   <cfquery name="rsTMB" datasource="#session.dsn#">
                    select BTEcodigo from TransaccionesBanco 
                    where Bid = #rsDatosOri.Bid#
                    and BTEtce = 1
                    and BTEtipo = 'C'                         
                   </cfquery>
                   
                   <cfif rsTMB.recordcount eq 0>
                       <cfthrow message="No existe una transacción de tipo 'Credito' en tarjeta de crédito para el banco:#rsBanco.Bdescripcion#. Proceso cancelado!">
                   </cfif>                
            
                    <cfquery name="ERR" datasource="#session.DSN#">
                        insert into DCuentaBancaria (ECid, 
                                                     BTEcodigo,  
                                                     Documento, 
                                                     DCfecha, 
                                                     DCmontoori, 
                                                     DCmontoloc, 
                                                     DCReferencia, 
                                                     DCtipocambio, 
                                                     DCtipo, 
                                                     DCconciliado,
                                                     Ecodigo,
                                                     Bid) 
                        select <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarEncabezado#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTMB.BTEcodigo#">,
								<cf_dbfunction name="spart" args="a.Detalle,1,20">,
                                FechaEstadoCta, 
                                ImporteOri, 
                                ImporteOri, 
                                NumRFC, 
                                1.00, 
                                'C', 
                                'N', 
                                #session.Ecodigo#,
                                #rsDatosOri.Bid#
                        from #table_name# a 
                     where ImporteOri > 0.00
                     and SaldoActMonOri = 0  
                     and CuentaTCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentasOri.CuentaTCE#"> 
                     and tipoMov = 'C'
                    </cfquery>  
                    
                    <cfquery name="ERR" datasource="#session.DSN#">
                        insert into DCuentaBancaria (ECid, 
                                                     BTEcodigo,  
                                                     Documento, 
                                                     DCfecha, 
                                                     DCmontoori, 
                                                     DCmontoloc, 
                                                     DCReferencia, 
                                                     DCtipocambio, 
                                                     DCtipo, 
                                                     DCconciliado,
                                                     Ecodigo,
                                                     Bid) 
                        select <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarEncabezado#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTMB.BTEcodigo#">,
								<cf_dbfunction name="spart" args="a.Detalle,1,20">,
                                FechaEstadoCta, 
                                ImporteOri, 
                                ImporteOri, 
                                NumRFC, 
                                1.00, 
                                'D', 
                                'N', 
                                #session.Ecodigo#,
                                #rsDatosOri.Bid#
                        from #table_name# a 
                     where ImporteOri > 0.00
                     and SaldoActMonOri = 0  
                     and CuentaTCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentasOri.CuentaTCE#"> 
                      and tipoMov = 'D'
                    </cfquery> 
                               
            </cfloop> 
          </cfif>      	    
	</cftransaction>
</cfif>


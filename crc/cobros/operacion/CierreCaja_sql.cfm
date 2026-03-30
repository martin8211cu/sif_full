<!---<cfparam name="action" default="ConsultaCierreCaja.cfm">--->
<cfparam name="action" default="CierreCaja.cfm">
<cf_dbfunction name="op_concat" returnvariable="_CNCT">
 <cfinvoke component="sif.Componentes.CG_GeneraAsiento" Conexion  ="#session.dsn#" method="CreaIntarc" returnvariable  ="INTARC"  CrearPresupuesto="false"/>  
 <cfinvoke component= "sif.Componentes.PRES_Presupuesto" Conexion ="#session.dsn#" method="CreaTablaIntPresupuesto"  returnvariable="IntPresup"/>
            
<cfif isdefined("form.btnAceptar") or isdefined("form.btnModificar")>    
	<cftransaction>		
        <cftry>
			<!--- inserta el encabezado del cierre --->
			<cfif isdefined("form.btnAceptar")>
                  <cfquery name="sql_ecierre" datasource="#session.DSN#" >
					insert FACierres ( Ecodigo, FCid, Usucodigo, Ulocalizacion, EUcodigo, FCAfecha )
					values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"	>,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#" >,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#" >,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#" >,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EUcodigo#" >,
							 getDate()
						   )
					<cf_dbidentity1 datasource="#session.DSN#">		   
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="sql_ecierre">
                <cfset FACid = sql_ecierre.identity >
			<cfelse>
				<cfset FACid = form.FACid >	
			</cfif>	
            				
		<!--- proceso de datos por moneda --->
		<cfloop index="i" list="#form.moneda#" delimiters=",">  
        
              <cfquery name="rsMlocal" datasource="#Session.DSN#">
                select Mcodigo from Empresas where Ecodigo= #session.Ecodigo#
              </cfquery>
               <cfquery name="rsMoneda" datasource="#Session.DSN#">
                select Mcodigo 
                   from Monedas 
                   where Miso4217 = '#i#'
                and Ecodigo= #session.Ecodigo#
              </cfquery>
              <cfif rsMlocal.Mcodigo neq rsMoneda.Mcodigo>
               	<cfquery name="rsTC" datasource="#Session.DSN#" maxrows="1">
                    select tc.TCcompra,tc.Mcodigo
                    from Htipocambio tc
                   where  tc.Mcodigo =  #rsMoneda.Mcodigo#
                      and tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
                     order by Hfecha desc  
				</cfquery>
              <cfelse>
                 <cfquery name="rsTC" datasource="#Session.DSN#">
                    select 1 as TCcompra, #rsMoneda.Mcodigo# as Mcodigo
                    from dual 
             	</cfquery>
              </cfif>    
              
                
				<!--- crea los nombres de los objetos --->
				<cfset FADCminicial    = 0>     
                <cfif isdefined("form.Doc_F_" & i )>   <!----Facturas de contado --->
               	   <cfset FADCcontado     =  Evaluate("form.Doc_F_" & i ) >
                <cfelse>
                   <cfset FADCcontado     = 0>
                </cfif>               
                <cfif isdefined("form.Doc_C_" & i )>   <!----Facturas de credito --->
				   <cfset FADCfcredito    =  Evaluate("form.Doc_C_" & i ) >
                <cfelse>
                   <cfset FADCfcredito    =  0>
                </cfif>
                <cfif isdefined("form.Monto_E_" & i )> <!----El efectivo --->
				   <cfset FADCefectivo    =  Evaluate("form.Monto_E_" & i) >
                <cfelse>
                   <cfset FADCefectivo    = 0>
                </cfif>
                <cfif isdefined("form.Monto_C_" & i )> <!----Los cheques --->
				   <cfset FADCcheques     =  Evaluate("form.Monto_C_" & i ) >
                <cfelse>
                </cfif>
                <cfif isdefined("form.Monto_T_" & i )> <!----Las tarjetas --->
				   <cfset FADCvouchers    =  Evaluate("form.Monto_T_" & i )>
                <cfelse>
                   <cfset FADCvouchers    = 0>
                </cfif>
                <cfif isdefined("form.Monto_D_" & i )> <!----Depositos --->
				   <cfset FADCdepositos   =  Evaluate("form.Monto_D_" & i ) >
                <cfelse>
                   <cfset FADCdepositos   = 0>
                </cfif>
                <cfif isdefined("form.Monto_A_" & i )> <!----Documentos--->
				   <cfset FADCdocumentos  =  Evaluate("form.Monto_A_" & i ) >
                <cfelse>
                   <cfset FADCdocumentos  =  0 >
                </cfif>
				<!---<cfset FADCncredito    =  Evaluate("form.Doc_C_"   & i ) >--->
                <cfset FADCncredito    =  0>
				<cfset FADCtc          =  rsTC.TCcompra >
             
				<cfquery name="rsCount" datasource="#session.DSN#">
					select 1 from FADCierres where FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FACid#"> and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTC.Mcodigo#">
				</cfquery>
				<cfif isdefined("form.btnAceptar") or isdefined("form.btnModificar") >
					<cfquery name="sql_dcierre" datasource="#session.DSN#">
						<cfif rsCount.RecordCount gt 0 >
								update FADCierres 
								set FADCminicial    = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCminicial#">, 
									FADCcontado     = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCcontado#">, 
									FADCfcredito    = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCfcredito#">,
									FADCefectivo    = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCefectivo#">, 
									FADCcheques     = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCcheques#">, 
									FADCvouchers    = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCvouchers#">, 
									FADCdepositos   = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCdepositos#">, 
									FADCdocumentos  = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCdocumentos#">, 
                                    FADCncredito    = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCncredito#">,
									FADCtc          = <cfqueryparam cfsqltype="cf_sql_money" value="#FADCtc#">
								where FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FACid#">
								  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTC.Mcodigo#">
						<cfelse>		  
							insert FADCierres ( FACid, Mcodigo, FADCminicial, FADCcontado, FADCcontadosis, FADCfcredito, FADCfcreditosis, 
												FADCefectivo, FADCefectivosis, FADCcheques, FADCchequessis, FADCvouchers, FADCvoucherssis, 
												FADCdepositos, FADCdepositossis, FADCdocumentos, FADCdocumentossis, FADCncredito, FADCncreditosis, FADCdiferencias, FADCtc)
							values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#FACid#">, 
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTC.Mcodigo#">, 
									 <cfqueryparam cfsqltype="cf_sql_money" value="#FADCminicial#">,
									 <cfqueryparam cfsqltype="cf_sql_money" value="#FADCcontado#">, 
									 0, 
									 <cfqueryparam cfsqltype="cf_sql_money" value="#FADCfcredito#">,
									 0,
									 <cfqueryparam cfsqltype="cf_sql_money" value="#FADCefectivo#">, 
									 0,
									 <cfqueryparam cfsqltype="cf_sql_money" value="#FADCcheques#">,
									 0,
									 <cfqueryparam cfsqltype="cf_sql_money" value="#FADCvouchers#">, 
									 0,
									 <cfqueryparam cfsqltype="cf_sql_money" value="#FADCdepositos#">,
									 0,
                                     <cfqueryparam cfsqltype="cf_sql_money" value="#FADCdocumentos#">,
									 0,
									 <cfqueryparam cfsqltype="cf_sql_money" value="#FADCncredito#">,
									 0,
									 0,
									 <cfqueryparam cfsqltype="cf_sql_float" value="#FADCtc#">
									)
						</cfif>		
					</cfquery>
				</cfif>            
			</cfloop>
            
		<cfcatch type="any">
			<cfinclude template="../../errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	</cftransaction>
<cfelseif isdefined("form.btnTerminar")>

    <cfset ObjParametro  = CreateObject("component","sif.Componentes.FA_funciones")>    
    <cfset rsPeriodo     = ObjParametro.consultaParametro(#session.Ecodigo#, 'GN',50)>
    <cfset LvarPeriodo   = rsPeriodo.valor> 

    <cfset rsMes = ObjParametro.consultaParametro(#session.Ecodigo#, 'GN',60)>
    <cfset LvarMes = rsMes.valor>
    
    <cfquery name = "rsRefactura" datasource = "#session.dsn#">       
       select * from ETransacciones a 
       where a. ETestado in ('T', 'P')
       and a.FCid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#" >
       and ( select count(1) 
       from CCENotaCredito c
       where c.ETnumero_generado = a.ETnumero
       and c.FCid_generado       = a.FCid) > 0 
     </cfquery>
     <cfif isdefined('rsRefactura') and rsRefactura.recordcount GT  0 >
        <cf_ErrorCode code="-1" msg="No se puede procesar el cierre porque existen transacciones con refacturacion de notas de credito pendientes (Documento:#rsRefactura.ETnumero#). Proceso cancelado!. ">
     </cfif>

     <!--- Valida que la caja NO tenga liquidaciones pendientes de ser Aplicadas --->
     <cfquery name="rsValida" datasource="#session.dsn#">
       select distinct NumLote from FALiquidacionRuteros
       where estado = <cfqueryparam cfsqltype="cf_sql_char" value="D">
         and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.caja#">
         and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
     </cfquery>
     <cfif rsValida.recordCount>
       <cf_ErrorCode code="-1" msg="No se puede procesar el cierre porque las siguientes Liquidaciones de Ruteros estan aplicadas parcialmente: #valueList(rsValida.NumLote)#, favor aplicar dichas liquidaciones en la pantalla: Validacion de Liquidaciones por el Cajero.">
     </cfif>

     <cfquery name = "rsRemesas" datasource = "#session.dsn#">       
       select * from ERemesas 
       where FCid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#" >
       and REstado <> 'A'
     </cfquery>
     <cfif isdefined('rsRemesas') and rsRemesas.recordcount GT  0 >
        <cf_ErrorCode code="-1" msg="No se puede procesar el cierre porque existen remesas sin aplicar. Proceso cancelado!. ">
     </cfif>
    
    <cftransaction>		
        <cftry>
            <cfif not isdefined('form.FACid') or len(trim(#form.FACid#)) eq 0 >
               <cfquery name="sql_ecierre" datasource="#session.DSN#" >
					insert FACierres ( Ecodigo, FCid, Usucodigo, Ulocalizacion, EUcodigo, FCAfecha )
					values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"	>,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#" >,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#" >,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#" >,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EUcodigo#" >,
							 getDate()
						   )
					<cf_dbidentity1 datasource="#session.DSN#">		   
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="sql_ecierre">
                <cfset FACid = sql_ecierre.identity >
            <cfelse>
                <cfset FACid =  form.FACid>
            </cfif>	

              <cfquery name="rsMlocal" datasource="#Session.DSN#">
                select Mcodigo from Empresas where Ecodigo= #session.Ecodigo#
              </cfquery>
       <cfif isdefined('form.moneda') and len(trim(form.moneda)) gt 0>  
            <cfloop index="i" list="#form.moneda#" delimiters=",">          
               <cfquery name="rsMoneda" datasource="#Session.DSN#">
                select Mcodigo,Mnombre 
                   from Monedas 
                   where Miso4217 = '#i#'
                and Ecodigo= #session.Ecodigo#
              </cfquery>

              <cfif rsMlocal.Mcodigo neq rsMoneda.Mcodigo>
               	<cfquery name="rsTC" datasource="#Session.DSN#" maxrows="1">
                    select tc.TCcompra,tc.Mcodigo
                    from Htipocambio tc
                   where  tc.Mcodigo =  #rsMoneda.Mcodigo#
                      and tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
                     order by Hfecha desc  
				</cfquery>
              <cfelse>
                 <cfquery name="rsTC" datasource="#Session.DSN#">
                    select 1 as TCcompra, #rsMoneda.Mcodigo# as Mcodigo
                    from dual 
             	</cfquery>
              </cfif>               
                
				<!--- crea los nombres de los objetos --->				  
                <cfif isdefined("form.Doc_Dif_" & i )>   <!----Diferencia del sistema --->
               	   <cfset LvarDoc_Dif     =  Evaluate("form.Doc_Dif_" & i ) >
                <cfelse>
                   <cfset LvarDoc_Dif     = 0>
                </cfif>                          
             	<cfset FADCminicial    = 0>     
                <cfif isdefined("form.Doc_F_" & i )>   <!----Facturas de contado --->
               	   <cfset FADCcontado     =  Evaluate("form.Doc_F_" & i ) >
                   <cfset FADCcontadoSYS  =  Evaluate("form.montoSys_F_" & i ) >                  
                <cfelse>
                   <cfset FADCcontado     = 0>
                   <cfset FADCcontadoSYS  = 0 >
                </cfif>                              
                <cfif isdefined("form.Doc_C_" & i )>   <!----Facturas de credito --->
				   <cfset FADCfcredito    =  Evaluate("form.Doc_C_" & i ) >
                   <cfset FADCfcreditoSYS =  Evaluate("form.montoSys_C_" & i ) >
                <cfelse>
                   <cfset FADCfcredito    =  0>
                   <cfset FADCfcreditoSYS =  0>
                </cfif>
                <cfif isdefined("form.Monto_E_" & i )> <!----El efectivo --->
				   <cfset FADCefectivo    =  Evaluate("form.Monto_E_" & i) >
                   <cfset FADCefectivoSYS =  Evaluate("form.montoSys_E_" & i) >
                <cfelse>
                   <cfset FADCefectivo    = 0>
                   <cfset FADCefectivoSYS = 0>
                </cfif>
                <cfif isdefined("form.Monto_C_" & i )> <!----Los cheques --->
				   <cfset FADCcheques     =  Evaluate("form.Monto_C_" & i ) >
                   <cfset FADCchequesSYS  =  Evaluate("form.montoSys_C_" & i ) >
                <cfelse>
                  <cfset  FADCcheques     = 0>
                  <cfset  FADCchequesSYS  = 0>
                </cfif>
                <cfif isdefined("form.Monto_T_" & i )> <!----Las tarjetas --->
				   <cfset FADCvouchers    =  Evaluate("form.Monto_T_" & i )>
                   <cfset FADCvouchersSYS =  Evaluate("form.montoSys_T_" & i )>
                <cfelse>
                   <cfset FADCvouchers    = 0>
                   <cfset FADCvouchersSYS = 0>
                </cfif>
                <cfif isdefined("form.Monto_D_" & i )> <!----Depositos --->
				   <cfset FADCdepositos    =  Evaluate("form.Monto_D_" & i ) >
                   <cfset FADCdepositosSYS =  Evaluate("form.montoSys_D_" & i ) >
                <cfelse>
                   <cfset FADCdepositos    = 0>
                   <cfset FADCdepositosSYS = 0>
                </cfif>
                <cfif isdefined("form.Monto_A_" & i )> <!----Documentos--->
				   <cfset FADCdocumentos     =  Evaluate("form.Monto_A_" & i ) >
                   <cfset FADCdocumentosSYS  =  Evaluate("form.montoSys_A_" & i ) >
                <cfelse>
                   <cfset FADCdocumentos     =  0 >
                   <cfset FADCdocumentosSYS  =  0 >                  
                </cfif>
                 <cfif isdefined("form.Monto_R_" & i )> <!----Remesas--->
				   <cfset FADCremesas     =  Evaluate("form.Monto_R_" & i ) >                   
                <cfelse>
                   <cfset FADCremesas     =  0 >
                </cfif>
                <cfif isdefined("form.montoSys_R_" & i )> <!----Remesas Sistema--->
                   <cfset FADCremesasSYS  =  Evaluate("form.montoSys_R_" & i ) >
                <cfelse>
                   <cfset FADCremesasSYS  =  0 >                  
                </cfif>

				<!---<cfset FADCncredito    =  Evaluate("form.Doc_C_"   & i ) >--->
                <cfset FADCncredito    =  0>
				<cfset FADCtc          =  rsTC.TCcompra >               
              
         	<cfquery name="sql_dcierre" datasource="#session.DSN#">	
              insert FADCierres ( FACid, Mcodigo, FADCminicial, FADCcontado, FADCcontadosis, FADCfcredito, FADCfcreditosis, 
												FADCefectivo, FADCefectivosis, FADCcheques, FADCchequessis, FADCvouchers, FADCvoucherssis, 
												FADCdepositos, FADCdepositossis, FADCdocumentos, FADCdocumentossis,FADCremesas,FADCremesassis, FADCncredito, FADCncreditosis, FADCdiferencias, FADCtc,
                        MontoFondeo)
							values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#FACid#">, 
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTC.Mcodigo#">, 
									 <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCminicial)#">,
									 <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCcontado)#">, 
									 <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCcontadoSYS)#">,
									 <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCfcredito)#">,
									 <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCfcreditoSYS)#">,
									 <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCefectivo)#">, 
									 <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCefectivoSYS)#">, 
									 <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCcheques)#">,
									 <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCchequesSYS)#">,
									 <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCvouchers)#">, 
									 <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCvouchersSYS)#">, 
									 <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCdepositos)#">,
									 <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCdepositosSYS)#">,
                                     <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCdocumentos)#">,
									 <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCdocumentosSYS)#">,
                                     <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCremesas)#">,
									 <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCremesasSYS)#">,
									 <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(FADCncredito)#">,
									  0,
									  <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#LSParseNumber(LvarDoc_Dif)#">,
									 <cfqueryparam cfsqltype="cf_sql_float" value="#FADCtc#">,
                   <cfqueryparam cfsqltype="cf_sql_money" value="#LSParseNumber(form.MontoFondeo)#">
									)			
                          </cfquery>
            <!---Obtengo la cuenta de sobrantes y faltantes de la caja. con el id de la caja-------> 
             <cfquery name="rsCuentas" datasource="#session.DSN#">
				select Ccuenta, FCcodigo, CcuentaSob, CcuentaFalt, FCdesc, Ocodigo from FCajas 
				where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			 </cfquery> 
             <cfset LvarMensaje = ''> 
             <cfif isdefined('rsCuentas') and  rsCuentas.recordcount eq 0>              
                 <cfset LvarMensaje = LvarMensaje & "No se han definido obtner las cuentas para faltantes y sobrantes. " & "<br/>">
             </cfif>
             <cfif isdefined('rsCuentas.Ccuenta') and  len(trim(#rsCuentas.Ccuenta#)) eq 0>              
                 <cfset LvarMensaje = LvarMensaje &  "No se ha definido la cuenta contable para la caja #rsCuentas.FCdesc#" & "<br/>">
             </cfif>   
             <cfif isdefined('rsCuentas.CcuentaSob') and  len(trim(#rsCuentas.CcuentaSob#)) eq 0>            
                 <cfset LvarMensaje =  LvarMensaje &   "No se ha definido la cuenta para sobrantes en la caja #rsCuentas.FCdesc#" & "<br/>" >
             </cfif>
              <cfif isdefined('rsCuentas.CcuentaFalt') and  len(trim(#rsCuentas.CcuentaFalt#)) eq 0>               
                   <cfset LvarMensaje =   LvarMensaje &   "No se ha definido la cuenta para faltantes en la caja #rsCuentas.FCdesc#" & "<br/>">
             </cfif>       
             <cfif len(trim(#LvarMensaje#)) gt 0>                
  			   <cfthrow message="#LvarMensaje#">
             </cfif>
             <cfset LvarCcuentaCaja = rsCuentas.Ccuenta>
             <cfset LvarCcuentaSob  = rsCuentas.CcuentaSob>
             <cfset LvarCcuentaFalt = rsCuentas.CcuentaFalt>
             
           <!---********* ASIENTOS POR DIFERENCIA ***********---------->                
          
            <!--- Genero el INTARC --->
           
            
            <cfset Hoy = #DateFormat(Now(),"mm-dd-yyyy")#>    
            <cfset LvarDescripcionAsiento = 'Cierre Caja' & ' ' & FACid & ' ' & rsCuentas.FCdesc >      
			<cfset LvarDocumento  = Hoy &' - ' & FACid &' - ' & rsCuentas.FCcodigo  &' - ' & session.Usulogin >  
            
            <cfset LvarDoc_Dif       = replace(#LvarDoc_Dif#,',','','All')>
              
            <cfif LvarDoc_Dif lt 0><!--- Si la diferencia es menor a 0. hubo faltante--->
                <cfset LvarDoc_Dif = abs(LvarDoc_Dif)>
			   <!--- 1)-  inserta la diferencia el INTARC  --->
                <!--- 1.1)- CUENTA DE FALTANTE  --->
                <cfquery name="rs" datasource="#session.dsn#">
                insert #INTARC# ( 
                     INTORI, INTREL, INTDOC, INTREF,
                     INTMON, INTTIP, INTDES, INTFEC,
                     INTCAM, Periodo, Mes, Ccuenta,
                     Mcodigo, Ocodigo, INTMOE                 
                )
                values(
                  'FAFC', 1, 'Cierre caja' #_CNCT# <cf_dbfunction name="to_char" args="#Hoy#">,'CO',
                    #LvarDoc_Dif# * #FADCtc# ,'D', 'Faltante de la caja' #_CNCT# '#rsCuentas.FCdesc#', <cf_dbfunction name="to_char"	args="getdate(),112">,
                    #FADCtc#, #LvarPeriodo#, #LvarMes#, #LvarCcuentaFalt#,
                    #rsMoneda.Mcodigo#, #rsCuentas.Ocodigo#, #LvarDoc_Dif# 
                    )		
                </cfquery>
       
                <!--- 1.2)- CUENTA DE CAJA  --->
               <cfquery name="rs" datasource="#session.dsn#">
                insert #INTARC# ( 
                     INTORI, INTREL, INTDOC, INTREF,
                     INTMON, INTTIP, INTDES, INTFEC,
                     INTCAM, Periodo, Mes, Ccuenta,
                     Mcodigo, Ocodigo, INTMOE                 
                )
              values(
                  'FAFC', 1, 'Cierre caja' #_CNCT# <cf_dbfunction name="to_char"	args="#Hoy#">,'CO',
                    #LvarDoc_Dif#  * #FADCtc# ,'C', 'Cuenta de la caja' #_CNCT# '#rsCuentas.FCdesc#', <cf_dbfunction name="to_char"	args="getdate(),112">,
                    #FADCtc#, #LvarPeriodo#, #LvarMes#, #LvarCcuentaCaja#,
                    #rsMoneda.Mcodigo#, #rsCuentas.Ocodigo#, #LvarDoc_Dif#
                    )		
                </cfquery>
              
             <cfelseif LvarDoc_Dif gt 0>  
               
              	<!--- 2)-  inserta el sobrante el INTARC  --->
                <!--- 2.1)- CUENTA DE CAJA  --->
                <cfquery name="rs" datasource="#session.dsn#">
                insert #INTARC# ( 
                     INTORI, INTREL, INTDOC, INTREF,
                     INTMON, INTTIP, INTDES, INTFEC,
                     INTCAM, Periodo, Mes, Ccuenta,
                     Mcodigo, Ocodigo, INTMOE                 
                )
                values(
                    'FAFC', 1, 'Cierre caja' #_CNCT# <cf_dbfunction name="to_char" args="#Hoy#">,'CO',
                    #LvarDoc_Dif# * #FADCtc# ,'D', 'Cuenta de la caja' #_CNCT# '#rsCuentas.FCdesc#', <cf_dbfunction name="to_char"	args="getdate(),112">,
                    #FADCtc#, #LvarPeriodo#, #LvarMes#, #LvarCcuentaCaja#,
                    #rsMoneda.Mcodigo#, #rsCuentas.Ocodigo#, #LvarDoc_Dif#
                    )		
                </cfquery>
                <!--- 2.2)- CUENTA DE SOBRANTE --->
               <cfquery name="rs" datasource="#session.dsn#">
                insert #INTARC# ( 
                     INTORI, INTREL, INTDOC, INTREF,
                     INTMON, INTTIP, INTDES, INTFEC,
                     INTCAM, Periodo, Mes, Ccuenta,
                     Mcodigo, Ocodigo, INTMOE                 
                )
                values(
                   'FAFC', 1, 'Cierre caja' #_CNCT# <cf_dbfunction name="to_char" args="#Hoy#">,'CO',
                    #LvarDoc_Dif#  * #FADCtc# ,'C', 'Sobrante de la caja' #_CNCT# '#rsCuentas.FCdesc#', <cf_dbfunction name="to_char"	args="getdate(),112">,
                    #FADCtc#, #LvarPeriodo#, #LvarMes#, #LvarCcuentaSob#,
                    #rsMoneda.Mcodigo#, #rsCuentas.Ocodigo#, #LvarDoc_Dif#
                    )		
                </cfquery>  
              </cfif><!---Fin de las direncias de caja--->                        
          </cfloop>       
          <cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
            <cfinvokeargument name="Ecodigo"		value="#session.Ecodigo#"/>
            <cfinvokeargument name="Oorigen"		value="FACD"/>       
            <cfinvokeargument name="Eperiodo"		value="#LvarPeriodo#"/>
            <cfinvokeargument name="Emes"			value="#LvarMes#"/>
            <cfinvokeargument name="Efecha"			value="#now()#"/>
            <cfinvokeargument name="Edescripcion"	value="#LvarDescripcionAsiento#"/>     
            <cfinvokeargument name="Edocbase"		value="#LvarDocumento#"/>
            <cfinvokeargument name="Ereferencia"	value="#rsCuentas.FCdesc#"/>   
            <cfinvokeargument name="Ocodigo"        value="#rsCuentas.Ocodigo#"/>        
            <cfinvokeargument name="Usucodigo"		value="#session.Usucodigo#"/>     
            <cfinvokeargument name="debug"		    value="no"/>    
            <cfinvokeargument name="PintaAsiento"   value="false"/>          
          </cfinvoke>     
        
       </cfif>     
       
           <!--- Actualizar el FACid en ETransaccion, Pagos, Liquidacion y posteriormente en Notas de credito  --->
           <cfquery name="rsUpd_Contado_Liquidacion_Creditos" datasource="#session.DSN#">
            update ETransacciones 
            set FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FACid#">         
            where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">          
              and FACid IS NULL
              and ETestado = 'C'
              and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
          </cfquery>
        
            <cfquery name="rsUpd_Recibos" datasource="#session.DSN#">
             update HPagos 
              set FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FACid#">         
              where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">  
              and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and  FACid IS NULL
            </cfquery>  
            
            <cfquery name="rsUpd_Liquidaciones" datasource="#session.DSN#">
             update FALiquidacionRuteros 
              set FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FACid#">         
              where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">  
              and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and estado = 'P' 
              and  FACid IS NULL
            </cfquery>  
            
           <cfquery name="rsUpd_Remesas" datasource="#session.DSN#">
             update ERemesas 
              set FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FACid#">         
              where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">               
              and  FACid IS NULL
            </cfquery>  
                 
            <cfquery name="rsUpdateCierres" datasource="#session.DSN#">
            update FACierres 
            set FACestado = <cfqueryparam cfsqltype="cf_sql_char" value="T">
            where FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FACid#">
              and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            </cfquery> 
        
		  <!--- Se le cambia el estado de la caja de ocupada a disponible, para permitirle a otro usuario tomar la caja --->
          <cfquery name="rsUpdCaja" datasource="#session.DSN#">
            update FCajas 
            set FCestado = 0
            where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
              and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
          </cfquery>
          
          <!--- Se elimina la caja de Cajas Activas para permitirle a otro usuario tomar la caja --->
          <cfquery name="rsDelCajaAct" datasource="#session.DSN#">
            delete from FCajasActivas           
            where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">           
          </cfquery>
          
        
       
          <cfset StructDelete(session, "Caja")>
                 
        <cfcatch type="any">
        <cfinclude template="/sif/errorPages/BDerror.cfm">
        <cfabort>
        </cfcatch>
        </cftry>   
   </cftransaction>  
<cfelseif isdefined('form.btnLiberar')>
          <!--- Se le cambia el estado de la caja de ocupada a disponible, para permitirle a otro usuario tomar la caja --->
          <cfquery name="rsUpdCaja" datasource="#session.DSN#">
            update FCajas 
            set FCestado = 0
            where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
              and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
          </cfquery>
          
          <!--- Se elimina la caja de Cajas Activas para permitirle a otro usuario tomar la caja --->
          <cfquery name="rsDelCajaAct" datasource="#session.DSN#">
            delete from FCajasActivas           
            where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">           
          </cfquery>
          
          <cfset StructDelete(session, "Caja")>
    
<cfelse>
	<cfset action = "CierreCaja.cfm" >
	<cfset modo   = "CAMBIO" >
</cfif>	

<cfif isdefined("form.FACid") AND form.FACid EQ "" >
	<cfset form.FACid = "#FACid#">
</cfif>
<cfoutput>
<form  action="Ingresos.cfm"  method="post" name="sql">
	<input type="hidden" name="FACid" value="-1">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">
<cfif not isdefined('form.btnLiberar')>
  alert("El cierre se ha realizado con éxito.");
</cfif>
document.forms[0].submit();
</script>
</body>
</HTML>
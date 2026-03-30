<cfset esAguinaldo 		= isdefined('form.Aguinaldo')>
<cfset esPRG    		= isdefined('form.PRG')>
<cfset esNomina 		= isdefined('form.RCNid')>
<cfset esAccionMasiva 	= isdefined('form.AM')>
<cfset esInc 			= isdefined('form.INC')>
<cfset esDeduc			= isdefined('form.Deduc')>
<cfset esInc_PRG 		= isdefined('form.INC_PRG')>
<cfset esCompEmp 		= isdefined('form.CompEmp')>
<cfset esDeducMas		= isdefined('form.DeducMas')>
<cfset esDeducMasD 		= isdefined('form.DeducMasD')>
<cfset esEPTU 			= isdefined('form.EPTU')>
<cfset esDPTU 			= isdefined('form.DPTU')>
<cfset esDEPTU 			= isdefined('form.DEPTU')>
<cfset esIncMas			= isdefined('form.IncMas')>
<cfset esIncMasD		= isdefined('form.IncMasD')>
<cfset esnomEspecial	= isdefined('form.nomEspecial')>

<!---►►►►►►►Manejo de PayrollGroups◄◄◄◄◄◄◄◄--->
<cfif isdefined('form.Accion') and form.Accion EQ 'CambioFecha'>
	<cfquery name="ABC_TiposNomina_dtn" datasource="#Session.DSN#">			
        update CalendarioPagos set  CPfpago =  <cf_JDBCquery_param cfsqltype="cf_sql_date" value="#LsParseDateTime(form.fechaPagoNomin)#">
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#">
            and CPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.RCNid)#">
    </cfquery>
    <form name="form1" method="post" action="EmpleadosNomina.cfm">
   		<input type="hidden" name="Tcodigo" id="Tcodigo" value="#form.Tcodigo#"/>
     	<input type="hidden" name="RCNid" id="RCNid" value="#form.RCNid#"/>
    </form>
	<script type="text/javascript">
        document.form1.action = "EmpleadosNomina.cfm";
        document.form1.Tcodigo.value = "<cfoutput>#form.RCNid#</cfoutput>";
        document.form1.RCNid.value = "<cfoutput>#form.RCNid#</cfoutput>";
        document.form1.submit();
    </script>
</cfif>
<cfif esPRG>
	<cfset esAlta = isdefined('form.Alta')>
    <cfset esCambio= isdefined('form.Cambio')>
    <cfset esBaja = isdefined('form.Baja')>
    <cfset form.noSumbit = true>
        <cffunction name="datos" >		
            <cfargument name="tcodigo" type="string" required="true">
            <cfargument name="dtndia"  type="numeric" required="true">
        
            <cfquery name="rsDatos" datasource="#Session.DSN#">
                insert into DiasTiposNomina(Ecodigo, Tcodigo, DTNdia, Usucodigo, Ulocalizacion)
                values ( 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#tcodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#dtndia#">, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    '00'
                )
            </cfquery>
            <cfreturn true>
        </cffunction>
    <cfif esAlta>
        <cfinvoke component="rh.Componentes.TipoNomina" method="AltaTipoNomina" returnvariable="Tcodigo">
            <cfinvokeargument name="Tcodigo" value="#form.Tcodigo#">
            <cfinvokeargument name="Tdescripcion" value="#form.Tdescripcion#">
            <cfinvokeargument name="Ttipopago" value="#form.Ttipopago#">
            <cfinvokeargument name="FactorDiasSalario" value="#form.FactorDiasSalario#">
        </cfinvoke>
        <cfif form.Ttipopago EQ 1 or form.Ttipopago EQ 0>
        	<cfif not isdefined("form.DTNdia_1")><cfset datos(form.Tcodigo, 1)></cfif>
			<cfif not isdefined("form.DTNdia_2")><cfset datos(form.Tcodigo, 2)></cfif>
            <cfif not isdefined("form.DTNdia_3")><cfset datos(form.Tcodigo, 3)></cfif>
            <cfif not isdefined("form.DTNdia_4")><cfset datos(form.Tcodigo, 4)></cfif>
            <cfif not isdefined("form.DTNdia_5")><cfset datos(form.Tcodigo, 5)></cfif>
            <cfif not isdefined("form.DTNdia_6")><cfset datos(form.Tcodigo, 6)></cfif>
            <cfif not isdefined("form.DTNdia_7")><cfset datos(form.Tcodigo, 7)></cfif>
        </cfif>
   	<cfelseif esCambio>
    	<cfinvoke component="rh.Componentes.TipoNomina" method="fnCambioTipoNomina" returnvariable="Tcodigo">
            <cfinvokeargument name="Tcodigo" value="#form.Tcodigo#">
            <cfinvokeargument name="Tdescripcion" value="#form.Tdescripcion#">
            <cfinvokeargument name="Ttipopago" value="#form.Ttipopago#">
            <cfinvokeargument name="FactorDiasSalario" value="#form.FactorDiasSalario#">
        </cfinvoke>
		<cfif form.Ttipopago EQ 1 or form.Ttipopago EQ 0>
            <cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
            <!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
                <cfinvokeargument  name="nombreTabla" value="DiasTiposNomina">		
                <cfinvokeargument name="condicion" value="Ecodigo = #Session.Ecodigo# and rtrim(Tcodigo) ='#Trim(form.Tcodigo)#'">
            </cfinvoke>
            <cfquery name="rsDelete" datasource="#session.DSN#">
                delete from DiasTiposNomina 
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
                    and rtrim(Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#">
            </cfquery>
            
                <cfif not isdefined("form.DTNdia_1")><cfset datos(form.Tcodigo, 1)></cfif>
                <cfif not isdefined("form.DTNdia_2")><cfset datos(form.Tcodigo, 2)></cfif>
                <cfif not isdefined("form.DTNdia_3")><cfset datos(form.Tcodigo, 3)></cfif>
                <cfif not isdefined("form.DTNdia_4")><cfset datos(form.Tcodigo, 4)></cfif>
                <cfif not isdefined("form.DTNdia_5")><cfset datos(form.Tcodigo, 5)></cfif>
                <cfif not isdefined("form.DTNdia_6")><cfset datos(form.Tcodigo, 6)></cfif>
                <cfif not isdefined("form.DTNdia_7")><cfset datos(form.Tcodigo, 7)></cfif>
        </cfif>
    <cfelseif esBaja>
		<cftry>
			<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
			<!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
						<cfinvokeargument  name="nombreTabla" value="DiasTiposNomina">		
						<cfinvokeargument name="condicion" value="Ecodigo = #Session.Ecodigo# and rtrim(Tcodigo) ='#Trim(form.Tcodigo)#'">
			</cfinvoke>
			<cfquery name="ABC_TiposNomina_dtn" datasource="#Session.DSN#">			
				delete from DiasTiposNomina	
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and rtrim(Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#"> 
			</cfquery>
			<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
			<!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
						<cfinvokeargument  name="nombreTabla" value="TiposNomina">		
						<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
						<cfinvokeargument name="condicion" value="Ecodigo = #Session.Ecodigo# and rtrim(Tcodigo) ='#Trim(form.Tcodigo)#'">
			</cfinvoke>
			<cfquery name="ABC_TiposNomina_tn" datasource="#Session.DSN#">						
				delete from TiposNomina 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and rtrim(Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#">	  
			</cfquery>
			<cfcatch type="any">
				<cf_throw message="#LB_ErrorTipoNomi#" errorcode="48">
			</cfcatch>
		</cftry>
    </cfif>
<!---►►►►►►►Manejo de Nominas◄◄◄◄◄◄◄◄--->
<cfelseif esNomina and not esInc and not esDeduc>
    <cfset esRestaurar  = isdefined('form.Accion') and form.Accion EQ 'Restaurar'>
    <cfset esBaja   	= isdefined('form.Accion') and form.Accion EQ 'Baja'>
    <cfset esAplicar   	= isdefined('form.Accion') and form.Accion EQ 'AplicarNomina'>
    <cfif esBaja>
    	<cfquery name="rsRelacion" datasource="#session.dsn#">
        	select Tcodigo from RCalculoNomina where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
        </cfquery>
        <cfset form.Tcodigo = rsRelacion.Tcodigo>
    	<cfquery name="rsCP" datasource="#session.dsn#">
        	select CPid,CPtipo 
            from CalendarioPagos
            where Ecodigo = #session.ecodigo#
              and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsRelacion.Tcodigo#">
              and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
        </cfquery>
    	<cftransaction>
            <cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="BajaRCalculoNomina">
                <cfinvokeargument name="RCNid" 				value="#form.RCNid#">
                <cfinvokeargument name="TransacionActiva" 	value="true">
            </cfinvoke>
			<cfif rsCP.CPtipo eq 1>
            	<cfinvoke component="rh.Componentes.CalendarioPago" method="fnBajaCalendarioPago">
                	<cfinvokeargument name="CPid" 				value="#rsCP.CPid#">
                </cfinvoke>
            </cfif>
        </cftransaction>
        <cfset form.RCNid = "">
    <cfelseif esRestaurar>
    <cftry> 
                 <cfquery name="rsCalendario" datasource="#session.DSN#">
                    select CPtipo, CPdesde, CPhasta from CalendarioPagos where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
                </cfquery>
                <cfif rsCalendario.CPtipo EQ 2>
                    <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Session.DSN#" Ecodigo="#Session.Ecodigo#" Pvalor="730" default="" returnvariable="CIidAnticipo"/>
                    <cfif Not Len(CIidAnticipo)>
                        <cf_throw message="Error!, No se ha definido el Concepto de Pago para Anticipos de Salario a utilizar en los parámetros del Sistema. Proceso Cancelado!!" errorCode="1145">
                    </cfif>
                    <cfquery name="deleteAnticipo" datasource="#session.DSN#">
                        delete from IncidenciasCalculo
                        where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CIidAnticipo#">
                        <cfif IsDefined('Form.DEid') and len(trim(Form.DEid)) >and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> </cfif>
                    </cfquery>	
                </cfif>
            
                <cfif not isdefined('form.baja')>
                    <cfquery name="ABC_Resultado" datasource="#Session.DSN#">	
                        delete from DeduccionesCalculo 
                        where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
                    <cfif IsDefined('Form.DEid') and len(trim(Form.DEid)) >and DEid = #Form.DEid# </cfif>
                    </cfquery>
                </cfif>
                <cfquery datasource="#Session.DSN#">	
                    delete from DeduccionesEmpleado 
                    where Dfechaini between 
                      <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCalendario.CPdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCalendario.CPhasta#">
                      and CIid is not null
                      <cfif IsDefined('Form.DEid') and len(trim(Form.DEid)) >and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"></cfif>
                      and (select count(1) 
                        from HDeduccionesCalculo hdc 
                        where hdc.Did = DeduccionesEmpleado.Did) = 0
                </cfquery>
            <!---ljimenez sacamos las incidencias de subsidio al salario de las nominas anteriores del periodo--->
            <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
                    ecodigo="#session.Ecodigo#" pvalor="2033" default="0" returnvariable="vCIsubc"/>
                    
            <cfquery datasource="#Session.DSN#" name="rsCalendario">
                select CPdesde,CPhasta,CPcodigo
                from CalendarioPagos
                where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
            </cfquery>
             
            <cfquery name="rs_Deducc" datasource="#Session.DSN#">	
                delete from DeduccionesCalculo 
                where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
                and Did = (select Did from DeduccionesEmpleado 
                                where ltrim(rtrim(Dreferencia)) = '#trim(rsCalendario.CPcodigo)#'
                                    and TDid = #vCIsubc#
                                    <cfif IsDefined('Form.DEid') and len(trim(Form.DEid)) >and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"></cfif>)
            </cfquery>
            
            <cfquery datasource="#Session.DSN#">
                delete from DeduccionesEmpleado
                    where ltrim(rtrim(Dreferencia)) = '#trim(rsCalendario.CPcodigo)#'
                    and TDid = #vCIsubc#
                    <cfif IsDefined('Form.DEid') and len(trim(Form.DEid)) >and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"></cfif>
            </cfquery>
       <cfinvoke component="rh.Componentes.RH_CalculoNomina" method="CalculoNomina"
                datasource="#session.dsn#"
                Ecodigo = "#Session.Ecodigo#"
                RCNid = "#Form.RCNid#"
                Usucodigo = "#Session.Usucodigo#"
                Ulocalizacion = "#Session.Ulocalizacion#"
                  ValidarCalendarios ="false"  />            
                  
       <cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="RelacionCalculo"
            datasource="#session.dsn#"
            Ecodigo = "#Session.Ecodigo#"
            RCNid = "#Form.RCNid#"
            Tcodigo = "#Form.Tcodigo#"
            Usucodigo = "#Session.Usucodigo#"
            Ulocalizacion = "#Session.Ulocalizacion#"
            ValidarCalendarios ="false" />
            
     
              
    <cfcatch type="any">
        <cfinclude template="/sif/errorPages/BDerror.cfm">
        <cfabort>
    </cfcatch>
    </cftry>
    <cfelseif esAplicar>
    	<cfquery name="rsNomina" datasource="#session.dsn#">
        	select CPtipo
            from CalendarioPagos
            where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
        </cfquery>

        <!---►►►►OJO: hay transacciones anidadas, solo sirve en CF 9◄◄◄--->
        <cftransaction>
            <!---►►►►Envio de Correo Eletronico a aquellos empleados que lo tengan Configurado◄◄◄--->
        	<cfif isdefined('form.envioCorreo') and form.envioCorreo>
                <cfinvoke component="rh.Componentes.BoletaPago" method="EnvioBoletasPago">
                    <cfinvokeargument name="RCNid" value="#Form.RCNid#">
                    <cfinvokeargument name="MensajeBoleta" value="#trim(Form.MensajeBoleta)#">
                </cfinvoke>
            </cfif>
            <!---►►►►Se aplica la nomina◄◄◄--->
            <cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="AplicaNomina" returnvariable="NewERNid">
                <cfinvokeargument name="RCNid" 			value="#Form.RCNid#">
                <cfinvokeargument name="Bid"  			value="#Form.Bid#">
                <cfinvokeargument name="CBid"  			value="#Form.CBid#">
                <cfinvokeargument name="Lvar_Regresar"  value="/cfmx/rh/Cloud/Nomina/EmpleadosNomina.cfm">
                <cfif rsNomina.CPtipo neq 4>
               		<cfinvokeargument name="tipo_cambio"  	value="#Form.tipo_cambio#">  
                </cfif>
                <cfinvokeargument name="Mcodigo"  		value="#Form.Mcodigo#">
                <cfinvokeargument name="CBcc"  			value="#Form.CBcc#">
            </cfinvoke>
            <cfif rsNomina.CPtipo eq 4>
            	<cfinvoke component="rh.Componentes.RH_PosteoRelacion" method="PosteoRelacion" >	
                    <cfinvokeargument name="Ecodigo" 	value="#Session.Ecodigo#">
                    <cfinvokeargument name="RCNid" 		value="#Form.RCNid#">
                    <cfinvokeargument name="CBcc"  		value="#Form.CBcc#" >
                    <cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#">
                </cfinvoke>
            </cfif>
           <!---►►►►Se Marca Como verificada◄◄◄--->
            <cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="VerificaNomina">
                <cfinvokeargument name="ERNid" 			value="#NewERNid#">
                <cfinvokeargument name="ERNestado" 		value="4">
                <cfinvokeargument name="DRNestado" 		value="1">
            </cfinvoke>
            
            <!---►►►►Finalizacion de la nomina◄◄◄--->
            <!---►►►►OJO: FinalizaNomina tiene transacciones adentro, solo sirve en CF 9◄◄◄--->
            <cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="FinalizaNomina">
                <cfinvokeargument name="ListERNid" value="#NewERNid#">
            </cfinvoke>
       </cftransaction>
    </cfif>
<!---→ NOMINA ESPECIALES ←--->    
<cfelseif esnomEspecial>
<!---→ CREAR EL CALENDARIO fijo valores←---> 
  <cfset LvarDateIni = LSParseDateTime(form.CPdesde)>
		<cftransaction>
				<!---►►►►Agrega el Calendario especial para nomina◄◄◄--->
                <cfinvoke component="rh.Componentes.CalendarioPago" method="AltaCalendarioPago" returnvariable="LvarCPid">
                        <cfinvokeargument name="CPdesde"		 value="#LvarDateIni#">
                        <cfinvokeargument name="CPhasta"		 value="#LvarDateIni#">
                        <cfinvokeargument name="CPfpago"		 value="#LvarDateIni#">
                        <cfinvokeargument name="Tcodigo" 		 value="#form.Tcodigo#">
                        <cfinvokeargument name="CPtipo" 		 value="1">
                        <cfinvokeargument name="CPdescripcion"   value="Nomina Especial de #DatePart('YYYY',LvarDateIni)#"> 	        
                        <cfinvokeargument name="CPnorenta"       value="#form.norenta#">
                        <cfinvokeargument name="CPnocargasley"   value="#form.nocargaley#">
                        <cfinvokeargument name="CPnocargas"      value="#form.nocarga#">
                        <cfinvokeargument name="CPnodeducciones" value="#form.nodeducci#"> 
                </cfinvoke>	
                <!---►►►►Agrega las deducciones que desean excluir◄◄◄--->
                <cfif isdefined('form.listTDid') and LEN(TRIM(form.listTDid))>
                     <cfinvoke component="rh.Componentes.CalendarioPago" method="AltaRHExcluirDeduccion">
                        <cfinvokeargument name="CPid"   		value="#LvarCPid#">
                        <cfinvokeargument name="TDidExluir"    value="#form.listTDid#">
                     </cfinvoke>
                </cfif>
               <!---►►►►Agrega las cargas que desean excluir◄◄◄--->
                <cfif isdefined('form.listDCcodigo') and LEN(TRIM(form.listDCcodigo))> 
                    <cfloop list="#form.listDCcodigo#" index="valorCargas">
                         <cfquery name="ABC_datosCargas" datasource="#session.dsn#">
                            insert into RHCargasExcluir (CPid,DClinea,BMUsucodigo)
                            values (
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPid#">, 
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#valorCargas#">,
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                            )
                        </cfquery>
                    </cfloop>
                </cfif>
                <!---CONCEPTOS DE PAGO--->
                <cfif isdefined('form.listCIid') and LEN(TRIM(form.listCIid))> 
                    <cfloop list="#form.listCIid#" index="valorCon">
                        <cfinvoke component="rh.Componentes.CalendarioPago" method="AltaCCalendario">
                            <cfinvokeargument name="CPid"    value="#LvarCPid#">
                            <cfinvokeargument name="CIid"    value="#trim(valorCon)#">
                         </cfinvoke>
                    </cfloop>
                </cfif>
           </cftransaction>
           	<cftry> 
			<!---►►►►►►►Se Recupera el Calendario de pago de la nomina especial◄◄◄◄◄◄--->
                <cfinvoke component="rh.Componentes.CalendarioPago" method="getCalendarioPago" returnvariable="rsCalendarioPago">
                    <cfinvokeargument name="CPid" value="#LvarCPid#">
                </cfinvoke>
                 <!---►►►►►►►Generacion y Calculo de la nomina especial◄◄◄◄◄◄--->
                <cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="AltaNominaEspecial">
                    <cfinvokeargument name="RCNid" 	  		 	value="#LvarCPid#">
                    <cfinvokeargument name="RCDescripcion" 	 	value="Nomina Especial de #DATEPART('YYYY',rsCalendarioPago.CPfpago)#">
                    <cfinvokeargument name="ValidarCalendarios" value="false">
       		 	</cfinvoke>
           <cfcatch type="any">
            	 <!---►►►►Si da un Error se Elimina la relacion la calculo◄◄◄--->
            	 <cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="BajaRCalculoNomina">
                    <cfinvokeargument name="RCNid" 				value="#LvarCPid#">
                    <cfinvokeargument name="TransacionActiva" 	value="true">
                </cfinvoke>
                <!---►►►►Si da un Error se Elimina la relacion la calculo◄◄◄--->
                <cfinvoke component="rh.Componentes.CalendarioPago" method="fnBajaCalendarioPago">
                    <cfinvokeargument name="CPid" value="#LvarCPid#">
                </cfinvoke>
                <cfthrow message="#cfcatch.Message#">
            </cfcatch>
           </cftry>
           <!---∟∟∟∟↔▬--------------------------------------------------------------------------↑--->
<!---►►►►►►►Manejo de Aguinaldos◄◄◄◄◄◄◄◄--->
<cfelseif esAguinaldo>
	<cfset esGeneracion = isdefined('form.Accion') and form.Accion EQ 'generar'>
    <cfif esGeneracion>
    	<cfset LvarDateIni = LSParseDateTime(form.CPdesde)>
        <cfset RHParamCFC = CreateObject("component","rh.Componentes.RHParametros").init()>
		<cfset Param2530 = RHParamCFC.get(session.dsn,session.Ecodigo,2530,"")>
        <cfif NOT LEN(TRIM(Param2530))>
        	<cfthrow message="No se encuentra configurado la incidencia para aguinaldo">
        </cfif>
   
      	<cftransaction>
				<!---►►►►Agrega el Calendario especial para Aguinaldo◄◄◄--->
                <cfinvoke component="rh.Componentes.CalendarioPago" method="AltaCalendarioPago" returnvariable="LvarCPid">
                        <cfinvokeargument name="CPdesde"		 value="#LvarDateIni#">
                        <cfinvokeargument name="CPhasta"		 value="#LvarDateIni#">
                        <cfinvokeargument name="CPfpago"		 value="#LvarDateIni#">
                        <cfinvokeargument name="Tcodigo" 		 value="#form.Tcodigo#">
                        <cfinvokeargument name="CPtipo" 		 value="1">
                        <cfinvokeargument name="CPTipoCalRenta"  value="2">
                        <cfinvokeargument name="CPdescripcion"   value="Aguinaldo del #DatePart('YYYY',LvarDateIni)#">  
                        <cfinvokeargument name="EsAguinaldo"     value="true">
                        <cfinvokeargument name="CPnorenta"       value="1">
                        <cfinvokeargument name="CPnocargasley"   value="1">
                        <cfinvokeargument name="CPnocargas"      value="1">
                    <cfif isdefined('form.listTDid') and LEN(TRIM(listTDid))>
                        <cfinvokeargument name="CPnodeducciones" value="0"> 
                    <cfelse>
                        <cfinvokeargument name="CPnodeducciones" value="1"> 
                    </cfif>
                </cfinvoke>	
                <!---►►►►Agrega las deducciones que desean incluir◄◄◄--->
                <cfif isdefined('form.listTDid') and LEN(TRIM(form.listTDid))>
                     <cfinvoke component="rh.Componentes.CalendarioPago" method="AltaRHExcluirDeduccion">
                        <cfinvokeargument name="CPid"   		value="#LvarCPid#">
                        <cfinvokeargument name="TDidIncluir"    value="#form.listTDid#">
                     </cfinvoke>
                </cfif>
                <!---►►►►Agrega los conceptos de pago◄◄◄--->
                <cfinvoke component="rh.Componentes.CalendarioPago" method="AltaCCalendario">
                    <cfinvokeargument name="CPid"    value="#LvarCPid#">
                    <cfinvokeargument name="CIid"    value="#Param2530#">
                 </cfinvoke>
           </cftransaction>
           	<cftry> 
			<!---►►►►►►►Se Recupera el Calendario de pago de la nomina especial◄◄◄◄◄◄--->
                <cfinvoke component="rh.Componentes.CalendarioPago" method="getCalendarioPago" returnvariable="rsCalendarioPago">
                    <cfinvokeargument name="CPid" value="#LvarCPid#">
                </cfinvoke>
                 <!---►►►►►►►Generacion y Calculo de la nomina especial◄◄◄◄◄◄--->
                <cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="AltaNominaEspecial">
                    <cfinvokeargument name="RCNid" 	  		 	value="#LvarCPid#">
                    <cfinvokeargument name="RCDescripcion" 	 	value="Aguinaldo del #DATEPART('YYYY',rsCalendarioPago.CPfpago)#">
                    <cfinvokeargument name="ValidarCalendarios" value="false">
       		 	</cfinvoke>
           <cfcatch type="any">
            	 <!---►►►►Si da un Error se Elimina la relacion la calculo◄◄◄--->
            	 <cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="BajaRCalculoNomina">
                    <cfinvokeargument name="RCNid" 				value="#LvarCPid#">
                    <cfinvokeargument name="TransacionActiva" 	value="true">
                </cfinvoke>
                <!---►►►►Si da un Error se Elimina la relacion la calculo◄◄◄--->
                <cfinvoke component="rh.Componentes.CalendarioPago" method="fnBajaCalendarioPago">
                    <cfinvokeargument name="CPid" value="#LvarCPid#">
                </cfinvoke>
                <cfthrow message="#cfcatch.Message#">
            </cfcatch>
           </cftry>
    </cfif>
<!---►►►►►►►Manejo de Acciones Masivas◄◄◄◄◄◄◄◄--->
<cfelseif esAccionMasiva>
	<cfset esAltaAMV  = isdefined('form.Alta_AMV')><!--- Acción Masiva de Vacaciones Agregar  --->
    <cfset esBajaAMV  = isdefined('form.Baja_AMV')><!--- Acción Masiva de Vacaciones Eliminar --->
    <cfset esAltaFiltroAMV  = isdefined('form.AltaFiltro_AMV')><!--- Acción Masiva de Vacaciones Alta Filtro --->
    <cfset esBajaFiltro_AMV = isdefined('form.BajaFiltro_AMV')><!--- Acción Masiva de Vacaciones Baja Filtro --->
    <cfset esBajaEmpleado_AMV = isdefined('form.BajaEmpleado_AMV')><!--- Acción Masiva de Vacaciones Baja Empleado --->
    <cfset esRegenerarEmpleados_AMV = isdefined('form.RegenerarEmpleados_AMV')><!--- Acción Masiva de Vacaciones Regenera Lista de Empleado --->
    <cfset esEnviar_AMV = isdefined('form.Enviar_AMV')><!--- Acción Masiva de Vacaciones, envia a vacaciones --->
    <cfif esAltaAMV>
    	<cfset cerrarNotas = true>
    	<cftransaction>
            <cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="fnAltaAccionMasiva" returnvariable="RHAid">
                <cfinvokeargument name="RHTAid"	 		value="#form.RHTAid#">
                <cfinvokeargument name="RHAcodigo"	 	value="#form.RHAcodigo#">
                <cfinvokeargument name="RHAdescripcion" value="#form.RHAdescripcion#">
                <cfinvokeargument name="RHAfdesde" 		value="#form.RHAfdesde#">
                <cfinvokeargument name="RHAfhasta" 		value="#form.RHAfhasta#">
            </cfinvoke>
            <cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="fnAltaDependencia" returnvariable="RHDAMid">
                <cfinvokeargument name="RHAid"	 		value="#RHAid#">
                <cfinvokeargument name="Tcodigo"	 	value="#form.Tcodigo#">
            </cfinvoke>
            <cfsetting requesttimeout="84600">
            <cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="generarEmpleados">
                <cfinvokeargument name="RHAid" value="#RHAid#"/>
				<cfinvokeargument name="validaTcodigo" value="true"/>
            </cfinvoke>
        </cftransaction>
   	<cfelseif esBajaAMV>
    	<cfset cerrarLightBox  = true> 
		<cfset cerrarNotas = true>
        <cfset form.noSumbit = true>
    	<cftransaction>
            <cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="fnBajaAccionMasiva" returnvariable="RHAid">
                <cfinvokeargument name="RHAid"	 		value="#form.RHAid#">
            </cfinvoke>
        </cftransaction>
  	<cfelseif esAltaFiltroAMV>
    	<cfset form.noSumbit = true>
        <cfif not isdefined('form.EliminarFiltros')>
			<cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="fnGetDependencia" returnvariable="rsDep">
                <cfinvokeargument name="RHAid"	 		value="#form.RHAid#">
                <cfif isdefined('form.DEid')>
                    <cfinvokeargument name="DEid"	 	value="#form.DEid#">
                </cfif>
                <cfif isdefined('form.Tcodigo')>
                    <cfinvokeargument name="Tcodigo"	value="#form.Tcodigo#">
                </cfif>
                <cfif isdefined('form.CFid')>
                    <cfinvokeargument name="CFid"	 	value="#form.CFid#">
                </cfif>
                <cfif isdefined('form.Dcodigo')>
                    <cfinvokeargument name="Dcodigo"	 value="#form.Dcodigo#">
                </cfif>
                <cfif isdefined('form.Ocodigo')>
                    <cfinvokeargument name="Ocodigo"	 value="#form.Ocodigo#">
                </cfif>
                <cfif isdefined('form.RHPcodigo')>
                    <cfinvokeargument name="RHPcodigo"	 value="#form.RHPcodigo#">
                </cfif>
            </cfinvoke>
        </cfif>
        <cfif isdefined('form.EliminarFiltros') or rsDep.recordcount eq 0>
            <cftransaction>
                <cfif isdefined('form.EliminarFiltros')>
                    <cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="fnBajaDependencia">
                    	<cfinvokeargument name="RHAid"	 		value="#form.RHAid#">
                	</cfinvoke>
                </cfif>
                <cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="fnAltaDependencia" returnvariable="RHDAMid">
                    <cfinvokeargument name="RHAid"	 		value="#form.RHAid#">
                    <cfif isdefined('form.DEid')>
                        <cfinvokeargument name="DEid"	 	value="#form.DEid#">
                    </cfif>
                    <cfif isdefined('form.Tcodigo')>
                        <cfinvokeargument name="Tcodigo"	value="#form.Tcodigo#">
                    </cfif>
                    <cfif isdefined('form.CFid')>
                        <cfinvokeargument name="CFid"	 	value="#form.CFid#">
                    </cfif>
                    <cfif isdefined('form.Fcorte')>
                        <cfinvokeargument name="Fcorte"	 	value="#form.Fcorte#">
                    </cfif>
                    <cfif isdefined('form.Dcodigo')>
                        <cfinvokeargument name="Dcodigo"	 value="#form.Dcodigo#">
                    </cfif>
                    <cfif isdefined('form.Ocodigo')>
                        <cfinvokeargument name="Ocodigo"	 value="#form.Ocodigo#">
                    </cfif>
                    <cfif isdefined('form.RHPcodigo')>
                        <cfinvokeargument name="RHPcodigo"	 value="#form.RHPcodigo#">
                    </cfif>
                </cfinvoke>
                <cfif isdefined('form.IncluirDependencia')>
                    <cfquery name="rsPathCF" datasource="#Session.DSN#">
                        select CFpath
                        from CFuncional
                        where Ecodigo = #session.Ecodigo#
                        and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
                    </cfquery>
                    <cfquery name="rsCFs" datasource="#Session.DSN#">
                        select CFid
                            from CFuncional
                            where Ecodigo = #session.Ecodigo#
                            and CFpath like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(rsPathCF.CFpath)#/%">
                            and not exists (
                                select 1
                                from RHDepenAccionM x
                                where x.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
                                and x.CFid = CFuncional.CFid
                            )
                    </cfquery>
                    <cfloop query="rsCFs">
                        <cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="fnAltaDependencia" returnvariable="RHDAMid">
                            <cfinvokeargument name="RHAid"	 	value="#form.RHAid#">
                            <cfinvokeargument name="Tcodigo"	value="#form.Tcodigo#">
                            <cfinvokeargument name="CFid"	 	value="#rsCFs.CFid#">
                        </cfinvoke>
                    </cfloop>
                </cfif>
                <cfsetting requesttimeout="84600">
                <cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="generarEmpleados">
                    <cfinvokeargument name="RHAid" 			value="#Form.RHAid#"/>
                    <cfinvokeargument name="validaTcodigo" 	value="true"/>
                </cfinvoke>
       		</cftransaction>
       	</cfif>
    <cfelseif esBajaFiltro_AMV>
    	<cfset form.noSumbit = true>
    	<cftransaction>
       		<cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="fnBajaDependencia">
                <cfinvokeargument name="RHDAMid"	value="#form.RHDAMid#">
            </cfinvoke>
        	<cfsetting requesttimeout="84600">
            <cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="generarEmpleados">
                <cfinvokeargument name="RHAid"			value="#Form.RHAid#"/>
				<cfinvokeargument name="validaTcodigo" 	value="true"/>
            </cfinvoke>
        </cftransaction>
     <cfelseif esBajaEmpleado_AMV>
    	<cfset form.noSumbit = true>
    	<cftransaction>
       		<cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="fnBajaEmpleado">
                <cfinvokeargument name="RHEAMid"	value="#form.RHEAMid#">
                <cfinvokeargument name="RHAid"		value="#form.RHAid#">
            </cfinvoke>
        </cftransaction>
   	<cfelseif esRegenerarEmpleados_AMV>
    	<cfset form.noSumbit = true>
    	<cftransaction>
        	<cfsetting requesttimeout="84600">
            <cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="generarEmpleados">
                <cfinvokeargument name="RHAid"			value="#form.RHAid#"/>
				<cfinvokeargument name="validaTcodigo" 	value="true"/>
            </cfinvoke>
        </cftransaction>
  	<cfelseif esEnviar_AMV>
    	<cfset cerrarLightBox  = true> 
		<cfset cerrarNotas = true>
        <cfset form.noSumbit = true>
        
        <cfquery name="rsUpEn" datasource="#session.dsn#">
            select EAid,DEid from EAnualidad
            where DEid in (select DEid from RHEmpleadosAccionMasiva where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAid#">)
            and EAacum < 345
        </cfquery>
        <cfquery name="Anua" datasource="#session.dsn#">
            select RHTAanualidad 
            from RHAccionesMasiva a
                inner join RHTAccionMasiva b
                on b.RHTAid=a.RHTAid
            where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAid#">
        </cfquery>
        <cfif Anua.RHTAanualidad eq 1>
            <cfquery name="rsDE" datasource="#session.dsn#">
                select DEid,RHAfhasta,RHAfdesde from RHEmpleadosAccionMasiva where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAid#">
            </cfquery>
      	</cfif>
        <cftransaction>
            <cfquery name="rsDel" datasource="#session.dsn#">
                delete DAnualidad where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAid#">
            </cfquery>
        
            <cfloop query="rsUpEn">
                <cfquery name="rsUpA" datasource="#session.dsn#">
                    update EAnualidad 
                        set EAacum= (EAacum+360)
                    where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUpEn.DEid#">
                    and DAtipoConcepto=2
                </cfquery>
            </cfloop>
			<cfif isdefined('rsDE')>
                <cfloop query="rsDE">
                    <cfquery name="rsEnc" datasource="#session.dsn#">
                        select EAid from EAnualidad where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDE.DEid#"> and DAtipoConcepto=2 <!---Concepto de anualidad tipo ITCR--->
                    </cfquery>
                    <cfquery name="rsIn" datasource="#session.dsn#">
                        insert into DAnualidad(EAid,DAdescripcion,DAfdesde,DAfhasta,DAanos,BMfalta,BMUsucodigo,DAtipo,DAtipoConcepto,RHAid,DAaplicada)
                        values(#rsEnc.EAid#,
                                'Anualidad Cumplida',
                                <cfqueryparam cfsqltype="cf_sql_date" value="#rsDE.RHAfdesde#">,
                                <cfqueryparam cfsqltype="cf_sql_date" value="#rsDE.RHAfhasta#">,
                                1,
                                #now()#,
                                #session.Usucodigo#,
                                1,
                                2,
                                #Form.RHAid#,0)
                    </cfquery>	
                    <cfquery name="rsUpA" datasource="#session.dsn#">
                        update EAnualidad 
                            set EAacum= (EAacum-360)
                        where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDE.DEid#">
                        and DAtipoConcepto=2
                    </cfquery>
                </cfloop>
           	</cfif>
        	<cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="generarAccionesMasivas">
                <cfinvokeargument name="RHAid" value="#form.RHAid#"/>
                <cfinvokeargument name="RHTipoAplicacion" value="0"/>
            </cfinvoke>
            <cfinvoke component="rh.Componentes.RH_AccionesMasivas" method="aplicarAccionMasiva" returnvariable="LvarResult">
				<cfinvokeargument name="RHAid" value="#form.RHAid#"/> 
			</cfinvoke>
        </cftransaction>
    </cfif>
<cfelseif esInc>
	<cfset esAlta = isdefined('form.Alta')>
    <cfset esBaja = isdefined('form.Baja')>
	<cfif esAlta>
        <cftransaction>
            <cfinvoke component="rh.Componentes.RH_Incidencias" method="Alta">
                <cfinvokeargument name="DEid" value="#form.DEid#"/>
                <cfinvokeargument name="CIid" value="#form.CIid#"/> 
                <cfif isdefined('form.CFid') and len(trim(form.CFid))>
                    <cfinvokeargument name="CFid" value="#form.CFid#"/> 
                </cfif>
                <cfinvokeargument name="iFecha" value="#LSParseDatetime(form.ICfecha)#"/> 
                <cfinvokeargument name="iValor" value="#form.ICvalor#"/> 
                <cfif isdefined('form.RHJid') and len(trim(form.RHJid))>
                    <cfinvokeargument name="RHJid" value="#form.RHJid#"/> 
                </cfif>
                <cfinvokeargument name="TransaccionAbierta" value="true"/> 
            </cfinvoke>
            <cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="RelacionCalculo">
              	<cfinvokeargument name="RCNid" value="#Form.RCNid#">
                <cfinvokeargument name="pDEid" value="#Form.DEid#">
                <cfinvokeargument name="ValidarCalendarios" value="false">
            </cfinvoke>
        </cftransaction>
    <cfelseif esBaja>
        <cfquery name="rsCalendario" datasource="#session.DSN#">
            select CPtipo, CPdesde, CPhasta from CalendarioPagos where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
        </cfquery>
        <cftransaction>
            <cfif rsCalendario.CPtipo EQ 2>
                <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Session.DSN#" Ecodigo="#Session.Ecodigo#" Pvalor="730" default="" returnvariable="CIidAnticipo"/>
                <cfif Not Len(CIidAnticipo)>
                    <cf_throw message="Error!, No se ha definido el Concepto de Pago para Anticipos de Salario a utilizar en los parámetros del Sistema. Proceso Cancelado!!" errorCode="1145">
                </cfif>
                <cfinvoke component="rh.Componentes.RH_Incidencias" method="fnBajaIncidenciaCalculo">
                    <cfinvokeargument name="CIid" value="#CIidAnticipo#"/>
                    <cfinvokeargument name="DEid" value="#form.DEid#"/>
                </cfinvoke>
            </cfif>
            <cfquery datasource="#Session.DSN#">	
                delete from DeduccionesEmpleado 
                where Dfechaini between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCalendario.CPdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCalendario.CPhasta#">
                  and CIid is not null <cfif IsDefined('Form.DEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"></cfif>
                  and (select count(1) 
                       from HDeduccionesCalculo hdc 
                       where hdc.Did = DeduccionesEmpleado.Did
                       ) = 0
            </cfquery>
            <cfinvoke component="rh.Componentes.RH_Incidencias" method="fnBajaIncidenciaCalculo">
                <cfinvokeargument name="ICid" value="#Form.ICid#"/>
            </cfinvoke>
            <cfquery datasource="#Session.DSN#">
                update SalarioEmpleado set SEcalculado = 0
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
                and RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
            </cfquery>
            <cfinvoke component="rh.Componentes.RH_CalculoNomina" method="CalculoNomina">
             	<cfinvokeargument name="RCNid" 				value="#Form.RCNid#"> 
                <cfinvokeargument name="pDEid" 				value="#form.DEid#">
                <cfinvokeargument name="ValidarCalendarios" value="false">
           </cfinvoke>
        </cftransaction>
    </cfif>
<cfelseif esDeduc>
	<cfset esAlta = isdefined('form.Alta')>
    <cfset esBaja = isdefined('form.Baja')>
	<cfif esAlta>
    	<cfset form.noSumbit = true>
    	 <cfquery name="rsTDeduccionRenta" datasource="#session.DSN#">
            select 1
            from TDeduccion
            where TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
              and TDrenta > 0
        </cfquery>
        <cfif rsTDeduccionRenta.RecordCount GT 0>
       		<cfquery name="rsTDeduccionRentaOtra" datasource="#session.DSN#">
                select 1 
                from DeduccionesEmpleado
                where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
                and TDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
                and (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.Dfechaini)#"> 
                    between Dfechaini and Dfechafin
                    or <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.Dfechafin)#"> 
                    between Dfechaini and Dfechafin
                    )
            </cfquery>
			<cfif rsTDeduccionRentaOtra.RecordCount GT 0>
                <cfthrow message="Transacción Cancelada. Está definiendo una deducción de tipo renta, pero ya tiene otra de tipo renta definida para el rango de fechas dado, Proceso Cancelado!">
            </cfif>
        </cfif>
        <cfif Len(Trim(form.Ddescripcion)) NEQ 0>
         	<cfset lvarDescripcion = form.Ddescripcion>
        <cfelse>
        	 <cfquery name="rsTDeduccion" datasource="#session.DSN#">
                select TDdescripcion
                from TDeduccion
                where TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
            </cfquery>
        	<cfset lvarDescripcion = rsTDeduccion.TDdescripcion>
        </cfif>
        <cftransaction>
        	<cfinvoke component="rh.Componentes.Deduccion" method="fnAltaDeduccion">
                <cfinvokeargument name="DEid" value="#form.DEid#"/>
                <cfinvokeargument name="SNcodigo" value="#form.SNcodigo#"/>
                <cfinvokeargument name="TDid" value="#form.TDid#"/>
                <cfinvokeargument name="Ddescripcion" value="#lvarDescripcion#"/>
                <cfif rsTDeduccionRenta.RecordCount eq 0>
                	<cfinvokeargument name="Dmetodo" value="#form.Dmetodo#"/>
                </cfif>
                <cfinvokeargument name="Dvalor" value="#form.Dvalor#"/>
                <cfinvokeargument name="Dfechaini" value="#LSParsedateTime(form.Dfechaini)#"/>
                <cfif isdefined("form.Dfechafin") and len(trim(form.Dfechafin))>
                	<cfinvokeargument name="Dfechafin" value="#LSParsedateTime(form.Dfechafin)#"/>
                </cfif>
                <cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
                	<cfinvokeargument name="Dmonto" value="#form.Dmonto#"/>
                </cfif>
                <cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
                	<cfinvokeargument name="Dtasa" value="#form.Dtasa#"/>
                </cfif>
                <cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
                	<cfinvokeargument name="Dsaldo" value="#form.Dsaldo#"/>
                </cfif>
                <cfif isdefined("form.Dcontrolsaldo") and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0>
                	<cfinvokeargument name="Dmontoint" value="#form.Dmontoint#"/>
                </cfif>
                <cfif isdefined('form.Dactivo')>
                	<cfinvokeargument name="Dactivo" value="1"/>
                </cfif>
                <cfinvokeargument name="Dcontrolsaldo" value="#isdefined('form.Dcontrolsaldo') and form.Dcontrolsaldo eq '1' and rsTDeduccionRenta.RecordCount EQ 0#"/>
                <cfinvokeargument name="Dreferencia" value="#form.Dreferencia#"/>
                <cfif isdefined("form.Dinicio")>
                	<cfinvokeargument name="Dinicio" value="#form.Dinicio#"/>
                </cfif>
            </cfinvoke>
            <cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="RelacionCalculo" datasource="#session.dsn#"
                    Ecodigo = "#Session.Ecodigo#"
                    RCNid = "#Form.RCNid#"
                    Tcodigo = "#Form.Tcodigo#"
                    Usucodigo = "#Session.Usucodigo#"
                    Ulocalizacion = "#Session.Ulocalizacion#"
                    ValidarCalendarios = "false"
                    pDEid = "#Form.DEid#" />
        </cftransaction>
    <cfelseif esBaja>
    	<cfquery name="rsCalendario" datasource="#session.DSN#">
            select CPtipo, CPdesde, CPhasta from CalendarioPagos where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
        </cfquery>
        <cftransaction>
            <cfif rsCalendario.CPtipo EQ 2>
                <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Session.DSN#" Ecodigo="#Session.Ecodigo#" Pvalor="730" default="" returnvariable="CIidAnticipo"/>
                <cfif Not Len(CIidAnticipo)>
                    <cf_throw message="Error!, No se ha definido el Concepto de Pago para Anticipos de Salario a utilizar en los parámetros del Sistema. Proceso Cancelado!!" errorCode="1145">
                </cfif>
                <cfinvoke component="rh.Componentes.RH_Incidencias" method="fnBajaIncidenciaCalculo">
                    <cfinvokeargument name="CIid" value="#CIidAnticipo#"/>
                    <cfinvokeargument name="DEid" value="#form.DEid#"/>
                </cfinvoke>
            </cfif>
            <cfquery datasource="#Session.DSN#">	
                delete from DeduccionesEmpleado 
                where Dfechaini between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCalendario.CPdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCalendario.CPhasta#">
                  and CIid is not null <cfif IsDefined('Form.DEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"></cfif>
                  and (select count(1) 
                       from HDeduccionesCalculo hdc 
                       where hdc.Did = DeduccionesEmpleado.Did
                       ) = 0
            </cfquery>
            <cfinvoke component="rh.Componentes.Deduccion" method="fnBajaDeduccionCalculo">
                <cfinvokeargument name="Did" 	value="#Form.Did#"/>
                <cfinvokeargument name="RCNid" 	value="#Form.RCNid#"/>
                <cfinvokeargument name="DEid" 	value="#Form.DEid#"/>
            </cfinvoke>
            <cfquery datasource="#Session.DSN#">
                update SalarioEmpleado set SEcalculado = 0
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
                and RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
            </cfquery>
            <cfinvoke component="rh.Componentes.RH_CalculoNomina" method="CalculoNomina">
                    <cfinvokeargument name="RCNid"	 value="#Form.RCNid#">
                <cfif isdefined('form.DEid') and LEN(TRIM(Form.RCNid))>
                    <cfinvokeargument name="DEid" 	value="#Form.DEid#">
                </cfif>
                    <cfinvokeargument name="ValidarCalendarios" value="false">
             </cfinvoke>
        </cftransaction>
    </cfif>
<cfelseif esInc_PRG>
	<cfset esAlta = isdefined('form.Alta')>
    <cfset esBaja = isdefined('form.Baja')>
    <cfset esCambio= isdefined('form.Cambio')>
    <!---busco si la incidencia va a afectar a una nomina que este activa--->
    <!---obtengo posibles calendarios--->
    <cfinvoke component="rh.Componentes.RH_CalculoNomina" method="GetCalculoNomina" returnvariable="rsCalculoNomina">
		<cfif isdefined('form.Tcodigo')><cfinvokeargument name="Tcodigo" value="#form.Tcodigo#"></cfif>
	</cfinvoke>
    <!---busco dentro de ellos si existe una fecha entre y si esta el empleado--->
    <cfif not isdefined('form.Baja')>
		<cfset iFecha = "#LSParseDateTime(Form.ICfecha)#" >
        <cfloop query="rsCalculoNomina">
            <cfquery name="buscaNomina" datasource="#Session.DSN#">
                select  RCNid
                from RCalculoNomina 
                where RCNid = #rsCalculoNomina.RCNid# and #iFecha#  between RCdesde and RChasta
            </cfquery>
       </cfloop>
       <!---Si consigo una nomina le cambio el valor al estado de cambio de la nomina--->
       <cfif buscaNomina.recordCount>
            <cfquery datasource="#Session.DSN#">
                update SalarioEmpleado set SEcalculado = 0
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
                and RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#buscaNomina.RCNid#">
            </cfquery>   
       </cfif>
   </cfif>
    <cfif esAlta or esCambio>
    	<cfquery name="rsDatosConcepto" datasource="#Session.DSN#">
            select 	coalesce(b.CItipo,'m') as CItipo, b.CIdia, b.CImes, b.CIcalculo,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#Form.ICfecha#"> as Ifecha,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ICvalor#"> as Ivalor,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"> as DEid,
                    0 as RHJid, 0 as Tcodigo, coalesce(b.CIcantidad,0) as CIcantidad, coalesce(b.CIrango,0) as CIrango,
                    coalesce(b.CIspcantidad,0) as CIspcantidad, coalesce(b.CIsprango,0) as CIsprango
            from CIncidentes a
                left outer join CIncidentesD b
                    on a.CIid = b.CIid
            where a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">
                and a.CItipo = 3
        </cfquery>
            
        <cfif rsDatosConcepto.RecordCount NEQ 0>
            <!---LLAMAR CALCULADORA PARA OBTENER EL Imonto----->
            <cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")><!----Para utilizar la calculadora--->
            <cfset current_formulas = rsDatosConcepto.CIcalculo>
            <cfset presets_text = RH_Calculadora.get_presets(LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha1_accion--->
                                           LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha2_accion--->
                                           rsDatosConcepto.CIcantidad,<!---CIcantidad--->
                                           rsDatosConcepto.CIrango, <!---CIrango--->
                                           rsDatosConcepto.CItipo, <!---CItipo--->
                                           rsDatosConcepto.DEid,	<!---DEid--->
                                           rsDatosConcepto.RHJid, <!---RHJid--->
                                           session.Ecodigo, <!---Ecodigo--->
                                           0, <!---RHTid--->
                                           0, <!---RHAlinea--->																		   
                                           rsDatosConcepto.CIdia, <!---CIdia--->
                                           rsDatosConcepto.CImes,<!---CImes--->
                                           rsDatosConcepto.Tcodigo,<!---Tcodigo--->
                                           FindNoCase('SalarioPromedio', current_formulas), <!---calc_promedio--->
                                           'false', <!---masivo--->
                                           '', <!---tabla_temporal--->
                                           0,<!---calc_diasnomina--->
                                           rsDatosConcepto.Ivalor,
                                           '', 
                                           rsDatosConcepto.CIsprango,
                                           rsDatosConcepto.CIspcantidad
                                           )>
                                           
            <cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
            <cfif Not IsDefined("values") or not isdefined("presets_text")>												
                <cfinvoke component="sif.Componentes.Translate"
                    method="Translate"
                    Key="LB_NoEsPosibleRealizarElCalculo"
                    Default="No es posible realizar el c&aacute;lculo"
                    XmlFile="/rh/generales.xml"
                    returnvariable="LB_NoEsPosibleRealizarElCalculo"/>
                <cf_throw message="#LB_NoEsPosibleRealizarElCalculo#" errorCode="1000">
            </cfif>
            <cfset iMonto = values.get('resultado').toString()>
        </cfif>
    </cfif>
     
    <cfif esAlta>
        <cfinvoke component="rh.Componentes.RH_Incidencias" method="Alta" returnVariable="Iid"> 
            <cfinvokeargument name="DEid" value="#Form.DEid#">
            <cfinvokeargument name="CIid" value="#Form.CIid#">
            <cfinvokeargument name="iFecha" value="#LSParseDateTime(Form.ICfecha)#">
            <cfinvokeargument name="iValor" value="#Form.ICvalor#">
            <cfif rsDatosConcepto.RecordCount NEQ 0>
                <cfinvokeargument name="Imonto" value="#iMonto#">
            </cfif>
            <cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0>
                <cfinvokeargument name="CFid" value="#Form.CFid#">
            </cfif>
            <cfif isdefined("form.RHJid") and len(trim(form.RHJid)) gt 0>
                <cfinvokeargument name="RHJid" value="#Form.RHJid#">
            </cfif>
            <cfif isdefined("form.Icpespecial") and len(trim(form.Icpespecial)) NEQ 0 and form.Icpespecial EQ 'on'>
                <cfinvokeargument name="Icpespecial" value="1">
                <cfif isdefined("form.IfechaRebajo")>
                    <cfinvokeargument name="IfechaRebajo" value="#form.IfechaRebajo#">
                </cfif>
            </cfif>
        </cfinvoke>
    <cfelseif esCambio>
    	<cfinvoke component="rh.Componentes.RH_Incidencias" method="Cambio">
            <cfinvokeargument name="Iid" 	value="#Form.Iid#">
            <cfinvokeargument name="DEid" value="#Form.DEid#">
            <cfinvokeargument name="CIid" value="#Form.CIid#">
            <cfinvokeargument name="iFecha" value="#LSParseDateTime(Form.ICfecha)#">
            <cfinvokeargument name="iValor" value="#Form.ICvalor#">
            <cfif rsDatosConcepto.RecordCount NEQ 0>
                <cfinvokeargument name="Imonto" value="#iMonto#">
            </cfif>
			<cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0>
                <cfinvokeargument name="CFid" value="#Form.CFid#">
            </cfif>
            <cfif isdefined("form.RHJid") and len(trim(form.RHJid)) gt 0>
                <cfinvokeargument name="RHJid" value="#Form.RHJid#">
            </cfif>
            <cfif isdefined("form.Icpespecial") and len(trim(form.Icpespecial)) NEQ 0 and form.Icpespecial EQ 'on'>
                <cfinvokeargument name="Icpespecial" value="1">
                <cfif isdefined("form.IfechaRebajo")>
                    <cfinvokeargument name="IfechaRebajo" value="#form.IfechaRebajo#">
                </cfif>
          	<cfelse>
                <cfinvokeargument name="Icpespecial" value="0">
            </cfif>		
        </cfinvoke>
    <cfelseif esBaja>
    	<cfinvoke component="rh.Componentes.RH_Incidencias" method="Baja" Iid="#Form.Iid#"/>
	</cfif>
<cfelseif esCompEmp>
	<cfset esNomina = true>
    <cfset form.noSumbit = true>
	<cfinclude template="/rh/Cloud/Empleado/Laboral-sql.cfm">
<cfelseif esDeducMas>
	<cfset esAlta = isdefined('form.Alta')>
    <cfset esBaja = isdefined('form.Baja')>
    <cfset esCambio= isdefined('form.Cambio')>
    <cfset esAplicar= isdefined('form.Aplicar')>
    <cfif esAlta>
        <cfquery name="rsLote" datasource="#session.DSN#">
            select coalesce(max(EIDlote),0)+1 as EIDlote
            from EIDeducciones
        </cfquery>
        <cfinvoke component="rh.Componentes.Deduccion" method="fnAltaEDeduccionMasiva" returnVariable="EIDlote"> 
            <cfinvokeargument name="EIDlote" value="#rsLote.EIDlote#">
            <cfinvokeargument name="TDid" value="#Form.TDid#">
            <cfinvokeargument name="SNcodigo" value="#form.SNcodigo#">
            <cfinvokeargument name="Tcodigo" value="#trim(form.Tcodigo)#">
            <cfinvokeargument name="EIDdescripcion" value="#form.EIDdescripcion#">
        </cfinvoke>
   	<cfelseif esCambio>
     	<cfinvoke component="rh.Componentes.Deduccion" method="fnCambioEDeduccionMasiva" returnVariable="EIDlote"> 
            <cfinvokeargument name="EIDlote"		value="#form.EIDlote#">
            <cfinvokeargument name="TDid" 			value="#Form.TDid#">
            <cfinvokeargument name="SNcodigo" 		value="#form.SNcodigo#">
            <cfinvokeargument name="Tcodigo" 		value="#trim(form.Tcodigo)#">
            <cfinvokeargument name="EIDdescripcion" value="#form.EIDdescripcion#">
            <cfinvokeargument name="EIDfecha" 		value="#LSParseDateTime(form.EIDfecha)#">
        </cfinvoke>
    <cfelseif esBaja>
    	<cftransaction>
        	<cfinvoke component="rh.Componentes.Deduccion" method="fnBajaDDeduccionMasiva"> 
            	<cfinvokeargument name="EIDlote" 			value="#form.EIDlote#">
            </cfinvoke>
            <cfinvoke component="rh.Componentes.Deduccion" method="fnBajaEDeduccionMasiva"> 
                <cfinvokeargument name="EIDlote" value="#form.EIDlote#">
            </cfinvoke>  
        </cftransaction>
  	<cfelseif esAplicar>
    	<cfset form.noSumbit = true>
    	<cftransaction>
            <cfinvoke component="rh.Componentes.Deduccion" method="fnAplicaDeduccionMasiva"> 
                <cfinvokeargument name="EIDlote" value="#form.EIDlote#">
            </cfinvoke> 
        </cftransaction>
    </cfif>
<cfelseif esDeducMasD>
	<cfset esAlta = isdefined('form.Alta')>
    <cfset esBaja = isdefined('form.Baja')>
    <cfset esCambio= isdefined('form.Cambio')>
    <cfif esAlta>
    	<cf_dbfunction name="now" returnvariable="lvarHoy">
        <cfquery name="rsEmpleados" datasource="#session.dsn#">
            select distinct de.DEidentificacion
            from LineaTiempo lt
                <cfif form.filtroTipo eq 2>
                    <cfif form.subFiltro eq 1>	
                    inner join RHPlazas p
                        on p.RHPid = lt.RHPid and p.Ecodigo = lt.Ecodigo and p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.subFiltroCF#">
                    <cfelseif form.subFiltro eq 3>			
                    inner join RHPlazas p
                        on p.RHPid = lt.RHPid and p.Ecodigo = lt.Ecodigo and p.RHPpuesto = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.subFiltroP)#">
                    </cfif>
                </cfif>
                inner join DatosEmpleado de
                    on de.DEid = lt.DEid
            where lt.Ecodigo = #session.Ecodigo#
              <cfif form.filtroTipo eq 2>
                <cfif form.subFiltro eq 2>
                    and lt.Dcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.subFiltroD#">
                    and lt.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.subFiltroO#">
                </cfif>
                and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.filtroFecha)#"> between lt.LTdesde and lt.LThasta
              </cfif>
              <cfif form.filtroTipo eq 3>
              and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.filtroEmpleado#">
              </cfif>
              and not exists (select 1
                            from EIDeducciones eid
                                inner join DIDeducciones did
                                    on did.EIDlote = eid.EIDlote
                                inner join DatosEmpleado sde
                                    on sde.DEidentificacion = did.DIDidentificacion and sde.Ecodigo = eid.Ecodigo
                            where eid.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#form.EIDlote#"> 
                              and eid.Ecodigo = #session.Ecodigo#
                              and sde.DEid = lt.DEid)	
              and exists (select 1 
                          from LineaTiempo lts 
                          where lts.DEid = lt.DEid and (lts.LTdesde between #lvarHoy# and '61000101' or lts.LThasta between #lvarHoy# and '61000101')
                            and lts.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Tcodigo)#">)
        </cfquery>
    	<cftransaction>
            <cfloop query="rsEmpleados">
                <cfinvoke component="rh.Componentes.Deduccion" method="fnAltaDDeduccionMasiva" returnVariable="DIDid"> 
                    <cfinvokeargument name="EIDlote" 			value="#form.EIDlote#">
                    <cfinvokeargument name="DEidentificacion" 	value="#rsEmpleados.DEidentificacion#">
                    <cfinvokeargument name="DIDreferencia" 		value="#form.DIDreferencia#">
                    <cfinvokeargument name="DIDmetodo" 			value="#form.DIDmetodo#">
                    <cfinvokeargument name="DIDvalor" 			value="#replace(form.DIDvalor,',','','ALL')#">
                    <cfinvokeargument name="DIDfechaini" 		value="#LSParseDateTime(form.DIDfechaini)#">
                    <cfinvokeargument name="DIDfechafin" 		value="#LSParseDateTime(form.DIDfechaini)#">
                    <cfinvokeargument name="DIDmonto" 			value="0">
                </cfinvoke>
            </cfloop>
        </cftransaction>
   	<cfelseif esCambio>
   		<cfinvoke component="rh.Componentes.Deduccion" method="fnCambioDDeduccionMasiva" returnVariable="DIDid"> 
            <cfinvokeargument name="DIDid" 				value="#form.DIDid#">
            <cfinvokeargument name="EIDlote" 			value="#form.EIDlote#">
            <cfif isdefined('form.DEidentificacion')>
            	<cfinvokeargument name="DEidentificacion" 	value="#form.DEidentificacion#">
            </cfif>
            <cfif isdefined('form.DIDreferencia')>
           		<cfinvokeargument name="DIDreferencia" 		value="#form.DIDreferencia#">
            </cfif>
            <cfif isdefined('form.DIDmetodo')>
            	<cfinvokeargument name="DIDmetodo" 			value="#form.DIDmetodo#">
            </cfif>
            <cfif isdefined('form.DIDvalor')>
            	<cfinvokeargument name="DIDvalor" 			value="#replace(form.DIDvalor,',','','ALL')#">
            </cfif>
            <cfif isdefined('form.DIDfechaini')>
            	<cfinvokeargument name="DIDfechaini" 		value="#LSParseDateTime(form.DIDfechaini)#">
            </cfif>
            <cfif isdefined('form.DIDfechaini')>
            	<cfinvokeargument name="DIDfechafin" 		value="#LSParseDateTime(form.DIDfechaini)#">
            </cfif>
    	</cfinvoke>
   	<cfelseif esBaja>
    	<cfinvoke component="rh.Componentes.Deduccion" method="fnBajaDDeduccionMasiva"> 
            <cfinvokeargument name="DIDid" 				value="#form.DIDid#">
            <cfinvokeargument name="EIDlote" 			value="#form.EIDlote#">
    	</cfinvoke>
    </cfif>
<cfelseif esEPTU>
	<cfset esAlta = isdefined('form.Alta')>
    <cfset esBaja = isdefined('form.Baja')>
    <cfset esCerrarCalculo = isdefined('form.CerrarCalculo')>
    <cfset esCambio= isdefined('form.Cambio')>
    <cfif esAlta>
    	<cfinvoke component="rh.Componentes.RH_PTU" method="fnAltaEPTU" returnvariable="RHPTUEid"> 
            <cfinvokeargument name="RHPTUEcodigo" 			value="#form.RHPTUEcodigo#">
            <cfinvokeargument name="RHPTUEdescripcion" 		value="#form.RHPTUEdescripcion#">
            <cfinvokeargument name="CIid" 					value="#form.CIid#">
            <cfinvokeargument name="FechaDesde" 			value="#LSParseDateTime(form.FechaDesde)#">
            <cfinvokeargument name="FechaHasta" 			value="#LSParseDateTime(form.FechaHasta)#">
            <cfinvokeargument name="RHPTUEMonto" 			value="#replace(form.RHPTUEMonto,',','','ALL')#">
            <cfif isdefined('form.RHPTUEDescFaltas')>
            	<cfinvokeargument name="RHPTUEDescFaltas"	value="1">
            </cfif>
            <cfif isdefined('form.RHPTUEDescIncapa')>
            	<cfinvokeargument name="RHPTUEDescIncapa"	value="1">
            </cfif>
    	</cfinvoke>
   	<cfelseif esBaja>
    	<cfset form.noSumbit = true>
        <cfquery name="rsNominaPago" datasource="#session.dsn#">
            select 1
            from ERNomina ern
            where ern.Ecodigo = #session.Ecodigo# and ern.RCNid in(select rcn.RCNid from RCalculoNomina rcn where rcn.Ecodigo = ern.Ecodigo and ern.ERNid = ern.ERNid and rcn.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">)
        </cfquery>
        <cfquery name="rsNominaHPago" datasource="#session.dsn#">
            select 1
            from HERNomina ern
            where ern.Ecodigo = #session.Ecodigo# and ern.RCNid in(select rcn.RCNid from HRCalculoNomina rcn where rcn.Ecodigo = ern.Ecodigo and ern.ERNid = ern.ERNid and rcn.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">)
        </cfquery>
        <cfquery name="rsNomina" datasource="#session.DSN#">
        	select RCNid
            from RCalculoNomina
            where Ecodigo = #Session.Ecodigo# and RCestado in (0,1,2,3) and RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">
        </cfquery>
        <cfif rsNominaPago.recordcount eq 0 and  rsNominaHPago.recordcount eq 0>
            <cftransaction>
                <cfinvoke component="rh.Componentes.RH_PTU" method="fnBajaDPTU">
                    <cfinvokeargument name="RHPTUEid" 			value="#form.RHPTUEid#">
                </cfinvoke>
                <cfinvoke component="rh.Componentes.RH_PTU" method="fnBajaDEPTU"> 
                    <cfinvokeargument name="RHPTUEid" 			value="#form.RHPTUEid#">
                </cfinvoke>
                <cfloop query="rsNomina">
                    <cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="BajaRCalculoNomina"> 
                        <cfinvokeargument name="RCNid" 				value="#rsNomina.RCNid#">
                        <cfinvokeargument name="TransacionActiva" 	value="true">
                    </cfinvoke>
                    <cfinvoke component="rh.Componentes.CalendarioPago" method="fnBajaCalendarioPago"> 
                        <cfinvokeargument name="CPid" 			value="#rsNomina.RCNid#">
                    </cfinvoke>
                </cfloop>
                <cfinvoke component="rh.Componentes.RH_PTU" method="fnBajaEPTU"> 
                    <cfinvokeargument name="RHPTUEid" 			value="#form.RHPTUEid#">
                </cfinvoke>
            </cftransaction>
    	</cfif>
  	<cfelseif esCerrarCalculo>
    	<cftransaction>
        	<cfloop list="#form.TcodigoList#" index="lvarTcodigo">
            	<cfset lvarFecha = LSParseDateTime(evaluate('#lvarTcodigo#'))>
                <cfinvoke component="rh.Componentes.CalendarioPago" method="AltaCalendarioPago" returnvariable="LvarCPid">
                    <cfinvokeargument name="CPdesde"		 value="#lvarFecha#">
                    <cfinvokeargument name="CPhasta"		 value="#lvarFecha#">
                    <cfinvokeargument name="CPfpago"		 value="#lvarFecha#">
                    <cfinvokeargument name="Tcodigo" 		 value="#trim(lvarTcodigo)#">
                    <cfinvokeargument name="CPtipo" 		 value="4">
                    <cfinvokeargument name="CPTipoCalRenta"  value="1">
                    <cfinvokeargument name="CPdescripcion"   value="PTU del #DatePart('YYYY',lvarFecha)#">
                    <cfinvokeargument name="CPnorenta"       value="0">
                    <cfinvokeargument name="CPnocargasley"   value="0">
                    <cfinvokeargument name="CPnocargas"      value="0">
                    <cfinvokeargument name="CPnodeducciones" value="1">
                    <cfinvokeargument name="EsPTU" 			 value="true">
                </cfinvoke>
                <cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="AltaRCalculoNomina">
                    <cfinvokeargument name="RCNid"		 	value="#LvarCPid#">
                    <cfinvokeargument name="RCDescripcion" 	value="PTU(#lvarTcodigo#) - #form.RHPTUEdescripcion#">
                    <cfinvokeargument name="RHPTUEid"		value="#form.RHPTUEid#">
                    <cfinvokeargument name="RCporcentaje"	value="0">
                </cfinvoke>
                <cfquery name="rsEmpleados" datasource="#session.DSN#">
                    select e.DEid, e.RHPTUEMTotalPTU, e.RHPTUEMISPTRetencionPTU, e.RHPTUEMNetaRecibir, cn.RChasta, eptu.CIid
                    from RHPTUEMpleados e
                    	inner join LineaTiempo lt
                        	on lt.DEid = e.DEid and e.FechaHasta >= lt.LTdesde and e.FechaHasta <= lt.LThasta
                    	inner join RCalculoNomina cn
                        	on cn.RHPTUEid = e.RHPTUEid
                    	inner join CalendarioPagos cp
                        	on cp.Ecodigo = lt.Ecodigo and cp.Tcodigo = lt.Tcodigo
                       	inner join RHPTUE eptu
                        	on eptu.RHPTUEid = e.RHPTUEid
                    where e.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">
                      and e.Ecodigo = #session.Ecodigo#
                      and e.RHPTUEMreconocido = 1
                      and cp.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPid#">
                      and cn.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPid#">
                      and cn.RCestado = 0
                      and cp.CPtipo = 4
                     and not exists ( select 1 from SalarioEmpleado i where i.DEid = e.DEid and i.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPid#">)
       			</cfquery>
                <cfloop query="rsEmpleados">
                    <cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="fnAltaSalarioEmpleado">
                        <cfinvokeargument name="RCNid"			value="#LvarCPid#">
                        <cfinvokeargument name="DEid" 			value="#rsEmpleados.DEid#">
                        <cfinvokeargument name="SEincidencias"	value="#rsEmpleados.RHPTUEMTotalPTU#">
                        <cfinvokeargument name="SErenta"		value="#rsEmpleados.RHPTUEMISPTRetencionPTU#">
                        <cfinvokeargument name="SEliquido"		value="#rsEmpleados.RHPTUEMNetaRecibir#">
                    </cfinvoke>
                    <cfinvoke component="rh.Componentes.RH_Incidencias" method="fnAltaIncidenciaCalculo">
                        <cfinvokeargument name="RCNid"			value="#LvarCPid#">
                        <cfinvokeargument name="DEid" 			value="#rsEmpleados.DEid#">
                        <cfinvokeargument name="CIid"			value="#rsEmpleados.CIid#">
                        <cfinvokeargument name="ICfecha"		value="#rsEmpleados.RChasta#">
                        <cfinvokeargument name="ICvalor"		value="#rsEmpleados.RHPTUEMNetaRecibir#">
                        <cfinvokeargument name="ICfechasis"		value="#now()#">
                        <cfinvokeargument name="Ulocalizacion"	value="00">
                        <cfinvokeargument name="ICmontoant"		value="0">
                        <cfinvokeargument name="ICmontores"		value="#rsEmpleados.RHPTUEMNetaRecibir#">
                    </cfinvoke>
                </cfloop>
                <cfinvoke component="rh.Componentes.RH_PTU" method="fnCerrarCalculoEPTU">
                    <cfinvokeargument name="RHPTUEid" 			value="#form.RHPTUEid#">
                </cfinvoke>
            </cfloop>
        </cftransaction>
    </cfif>
<cfelseif esDPTU>
	<cfset esAlta = isdefined('form.Alta')>
    <cfset esBaja = isdefined('form.Baja')>
    <cfset form.noSumbit = true>
    <cfif esAlta>
        <cfinvoke component="rh.Componentes.RH_PTU" method="fnExisteDPTU" returnvariable="existeFiltro">
        	<cfinvokeargument name="RHPTUEid" 			value="#form.RHPTUEid#">
            <cfif isdefined('form.DEid')>
                <cfinvokeargument name="DEid" 			value="#form.DEid#">
            </cfif>
            <cfif isdefined('form.RHPcodigo')>
                <cfinvokeargument name="RHPcodigo" 			value="#form.RHPcodigo#">
            </cfif>
            <cfif isdefined('form.Dcodigo')>
                <cfinvokeargument name="Dcodigo" 			value="#form.Dcodigo#">
            </cfif>
            <cfif isdefined('form.Ocodigo')>
                <cfinvokeargument name="Ocodigo" 			value="#form.Ocodigo#">
            </cfif>
            <cfif isdefined('form.CFid')>
                <cfinvokeargument name="CFid" 			value="#form.CFid#">
            </cfif>
            <cfif isdefined('form.RHTPid')>
                <cfinvokeargument name="RHTPid" 			value="#form.RHTPid#">
            </cfif>
            <cfif isdefined('form.Tcodigo') and len(trim(form.Tcodigo))>
                <cfinvokeargument name="Tcodigo" 			value="#form.Tcodigo#">
            </cfif>
        </cfinvoke>
        <cfif not existeFiltro>
            <cftransaction>
                <cfinvoke component="rh.Componentes.RH_PTU" method="fnAltaDPTU">
                    <cfinvokeargument name="RHPTUEid" 			value="#form.RHPTUEid#">
                    <cfif isdefined('form.DEid')>
                        <cfinvokeargument name="DEid" 			value="#form.DEid#">
                    </cfif>
                    <cfif isdefined('form.RHPcodigo')>
                        <cfinvokeargument name="RHPcodigo" 			value="#form.RHPcodigo#">
                    </cfif>
                    <cfif isdefined('form.Dcodigo')>
                        <cfinvokeargument name="Dcodigo" 			value="#form.Dcodigo#">
                    </cfif>
                    <cfif isdefined('form.Ocodigo')>
                        <cfinvokeargument name="Ocodigo" 			value="#form.Ocodigo#">
                    </cfif>
                    <cfif isdefined('form.CFid')>
                        <cfinvokeargument name="CFid" 			value="#form.CFid#">
                    </cfif>
                    <cfif isdefined('form.RHTPid')>
                        <cfinvokeargument name="RHTPid" 			value="#form.RHTPid#">
                    </cfif>
                    <cfif isdefined('form.Fcorte')>
                        <cfinvokeargument name="Fcorte" 			value="#LSParseDateTime(form.Fcorte)#">
                    </cfif>
                    <cfif isdefined('form.Tcodigo') and len(trim(form.Tcodigo))>
                        <cfinvokeargument name="Tcodigo" 			value="#form.Tcodigo#">
                    </cfif>
                </cfinvoke>
                <cfif isdefined("Form.dependencia") >
                    <cfquery name="rsPathCF" datasource="#Session.DSN#">
                        select CFpath
                        from CFuncional
                        where Ecodigo = #session.Ecodigo#
                        and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
                    </cfquery>
                    <cfquery name="rsCFs" datasource="#Session.DSN#">
                        select CFid
                            from CFuncional
                            where Ecodigo = #session.Ecodigo#
                            and CFpath like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(rsPathCF.CFpath)#/%">
                            and not exists (
                                select 1
                                from RHPTUD x
                                where x.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
                                and x.CFid = CFuncional.CFid
                                and(exists (select 1 
                                        from LineaTiempo lts 
                                         where lts.DEid = c.DEid 
                                         and (lts.LTdesde between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fcorte)#"> and '61000101'
                                         or lts.LThasta between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fcorte)#"> and '61000101')
                                         and lts.Tcodigo = b.Tcodigo
                                ) or b.Tcodigo is null)
                            )
                    </cfquery>
                    <cfloop query="rsCFs">
                        <cfinvoke component="rh.Componentes.RH_PTU" method="fnAltaDPTU">
                            <cfinvokeargument name="RHPTUEid" 		value="#form.RHPTUEid#">
                            <cfinvokeargument name="CFid" 			value="#rsCFs.CFid#">
                            <cfinvokeargument name="Fcorte" 		value="#LSParseDateTime(form.Fcorte)#">
                            <cfif isdefined('form.Tcodigo') and len(trim(form.Tcodigo))>
                                <cfinvokeargument name="Tcodigo" 			value="#form.Tcodigo#">
                            </cfif>
                        </cfinvoke>
                    </cfloop>
                </cfif>
                <cfinvoke component="rh.Componentes.RH_PTU" method="generarEmpleados" returnvariable="LvarResult">
                    <cfinvokeargument name="RHPTUEid" value="#Form.RHPTUEid#"/>
                    <cfinvokeargument name="validaTcodigo" value="true"/>
                    <cfinvokeargument name="TransaccionActiva" value="true"/>
                </cfinvoke>
                <cfinvoke component="rh.Componentes.RH_PTU" method="CalculoPTU" returnvariable="LvarResult">
                    <cfinvokeargument name="RHPTUEid" value="#Form.RHPTUEid#"/>
                </cfinvoke>
            </cftransaction>
        </cfif>
   	<cfelseif esBaja>
    	<cftransaction>
            <cfinvoke component="rh.Componentes.RH_PTU" method="fnBajaDPTU">
                <cfinvokeargument name="RHPTUEid" 			value="#form.RHPTUEid#">
                <cfinvokeargument name="RHPTUDid" 			value="#form.RHPTUDid#">
            </cfinvoke>
            <cfinvoke component="rh.Componentes.RH_PTU" method="generarEmpleados" returnvariable="LvarResult">
                <cfinvokeargument name="RHPTUEid" value="#Form.RHPTUEid#"/>
                <cfinvokeargument name="validaTcodigo" value="true"/>
                <cfinvokeargument name="TransaccionActiva" value="true"/>
            </cfinvoke>
            <cfinvoke component="rh.Componentes.RH_PTU" method="CalculoPTU" returnvariable="LvarResult">
                <cfinvokeargument name="RHPTUEid" value="#Form.RHPTUEid#"/>
            </cfinvoke>
        </cftransaction>
    </cfif>
<cfelseif esDEPTU>
    <cfset esBaja = isdefined('form.Baja')>
    <cfset esReconocer = isdefined('form.Reconocer')>
    <cfset esRegenerar = isdefined('form.Regenerar')>
    <cfset form.noSumbit = true>
	<cfif esBaja>
    	<cftransaction>
            <cfinvoke component="rh.Componentes.RH_PTU" method="fnBajaDEPTU">
                <cfinvokeargument name="RHPTUEid" 			value="#form.RHPTUEid#">
                <cfinvokeargument name="RHPTUEMid" 			value="#form.RHPTUEMid#">
            </cfinvoke>
            <cfinvoke component="rh.Componentes.RH_PTU" method="CalculoPTU" returnvariable="LvarResult">
                <cfinvokeargument name="RHPTUEid" value="#Form.RHPTUEid#"/>
            </cfinvoke>
        </cftransaction>
   	<cfelseif esRegenerar>
    	<cftransaction>
            <cfinvoke component="rh.Componentes.RH_PTU" method="generarEmpleados" returnvariable="LvarResult">
                <cfinvokeargument name="RHPTUEid" value="#Form.RHPTUEid#"/>
                <cfinvokeargument name="validaTcodigo" value="true"/>
            </cfinvoke>
            <cfinvoke component="rh.Componentes.RH_PTU" method="CalculoPTU" returnvariable="LvarResult">
                <cfinvokeargument name="RHPTUEid" value="#Form.RHPTUEid#"/>
            </cfinvoke>
        </cftransaction>
  	<cfelseif esReconocer>
    	<cfinvoke component="rh.Componentes.RH_PTU" method="fnReconocerDEPTU" returnvariable="RHPTUEMid">
            <cfinvokeargument name="RHPTUEid" value="#Form.RHPTUEid#"/>
            <cfinvokeargument name="RHPTUEMid" value="#form.RHPTUEMid#"/>
            <cfif isdefined('form.RHPTUEMreconocido')>
                <cfinvokeargument name="RHPTUEMreconocido" value="0"/>
                <cfinvokeargument name="RHPTUEMjustificacion" value="No Aplica"/>
            </cfif>
        </cfinvoke>
    </cfif>
<cfelseif esIncMas>
	<cfset esAlta = isdefined('form.Alta')>
    <cfset esBaja = isdefined('form.Baja')>
    <cfset esCambio= isdefined('form.Cambio')>
    <cfset esAplicar= isdefined('form.Aplicar')>
    <cfif esAlta>
        <cfinvoke component="rh.Componentes.RH_Incidencias" method="fnAltaEIncidenciaMasiva" returnVariable="EIlote"> 
            <cfinvokeargument name="CIid" value="#Form.CIid#">
            <cfinvokeargument name="SNcodigo" value="#form.SNcodigo#">
            <cfinvokeargument name="Tcodigo" value="#trim(form.Tcodigo)#">
            <cfinvokeargument name="EIdescripcion" value="#form.EIdescripcion#">
             <cfinvokeargument name="Edescripcion" value="#form.EIdescripcion#">
        </cfinvoke>
   	<cfelseif esCambio>
        <cfinvoke component="rh.Componentes.RH_Incidencias" method="fnCambioEIncidenciaMasiva" returnVariable="EIlote"> 
            <cfinvokeargument name="EIlote" value="#Form.EIlote#">
            <cfinvokeargument name="CIid" value="#Form.CIid#">
            <cfinvokeargument name="SNcodigo" value="#form.SNcodigo#">
            <cfinvokeargument name="Tcodigo" value="#trim(form.Tcodigo)#">
            <cfinvokeargument name="EIdescripcion" value="#form.EIdescripcion#">
            <cfinvokeargument name="Edescripcion" value="#form.EIdescripcion#">
        </cfinvoke>
   	<cfelseif esBaja>
    	<cfset form.noSumbit = true>
    	<cftransaction>
        	<cfinvoke component="rh.Componentes.RH_Incidencias" method="Baja" EIlote="#Form.EIlote#"/>
            <cfinvoke component="rh.Componentes.RH_Incidencias" method="fnBajaEIncidenciaMasiva"> 
                <cfinvokeargument name="EIlote" value="#Form.EIlote#">
            </cfinvoke>
            <cfinvoke component="rh.Componentes.RH_Incidencias" method="Baja">
            	<cfinvokeargument name="EIlote" value="#Form.EIlote#">
            </cfinvoke>
        </cftransaction>
  	<cfelseif esAplicar>
    	<cfset form.noSumbit = true>
    	<cfinvoke component="rh.Componentes.RH_Incidencias" method="fnAplicarEIncidenciaMasiva"> 
            <cfinvokeargument name="EIlote" value="#Form.EIlote#">
        </cfinvoke>
   </cfif>
<cfelseif esIncMasD>
	<cfset esAlta = isdefined('form.Alta')>
    <cfset esBaja = isdefined('form.Baja')>
    <cfset esCambio= isdefined('form.Cambio')>
    <cfset esCambioM= isdefined('form.CambioM')>
    <cfif not esBaja>
    	<cfquery name="rsDatosConcepto" datasource="#session.dsn#">
			select 	coalesce(b.CItipo,'m') as CItipo, b.CIdia, b.CImes, b.CIcalculo, coalesce(b.CIcantidad,0) as CIcantidad,
					coalesce(b.CIrango,0) as CIrango, coalesce(b.CIspcantidad,0) as CIspcantidad, coalesce(b.CIsprango,0) as CIsprango
			from CIncidentes a
				left outer join CIncidentesD b
					on a.CIid = b.CIid
			where a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.dCIid#">
				and a.CItipo = 3
		</cfquery>
        <cfif rsDatosConcepto.RecordCount NEQ 0>
			<!---LLAMAR CALCULADORA PARA OBTENER EL Imonto----->
			<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")><!----Para utilizar la calculadora--->
			<cfset current_formulas = rsDatosConcepto.CIcalculo>
			<cfset presets_text = RH_Calculadora.get_presets(LSParseDateTime(Form.Ifecha),<!---fecha1_accion--->
										   LSParseDateTime(Form.Ifecha),<!---fecha2_accion--->
										   rsDatosConcepto.CIcantidad,<!---CIcantidad--->
										   rsDatosConcepto.CIrango, <!---CIrango--->
										   rsDatosConcepto.CItipo, <!---CItipo--->
										   rsDatosConcepto.DEid,	<!---DEid--->
										   0, <!---RHJid--->
										   session.Ecodigo, <!---Ecodigo--->
										   0, <!---RHTid--->
										   0, <!---RHAlinea--->																		   
										   rsDatosConcepto.CIdia, <!---CIdia--->
										   rsDatosConcepto.CImes,<!---CImes--->
										   0,<!---Tcodigo--->
										   FindNoCase('SalarioPromedio', current_formulas), <!---calc_promedio--->
										   'false', <!---masivo--->
										   '', <!---tabla_temporal--->
										   0,<!---calc_diasnomina--->
										   Form.Ivalor
										   , '' 
										   ,rsDatosConcepto.CIsprango
										   ,rsDatosConcepto.CIspcantidad
										   )>
										   
			<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
			<cfif Not IsDefined("values") or not isdefined("presets_text")>												
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_NoEsPosibleRealizarElCalculo"
					Default="No es posible realizar el c&aacute;lculo"
					XmlFile="/rh/generales.xml"
					returnvariable="LB_NoEsPosibleRealizarElCalculo"/>
				<cf_throw message="#LB_NoEsPosibleRealizarElCalculo#" errorCode="1000">
			</cfif>
			<cfset iMonto = values.get('resultado').toString()>
			<!----------------- Fin de calculadora ------------------->		
		</cfif>	
    </cfif>
    <cfif esAlta>
    	<cf_dbfunction name="now" returnvariable="lvarHoy">
        <cfquery name="rsEmpleados" datasource="#session.dsn#">
            select distinct de.DEid
            from LineaTiempo lt
                <cfif form.filtroTipo eq 2>
                    <cfif form.subFiltro eq 1>	
                    inner join RHPlazas p
                        on p.RHPid = lt.RHPid and p.Ecodigo = lt.Ecodigo and p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.subFiltroCF#">
                    <cfelseif form.subFiltro eq 3>			
                    inner join RHPlazas p
                        on p.RHPid = lt.RHPid and p.Ecodigo = lt.Ecodigo and p.RHPpuesto = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.subFiltroP)#">
                    </cfif>
                </cfif>
                inner join DatosEmpleado de
                    on de.DEid = lt.DEid
            where lt.Ecodigo = #session.Ecodigo#
              <cfif form.filtroTipo eq 2>
                <cfif form.subFiltro eq 2>
                    and lt.Dcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.subFiltroD#">
                    and lt.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.subFiltroO#">
                </cfif>
                and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.filtroFecha)#"> between lt.LTdesde and lt.LThasta
              </cfif>
              <cfif form.filtroTipo eq 3>
              and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.filtroEmpleado#">
              </cfif>
              and not exists (select 1
                            from EIncidencias ei
                                inner join Incidencias i
                                    on i.EIlote = ei.EIlote
                            where ei.EIlote = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#form.EIlote#"> 
                              and ei.Ecodigo = #session.Ecodigo#
                              and i.DEid = lt.DEid)	
              and exists (select 1 
                          from LineaTiempo lts 
                          where lts.DEid = lt.DEid and (lts.LTdesde between #lvarHoy# and '61000101' or lts.LThasta between #lvarHoy# and '61000101')
                            and lts.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Tcodigo)#">)
        </cfquery>
    	<cftransaction>
            <cfloop query="rsEmpleados">
            	<cfinvoke component="rh.Componentes.RH_Incidencias"  method="Alta" returnVariable="Iid">
                	<cfinvokeargument name="DEid" value="#rsEmpleados.DEid#">
                    <cfinvokeargument name="CIid" value="#Form.dCIid#">
                    <cfinvokeargument name="iFecha" value="#LSParseDateTime(Form.iFecha)#">
                    <cfinvokeargument name="iValor" value="#replace(Form.iValor,',','','ALL')#">
                    <cfinvokeargument name="EIlote" value="#form.EIlote#">
                    <cfif rsDatosConcepto.RecordCount NEQ 0>
                    	<cfinvokeargument name="Imonto" value="#iMonto#">
                    </cfif>
                    <cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0>
                        <cfinvokeargument name="CFid" value="#Form.CFid#">
                    </cfif>
                    <cfif isdefined("form.RHJid") and len(trim(form.RHJid)) gt 0>
                        <cfinvokeargument name="RHJid" value="#Form.RHJid#">
                    </cfif>
                    <cfif isdefined("form.Icpespecial") and len(trim(form.Icpespecial)) NEQ 0 and form.Icpespecial EQ 'on'>
                        <cfinvokeargument name="Icpespecial" value="1">		
                        <cfif isdefined("form.IfechaRebajo")and len(trim(form.IfechaRebajo)) >
                            <cfinvokeargument name="IfechaRebajo" value="#LSParseDateTime(form.IfechaRebajo)#">
                        </cfif>
                    </cfif>
                </cfinvoke>
            </cfloop>
        </cftransaction>
   	<cfelseif esCambio>
    	<cftransaction>
        	<cfinvoke component="rh.Componentes.RH_Incidencias"  method="Cambio" returnVariable="Iid">
            	<cfinvokeargument name="Iid" 	value="#form.Iid#">
                <cfinvokeargument name="DEid" 	value="#form.filtroEmpleado#">
                <cfinvokeargument name="CIid" 	value="#Form.dCIid#">
                <cfinvokeargument name="iFecha" value="#LSParseDateTime(Form.iFecha)#">
                <cfinvokeargument name="iValor" value="#replace(Form.iValor,',','','ALL')#">
                <cfinvokeargument name="EIlote" value="#form.EIlote#">
                <cfif rsDatosConcepto.RecordCount NEQ 0>
                    <cfinvokeargument name="Imonto" value="#iMonto#">
                </cfif>
                <cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0>
                    <cfinvokeargument name="CFid" value="#Form.CFid#">
                </cfif>
                <cfif isdefined("form.RHJid") and len(trim(form.RHJid)) gt 0>
                    <cfinvokeargument name="RHJid" value="#Form.RHJid#">
                </cfif>
                <cfif isdefined("form.Icpespecial") and form.Icpespecial EQ 'on' >
                    <cfinvokeargument name="Icpespecial" value="1">		
                    <cfif isdefined("form.IfechaRebajo") >
                        <cfinvokeargument name="IfechaRebajo" value="#form.IfechaRebajo#">
                    </cfif>
               <cfelse>
                        <cfinvokeargument name="Icpespecial" value="0">		
                </cfif>
            </cfinvoke>
        </cftransaction>
   	<cfelseif esCambioM>
    	<cftransaction>
        	<cfinvoke component="rh.Componentes.RH_Incidencias"  method="fnCambioDIncidenciaMasivaMonto" returnVariable="Iid">
                <cfinvokeargument name="Iid" value="#form.Iid#">
                <cfinvokeargument name="iValor" value="#replace(Form.iValor,',','','ALL')#">
                <cfif rsDatosConcepto.RecordCount NEQ 0>
                    <cfinvokeargument name="Imonto" value="#iMonto#">
                </cfif>
            </cfinvoke>
        </cftransaction>
 	<cfelseif esBaja>
    	<cfinvoke component="rh.Componentes.RH_Incidencias" method="Baja" Iid="#Form.Iid#"/>
   </cfif>
</cfif>
<cfif not isdefined('form.noSumbit')>
	<cfoutput>
	<cfif (isdefined('form.DEid') and LEN(TRIM(form.DEid))) and (isdefined('form.RCNid') and LEN(TRIM(form.RCNid)))>
        <form name="form1" method="post" action="EmpleadosNomina.cfm">
    <cfelseif NOT (isdefined('form.DEid') and LEN(TRIM(form.DEid))) and (isdefined('form.RCNid') and LEN(TRIM(form.RCNid)))>
        <form name="form1" method="post" action="EmpleadosNomina.cfm">
   <cfelseif esAccionMasiva>
   		<form name="form1" action="windowsVacaciones.cfm" method="post">
    <cfelseif esDeducMas or esDeducMasD>
    	<form name="form1" action="windowsDeducMasivas.cfm" method="post">
   	<cfelseif esEPTU>
    	<form name="form1" action="windowsPTU.cfm" method="post">
    <cfelseif esIncMas or esIncMasD>
    	<form name="form1" action="windowsIncMasivas.cfm" method="post">
    <cfelse>
        <form name="form1" method="post" action="index.cfm">
    </cfif>
        <cfif isdefined('form.DEid')>   <input type="hidden" name="DEid" id="DEid" value="#form.DEid#"/></cfif>
        <cfif isdefined('form.Tcodigo') and ((esPRG and not esBaja) or esNomina or esAccionMasiva or esDeducMas or esDeducMasD or esIncMas or esIncMasD)><input type="hidden" name="Tcodigo" id="Tcodigo" value="#form.Tcodigo#"/> </cfif>
        <cfif isdefined('form.RCNid')>  <input type="hidden" name="RCNid" id="RCNid" value="#form.RCNid#"/> </cfif>
        <cfif isdefined('cerrarNotas')><input type="hidden" name="cerrarNotas" id="cerrarNotas" value="true" /></cfif>
        <cfif isdefined('cerrarLightBox')><input type="hidden" name="cerrarLightBox" id="cerrarLightBox" value="true" /></cfif>
        <cfif isdefined('EIDlote') and ((not esBaja and not esDeducMas) or esDeducMasD)>  <input type="hidden" name="EIDlote" id="EIDlote" value="#EIDlote#"/> </cfif>
    	<cfif isdefined('RHPTUEid') and (not esBaja)><input type="hidden" name="RHPTUEid" id="RHPTUEid" value="#RHPTUEid#"/> </cfif>
        <cfif isdefined('EIlote') and (not esBaja and not esIncMasD)><input type="hidden" name="EIlote" id="EIlote" value="#EIlote#"/> </cfif>
    </form>
    </cfoutput>
    <script type="text/javascript">
        document.form1.submit();
    </script>
<cfelse>
	<cfif isdefined('cerrarNotas')>
        <script type="text/javascript">
            window.parent.fnCerrarToolTip_3();
        </script>
    </cfif>
    <cfif isdefined('cerrarLightBox')>
        <script type="text/javascript">
            window.parent.fnLightBoxClose_Vacaciones();
        </script>
    </cfif>
    <cfif esInc or esDeduc>
    	<cfif isdefined('form.return')>
        	<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="GetResumenCalculoNomina" returnvariable="rsResumenNomina">
                <cfinvokeargument name="RCNid" value="#form.RCNid#">
                <cfinvokeargument name="DEid"  value="#form.DEid#">
            </cfinvoke>
            <cfoutput>#LSNumberFormat(evaluate("rsResumenNomina.#form.return#"),9.99)#</cfoutput>
        <cfelse>
			<script type="text/javascript">
                window.parent.fnLightBoxClose_Incidencias();
				<!---window.parent.fnCerrarToolTip_1();--->
				window.parent.document.fmEmpleadoNomina.action = "EmpleadosNomina.cfm";
				window.parent.document.fmEmpleadoNomina.DEid.value = "<cfoutput>#form.DEid#</cfoutput>";
				window.parent.document.fmEmpleadoNomina.RCNid.value = "<cfoutput>#form.RCNid#</cfoutput>";
				window.parent.document.fmEmpleadoNomina.submit();
            </script>
        </cfif>
    </cfif>
    <cfif esInc_PRG>
    	<script type="text/javascript">
			<!---window.parent.fnCerrarToolTip_1();--->
			window.parent.fnGridReload7();
			window.parent.fnLightBoxClose_Incidencia();
		</script>
    </cfif>
    <cfif esCompEmp>
    	<script type="text/javascript">
			window.parent.fnLightBoxClose_Componente();
			window.parent.fnCerrarToolTip_1();
			if('<cfoutput>#form.lugar#</cfoutput>'=='Nomina'){
				window.parent.fnGridReload8();
			}
			else{
				 window.parent.document.location.reload();		
			}
		</script>
    </cfif>
    <cfif esPRG>
    	<cfif esAlta>
			<script type="text/javascript">
                window.parent.fnLightBoxClose_GrupoNomina();
                if(window.parent.fnClickNomina)
                    window.parent.fnClickNomina("<cfoutput>#form.Tcodigo#</cfoutput>");
            </script>
         <cfelseif esCambio>
              <form name="form1" method="post" action="EmpleadosNomina.cfm">
              <input type="text" value="<cfoutput>#form.Tcodigo#</cfoutput>">
              <form>
            <cflocation addtoken="no" url="/cfmx/rh/Cloud/Nomina/index.cfm?Tcodigo=#form.Tcodigo#">
          <cfelse>
    		<cflocation addtoken="no" url="/cfmx/rh/Cloud/Nomina/index.cfm">
        </cfif>
    </cfif>
    <cfif esDeducMasD>
    	OK
   	</cfif>
   	<cfif esDeducMas and esAplicar>
    	<script type="text/javascript">
			window.parent.fnLightBoxClose_DeducMasivas();
		</script>
    </cfif>
    <cfif esEPTU>
    	<script type="text/javascript">
			window.parent.fnLightBoxClose_PTU();
		</script>
    </cfif>
    <cfif esDPTU>
    	OK
    </cfif>
    <cfif esDEPTU>
    	OK
    </cfif>
    <cfif esIncMas>
    	<script type="text/javascript">
			window.parent.fnLightBoxClose_IncMasivas();
		</script>
    </cfif>
     <cfif esIncMasD>
    	OK
    </cfif>
</cfif>


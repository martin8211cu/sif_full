<cfcomponent>
	    
    <cfset GvarUsuario = #session.Usulogin#>
    <cfset GvarConexion = #session.Dsn#>
    
    <cffunction name="invoka718" access="public" >
		<cfargument name="Ecodigo" 		required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="ETnumero"		required="no" type="numeric" >
		<cfargument name="FCid" 		required="no" type="numeric" >
		<cfargument name="Ddocumento"	required="no" type="string" >
		<cfargument name="CCTcodigo" 	required="no" type="string" >
        
        
		<cfquery name="rsVerificaAgencia" datasource="#GvarConexion#" maxrows="500">
            select  <!---(select AliasRol from  RolEmpleadoSNegocios sa where  sa.SNcodigo = a.SNcodigoAgencia and sa.Ecodigo = a.Ecodigo) as AliasRol  --->
            SNcodigoAgencia
            from Documentos a
            where a.Ecodigo = #arguments.Ecodigo#
            <cfif isdefined('arguments.ETnumero') and len(trim(#arguments.ETnumero#))> 
            	and a.ETnumero = #arguments.ETnumero#
            	and a.FCid = #arguments.FCid#
            <cfelse>
            	and a.Ddocumento = '#arguments.Ddocumento#'
            	and a.CCTcodigo = '#arguments.CCTcodigo#'
            </cfif>      
        </cfquery>
        
        <cfif len(trim(#rsVerificaAgencia.SNcodigoAgencia#)) eq 0>
        
            <cfquery name="rsSNcodigo" datasource="#GvarConexion#" maxrows="500">
                select SNcodigo   
                from  RolEmpleadoSNegocios 
                    where  AliasRol = 'N/A'
                    and Ecodigo = #arguments.Ecodigo#
            </cfquery>
            
            <cfif len(trim(#rsSNcodigo.SNcodigo#)) eq 0>
            	<cfreturn>
            	<!---<cfthrow message="No esta definida la agencia Generica en Rol empleado  con alias N/A en la empresa">--->
            </cfif>
                            
            <cfquery datasource="#GvarConexion#">
                update Documentos  
                set SNcodigoAgencia = #rsSNcodigo.SNcodigo#
                where Ecodigo = #arguments.Ecodigo#
                <cfif isdefined('arguments.ETnumero') and len(trim(#arguments.ETnumero#))> 
                    and ETnumero = #arguments.ETnumero#
                    and FCid = #arguments.FCid#
                <cfelse>
                    and Ddocumento = '#arguments.Ddocumento#'
                    and CCTcodigo = '#arguments.CCTcodigo#'
                </cfif>      
            </cfquery>
            
            <cfquery datasource="#GvarConexion#">
                update HDocumentos  
                set SNcodigoAgencia = #rsSNcodigo.SNcodigo#
                where Ecodigo = #arguments.Ecodigo#
                <cfif isdefined('arguments.ETnumero') and len(trim(#arguments.ETnumero#))> 
                    and ETnumero = #arguments.ETnumero#
                    and FCid = #arguments.FCid#
                <cfelse>
                    and Ddocumento = '#arguments.Ddocumento#'
                    and CCTcodigo = '#arguments.CCTcodigo#'
                </cfif>      
            </cfquery>
        	
        </cfif> 
        
        <cfquery name="readInterfaz718" datasource="#GvarConexion#" maxrows="500">
            select   a.Ecodigo, a.CCTcodigo, a.Ddocumento, b.Miso4217 , a.Dfecha,a.SNcodigo,
            coalesce((select AliasRol from  RolEmpleadoSNegocios sa where  sa.SNcodigo = a.SNcodigoAgencia and sa.Ecodigo = a.Ecodigo),'') as AliasRol, 
            (select sum(DDtotal) from DDocumentos dd where dd.CCTcodigo =a.CCTcodigo and dd.Ddocumento = a.Ddocumento 
                and b.Ecodigo = a.Ecodigo)  as Subtotal,Dtotal as Total , Dvencimiento, SNcodigoext, a.ETnumero,a.FCid, null as FAM01COD, null as FAX01NTR, 
            case when d.CCTvencim = -1 then 'S' else 'N' end as  IndContado 
          
            from Documentos a
            inner join Monedas b 
                on a.Ecodigo = b.Ecodigo
                and a.Mcodigo=b.Mcodigo
            inner join SNegocios c
                on c.SNcodigo =a.SNcodigo
                and c.Ecodigo = a.Ecodigo
            inner join CCTransacciones d
            	on d.CCTcodigo = a.CCTcodigo
                and d.Ecodigo = a.Ecodigo    
            where a.Ecodigo = #arguments.Ecodigo#
            <cfif isdefined('arguments.ETnumero') and len(trim(#arguments.ETnumero#))> 
            	and a.ETnumero = #arguments.ETnumero#
            	and a.FCid = #arguments.FCid#
            <cfelse>
            	and a.Ddocumento = '#arguments.Ddocumento#'
            	and a.CCTcodigo = '#arguments.CCTcodigo#'
            </cfif>      
        </cfquery>
        
        <cfif readInterfaz718.recordCount GT 0>
            <!--- Invoca Componente de Procesamiento de Interfaz 718. --->
            <cfinvoke component="interfacesSoin.Componentes.COM_EnvioDatos" method="process" returnvariable="MSG" 
            query="#readInterfaz718#"  Interfaz="false" TranActiva ="yes" />
        <cfelse>
        	<cfthrow message="la informacion que se envio no va a comisionar error en COM_Invocaciones, favor revisar con Soin">
        </cfif>

	</cffunction>
    
    
    <cffunction name="invoka719" access="public" >
		<cfargument name="Conexion" 		required="no" type="string"  default="#Session.Dsn#">
		<cfargument name="Ecodigo" 			required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="ETnumero"			required="no" type="numeric" >
		<cfargument name="FCid" 			required="no" type="numeric" >
		<cfargument name="Ddocumento"		required="no" type="string" >
		<cfargument name="CCTcodigo" 		required="no" type="string" >
		<cfargument name="Dfechaexpedido" 	required="no" type="date" >
		<cfargument name="PtipoSN" 			required="no" type="string">
		<cfargument name="Pcodigo"			required="no" type="string" >
		<cfargument name="CCTcodigoE" 		required="no" type="string" >
        <cfargument name="ValidaFPago"      required="no" type="boolean" >
		<cfargument name="Debug" 		    required="no" type="boolean" default="false">
        
        <cfquery name="readInterfaz719" datasource="#GvarConexion#" maxrows="500">
            select   a.Ecodigo, a.CCTcodigo, a.Ddocumento, b.Miso4217 , a.Dfecha,
             Dvencimiento, a.ETnumero,a.FCid, c.SNcodigo, c.SNnumero ,         
             'S' as IndComVol,'S' as IndComVolR,'S' as IndComVolRE,
             'S' as IndComPP , 'S' as IndComPPC , 
             'S' as IndComAge,
             'R' as Estado, Dtotal as MontoAbono , 'ParaOlla' as invokadoDesde 
             <cfif isdefined ('arguments.Dfechaexpedido') and len(trim(#arguments.Dfechaexpedido#))>
             	,'#arguments.Dfechaexpedido#' as Dfechaexpedido
             </cfif>
             <cfif isdefined ('arguments.Pcodigo') and len(trim(#arguments.Pcodigo#))>
             	,'#arguments.Pcodigo#' as Pcodigo
             </cfif>
             <cfif isdefined ('arguments.CCTcodigoE') and len(trim(#arguments.CCTcodigoE#))>
             	,'#arguments.CCTcodigoE#' as CCTcodigoE
             </cfif>
             <cfif isdefined ('arguments.PtipoSN') and len(trim(#arguments.PtipoSN#))>
             	,'#arguments.PtipoSN#' as PtipoSN
             </cfif>
             
             <cfif isdefined ('arguments.ValidaFPago') and len(trim(#arguments.ValidaFPago#))>
             	,'#arguments.ValidaFPago#' as ValidaFPago
             </cfif>
			 
          
            from HDocumentos a
            inner join Monedas b 
                on a.Ecodigo = b.Ecodigo
                and a.Mcodigo=b.Mcodigo
            inner join SNegocios c
                on c.SNcodigo =a.SNcodigo
                and c.Ecodigo = a.Ecodigo
            inner join CCTransacciones d
            	on d.CCTcodigo = a.CCTcodigo
                and d.Ecodigo = a.Ecodigo    
            where a.Ecodigo = #arguments.Ecodigo#
            <cfif isdefined('arguments.ETnumero') and len(trim(#arguments.ETnumero#))> 
            	and a.ETnumero = #arguments.ETnumero#
            	and a.FCid = #arguments.FCid#
            <cfelse>
            	and a.Ddocumento = '#arguments.Ddocumento#'
            	and a.CCTcodigo = '#arguments.CCTcodigo#'
            </cfif>      
        </cfquery>
        
         <cfif readInterfaz719.recordCount GT 0>
            <cfinvoke component="interfacesSoin.Componentes.COM_Calculo" method="process">
                <cfinvokeargument name="query" 	      value="#readInterfaz719#">   
                <cfinvokeargument name="TransActiva"  value="true">   
                <cfinvokeargument name="comVol" 	  value="false"> 
                <cfinvokeargument name="interfaz" 	  value="false">      
                <cfinvokeargument name="Debug" 	  	  value="#arguments.Debug#">                                                
            </cfinvoke>
        <cfelse>
        	<!---<cfthrow message="la informacion que se envio no va a realizar calculo error en COM_Invocaciones, favor revisar con Soin">--->
        </cfif>
                

	</cffunction>  



    <cffunction name="borraCOMCalculo" access="public" >
		<cfargument name="Conexion" 		required="no" type="string"  default="#Session.Dsn#">
		<cfargument name="Ecodigo" 			required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="ETnumero"			required="no" type="numeric" >
		<cfargument name="FCid" 			required="no" type="numeric" >
		<cfargument name="Ddocumento"		required="no" type="string" >
		<cfargument name="CCTcodigo" 		required="no" type="string" >
        
        <cfquery name="rsBorra" datasource="#GvarConexion#">
            select   co.COMEDid         
            from HDocumentos a
            inner join CCTransacciones d
            	on d.CCTcodigo = a.CCTcodigo
                and d.Ecodigo = a.Ecodigo    
            inner join COMEDocumentos ce
                on ce.Ddocumento =a.Ddocumento
            inner join COMCalculo co
                on co.COMEDid = ce.COMEDid     
            where a.Ecodigo = #arguments.Ecodigo#
            <cfif isdefined('arguments.ETnumero') and len(trim(#arguments.ETnumero#))> 
            	and a.ETnumero = #arguments.ETnumero#
            	and a.FCid = #arguments.FCid#
            <cfelse>
            	and a.Ddocumento = '#arguments.Ddocumento#'
            	and a.CCTcodigo = '#arguments.CCTcodigo#'
            </cfif>      

        </cfquery>
                
		<cfif rsBorra.recordcount gt 0>
            <cfquery datasource="#GvarConexion#">
                insert  into COMCalculo_Bit( 
                    Accion,COMEDid,RESNid,Estado,Mcodigo,
                    ProntoPago,ProntoPagoCliente,PorcentajePP,
                    VolumenGN,VolumenGLR,VolumenGLRE,
                    montoAgencia,Ecodigo,BMUsucodigo,fecha
                    )
                select
                    'Del func borraCOMCalculo',COMEDid,RESNid,Estado,Mcodigo,
                    ProntoPago,ProntoPagoCliente,PorcentajePP,
                    VolumenGN,VolumenGLR,VolumenGLRE,
                    montoAgencia,Ecodigo,#session.usucodigo#,#now()#
                from COMCalculo
                where Ecodigo = #arguments.Ecodigo#
                and COMEDid = #rsBorra.COMEDid#
            </cfquery>

            <cfquery datasource="#GvarConexion#">
                delete from COMCalculo 
                where Ecodigo = #arguments.Ecodigo#
                and COMEDid = #rsBorra.COMEDid#
            </cfquery>
           <!--- Se ponen los indicadores en 'S' para cuando 
           se corra el volumen al cierre de mes, no genere nada --->
           <cfquery datasource="#GvarConexion#">
            update  COMEDocumentos set 
              COMEindVVG   = 'S',
              COMEindCVG   = 'S',
              COMEindCAG   = 'S',
              COMEindCPPG  = 'S',
              COMEindCPPCG = 'S',
              COMEindCVREG = 'S',
              COMEindCVRG  = 'S',
              COMEindVVRG  = 'S',
              COMEindVVREG = 'S'
           where  Ecodigo  = #arguments.Ecodigo#
             and COMEDid   = #rsBorra.COMEDid#
            </cfquery>

        </cfif>

	</cffunction>  
    

</cfcomponent>

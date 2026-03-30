<cfoutput>Empieza</cfoutput><br>

<!--- Busca lote listo para procesar --->
<cfquery name="rsControl" datasource="#session.DSN#">
    select  
        qplc_id
	from QPListaControl
    where qplc_estado = 2
</cfquery>

<cfif rsControl.recordcount eq 1>
	<cftransaction action="begin">
		<!--- simula que el lote ya procesó todo del lado del HSBC y esta listo para ser procesado por SOIN --->
        <cfquery datasource="#session.DSN#">
            update QPListaControl
            set qplc_estado = 5,
            qplc_fecha_proceso1 = #now()#,
            qplc_fecha_proceso2 = #now()#
            where qplc_origen = 1
            and qplc_id = #rsControl.qplc_id#
        </cfquery>
        
        
        <!--- inserta los registros según los que tenga entrada --->
        <cfquery name="rsEntrada" datasource="#session.DSN#">
            select  
                qpldc_id,
                qplc_id,
                qpldc_tipo_mov,
                qpldc_ente,
                qpldc_identificacion,
                qpldc_cuenta,
                qpldc_fecha,
                qpldc_descripcion,
                qpldc_PAN,
                qpldc_Tag
            from QPListaEntrada
            where qplc_id = #rsControl.qplc_id#
        </cfquery>
    
        <cfloop query="rsEntrada">
            <cfset Lvarqpldc_id = rsEntrada.qpldc_id>
            <cfset Lvarqplc_id = rsEntrada.qplc_id>
            <cfset Lvarqpldc_tipo_mov = rsEntrada.qpldc_tipo_mov>
            <cfset Lvarqpldc_ente = rsEntrada.qpldc_ente>
            <cfset Lvarqpldc_identificacion = rsEntrada.qpldc_identificacion>
            <cfset Lvarqpldc_cuenta = rsEntrada.qpldc_cuenta>
            <cfset Lvarqpldc_fecha = rsEntrada.qpldc_fecha>
            <cfset Lvarqpldc_descripcion = rsEntrada.qpldc_descripcion>
            <cfset Lvarqpldc_PAN = rsEntrada.qpldc_PAN>
            <cfset Lvarqpldc_Tag = rsEntrada.qpldc_Tag>
            
            <cfif not len(trim(Lvarqpldc_ente))><cfset Lvarqpldc_ente = '1'></cfif>
            
            <!--- Dice en que color se va cada tag --->
            <cfif right(Lvarqpldc_PAN,1) eq 0><cfset LvarColor = 'B'></cfif>
            <cfif right(Lvarqpldc_PAN,1) GTE 1 and right(Lvarqpldc_PAN,1) LTE 6><cfset LvarColor = 'G'></cfif>
            <cfif right(Lvarqpldc_PAN,1) GTE 7><cfset LvarColor = 'N'></cfif>
            
            <cfquery datasource="#session.DSN#">
                insert into QPListaSalida 
                    (	
                   qpdlc_id,
                   qplc_id, 						  
                   qpdlc_tipo_mov, 			
                   qpdlc_ente, 					
                   qpdlc_cuenta, 				
                   qpdlc_fecha_consulta, 
                   qpdlc_cod_error, 		  
                   qpdlc_desc_cod_error, 
                   qpdlc_lista, 				  
                   qpdlc_estado, 				
                   qpdlc_PAN, 					  
                   qpdlc_Tag 					  
                   )
                   values(
                    #Lvarqpldc_id#,
                    #Lvarqplc_id#,
                    1,
                    #Lvarqpldc_ente#,
                    '#Lvarqpldc_cuenta#',
                    #now()#,
                    'V',
                    'Consulta realizada correctamente',
                    '#LvarColor#',
                    0,
                    '#Lvarqpldc_PAN#',
                    #Lvarqpldc_Tag#
                   )
            </cfquery>
        </cfloop>
        <cftransaction action="commit"/>
	</cftransaction>
</cfif>

<cfoutput>Termina</cfoutput>
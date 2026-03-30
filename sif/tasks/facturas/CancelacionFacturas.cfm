<cfsetting RequestTimeout = "3600">

<cflock  timeout="600">
    <cftry> 
        <cfquery datasource="asp" name="rscaches">
        select e.Ereferencia as Ecodigo, e.CEcodigo, c.Ccache, e.Eidentificacion
        from Empresa e
            join Caches c
            on e.Cid = c.Cid and e.Ereferencia is not null
        </cfquery>

        <cfloop query="rscaches">   
            <cftry>
                <cfquery datasource="#rscaches.ccache#" name="rsProv">
                    SELECT Pvalor
                    FROM Parametros 
                    WHERE Ecodigo = #rscaches.Ecodigo#
                    AND Pcodigo = '507'
                    AND Mcodigo = 'FA'
                </cfquery>
            <cfcatch type="any">
                <!--- En produccion se tiene un cache con una base que no existe, para clientes que no cuentan con sif --->
                <cfcontinue>
            </cfcatch>
            </cftry>
        
            <cfif rsProv.Pvalor eq "">
                <cfcontinue>
            </cfif>
            <cfif not isDefined('session.validaCanc')>
                <cfif not isDefined('session.usucodigo')>
                    <cfset session.usucodigo = "1">
                </cfif> 
                <cfif not isDefined('session.usuario') or "#session.usuario#" eq "">
                    <cfset session.usuario = "1">
                </cfif>    
                <cfif not isDefined('session.sitio.ip')>
                    <cfset session.sitio.ip = "127.0.0.1">
                </cfif>
                <cfset session.cecodigo = "#rscaches.CECODIGO#">
                <cfset session.Ecodigo = "#rscaches.Ecodigo#">
                <cfset session.dsn = "#rscaches.ccache#">
            </cfif>
			<!---Iniciamos componente para verificar con Konesh el estatus de la cancelación --->
			<cftransaction>
        		<cfinvoke component="sif.Componentes.FA_CancelacionFactura"
				method="EstatusCancelacionKonesh"	
				Ecodigo = "#session.Ecodigo#"
				usuario = "#session.usucodigo#"
                Conexion = "#session.dsn#"
				USA_tran = "true"
			/> 
        	</cftransaction>


   
        </cfloop>
    <cfcatch type="any">     
    <cfdump  var="ERROR: #cfcatch.message# #cfcatch.Detail#">   
        <cflog file="CFDI_Cancelacion"
            application="yes"
            text="Error: #cfcatch.message# #cfcatch.Detail#, #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">
    </cfcatch>
    </cftry>

            
    <cflog file="CFDI_Cancelacion"
        application="yes"
        text="Finalizando Cancelacion , #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">
    <cfif isDefined("resultadoJSON")>
        <cfdump  var="#resultadoJSON#">
    </cfif>
    
    <cfif isDefined("cfcatch.Detail")>
        <cfdump  var="#cfcatch.Detail#">
    </cfif>
    <cf_dump  var="Verifique el proceso Cola_Cancelacion de Factura en Facturacion/Procesos">
</cflock>


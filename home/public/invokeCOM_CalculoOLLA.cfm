<cfoutput>
INICIO de la invocacion COM_Calculo.<br />


<cfquery name="rsDatos" datasource="minisif_soin" maxrows="500">
	<!---QUERY PARA APLICACION DE DOCUMENTOS--->
	<!---select 
    
            (select sn.SNnumero 
					from SNegocios sn
                    where sn.Ecodigo = a.Ecodigo 
                        and sn.SNcodigo = a.SNcodigo
            ) as SNnumero,
            0 as MontoTotalComision,
            a.Ecodigo, a.CCTcodigo as CCTcodigo, a.Ddocumento as Ddocumento, 
            'S' as IndComVol,
            'S' as IndComAge, 
            'S' as IndComPP, 
            'P' as Estado,
            c.EFtotal as MontoAbono, 
            c.EFfecha as Dfechaexpedido
        from EFavor c
            inner join DFavor b
            on c.Ecodigo = b.Ecodigo
            and c.CCTcodigo = b.CCTcodigo
            and c.Ddocumento = b.Ddocumento
        
            inner join Documentos a
            on b.Ecodigo = a.Ecodigo
            and b.CCTRcodigo = a.CCTcodigo
            and b.DRdocumento = a.Ddocumento
        where c.Ecodigo  	  =  #session.Ecodigo# 
          and c.CCTcodigo  	  = 'RR'
          and c.Ddocumento 	  = 'RRacierto1'--->

	<!---QUERY PARA COBROS--->
	select 
    
<!---    (select sn.SNnumero 
            from Documentos d
            inner join SNegocios sn
                on sn.Ecodigo = d.Ecodigo 
                and sn.SNcodigo = d.SNcodigo

            where b.Ecodigo = d.Ecodigo
                and b.DRdocumento = d.Ddocumento
                and b.CCTRcodigo = d.CCTcodigo 
    ) as SNnumero,
    
        (
        select  sum( 
                      case when  VolumenGNCheck         = 1 then VolumenGN          else 0 end
                    + case when  VolumenGLRCheck        = 1 then VolumenGLR         else 0 end
                    + case when  VolumenGLRECheck       = 1 then VolumenGLRE        else 0 end
                    + case when  ProntoPagoCheck        = 1 then ProntoPago         else 0 end
                    + case when  ProntoPagoClienteCheck = 1 then ProntoPagoCliente  else 0 end
                    + case when  montoAgenciaCheck      = 1 then montoAgencia       else 0 end
                    )  
       from COMFacturas comf
       where comf.CCTcodigoE      = a.CCTcodigo
       and rtrim(comf.PcodigoE)   = a.Pcodigo
       and comf.CCTcodigoD        = b.CCTRcodigo
       and rtrim(comf.Ddocumento) = b.DRdocumento
       and comf.Ecodigo           = a.Ecodigo
        )as MontoTotalComision, --->

    a.Ecodigo, CCTRcodigo as CCTcodigo, a.Pcodigo,b.DRdocumento as Ddocumento, 'S' as IndComVol,
    'S' as IndComAge, 'S' as IndComPP, 'R' as Estado,Dtotal as MontoAbono, a.fechaExpedido as Dfechaexpedido, a.CCTcodigo as CCTcodigoE,PtipoSN
    ,fechaExpedido
       
        from HPagos a
            inner join BMovimientos b
                on b.Ecodigo = a.Ecodigo
                    and b.CCTcodigo = a.CCTcodigo
                    and b.Ddocumento  = a.Pcodigo
        
    where a.Pcodigo = '13782692'  <!---aqui el numero de factura--->
        order by DRdocumento desc
</cfquery>
<!---No procesadas
problemas con socio
360249, 362352,362353 


sin problema
360248, 362358, 360163-3 , 360246 ,362189

--->



<!---<cfloop query="rsDatos">
	 Procesando <cfoutput>#rsDatos.Nombre#</cfoutput><br />--->
	
   <cftransaction>

	<cfinvoke component="interfacesSoin.Componentes.COM_Invocaciones"  method="invoka719">
        <cfinvokeargument name="Ddocumento" 	value="#rsDatos.Ddocumento#">
        <cfinvokeargument name="CCTcodigo" 		value="#rsDatos.CCTcodigo#">
        <cfinvokeargument name="Ecodigo" 		value="#rsDatos.Ecodigo#">
        <cfinvokeargument name="Dfechaexpedido"	value="#rsDatos.fechaExpedido#">
        <cfinvokeargument name="PtipoSN"		value="#rsDatos.PtipoSN#">
        <cfinvokeargument name="Pcodigo"		value="#rsDatos.Pcodigo#">
        <cfinvokeargument name="CCTcodigoE"		value="#rsDatos.CCTcodigoE#">
    </cfinvoke>
                        
                        
                        
	</cftransaction>


FIN 
</cfoutput>

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
    
    (select sn.SNnumero 
            from Documentos d
            inner join SNegocios sn
                on sn.Ecodigo = d.Ecodigo 
                and sn.SNcodigo = d.SNcodigo

            where b.Ecodigo = d.Ecodigo
                and b.Ddocumento = d.Ddocumento
                and b.Doc_CCTcodigo = d.CCTcodigo 
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
       and comf.CCTcodigoD        = b.Doc_CCTcodigo
       and rtrim(comf.Ddocumento) = b.Ddocumento
       and comf.Ecodigo           = a.Ecodigo
        )as MontoTotalComision, 

    a.Ecodigo, Doc_CCTcodigo as CCTcodigo, b.Pcodigo,b.Ddocumento,    'S' as IndComVol,
    'S' as IndComAge, 'S' as IndComPP, 'R' as Estado,DPtotal as MontoAbono, a.fechaExpedido as Dfechaexpedido, a.CCTcodigo as CCTcodigoE
    	from Pagos a 
    	inner join DPagos b
        on a.Ecodigo = b.Ecodigo
        and a.CCTcodigo=b.CCTcodigo
        and a.Pcodigo= b.Pcodigo
    where a.Pcodigo = 'RE363001'  <!---aqui el numero de factura--->
  <!--- -- and b.Ddocumento = 'GNR57288'--->
</cfquery>


<!---<cfloop query="rsDatos">
	 Procesando <cfoutput>#rsDatos.Nombre#</cfoutput><br />--->
	
   <cftransaction>

        <cfinvoke component="interfacesSoin.Componentes.COM_Calculo" method="process" returnvariable="MSG" Debug="true" query="#rsDatos#" 
        interfaz="false" TransActiva="true"/>
    	
	</cftransaction>


FIN 
</cfoutput>

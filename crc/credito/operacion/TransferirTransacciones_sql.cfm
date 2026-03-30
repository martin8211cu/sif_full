<cfparam  name="form.PagadoNeto" default="0">
<cfset CRCTrantransferir = createObject("component","crc.Componentes.transacciones.CRCTransferir")>
<cfset CRCTrantransferir.init(session.dsn,session.ecodigo)>


<cftransaction>
    <cftry>
        <cfset CRCTrantransferir.AplicarTransferencia(Transaccion_id=form.tran_id,Monto=form.Monto,PagadoNeto=form.PagadoNeto,Cuenta_id=form.id)>
        <cftransaction action="commit">
    <!--- <cfcatch type="Database">
        <cftransaction action="rollback">        
        <cf_dump var="#cfcatch.sql#">
    </cfcatch> --->
    <cfcatch type="any">
        <cftransaction action="rollback">        
        <cfthrow message="#cfcatch.message#">
    </cfcatch>
    </cftry>
</cftransaction>




<cflocation url="TransferirTransacciones.cfm" addtoken="false">

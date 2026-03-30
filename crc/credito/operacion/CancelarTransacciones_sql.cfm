<cfparam  name="form.PagadoNeto" default="0">
<cfset CRCCancelar = createObject("component","crc.Componentes.transacciones.CRCCancelar")>
<cfset CRCCancelar.init(session.dsn,session.ecodigo)>


<cftransaction>
    <cftry>
        <cfset CRCCancelar.AplicarTransferencia(Transaccion_id=form.tran_id,Monto=form.Monto,PagadoNeto=form.PagadoNeto)>
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




<cflocation url="CancelarTransacciones.cfm" addtoken="false">

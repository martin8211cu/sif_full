<cfparam  name="form.PagadoNeto" default="0">
<cfset CRCCancelar = createObject("component","crc.Componentes.transacciones.CRCCancelar")>
<cfset CRCCancelar.init(session.dsn,session.ecodigo)>


<cftransaction>
    <cftry>
        <cfset CRCCancelar.CancelaPago(Transaccion_id=form.tran_id, debug="false")>
        <cftransaction action="commit">
    <cfcatch type="any">
        <cftransaction action="rollback"> 
        <cfrethrow>
        <cfthrow message="#cfcatch.message#">
    </cfcatch>
    </cftry>
</cftransaction>




<cflocation url="ReversaPago.cfm" addtoken="false">

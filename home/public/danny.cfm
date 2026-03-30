

<!--- Prueba de contabilizacion --->


<cftransaction action="begin">
    
    <cfinvoke component="sif.Componentes.FA_funciones" method="AplicarTransaccionFA">
      <cfinvokeargument name="ETnumero" value="1080">
      <cfinvokeargument name="FCid" value="61">
      <cfinvokeargument name="InvocarInterfaz718" value="true">
      <cfinvokeargument name="InvocarInterfaz719" value="true">
      <cfinvokeargument name="Contabilizar" value="conta">
    </cfinvoke>

<!--- 
    <cfquery name="rsID" datasource="#session.dsn#" maxrows="1">
      select max(IDcontable) as IDcontable from EContables
    </cfquery>
    <cfquery name="rsAsiento" datasource="#session.dsn#">
      select * from EContables where IDcontable = #rsID.IDcontable#
    </cfquery>
    <cfquery name="rsDAsiento" datasource="#session.dsn#">
      select * from DContables
      where IDcontable = #rsID.IDcontable#
    </cfquery>

    Encabezado: <cfdump var="#rsAsiento#">
    Detalles: <cfdump var="#rsDAsiento#">

    <cfdump var="Termino Correctamente">
    --->
</cftransaction>


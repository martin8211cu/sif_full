<cfquery name="rs_RPListaPolizaDesalmacenaje" datasource="#session.dsn#">
    select 
        e.EPDnumero as Numero_Poliza,
        e.EPDdescripcion as Descripcion_Poliza,
       case detalles.CMtipo 
            when 'A' then art.Acodigo 
            when 'S' then con.Ccodigo 
            end Codigo_Item,
       detalles.DPDdescripcion as Descripcion_Item,
        case detalles.CMtipo 
            when 'A' then 'Artíulo' 
            when 'S' then 'Servicio' 
            when 'F' then 'Activo' 
            end as Tipo_Linea,
       detalles.Ucodigo as CodigoUnidad,
       u.Udescripcion  as UnidadMedida,
       detalles.Icodigo as Codigo_Impuesto,
       Impuestos.Idescripcion as descripcion_Impuesto,
       codadu.CAdescripcion as CodigoAduanal,
       a.EOnumero as OrdenCompra,
       detalles.DPDpaisori as CodigoPaisOrigen,
       detalles.DPDpeso as Peso,
       detalles.DPDcantidad as Cantidad,
       detalles.DPDmontofobreal as FOB,
       detalles.DPseguropropio as SeguroPropio,
       detalles.DPDmontocifreal as CIF,
       detalles.DPDimpuestosrecup + detalles.DPDimpuestosreal  as Total_Impuestos,
       detalles.DPDimpuestosrecup as Impuesto_Recuperable,
       detalles.DPDvalordeclarado as CostoTotal,
       case detalles.DPDcantidad  
            when  0 then 0 
            else detalles.DPDvalordeclarado / detalles.DPDcantidad end as Costo_Unitario
                                                         
	from DPolizaDesalmacenaje detalles 
        LEFT OUTER JOIN EPolizaDesalmacenaje e on detalles.EPDid = e.EPDid 
        LEFT OUTER JOIN DOrdenCM a on detalles.DOlinea = a.DOlinea 
        LEFT OUTER JOIN CodigoAduanal codadu on detalles.CAid = codadu.CAid and detalles.Ecodigo = codadu.Ecodigo 
        LEFT OUTER JOIN Impuestos on detalles.Icodigo = Impuestos.Icodigo and detalles.Ecodigo = Impuestos.Ecodigo 
        LEFT OUTER JOIN Articulos art on detalles.Aid = art.Aid 
        LEFT OUTER JOIN Conceptos con on detalles.Cid = con.Cid 
        LEFT OUTER JOIN Unidades u on u.Ucodigo = detalles.Ucodigo and u.Ecodigo = detalles.Ecodigo
	where detalles.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    	 <cfif isdefined("form.EPDnumeroDesde") and  len(trim(form.EPDnumeroDesde))>
        	and EPDnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.EPDnumeroDesde#">
        </cfif>
       <cfif isdefined("form.EPDnumeroHasta") and  len(trim(form.EPDnumeroHasta))>
        	and EPDnumero >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.EPDnumeroHasta#">
        </cfif> 
</cfquery>
<!--- Formato Excel --->
<cfif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 3>
    <cfset formatos = "excel">
</cfif>
<cfif formatos eq "excel">
     <cf_QueryToFile query="#rs_RPListaPolizaDesalmacenaje#" FILENAME="ListaPolizasDesalmacenaje.xls" titulo="Lista de Polizas de Desalmacenaje">
<cfelse>
	<cfthrow message="No implementado">
</cfif>
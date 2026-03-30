<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfset Param = "">
<cfif isdefined('url.lista') and len(trim(url.lista)) gt 0>    
	<cfset Param = Param & "&lista="&url.lista>
    <cfset arr 	   = ListToArray(url.lista, ',', false)>
    <cfset LvarLen = ArrayLen(arr)>
    <cf_templatecss>
    <cf_rhimprime datos="/sif/cp/operacion/facturaTramite.cfm" paramsuri="#Param#">     
	<!--- Tramites que se requieren imprimir --->
    <cfquery name="rsEfactura" datasource="#session.dsn#">
        select 	
                IDdocumento,
                EDdocumento,
                EDfechaarribo,
                (select SNnombre from  SNegocios s where s.SNcodigo = d.SNcodigo and s.Ecodigo = #session.Ecodigo#) as Proveedor,
                (select Mnombre from  Monedas m  where m.Mcodigo = d.Mcodigo and m.Ecodigo = #session.Ecodigo#) as Moneda,
                EDtotal
        from EDocumentosCxP d
        where d.Ecodigo = #Session.Ecodigo#
            and d.IDdocumento in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.lista#" list="yes">)
    </cfquery>    
    <!--- Cantidad de paginas a utilizar --->
    <cfif rsEfactura.recordcount gt 0>
        <cfset Paginas =  Ceiling((rsEfactura.recordcount/10))>
    <cfelse>
        <cfset Paginas =  0> 
    </cfif>
    <!--- Encabezado --->
    <cffunction name="Encabezado" output="yes">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr><td colspan="2"></td></tr>
            <tr><td colspan="2">&nbsp;</td></tr>
            <tr><td height="30" colspan="2">&nbsp;</td></tr>
            <tr><td height="35" colspan="2">&nbsp;</td></tr>
            <tr><td height="35" colspan="2">&nbsp;</td></tr>
            <tr><td colspan="2">&nbsp;</td></tr>
            <tr><td colspan="2">&nbsp;</td></tr>
            <tr>
                <td colspan="2" width="30%">
                    <strong>&nbsp;&nbsp;Fecha:</strong>&nbsp;&nbsp;<cfoutput>#Dateformat(rsEfactura.EDfechaarribo,'dd/mm/YYYY')#</cfoutput>
                </td>            
            </tr>
            <tr>
                <td colspan="2" align="left">
                    <strong>&nbsp;&nbsp;Recibimos de:</strong>&nbsp;&nbsp;<cfoutput>#rsEfactura.Proveedor#</cfoutput>
                </td>          
            </tr>
            <tr><td colspan="2">&nbsp;</td></tr>
        </table>
    </cffunction>
    <!--- Encabezado de los detalles  --->
    <cffunction name="EncColumnas" output="yes">
     <table border="0" cellpadding="0" cellspacing="0" width="100%">  
         <tr>
              <td><strong>DOCUMENTO</strong></td>
              <td><strong>ORDEN COMPRA</strong></td>
              <td><strong>MONTO</strong></td>
              <td><strong>MONEDA</strong></td>          
         </tr>
    </cffunction>      
     <cfset LvarRestantes = "#abs(((rsEfactura.recordcount/10)-Paginas)*10)#"><!--- Restantes para mantener formato --->  
     <cfset starRow = 1>																					<!--- Inicio de las rutinas del query--->  	
     <cfset endRow = 0>
    <cfloop index="i" from="1" to="#Paginas#">
        <cfloop index="copia" from="1" to="2">
           <cfset Encabezado()>
           <cfset EncColumnas()>
           <cfif i eq 1>
                <cfset starRow = 1>
                <cfset endRow = 10>
           </cfif>
            <cfloop  query="rsEfactura" startrow="#starRow#" endrow="#endRow#">     
                  <cfset rslineas = queryOC(rsEfactura.IDdocumento)>
                  <cfset detalle = DetallesFactura(rslineas)>
            </cfloop>
            <cfif i eq Paginas and LvarRestantes neq 0><cfloop index="k" from="1" to="#LvarRestantes#"><tr><td colspan="4">&nbsp;</td></tr></cfloop></cfif>
            <cfif copia eq 2>
                <tr><td colspan="4">&nbsp;<div style="page-break-after: always;"></div></td></tr>		<!--- Salto de Pagina --->
            <cfelse>
                <tr><td colspan="4"  height="120"></td></tr>																<!--- Espacio entre cada copia--->
             </cfif>																
        </cfloop>
        <cfset starRow = endRow+1>
        <cfset endRow = starRow+10>
    </cfloop>
    </table>
    <!--- Funcion para calcular las OC del documento --->
    <cffunction name="queryOC" returntype="query" access="private">
        <cfargument name="IDdocumento"  type="numeric" required="yes">
        <cfquery name="rsLineas" datasource="#session.dsn#">
            select 
                coalesce(<cf_dbfunction name="to_char"	args="do.EOnumero">,'--') as NumeroOC
            from DDocumentosCxP a 
                left outer join CContables b
                    on a.Ccuenta = b.Ccuenta			  
                 left outer join DOrdenCM do
                    on a.DOlinea =  do.DOlinea
            where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDdocumento#">
                and a.Ecodigo=  #session.ecodigo#
            group by do.EOnumero	
        </cfquery>
        <cfreturn rsLineas>
    </cffunction>
    <!--- Funcion para imprimir el detalle de las facturas --->
    <cffunction name="DetallesFactura" output="yes" access="private">
        <cfargument name="rslineasQuery"  type="query" required="yes">
            <cfset rslineas = Arguments.rslineasQuery>
            <tr>
                <td><cfoutput>F- #rsEfactura.EDdocumento#</cfoutput></td>           
                <td>
                <cfloop query="rsLineas">
                    <cfif len(trim(#rsLineas.NumeroOC#)) gt 0>                        
                        <cfoutput>#rsLineas.NumeroOC#</cfoutput>/
                    </cfif>                          
                </cfloop>    
                <cfif len(trim(#rsLineas.NumeroOC#)) eq 0>
                    --
                </cfif>                                   
                </td>
                <td><cfoutput>#NumberFormat(rsEfactura.EDtotal,'9,9.99')#</cfoutput></td>
                <td><cfoutput>#rsEfactura.Moneda#</cfoutput></td>
            </tr>    
    </cffunction>
<cfelse>
 <cfthrow message="No se ha definido ninguna factura para mostrar su información!">
  <script language="javascript">
   		window.close();
  </script>
</cfif>

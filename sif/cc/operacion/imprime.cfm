    <cfset params = "">  
    <cfset params = '?pageNum_rsLista=1' >
	<cfset paramsLvarArchivo = '' >
	<cfif isdefined('url.PageNum_rsLista') and len(trim(url.PageNum_rsLista))>
        <cfset params = '?pageNum_rsLista=#url.PageNum_rsLista#' >
    </cfif>    
    <cfif isdefined('url.fecha') and len(trim(url.fecha)) and url.fecha neq -1 >
        <cfset params = params & '&fecha=#url.fecha#' >
    </cfif>
    <cfif isdefined('url.transaccion') and len(trim(url.transaccion)) and url.transaccion neq -1 >
        <cfset params =  params & '&transaccion=#url.transaccion#' >
    </cfif>
    <cfif isdefined('url.usuario') and len(trim(url.usuario)) and url.usuario neq -1 >
        <cfset params =  params & '&usuario=#url.usuario#' >
    </cfif>
    <cfif isdefined('url.moneda') and len(trim(url.moneda)) and url.moneda neq -1 >
        <cfset params =  params & '&moneda=#url.moneda#' >
    </cfif>  
     <cfif isdefined('url.CCTcodigo') and len(trim(url.CCTcodigo)) gt 0 >
        <cfset params =  params & '&CCTcodigo=#url.CCTcodigo#' >
        <cfset paramsLvarArchivo =  paramsLvarArchivo & '&CCTcodigo=#url.CCTcodigo#' >		
    </cfif>  
     <cfif isdefined('url.Pcodigo') and len(trim(url.Pcodigo)) gt 0  >
        <cfset params =  params & '&Pcodigo=#url.Pcodigo#' >
        <cfset paramsLvarArchivo =  paramsLvarArchivo & '&Pcodigo=#url.Pcodigo#' >
    </cfif>  
     <cfif isdefined('url.documento') and len(trim(url.documento)) gt 0  >
        <cfset params =  params & '&documento=#url.documento#' >
         <cfset paramsLvarArchivo =  paramsLvarArchivo & '&documento=#url.documento#' >
    </cfif>  
	 <cfif isdefined('url.Ecodigo') and len(trim(url.Ecodigo)) gt 0  >
        <cfset paramsLvarArchivo =  paramsLvarArchivo & '&Ecodigo=#url.Ecodigo#' >      
    </cfif> 
    
<cfif isdefined('CCTcodigo') and len(trim(#url.CCTcodigo#)) gt 0 and isdefined('Pcodigo') and len(trim(#url.Pcodigo#)) gt 0> 
        <cfquery name="rsFMT" datasource="#session.dsn#">
         select FMT01COD from CCTransacciones where CCTcodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigo#">
         and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
        <cfif len(trim(#rsFMT.FMT01COD#)) eq 0>
           <cfthrow message="No existe un formato de impresion definido para las facturas de CxC!">
        </cfif>
        <cfquery name="rsFormato" datasource="#session.DSN#">
			select FMT01tipfmt, FMT01cfccfm
			from FMT001
			where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
			  and FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFMT.FMT01COD#">
              and FMT01tipfmt = 1
		</cfquery>
        
        <cfif rsFormato.recordcount gt 0>        
			<cfset LvarArchivo = trim(rsFormato.FMT01cfccfm) >
        </cfif>   
        
      <cfif isdefined("LvarArchivo") >	
		<cfif rsFormato.FMT01tipfmt eq 1>
			<cf_rhimprime datos="#LvarArchivo#" paramsuri="#paramsLvarArchivo#">
		 	<cfinclude template="#LvarArchivo#">  
        </cfif>
     <cfelse>
         <cflocation url="ListaPagos.cfm#params#" addtoken="no"> 
     </cfif>   
       
<cfelse>
  <cflocation url="ListaPagos.cfm#params#" addtoken="no">     
</cfif>        
<cfif isdefined("session.Usulogin") and len(trim(session.Usulogin))>
	<cfquery name="rsVentaDuplicada" datasource="#session.DSN#">
        select QPTidTag, count(1), max(QPvtaTagid) as maximo
        from QPventaTags 
        where Ecodigo =#session.Ecodigo#
        group by QPTidTag
        having count(1) > 1
     </cfquery>

     <cfdump var="#rsVentaDuplicada#">
     <cfquery name="rsVentas" datasource="#session.DSN#">
    	select count(1) as cantidad
        from QPventaTags
        where Ecodigo = #session.Ecodigo#
    </cfquery>
    Registros existentes antes del Borrado:
    <cfoutput>#rsVentas.cantidad#</cfoutput><br /><br />
    
    
     <cftransaction>
         <cfloop  query="rsVentaDuplicada">
             <cfquery name="rsMaxVenta" datasource="#session.DSN#">
                delete from QPventaTags
                where QPvtaTagid =#rsVentaDuplicada.maximo#
             </cfquery>
         </cfloop>
         
          	<cfquery name="rsVentas" datasource="#session.DSN#">
                select count(1) as cantidad
                from QPventaTags
                where Ecodigo = #session.Ecodigo#
            </cfquery>
            Registros existentes despues del Borrado:
            <cfoutput>#rsVentas.cantidad#</cfoutput><br /><br />
            
            
		<cftransaction action="commit"/>
	</cftransaction>

    
   	Eliminación de ventas duplicadas finalizada<br />
    <a href="/cfmx/home/menu/empresa.cfm">Regresar</a><br />
</cfif>
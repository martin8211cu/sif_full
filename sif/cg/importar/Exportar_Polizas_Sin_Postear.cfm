<cfset Exporta(url.IDcontable)>

<cffunction access="private" output="yes" name="Exporta">
	<cfargument name="IDcontable" type="numeric" required="yes"> 

	<cf_dbfunction name="to_sdate" args="a.Efecha" returnvariable="LvarEfecha">    
    <cfquery name="ERR" datasource="#session.DSN#">
        select 
             a.Ecodigo, 
             a.Cconcepto, 
             a.Eperiodo, 
             a.Emes, 
             a.Edocumento, 
             #preservesinglequotes(LvarEfecha)# as Efecha, 
             a.Edescripcion, 
             a.Edocbase, 
             a.Ereferencia, 
             a.ECauxiliar, 
             a.ECusuario, 
             a.ECselect,
             b.Dlinea, 
             b.Ocodigo, 
             b.Ddescripcion, 
             b.Ddocumento, 
             b.Dreferencia, 
             b.Dmovimiento, 
             b.Ccuenta, 
             b.Doriginal, 
             b.Dlocal, 
             b.Mcodigo, 
             b.Dtipocambio
        from EContables a
            inner join DContables b 
              on b.IDcontable=a.IDcontable
        where a.Ecodigo    = #session.Ecodigo#
          and a.IDcontable = #arguments.IDcontable#
    </cfquery>
</cffunction>
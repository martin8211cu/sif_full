<!---<cf_dump var="#form#">--->
<cfquery name="rsReporte" datasource="#session.dsn#">
	SELECT  	Speriodo AS Periodo,	Smes AS Mes,	SNnombre AS SocioNegocio,
                    a.Ddocumento AS Documento,				a.id_direccion AS Direccion,
                    c.Miso4217 AS Moneda,							Dtipocambio AS TipoCambio,
                    Dsaldo AS Saldo_Origen,						ROUND((Dsaldo * Dtipocambio), 2) AS Saldo_Local,
                    Dantiguedad AS Antiguedad,					d.CPTdescripcion AS transaccion 
                    
	FROM SNSaldosInicialesCPD a 	
        INNER JOIN BMovimientosCxP bm 
            ON bm.Ddocumento = a.Ddocumento 
            AND bm.CPTcodigo = a.CPTcodigo 
            AND bm.Ecodigo = a.Ecodigo 
        LEFT JOIN SNegocios b 	
	        ON b.SNcodigo = a.SNcodigo 
        LEFT JOIN Monedas c 	
	        ON c.Mcodigo = a.Mcodigo 
        LEFT JOIN CPTransacciones d 	
    	    ON d.Ecodigo = a.Ecodigo 	 
        	AND d.CPTcodigo = a.CPTcodigo 	
	
    WHERE a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined('form.SNcodigo') and len(trim(form.SNcodigo))>
    	and a.SNcodigo >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.SNcodigo)#">
    </cfif>
    <cfif isdefined('form.SNcodigob2') and len(trim(form.SNcodigob2))>
    	and a.SNcodigo <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.SNcodigob2)#">
    </cfif>
    <cfif isdefined('form.mes') and len(trim(form.mes))>
    	and a.Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.mes)#">
    </cfif>
    <cfif isdefined('form.periodo') and len(trim(form.periodo))>
    	and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.periodo)#">
    </cfif>
    <cfif isdefined('form.Documento') and len(trim(form.Documento))>
    	and a.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Documento)#">
    </cfif>

</cfquery>

<cfif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 1>
	<cfset formatos = "flashpaper">
<cfelseif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 2>
    <cfset formatos = "pdf">
<cfelseif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 3>
    <cfset formatos = "excel">
</cfif>
<cfif formatos eq "excel">
     <cf_QueryToFile query="#rsReporte#" FILENAME="AntiguedadSaldosxMesDetallado.xls" titulo="Antiguedad Saldos x Mes Detallado">
<cfelse>
	<cfthrow message="No implementado">
</cfif>
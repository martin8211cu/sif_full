<!--- Ruta: cfusion-war\home\public --->
<!--- Link: http://166.148.6.213:9030/cfmx/home/public/FixMovsDuolicados.cfm---> 

<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
<cfset javaRT.gc()>

<!--- Movimientos Duplicados --->
<cfquery name="rsDuplicados" datasource="minisif">
    select count(1), max(QPMCid) as QPMCid, QPTidTag
    from QPMovCuenta
    where QPMCdescripcion = 'Movimientos de uso telepeaje(ADS)'
    and BMFecha >= '2010-04-17 00:00:00'
    group by QPTidTag
    having count(1) > 1
    order by QPTidTag desc
</cfquery>


<cfset LvarQPTidTag = ''>

<cfflush interval="1024">
<cfset LvarCount = 0>
<cfloop query="rsDuplicados">
	<cfset LvarCount = LvarCount + 1>
    <cfset LvarQPMCid = rsDuplicados.QPMCid>
    
	<cfif LvarQPTidTag neq rsDuplicados.QPTidTag>
    	<cfset LvarQPTidTag = rsDuplicados.QPTidTag>
    	<cfquery datasource="minisif">
        	delete from QPMovCuenta
            where QPMCid = #LvarQPMCid#
        </cfquery>
    </cfif>
    <cfif LvarCount eq 1000 or LvarCount eq 2000>
    	<cfset javaRT.gc()>
    </cfif>
</cfloop>

<cfoutput>FIN</cfoutput><br>
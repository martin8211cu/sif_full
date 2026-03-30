<!--- Retorna en un arreglo (datasources), los caches definidos en el JRun o CF --->

<cflock name="serviceFactory" type="exclusive" timeout="10">
	<cfscript>
    	factory = CreateObject("java", "coldfusion.server.ServiceFactory");
    	ds_service = factory.datasourceservice;
  	</cfscript> 
	
	<!--- obtiene los nombres de los datasources --->
	<cfset caches = ds_service.getNames()>

	<!--- obtiene un struct con la propiedades de los datasources --->
	<cfset ds = "#ds_service.getDataSources()#" >

	<!--- Crea un arreglo con los datasources validos --->
	<!--- No toma en cuanta los datasources de MSaccess, pues son defindiso por el cf 
	      para ejemplos y otros motivos y no corresponden a las aplicaciones nuestras
	--->
	<cfset j = 1 >
	<cfloop From="1" To="#ArrayLen(caches)#" index="i">
		<cfset data = "ds." & caches[i] & ".driver" >
		<cfif UCase(Evaluate(data)) neq 'MSACCESS'>
			<cfset datasources[j] = caches[i] >
			<cfset j = j +1 >
		</cfif>	
	</cfloop>
	
	<cfset ArraySort(datasources, "text") >
</cflock>
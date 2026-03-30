<cffunction name="getMemData" access="remote" returnType="array" returnFormat="JSON">
	
	<cfscript>
		runtime = CreateObject("java","java.lang.Runtime").getRuntime();
		totalMemory = runtime.totalMemory() / 1024 / 1024;//currently in use
	</cfscript>
	
	<cfset runtime = CreateObject("java","java.lang.Runtime").getRuntime()>
	<cfset freeMemory = runtime.freeMemory() / 1024 / 1024>
	<cfset totalMemory = runtime.totalMemory() / 1024 / 1024>
	<cfset maxMemory = runtime.maxMemory() / 1024 / 1024>
	<cfset usedMemory =  (runtime.totalMemory() - runtime.freeMemory()) / 1024 / 1024>
	
	<cfset dataArr = arrayNew(1)/>
	
	<cfset _freeMemory = structNew()/>
	<cfset _freeMemory.name = 'Free Memory'/>
	<cfset _freeMemory.value = freeMemory/>
	<cfset ArrayAppend(dataArr, _freeMemory)/>

	<cfset _totalMemory = structNew()/>
	<cfset _totalMemory.name = 'Total Memory'/>
	<cfset _totalMemory.value = totalMemory/>
	<cfset ArrayAppend(dataArr, _totalMemory)/>

	<cfset _usedMemory = structNew()/>
	<cfset _usedMemory.name = 'Used Memory'/>
	<cfset _usedMemory.value = usedMemory/>
	<cfset ArrayAppend(dataArr, _usedMemory)/>
	
	<cfset _maxMemory = structNew()/>
	<cfset _maxMemory.name = 'Max Memory'/>
	<cfset _maxMemory.value = maxMemory/>
	<cfset ArrayAppend(dataArr, _maxMemory)/>
	
	<cfif _usedMemory.value gt 2048>
		<cfset clear = runtime.gc()> 
	</cfif>

	<cfreturn dataArr>
 </cffunction>



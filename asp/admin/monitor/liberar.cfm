<cfif IsDefined('form.asignar')>
<!---
	<cfset basura = CreateObject("java", "java.lang.StringBuffer")>
	<cfset basura.init(JavaCast('int', 1024 * 1024 * 50))>
--->
<cfelse>
	<cfset javaSystem = CreateObject("java", "java.lang.System")>
	<cfset javaSystem.gc()>
</cfif>
<cflocation url=".">
<!---
 * 25 Apr 2006 - Creación en Java
 * 10 Ago 2006 - Conversión a CFC
 * Si se usa ssh para ejecutar algo, asegurese
 * de que el directorio ~/.ssh contenga:
 *     id_rsa, id_rsa.pub y known_hosts
 * para el usuario con el que se ejecute el Coldfusion (SYSTEM, jrun, etc)
* 17 Oct 2006 - Copia a /asp/admin/respaldo
--->
<cfcomponent output="no">

	<cfproperty name="stdin">
	<cfproperty name="stderr">
	<cfproperty name="exitValue">
	<!---dumpStream--->
	<cffunction name="dumpStream" output="false" returntype="string">
		<cfargument name="istr">
		
		<cfset sb = CreateObject("java", "java.lang.StringBuffer")>
		
		<cfloop condition="1">
			<cfset ch = istr.read()>
			<cfif ch is -1><cfbreak></cfif>
			<cfset sb.append(Chr(ch))>
		</cfloop>
		<cfset istr.close()>
		<cfreturn sb.toString()>
	</cffunction>
	<!---shellExecute--->
	<cffunction name="shellExecute" returntype="numeric" output="true">
		<cfargument name="cmd" type="string" required="yes">
		<cfset This.cmd = Arguments.cmd>
		<cfset proc = CreateObject("java","java.lang.Runtime")
			.getRuntime().exec(Arguments.cmd)>
		<cfset proc.getOutputStream().close()>
		<cfset This.stdout = dumpStream(proc.getInputStream())>
		<cfset This.stderr = dumpStream(proc.getErrorStream())>
		<cfset This.exitValue = proc.waitFor()>
		<cfreturn This.exitValue>
	</cffunction>
	<!---shellEscape--->
	<cffunction name="shellEscape" output="false" returntype="string">
		<cfargument name="s" type="string" required="yes">
		<!--- oculta al shell los caracteres especiales para evitar la inyección de 
			comandos en las contraseñas. --->
		
		<cfparam name="This.modoShell">
		<!--- 'cygwinssh-solaris' --->
		<cfif ListFind('ssh', This.modoShell)>
			<cfif Find('Win', server.OS.Name)>
				<!--- Windows: Configuración para usar cmd/cygwinssh a solaris --->
				<cfset s = Replace(s, """", "\""", 'all')><!--- escape de comillas " por \" --->
				<cfset s = Replace(s, "'", "'\''", 'all')><!--- escape de ' por '\''  (o'hara => o'\''hara) --->
				<cfset s = Replace(s, "'", "'\''", 'all')><!--- otra vez por el ssh (o'hara => o'\''\'\'''\''hara)--->
				<cfset s = "'" & s & "'"><!--- unix quote: poner 'texto' (o'hara => 'o'\''\'\'''\''hara')--->
				<cfset s = '"' & s & '"'><!--- DOS quote poner "texto" ("o'hara => 'o'\''\'\'''\''hara'")--->
			<cfelse>
				<!--- UNIX: Configuración para usar bash/ssh unix a solaris --->
				<cfset s = Replace(s, "'", "", 'all')><!--- omito las ' porque el AddProfile no las entiende (o'hara=>ohara) --->
				<cfset s = "'" & s & "'"><!--- unix quote (o'hara=>'ohara')--->
			</cfif>
		<cfelseif ListFind('shell', This.modoShell)>
			<!--- Configuración para usar shell directo en, supondremos, solaris --->
			<cfset s = Replace(s, "'", "", 'all')><!--- omito las ' porque el AddProfile no las entiende (o'hara=>ohara) --->
			<cfset s = "'" & s & "'"><!--- unix quote (o'hara=>'ohara')--->
		</cfif>
		<cfreturn s>
	</cffunction>
	<!--- dump --->
	<cffunction name="dump" output="true" returntype="void" hint="Se usa solamente para debug">
		<cfargument name="title" default="cmd" required="no">
		<cfif IsDefined('This.Enabled') And Not This.Enabled>
			<div>Interfaz inhabilitada</div>
			<cfreturn>
		</cfif>
		<cfoutput>
			<div style="border:1px solid black; background-color:##CCCCCC; padding:4px; margin-bottom:4px">
				<div style="background-color:##66CCFF">#title#</div>
				<cfif IsDefined('This.cmd')>
				<div># HTMLEditFormat( This.cmd )#</div>
				</cfif>
				<cfif IsDefined('This.exitValue')>
				<div style="background-color:##999999">exit status: #HTMLEditFormat( This.exitValue )#</div>
				</cfif>
				<cfif IsDefined('This.stdout') And Len(This.stdout)><div style="font-weight:bold;white-space:pre"># HTMLEditFormat( This.stdout )#</div></cfif>
				<cfif IsDefined('This.stderr') And Len(This.stderr)><div style="font-weight:bold;white-space:pre;color:red"># HTMLEditFormat( This.stderr )#</div></cfif>
			</div>
		</cfoutput>
	</cffunction>
</cfcomponent>
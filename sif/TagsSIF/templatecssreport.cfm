<cfsilent>
	<cfset LvarStyle = "">
	<cfif Not IsDefined('Request.TemplateCSSReport')>
		<cfset Request.TemplateCSSReport = true>
		<cfif isdefined('session.sitio.css')>
			<cfset count = 0>
			<cfset elems = 0>
			<cfset rutacss = "">
			<cfset cssname = "">
			<cfset elems = ListLen(session.sitio.css,"/")>
			<cfif elems gt 1>
				<cfloop list="#session.sitio.css#" index="dir" delimiters="/">
					<cfset count = count + 1>
					<cfif count LT elems>
						<cfset rutacss = ListAppend(rutacss,dir,"/")>
					<cfelse>
						<cfset cssname = dir>
					</cfif>				
				</cfloop>
			<cfelse>
				<cfset elems = ListLen(session.sitio.css,"\")>	
				<cfloop list="#session.sitio.css#" index="dir" delimiters="\">
					<cfset count = count + 1>
					<cfif count LT elems>
						<cfset rutacss = ListAppend(rutacss,dir,"\")>
					<cfelse>
						<cfset cssname = dir>
					</cfif>				
				</cfloop>
			</cfif>
			<cfif (len(trim(rutacss)) gt 0)>
				<cfoutput>
				<cfsavecontent variable="LvarStyle">
<!-- INICIO templatecssreport.cfm -->
					<style type="text/css">
						@import "#cssname#";
					</style>
<!-- FINAL templatecssreport.cfm -->
				</cfsavecontent>
				</cfoutput>
				<cfloop condition="true">
					<cfset LvarPto1 = findNoCase('@import',LvarStyle)>
					<cfif LvarPto1 EQ 0>
						<cfbreak>
					</cfif>
					<cfset LvarPto2 = findNoCase('"',LvarStyle,LvarPto1)+1>
					<cfset LvarPto3 = findNoCase('"',LvarStyle,LvarPto2)>
					<cfset LvarPto4 = findNoCase(';',LvarStyle,LvarPto3)>
					<cfif LvarPto2 EQ 0 OR LvarPto3 EQ 0 OR LvarPto4 EQ 0>
						<cf_errorCode	code = "50716" msg = "Error de sintaxis en °import">
					</cfif>
					<cfset LvarFileName = mid(LvarStyle,LvarPto2,LvarPto3-LvarPto2)>
					<cfoutput>
				
					<cfset ArrayRutaCSS = ListToArray(LvarFileName,'/')>
					<cfif UCASE(ArrayRutaCSS[1]) EQ 'CFMX'>
						<cfsavecontent variable="LvarStyle2"><cfinclude template="#REPLACE(LvarFileName,'/cfmx/','/')#"></cfsavecontent>
					<cfelse>
						<cfsavecontent variable="LvarStyle2"><cfinclude template="/#rutacss#/#LvarFileName#"></cfsavecontent>
					</cfif>
					
					<cfset LvarStyle = mid(LvarStyle,1,LvarPto1-1) & LvarStyle2 & mid(LvarStyle,LvarPto4+1,len(LvarStyle))>
					</cfoutput>
				</cfloop>
			</cfif>
		</cfif>
	</cfif>
</cfsilent>
<cfhtmlhead text='#LvarStyle#'>



<cfsilent>
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
						<cfset cssname = ListGetAt(ListGetAt(dir,1,"."),2,"_")>
					</cfif>				
				</cfloop>
			<cfelse>
				<cfset elems = ListLen(session.sitio.css,"\")>	
				<cfloop list="#session.sitio.css#" index="dir" delimiters="\">
					<cfset count = count + 1>
					<cfif count LT elems>
						<cfset rutacss = ListAppend(rutacss,dir,"\")>
					<cfelse>
						<cfset cssname = ListGetAt(ListGetAt(dir,1,"."),2,"_")>
					</cfif>				
				</cfloop>
			</cfif>
			<cfsavecontent variable="style">
				<cfif (len(trim(rutacss)) gt 0)>
					<cfoutput>
						<style type="text/css">
							<cfinclude template="/#rutacss#/base/styles.css">
							<cfinclude template="/#rutacss#/#cssname#/portlet.css">
							<cfinclude template="/#rutacss#/base/mlm_menu.css">
							<cfinclude template="/#rutacss#/base/tabs.css">
							<cfinclude template="/#rutacss#/base/nonvisual.css">
							<cfinclude template="/#rutacss#/base/deprecated.css">
							<cfinclude template="/#rutacss#/base/button.css">
							<cfinclude template="/#rutacss#/base/template.css">
							<cfinclude template="/#rutacss#/base/leftmenu.css">
							<cfinclude template="/#rutacss#/#cssname#/#cssname#.css">
						</style>
					</cfoutput>
				</cfif>
			</cfsavecontent>
		</cfif>
	</cfif>
</cfsilent>
<cfhtmlhead text='#style#'>
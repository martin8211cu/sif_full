<cfcomponent>
	<cffunction name='wHint' access='public' returntype='any' output='true'>
 		<cfargument name='ref' type='string' required='true' default='Haga click aquí'>
 		<cfargument name='mensaje' type='string' required='true' default='Tooltip'>
		<cfargument name='titulo' type='string' required='false' default=''>
 		<cfargument name='imagen' type='boolean' required='false' default='false'>
 		<cfargument name='funcion' type='string' required='false' default=''>
 		<cfargument name='linkAttr' type='string' required='false' default=''>

		<cfif not isdefined("Request.overLib")>
			<script language='JavaScript' type='text/javascript' src='/cfmx/edu/js/Overlib/overlib.js'>//</script>
			<div id='overDiv' style='position:absolute; visibility:hidden; z-index:1000;'></div>
			<cfset Request.overLib = True>
		</cfif>
		
		<cfoutput>
			<a href="javascript:<cfif Len(Trim(funcion)) NEQ 0>#funcion#<cfelse>void(0);</cfif>" 
				onmouseover='javascript:return overlib("#mensaje#"<cfif Len(Trim(titulo)) NEQ 0>, CAPTION, "#titulo#"</cfif>);'
				onmouseout="nd();" 
				#linkAttr#
				>
				<cfif imagen>
					<img 
					src="#ref#"
					border="0">
				<cfelse>
					#ref#
				</cfif>
			</a>							
		</cfoutput>
	</cffunction>
</cfcomponent>
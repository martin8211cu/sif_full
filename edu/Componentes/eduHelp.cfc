<cfcomponent>
	<cffunction name='Ayuda' access='public' returntype='any' output='true'>
		<cfargument name='Acodigo' type='string' required='true' default=''>
		<cfargument name='Iid' type='string' required='false' default='1'>		
		<cfargument name='nombre' type='string' required='false' default='imAyuda'>		
 		<cfargument name='imagen' type='numeric' required='false' default='0'>		
		<cfargument name='tipo' type='numeric' required='false' default='0'>
		<cfargument name='titulo' type='string' required='false' default=''>
 		<cfargument name='pagina' type='string' required='false' default='/cfmx/edu/Componentes/errorHelp.cfm'>
		<cfargument name='width' type='numeric' required='false' default='550'>
		<cfargument name='height' type='numeric' required='false' default='400'>
 		<cfargument name='left' type='numeric' required='false' default='250'>
 		<cfargument name='top' type='numeric' required='false' default='200'>
				
		<script language='JavaScript' type='text/javascript' src='/cfmx/edu/js/Overlib/overlib.js'>//</script>
		<div id='overDiv' style='position:absolute; visibility:hidden; z-index:1000;'></div>
		
		<script language='JavaScript' type='text/javascript' >
			<cfif #width# EQ ''>
				ww = parseInt(screen.width) - 10;
			<cfelse>
				ww = <cfoutput>#width#;</cfoutput>
			</cfif>	
			<cfif #height# EQ ''>
				wh = parseInt(screen.height) - 60;
			<cfelse>
				wh = <cfoutput>#height#;</cfoutput>
			</cfif>	
			<cfif #left# EQ ''>
				wl = 0;
			<cfelse>
				wl = <cfoutput>#left#;</cfoutput>
			</cfif>	
			<cfif #top# EQ ''>
				wt = 0;
			<cfelse>
				wt = <cfoutput>#top#;</cfoutput>
			</cfif>
		</script>		
		
		<cfquery name="rs" datasource="#Session.Edu.DSN#">
			select Adesc 
			from Ayuda 
			where Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Acodigo#">
			  and Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Iid#">
		</cfquery>


		<cfif rs.RecordCount GT 0>
			<cfset ayudaTxt =  rs.Adesc>
		<cfelse>	
			<cfset ayudaTxt =  "Ayuda no disponible.">
		</cfif>
		
		<cfoutput>
			<cfif #tipo# EQ 1>
				<a href="javascript:void(0);" 
					onmouseover='javascript:return overlib("#jsstringformat(ayudaTxt)#", CAPTION, "#titulo#");'
					onmouseout="nd();">

					<img 
						name="#nombre#" 
						src="<cfif #imagen# EQ 1>/cfmx/edu/Imagenes/help_u.gif<cfelseif #imagen# EQ 0>/cfmx/edu/Imagenes/Help01_T.gif<cfelseif #imagen# EQ 2>/cfmx/edu/Imagenes/Bulb.gif</cfif>"
						border="0">
				</a>							
			<cfelse>
				<a href='javascript:void(0);'
	 				onclick="javascript: open('#pagina#', '#nombre#', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+ww+',height='+wh+',left='+wl+', top='+wt+',screenX='+wl+',screenY='+wt+'')">
					
					<img 
			 			name="#nombre#" 
					    alt="Ver Ayuda"
						src="<cfif #imagen# EQ 1>/cfmx/edu/Imagenes/help_u.gif<cfelseif #imagen# EQ 0>/cfmx/edu/Imagenes/Help01_T.gif<cfelseif #imagen# EQ 2>/cfmx/edu/Imagenes/Bulb.gif</cfif>"
						border="0">
				</a>					
			</cfif>
		</cfoutput>
	</cffunction>
</cfcomponent>
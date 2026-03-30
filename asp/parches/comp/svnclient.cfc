<cfcomponent output="no">
<cfif Not FindNoCase('Windows', Server.OS.Name)>
	<cfthrow message="Solo se permite ejecutar en Windows: OS.Name= #Server.OS.Name#">
</cfif>
<cftry>
	<cfset revisionClass = CreateObject("java", "org.tmatesoft.svn.core.wc.SVNRevision")>
	<cfcatch type="any">
		<!--- esto es porque no se puede restablecer la salida --->
		<cferror type="exception" template="/asp/parches/crear/instalar.cfm">
		<cfthrow message="<a href='instalar.cfm'>Debe instalar JavaSVN en su application server. Haga clic para ver las Instrucciones</a>">
	<cfabort>
</cfcatch>
</cftry>

<cfset revisionClass = CreateObject("java", "org.tmatesoft.svn.core.wc.SVNRevision")>

<cfset execute_timeout = 30>

<!--- Inicializa el Cliente de SVN --->
<cffunction name="getClientManager">
	<cfif Not IsDefined('Request.svn_client_manager')>
		<!---  for DAV (over http and https)  --->
		<cfset CreateObject("java", "org.tmatesoft.svn.core.internal.io.dav.DAVRepositoryFactory").setup()>
		<!---  for SVN (over svn and svn+ssh) --->
		<cfset CreateObject("java", "org.tmatesoft.svn.core.internal.io.svn.SVNRepositoryFactoryImpl").setup()>
		<!--- SVNWCUtil me permite obtener las opciones default --->
		<cfset wcutil = CreateObject("java", "org.tmatesoft.svn.core.wc.SVNWCUtil")>
		<!--- Modificar opciones default para que no almacene, nunca, las contraseñas obtenidas --->
		<cfset opts = wcutil.createDefaultOptions(true)>
		<cfset opts.setAuthStorageEnabled(false)>
		<cfset opts.setUseCommitTimes(true)>
		<!--- Crear Client Manager --->
		<cfset cmgr = CreateObject("java", "org.tmatesoft.svn.core.wc.SVNClientManager")>
		<cfset decrypted = ''>
		<cfif Len( session.parche.svnpasswd )>
			<cfset decrypted = ListRest(Decrypt( session.parche.svnpasswd, 'svn-password-encrypted' ))>
		</cfif>
		<cfset Request.svn_client_manager = cmgr.newInstance(opts, session.parche.svnuser, decrypted)>
	</cfif>
	<cfreturn Request.svn_client_manager>
</cffunction>

<!--- obtener información del repositorio --->
<cffunction name="get_info" output="false">
	<cfargument name="wc">
	<cfset var ret = StructNew()>
	
	<cfif Find("://", wc)>
		<cfset svnurlobj =CreateObject("java", "org.tmatesoft.svn.core.SVNURL").parseURIDecoded(wc)>
		<cfset info = getClientManager().getWCClient().doInfo(svnurlobj, revisionClass.HEAD, revisionClass.HEAD)>
	<cfelse>
		<cfset javaFile = CreateObject("java", "java.io.File").init(wc)>
		<cfset info = getClientManager().getWCClient().doInfo(javaFile, revisionClass.WORKING)>
	</cfif>
	<cfset ret.revision = info.revision.toString()>
	<cfset ret.url = info.url.toString()>
	  
	<cfreturn ret>
</cffunction>

<!--- obtener el log del repositorio --->
<cffunction name="get_log" output="false">
  <cfargument name="svnURL">
  <cfargument name="pathFilter">
  <cfargument name="fecha_desde" type="date">
  
  <!--- incluir el JSP, y preservar session.parche, que por alguna razón se pierde al llamar al JSP --->
  <cfset preservar_session_parche = session.parche>
  <cfset request.svnurl = Arguments.svnURL>
  <cfset getClientManager()>
  <cfset request.fecha_desde = Arguments.fecha_desde>
  <cfset GetPageContext().include("svnclient_log.jsp")>
  <cfset session.parche = preservar_session_parche>
	<!--- Validar que el JSP haya regresado algo --->
	<cfif Not IsDefined('request.logresult')>
		<cfif IsDefined('request.logerror')>
		<cfthrow message="#request.logerror#">
		<cfelse>
		<cfthrow message="Error consultando fuentes.">
		</cfif>
	</cfif>
  <cfset RETURN_ARRAY = ArrayNew(1)>
	  <cfloop from="1" to="#ArrayLen(request.logresult)#" index="i">
		<cfset STRUCT_ENTRY = StructNew()>
		<cfset thisentry = request.logresult[i]>
		<cfset STRUCT_ENTRY.Revision = thisentry.revision>
		<cfset STRUCT_ENTRY.Author = thisentry.author>
		<cfset STRUCT_ENTRY.Date = thisentry.date>
		<cfset STRUCT_ENTRY.Msg = thisentry.message>
		<cfset Paths = thisentry.changedPaths>
		<cfset PATHS_ARRAY = ArrayNew(1)>
		<cfloop collection="#Paths#" item="j">
		  <cfset S_PATH = StructNew()>
		  <cfset S_PATH.action = Paths[j].type & "">
		  <cfset S_PATH.path = Paths[j].path>
<!---
	Se deberían ignorar / borrar los archivos que hayan sido eliminados
	action es 'M' - Modified, 'A' - Added, 'D' - Deleted, 'R' - Replaced
--->
<!---		  <cfif (Left(S_PATH.path,Len(PathFilter)) EQ PathFilter) And (  DateCompare( thisentry.date, Arguments.fecha_desde ) GE 0)>
	*** esta condición DateCompare solo se pone si vuelve a fallar el filtro de fechas ***
--->
		  <cfif (Left(S_PATH.path,Len(PathFilter)) EQ PathFilter) >
		  	<cfset ArrayAppend(PATHS_ARRAY, S_PATH)>
		  </cfif>
		</cfloop>
		<cfif ArrayLen(PATHS_ARRAY)>
			<cfset STRUCT_ENTRY.Paths = PATHS_ARRAY>
			<cfset ArrayAppend(RETURN_ARRAY, STRUCT_ENTRY)>
		</cfif>
	  </cfloop>
  <cfreturn RETURN_ARRAY>
</cffunction>

<!--- desplegar, en HTML, el log recabado por get_log --->
<cffunction name="show_log" output="true">
  <cfargument name="the_log">
  <cfoutput>
    <table border="1">
      <tr>
        <td>Revision</td>
        <td>Author</td>
        <td>Date</td>
        <td>Paths</td>
        <td>Msg</td>
      </tr>
      <cfloop from="1" to="#ArrayLen(the_log)#" index="i">
        <tr>
          <td>#the_log[i].Revision#</td>
          <td>#the_log[i].Author#</td>
          <td>#the_log[i].Date#</td>
          <td><cfloop from="1" to="#ArrayLen(the_log[i].Paths)#" index="j">
				#the_log[i].Paths[j].action# #the_log[i].Paths[j].path#               <br />
            </cfloop></td>
          <td>#the_log[i].Msg#&nbsp;</td>
        </tr>
      </cfloop>
    </table>
  </cfoutput>
</cffunction>

<cffunction name="export" output="false">
	<cfargument name="reposURL" required="yes">
	<cfargument name="branch" required="yes">
	<cfargument name="file" required="yes">
	<cfargument name="destPath" required="yes">

	<cfinvoke component="path" method="concat"
		dir="#destPath#" file="#GetDirectoryFromPath(file)#"
		returnvariable="destFulldir"/>
	<cfinvoke component="path" method="concat"
		dir="#destPath#" file="#file#"
		returnvariable="destFullFile"/>

	<cfinvoke component="path" method="concat"
		dir="#reposURL#" file="#branch#"
		returnvariable="fullURL"/>
	<cfinvoke component="path" method="concatURL"
		dir="#fullURL#" file="#file#"
		returnvariable="fullURL"/>
	<cfif Not DirectoryExists(destFulldir)>
		<cfdirectory action="create" directory="#destFulldir#">
	</cfif>

	<cfset svnurlobj =CreateObject("java", "org.tmatesoft.svn.core.SVNURL")
							.parseURIDecoded(fullURL)>
	<cfset dstPath = CreateObject("java", "java.io.File")>
	<cfset dstPath.init(destFullFile)>
	<cfset eolStyle = "">
	<cfset force = true>
	<cfset recursive = true>
	
	<cfoutput>doExport: #getClientManager().getUpdateClient().doExport(svnurlobj, dstPath, 
		revisionClass.HEAD, revisionClass.HEAD, JavaCast("null", eolStyle), force, recursive)#</cfoutput>
	
</cffunction>
</cfcomponent>

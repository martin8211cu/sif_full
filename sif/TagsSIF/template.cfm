<cfparam name="Attributes.template" type="string" default="">
<cfparam Name="ThisTag.areas"       default="#arrayNew(1)#">
<cfif Len(Attributes.template) Is 0 and IsDefined('session.sitio.template')>
	<cfset Attributes.template=session.sitio.template>
</cfif>

<!--- indicar al cf_templatecss que ya se ha incluido el css --->
<cfset Request.TemplateCSS = true>

<cfif ThisTag.ExecutionMode IS 'Start' AND ThisTag.HasEndTag IS 'YES'>
<cfelseif ThisTag.ExecutionMode IS 'End' OR ThisTag.HasEndTag IS 'NO' >

	<!--- guardar en bitacora cualquier area de mas de 64 KB --->
	<cfloop from="1" to="#ArrayLen(ThisTag.areas)#" index="areaid">
		<cfif Len(ThisTag.areas[areaid].contents) GE 65536>
			<cfif IsDefined('Request.MonPacket.sessionid') and Len(request.MonPacket.sessionid)>
				<cfset mysessionid = request.MonPacket.sessionid>
			<cfelse>
				<cfset mysessionid = 0>
			</cfif>
			<cfquery datasource="aspmonitor">
				insert into MonRequestTemplate 
					(sessionid, requested, area, areasize, method, uri, args)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#mysessionid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ThisTag.areas[areaid].name#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Len(ThisTag.areas[areaid].contents)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REQUEST_METHOD#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(CGI.SCRIPT_NAME, 1, 255)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(CGI.QUERY_STRING, 1, 255)#">
					)
			</cfquery>
		</cfif>
	</cfloop>

	<cfif FileExists(ExpandPath(Attributes.template))>
		<cfif Right(Attributes.template,4) EQ ".cfm">
			<cftry>
			<cfsavecontent variable="templatedata">
				<cfinclude template="#Attributes.template#">
			</cfsavecontent>
			<cfcatch type="any">
				<cfsavecontent variable="templatedata">
					<cfoutput>
						<html><head><title>$$TITLE$$</title></head>
						<body>
						<div style="background-color:red;color:white;font-weight:bold">
							Error en plantilla: #cfcatch.Message# #cfcatch.Detail#<br>
							<cfif IsDefined('cfcatch.StackTrace')>
							<a href="javascript:void(document.getElementById('cf_template_error_detail_body').style.display='block')" style="color:white">
							Click para ver m&aacute;s detalles &gt;&gt;
							</a>
							<div id="cf_template_error_detail_body" style="display:none">
							<pre>#cfcatch.StackTrace#</pre></div></cfif>
							<br>
							<a href="/cfmx#Attributes.template#" style="color:white ">&gt;&gt;Revisar plantilla</a>
							</div>
							
						<table><tr><td>$$LEFT OPTIONAL$$</td><td>$$BODY$$</td></tr></table></body></html>
					</cfoutput>
				</cfsavecontent>
			</cfcatch>
			</cftry>
		<cfelse>
			<cffile action="read" file="#ExpandPath(Attributes.template)#" variable="templatedata">
		</cfif>
	<cfelseif FileExists(ExpandPath("/home/public/plantilla.cfm"))>
		<cfsavecontent variable="templatedata">
			<cfinclude template="/home/public/plantilla.cfm">
		</cfsavecontent>
	<cfelse>
		<cfset templatedata='<html><head><title>$$TITLE$$</title></head><body><table><tr><td>$$LEFT OPTIONAL$$</td><td>$$BODY$$</td></tr></table></body></html>'>
	</cfif>
	<!--- reemplazar hrefs: convertir ruta absoluta en relativa
	<cfscript>
		delim = '/\';
		// CGI.PATH_INFO no sirve en Win32/Apache/mod_proxy
		// CGI.PATH_TRANSLATED no sirve en RedHat AS2.1/Apache/jrun/mod_jrun
		// por eso se usa CGI.SCRIPT_NAME
		// index LT 50 en lugar de 10: WebSphere, instalacion default en windows,
		//     tiene un path de 11 componentes, sumandole el SCRIPT_NAME, pueden llegar a 20
		basepath = ListToArray(GetDirectoryFromPath(ExpandPath(Replace(CGI.SCRIPT_NAME,'/cfmx',''))), delim);
		tmplpath = ListToArray(GetDirectoryFromPath(ExpandPath(Attributes.template)), delim);
		//WriteOutput("basepath:"&ArrayToList(basepath)&"<br>tmplpath:"&ArrayToList(tmplpath)&"<br>");
		for (index = 1; index LT 50; index = index + 1) {
			if (ArrayLen(basepath) EQ 0) break;
			if (ArrayLen(tmplpath) EQ 0) break;
			if (basepath[1] NEQ tmplpath[1]) break;
			ArrayDeleteAt(basepath, 1);
			ArrayDeleteAt(tmplpath, 1);
		}
		relative_path = "";
		//WriteOutput("basepath:"&ArrayToList(basepath)&"<br>tmplpath:"&ArrayToList(tmplpath)&"<br>");
		if (ArrayLen(basepath) GT 0)
			relative_path = relative_path & RepeatString('../',ArrayLen(basepath));
		if (ArrayLen(tmplpath) GT 0)
			relative_path = relative_path & ArrayToList(tmplpath,'/') & '/';
		//WriteOutput("relpath:"&relative_path&"<br>");
		
		// src href background
		
		templatedata = REReplaceNoCase(templatedata, 'src="(?!http:|javascript:)([^/##"])',        'src="'        & relative_path & '\1', 'all');
		templatedata = REReplaceNoCase(templatedata, 'href="(?!http:|javascript:)([^/##"])',       'href="'       & relative_path & '\1', 'all');
		templatedata = REReplaceNoCase(templatedata, 'background="(?!http:|javascript:)([^/##"])', 'background="' & relative_path & '\1', 'all');
		
	</cfscript> --->

	<!---
	No se  utilizan los  mismos templates que  en Dreamweaver  porque 
	esto evitaría el uso de contribute en la edición de los templates
	--->

	<cfloop from="1" to="#ArrayLen(ThisTag.areas)#" index="areaid">

		<!---
		<cfset marker1 = "\$\$" & ThisTag.areas[areaid].name & "( [^$]+)?\$\$">
		<cfif REFindNoCase(marker1, templatedata)>
			<cfset templatedata = REReplaceNoCase(templatedata, marker1, ThisTag.areas[areaid].contents, "all")>
		</cfif>
		--->

		<cfset marker1 = "$$" & ThisTag.areas[areaid].name & "$$">
		<cfset marker2 = "$$" & ThisTag.areas[areaid].name & " optional$$">
		<cfif FindNoCase(marker1, templatedata)>
			<cfset templatedata = ReplaceNoCase(templatedata, marker1, ThisTag.areas[areaid].contents, "all")>
		<cfelseif FindNoCase(marker2, templatedata)>
			<cfset templatedata = ReplaceNoCase(templatedata, marker2, ThisTag.areas[areaid].contents, "all")>
		</cfif>
	</cfloop>
	
	<cfset EmptyAreaRE = '\$\$([^ $]+)( [^ $]+)*\$\$'>

	<cfset EmptyAreas = REFindNoCase(EmptyAreaRE, templatedata, 0, true)>

	<cfif ArrayLen(EmptyAreas.len) NEQ 1>
		<cfloop from="1" to="30" index="no_max_loop">
			<cfset AreaString = Mid(templatedata, EmptyAreas.pos[1], EmptyAreas.len[1])>
			<cfset AreaName   = Mid(templatedata, EmptyAreas.pos[2], EmptyAreas.len[2])>
			<cfset CurrentDirectory = GetDirectoryFromPath(GetPageContext().getRequest().getServletPath())>
			<cfset AreaTemplate = CurrentDirectory & "AREA_" & UCase(AreaName) & ".cfm">
			<cfif FileExists( ExpandPath (AreaTemplate) )>
				<cftry>
				<cfsavecontent variable="AreaContents">
				<cfinclude template="#AreaTemplate#">
				</cfsavecontent>
				<cfcatch type="any"><cfset AreaContents=cfcatch.Message & " " & cfcatch.Detail></cfcatch>
				</cftry>
			<cfelseif ListContainsNoCase(AreaString, 'OPTIONAL', ' ') EQ 0>
				<cf_errorCode	code = "50715"
								msg  = "No hay contenido para el area: @errorDat_1@"
								errorDat_1="#AreaName#"
				>
			<cfelse>
				<cfset AreaContents = "">
			</cfif>
			<cfset templatedata = Replace(templatedata, AreaString, AreaContents)>
			<cfset EmptyAreas = REFindNoCase(EmptyAreaRE, templatedata, 0, true)>
			<cfif ArrayLen(EmptyAreas.len) LT 2><cfbreak></cfif>
		</cfloop>
	</cfif>

	<!---
	<cfset templatedata = REReplaceNoCase(templatedata, '<' & '!-- InstanceBeginEditable name="[^">]*" -->', '', "all")>
	<cfset templatedata = ReplaceNoCase(templatedata, '<' & '!-- InstanceEndEditable -->', '', "all")>
	--->

	<cfset ThisTag.GeneratedContent = templatedata>
	<!---<cfoutput># templatedata #</cfoutput>--->
</cfif>


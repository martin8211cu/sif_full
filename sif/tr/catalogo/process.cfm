<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Titulo"
		Default="Definir Tr&aacute;mite"
		returnvariable="Titulo"/>
		<cfoutput>#Titulo#</cfoutput>
</cf_templatearea>
<cf_templatearea name="left">
</cf_templatearea>
<!--- <cfinclude template="/home/menu/pNavegacion.cfm"> --->
<cf_templatearea name="body">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TituloPortlet"
	Default="Definir Tr&aacute;mite"
	returnvariable="TituloPortlet"/>
	<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#TituloPortlet#">


<cfparam name="url.processid" type="numeric">
<cfset session.processid = url.processid>


<cfquery datasource="#session.dsn#" name="process">
	select p.ProcessId, p.Version, p.Name, p.Description, x.Name as PackageName, x.Description as PackageDescription
	from WfProcess p join WfPackage x on x.PackageId = p.PackageId
	where p.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.processid#">
</cfquery>

<cfif process.RecordCount is 0><cflocation url="process_list.cfm" addtoken="no"></cfif>

<cfquery datasource="#session.dsn#" name="activity">
	select ActivityId, Name, Ordering
	from WfActivity
	where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.processid#">
	order by Ordering
</cfquery>
<cfquery datasource="#session.dsn#" name="transition">
	select TransitionId, FromActivity, ToActivity, Name
	from WfTransition
	where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.processid#">
	order by FromActivity, ToActivity
</cfquery>

<cfoutput><div style="background-color:##ededed;"><br>

&nbsp;&nbsp;&nbsp;<strong><cf_translate key="LB_GrupoTram">Grupo de tr&aacute;mites</cf_translate>:</strong> #process.PackageDescription#</a><br>
&nbsp;&nbsp;&nbsp;<strong><cf_translate key="LB_Tramite" XmlFile="/sif/generales.xml">Tr&aacute;mite</cf_translate>:</strong> <a href="process_detail.cfm" target="detail_frame">#process.Name#, <cf_translate key="LB_Version">Versi&oacute;n</cf_translate> #Replace(Process.Version,' ','','all')#</a><br><br>
</div>
</cfoutput>

<object id="diagrama" name="diagrama" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
	codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0"
	width="950" height="300" swLiveConnect="true">
<cfoutput>
  <param name="allowScriptAccess" value="sameDomain" />
  <param name="movie" value="activities.swf?n=#Rand()#">
  <param name="quality" value="high">
  <embed src="activities.swf?n=#Rand()#" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer"
  	type="application/x-shockwave-flash" width="950" height="300" swLiveConnect="true"></embed>
</cfoutput>
</object>
<cfif IsDefined('url.ActivityId') And Len(url.ActivityId)>
	<cfoutput>
	<iframe width="950" height="350" name="detail_frame" frameborder="0" scrolling="no" style="margin:0 " src="activity_detail.cfm?k=parent&amp;ActivityId=#URLEncodedFormat(url.ActivityId)#"></iframe>
	</cfoutput>
<cfelseif IsDefined('url.TransitionId') And Len(url.TransitionId)>
	<cfoutput>
	<iframe width="950" height="350" name="detail_frame" frameborder="0" scrolling="no" style="margin:0 " src="transition_detail.cfm?k=parent&amp;TransitionId=#URLEncodedFormat(url.TransitionId)#"></iframe>
	</cfoutput>
<cfelse>
<iframe width="950" height="350" name="detail_frame" frameborder="0" scrolling="no" style="margin:0 " src="process_detail.cfm"></iframe>
</cfif>


	</cf_web_portlet>
</cf_templatearea>
</cf_template>


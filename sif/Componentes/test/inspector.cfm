<cfsetting enablecfoutputonly="yes">

<!--- package list --->
<cfparam name="url.refreshCache" default="no" type="boolean">
<cfscript>
	explorer = CreateObject( "component", "CFIDE.componentutils.cfcexplorer" ) ;
	cfcs = explorer.getcfcs(url.refreshCache) ;
	
	packages = StructNew() ;
	for ( i=1; i lte ArrayLen(cfcs); i=i+1 ) {
		if ( not StructKeyExists( packages, cfcs[i].package ) ) {
			packages[cfcs[i].package] = '' ;
		}
	}
	packages = structKeyArray(packages) ;
	arraySort(packages,"textnocase") ;
	
</cfscript>

<!--- component list --->
<cfparam name="url.package" default="">
<cfscript>
	explorer = CreateObject( "component", "CFIDE.componentutils.cfcexplorer" ) ;
	cfcs = explorer.getcfcs(false) ;
	
	components = ArrayNew(1) ;
	for ( i=1; i lte ArrayLen(cfcs); i=i+1 ) {
		if ( Len(url.package) is 0 or cfcs[i].package eq url.package ) {
			ArrayAppend( components, ListLast(cfcs[i].name,'.') & ',' & cfcs[i].name ) ;
		}
	}
	ArraySort( components, "textnocase" ) ;
</cfscript>

<cfoutput><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>Lista de componentes</title>
<style>
body,td  {
	font-family: verdana, arial, helvetica, sans-serif;
	background-color: ##FFFFFF;
	font-size: 11px;
	margin-top: 10px;
	margin-left: 10px;
}
a { color:blue}
.noprint {}
</style>
<style type="text/css" media="print">
.noprint{display:none;}
</style>
</head>
<body>


<!--- package list --->


<table border="0" width="100%" cellspacing="0" cellpadding="0"><tr><td valign="top" class="noprint" width="210">
<a href="inspector.cfm">[all components]</a>
<a href="inspector.cfm?refreshCache=yes">[refresh]</a>
<br>
<b>Packages</b><br><br>

<div style="width:210px;height:300px;overflow:auto">
<cfloop index="i" from="1" to="#ArrayLen(packages)#">
<a href="inspector.cfm?package=#packages[i]#"><cfif packages[i] eq ''>[root]<cfelse>#packages[i]#</cfif></a><br>
</cfloop>
</div>
<hr>
<!--- component list --->
<cfif IsDefined('url.package')>
	<b><cfif url.package eq ''>[root]<cfelse>#url.package#</cfif></b><br><br>
<cfelse>
	<b>All components</b><br><br>
</cfif>
<div style="width:210px;height:300px;overflow:auto">
<cfloop index="i" from="1" to="#ArrayLen(components)#">
<a href="inspector.cfm?component=#ListLast(components[i])#&amp;package=#HTMLEditFormat(url.package)#" >#ListFirst(components[i])#</a><br>
</cfloop>
</div>
</td>
  <td rowspan="2" valign="top">


<!--- component detail --->
<cfparam name="url.component" type="string" default="">
<cfif Len(url.component)>
	<cfset components = ArrayNew(1)>
	<cfset components[1] = url.component & ',' & url.component>
</cfif>

<table border="0" cellspacing="0" cellpadding="1" style="margin-left:12px " >
<tr>
  <td width="10">&nbsp;</td>
  <td width="10">&nbsp;</td>
  <td width="10">&nbsp;</td>
  <td width="900">&nbsp;</td> </tr>

<cfloop from="1" to="#ArrayLen(components)#" index="components_index">
	<cfset component_name = ListLast(components[components_index])>
	<cfset explorer = CreateObject( "component", "CFIDE.componentutils.cfcexplorer" )>
	<cfset comp = CreateObject( "component", component_name )>
	<cfset cd = GetMetadata(comp)>
	<tr><td colspan="4">
	<div style="font-size:larger;font-weight:bold;margin-top:6px">#component_name#</div>
	</td></tr>
	<cfif IsDefined('cd.properties')>
		<tr><td>&nbsp;
			</td>
		  <td colspan="3"><strong><em>Propiedades</em></strong></td>
		  </tr>
		<tr><td align="left" valign="top" nowrap   >&nbsp;</td>
			  <td align="left" valign="top" nowrap  >&nbsp;</td>
			  <td colspan="2">
			    <cfset props = StructNew()>
				<cfloop from="1" to="#ArrayLen(cd.properties)#" index="i">
					<cfset props[cd.properties[i].name] = cd.properties[i]>
				</cfloop>
				<cfset sorted_props = StructSort(props,'textnocase','asc','name')>
				<cfloop from="1" to="#ArrayLen(sorted_props)#" index="i">
					<cfset prop = props[sorted_props[i]]>
					<cfif i neq 1>, </cfif>
					<span style="white-space:nowrap">
						<cfif StructKeyExists( prop, 'type' )>#prop.type#</cfif>  <b>#prop.name#</b> 
						<cfif StructKeyExists( prop, 'displayName' ) and prop.displayName neq prop.name>(#prop.displayName#)</cfif>	
						<cfif StructKeyExists( prop, 'hint' )>
						#prop.hint#
						</cfif>			<cfif StructKeyExists( prop, 'required' ) and prop.required>
						<strong>required</strong>
						</cfif>			
						<cfif StructKeyExists( prop, 'default')>
							= <cfif IsSimpleValue(prop.default)>
								#prop.default#
							<cfelse>
								{complex value}
							</cfif>
						</cfif>
					</span>
				</cfloop>
		</td></tr>
	</cfif>
	<cfif IsDefined('cd.functions')>
		<tr><td>&nbsp;
		</td>
		  <td colspan="3"><strong><em>M&eacute;todos</em></strong></td>
		  </tr>
		
		<cfset methods = StructNew()>
		<cfloop from="1" to="#ArrayLen(cd.functions)#" index="i">
			<cfset methods[cd.functions[i].name] = cd.functions[i]>
		</cfloop>
		<cfset sorted_methods = StructSort(methods,'textnocase','asc','name')>
		<cfloop from="1" to="#ArrayLen(sorted_methods)#" index="i">
			<cfset method = methods[sorted_methods[i]]>
			
			<tr>
			  <td align="left" valign="top" nowrap style="background-color:<cfif i mod 2>##edffed<cfelse>##ededed</cfif>" >&nbsp;</td>
			  <td align="left" valign="top" nowrap style="background-color:<cfif i mod 2>##edffed<cfelse>##ededed</cfif>" >&nbsp;</td>
			  <td align="left" valign="top" nowrap style="background-color:<cfif i mod 2>##edffed<cfelse>##ededed</cfif>" >
			
			
			<cfif StructKeyExists( method, "access" )>
				<i>#lcase(method.access)#</i>
			</cfif>
			<i><cfif IsDefined('method.returnType')>#method.returnType#<cfelse>void</cfif></i>
			
			<cfif IsDefined( 'method.roles' ) and method.roles neq ''>Available only for users in one of the roles: #method.roles#<br></cfif>
			
			&nbsp;&nbsp;
			</td>
			<td align="left" valign="top"   style="background-color:<cfif i mod 2>##edffed<cfelse>##ededed</cfif>" >
			<strong>#method.name#
			<cfif StructKeyExists( method, 'access' ) and method.access is 'private'>*</cfif>
			</strong>
			<cfif IsDefined( "method.exceptions.types" ) and method.exceptions.types neq ""><i>throws</i> #method.exceptions.types#</cfif>
			</i>
			
			<!--- method description --->
			
			&nbsp;&nbsp; (
            <cfloop index="j" from="1" to="#ArrayLen(method.parameters)#">
				  <cfset param = method.parameters[j]>
				  <span style="white-space:nowrap;">
				  <i>
				  <cfif IsDefined('param.required') and param.required>required</cfif>
				  <cfif IsDefined('param.type')>#param.type#</cfif>
				  </i>
				  #param.name#<cfif IsDefined('param.default')>="#param.default#"</cfif></span><cfif j neq ArrayLen(method.parameters)>,</cfif>
			  </cfloop>	
			) 
			<cfif not IsDefined( 'method.output' ) or method.output neq false>
				  <span style="color:red;font-style:italic">(output="yes")</span>
			  </cfif></td>
			</tr>
		
		</cfloop>	
	</cfif>
</cfloop>
</table>



</td></tr>
  <tr>
    <td valign="top" class="noprint">
</td>
    </tr>
</table>
</body>
</html>
</cfoutput>
<cfsetting enablecfoutputonly="no">




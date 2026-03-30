    <cfparam name="url.modo" default="html">
    <cfif url.modo eq 'html'>
	    <cfflush interval="1">
    <cfelse>	
    	<cfset form.btnDownload=true>
    	<cf_htmlReportsHeaders filename="Reporte.xls" irA="pruebaSNVColdfusion.cfm">
    </cfif>
    
    <cfsetting requesttimeout="3600">
 	<cfset session.parche=StructNew()>
 	

<cfset session.parche.svnuser   = 'fcastro'>
<cfset session.parche.svnpasswd = Encrypt('svn-password-encrypted,' & 'fc072011', 'svn-password-encrypted')>
<cfset session.parche.reposURL  = 'http://172.20.0.53/svn/coldfusion/'>
<cfset session.parche.svnBranch = 'trunk'>
 
<cfinvoke component="asp.parches.comp.svnclient" method="get_info" wc="#session.parche.reposURL#" returnvariable="svninfo" />
<cfset session.parche.info.svnrev = svninfo.Revision>
 
 

	<cfif !isDefined("url.fecha")>
		<cfoutput>Ocupo fecha de corte dd/mm/dddd </cfoutput><cfabort>
	</cfif>


    <cfinvoke component="asp.parches.comp.svnclient"
		method="get_log"
		svnURL="http://172.20.0.53/svn/coldfusion/trunk/"
		PathFilter="/trunk/"
		fecha_desde="#LSParseDateTime(url.fecha)#"
		returnvariable="the_log" /> 

  
	<table width="100%" border="1">
		<cfoutput>
		<cfset cont=0>
		<cfloop from="1" to="#arraylen(the_log)#" index="i">

			<cfif arraylen(the_log[i].paths) gt 1>
				<cfloop from="1"  to="#arraylen(the_log[i].paths)#" index="j">
					<cfif the_log[i].paths[j].action neq 'D' and !isParchado(the_log[i].paths[j].path,the_log[i].revision)>
						<cfset cont+=1>
							<tr>
								<td>#cont#</td>
								<td>#the_log[i].author#</td>
								<td>#the_log[i].revision#</td>
								<td>#the_log[i].paths[j].path#</td>
								<td>#the_log[i].paths[j].action#</td>
								<td>#Lsdateformat(the_log[i].date,'dd/mm/yyyy')#</td>
							</tr>
					</cfif>
				</cfloop>
			<cfelse>
					<cfif the_log[i].paths[1].action neq 'D' and !isParchado(the_log[i].paths[1].path,the_log[i].revision)>
						<tr>
							<cfset cont+=1>
							<td>#cont#</td>
							<td>#the_log[i].author#</td>
							<td>#the_log[i].revision#</td>
							<td>#the_log[i].paths[1].path#</td>
							<td>#the_log[i].paths[1].action#</td>
							<td>#Lsdateformat(the_log[i].date,'dd/mm/yyyy')#</td>
						</tr>	
					</cfif>
			</cfif>
		</cfloop>
		</cfoutput>
	</table>

	<cffunction name="isParchado" returntype="boolean">
		<cfargument name="path" type="string" required="true">
		<cfargument name="rev" type="numeric" required="true">
			<cfquery datasource="asp" name="rs">
				select count(1) as valor
				from APFuente f            
				where f.nombre like '%#replace(arguments.path,'/trunk/','')#%'	
				and revision >= #arguments.rev#
			</cfquery>
		<cfreturn rs.valor gt 0>
	</cffunction>
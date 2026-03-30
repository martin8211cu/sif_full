<cfset session.parche.svnuser   = form.svnuser>
<cfset session.parche.svnpasswd = Encrypt('svn-password-encrypted,' & form.svnpasswd, 'svn-password-encrypted')>
<cfset session.parche.reposURL  = form.reposURL>
<cfset session.parche.svnBranch = form.svnBranch>

<cftry>
<cfinvoke component="asp.parches.comp.svnclient" method="get_info" wc="#session.parche.reposURL#" returnvariable="svninfo" />
<cfset session.parche.info.svnrev = svninfo.Revision>
<cflocation url="svnbuscar.cfm">
<cfcatch type="any">
	<cfset session.parche.svnuser = ''>
	<cfset session.parche.svnpasswd = ''>
	<cfset session.parche.msg = cfcatch.Message>
	<cflocation url="svnlogin.cfm?msg=1">
</cfcatch>
</cftry>

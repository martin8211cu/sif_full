<!---<cfinclude template="../../portlets/pHeaderCG.cfm">--->
<cfset Session.modulo="CG">
<cfparam default="Contabilidad General" name="title">
<cfparam default="Contabilidad General" name="moduleName">
<cfparam default="/cfmx/sif/cg/MenuCG.cfm" name="moduleRef">
<cfinclude template="/sif/portlets/pHeader.cfm">
<cfset modulo = 'MenuCG.cfm'>

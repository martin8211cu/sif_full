<cfsetting enablecfoutputonly="yes">

<!--- Creado por Gabriel Ernesto Sanchez Huerta  para  AppHost  06/09/2010 --->

<cfcontent type="text/plain; charset=ISO-8859-1">

<!---<cfcontent type="application/octetstream">--->

<cfheader name="Content-Disposition" value="attachment; filename=ErroresReversionMasiva.txt">
<cfloop index="i" from = "1"  to = "#ArrayLen(session.load_errores)#">
<cfoutput>#session.load_errores[i]#
</cfoutput>
</cfloop>

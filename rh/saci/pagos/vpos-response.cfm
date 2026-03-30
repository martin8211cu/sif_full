<!--- Recibe la respuesta del vpos/aval/banco-uno/visa --->

<cfparam name="form.SESSIONKEY" default="S14k9OUWk">
<cfparam name="form.XMLRES" default="-sin-xml-">
<cfparam name="form.DIGITALSIGN" default="-sin-firmar-">

<!---
	PAautoriza se recibe como form.convenio.
	El default de '01' representa el convenio para SACI en el ambiente
	respectivo, ya se pruebas o producción, los otros deberían especificarse por
	URL
--->

<cfparam name="form.convenio" default="01">

<cfinvoke component="vpos" method="recv" returnvariable="vpos_struct"
	PAautoriza="#form.convenio#"
	SESSIONKEY="#form.SESSIONKEY#"
	XMLRES="#form.XMLRES#"
	DIGITALSIGN="#form.DIGITALSIGN#" />

<!---<cfdump var="#vpos_struct#">--->

<cfoutput>
<a href="#HTMLEditFormat( vpos_struct.NEXTURL )##vpos_struct.PTid#">Continuar</a>
</cfoutput>
<cflocation url="#HTMLEditFormat( vpos_struct.NEXTURL )##vpos_struct.PTid#">
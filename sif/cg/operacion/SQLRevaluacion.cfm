<!--- 
	Creado por: Ana Villavicencio
	Fecha: 22 de julio del 2005
	Motivo: La consulta q realiza el proceso de Revaluación de Cuentas de Mayor
			es la llamada al componente CG_RevaluaCuentas.  Este recibe el periodo,mes 
			y la opcion de aplicar el asiento generado.
 --->
	<cfset mesL = form.mesI>
	<cfif isdefined('form.Automatico')>
		<cfset mesUlt = 12>
		<cfset annoUlt = form.periodoF>
	<cfelse>
		<cfset mesUlt = form.mesI>
		<cfset annoUlt = form.periodoI>
	</cfif>
	<cfloop index="anno" from="#form.periodoI#" to="#annoUlt#" step="1">
		<cfif annoUlt EQ anno and isdefined('form.automatico')><cfset mesult = form.mesF></cfif>
		<cfset aplicar = false>
		<cfif isdefined('form.Automatico')><cfset aplicar = true></cfif>
		<cfloop index="mes" from="#mesL#" to="#mesult#" step="1">
			 <cfinvoke 
				component="sif.Componentes.CG_RevaluaCuentas" 
				method="RevaluaCuentas" 
				returnvariable="ResultadoRC"
				periodo="#anno#"
				mes="#mes#"
				aplicar="#aplicar#"
				debug="#false#"> 
				<!---<cfdump var="#mes# #anno# #mesult# #annoUlt# "><br>--->
		</cfloop>
		<cfset mesL = 1>
	</cfloop>

<form action="Revaluacion.cfm" method="post" name="form1">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
 </form>
 
 <HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

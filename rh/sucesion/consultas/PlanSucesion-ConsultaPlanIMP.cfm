<cfquery name="data_plan" datasource="#session.DSN#">
	select *
	from RHPlanSucesion
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and   RHPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#url.RHPcodigo#">
</cfquery>
<cfif data_plan.recordcount gt 0>
	<html>
	<head>
	<title><cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<cf_templatecss>
	</head>
	<body>
	<cf_rhimprime datos="/rh/sucesion/consultas/PlanSucesion-ConsultaPlan.cfm" paramsuri="&RHPcodigo=#url.RHPcodigo#"> 
	<form name="form1">
		<table width="98%">
			<cf_sifHTML2Word>
			<tr><td><cfinclude template="PlanSucesion-ConsultaPlan.cfm"></td></tr>
			</cf_sifHTML2Word>
			<tr><td>&nbsp;</td></tr>
			<cfif not isdefined("url.sel")>
				<tr>
					<td align="center">
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Cerrar"
							Default="Cerrar"
							XmlFile="/rh/generales.xml"
							returnvariable="BTN_Cerrar"/>
	
						<input type="button" value="<cfoutput>#BTN_Cerrar#</cfoutput>" onClick="javascript: window.close();" tabindex="1">
					</td>
				</tr>
			</cfif>
		</table>
	</form>
	</body>
	</html>
<cfelse>
	<html>
	<head>
	<title><cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<cf_templatecss>
	</head>
	<body>
	<form name="form1">
		<table width="98%">
			<tr>
				<td align="center">
				<strong><cf_translate key="MSG_EstePuestoNoCuentaConUnPlanDeSucesion">Este puesto no cuenta con un plan de sucesión</cf_translate></strong>
				</td>
			</tr>
		</table>
	</form>
	</body>
	</html>
</cfif>
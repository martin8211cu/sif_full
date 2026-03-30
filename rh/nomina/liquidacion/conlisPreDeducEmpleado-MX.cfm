<!---<cf_dump var = "#url#">--->
<!--- codigo --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Lista_de_Deducciones_de_Empleado"
	Default="Lista de Deducciones de Empleado"
	returnvariable="vListaDeducciones"/>		

	<!--- Fecha --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Fecha"
		Default="Fecha"
		xmlfile="/rh/generales.xml"
		returnvariable="vFecha"/>		

	<!--- Deduccion --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Deduccion"
		Default="Deducci&oacute;n"
		xmlfile="/rh/generales.xml"
		returnvariable="vDeduccion"/>

	<!--- Valor --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Valor"
		Default="valor"
		xmlfile="/rh/generales.xml"
		returnvariable="vValor"/>

	<!--- metodo --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Metodo"
		Default="M&eacute;todo"
		xmlfile="/rh/generales.xml"
		returnvariable="vMetodo"/>


<html>
<head>
<title><cfoutput>#vListaDeducciones#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<cfif isdefined("Url.RHPLPid") and not isdefined("Form.RHPLPid")>
	<cfset Form.RHPLPid = Url.RHPLPid>
</cfif>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.RHPLPid") and Len(Trim(Form.RHPLPid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPLPid=" & Form.RHPLPid>
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	function Asignar(valor1, valor2, valor3, valor4, valor5, valor6, valor7,valor8,valor9) {
		window.opener.document.form1.Did.value = valor1;
		window.opener.document.form1.Ddescripcion.value = valor2;
		window.opener.document.form1.SNcodigo.value = valor3;
		window.opener.document.form1.SNnumero.value = valor4;
		window.opener.document.form1.SNnombre.value = valor5;
		window.opener.document.form1.referencia.value = valor6;
		window.opener.document.form1.Dmetodo.value = valor8;
		window.opener.cambiar_etiqueta(valor7,valor8,valor9);
		window.close();
	}
</script>

	<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
	  <tr>
		<td class="tituloListas" align="center"><cfoutput>#vListaDeducciones#</cfoutput></td>
	  </tr>
	</table>
	<cfquery name="rsInfonavit" datasource="#session.DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo =  2110
	</cfquery>
	<cfquery name="rsLista" datasource="#session.DSN#">
		select a.DEid, a.Did, a.Ddescripcion, a.SNcodigo, b.SNnombre, b.SNnumero,
			   case a.Dmetodo when 0 then 'Porcentaje' when 1 then 'Valor' end as Dmetodo, Dmetodo as DmetodoValor,
			   a.Dvalor, a.Dfechaini, a.Dfechafin, a.Dreferencia 
		from RHPreLiquidacionPersonal lp
			inner join DeduccionesEmpleado a
				on lp.Ecodigo = a.Ecodigo
				and lp.DEid = a.DEid
				and a.Dsaldo > 0
				and a.Dcontrolsaldo = 1
			inner join SNegocios b 
				on a.Ecodigo = b.Ecodigo 
				and a.SNcodigo = b.SNcodigo 
		where lp.RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPLPid#">
			and not TDid in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInfonavit.Pvalor#" list="yes">)
		union

		select a.DEid, a.Did, a.Ddescripcion, a.SNcodigo, b.SNnombre, b.SNnumero,
			   'Porcentaje' as Dmetodo, Dmetodo as DmetodoValor,
			   a.Dvalor, a.Dfechaini, a.Dfechafin, a.Dreferencia
		from RHPreLiquidacionPersonal lp
			inner join DeduccionesEmpleado a
				on lp.Ecodigo = a.Ecodigo
				and lp.DEid = a.DEid
				and a.Dmetodo = 0
			inner join SNegocios b 
				on a.Ecodigo = b.Ecodigo 
				and a.SNcodigo = b.SNcodigo 
		where lp.RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPLPid#">
				and not TDid in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInfonavit.Pvalor#" list="yes">)
		order by 3,2
	</cfquery>
	
	<cfinvoke 
		component="rh.Componentes.pListas"
		method="pListaQuery"
		returnvariable="pListaDed">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="Dfechaini, Ddescripcion, Dmetodo, Dvalor"/>
			<cfinvokeargument name="etiquetas" value="#vFecha#, #vDeduccion#, #vMetodo#, #vValor#"/>
			<cfinvokeargument name="formatos" value="D, V, V, M"/>
			<cfinvokeargument name="formName" value="listaDeducciones"/>	
			<cfinvokeargument name="align" value="left,left,left,right"/>
			<cfinvokeargument name="ajustar" value="N"/>				
			<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="keys" value="Did"/>
			<cfinvokeargument name="Cortes" value="SNnombre"/>
			<cfinvokeargument name="maxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="Did, Ddescripcion, SNcodigo, SNnumero, SNnombre, Dreferencia,Dmetodo,DmetodoValor,Dvalor"/>
	</cfinvoke>
</body>
</html>

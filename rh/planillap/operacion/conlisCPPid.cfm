<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Asignar(id, descripcion, inicio, fin) {
	if (window.opener != null) {
		window.opener.document.form1.CPPid.value = id;
		window.opener.document.form1.CPPdesc.value = descripcion;
		window.opener.document.form1.RHEfdesde.value = inicio;
		window.opener.document.form1.RHEfhasta.value = fin;
		if (window.opener.tipos) window.opener.tipos(id);
		window.close();
	}
}
</script>

<cfset navegacion = "">

<html>
<head>
<title>Lista de Per&iacute;odos de Presupuesto</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}" returnvariable="Lvar_Fdesde">
<cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}" returnvariable="Lvar_Fhasta">
<cf_dbfunction name="concat" args="'Presupuesto '|case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
				|' de '|case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				| ' ' | #preservesinglequotes(Lvar_Fdesde)#| ' a ' |case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				|' ' |#preservesinglequotes(Lvar_Fhasta)#" returnvariable="Lvar_descripcion" delimiters="|">
<cfquery name="rsCPPeriodos" datasource="#Session.DSN#">
	select 	CPPid, 
			CPPtipoPeriodo, 
			<cf_dbfunction name="date_format" args="CPPfechaDesde,DD/MM/YYYY"> as desde,
			<cf_dbfunction name="date_format" args="CPPfechaHasta,DD/MM/YYYY"> as hasta,
			CPPestado,
			#preservesinglequotes(Lvar_descripcion)#
			as descripcion				
	 from CPresupuestoPeriodo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by CPPfechaDesde
</cfquery>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="query" value="#rsCPPeriodos#"/>
	<cfinvokeargument name="desplegar" value="descripcion,desde,hasta"/>
	<cfinvokeargument name="etiquetas" value="Presupuesto, Fecha Inicial, Fecha Final"/>
	<cfinvokeargument name="formatos" value="S, S, S"/>
	<cfinvokeargument name="align" value="left, left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CPPid, descripcion, desde, hasta"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
</cfinvoke>

</body>
</html>
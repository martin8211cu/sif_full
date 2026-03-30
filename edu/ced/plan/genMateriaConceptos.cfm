<cfif not isdefined("Url.EPcodigo")>
	<cfparam name="Url.EPcodigo" default="15">
</cfif>
<cfif not isdefined("Url.id")>
	<cfparam name="Url.id" default="ConceptosEval">
</cfif>
<html>
<head>
<title>Cantidad de Evaluaciones a Generar</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../css/portlets.css" rel="stylesheet" type="text/css">
<link href="../css/edu.css" rel="stylesheet" type="text/css">
</head>

<body>
	<cfquery name="rsConceptos" datasource="#Session.Edu.DSN#">
		select c.ECcodigo, c.ECnombre, convert(varchar, b.EPCporcentaje, 1) as EPCporcentaje
		from EvaluacionPlanConcepto b, EvaluacionConcepto c
		where b.EPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.EPcodigo#">
		and b.ECcodigo = c.ECcodigo
		order by c.ECorden
	</cfquery>

<script language="JavaScript" type="text/javascript">
	function Asignar() {
		var elem = "";
		if (document.form1.ECcodigo.value != null) {
			elem += document.form1.ECcodigo.value + "," + document.form1.cantidad.value;
		} else {
			for (var i = 0; i < document.form1.ECcodigo.length; i++) {
				if (elem != "") elem += ";";
				elem += document.form1.ECcodigo[i].value + "," + document.form1.cantidad[i].value;
			}
		}
		window.opener.document.<cfoutput>#Url.form#.#Url.id#</cfoutput>.value = elem;
		window.close();
	}
</script>

<form name="form1">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  	<cfoutput query="rsConceptos">
    <tr>
      <td>#ECnombre#</td>
      <td>#EPCporcentaje# %</td>
      <td>
	  	<input type="hidden" name="ECcodigo" value="#ECcodigo#">
	  	<input type="text" name="cantidad" value="1">
	  </td>
    </tr>
	</cfoutput>
	<tr>
		<td colspan="3" align="center"><input type="button" name="btnAceptar" value="Aceptar" onClick="javascript: Asignar();"></td>
	</tr>
  </table>
</form>
</body>
</html>

<html>
<head>
<title>Lista de Cuentas de Mayor</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<cfif isdefined("Url.form") and not isdefined("Form.form")>
	<cfset Form.form = Url.form>
</cfif>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.form") and Len(Trim(Form.form)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "form=" & Form.form>
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	function Asignar(valor1, valor2, valor3) {
		window.opener.document.<cfoutput>#Form.form#</cfoutput>.Cmayor.value = valor1;
		window.opener.document.<cfoutput>#Form.form#</cfoutput>.Cdescripcion.value = valor2;
		window.opener.document.<cfoutput>#Form.form#</cfoutput>.PCEMid.value = valor3;
		window.close();
	}
</script>

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pLista"
 returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="CtasMayor a"/>
	<cfinvokeargument name="columnas" value="a.Cmayor, a.PCEMid, a.Cdescripcion, a.Ctipo, a.Cbalancen, a.Cmascara"/>
		<cfinvokeargument name="desplegar" value="Cmayor, Cdescripcion"/>
		<cfinvokeargument name="etiquetas" value="Cuenta, Descripción"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#
											  and a.PCEMid is not null
											  and exists(
												select 1
												from PRJparametros r, PCECatalogo s, PCNivelMascara t
												where r.Ecodigo = #Session.Ecodigo#
												and r.PCEcatidProyecto = s.PCEcatid
												and s.PCEcatid = t.PCEcatid
												and t.PCEMid = a.PCEMid
											  )
											  and exists(
												select 1
												from PRJparametros r, PCECatalogo s, PCNivelMascara t
												where r.Ecodigo = #Session.Ecodigo#
												and r.PCEcatidRecurso = s.PCEcatid
												and s.PCEcatid = t.PCEcatid
												and t.PCEMid = a.PCEMid
											  )
											  #filtro#
											  order by Cmayor"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
	<cfinvokeargument name="formName" value="listaCuentas"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="Cmayor, Cdescripcion, PCEMid"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>

</body>
</html>

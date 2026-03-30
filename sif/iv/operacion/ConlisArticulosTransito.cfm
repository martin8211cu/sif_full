<html>
<head>
<title>Lista de Artículos en Tránsito</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
</head>

<script language="JavaScript1.2">
function Asignar(id, desc, Aid, Tcantidad, Ddocumento, Ucodigo, Tembarque, Acodigo, Adescripcion, Saldo) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Url.form#.#Url.id#.value = id;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		window.opener.document.#Url.form#.#Url.Aid#.value = Aid;
		window.opener.document.#Url.form#.#Url.Tcantidad#.value = Saldo;
		window.opener.document.#Url.form#.#Url.Ddocumento#.value = Ddocumento;
		window.opener.document.#Url.form#.#Url.Ucodigo#.value = Ucodigo;
		window.opener.document.#Url.form#.#Url.DRTembarque#.value = Tembarque;
		window.opener.document.#Url.form#.#Url.Acodigo#.value = Acodigo;
		window.opener.document.#Url.form#.#Url.Adescripcion#.value = Adescripcion;
		window.opener.document.#Url.form#.Saldo.value = Saldo;
		</cfoutput>
		window.close();
	}
}
</script>

<body>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name="to_char"	args="t.Tid"  returnvariable="Tid">
<cf_dbfunction name="to_char"	args="t.Aid"  returnvariable="Aid">
<cf_dbfunction name="sPart"		args="a.Adescripcion,1,32" returnvariable="Adescripcion">
<cf_dbfunction name="length"	args="rtrim(a.Adescripcion)" returnvariable="lenAdescripcion">
	<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="Transito t, Articulos a"/>
		<cfinvokeargument name="Conexion" value="minisif_marcel"/>
		<cfinvokeargument name="columnas" value="#PreserveSingleQuotes(Tid)# as Tid, t.DDdocref, #PreserveSingleQuotes(Aid)# as Aid, t.Acodigo, 
										t.Tfecha, t.Tcantidad, t.Ddocumento, 
										case when #PreserveSingleQuotes(lenAdescripcion)# >= 35 then #PreserveSingleQuotes(Adescripcion)# #_Cat# '...' 
											 when #PreserveSingleQuotes(lenAdescripcion)# < 35  then a.Adescripcion end as Adescripcion
										, Adescripcion as Adescripcion2, (t.Tcantidad - t.Trecibido) as Saldo										
										, a.Ucodigo, t.Tembarque, a.Acodigo, t.Trecibido"/>
		<cfinvokeargument name="desplegar" value="Acodigo,Adescripcion,Ddocumento,Tembarque,Tcantidad,Trecibido"/>
		<cfinvokeargument name="etiquetas" value="Código,Artículo,Documento,Embarque,Cantidad,Recibido"/>
		<cfinvokeargument name="formatos" value="S,S,S,S,I,I"/>
		<cfinvokeargument name="filtro" value=" t.Ecodigo = #Session.Ecodigo#
											  and t.Ecodigo = a.Ecodigo
											  and t.Aid = a.Aid
											  and (t.Tcantidad - t.Trecibido) > 0
											order by t.Tfecha "/>
		<cfinvokeargument name="align" value="left, left, left, left, right, right"/>
		<cfinvokeargument name="ajustar" value="N,N,N,N,N,N"/>
		<cfinvokeargument name="irA" value="RecibeTransito.cfm"/>
		<cfinvokeargument name="maxrows" value="10"/>
		<cfinvokeargument name="formName" value="lista"/>
		<cfinvokeargument name="funcion" value="Asignar"/>
		<cfinvokeargument name="fparams" value="Tid, DDdocref, Aid, Tcantidad, Ddocumento, Ucodigo, Tembarque, Acodigo, Adescripcion2, Saldo"/>		
	</cfinvoke>
</body>
</html>
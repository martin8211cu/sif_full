<html>
<head>
<title>Listado de Temarios y Evaluaciones por Profesor</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../../css/edu.css" type="text/css">
</head>

<body>
	<cfinvoke 
	 component="edu.Componentes.usuarios"
	 method="get_usuario_by_cod"
	 returnvariable="usr">
		<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
		<cfinvokeargument name="sistema" value="edu"/>
		<cfinvokeargument name="Usucodigo" value="#Session.Edu.Usucodigo#"/>
		<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
		<cfinvokeargument name="roles" value="edu.docente"/>
	</cfinvoke>

	<cfquery datasource="#Session.Edu.DSN#" name="rsProfesor">
		select convert(varchar,Splaza) as Splaza
			, (Papellido1 + ' ' 
			+ Papellido2 + ','
			+ Pnombre) as nombre 
		from 	PersonaEducativo a
				, Staff b 
		where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and a.persona=b.persona 
			and a.CEcodigo=b.CEcodigo 
			and b.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
			and b.retirado = 0 
			and b.autorizado = 1 
		order by nombre 
	</cfquery>

	<cfinclude template="/edu/docencia/consultas/formListaTemariosEvalXProf.cfm">
</body>
</html>
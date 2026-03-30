<!---Esta Parte si esta Fijo Para Activos Fijos si en algun momento se va a configurara otro modulo, habria que Cambiar esto--->
<cfquery name="CategoriaClase" datasource="#session.dsn#">
	select a.Aid AF, b.ACatId AF_CATEGOR, c.AClaId AF_CLASIFI
		from Activos a
			inner join ACategoria b
				on a.Ecodigo = b.Ecodigo
				and a.ACcodigo = b.ACcodigo
			inner join AClasificacion c
				on a.Ecodigo = c.Ecodigo
				and a.ACcodigo = c.ACcodigo
				and a.ACid = c.ACid
		where Aid = #URl.CEVidTabla#
</cfquery>

<cfset Tipificacion = StructNew()>
<cfset temp = StructInsert(Tipificacion, "AF", "")> 
<cfset temp = StructInsert(Tipificacion, "AF_CATEGOR", "#CategoriaClase.AF_CATEGOR#")> 
<cfset temp = StructInsert(Tipificacion, "AF_CLASIFI", "#CategoriaClase.AF_CLASIFI#")> 

<cfinvoke component="sif.Componentes.DatosVariables" method="GETVALOR" returnvariable="CamposForm">
	<cfinvokeargument name="DVTcodigoValor" value="AF">
	<cfinvokeargument name="Tipificacion"   value="#Tipificacion#">
	<cfinvokeargument name="DVVidTablaVal"  value="#CategoriaClase.AF#">
	<cfinvokeargument name="EsEvento"  		value="true">
</cfinvoke>
<script language="javascript" type="text/javascript">
	window.parent.document.form1.TEVid.options.length = <cfoutput>#CamposForm.recordCount#</cfoutput>;
	window.parent.document.form1.TEVid.options[0] = new Option("Elija el Tipo de Evento","", true);
</script>
<cfloop query="CamposForm">
	<script language="javascript" type="text/javascript">	 
		window.parent.document.form1.TEVid.options[<cfoutput>#CamposForm.currentrow#</cfoutput>] = new Option("<cfoutput>#CamposForm.TEVDescripcion#</cfoutput>","<cfoutput>#CamposForm.TEVid#</cfoutput>", false);
	</script>
</cfloop>

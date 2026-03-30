<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Importar Catalogos" returnvariable="LB_Title"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Archivo" Default="Selecciones un archivo para importar:" returnvariable="LB_Archivo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Method" Default="M&eacute;todo:" returnvariable="LB_Method"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Msg1" Default="Actualizar Existentes y Agregar Nuevos" returnvariable="LB_Msg1"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Msg2" Default="Solo Actualizar Existentes" returnvariable="LB_Msg2"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Msg3" Default="Solo Agregar Nuevos" returnvariable="LB_Msg3"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Msg4" Default="Reemplazar todo" returnvariable="LB_Msg4"/>


<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
		<div align="center">
			<form action="Importar_form.cfm" onsubmit="return validate(this);" method="post" enctype="multipart/form-data">
				<cfoutput>#LB_Archivo#</cfoutput> 
				<input type="file" name="fileToUpload" id="fileToUpload" accept="text/plain, .txt"required>
				<cfoutput>#LB_Method#</cfoutput> 
				<select name="method" required>
					<option value="full"><cfoutput>#LB_Msg1#</cfoutput></option>
					<option value="update"><cfoutput>#LB_Msg2#</cfoutput></option>
					<option value="add"><cfoutput>#LB_Msg3#</cfoutput></option>
					<option value="replace"><cfoutput>#LB_Msg4#</cfoutput></option>
				</select>
				<br/>
				<input type="submit" value="Upload" name="submit">
			</form>
		</div>
	<cf_web_portlet_end>
<cf_templatefooter>

<script>
function validate(form) {
	console.log(window.b = form);
	var methodMsg = "";
	switch (document.getElementsByName('method')[0].value){
		case "full": 	methodMsg = "<cfoutput>#LB_Msg1#</cfoutput>"; 	break;
		case "update": 	methodMsg = "<cfoutput>#LB_Msg2#</cfoutput>";	break;
		case "add": 	methodMsg = "<cfoutput>#LB_Msg3#</cfoutput>";	break;
		case "replace": methodMsg = "<cfoutput>#LB_Msg4#</cfoutput>";	break;
	}
    return confirm("Esta seguro de que quiere ["+methodMsg+"]?");
}
</script>

<cfif isdefined('form.FILETOUPLOAD')>
	<cftry>
		<cfscript>
			myfile = FileRead("#form.FILETOUPLOAD#"); 
			record=deserializeJSON(myfile);
		</cfscript>
	<cfcatch>
		<cfthrow message = "Archivo da&ntilde;ado, no se puede cargar.">
	</cfcatch>
	</cftry>
	<cfset componentPath = "crc.Componentes.TransferData">
	<cfset componentOBJ = createObject("component","#componentPath#")>
	<cfset result = componentOBJ.Importar(
			json = "#record#"
		,	method = "#form.method#"
	)>
	<script>
		alert("Se ha importado con exito");
	</script>
</cfif>
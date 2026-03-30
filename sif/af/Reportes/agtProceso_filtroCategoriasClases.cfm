<cfscript>
//Procesa los datos del filtro cuando vienen en url
if (isdefined("url.ACcodigodesde") and len(trim(url.ACcodigodesde))) ACcodigodesde = url.ACcodigodesde;
if (isdefined("url.ACcodigohasta") and len(trim(url.ACcodigohasta))) ACcodigohasta = url.ACcodigohasta;
//Procesa los datos del filtro cuando vienen en form
if (isdefined("form.ACcodigodesde") and len(trim(form.ACcodigodesde))) ACcodigodesde = form.ACcodigodesde;
if (isdefined("form.ACcodigohasta") and len(trim(form.ACcodigohasta))) ACcodigohasta = form.ACcodigohasta;
//Procesa los datos para crear el filtro y la navegacion
if (isdefined("ACcodigodesde") and len(trim(ACcodigodesde))) { filtro = filtro & " and a.ACcodigodesde = #ACcodigodesde#"; navegacion = navegacion & "&ACcodigodesde=#ACcodigodesde#";}
if (isdefined("ACcodigohasta") and len(trim(ACcodigohasta))) { filtro = filtro & " and a.ACcodigohasta = #ACcodigohasta#"; navegacion = navegacion & "&ACcodigohasta=#ACcodigohasta#";}
</cfscript>
<!---Consultas para pintar el formulario--->

<!---Categorias--->
<cfquery name="rsCategorias" datasource="#Session.DSN#">
	select ACcodigo, ACdescripcion, ACmascara
	from ACategoria 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by ACcodigo
</cfquery>

<!---Pinta el Formulario del filtro--->
<cfoutput>
<form action="#CurrentPage#" method="post" name="form1" style="margin:0" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin:0" class="tituloListas">
  <tr>
    <td align="center">
			<table border="0" cellspacing="0" cellpadding="0" style="margin:0">
				<tr>
					<td nowrap="nowrap" align="right"><strong>Categoría Inicial:</strong>&nbsp;</td>
					<td>
					<cf_conlis
						campos="ACcodigodesde, ACcodigodescdesde, ACdescripciondesde"
						desplegables="N,S,S"
						modificables="N,S,N"
						size="0,20,60"
						title="Lista de Categor&iacute;as"
						tabla="ACategoria"
						columnas="ACcodigo as ACcodigodesde, ACcodigodesc as ACcodigodescdesde, ACdescripcion as ACdescripciondesde"
						filtro="Ecodigo=#SESSION.ECODIGO#"
						desplegar="ACcodigodescdesde, ACdescripciondesde"
						filtrar_por="ACcodigodesc, ACdescripcion"
						etiquetas="Código, Descripción"
						formatos="S,S"
						align="left,left"
						asignar="ACcodigodesde, ACcodigodescdesde, ACdescripciondesde"
						asignarformatos="S, S, S"
						showEmptyListMsg="true"
						EmptyListMsg="-- No se encontrarón Categor&iacute;as --"
						tabindex="1">
					<!---<select name="FCategoriaInicial" onChange="procEst();"><option value="0"></option><cfloop query="rsCategorias"><option value="#ACcodigo#" <cfif (isdefined("FAGTPcategoria") and len(trim(FAGTPcategoria)) and FAGTPcategoria eq ACcodigo)>selected</cfif>>#ACdescripcion#</option></cfloop></select>--->
					</td>
				</tr>
				
				<tr>					
					<td nowrap="nowrap" align="right"><strong>Categoría Final:</strong>&nbsp;</td>
					<td>
					<cf_conlis
						campos="ACcodigohasta, ACcodigodeschasta, ACdescripcionhasta"
						desplegables="N,S,S"
						modificables="N,S,N"
						size="0,20,60"
						title="Lista de Categor&iacute;as"
						tabla="ACategoria"
						columnas="ACcodigo as ACcodigohasta, ACcodigodesc as ACcodigodeschasta, ACdescripcion as ACdescripcionhasta"
						filtro="Ecodigo=#SESSION.ECODIGO# and ACcodigodesc >= $ACcodigodescdesde,varchar$"
						desplegar="ACcodigodeschasta, ACdescripcionhasta"
						filtrar_por="ACcodigodesc, ACdescripcion"
						etiquetas="Código, Descripción"
						formatos="S,S"
						align="left,left"
						asignar="ACcodigohasta, ACcodigodeschasta, ACdescripcionhasta"
						asignarformatos="S, S, S"
						showEmptyListMsg="true"
						EmptyListMsg="-- No se encontrarón Categor&iacute;as --"
						tabindex="1">
					<!---<select name="FCategoriaFinal" onChange="procEst();"><option value="0"></option><cfloop query="rsCategorias"><option value="#ACcodigo#" <cfif (isdefined("FAGTPcategoria") and len(trim(FAGTPcategoria)) and FAGTPcategoria eq ACcodigo)>selected</cfif>>#ACdescripcion#</option></cfloop></select>--->
					</td>
				</tr>

				<tr>
					<td align="right" align="right"><strong>Formato:</strong>&nbsp;</td>
					<td>
						<select name="Formato" tabindex="1">
							<option value="1">HTML</option>
							<option value="2">Exportar a Excel</option>
							<option value="3">Exportar Archivo Plano</option>
						</select> 
					</td>
				</tr>
				
				<tr>
					<td align="center" colspan="2"><cf_botones values="Generar"></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</cfoutput>
<!---Funciones en Javascript del formulario de filtro--->
<script language="javascript" type="text/javascript">
	<!--//
	function _forminit(){
		var form = document.form1;
		form.ACcodigodesde.focus();
	}
	//_forminit();
	//-->
</script>

<cfset modo = "ALTA">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr> 		
		<td class="tituloAlterno" width="50%" valign="top"><div align="center">Clasificaci&oacute;n</div></td>
		<td class="tituloAlterno" width="50%" valign="top"><div align="center">Clasificaciones Asignadas</div></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr> 		
		<td width="50%" valign="top">
		<cfoutput>
		<form method="post" name="form1" action="Clasificacion-Custodia-sql.cfm">

			<table width="100%">
				<tr>
					<td width="15%"><strong>Categor&iacute;a:</strong></td>
					<td>
						<!--- Categoría --->
						<cfset ValuesArray=ArrayNew(1)>
						<cfif (modo neq "ALTA")>
							<cfset ArrayAppend(ValuesArray,rsForm.ACcodigo)>
							<cfset ArrayAppend(ValuesArray,rsForm.ACcodigodesc)>
							<cfset ArrayAppend(ValuesArray,rsForm.ACdescripcion)>
							<cfset ArrayAppend(ValuesArray,rsForm.ACmascara)>
						</cfif>								
						
						<cf_conlis
							Campos="ACcodigo, ACcodigodesc, ACdescripcion, ACmascara"
							Desplegables="N,S,S,N"
							Modificables="N,S,N,N"
							Size="0,10,40,0"
							ValuesArray="#ValuesArray#"
							Title="Lista de Categor&iacute;as"
							Tabla="ACategoria"
							Columnas="ACcodigo, ACcodigodesc, ACdescripcion, ACmascara"
							Filtro="Ecodigo = #Session.Ecodigo# order by ACcodigodesc, ACdescripcion"
							Desplegar="ACcodigodesc, ACdescripcion"
							Etiquetas="C&oacute;digo,Descripci&oacute;n"
							filtrar_por="ACcodigodesc, ACdescripcion"
							Formatos="S,S"
							Align="left,left"
							Asignar="ACcodigo, ACcodigodesc, ACdescripcion, ACmascara"
							Asignarformatos="I,S,S,S"
									funcion="resetClase"
							tabindex="1"/>						
					</td>
				</tr>
			
				<tr>
					<td width="15%"><strong>Clase:</strong></td>
					<td>
						<!--- Clasificación --->
						<cfset ValuesArray=ArrayNew(1)>
						<cfif (modo neq "ALTA")>
							<cfset ArrayAppend(ValuesArray,rsForm.ACid)>
							<cfset ArrayAppend(ValuesArray,rsForm.Cat_ACcodigodesc)>
							<cfset ArrayAppend(ValuesArray,rsForm.Cat_ACdescripcion)>
						</cfif>					
						
						<cf_conlis
							Campos="ACid, Cat_ACcodigodesc, Cat_ACdescripcion"
							Desplegables="N,S,S"
							Modificables="N,S,N"
							Size="0,10,40"
							ValuesArray="#ValuesArray#"
							Title="Lista de Clases"
							Tabla="AClasificacion"
							Columnas="ACid, ACcodigodesc as Cat_ACcodigodesc, ACdescripcion as Cat_ACdescripcion"
							Filtro="Ecodigo = #Session.Ecodigo# and ACcodigo = $ACcodigo,numeric$ order by Cat_ACcodigodesc, Cat_ACdescripcion"
							Desplegar="Cat_ACcodigodesc, Cat_ACdescripcion"
							Etiquetas="C&oacute;digo,Descripci&oacute;n"
							filtrar_por="ACcodigodesc, ACdescripcion"
							Formatos="S,S"
							Align="left,left"
							Asignar="ACid, Cat_ACcodigodesc, Cat_ACdescripcion"
							Asignarformatos="I,S,S"
							tabindex="1"/>						
					</td>
				</tr>
			</table>
			<br>
			<center>
			<cf_botones values="Agregar" tabindex="1">
			</center>
			<input type="hidden" name="modo" value="ALTA" tabindex="-1">
			<input type="hidden" name="CRCCid" value="#form.CRCCid#" tabindex="-1">
			<input type="hidden" name="tab" value="#form.tab#" tabindex="-1">			
		</form>
		</cfoutput>
		</td> 
		<td width="50%" valign="top">
			<cfinclude template="Clasificacion-Custodia-form.cfm">
		</td>
	</tr> 
</table>

<script language="javascript1.2" type="text/javascript">	

	function funcAgregar() {		
		var valido=true;
		if (trim(document.form1.ACid.value) == '') {
			alert('Debe de ingresar una clasificación.');
			valido=false;
		}
		if (trim(document.form1.ACcodigo.value) == '') {
			alert('Debe de ingresar una categoría.');
			valido=false;
		}
		if (valido) {
			valida=true;
			return true;
		 }
		else{
			return false;
		}
	}
</script>

<script language="javascript">
	document.form1.ACcodigodesc.focus();
</script>
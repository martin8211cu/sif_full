<cfset MaxItems = 15>
<br>
<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0"><tr><td>
<cfoutput>
<form action="vistas-sql.cfm" method="post" name="form1">
	<input type="hidden" name="id_vista" value="#form.id_vista#">
	<input type="hidden" name="id_tipo" value="#form.id_tipo#">
	<input type="hidden" name="maxitems" value="#MaxItems#">
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td class="TituloSub">
				#rsVista.titulo_vista#
			</td>
		</tr>
	</table>
	<br>
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="2">
	<cfquery name="rsVistaEnc" dbtype="query">
		select * from rsVista where es_encabezado = 1
	</cfquery>
	<cfloop query="rsVistaEnc">
		<tr>
			<td width="1%" nowrap >
				<strong>#etiqueta_campo#&nbsp;:&nbsp;</strong>
			</td>
			<td width="99%" align="left">
				<cf_tipo clase_tipo="#clase_tipo#" name="c_#id_tipo#_#id_campo#" 
					id_tipo="#id_tipo#" id_tipocampo="#id_tipocampo#" 
					tipo_dato="#tipo_dato#" mascara="#mascara#" 
					formato="#formato#" valor_minimo="#valor_minimo#" 
					valor_maximo="#valor_maximo#" longitud="#longitud#" 
					escala="#escala#" nombre_tabla="#nombre_tabla#">
			</td>
		</tr>
	</cfloop>
	</table>
	<br>
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="2">
	<cfquery name="rsVistaDet" dbtype="query">
		select * from rsVista where es_encabezado = 0
	</cfquery>
	<tr class="TituloListas">
		<td class="TituloListas" width="1%">
			<strong>Persona</strong>
		</td>
		<cfloop query="rsVistaDet">
			<td class="TituloListas" width="1%">
				<strong>#etiqueta_campo#</strong>
			</td>
		</cfloop>
	</tr>
	<cfloop from="1" to="#MaxItems#" index="i">
	<tr>
		<td width="1%">
			<cf_persona index="#i#">
		</td>
		<cfloop query="rsVistaDet">
			<td width="1%">
				<cf_tipo clase_tipo="#clase_tipo#" name="c_#id_tipo#_#id_campo#_#i#" 
					id_tipo="#id_tipo#" id_tipocampo="#id_tipocampo#" 
					tipo_dato="#tipo_dato#" mascara="#mascara#" 
					formato="#formato#" valor_minimo="#valor_minimo#" 
					valor_maximo="#valor_maximo#" longitud="#longitud#" 
					escala="#escala#" nombre_tabla="#nombre_tabla#">
			</td>
		</cfloop>
	</tr>
	</cfloop>
	<tr><td colspan="#rsVistaDet.recordcount+1#">&nbsp;</td></tr>
	<tr><td colspan="#rsVistaDet.recordcount+1#"><cf_botones values="Agregar"></td></tr>
	</table>
	<br>
</form>
<cf_qforms>
<script language="javascript" type="text/javascript">
	//descripciones
	<cfloop query="rsVistaEnc">
		objForm.c_#id_tipo#_#id_campo#.description = "#JSStringFormat(etiqueta_campo)#";
	</cfloop>
	<cfloop from="1" to="#MaxItems#" index="i">
		objForm.id_tipoident#i#.description = "#JSStringFormat('Tipo de Identificación')#";
		objForm.id_persona#i#.description = "#JSStringFormat('Identificación')#";
		<cfloop query="rsVistaDet">
			objForm.c_#id_tipo#_#id_campo#_#i#.description = "#JSStringFormat(etiqueta_campo)#";
		</cfloop>
	</cfloop>
	
	//validaciones
	function funcAgregar(){
		<cfloop query="rsVistaEnc">
			objForm.c_#id_tipo#_#id_campo#.required = true;
		</cfloop>
		<cfloop from="1" to="#MaxItems#" index="i">
			if (objForm.id_persona#i#.getValue()!='') {
				<cfloop query="rsVistaDet">
					<cfif rsVistaDet.es_obligatorio EQ 1 and rsVistaDet.tipo_dato neq "B">
						objForm.c_#id_tipo#_#id_campo#_#i#.required = true;
					<cfelse>
						objForm.c_#id_tipo#_#id_campo#_#i#.required = false;
					</cfif>
				</cfloop>
			}
			else {
				<cfloop query="rsVistaDet">
					objForm.c_#id_tipo#_#id_campo#_#i#.required = false;
				</cfloop>
			}
		</cfloop>
	}
</script>
</cfoutput>
</td></tr></table>
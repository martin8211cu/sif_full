<cfif not isdefined("form.Aid") or len(trim(form.Aid)) eq 0>
	<cflocation addtoken="no" url="/sif/iv/catalogos/Articulos.cfm">
</cfif>

<cfquery name="rsArticulo" datasource="#Session.DSN#">
	select Aid, Acodigo, Adescripcion 
	from Articulos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
</cfquery>


<script language="JavaScript1.4" type="text/javascript">
	var boton = "";
	function setBtnBorra(button){
		boton = button.name;
	}
	
	function funcRegresar(){
		boton = 'Regresar';
	}
	
	function validar(form){
		if ((boton != 'btnEliminar') && (boton != 'Regresar')){
			if ( form.FiletoUpload.value == ""){
				alert("Se presentaron los siguientes errores:\n\n  - La imagen  es requerida.");
				return false;
			}
		}

		return true;
	}

</script>

<form name="form1" action="SQLImgArticulos.cfm" method="post" onSubmit="javascript: return validar(this);" enctype="multipart/form-data">
	<cfoutput>
		<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
		<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">		
		<input type="hidden" name="filtro_Acodigo" value="<cfif isdefined('form.filtro_Acodigo') and form.filtro_Acodigo NEQ ''>#form.filtro_Acodigo#</cfif>">
		<input type="hidden" name="filtro_Acodalterno" value="<cfif isdefined('form.filtro_Acodalterno') and form.filtro_Acodalterno NEQ ''>#form.filtro_Acodalterno#</cfif>">
		<input type="hidden" name="filtro_Adescripcion" value="<cfif isdefined('form.filtro_Adescripcion') and form.filtro_Adescripcion NEQ ''>#form.filtro_Adescripcion#</cfif>">		
		<input type="hidden" name="Aid" value="#form.Aid#">
	</cfoutput>
	<table width="100%">
		<tr><td colspan="3" align="center"><cfinclude template="articulos-link.cfm"></td></tr>
		<tr>
			<td width="15%">&nbsp;</td>
			<td>
				<cfquery name="rsImagenes" datasource="#Session.DSN#">
					select a.Aid, a.ILinea
					from ImagenArt a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
				</cfquery>
				<!--- Generación de Thumbs --->
				<table border="0" cellpadding="0" cellspacing="0">
					<tr><td nowrap colspan="2"><strong>Im&aacute;genes asociadas al art&iacute;culo</strong><hr size="1"></td></tr>
					<cfloop query="rsImagenes">
						<tr><td><a href="#" onclick="<cfoutput>javascript:document.form1.imPreview.src=document.form1.Img#rsImagenes.ILinea#.src</cfoutput>">
						<cf_sifleerimagen autosize="false" border="false"  tabla="ImagenArt" campo="IAimagen" condicion="Ecodigo = #Session.Ecodigo# and Aid = #form.Aid# and ILinea = #rsImagenes.ILinea#" conexion="#Session.DSN#" imgname="Img#rsImagenes.ILinea#" width="80" height="60">
						</a>
						</td>
						<cfoutput>
						<td>&nbsp;<input type="submit" name="btnEliminar" value="Borrar" onclick="javascript:setBtnBorra(this);document.form1.ILinea.value='#rsImagenes.ILinea#';return confirm('¿Desea Eliminar la Imagen?');"> </td>
						</cfoutput>
						</tr>
					</cfloop>
				</table>  
			</td>
			
			<td valign="top">
				<table width="75%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F5F5F5">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td align="right"><strong><font size="2">Art&iacute;culo:&nbsp;</font></strong>
						<td>&nbsp;&nbsp;<cfoutput><font size="2">#rsArticulo.Acodigo# - #rsArticulo.Adescripcion#</font>
						</cfoutput></td>
					</tr>

					<tr>
						<td align="right" bgcolor="#F5F5F5" valign="top"><font size="2"><strong>Imagen:&nbsp;</strong></font></td>
						<td bgcolor="#F5F5F5" valign="top">
							<input type="file" name="FiletoUpload" size="45">
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2" align="center" nowrap>
						<cf_Botones modo="ALTA" exclude="Limpiar" include="Regresar" includevalues="Regresar" tabindex="1">
					</td></tr>
				</table>
			</td>
		</tr>
	</table>

	<input type="hidden" name="ILinea" value="">
	<input type="hidden" name="imPreview" value="">

</form>
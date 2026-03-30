<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Codigo = t.Translate('LB_Egresos','Codigo','/home/menu/GrpModulos.xml')>
<cfset LB_Sistema = t.Translate('LB_Sistema','Sistema','/home/menu/GrpModulos.xml')>
<cfset LB_Descripcion = t.Translate('LB_Descripcion','Descripcion','/home/menu/GrpModulos.xml')>
<cfset LB_Orden = t.Translate('LB_Orden','Orden','/home/menu/GrpModulos.xml')>
<cfset LB_Logo = t.Translate('LB_Logo','Logo','/home/menu/GrpModulos.xml')>
<cfset LB_Icon = t.Translate('LB_Icon','Clase del IconFonts','/home/menu/GrpModulos.xml')>
<cfset LB_Hablada = t.Translate('LB_Hablada','Informacion','/home/menu/GrpModulos.xml')>
<cfset LB_HabladaInfo = t.Translate('LB_HabladaInfo','El texto ingresado aqu&iacute;, ser&aacute; mostrado en el men&uacute;.','/home/menu/GrpModulos.xml')>

<cfset modo = "ALTA">
<cfif isdefined("Form.SGcodigo")>
	<cfset modo = "CAMBIO">
</cfif>


<!--- codigos que ya existen --->
<cfquery name="rsCodigos" datasource="asp">
	select SGcodigo
	from SGModulos
	<cfif modo neq 'ALTA'>
		where SGcodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="#form.SGcodigo#">
	</cfif>
	order by SGcodigo
</cfquery>

<!--- RsSistemas --->
<cfquery datasource="asp" name="rsSistemas">
   select SSorden, rtrim(a.SScodigo) as SScodigo, a.SSdescripcion
	from SSistemas a
	where 1=1 order by SSorden, SScodigo, SSdescripcion
</cfquery>

<cfif modo EQ "CAMBIO">
	<!--- Valida que el grupo de modulo se pueda eliminar --->
	<cfquery name="rsvalidaDelet" datasource="asp">
		select distinct SGdescripcion
			from SGModulos sg
			inner join SModulos sm
				on sm.SGcodigo = sg.SGcodigo
		where sg.SGcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SGcodigo#">
	</cfquery>
</cfif>

<form name="frmSistemas" action="GrpModulos-sql.cfm" method="post" enctype="multipart/form-data">
	<cfif isdefined("Form.PageNum")>
		<input type="hidden" name="Pagina" value="">
	</cfif>
	<table width="100%">
		<tr>
	        <td align="right" class="etiquetaCampo"><cfoutput>#LB_Codigo#</cfoutput></td>
			<td align="left">
				<cfif modo EQ "CAMBIO">
					<span><cfoutput>#Form.SGcodigo#</cfoutput></span>
					<input name="SGcodigo" type="hidden" id="SGcodigo" value="<cfoutput>#Form.SGcodigo#</cfoutput>">
				<cfelse>
					<input name="SGcodigo_text" type="text" id="SGcodigo_text" size="10" maxlength="10"  onBlur="codigos(this);" onFocus="this.select();" required>
				</cfif>
			</td>
	    </tr>
	    <tr>
	        <td align="right" class="etiquetaCampo"><cfoutput>#LB_Sistema#</cfoutput> </td>
			<td align="left">
				<select  name="SScodigo" id="SScodigo" required>
					<option value="<cfif modo EQ 'CAMBIO'><cfoutput> #Form.SScodigo# </cfoutput></cfif>"><cfif modo EQ 'CAMBIO'><cfoutput> #Form.SScodigo# </cfoutput><cfelse>Elige el sistema</cfif></option>
					<cfoutput query="rsSistemas">
					     <option value="#rsSistemas.SScodigo#">#rsSistemas.SScodigo#</option>
					</cfoutput> <!--Fin del iteracion --->
				</select>
			</td>
		</tr>
		<tr>
			<td align="right" class="etiquetaCampo"><cfoutput>#LB_Descripcion#</cfoutput></td>
			<td align="left">
				<input name="SGdescripcion" type="text" id="SGdescripcion" value="<cfif modo EQ 'CAMBIO'><cfoutput> #Form.SGdescripcion# </cfoutput></cfif>"
						size="30" maxlength="50" onFocus="this.select();" required></td>
		</tr>
		<tr>
			<td align="right" class="etiquetaCampo"><cfoutput>#LB_Orden#</cfoutput>: </td>
			<td align="left">
				<input name="SSorden" type="text" style="text-align: right;" onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0);"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
					value="<cfif modo EQ 'CAMBIO'><cfoutput> #Form.SGorden# </cfoutput></cfif>" size="5" maxlength="4" >
				<input name="SSorden_2" type="hidden" value="<cfif modo EQ 'CAMBIO'></cfif>" >
			</td>
		</tr>
		<tr>
			<td align="right" class="etiquetaCampo"><cfoutput>#LB_Logo#</cfoutput>: </td>
			<td align="left">
				<input name="logo" type="file" id="logo" onChange="previewLogo(this.value)">
			</td>
		</tr>
		<tr>
			<td align="right" class="etiquetaCampo"><cfoutput>#LB_Icon#</cfoutput>: </td>
			<td align="left"><input name="SGicon" type="text" id="SGicon" size="40" maxlength="50" onFocus="this.select();"value="<cfif modo EQ 'CAMBIO'><cfoutput> #Form.IconFonts# </cfoutput></cfif>" ></td>
		</tr>
		<tr>
			<td align="right" valign="top" class="etiquetaCampo"><cfoutput>#LB_Hablada#</cfoutput>: </td>
			<td align="left">
				<textarea class="textarea" name="SGhablada" cols="33" rows="8" onFocus="this.select();"></textarea>
				<br><b><cfoutput>#LB_HabladaInfo#</cfoutput>:</b>
				<p><cfif modo EQ 'CAMBIO'><cfoutput> #Form.SGhablada# </cfoutput></cfif></p>
			</td>
		</tr>
		 <tr>
		    <td colspan="2" align="center">
				<cfif modo EQ "CAMBIO">
					<input type="submit" name="btnCambiar" value="Actualizar">
					<cfif rsvalidaDelet.RecordCount eq 0>
					<input type="submit" name="btnEliminar" value="Eliminar" onClick="javascript: if (confirm('¿Está seguro de que desea eliminar este sistema?')) { deshabilitarValidacion(); return true; } else return false;">
					</cfif>
					<input type="button" name="btnNuevo" value="Nuevo" onClick="location.href='GrpModulos.cfm'">
				<cfelse>
					<input type="submit" name="btnAgregar" value="Agregar">
				</cfif>
			</td>
      	</tr>
	</table>
</form>

<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("frmSistemas");

	<cfif modo EQ "ALTA">
		document.getElementById("SGcodigo_text").required = true;
		document.getElementById("SScodigo").required = true;
		document.getElementById("SGdescripcion").required = true;
	</cfif>

	function deshabilitarValidacion() {
		document.getElementById("SScodigo").required = false;
	}

	function codigos(obj){
		if (obj.value != "") {
			var dato    = obj.value;
			var temp    = new String();
			<cfloop query="rsCodigos">
				temp = '<cfoutput>#rsCodigos.SGcodigo#</cfoutput>';
				if (dato.toUpperCase() == temp.toUpperCase()){
					alert('El Código de Sistema ya existe.');
					obj.value = "";
					obj.focus();
					return false;
				}
			</cfloop>
		}
		return true;
	}
</script>

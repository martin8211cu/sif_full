
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif isdefined("url.pcodigo") and Len("url.pcodigo") gt 0>
	<cfset form.pcodigo = url.pcodigo >
</cfif>

<cfif isdefined("Session.Ecodigo") and isdefined("Form.pcodigo") and not isDefined("Form.Nuevo")>
	<cfset modo="CAMBIO">
</cfif>

<cfif modo eq "CAMBIO">
	<cfquery name="rsParametro" datasource="#Session.DSN#">
		SELECT Pcodigo,Pvalor,Pdescripcion,Pcategoria,
		       TipoDato,TipoParametro,Parametros
		FROM RHParametros
		WHERE Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		<cfif isdefined("Form.pcodigo") and form.pcodigo neq "">
			and Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.pcodigo#">
		</cfif>
	</cfquery>
	
</cfif>

<cfquery name="rsCategorias" datasource="#session.dsn#">
	select distinct(pCategoria) pCategoria
	from RHParametros
	where Ecodigo = #Session.Ecodigo#
		and Adicional = 1
</cfquery>

<cfoutput>


<!--- <form method="post" name="form1" action="parametros_config-tab-sql.cfm"> --->
	<table align="center" width="100%" cellpadding="1" cellspacing="0">
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">Codigo</cf_translate>:&nbsp;</td>
			<td>
				<input type="text" name="c_Pcodigo" tabindex="1"
				value="<cfif modo NEQ "ALTA">#rsParametro.Pcodigo#</cfif>"
				<cfif modo eq "CAMBIO"> readonly = "true"</cfif>
				size="20" maxlength="50" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
			<td>
				<input type="text" name="Pdescripcion" tabindex="1"
				value="<cfif modo NEQ "ALTA">#rsParametro.Pdescripcion#</cfif>"
				size="50" maxlength="150" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_Categoria" XmlFile="/rh/generales.xml">Categoria</cf_translate>:&nbsp;</td>
			<td>
              <select tabindex="1" onchange="Categoria(this.value);">
			  	<option value="">Nueva Categoria</option>
                <cfloop query="rsCategorias">
                  <option value="#trim(rsCategorias.pCategoria)#"
						<cfif (MODO neq "ALTA") and (trim(rsParametro.pCategoria) eq trim(rsCategorias.pCategoria))>selected</cfif>
							>#rsCategorias.pCategoria#</option>
                </cfloop>
              </select>
				<input type="text" name="Pcategoria" tabindex="1"
				value="<cfif modo NEQ "ALTA">#rsParametro.Pcategoria#</cfif>"
				<cfif modo NEQ "ALTA">style="display:none;"</cfif>
				size="20" maxlength="150" onfocus="javascript:this.select();" >
			</td>
		</tr>
		
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_TipoDato" XmlFile="/rh/generales.xml">Tipo de Dato</cf_translate>:&nbsp;</td>
			<td>
				<select name="TipoDato">
					<option value="T" <cfif modo NEQ "ALTA" and rsParametro.TipoDato eq "T"> selected='true'</cfif>>Texto </option>
					<option value="A" <cfif modo NEQ "ALTA" and rsParametro.TipoDato eq "A"> selected='true'</cfif>>Texto Grande</option>
					<option value="B" <cfif modo NEQ "ALTA" and rsParametro.TipoDato eq "B"> selected='true'</cfif>>Boleano </option>
					<option value="E" <cfif modo NEQ "ALTA" and rsParametro.TipoDato eq "E"> selected='true'</cfif>>Numero entero </option>
					<option value="D" <cfif modo NEQ "ALTA" and rsParametro.TipoDato eq "D"> selected='true'</cfif>>Numero con Decimales </option>
					<option value="F" <cfif modo NEQ "ALTA" and rsParametro.TipoDato eq "F"> selected='true'</cfif>>Fecha </option>
				</select>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_TipoParamero" XmlFile="/rh/generales.xml">Tipo de Parametro</cf_translate>:&nbsp;</td>
			<td>
				<select name="TipoParametro">
					<option value="F" <cfif modo NEQ "ALTA" and rsParametro.TipoParametro eq "F"> selected='true'</cfif>>Fijo</option>
					<option value="R" <cfif modo NEQ "ALTA" and rsParametro.TipoParametro eq "R"> selected='true'</cfif>>Rango</option>
					<option value="L" <cfif modo NEQ "ALTA" and rsParametro.TipoParametro eq "L"> selected='true'</cfif>>Lista</option>
					<option value="Q" <cfif modo NEQ "ALTA" and rsParametro.TipoParametro eq "Q"> selected='true'</cfif>>Consulta</option>
					<option value="P" <cfif modo NEQ "ALTA" and rsParametro.TipoParametro eq "P"> selected='true'</cfif>>Personalizado</option>
				</select>
			</td>
		</tr>
		<tr>
			<td nowrap align="right"><cf_translate key="LB_ValorMin" XmlFile="/rh/generales.xml">Parametros</cf_translate>:&nbsp;</td>
			<td>
				<input type="text" name="Parametros" tabindex="1"
				value="<cfif modo NEQ "ALTA">#rsParametro.Parametros#</cfif>"
				size="40" maxlength="500" onfocus="javascript:this.select();" >
			</td>
		</tr>
		</tr>
		<tr valign="baseline">
			<td colspan="2" align="right" nowrap>
				<div align="center">
					<script language="JavaScript" type="text/javascript">
						// Funciones para Manejo de Botones
						botonActual = "";

						function setBtn(obj) {
							botonActual = obj.name;
						}
						function btnSelected(name, f) {
							if (f != null) {
								return (f["botonSel"].value == name)
							} else {
								return (botonActual == name)
							}
						}
					</script>

					<input tabindex="-1" type="hidden" name="botonSel" value="">
					<input tabindex="-1" name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
					<cfif modo eq 'ALTA'>					
							<cf_botones default="false" include="AgregaConfiguracion" exclude="ALTA">
					<cfelse>
						<cf_botones modo="CAMBIO" include="ModificarConfiguracion,EliminaConfiguracion" exclude="CAMBIO,BAJA">
					</cfif>
				</div>
			</td>
		</tr>
		<tr>
		  <td>&nbsp;</td>
		</tr>
		<tr valign="baseline">
			<input tabindex="-1" type="hidden" name="pcodigo" value="<cfif modo NEQ "ALTA">#rsParametro.pcodigo#</cfif>">
			<input tabindex="-1" type="hidden" name="Pagina"
			value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">
			<cfif modo NEQ "ALTA">
				<td colspan="2" align="right" nowrap>
					<div align="center">
					</div>
				</td>
			</cfif>
		</tr>
	</table>
<!--- </form> --->
</cfoutput>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Descripcion" Default="Descripcion" XmlFile="/rh/generales.xml" returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Codigo" Default="Codigo" XmlFile="/rh/generales.xml" returnvariable="MSG_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Categoria" Default="Catagoria" XmlFile="/rh/generales.xml" returnvariable="MSG_Categoria"/>


<script>
	function Categoria(cat){
		console.log(cat);
		if(cat == ''){
			document.form1.Pcategoria.style.display = 'inline';
		}else{
			document.form1.Pcategoria.style.display = 'none';
		}
		document.form1.Pcategoria.value = cat;
	}
	function funcAgregar(){
		return validarForm();
	}

	function validarForm(){
		var msg = 'Solucione los siguientes problemas:'
		var result = true;
		var form = document.form1;

		if(form.Pcategoria.value == ''){msg += '\n- La Categoria no puede ser estar en blanco'; result = false;}
		
		if(!result){
			alert(msg);
		}

		return result;
	}

</script>

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

<cfif isdefined("url.id") and Len("url.id") gt 0>
	<cfset form.id = url.id >
</cfif>

<cfif isdefined("Session.Ecodigo") and isdefined("Form.id") and not isDefined("Form.Nuevo")>
	<cfset modo="CAMBIO">
</cfif>

<cfif modo eq "CAMBIO">
	<cfquery name="rsParametro" datasource="#Session.DSN#">
		SELECT id,Pcodigo,Mcodigo,Pvalor,Pdescripcion,Pcategoria,
		       TipoDato,TipoParametro,Parametros,PSistema,PEspecial
		FROM CRCParametros
		WHERE Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		<cfif isdefined("Form.id") and form.id neq "">
			and id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
		</cfif>
	</cfquery>
	
</cfif>

<cfquery name="rsModulos" datasource="asp">
	select m.SMcodigo, m.SMdescripcion
	from SModulos m
	inner join ModulosCuentaE ce
		on m.SScodigo = ce.SScodigo
		and m.SMcodigo = ce.SMcodigo
	where m.SScodigo = 'CRED'
		and ce.CEcodigo = #Session.CEcodigo#
</cfquery>

<cfquery name="rsCategorias" datasource="#session.dsn#">
	select distinct(pCategoria) pCategoria
	from CRCParametros
	where Ecodigo = #Session.Ecodigo#
</cfquery>



<SCRIPT SRC="../../js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</SCRIPT>

<script language="JavaScript">

	function deshabilitarValidacion(){
		objForm.Pcodigo.required = false;
		objForm.Pdescripcion.required = false;
	}

</script>
<cfoutput>


<!---Redireccion ConfiguracionParametros_sql.cfm --->
<form method="post" name="form1" action="ConfiguracionParametros_sql.cfm">
	<table align="center" width="100%" cellpadding="1" cellspacing="0">
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_Codigo" XmlFile="/crc/generales.xml">Codigo</cf_translate>:&nbsp;</td>
			<td>
				<input type="text" name="Pcodigo" tabindex="1"
				value="<cfif modo NEQ "ALTA">#rsParametro.Pcodigo#</cfif>"
				<cfif modo eq "CAMBIO"> readonly = "true"</cfif>
				size="20" maxlength="50" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_Descripcion" XmlFile="/crc/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
			<td>
				<input type="text" name="Pdescripcion" tabindex="1"
				value="<cfif modo NEQ "ALTA">#rsParametro.Pdescripcion#</cfif>"
				size="50" maxlength="150" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_Categoria" XmlFile="/crc/generales.xml">Categoria</cf_translate>:&nbsp;</td>
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
		<tr>
			<td align="right" nowrap><cf_translate key="LB_Categoria">Modulo</cf_translate>:&nbsp;</td>
			<td>
              <select name="Mcodigo"  tabindex="1">
                <cfloop query="rsModulos">
                  <option value="#trim(rsModulos.SMcodigo)#"
						<cfif (MODO neq "ALTA") and (trim(rsParametro.Mcodigo) eq trim(rsModulos.SMcodigo))>selected</cfif>
							>#rsModulos.SMdescripcion#</option>
                </cfloop>
              </select>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_Valor" XmlFile="/crc/generales.xml">Valor por Defecto</cf_translate>:&nbsp;</td>
			<td>
				<input type="text" name="Pvalor" tabindex="1"
				value="<cfif modo NEQ "ALTA">#rsParametro.Pvalor#</cfif>"
				size="20" maxlength="100" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_TipoDato" XmlFile="/crc/generales.xml">Tipo de Dato</cf_translate>:&nbsp;</td>
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
			<td nowrap align="right"><cf_translate key="LB_TipoParamero" XmlFile="/crc/generales.xml">Tipo de Parametro</cf_translate>:&nbsp;</td>
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
			<td nowrap align="right"><cf_translate key="LB_ValorMin" XmlFile="/crc/generales.xml">Parametros</cf_translate>:&nbsp;</td>
			<td>
				<input type="text" name="Parametros" tabindex="1"
				value="<cfif modo NEQ "ALTA">#rsParametro.Parametros#</cfif>"
				size="40" maxlength="500" onfocus="javascript:this.select();" >
			</td>
		</tr>
		</tr>
		<tr>
			<td nowrap align="right"><cf_translate key="LB_PSistema" XmlFile="/crc/generales.xml">Par&aacute;metro de Sistema</cf_translate>:&nbsp;</td>
			<td>
				<input type="checkbox" name="PSistema" tabindex="1" <cfif modo NEQ "ALTA" && rsParametro.PSistema eq 1>checked</cfif>>
			</td>
		</tr>
		<tr>
			<td nowrap align="right"><cf_translate key="LB_PEspecial" XmlFile="/crc/generales.xml">Par&aacute;metro Especial</cf_translate>:&nbsp;</td>
			<td>
				<input type="checkbox" name="PEspecial" tabindex="1" <cfif modo NEQ "ALTA" && rsParametro.PEspecial eq 1>checked</cfif>>
			</td>
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
							<cf_botones modo="ALTA">
					<cfelse>
						<cf_botones modo="CAMBIO">
					</cfif>
				</div>
			</td>
		</tr>
		<tr>
		  <td>&nbsp;</td>
		</tr>
		<tr valign="baseline">
			<input tabindex="-1" type="hidden" name="id" value="<cfif modo NEQ "ALTA">#rsParametro.id#</cfif>">
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
</form>
</cfoutput>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Descripcion" Default="Descripcion" XmlFile="/crc/generales.xml" returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Codigo" Default="Codigo" XmlFile="/crc/generales.xml" returnvariable="MSG_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Categoria" Default="Catagoria" XmlFile="/crc/generales.xml" returnvariable="MSG_Categoria"/>

<cf_qforms>
	<cf_qformsRequiredField name="Pcodigo" description="#MSG_Codigo#">
	<cf_qformsRequiredField name="Pdescripcion" description="#MSG_Descripcion#">
</cf_qforms>

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
<cfset mododet = "ALTA">
<cfif isdefined("form.id_atributo") and len(trim(form.id_atributo)) and form.id_atributo>
	<cfset mododet = "CAMBIO">
</cfif>

<!--- Seccion del detalle --->
<cfif modoDet NEQ 'ALTA'>
	
	<cfif isdefined("Form.id_atributo") and len(trim(Form.id_atributo))neq 0>
		<!--- 1. Form --->	
		<cfquery datasource="#Session.Edu.DSN#" name="rsMAAtributo">
			select b.id_atributo,  substring(nombre_atributo,1,35) as nombre_atributo, orden_atributo , tipo_atributo
			from MATipoDocumento a, MAAtributo b 
			where b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
			  and a.id_tipo = b.id_tipo
			<cfif isdefined("Form.id_tipo") AND len(trim(Form.id_tipo))neq 0>
			  and b.id_tipo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
			</cfif>
			<cfif isdefined("Form.id_atributo") AND len(trim(Form.id_atributo))neq 0>
			  and b.id_atributo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_atributo#">
			</cfif>
		</cfquery>
	</cfif>

</cfif>

<cfif modo NEQ 'ALTA' and isdefined("Form.id_tipo") and len(trim(Form.id_tipo))>
	<cfif modoDet NEQ 'ALTA' and isdefined("form.id_tipo") and len(trim(form.id_tipo)) >
		
		<cfquery datasource="#Session.Edu.DSN#" name="rsHayMAAtributoDocumento">
			<!--- Existen dependencias con MAAtributoDocumento--->
			select isnull(1,0) from MAAtributoDocumento a, MAAtributo b
			where a.id_atributo= <cfqueryparam value="#form.id_atributo#" cfsqltype="cf_sql_numeric">
			  and b.id_tipo= <cfqueryparam value="#form.id_tipo#" cfsqltype="cf_sql_numeric">
			  and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
		</cfquery> 
		
	</cfif>
	
</cfif>	


<cfoutput>

<cfif modo NEQ "ALTA" and isdefined("Form.id_tipo")>
	<input type="hidden" name="HayMADocumento" value="#rsHayMADocumento.recordCount#" >
</cfif>
<cfif modoDet NEQ 'ALTA' and isdefined("form.id_tipo")>
	<input type="hidden" name="HayMAAtributoDocumento" value="<cfif #rsHayMAAtributoDocumento.recordCount# GT 0>#rsHayMAAtributoDocumento.recordCount#<cfelse>0</cfif>">
 </cfif>
<cfif modo NEQ "ALTA" and isdefined("Form.id_tipo")>
	<input type="hidden" name="HayMADocumento" value="#rsHayMADocumento.recordCount#" >
</cfif>
<input name="id_atributo" id="id_atributo" value="<cfif (mododet NEQ 'ALTA')>#Form.id_atributo#</cfif>" type="hidden">
<input name="Pagina2" id="Pagina2" value="#Form.Pagina2#" type="hidden">
<input name="Filtro_nombre_atr" id="Filtro_nombre_atr" value="#Form.Filtro_nombre_atr#" type="hidden">
<input name="Filtro_TipoAtr" id="Filtro_TipoAtr" value="#Form.Filtro_TipoAtr#" type="hidden">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	
	<tr> 
	  <td align="right" nowrap>Nombre:&nbsp;</td>
	  <td nowrap><input name="nombre_atributo" type="text" id="nombre_atributo" tabindex="1" size="30" maxlength="80" onfocus="javascript:this.select();" value="<cfif modoDet NEQ 'ALTA'><cfoutput>#rsMAAtributo.nombre_atributo#</cfoutput></cfif>"></td>
	</tr>
	
	<tr> 
		<td align="right" nowrap>Tipo:&nbsp;</td>
		<td nowrap> 
			<cfif 	isdefined("Form.id_atributo") and isdefined("rsMAAtributo") and #rsMAAtributo.RecordCount# GT 0>
				<input type="hidden" name="tipo_atributo_ant" value="<cfif #rsMAAtributo.RecordCount# GT 0><cfoutput>#rsMAAtributo.tipo_atributo#</cfoutput></cfif>">
			</cfif>
			<select name="tipo_atributo" id="tipo_atributo" tabindex="1"  onchange="Javascript: es_valor();">
              <option value="N" <cfif modoDet NEQ 'ALTA' and #rsMAAtributo.tipo_atributo# EQ "N">selected</cfif>>Numérico</option>
              <option value="T" <cfif modoDet NEQ 'ALTA' and #rsMAAtributo.tipo_atributo# EQ "T">selected</cfif>>Text</option>
              <option value="F" <cfif modoDet NEQ 'ALTA' and #rsMAAtributo.tipo_atributo# EQ "F">selected</cfif>>Fecha</option>
              <option value="V" <cfif modoDet NEQ 'ALTA' and  #rsMAAtributo.tipo_atributo# EQ "V">selected</cfif>>Valores</option>
            </select>
			<!--- <cfif modoDet NEQ "ALTA" and #rsMAAtributo.tipo_atributo# EQ "V"> --->
			<cfif modoDet NEQ "ALTA">
				<input name="btnValores" id="btnValores" type="button" value="Valores" onClick="javascript:doConlisMantValores();">
			</cfif>	
		</td>
	</tr>
	
	<tr> 
	  <td align="right" nowrap>Orden:&nbsp;</td>
	  <td nowrap> <cfoutput> 
		  <input name="orden_atributo" align="left" type="text" id="orden_atributo" size="8" maxlength="8" value="<cfif modoDet NEQ "ALTA">#rsMAAtributo.orden_atributo#</cfif>" onfocus="this.value=qf(this); this.select();" onblur="fm(this,0);"  onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
		</cfoutput>		</td>
	</tr>
	
</table>
</cfoutput>


<cfquery datasource="#session.tramites.dsn#" name="tipoIdent">
	select a.id_tipo,
		   b.id_campo,	 
		   b.nombre_campo, 
		   c.clase_tipo, 
		   c.tipo_dato, 
		   c.mascara, 
		   c.formato, 
		   c.valor_minimo, 
		   c.valor_maximo, 
		   c.longitud, 
		   c.escala, 
		   c.nombre_tabla,
		   b.id_tipocampo,
		   b.es_obligatorio

	from TPTipoIdent a
		join DDTipoCampo b
			on b.id_tipo = a.id_tipo
		join DDTipo c
			on c.id_tipo = b.id_tipocampo

	where id_tipoident = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tipoident#">
</cfquery>

<cfquery name="registro" datasource="#session.tramites.dsn#" maxrows="1">
	select ddr.id_registro
	from DDRegistro ddr
	where ddr.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tipoIdent.id_tipo#" >
	and ddr.id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_persona#" >
</cfquery>

<cfoutput>

<input type="hidden" name="id_registro" value="<cfif len(trim(registro.id_registro))>#registro.id_registro#<cfelse>0</cfif>">
<input type="hidden" name="id_tipo" value="#tipoIdent.id_tipo#">
<cfloop query="tipoIdent">
	<cfquery name="valor" datasource="#session.tramites.dsn#">
		select ddc.id_campo, ddc.valor, ddc.valor_ref
		from DDCampo ddc
		where ddc.id_registro = <cfif len(trim(registro.id_registro))><cfqueryparam cfsqltype="cf_sql_numeric" value="#registro.id_registro#" ><cfelse>0</cfif>
		  and ddc.id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tipoIdent.id_campo#" >
	</cfquery>
	
	<cfif tipoIdent.es_obligatorio eq 1 >
		<cfset validacion = validacion &" if( f.C_#id_campo#.value == '' ){msj += ' - El campo #JSStringFormat(tipoIdent.nombre_campo)# es requerido.\n';}" >
	</cfif>
	
	<input type="hidden" name="id_campo" value="#tipoIdent.id_campo#">
	<tr>
		<td>#tipoIdent.nombre_campo#</td>
		<td>
			<cf_tipo clase_tipo="#tipoIdent.clase_tipo#" 
					 name="C_#tipoIdent.id_campo#" 
					 form="form2"
					 id_tipo="#tipoIdent.id_tipo#" 
					 id_tipocampo="#tipoIdent.id_tipocampo#" 
					 tipo_dato="#tipoIdent.tipo_dato#" 
					 mascara="#tipoIdent.mascara#" 
					 formato="#tipoIdent.formato#" 
					 valor_minimo="#tipoIdent.valor_minimo#" 
					 valor_maximo="#tipoIdent.valor_maximo#" 
					 longitud="#tipoIdent.longitud#" 
					 escala="#tipoIdent.escala#" 
					 nombre_tabla="#tipoIdent.nombre_tabla#"
					 value="#trim(valor.valor)#"
					 valueid="#trim(valor.valor_ref)#">	
		</td>
	</tr>
</cfloop>
</cfoutput>
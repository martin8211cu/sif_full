
<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 24 de febrero del 2006
	Motivo: Se agrego un trim en el la variable del documento para eliminar espacios en blanco.

 --->
<cfif isdefined("Url.SNcodigo") and not isdefined("Form.SNcodigo")>
	<cfparam name="Form.SNcodigo" default="#Url.SNcodigo#">
</cfif>

<cfif isdefined("Url.DocumentoC") and not isdefined("Form.DocumentoC")>
	<cfparam name="Form.DocumentoC" default="#trim(Url.DocumentoC)#">
</cfif>

<cfif isdefined("url.dato") and Len(Trim(url.dato))>
<cf_dbfunction name="concat" args="rtrim(b.CCTcodigo+'-'+rtrim(a.Ddocumento)+'-'+c.Mnombre)" delimiters= "+"  returnvariable="Descripcion">
	<cfquery name="rs" datasource="#url.conexion#">	
		select a.CCTcodigo, rtrim(a.Ddocumento) as Ddocumento, a.Mcodigo,  a.Ccuenta, a.Dtipocambio, a.Dfecha, 
			   a.Dvencimiento, a.Dtotal, a.Dsaldo,
			   #PreserveSingleQuotes(Descripcion)# as Descripcion, c.Mnombre
		from Documentos a, CCTransacciones b, Monedas c
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
		  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#"> 
		  and b.CCTtipo = 'D'
		  and a.Ecodigo = b.Ecodigo
		  and a.CCTcodigo = b.CCTcodigo 
		  and a.Ecodigo = c.Ecodigo
		  and a.Mcodigo = c.Mcodigo
		<cfif isdefined("url.dato") and (Len(Trim(url.dato)) NEQ 0) and (url.dato NEQ "-1")>
			and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TRIM(url.dato)#">
		</cfif>
		<cfif isdefined("Form.DocumentoC") and (Len(Trim(Form.DocumentoC)) NEQ 0)>
		  and upper(ltrim(rtrim(a.Ddocumento))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(trim(Form.DocumentoC))#">
		</cfif>
		order by Dvencimiento asc
	</cfquery>	
	<script language="JavaScript"> 
		var descAnt = parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value.toUpperCase();
		
		<!--- parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.Descripcion#</cfoutput>"; --->
		parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#TRIM(rs.Ddocumento)#</cfoutput>";
		// si el valor devuelto por el "rs" es diferente al que se digitó en el conlis... entonces limpia el conlis con la funcion limpiarDocsReferenciaCxC
		if (descAnt != parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value.toUpperCase() && parent.limpiarDocsReferenciaCxC) {
			parent.limpiarDocsReferenciaCxC();
		}
	</script>
</cfif>



	

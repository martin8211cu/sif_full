<!--- Modo del pintado de los campos     --->
<!--- pinta los campos según 3 estados   --->
<!--- si hay el catalogo que buscamos esta en la tabla  OrigenDocumentos  pinta un combo las cuentas en   OrigenCtaMayor--->
<!--- si sucede lo anterior y ademas el catalogo que buscamos tambien se encuentra la tabla OrigenNivelProv  se agrega un campo imput --->
<!--- si susede solamente el 2 caso se pinta una lista de la cuentas localizadas en  OrigenNivelProv y se les agrega un imput a cada una   --->

<!--- ABG: Obtiene el rutatag del valor para obtener codigos mas legibles para el usuario--->
<cfquery name="rsrutatag" datasource="sifcontrol">
    select rutatag
    from OrigenTablaProv
    where OPtabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OPtabla_F#">
</cfquery>

<cfif compareNocase('rhcfuncional', rsrutatag.rutatag) eq 0>
    <cfquery name="rsComplemento" datasource="#Session.dsn#">
        select CFcodigo as Codigo
        from CFuncional
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">
        and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ODchar_F#">
    </cfquery>
<cfelseif compareNocase('sifalmacen', rsrutatag.rutatag) eq 0>
     <cfquery name="rsComplemento" datasource="#Session.dsn#">
        select Almcodigo as Codigo
        from Almacen
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">
        and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ODchar_F#">
    </cfquery>    
<cfelseif compareNocase('sifarticulos', rsrutatag.rutatag) eq 0>
    <cfquery name="rsComplemento" datasource="#Session.dsn#">
        select Acodigo as Codigo
        from Articulos
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">
        and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ODchar_F#">
    </cfquery>    
<cfelseif compareNocase('sifmonedas', rsrutatag.rutatag) eq 0>
    <cfquery name="rsComplemento" datasource="#Session.dsn#">
        select Miso4217 as Codigo
        from Monedas
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">
        and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ODchar_F#">
    </cfquery>  
<cfelseif compareNocase('sifsociosnegocios2', rsrutatag.rutatag) eq 0>
    <cfquery name="rsComplemento" datasource="#Session.dsn#">
        select SNnumero as Codigo
        from SNegocios
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">
        and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ODchar_F#">
    </cfquery> 
<cfelseif compareNocase('sifactivo', rsrutatag.rutatag) eq 0>
    <cfquery name="rsComplemento" datasource="#Session.dsn#">
        select ACcodigo as Codigo
        from Activos
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">
        and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ODchar_F#">
    </cfquery> 
<cfelseif compareNocase('sifoficinas', rsrutatag.rutatag) eq 0>
    <cfquery name="rsComplemento" datasource="#Session.dsn#">
        select Oficodigo as Codigo
        from Oficinas
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">
        and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ODchar_F#">
    </cfquery>
<cfelseif compareNocase('sifconceptos', rsrutatag.rutatag) eq 0>
    <cfquery name="rsComplemento" datasource="#Session.dsn#">
        select Ccodigo as Codigo
        from Conceptos 
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">
        and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ODchar_F#">
    </cfquery>
<cfelseif compareNocase('siftransaccionescc', rsrutatag.rutatag) eq 0>
    <cfset varCodigo = "#form.ODchar_F#">
<cfelseif compareNocase('siftransaccionescp', rsrutatag.rutatag) eq 0>
    <cfset varCodigo = "#form.ODchar_F#">
<cfelseif compareNocase('sifbancos', rsrutatag.rutatag) eq 0>
    <cfquery name="rsComplemento" datasource="#Session.dsn#">
        select Bdescripcion as Codigo
        from Bancos 
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">
        and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ODchar_F#">
    </cfquery>
<cfelseif compareNocase('siftransaccionesmb', rsrutatag.rutatag) eq 0>
    <cfquery name="rsComplemento" datasource="#Session.dsn#">
        select BTcodigo as Codigo
        from BTransacciones 
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">
        and BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ODchar_F#">
    </cfquery>
<cfelseif compareNocase('sifclasificacionconcepto', rsrutatag.rutatag) eq 0>
     <cfquery name="rsComplemento" datasource="#Session.dsn#">
        select CCcodigo as Codigo
        from CConceptos 
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">
        and CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ODchar_F#">
    </cfquery>
<cfelse>
    <cfset varCodigo = "#form.ODchar_F#">
</cfif>
<cfif isdefined("rsComplemento")>
    <cfset varCodigo = rsComplemento.Codigo>
</cfif>

<form method="post" name="form1"  action="SQLMantComp_Finacieros.cfm">

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td  style="background-color:#CCCCCC" align="center" colspan="3">
			<cfoutput>
			<!---<strong><font size="2">#form.OPtabla_F#:&nbsp;#form.ODchar_F#</font></strong>--->
            <strong><font size="2">#form.OPtabla_F#:&nbsp;#varCodigo#</font></strong> <!---ABG Se muestra el codigo obtenido--->
			</cfoutput></td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>				</table> 
	<cf_sifcomplementofinanciero action='display'
		tabla="#form.OPtabla_F#"
		llave="#form.ODchar_F#" /> 
	<center>	
				<input type="submit" name="Alta" value="Guardar">
				<input type="submit" name="Baja" value="Borrar">
		</center>
</form>

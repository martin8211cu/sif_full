<cfparam name="url.src_r1" type="integer">
<cfparam name="url.src_r2" type="integer">
<cfparam name="url.src_c1" type="integer">
<cfparam name="url.src_c2" type="integer">
<cfparam name="url.dst_r1" type="integer">
<cfparam name="url.dst_r2" type="integer">
<cfparam name="url.dst_c1" type="integer">
<cfparam name="url.dst_c2" type="integer">
<cfparam name="url.mod_con" default="">
<cfparam name="url.sel_con">
<cfparam name="url.mod_mes" default="">
<cfparam name="url.sel_mes_modo" default="R">
<cfparam name="url.sel_mes_rel"  default="0">
<cfparam name="url.sel_mes_fijo" default="1">
<cfparam name="url.sel_mes_ano"  default="0">

<cfparam name="url.mod_ANubica" default="">
<cfparam name="Url.ANubicaTipo" default="">
<cfparam name="Url.ANubicaEcodigo">
<cfparam name="Url.ANubicaGEid">
<cfparam name="Url.ANubicaGOid">
<cfparam name="Url.ANubicaOcodigo">

<cfparam name="url.sel_Hojasrc">
<cfparam name="url.sel_Hojadst">

<cfquery name="rsConceptos" datasource="#Session.dsn#">
	SELECT CAcodigo, CAdescripcion
	FROM ConceptoAnexos 
	ORDER BY CAcodigo
</cfquery>
<cfquery name="rsOficinas" datasource="#Session.dsn#">
	SELECT Ocodigo, Odescripcion
	FROM Oficinas 
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	ORDER BY Odescripcion
</cfquery>
<cfquery name="rsEmpresas" datasource="#session.dsn#">
	SELECT Ecodigo, Edescripcion
	FROM Empresas
	WHERE cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	ORDER BY Edescripcion
</cfquery>
<cfquery datasource="#session.dsn#" name="porcopiar">
	select
		src.AnexoRan as src_ran, src.AnexoFila as src_fil, src.AnexoColumna as src_col,
		dst.AnexoRan as dst_ran, dst.AnexoFila as dst_fil, dst.AnexoColumna as dst_col,
		(select count(1)
			from AnexoCelD srcd
			where srcd.AnexoCelId = src.AnexoCelId) as cant_src,
		(select count(1)
			from AnexoCelD dstd
			where dstd.AnexoCelId = dst.AnexoCelId) as cant_dst
	from AnexoCel src, AnexoCel dst
	where src.AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
	  and src.AnexoHoja = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.sel_Hojasrc#">

	  and dst.AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
	  and dst.AnexoHoja = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.sel_Hojadst#">

	  and src.AnexoFila    between <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.src_r1#">
	                       and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.src_r2#">
	  and src.AnexoColumna between <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.src_c1#">
	                       and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.src_c2#">
	  and dst.AnexoFila    between <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.dst_r1#">
	                       and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.dst_r2#">
	  and dst.AnexoColumna between <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.dst_c1#">
	                       and     <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.dst_c2#">
	  and src.AnexoFila    - dst.AnexoFila    = 
	  		<cfqueryparam cfsqltype="cf_sql_numeric" value="# url.src_r1 - url.dst_r1 #">
	  and src.AnexoColumna - dst.AnexoColumna = 
	  		<cfqueryparam cfsqltype="cf_sql_numeric" value="# url.src_c1 - url.dst_c1 #">
	order by src_fil, src_col
</cfquery>
<script type="text/javascript" src="../../../js/sinbotones.js"></script>

<cfscript>
	letras = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	function NombreColumna(n) {
		if(n LT 1) {
			return n;
		} else if(n LT (26+1)) {
			return Mid(letras,n,1);
		} else if (n LT (26*27+1)){
			return Mid(letras, int(n / 26), 1) & Mid(letras, n mod 26 + 1, 1);
		} else {
			return n;
		}
	}
</cfscript>

<form name="formcopyop" method="post" action="anexo-rango-copy-apply.cfm" style="margin:0" onsubmit="return sinbotones()">
  <cfoutput>
    <input type="hidden" name="tab" value="2">
    <input type="hidden" name="copyop2" value="1">
    <input type="hidden" name="AnexoId" value="# HTMLEditFormat( url.AnexoId ) #">
    <cfloop list="src_r1,src_r2,src_c1,src_c2,dst_r1,dst_r2,dst_c1,dst_c2,mod_con,sel_con,mod_mes,sel_mes_modo,sel_mes_rel,sel_mes_fijo,sel_mes_ano,mod_ANubica" index="lvar">
	<cfset Lvarval = Evaluate("url.#lvar#")>
      <input type="hidden" name="#lvar#" value="#Lvarval#">
    </cfloop>
	 <input type="hidden" name="sel_Hojasrc" value="#url.sel_Hojasrc#">
	  <input type="hidden" name="sel_Hojadst" value="#url.sel_Hojadst#">
  </cfoutput>
  <table width="793" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="4">&nbsp;</td>
      <td colspan="9" class="subTitulo">&nbsp;</td>
      <td width="19">&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="9" class="subTitulo">Copia de anexos </td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="9">Utilice esta página para copiar las cuentas contables asignadas a cada celda del anexo. </td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="9"><p>Por favor revise y valide la información sobre la copia que desea realizar. <br />
      Los números entre paréntesis indican la cantidad de cuentas que hay actualmente en cada rango. </p></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td colspan="4" align="center">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="4" class="subTitulo">Origen de la copia </td>
      <td>&nbsp;</td>
      <td colspan="4" class="subTitulo">Destino  de la copia </td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td width="73">Filas</td>
      <td width="55"><cfoutput># HTMLEditFormat( url.src_r1 ) #</cfoutput></td>
      <td width="15">a</td>
      <td width="198"><cfoutput># HTMLEditFormat( url.src_r2 ) #</cfoutput></td>
      <td width="37">&nbsp;</td>
      <td>Filas</td>
      <td width="54"><cfoutput># HTMLEditFormat( url.dst_r1 ) #</cfoutput></td>
      <td width="15">a</td>
      <td width="203"><cfoutput># HTMLEditFormat( url.dst_r2 ) #</cfoutput></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>Columnas</td>
      <td><cfoutput># HTMLEditFormat( url.src_c1 ) #</cfoutput></td>
      <td>a </td>
      <td><cfoutput># HTMLEditFormat( url.src_c2 ) #</cfoutput></td>
      <td>&nbsp;</td>
      <td>Columnas</td>
      <td><cfoutput># HTMLEditFormat( url.dst_c1 ) #</cfoutput></td>
      <td>a </td>
      <td><cfoutput># HTMLEditFormat( url.dst_c2 ) #</cfoutput></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td width="76" align="center">&nbsp;</td>
      <td width="54" align="center">&nbsp;</td>
      <td width="15" align="center">&nbsp;</td>
      <td width="203" align="center">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="4" align="center">
        <table border="1" cellspacing="0" cellpadding="2">
		<tr><td bgcolor="#CCCCCC">&nbsp;</td><cfloop from="#url.src_c1#" to="#url.src_c2#" index="mycol">
			<td bgcolor="#CCCCCC" align="center"><cfoutput># NombreColumna( mycol ) #</cfoutput></td></cfloop></tr>
		
          <cfset table_fil = url.src_r1>
          <cfoutput query="porcopiar" group="src_fil">
            <cfloop condition="table_fil LT porcopiar.src_fil">
              <tr>
                <td bgcolor="##CCCCCC"># table_fil #</td>
				  <cfloop from="#url.src_c1#" to="#url.src_c2#" index="dummy1">
				  	<td>&nbsp;</td>
				  </cfloop>
              </tr>
              <cfset table_fil = table_fil + 1>
            </cfloop>
            <tr>
              <td bgcolor="##CCCCCC"># porcopiar.src_fil #</td>
              <cfset table_col = url.src_c1>
              <cfoutput>
                <cfif porcopiar.src_col GT table_col>
                  <cfloop from="#table_col#" to="#porcopiar.src_col-1#" index="dummy1">
				  	<td>&nbsp;</td>
				  </cfloop>
                </cfif>
                <td># HTMLEditFormat( src_ran ) # <cfif cant_src NEQ 0>(# cant_src #)</cfif></td>
                <cfset table_col = porcopiar.src_col+1>
              </cfoutput>
                <cfif url.src_c2 GE table_col>
				  <cfloop from="#table_col#" to="#url.src_c2#" index="dummy1">
				  	<td>&nbsp;</td>
				  </cfloop>
                </cfif>
			  </tr>
            <cfset table_fil = porcopiar.src_fil+1>
          </cfoutput>
		  <cfloop from="#table_fil#" to="#url.src_r2#" index="extra_row">
		  	 <tr><td bgcolor="#CCCCCC"><cfoutput># extra_row #</cfoutput></td>
			  <cfloop from="#url.src_c1#" to="#url.src_c2#" index="dummy1">
				<td>&nbsp;</td>
			  </cfloop>
			  </tr>
		  </cfloop>
        </table></td>
      <td >&nbsp;</td>
      <td colspan="4" align="center">
        <table border="1" cellspacing="0" cellpadding="2">
		<tr><td bgcolor="#CCCCCC">&nbsp;</td><cfloop from="#url.dst_c1#" to="#url.dst_c2#" index="mycol">
			<td bgcolor="#CCCCCC" align="center"><cfoutput># NombreColumna( mycol ) #</cfoutput></td></cfloop></tr>
		
          <cfset table_fil = url.dst_r1>
          <cfoutput query="porcopiar" group="dst_fil">
            <cfloop condition="table_fil LT porcopiar.dst_fil">
              <tr>
                <td bgcolor="##CCCCCC"># table_fil #</td>
				  <cfloop from="#url.dst_c1#" to="#url.dst_c2#" index="dummy1">
				  	<td>&nbsp;</td>
				  </cfloop>
              </tr>
              <cfset table_fil = table_fil + 1>
            </cfloop>
            <tr>
              <td bgcolor="##CCCCCC"># porcopiar.dst_fil #</td>
              <cfset table_col = url.dst_c1>
              <cfoutput>
                <cfif porcopiar.dst_col GT table_col>
				  <cfloop from="#table_col#" to="#porcopiar.dst_col-1#" index="dummy1">
				  	<td>&nbsp;</td>
				  </cfloop>
                </cfif>
                <td># HTMLEditFormat( dst_ran ) #<cfif cant_dst NEQ 0>(# cant_dst #)</cfif></td>
                <cfset table_col = porcopiar.dst_col+1>
              </cfoutput>
                <cfif url.dst_c2 GE table_col>
				  <cfloop from="#table_col#" to="#url.dst_c2#" index="dummy1">
				  	<td>&nbsp;</td>
				  </cfloop>
                </cfif>
			  </tr>
            <cfset table_fil = porcopiar.dst_fil+1>
          </cfoutput>
		  <cfloop from="#table_fil#" to="#url.dst_r2#" index="extra_row">
		  	 <tr><td bgcolor="#CCCCCC"><cfoutput># extra_row #</cfoutput></td>
			  <cfloop from="#url.dst_c1#" to="#url.dst_c2#" index="dummy1">
				<td>&nbsp;</td>
			  </cfloop>
			  </tr>
		  </cfloop>
        </table></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td width="55">&nbsp;</td>
      <td width="15">&nbsp;</td>
      <td width="198">&nbsp;</td>
      <td width="37">&nbsp;</td>
      <td colspan="4" align="center">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td colspan="4" align="center">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="9">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="9" class="subTitulo">Modificaciones al copiar </td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="3">Concepto de anexo</td>
      <td colspan="6">
	  	<cfif url.mod_con EQ '1'>
	  	  <strong>Modificar a:&nbsp;</strong>
          <cfoutput query="rsConceptos">
          <cfif CAcodigo eq url.sel_con>
              #rsConceptos.CAdescripcion#
          </cfif>
          </cfoutput>
        <cfelse>
          <strong>N/A:</strong> Mantener Datos del Destino
        </cfif></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="3">Mes</td>
      <td colspan="6">
	  <cfif url.mod_mes EQ '1'>
	  		<strong>Modificar a:&nbsp;</strong>
	  	<cfif url.sel_mes_modo EQ 'R'>
          <cfoutput>Mes relativo: <cfif url.sel_mes_rel GT 0>+</cfif># HTMLEditFormat( url.sel_mes_rel ) #</cfoutput>
		<cfelse>
          <cfoutput>Mes fijo: # HTMLEditFormat( url.sel_mes_fijo ) # ; A&ntilde;o: # HTMLEditFormat( url.sel_mes_ano ) #</cfoutput>
		</cfif>
          <cfelse>
          <strong>N/A:</strong> Mantener Datos del Destino
        </cfif></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="3">Origen de Datos</td>
      <td colspan="6">

		<cfif url.mod_ANubica EQ '1'>
	  		<strong>Modificar a:&nbsp;</strong>
			<cfif url.ANubicaTipo EQ "GE">
				<cf_cboANubicacion modo="CAMBIO" tipo="CONSULTA"
					GEid="#url.ANubicaGEid#" 
				>
			<cfelseif url.ANubicaTipo EQ "GO">
				<cf_cboANubicacion modo="CAMBIO" tipo="CONSULTA"
					Ecodigo="#url.ANubicaEcodigo#" 
					GOid="#url.ANubicaGOid#" 
				>
			<cfelseif url.ANubicaTipo EQ "O">
				<cf_cboANubicacion modo="CAMBIO" tipo="CONSULTA"
					Ecodigo="#url.ANubicaEcodigo#" 
					Ocodigo="#url.ANubicaOcodigo#" 
				>
			<cfelseif url.ANubicaTipo EQ "E">
				<cf_cboANubicacion modo="CAMBIO" tipo="CONSULTA"
					Ecodigo="#url.ANubicaEcodigo#" 
				>
			<cfelse>
				<cf_cboANubicacion modo="CAMBIO" tipo="CONSULTA" Ecodigo=""
				>
			</cfif>
		<cfelse>
        	<strong>N/A:</strong> Mantener Datos del Destino
		</cfif>
	  </td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="9">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="5" align="center">
      <cfoutput>
        <input type="submit" name="Copiar" value="Copiar">
        <input type="button" name="Cancelar" value="Cancelar" onclick="location.href='anexo.cfm?tab=2&amp;AnexoId=# URLEncodedFormat( url.AnexoId ) #'">
        </td>
      </cfoutput>
      </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="9">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </table>
</form>

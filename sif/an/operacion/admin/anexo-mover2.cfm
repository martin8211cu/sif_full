<cfparam name="url.mod_con" default="">
<cfparam name="url.mod_mes" default="">
<cfparam name="url.sel_mes_modo" default="R">
<cfparam name="url.sel_mes_rel"  default="0">
<cfparam name="url.sel_mes_fijo" default="1">
<cfparam name="url.sel_mes_ano"  default="0">

<cfparam name="url.mod_ANubica" default="">
<cfparam name="Url.ANubicaTipo" default="">
<cfparam name="Url.ANubicaEcodigo" default="-1">
<cfparam name="Url.ANubicaGEid" default="-1">
<cfparam name="Url.ANubicaGOid" default="-1">
<cfparam name="Url.ANubicaOcodigo" default="-1">

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


<cfquery name="rsAnexoSRC" datasource="#session.DSN#">
	select AnexoDes
	from Anexo 
	where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
</cfquery>

<cfquery name="rsAnexoDST" datasource="#session.DSN#">
	select AnexoDes
	from Anexo 
	where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.sel_Anexodst#">
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

<form name="formmover" method="post" action="anexo-mover-apply.cfm" style="margin:0" onsubmit="return sinbotones()">
  <cfoutput>
    <input type="hidden" name="tab" value="2">
    <input type="hidden" name="mover2" value="1">
    <input type="hidden" name="AnexoId" value="# HTMLEditFormat( url.AnexoId ) #">
	<input type="hidden" name="sel_Anexodst" value="# HTMLEditFormat( url.sel_Anexodst ) #">
    <cfloop list="mod_con,mod_mes,sel_mes_modo,sel_mes_rel,sel_mes_fijo,sel_mes_ano,mod_ANubica" index="lvar">
      <input type="hidden" name="#lvar#" value="#url[lvar]#">
    </cfloop>
	 <input type="hidden" name="sel_Hojasrc" value="#url.sel_Hojasrc#">
	 <input type="hidden" name="sel_Hojadst" value="#url.sel_Hojadst#">
	 
	 
	 <input type="hidden" name="SoloExistan" value="<cfif isdefined("url.SoloExistan")>1<cfelse>0</cfif>">
	  
  <table width="793" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
      <td width="4">&nbsp;</td>
      <td colspan="9" class="subTitulo">&nbsp;</td>
      <td width="19">&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="9" class="subTitulo">Mover anexos </td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="9">Utilice esta página para Mover las cuentas contables asignadas a cada celda del anexo. </td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="9"><p>Por favor revise y valide la información sobre el movimiento que desea realizar. <br />
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
      <td colspan="4" class="subTitulo">Mover del Origen</td>
      <td>&nbsp;</td>
      <td colspan="4" class="subTitulo">Mover al Destino</td>
      <td>&nbsp;</td>
    </tr>
	<tr>
      <td>&nbsp;</td>
      <td colspan="4" align="left">&nbsp;&nbsp;Anexo:&nbsp;#rsAnexoSRC.AnexoDes#</td>
      <td >&nbsp;</td>
      <td colspan="4" align="left">&nbsp;&nbsp;Anexo:&nbsp;#rsAnexoDST.AnexoDes#</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
	  <td>&nbsp;</td>
      <td colspan="4" class="subTitulo">Hoja: #HTMLEditFormat(url.sel_Hojasrc)#</td>
      <td>&nbsp;</td>
      <td colspan="4" class="subTitulo">Hoja: <cfif isdefined("url.sel_Hojadst") and len(trim(url.sel_Hojadst)) eq 0>{misma hoja}<cfelse>#HTMLEditFormat(url.sel_Hojadst)#</cfif></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="4" align="center">&nbsp;</td>
      <td >&nbsp;</td>
      <td colspan="4" align="center"></td>
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
      <td colspan="9">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>

      <td colspan="9" align="center">
        <input type="submit" name="Mover" value="Mover">
      	<input type="button" name="Cancelar" value="Cancelar" onclick="location.href='anexo.cfm?tab=2&amp;AnexoId=# URLEncodedFormat( url.AnexoId ) #'">
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="9">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </table>
    </cfoutput>
</form>

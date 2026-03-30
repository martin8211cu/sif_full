<cfinclude template="/hosting/publico/ApplicationPublic.cfm">
<style type="text/css">
<!--
.FilasSimple {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.FilasSimpleAlt {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	background-color: #F9EED1;
}
.style8 {font-size: 14px; font-weight: bold; font-family: Verdana, Arial, Helvetica, sans-serif; }
.style10 {font-size: 14px; font-family: Verdana, Arial, Helvetica, sans-serif; }
.style11 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 9px;
}
.style12 {color: #FFFFFF}
-->
</style>
<cf_template>
	<cf_templatearea name="title"><cfoutput>Biblia en Línea</cfoutput></cf_templatearea>
	<cf_templatearea name="body">
	<cfset Regresar = 'biblia.cfm'>
	<cfinclude template="pNavegacion.cfm">
	<br><br>
<cfif isdefined("form.Libro") and len(form.Libro) gt 0>
<strong>Resultado de la Búsqueda:</strong><br><br>
	<cfoutput>
	<table  border="0" cellspacing="0" cellpadding="0" width="473">
  <tr valign="middle">
    <td><span class="style8">Libro:</span></td>
    <td>
      <span class="style8">
      <select name="Libro" disabled>
            <option value="1" <cfif Form.Libro eq 1>selected</cfif>>G&eacute;nesis</option>
  	        <option value="2" <cfif Form.Libro eq 2>selected</cfif>>Éxodo</option>
	        <option value="3" <cfif Form.Libro eq 3>selected</cfif>>Levítico</option>
	        <option value="4" <cfif Form.Libro eq 4>selected</cfif>>Números</option>
	        <option value="5" <cfif Form.Libro eq 5>selected</cfif>>Deuteronomio</option>
	        <option value="6" <cfif Form.Libro eq 6>selected</cfif>>Josué</option>
	        <option value="7" <cfif Form.Libro eq 7>selected</cfif>>Jueces</option>
	        <option value="8" <cfif Form.Libro eq 8>selected</cfif>>Rut</option>
	        <option value="9" <cfif Form.Libro eq 9>selected</cfif>>I  Samuel</option>
	        <option value="10" <cfif Form.Libro eq 10>selected</cfif>>II Samuel</option>
	        <option value="11" <cfif Form.Libro eq 11>selected</cfif>>I  Reyes</option>
	        <option value="12" <cfif Form.Libro eq 12>selected</cfif>>II Reyes</option>
	        <option value="13" <cfif Form.Libro eq 13>selected</cfif>>I Crónicas</option>
	        <option value="14" <cfif Form.Libro eq 14>selected</cfif>>II Crónicas</option>
	        <option value="15" <cfif Form.Libro eq 15>selected</cfif>>Esdras</option>
	        <option value="16" <cfif Form.Libro eq 16>selected</cfif>>Nehemías</option>
	        <option value="17" <cfif Form.Libro eq 17>selected</cfif>>Ester</option>
	        <option value="18" <cfif Form.Libro eq 18>selected</cfif>>Job</option>
	        <option value="19" <cfif Form.Libro eq 19>selected</cfif>>Salmos</option>
	        <option value="20" <cfif Form.Libro eq 20>selected</cfif>>Proverbios</option>
	        <option value="21" <cfif Form.Libro eq 21>selected</cfif>>Eclesiastés</option>
	        <option value="22" <cfif Form.Libro eq 22>selected</cfif>>Cantares</option>
	        <option value="23" <cfif Form.Libro eq 23>selected</cfif>>Isaías</option>
	        <option value="24" <cfif Form.Libro eq 24>selected</cfif>>Jeremías</option>
	        <option value="25" <cfif Form.Libro eq 25>selected</cfif>>Lamentaciones</option>
	        <option value="26" <cfif Form.Libro eq 26>selected</cfif>>Ezequiel</option>
	        <option value="27" <cfif Form.Libro eq 27>selected</cfif>>Daniel</option>
	        <option value="28" <cfif Form.Libro eq 28>selected</cfif>>Oseas</option>
	        <option value="29" <cfif Form.Libro eq 29>selected</cfif>>Joel</option>
	        <option value="30" <cfif Form.Libro eq 30>selected</cfif>>Amós</option>
	        <option value="31" <cfif Form.Libro eq 31>selected</cfif>>Abdías</option>
	        <option value="32" <cfif Form.Libro eq 32>selected</cfif>>Jonás</option>
	        <option value="33" <cfif Form.Libro eq 33>selected</cfif>>Miqueas</option>
	        <option value="34" <cfif Form.Libro eq 34>selected</cfif>>Nahúm</option>
	        <option value="35" <cfif Form.Libro eq 35>selected</cfif>>Habacuc</option>
	        <option value="36" <cfif Form.Libro eq 36>selected</cfif>>Sofonías</option>
	        <option value="37" <cfif Form.Libro eq 37>selected</cfif>>Hageo</option>
	        <option value="38" <cfif Form.Libro eq 38>selected</cfif>>Zacarías</option>
	        <option value="39" <cfif Form.Libro eq 39>selected</cfif>>Malaquías</option>
	        <option value="40" <cfif Form.Libro eq 40>selected</cfif>>Mateo</option>
	        <option value="41" <cfif Form.Libro eq 41>selected</cfif>>Marcos</option>
	        <option value="42" <cfif Form.Libro eq 42>selected</cfif>>Lucas</option>
	        <option value="43" <cfif Form.Libro eq 43>selected</cfif>>Juan</option>
	        <option value="44" <cfif Form.Libro eq 44>selected</cfif>>Hechos</option>
	        <option value="45" <cfif Form.Libro eq 45>selected</cfif>>Romanos</option>
	        <option value="46" <cfif Form.Libro eq 46>selected</cfif>>I  Corintios</option>
	        <option value="47" <cfif Form.Libro eq 47>selected</cfif>>II Corintios</option>
	        <option value="48" <cfif Form.Libro eq 48>selected</cfif>>Gálatas</option>
	        <option value="49" <cfif Form.Libro eq 49>selected</cfif>>Efesios</option>
	        <option value="50" <cfif Form.Libro eq 50>selected</cfif>>Filipenses</option>
	        <option value="51" <cfif Form.Libro eq 51>selected</cfif>>Colosenses</option>
	        <option value="52" <cfif Form.Libro eq 52>selected</cfif>>I  Tesalonicenses</option>
	        <option value="53" <cfif Form.Libro eq 53>selected</cfif>>II Tesalonicenses</option>
	        <option value="54" <cfif Form.Libro eq 54>selected</cfif>>I  Timoteo</option>
	        <option value="55" <cfif Form.Libro eq 55>selected</cfif>>II Timoteo</option>
	        <option value="56" <cfif Form.Libro eq 56>selected</cfif>>Tito</option>
	        <option value="57" <cfif Form.Libro eq 57>selected</cfif>>Filemón</option>
	        <option value="58" <cfif Form.Libro eq 58>selected</cfif>>Hebreos</option>
	        <option value="59" <cfif Form.Libro eq 59>selected</cfif>>Santiago</option>
	        <option value="60" <cfif Form.Libro eq 60>selected</cfif>>I  Pedro</option>
	        <option value="61" <cfif Form.Libro eq 61>selected</cfif>>II Pedro</option>
	        <option value="62" <cfif Form.Libro eq 62>selected</cfif>>I   Juan</option>
	        <option value="63" <cfif Form.Libro eq 63>selected</cfif>>II  Juan</option>
	        <option value="64" <cfif Form.Libro eq 64>selected</cfif>>III Juan</option>
	        <option value="65" <cfif Form.Libro eq 65>selected</cfif>>Judas</option>
	        <option value="66" <cfif Form.Libro eq 66>selected</cfif>>Apocalipsis</option>
      </select>
       </span></td>
      <tr>
	   <cfif isdefined("Form.Capitulo") and len(Form.Capitulo)>
	   <td><span class="style8">Capítulo:</span></td>
	   <td class="style10">#Form.Capitulo#</td>
	   </cfif>
      </tr>
	   <cfif isdefined("Form.Versiculo") and len(Form.Versiculo)>
	   <tr>
	   <td><span class="style8">Versículo:</span></td>
	   <td class="style10">#Form.Versiculo#</td>
	   <td class="style10">&nbsp;</td>
	   </tr>
	   </cfif>
	</tr>
</table>
	</cfoutput>
	<cfquery name="rs" datasource="#Session.DSN#">
		select Libro, Capitulo, Versiculo, Texto from Biblia where Libro = #Form.Libro#
		<cfif isdefined('form.capitulo') and len(form.capitulo)>
			and Capitulo = #form.capitulo#
		</cfif>
		<cfif isdefined('form.Versiculo') and len(form.Versiculo)>
			and Versiculo = #form.Versiculo#
		</cfif>
	</cfquery>
	<br>
	<cfif rs.RecordCount gt 0>
		<table width="100%" cellpadding="0" cellspacing="0">
		<cfoutput query="rs">
			<cfif rs.Versiculo EQ 1>
			<tr bgcolor="##CC9900">
				<td colspan="3" class="style12"><strong>Capítulo:</strong>#rs.Capitulo#</td>
			  </tr>
			</cfif>
			<tr <cfif rs.CurrentRow mod 2> class="FilasSimple"<cfelse> class="FilasSimpleAlt"</cfif>>
					<td width="79" valign="top"><span class="style11">#rs.versiculo#</span></td>
					<td width="519" colspan="2"><span class="style10">#rs.Texto#</span></td>
			</tr>
		</cfoutput>
	  </table>
	</cfif>
</cfif>
	</cf_templatearea>
</cf_template>

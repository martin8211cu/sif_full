<cfif isdefined("Url.o") and not isdefined("Form.o")>
	<cfparam name="Form.o" default="#Url.o#">
</cfif>

<cfif isdefined("Url.persona") and not isdefined("Form.persona")>
	<cfset Form.persona = Url.persona>
</cfif>
<cfif isdefined("form.persona")>
	<cfparam name="Form.persona" default="#form.persona#">
</cfif> 
<cfif isdefined("Url.fRHnombre") and not isdefined("Form.fRHnombre")>
	<cfparam name="Form.fRHnombre" default="#Url.fRHnombre#">
</cfif> 
<cfif isdefined("Url.filtroRhPid") and not isdefined("Form.filtroRhPid")>
	<cfparam name="Form.filtroRhPid" default="#Url.filtroRhPid#">
</cfif> 
<cfif isdefined("Url.FAretirado") and not isdefined("Form.FAretirado")>
	<cfparam name="Form.FAretirado" default="#Url.FAretirado#">
</cfif> 
<cfif isdefined("Url.NoMatr") and not isdefined("Form.NoMatr")>
	<cfparam name="Form.NoMatr" default="#Url.NoMatr#">
</cfif> 
<cfif isdefined("Url.FNcodigo") and not isdefined("Form.FNcodigo")>
	<cfparam name="Form.FNcodigo" default="#Url.FNcodigo#">
</cfif> 
<cfif isdefined("Url.FGcodigo") and not isdefined("Form.FGcodigo")>
	<cfparam name="Form.FGcodigo" default="#Url.FGcodigo#">
</cfif> 


	<cfquery datasource="#Session.Edu.DSN#" name="rsNiveles">
		select convert(varchar, Ncodigo) as Ncodigo, Ndescripcion from Nivel 
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		order by Norden
	</cfquery>
	
	<cfquery datasource="#Session.Edu.DSN#" name="rsGrado">
		select convert(varchar, b.Ncodigo)
			   + '|' + convert(varchar, b.Gcodigo) as Codigo, 
			   b.Gdescripcion
		from Nivel a, Grado b
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and a.Ncodigo = b.Ncodigo 
		order by a.Norden, b.Gorden
	</cfquery>
	
	<script language="JavaScript" type="text/javascript">
		var gradostext = new Array();
		var grados = new Array();
		var niveles = new Array();
	
		// Esta función únicamente debe ejecutarlo una vez
		function obtenerGrados(f) {
			for(i=0; i<f.FGcodigo.length; i++) {
				var s = f.FGcodigo.options[i].value.split("|");
				// Códigos de los detalles
				niveles[i]= s[0];
				grados[i] = s[1];
				gradostext[i] = f.FGcodigo.options[i].text;
			}
		}
		
		function cargarGrados(csource, ctarget, vdefault, t){
			// Limpiar Combo
			for (var i=ctarget.length-1; i >=0; i--) {
				ctarget.options[i]=null;
			}
			var k = csource.value;
			var j = 0;
			if (t) {
				var nuevaOpcion = new Option("Todos","-1");
				ctarget.options[j]=nuevaOpcion;
				j++;
			}
			if (k != "-1") {
				for (var i=0; i<grados.length; i++) {
					if (niveles[i] == k) {
						nuevaOpcion = new Option(gradostext[i],grados[i]);
						ctarget.options[j]=nuevaOpcion;

						if (vdefault != null && grados[i] == vdefault) {
							ctarget.selectedIndex = j;
						}
						j++;
					}
				}
			} else {
				for (var i=0; i<grados.length; i++) {
					nuevaOpcion = new Option(gradostext[i],grados[i]);
					ctarget.options[i+1]=nuevaOpcion;
					if (vdefault != null && grados[i] == vdefault) {
						ctarget.selectedIndex = i+1;
					}					
				}
			}
			if (!t) {
				var j = ctarget.length;
				nuevaOpcion = new Option("-------------------","");
				ctarget.options[j++]=nuevaOpcion;
				nuevaOpcion = new Option("Crear Nuevo ...","0");
				ctarget.options[j]=nuevaOpcion;
			}
		}
		
		function noMatr(obj){
			if(obj.checked)
				obj.form.FAretirado.checked = false;
		}
	</script>
 <form action="alumno.cfm" method="post" name="FiltroAlumno">	
  <table width="100%" border="0" class="areaFiltro">
    <tr> 
      <td width="15%" class="subTitulo">Nombre </td>
      <td colspan="2" class="subTitulo"><input name="fRHnombre" type="text" id="fRHnombre" size="80" onFocus="this.select()" maxlength="80" value="<cfif isdefined("Form.fRHnombre") AND #Form.fRHnombre# NEQ "" ><cfoutput>#Form.fRHnombre#</cfoutput></cfif>"></td>
      <td width="9%" class="subTitulo">Identificaci&oacute;n </td>
      <td class="subTitulo"><input name="filtroRhPid" type="text" size="25" onFocus="this.select()" maxlength="60" value="<cfif isdefined("Form.filtroRhPid") AND #Form.filtroRhPid# NEQ "" ><cfoutput>#Form.filtroRhPid#</cfoutput></cfif>"></td>
    </tr>
    <tr> 
      <td class="subTitulo">Nivel</td>
      <td class="subTitulo"> <select name="FNcodigo" id="FNcodigo" tabindex="5" onChange="javascript: cargarGrados(this, this.form.FGcodigo, '<cfif isdefined("Form.FGcodigo")><cfoutput>#Form.FGcodigo#</cfoutput></cfif>', true)">
          <option value="-1">Todos</option>
          <cfoutput query="rsNiveles"> 
            <option value="#Ncodigo#" <cfif isdefined("Form.FNcodigo") AND (Form.FNcodigo EQ rsNiveles.Ncodigo)>selected</cfif>>#Ndescripcion#</option>
          </cfoutput> </select> </td>
      <td class="subTitulo"><!---Retirados 
        <input name="FAretirado" class="areaFiltro" type="checkbox" id="FAretirado" border="0" value="1" <cfif isdefined("Form.FAretirado") and form.FAretirado EQ '1'>checked</cfif>---></td>
      <td class="subTitulo">Grado</td>
      <td class="subTitulo"> <select name="FGcodigo" id="FGcodigo" tabindex="5">
          <cfoutput query="rsGrado"> 
            <option value="#Codigo#" >#Gdescripcion#</option>
          </cfoutput> </select> </td>
    </tr>
	
<!--- <cfif isdefined("Form.FGcodigo") AND (Form.FGcodigo EQ rsGrado.FGcodigo)>selected</cfif> --->	
	
    <tr> 
		<td colspan="2" class="subTitulo">No matriculados en este per&iacute;odo 
			<input name="NoMatr" type="checkbox" class="areaFiltro" id="NoMatr" onClick="javascript: noMatr(this);" value="1" <cfif isdefined("Form.NoMatr") and Form.NoMatr EQ '1'>checked</cfif>>
			<input name="persona" type="hidden" value="<cfif isdefined("form.persona")><cfoutput>#form.persona#</cfoutput></cfif>"> 
			<input name="o" type="hidden" value="<cfif isdefined("Form.o")><cfoutput>#form.o#</cfoutput></cfif>"> 
			
		
		</td>
      <td colspan="3" class="subTitulo" align="center" valign="middle"><input name="btnFiltrar2" type="submit" id="btnFiltrar2" value="Buscar" ></td>
    </tr>
  </table>

</form>

<script language="JavaScript" type="text/JavaScript">
	//OcultaTablaEval(document.form1);
	obtenerGrados(document.FiltroAlumno);
	cargarGrados(document.FiltroAlumno.FNcodigo, document.FiltroAlumno.FGcodigo, '<cfif isdefined("Form.FGcodigo") AND Form.FGcodigo NEQ "-1"><cfoutput>#Form.FGcodigo#</cfoutput></cfif>', true);
</script>
<cfform action="" name="FiltroPromocion" >
	<cfquery datasource="#Session.Edu.DSN#" name="rsNiveles">
		select convert(varchar, Ncodigo) as Ncodigo, Ndescripcion from Nivel 
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		order by Norden
	</cfquery>
	
	<cfquery datasource="#Session.Edu.DSN#" name="rsPerEscolar">
		Select (convert(varchar,a.Ncodigo) + '|' + convert(varchar,PEcodigo)) as Cod,PEdescripcion
		from PeriodoEscolar a, Nivel b
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and a.Ncodigo=b.Ncodigo
		order by PEdescripcion	
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
		var PerEscolarText = new Array();
		var PerEscolar = new Array();
		var nivelesPer = new Array();
			
		// Esta función únicamente debe ejecutarlo una vez
		function obtenerPerEscolarF(f) {
			for(i=0; i<f.FPEcodigo.length; i++) {
				var Per = f.FPEcodigo.options[i].value.split("|");
				// Códigos de los detalles
				nivelesPer[i]= Per[0];
				PerEscolar[i] = Per[1];
				PerEscolarText[i] = f.FPEcodigo.options[i].text;
			}
		}
		
		function cargarPerEscolarF(csource, ctarget, vdefault, t){
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
				for (var i=0; i<PerEscolar.length; i++) {
					if (nivelesPer[i] == k) {
						nuevaOpcion = new Option(PerEscolarText[i],PerEscolar[i]);
						ctarget.options[j]=nuevaOpcion;
						if (vdefault != null && PerEscolar[i] == vdefault) {
							ctarget.selectedIndex = j;
						}
						j++;
					}
				}			
			} else {
				for (var i=0; i<PerEscolar.length; i++) {
					nuevaOpcion = new Option(PerEscolarText[i],PerEscolar[i]);
					ctarget.options[j]=nuevaOpcion;
					if (vdefault != null && PerEscolar[i] == vdefault) {
						ctarget.selectedIndex = j;
					}
					j++;					
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
	
		// Esta función únicamente debe ejecutarlo una vez
		function obtenerGradosF(f) {
			for(i=0; i<f.FGcodigo.length; i++) {
				var s = f.FGcodigo.options[i].value.split("|");
				// Códigos de los detalles
				niveles[i]= s[0];
				grados[i] = s[1];
				gradostext[i] = f.FGcodigo.options[i].text;
			}
		}
		
		function cargarGradosF(csource, ctarget, vdefault, t){
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
							ctarget.selectedIndex = j;
						}
						j++;					
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
	</script>
  <table width="100%" border="0" class="areaFiltro">
    <tr> 
      <td class="subTitulo">Nivel</td>
      <td class="subTitulo"> 
        <select name="FNcodigo" id="FNcodigo" tabindex="5" onChange="javascript: cargarGradosF(this, this.form.FGcodigo, '<cfif isdefined("Form.FGcodigo")><cfoutput>#Form.FGcodigo#</cfoutput></cfif>', true); cargarPerEscolarF(this, this.form.FPEcodigo, '<cfif isdefined("Form.FPEcodigo")><cfoutput>#Form.FPEcodigo#</cfoutput></cfif>', true)">
          <option value="-1">Todos</option>
          <cfoutput query="rsNiveles"> 
            <option value="#Ncodigo#" <cfif isdefined("Form.FNcodigo") AND (Form.FNcodigo EQ rsNiveles.Ncodigo)>selected</cfif>>#Ndescripcion#</option>
          </cfoutput> 
        </select>
      </td>
      <td class="subTitulo">A&ntilde;o</td>
      <td class="subTitulo"> 
        <input name="FPRano" type="text" size="5" onFocus="this.select()" maxlength="5" value="<cfif isdefined("Form.FPRano") AND #Form.FPRano# NEQ "" ><cfoutput>#Form.FPRano#</cfoutput></cfif>">
      </td>
      <td width="20%" rowspan="3" align="center" valign="middle"> 
        <input name="btnFiltrar" type="submit" id="btnFiltrar2" value="Buscar" >
      </td>
    </tr>
    <tr> 
      <td width="20%" class="subTitulo">Tipo de curso lectivo</td>
      <td width="16%" class="subTitulo"> 
        <select name="FPEcodigo" id="FPEcodigo">
          <cfoutput query="rsPerEscolar"> 
            <option value="#Cod#" <cfif isdefined("Form.FPEcodigo") AND (Form.FPEcodigo EQ rsPerEscolar.Cod)>selected</cfif>>#PEdescripcion#</option>
          </cfoutput> 
        </select>
      </td>
      <td width="6%" class="subTitulo">Grado</td>
      <td width="38%" class="subTitulo"> 
        <select name="FGcodigo" id="select3" tabindex="5">
          <cfoutput query="rsGrado"> 
            <option value="#Codigo#" <cfif isdefined("Form.FGcodigo") AND (Form.FGcodigo EQ rsGrado.Codigo)>selected</cfif>>#Gdescripcion#</option>
          </cfoutput> 
        </select>
      </td>
    </tr>
    <tr> 
      <td class="subTitulo">Descripci&oacute;n</td>
      <td colspan="3" class="subTitulo"> 
        <input name="FPRdescripcion" type="text" id="FPRdescripcion" size="80" onFocus="this.select()" maxlength="80" value="<cfif isdefined("Form.FPRdescripcion") AND #Form.FPRdescripcion# NEQ "" ><cfoutput>#Form.FPRdescripcion#</cfoutput></cfif>">
      </td>
    </tr>
  </table>
</cfform>

<script language="JavaScript" type="text/JavaScript">
	//Para los tipos de cursos lectivos
	obtenerPerEscolarF(document.FiltroPromocion);
	cargarPerEscolarF(document.FiltroPromocion.FNcodigo, document.FiltroPromocion.FPEcodigo, '<cfif isdefined("Form.FPEcodigo")><cfoutput>#Form.FPEcodigo#</cfoutput></cfif>', true);
	
	//Para los grados
	obtenerGradosF(document.FiltroPromocion);
	cargarGradosF(document.FiltroPromocion.FNcodigo, document.FiltroPromocion.FGcodigo, '<cfif isdefined("Form.FGcodigo")><cfoutput>#Form.FGcodigo#</cfoutput></cfif>', true);
</script>
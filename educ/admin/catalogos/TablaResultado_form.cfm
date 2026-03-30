<cfif isdefined("Form.TRcodigo")>
	<cfset Form.TRcodigo = Form.TRcodigo>
</cfif>
<cfif isdefined("Url.TRcodigo") and not isdefined("Form.TRcodigo")>
	<cfset Form.TRcodigo = Url.TRcodigo>
</cfif>
<cfif isdefined("form.TRRtipo_lista")>
	<cfset Form.TRRtipo = form.TRRtipo_lista>
</cfif>
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
<cfif isdefined("Form.TRcodigo") and len(trim(Form.TRcodigo)) neq 0  and not isdefined("form.btnNuevoE")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfif isdefined("Form.btnNuevoE") >
	<cfset modo="ALTA">
</cfif>

<!--- Consultas --->
<cfif modo EQ "ALTA">
	<cfquery datasource="#Session.DSN#" name="rsTablaResultado">	
			select convert(varchar,b.TRcodigo) as TRcodigo, rtrim(b.TRnombre) as TRnombre, 
			1 as TRcantidadAmpliacion, b.ts_rversion
			from TablaResultado b
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
	</cfquery>
</cfif>

<cfif modo NEQ "ALTA">
	<!--- 1. Form Encabezado --->
	<cfquery datasource="#Session.DSN#" name="rsTablaResultado">
		select convert(varchar,b.TRcodigo) as TRcodigo, rtrim(b.TRnombre) as TRnombre, 
		TRcantidadAmpliacion, ts_rversion
		from TablaResultado b
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
		  and b.TRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TRcodigo#">
	</cfquery>

	<cfquery datasource="#Session.DSN#" name="rsTablaResultadoRango">
		select 	convert(varchar, b.TRRtipo) as TRRtipo ,
				convert(varchar, b.TRcodigo) as TRcodigo,
				b.TRRnombre,
				b.TRRetiqueta,
				convert(varchar,b.TRRminimo) as TRRminimo, 
				convert(varchar, b.TRRmaximo) as TRRmaximo,
				b.ts_rversion
		from TablaResultado a, TablaResultadoRango b
		where a.TRcodigo  = b.TRcodigo
		  and b.TRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TRcodigo#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
		  order by TRRtipo
	</cfquery>
	<cfquery dbtype="query" name="rsMinGanar">
		select TRRminimo
		from rsTablaResultadoRango
		where TRRtipo = '1'
	</cfquery>
	<cfquery dbtype="query" name="rsMinNoPerder">
		select TRRminimo
		from rsTablaResultadoRango
		where TRRtipo = '2'
	</cfquery>
</cfif>

<cf_templatecss>
<script language="JavaScript" src="/cfmx/educ/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	
	/*function irALista() {
		location.href = "TablaResultado_lista.cfm";
	}*/
</script>
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

<form action="TablaResultado_SQL.cfm" method="post" name="form1">
  <cfif modo neq 'ALTA'>
    
    <cfset ts = "">
    <cfif modo neq "ALTA">
      
      <cfinvoke 
					component="educ.componentes.DButils"
					method="toTimeStamp"
					returnvariable="ts">
        <cfinvokeargument name="arTimeStamp" value="#rsTablaResultado.ts_rversion#"/>
      </cfinvoke>
    </cfif>
  </cfif>
  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
  <table width="57%" border="0" cellpadding="1" cellspacing="1">
    <tr align="center"> 
      <td  colspan="4" class="tituloMantenimiento" > <input type="hidden" name="TRcodigo" value="<cfif modo NEQ 'ALTA'><cfoutput>#form.TRcodigo#</cfoutput></cfif>">	
        <cfset ts = ""> 
        <cfif modo neq "ALTA">
          
          <cfinvoke 
									component="educ.componentes.DButils"
									method="toTimeStamp"
									returnvariable="ts">
            <cfinvokeargument name="arTimeStamp" value="#rsTablaResultadoRango.ts_rversion#"/>
          </cfinvoke>
        </cfif> <input type="hidden" name="timestampD" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
        <cfif modo EQ "ALTA">
          Nueva 
          <cfelse>
          Modificar 
        </cfif>
        Tipo de Aprobación</td>
    </tr>
    <tr> 
      <td align="left" nowrap><div align="right">Nombre del tipo de Aprobación</div></td>
      <td colspan="2" align="left" nowrap><input name="TRnombre" type="text" id="TRnombre" size="50" tabindex="1" maxlength="50" onFocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsTablaResultado.TRnombre#</cfoutput></cfif>">
      </td>
      <td align="right">
		  <cf_sifayuda width="650" height="450" name="imgAyuda" Tip="false">	  
	  </td>
    </tr>
    <tr> 
      <td width="34%" align="right" nowrap>Porcentaje M&iacute;nimo para Ganar 
        el curso:</td>
      <td colspan="3" nowrap> <input name="TRRminGanar" id="TRRminGanar" tabindex="2" type="text"  value="<cfif modo NEQ 'ALTA'><cfoutput>#rsMinGanar.TRRminimo#</cfoutput><cfelse>70.00</cfif>" size="12" maxlength="10"  onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,2); fnCopiaValores(this,1);"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"> 
      </td>
    </tr>
    <tr> 
      <td align="right" nowrap>Porcentaje M&iacute;nimo para no Perder el curso:</td>
      <td colspan="3" nowrap> <input name="TRRminNoPerder" id="TRRminNoPerder" tabindex="2"  type="text" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsMinNoPerder.TRRminimo#</cfoutput><cfelse>60.00</cfif>" size="12" maxlength="10" onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,2); fnCopiaValores(this, 2);"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"> 
      </td>
    </tr>
    <tr> 
      <td align="right" nowrap>Cantidad de Ex&aacute;menes de Ampliaci&oacute;n:</td>
      <td colspan="3" nowrap> <input name="TRcantidadAmpliacion" id="TRcantidadAmpliacion" tabindex="3"  type="text" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsTablaResultado.TRcantidadAmpliacion#</cfoutput><cfelse>1</cfif>" size="12" maxlength="10" onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,0); fnCopiaValores(this, 2);"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"> 
      </td>
    </tr>
	</table>
	<table>
    <tr> 
      <td align="center">&nbsp;</td>
      <td align="left"><strong>Etiqueta</strong></td>
      <td align="right"><strong>Desde</strong></td>
      <td align="right"><strong>Hasta</strong></td>
    </tr>
    <cfif isdefined("rsTablaResultadoRango") and rsTablaResultadoRango.RecordCount NEQ 0>
      <cfset cont = 0>
      <cfoutput query="rsTablaResultadoRango"> 
        <cfset cont = cont + 1>
        <tr> 
          <td align="right" ><input name="TRRnombre#cont#"   id="TRRnombre#cont#" class="cajasinbordeb" tabindex="2" readonly="" onFocus="this.select()" type="text"  value="<cfif modo NEQ 'ALTA' and rsTablaResultadoRango.TRRtipo EQ '#cont#'>#rsTablaResultadoRango.TRRnombre#</cfif>" size="25" maxlength="25"></td>
          <td ><input name="TRRetiqueta#cont#" type="text" id="TRRetiqueta#cont#" size="25" tabindex="1" maxlength="50" onFocus="javascript:this.select();" 
			     <cfif cont EQ 2>onblur="fnCopiaValores(this, 1);"</cfif>
		      		  value="<cfif modo NEQ 'ALTA' and rsTablaResultadoRango.TRRtipo EQ '#cont#'>#rsTablaResultadoRango.TRRetiqueta#</cfif>"></td>
          <td align="right" nowrap >&nbsp;
<input name="TRRminimo#cont#" id="TRRminimo#cont#" class="cajasinbordeb" style="text-align:right;" tabindex="2" readonly="" onFocus="this.select()" type="text"  value="<cfif modo NEQ 'ALTA' and rsTablaResultadoRango.TRRtipo EQ '#cont#'>#LsCurrencyFormat(rsTablaResultadoRango.TRRminimo,"none")#</cfif>" size="10" maxlength="10">%
          </td>
          <td align="left" nowrap > 
            <input name="TRRmaximo#cont#"   id="TRRmaximo#cont#" class="cajasinbordeb" style="text-align:right;" tabindex="2" readonly="" onFocus="this.select()" type="text"  value="<cfif modo NEQ 'ALTA' and rsTablaResultadoRango.TRRtipo EQ '#cont#'>#LsCurrencyFormat(rsTablaResultadoRango.TRRmaximo,"none")#</cfif>" size="10" maxlength="10">%
          </td>
        </tr>
      </cfoutput> 
      <cfelse>
      <cfloop  index="cont" from="1" to="3">
        <cfoutput> 
          <tr> 
            <td align="right" ><input name="TRRnombre#cont#"  id="TRRnombre#cont#" class="cajasinbordeb" tabindex="2" readonly="" onFocus="this.select()" type="text" 
				      value="<cfif cont eq 1>Para Ganar el curso<cfelseif cont eq 2>Requiere Examen de Ampliación<cfelse>Para Perder el curso</cfif>" 
					  size="25" maxlength="25"></td>
            <td ><input name="TRRetiqueta#cont#"  type="text" id="TRRetiqueta#cont#" size="25" tabindex="1" maxlength="50" onFocus="javascript:this.select();" 
			     <cfif cont EQ 2>onblur="fnCopiaValores(this, 1);"</cfif>
				  	  value="<cfif cont eq 1>Aprobado<cfelseif cont eq 2>Aplazado<cfelse>Reprobado</cfif>"></td>
            <td align="right" nowrap > 
              <input name="TRRminimo#cont#"  id="TRRminimo#cont#" class="cajasinbordeb" align="right" tabindex="2" readonly="" onFocus="this.select()" type="text"  value="" size="10" maxlength="10"> 
            </td>
            <td align="left" nowrap > 
              <input name="TRRmaximo#cont#"   id="TRRmaximo#cont#" class="cajasinbordeb" align="left" tabindex="2" readonly="" onFocus="this.select()" type="text"  value="" size="10" maxlength="10"> 
            </td>
          </tr>
        </cfoutput> 
      </cfloop>
    </cfif>
    <tr> 
      <td align="center" colspan="4"> <cfset mensajeDelete = "¿Desea Eliminar esta Tabla de Resultado?">
        <cfinclude template="/educ/portlets/pBotones.cfm"> 
		<input type="submit" name="btnLista" value="Ir Lista"  onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
        <!--- <input type="button" name="btnLista"  tabindex="1" value="Lista de Tablas de resultado" onClick="javascript: irALista();"> --->
      </td>
    </tr>
  </table>
</form>	  
<script language="JavaScript">
	//Rodolfo Jiménez Jara, SOIN,14/10/2003
	function deshabilitarValidacion() {
		objForm.TRnombre.required = false;
		objForm.TRRminNoPerder.required = false;
		objForm.TRRminGanar.required = false;
		objForm.TRcantidadAmpliacion.required = false;
		
	}
	
	function habilitarValidacion() {
		objForm.TRnombre.required = true;
		objForm.TRRminNoPerder.required = true;
		objForm.TRRminGanar.required = true;
		objForm.TRcantidadAmpliacion.required = true;
	}	
	
	function deshabilitarDetalle() {
		<cfif modo EQ "ALTA">
			objForm.TRnombre.required = false;
		</cfif>
		
		<cfif modo NEQ "ALTA">
			objForm.TRRminimo.required = false;
			objForm.TRRmaximo.required = false;
		</cfif>
	}

	function habilitarDetalle() {
		<cfif modo EQ "ALTA">
			objForm.TRnombre.required = true;
		</cfif>
		//objForm.TRRminimo.required = true;
		//objForm.TRRmaximo.required = true;
	}
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.TRnombre.required = true;
	objForm.TRnombre.description = "Nombre de la tabla de Resultado";
	objForm.TRRminGanar.required = true;
	objForm.TRRminGanar.description = "Porcentaje mínimo para Ganar el curso";
	objForm.TRRminNoPerder.required = true;
	objForm.TRRminNoPerder.description = "Porcentaje mínimo para No Perder el curso";
	objForm.TRcantidadAmpliacion.required = true;
	objForm.TRcantidadAmpliacion.description = "Cantidad de exámenes de ampliación";
	fnCopiaValores(null, 1);

 function fnCopiaValores (obj, LprmTipo)
	{
	  var LvarMin1 = parseFloat(document.getElementById("TRRminGanar").value);
	  var LvarMin2 = parseFloat(document.getElementById("TRRminNoPerder").value);
	  
	  if (LvarMin1 < LvarMin2)
	    if (LprmTipo == 1)
		{
		  LvarMin2 = LvarMin1;
	      document.getElementById("TRRminNoPerder").value = document.getElementById("TRRminGanar").value;
		}
		else
		{
		  LvarMin1 = LvarMin2;
	      document.getElementById("TRRminGanar").value = document.getElementById("TRRminNoPerder").value;
		}
	  
	  document.getElementById("TRRnombre1").value = "Para Ganar el curso";
	  document.getElementById("TRRmaximo1").value = "100.00";
	  document.getElementById("TRRminimo1").value = fm(LvarMin1, 2);

	  if (LvarMin1 == LvarMin2)
	  {
	    document.getElementById("TRcantidadAmpliacion").value = "0";
	    document.getElementById("TRRnombre2").value = "No hay Ampliación";
	    document.getElementById("TRRetiqueta2").value = "N/A";
	    document.getElementById("TRRmaximo2").value = "";
	    document.getElementById("TRRminimo2").value = "";
	  }
	  else
	  {
	    document.getElementById("TRRnombre2").value = "Requiere Ampliación";
		if (document.getElementById("TRRetiqueta2").value == "N/A" || document.getElementById("TRRetiqueta2").value == "")
		  document.getElementById("TRRetiqueta2").value = "Aplazado";
	    document.getElementById("TRRmaximo2").value = fm(LvarMin1 - 0.01, 2);
	    document.getElementById("TRRminimo2").value = fm(LvarMin2, 2);
	  }

	  if (LvarMin2 == 0)
	  {
		document.getElementById("TRRnombre3").value = "No se Pierde el curso";
	    document.getElementById("TRRetiqueta3").value = "N/A";
		document.getElementById("TRRmaximo3").value = "";
		document.getElementById("TRRminimo3").value = "";
	  }
	  else
	  {
		document.getElementById("TRRnombre3").value = "Para Perder el curso";
		if (document.getElementById("TRRetiqueta3").value == "N/A" || document.getElementById("TRRetiqueta3").value == "")
		  document.getElementById("TRRetiqueta3").value = "Reprobado";
	    document.getElementById("TRRmaximo3").value = fm(LvarMin2 - 0.01, 2);
		document.getElementById("TRRminimo3").value = "0.00";
	  }
	}	   
</script>

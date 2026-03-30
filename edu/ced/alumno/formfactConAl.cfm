			<cfif isdefined("Url.o") and not isdefined("Form.o")>
				<cfparam name="Form.o" default="#Url.o#">
			</cfif>
			<cfif isdefined("Url.persona") and not isdefined("Form.persona")>
				<cfset Form.persona = Url.persona>
			</cfif>
			<cfif isdefined("form.persona")>
				<cfparam name="Form.persona" default="#form.persona#">
			</cfif> 
			<cfif isdefined("Url.fFCAperiodicidad") and not isdefined("Form.fFCAperiodicidad")>
				<cfset Form.fFCAperiodicidad = Url.fFCAperiodicidad>
			</cfif>
			<cfif isdefined("Url.fFCid") and not isdefined("Form.fFCid")>
				<cfset Form.fFCid = Url.fFCid>
			</cfif>
			<cfif isdefined("Url.FCid") and not isdefined("Form.FCid")>
				<cfset Form.FCid = Url.FCid>
			</cfif>
			<cfif isdefined("Url.FCAid") and not isdefined("Form.FCAid")>
				<cfset Form.FCAid = Url.FCAid>
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

			<cfif isdefined("Form.Cambio") and isdefined("Form.FCid") and len(trim(form.FCid)) neq 0>
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
			
			<!--- <cfif modo NEQ "ALTA"> --->
			<cfquery datasource="#Session.Edu.DSN#" name="rsFacturaConceptos">
				Select convert(varchar,FCid) as FCid, FCcodigo, 
				substring(FCdescripcion,1,35) as FCdescripcion,	 FCmonto
				from FacturaConceptos 
			</cfquery>
			<cfif isdefined("form.persona") and len(trim(form.persona)) neq 0>
				<cfquery datasource="#Session.Edu.DSN#" name="rsDatosAlumnos">
					Select convert(varchar,Ecodigo) as Ecodigo
					from Alumnos
					where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
				</cfquery>
			</cfif>
<!--- 			<cfif isdefined("form.FCid") and len(trim(form.FCid)) neq 0> --->
			<cfif modo NEQ "ALTA">
				<cfquery datasource="#Session.Edu.DSN#" name="rsFactConceptosAlumno">
					Select convert(varchar,a.FCid) as FCid, 
					convert(varchar,a.Ecodigo) as Ecodigo,  
					convert(varchar,b.persona) as persona, 
					convert(varchar,a.CEcodigo) as CEcodigo,
					a.FCAmontobase,
					(c.Papellido1 + ' ' + c.Papellido2 + ',' + c.Pnombre) as Nombre,
					a.FCAdescuento, 
					a.FCAmontores, 
					a.FCAmontobase,
					a.FCAperiodicidad, 
					convert(varchar,FCfechainicio,103) as FCfechainicio, 
					convert(varchar,FCfechafin,103) as FCfechafin, FCmesinicio,FCmesfin
					from FactConceptosAlumno a, Alumnos b, PersonaEducativo c
					where a.FCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCAid#">
					and a.Ecodigo = b.Ecodigo 
					and b.persona = c.persona  
				</cfquery>
					<!--- a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and a.FCAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCAid#">
					and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
					 --->
				<cfquery dbtype="query" name="rsFactConc">
					select FCdescripcion
					from rsFacturaConceptos						
					where FCid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FCid#">
				</cfquery>				
			</cfif>
			<!-- Hecho por: Rodolfo Jimenez Jara, 31/07/2003 ,Soluciones Integrales S.A. -->
			<script language="JavaScript" type="text/javascript"  src="../../js/utilesMonto.js" >//</script>
			<script language="JavaScript" type="text/javascript"  src="../../js/calendar.js" >//</script>
			<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
			  
			<script language="JavaScript" type="text/javascript">
				// specify the path where the "/qforms/" subfolder is located
				qFormAPI.setLibraryPath("../../js/qForms/");
				// loads all default libraries
				qFormAPI.include("*");
				
				var montoConcepto = new Object();
				<cfloop query="rsFacturaConceptos">
					montoConcepto['<cfoutput>#FCid#</cfoutput>'] = parseFloat(<cfoutput>#FCmonto#</cfoutput>);
				</cfloop>
					
				function changeMonto(id){
					<cfif modo EQ "ALTA">
						//Sugiere el descuento en cero
						document.formfactAl.FCAdescuento.value = "0";
						if (id != "") document.formfactAl.FCAmontobase.value = fm(montoConcepto[id],2);
					</cfif>
				}
				function calculaDescuento(){
					document.formfactAl.FCAmontores.value = fm(new Number(qf(document.formfactAl.FCAmontobase.value)) - (new Number(qf(document.formfactAl.FCAmontobase.value)) * new Number(qf(document.formfactAl.FCAdescuento.value))/100),2);
				}
				
				function validaForm(f) {
					f.obj.FCAmontobase.value = qf(f.obj.FCAmontobase.value);
					f.obj.FCAmontores.value = qf(f.obj.FCAmontores.value);
					f.obj.FCAdescuento.value = qf(f.obj.FCAdescuento.value);
					if (new Number(f.obj.FCAmontores.value) <= 0 || new Number(f.obj.FCAmontobase.value)<=0) {
						alert("Error. No deben de existir montos iguales o inferiores a cero!!!");
						f.obj.FCAmontores.focus();
						return false;
					}
					if ( new Number(f.obj.FCAmontobase.value)<=0) {
						alert("Error. No deben de existir montos iguales o inferiores a cero!!!");
						f.obj.FCAmontobase.focus();
						return false;
					}
					if (new Number(f.obj.FCAdescuento.value)<=0) {
						f.obj.FCAdescuento.value = 0;
					}

					if (new Number(f.obj.FCAdescuento.value)>100) {
						alert("Error. No deben de existir descuentos superiores a 100!!!");
						f.obj.FCAdescuento.focus();
						return false;
					}
					return true;
				}
				var popUpWin=0;
				function popUpWindow(URLStr, left, top, width, height){
				  if(popUpWin) {
					if(!popUpWin.closed) popUpWin.close();
				  }
				  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
				
				function crearNuevoConcepto(c) {				
					if (c.value == "0") {
						c.selectedIndex = 0;
						location.href= "/cfmx/edu/ced/facturacion/Facturacion.cfm?"
						+ "RegresarURL=/cfmx/edu/ced/alumno/alumno.cfm"
						+ "<cfoutput>#UrlEncodedFormat('?')#</cfoutput>"+"persona="+"<cfoutput>#form.persona#</cfoutput>"
						+ "<cfoutput>#UrlEncodedFormat('&')#</cfoutput>"+"o=4";
					}
					else{ 
						if (c.value == "") {
							c.selectedIndex = 0;
						}
					}
				}
				
			</script>
			<!--- <cfinclude template="../../portlets/pNavegacionCED.cfm">
 --->			<form name="formfactAl" method="post" action="SQLFactConAl.cfm" onSubmit="javascript: return validaForm(this);">
			<div id="verDiaEstud"></div>
              <!--- <input name="FCid" id="FCid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsFactConceptosAlumno.FCid#</cfoutput></cfif>" type="hidden">  --->
           	<cfinclude template="../../portlets/pNavegacionCED.cfm"> 
			<cfif isdefined("Form.persona") and len(trim(form.persona)) neq 0>
				<cfinclude template="../../portlets/pAlumnoCED.cfm">
			</cfif>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="0%" nowrap ></td>
      <td width="8%" nowrap ><div align="right"><strong>Concepto &nbsp;</strong></div></td>
      <td width="19%" height="39" > <div align="left"> 
        <cfif modo NEQ "CAMBIO" >
            <select name="FCid" id="FCid" tabindex="1" onChange="javascript: crearNuevoConcepto(this);changeMonto(this.value);calculaDescuento();">
              <cfoutput query="rsFacturaConceptos"> 
                <option value="#FCid#" <cfif modo NEQ "ALTA" AND rsFactConceptosAlumno.FCid EQ rsFacturaConceptos.FCid>selected</cfif>>#FCdescripcion#</option>
              </cfoutput> 
              <option value="">-------------------</option>
              <option value="0">Crear Nuevo ...</option>
            </select>
		<cfelse>
			<cfoutput>#rsFactConc.FCdescripcion#</cfoutput> 
			<input type="hidden" name="FCid" value="<cfoutput>#form.FCid#</cfoutput>">
			<input type="hidden" name="FCAid" value="<cfoutput>#form.FCAid#</cfoutput>">
        </cfif>
        </div></td>
      <td width="3%" nowrap ></td>
      <td width="10%" nowrap ><div align="left"><strong>Fecha de inicio</strong></div></td>
      <td width="9%" ><div align="left"><a href="#"> 
          <input name="FCfechainicio" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfoutput><cfif isdefined('rsFactConceptosAlumno.FCfechainicio') and rsFactConceptosAlumno.FCfechainicio NEQ ''>#rsFactConceptosAlumno.FCfechainicio#<cfelse>#DateFormat(Now(),'DD/MM/YYYY')#</cfif></cfoutput>" size="12" maxlength="10" >
          </a><a href="#"><img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.formfactAl.FCfechainicio');"></a></div></td>
      <td width="5%" ></td>
      <td width="8%" ><div align="left"><strong>Monto</strong></div></td>
      <td width="14%" ><input name="FCAmontobase" align="left" type="text" id="FCAmontobase3" size="22" maxlength="22" style="text-align: right;" value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsFactConceptosAlumno.FCAmontobase,'none')#</cfoutput></cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2);calculaDescuento();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td>
      <td width="0%" >&nbsp;</td>
      <td width="7%" nowrap ><strong>Mes inicio</strong></td>
      <td width="21%" ><div align="left"> 
          <select name="FCmesinicio" id="select8">
            <option value="1" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesinicio EQ '1'> selected</cfif>>Enero</option>
            <option value="2" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesinicio EQ '2'> selected</cfif>>Febrero</option>
            <option value="3" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesinicio EQ '3'> selected</cfif>>Marzo</option>
            <option value="4" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesinicio EQ '4'> selected</cfif>>Abril</option>
            <option value="5" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesinicio EQ '5'> selected</cfif>>Mayo</option>
            <option value="6" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesinicio EQ '6'> selected</cfif>>Junio</option>
            <option value="7" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesinicio EQ '7'> selected</cfif>>Julio</option>
            <option value="8" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesinicio EQ '8'> selected</cfif>>Agosto</option>
            <option value="9" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesinicio EQ '9'> selected</cfif>>Setiembre</option>
            <option value="10 "<cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesinicio EQ '10'> selected</cfif>>Octubre</option>
            <option value="11 "<cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesinicio EQ '11'> selected</cfif>>Noviembre</option>
            <option value="12 "<cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesinicio EQ '12'> selected</cfif>>Diciembre</option>
          </select>
        </div></td>
    </tr>
    <tr> 
      <td nowrap></td>
      <td nowrap><div align="right"><strong>Periodicidad &nbsp;</strong></div></td>
      <td nowrap> <div align="left"> 
          <select name="FCAperiodicidad" id="select7">
            <cfif modo EQ 'CAMBIO' and #rsFactConceptosAlumno.FCAperiodicidad# EQ 'A'>
              <option value="A" selected>Anual</option>
              <cfelse>
              <option value="A">Anual</option>
            </cfif>
            <cfif modo EQ 'CAMBIO' and #rsFactConceptosAlumno.FCAperiodicidad# EQ 'M'>
              <option value="M" selected>Mensual</option>
              <cfelse>
              <option value="M">Mensual</option>
            </cfif>
            <cfif modo EQ 'CAMBIO' and #rsFactConceptosAlumno.FCAperiodicidad# EQ 'S'>
              <option value="S" selected>Semestral</option>
              <cfelse>
              <option value="S">Semestral</option>
            </cfif>
            <cfif modo EQ 'CAMBIO' and #rsFactConceptosAlumno.FCAperiodicidad# EQ 'T'>
              <option value="T" selected>Trimestral</option>
              <cfelse>
              <option value="T">Trimestral</option>
            </cfif>
            <cfif modo EQ 'CAMBIO' and #rsFactConceptosAlumno.FCAperiodicidad# EQ 'B'>
              <option value="B" selected>Bimestral</option>
              <cfelse>
              <option value="B">Bimestral</option>
            </cfif>
          </select>
          <cfif modo NEQ "CAMBIO" >
          </cfif>
        </div></td>
      <td width="3%" nowrap></td>
      <td nowrap><div align="left"><strong>Fecha final</strong></div></td>
      <td nowrap><div align="left"><a href="#"> 
          <input name="FCfechafin" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfoutput><cfif isdefined('rsFactConceptosAlumno.FCfechafin') and rsFactConceptosAlumno.FCfechafin NEQ ''>#rsFactConceptosAlumno.FCfechafin#<cfelse>#DateFormat(Now(),'DD/MM/YYYY')#</cfif></cfoutput>" size="12" maxlength="10" >
          <img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.formfactAl.FCfechafin');"> 
          </a> </div></td>
      <td width="5%"></td>
      <td><div align="left"><strong>Descuento </strong></div></td>
      <td><input name="FCAdescuento" align="left" type="text" id="FCAdescuento3" size="22" maxlength="3" style="text-align: right;" value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsFactConceptosAlumno.FCAdescuento,'none')#</cfoutput></cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0); calculaDescuento();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"></td>
      <td width="0%">&nbsp;</td>
      <td nowrap><strong>Mes final</strong></td>
      <td><div align="left"> 
          <select name="FCmesfin" id="select9">
            <option value="1" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesfin EQ '1'> selected</cfif>>Enero</option>
            <option value="2" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesfin EQ '2'> selected</cfif>>Febrero</option>
            <option value="3" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesfin EQ '3'> selected</cfif>>Marzo</option>
            <option value="4" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesfin EQ '4'> selected</cfif>>Abril</option>
            <option value="5" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesfin EQ '5'> selected</cfif>>Mayo</option>
            <option value="6" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesfin EQ '6'> selected</cfif>>Junio</option>
            <option value="7" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesfin EQ '7'> selected</cfif>>Julio</option>
            <option value="8" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesfin EQ '8'> selected</cfif>>Agosto</option>
            <option value="9" <cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesfin EQ '9'> selected</cfif>>Setiembre</option>
            <option value="10 "<cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesfin EQ '10'> selected</cfif>>Octubre</option>
            <option value="11 "<cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesfin EQ '11'> selected</cfif>>Noviembre</option>
            <option value="12 "<cfif modo NEQ 'ALTA' and isdefined('rsFactConceptosAlumno') and rsFactConceptosAlumno.FCmesfin EQ '12'> selected</cfif>>Diciembre</option>
          </select>
        </div></td>
    </tr>
    <tr> 
      <td ></td>
      <td ><div align="right"></div></td>
      <td ><div align="left"></div></td>
      <td width="3%" ></td>
      <td ><div align="left"></div></td>
      <td > <div align="left"> </div></td>
      <td width="5%"></td>
      <td ><div align="left"><strong>Resultado</strong></div></td>
      <td ><input name="FCAmontores" align="left" type="text" readonly="true" id="FCAmontores3" size="22" maxlength="22" style="text-align: right;" value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsFactConceptosAlumno.FCAmontores,'none')#</cfoutput></cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2);"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
      <td width="0%" >&nbsp;</td>
      <td nowrap >&nbsp;</td>
      <td ><div align="left"> </div></td>
    </tr>
    <tr> 
      <td></td>
      <td><div align="right"></div></td>
      <td> <div align="left"></div></td>
      <td  width="3%"></td>
      <td><div align="left"></div></td>
      <td> <div align="left"><a href="#"> </a> </div></td>
      <td wit width="5%"></td>
      <td><div align="left"></div></td>
      <td></td>
      <td width="0%">&nbsp;</td>
      <td nowrap>&nbsp;</td>
      <td> <div align="left"></div></td>
    </tr>
    <tr> 
      <td></td>
      <td><div align="right"></div></td>
      <td><div align="left"></div></td>
      <td width="3%"></td>
      <td><div align="left"></div></td>
      <td><div align="left"></div></td>
      <td width="5%"></td>
      <td><div align="left"></div></td>
      <td></td>
      <td width="0%">&nbsp;</td>
      <td nowrap>&nbsp;</td>
      <td><div align="left"></div></td>
    </tr>
    <tr> 
      <td colspan="12" align="center"> <input name="Ecodigo" type="hidden" value="<cfif modo NEQ "ALTA"><cfoutput>#rsFactConceptosAlumno.Ecodigo#</cfoutput><cfelseif isdefined("form.persona")><cfoutput>#rsDatosAlumnos.Ecodigo#</cfoutput></cfif>"> 
        <cfinclude template="../../portlets/pBotones.cfm"> </td>
    </tr>
  </table>
			<input name="persona" type="hidden" value="<cfif isdefined("form.persona")><cfoutput>#form.persona#</cfoutput></cfif>"> 
			<input name="o" type="hidden" value="<cfif isdefined("Form.o")><cfoutput>#form.o#</cfoutput></cfif>"> 
			<!--- Campos del filtro para la lista de alumnos --->
			<cfif isdefined("Form.fRHnombre")>
				<input type="hidden" name="fRHnombre" value="<cfoutput>#Form.fRHnombre#</cfoutput>">
			</cfif>		   
			<cfif isdefined("Form.FNcodigo")>
				 <input type="hidden" name="FNcodigo" value="<cfoutput>#Form.FNcodigo#</cfoutput>">
			</cfif>		
			<cfif isdefined("Form.filtroRhPid")>
				 <input type="hidden" name="filtroRhPid" value="<cfoutput>#Form.filtroRhPid#</cfoutput>">
			</cfif>		
			<cfif isdefined("Form.FGcodigo")>
				<input type="hidden" name="FGcodigo" value="<cfoutput>#Form.FGcodigo#</cfoutput>">
			</cfif>
			<cfif isdefined("Form.NoMatr")>
				<input type="hidden" name="NoMatr" value="<cfoutput>#Form.NoMatr#</cfoutput>">
			</cfif>		  		  
			<cfif isdefined("Form.FAretirado")>
				<input type="hidden" name="FAretirado" value="<cfoutput>#Form.FAretirado#</cfoutput>">
			</cfif>
        </form>
 		<form action="alumno.cfm" name="filtrofactConAl" method="post">
		      
  <table width="99%" border="0" class="areaFiltro">
    <tr> 
      <td width="0%"  align="right" ></td>
      <td width="28%"  align="left" nowrap ><strong>Concepto 
        <select name="fFCid" id="fFCid" tabindex="1" >
          <cfif isdefined("form.fFCid") and #form.fFCid# EQ "-1">
            <option value="-1" selected>-- Todos --</option>
            <cfelse>
            <option value="-1">-- Todos --</option>
          </cfif>
          <cfoutput query="rsFacturaConceptos"> 
            <option value="#FCid#"  <cfif isdefined("Form.fFCid") AND #Form.fFCid# EQ #rsFacturaConceptos.FCid# >selected</cfif>>#FCdescripcion#</option>
          </cfoutput> 
        </select>
        </strong></td>
      <td width="15%"  align="left" nowrap ><strong>Inicio <a href="#"> 
        <input name="fFCfechainicio" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)"   value="<cfif isdefined("form.fFCfechainicio") and len(trim(form.fFCfechainicio)) neq 0><cfoutput>#form.fFCfechainicio#</cfoutput></cfif>" size="12" maxlength="10" >
        <img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.filtrofactConAl.fFCfechainicio');"> 
        </a></strong></td>
      <td width="15%"  align="left" nowrap ><strong>Final <a href="#"> 
        <input name="fFCfechafin" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)"  value="<cfif isdefined("form.fFCfechafin") and len(trim(form.fFCfechafin)) neq 0><cfoutput>#form.fFCfechafin#</cfoutput></cfif>" size="12" maxlength="10" >
        <img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.filtrofactConAl.fFCfechafin');"> 
        </a></strong></td>
      <td width="18%"  align="left" nowrap ><strong>Periodicidad</strong> 
        <select name="fFCAperiodicidad" id="fFCAperiodicidad">
          <cfif isdefined("form.fFCAperiodicidad") and #form.fFCAperiodicidad# EQ "-1">
            <option value="-1" selected>-- Todos --</option>
            <cfelse>
            <option value="-1">-- Todos --</option>
          </cfif>
          <cfif isdefined("Form.fFCAperiodicidad") and #form.fFCAperiodicidad# EQ 'A'>
            <option value="A" selected>Anual</option>
            <cfelse>
            <option value="A">Anual</option>
          </cfif>
          <cfif isdefined("Form.fFCAperiodicidad") and #form.fFCAperiodicidad# EQ 'M'>
            <option value="M" selected>Mensual</option>
            <cfelse>
            <option value="M">Mensual</option>
          </cfif>
          <cfif isdefined("Form.fFCAperiodicidad") and #form.fFCAperiodicidad# EQ 'S'>
            <option value="S" selected>Semestral</option>
            <cfelse>
            <option value="S">Semestral</option>
          </cfif>
          <cfif isdefined("Form.fFCAperiodicidad") and #form.fFCAperiodicidad# EQ 'T'>
            <option value="T" selected>Trimestral</option>
            <cfelse>
            <option value="T">Trimestral</option>
          </cfif>
          <cfif isdefined("Form.fFCAperiodicidad") and #form.fFCAperiodicidad# EQ 'B'>
            <option value="B" selected>Bimestral</option>
            <cfelse>
            <option value="B">Bimestral</option>
          </cfif>
        </select>
      </td>
      <td width="24%" align="center" > <input name="btnFiltrar" type="submit" id="btnFiltrar" value="Buscar" > 
        <input name="persona" type="hidden" value="<cfif isdefined("form.persona")><cfoutput>#form.persona#</cfoutput></cfif>"> 
        <input name="o" type="hidden" value="<cfif isdefined("Form.o")><cfoutput>#form.o#</cfoutput></cfif>"> 
      </td>
    </tr>
  </table>
</form>
		<cfinclude template="ListaformFactConAl.cfm">

	
<script language="JavaScript">
			function deshabilitarValidacion() {
				objForm.FCid.required = false;
				objForm.FCAmontobase.required = false;
				objForm.FCAdescuento.required = false;
				objForm.FCAmontores.required = false;		
				objForm.FCAperiodicidad.required = false;
				//objForm.Ecodigo.required = false;
				objForm.FCfechainicio.required = false;
				objForm.FCfechafin.required = false;
			}
			//------------------------------------------------------------------------------------------						
			function habilitarValidacion() {
				objForm.FCid.required = true;
				objForm.FCAmontobase.required = true;
				objForm.FCAdescuento.required = true;
				objForm.FCAmontores.required = true;
				objForm.FCAperiodicidad.required = true;
				//objForm.Ecodigo.required = true;
				objForm.FCfechainicio.required = true;
				objForm.FCfechafin.required = true;
			}	
			//------------------------------------------------------------------------------------------							

			qFormAPI.errorColor = "#FFFFCC";
			objForm = new qForm("formfactAl");
			
			<cfif modo EQ "ALTA" >
				objForm.FCid.required = true;
				objForm.FCid.description = "Concepto";
				objForm.FCAmontobase.required = true;
				objForm.FCAmontobase.description = "monto";
				//objForm.Ecodigo.required = true;
				//objForm.Ecodigo.description = "alumno";
				objForm.FCAdescuento.required = true;
				objForm.FCAdescuento.description = "descuento";
				objForm.FCAmontores.required = true;
				objForm.FCAmontores.description = "resultado";
				objForm.FCfechainicio.required = true;
				objForm.FCfechainicio.description = "Fecha de inicio";				
				objForm.FCfechafin.required = true;
				objForm.FCfechafin.description = "Fecha fin";				
			<cfelseif modo EQ "CAMBIO">
				objForm.FCid.required = true;
				objForm.FCid.description = "Concepto";
				objForm.FCAmontobase.required = true;
				objForm.FCAmontobase.description = "monto";
				//objForm.Ecodigo.required = true;
				//objForm.Ecodigo.description = "alumno";
				objForm.FCAdescuento.required = true;
				objForm.FCAdescuento.description = "descuento";
				objForm.FCAmontores.required = true;
				objForm.FCAmontores.description = "resultado";		
				objForm.FCfechainicio.required = true;
				objForm.FCfechainicio.description = "Fecha de inicio";				
				objForm.FCfechafin.required = true;
				objForm.FCfechafin.description = "Fecha fin";				
			</cfif>	
			// Establecer el monto inicial
			changeMonto(document.formfactAl.FCid.value);
		</script>

<!-- InstanceBegin template="/Templates/LMenuCED.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cfinclude template="../../Utiles/general.cfm">
<cf_template>
	<cf_templatearea name="title">
		Educaci&oacute;n
	</cf_templatearea>
	<cf_templatearea name="body">
		<!-- InstanceBeginEditable name="head" -->
	<script language="JavaScript" src="../../js/utilesMonto.js"></script>
	<script language="JavaScript" type="text/javascript">
			function MM_findObj(n, d) { //v4.01
			  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
				d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
			  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
			  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
			  if(!x && d.getElementById) x=d.getElementById(n); return x;
			}
		
			function MM_swapImgRestore() { //v3.0
			  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
			}
			
			function MM_swapImage() { //v3.0
			  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
			   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
			}
		</script>
	
<!-- InstanceEndEditable -->
		<link href="../../css/portlets.css" rel="stylesheet" type="text/css">
		<link href="../../css/edu.css" rel="stylesheet" type="text/css">
		<script language="JavaScript" type="text/JavaScript">
		<!--
		function MM_reloadPage(init) {  //reloads the window if Nav4 resized
		  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
			document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
		  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
		}
		MM_reloadPage(true);
		//-->
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

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr> 
			<td valign="top">
				<cfset RolActual = 4>
				<cfset Session.RolActual = 4>
				<cfinclude template="../../portlets/pEmpresas2.cfm">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr class="area" style="padding-bottom: 3px;"> 
				  <td nowrap style="padding-left: 10px;">
				  <cfinclude template="../../portlets/pminisitio.cfm">
				  </td>
				  <td valign="top" nowrap> 
			  <!-- InstanceBeginEditable name="MenuJS" --> 
            <cfinclude template="../jsMenuCED.cfm">
      <!-- InstanceEndEditable -->	
				  </td>
				</tr>
			  </table>
			</td>
		  </tr>
		</table>
		  
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr> 
			<td align="left" valign="top" nowrap></td>
			<td width="100%" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" --><!-- InstanceEndEditable --></td>
		  </tr>
		  <tr> 
			<td valign="top" nowrap>
				<cfinclude template="/sif/menu.cfm">
			</td>
			<td valign="top" width="100%">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
				  <td width="2%"class="Titulo"><img  src="../../Imagenes/sp.gif" width="15" height="15" border="0"></td>
				  <td width="3%" class="Titulo" >&nbsp;</td>
				  <td width="94%" class="Titulo">
				  <!-- InstanceBeginEditable name="TituloPortlet" -->Registro de Conceptos de Facturaci&oacute;n por Alumno<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" --> 
			
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
			
			<cfif isdefined("Url.fNombreAl") and not isdefined("Form.fNombreAl")>
				<cfset Form.fNombreAl = Url.fNombreAl>
			</cfif>
		
			<cfif isdefined("Url.fFCAperiodicidad") and not isdefined("Form.fFCAperiodicidad")>
				<cfset Form.fFCAperiodicidad = Url.fFCAperiodicidad>
			</cfif>

			<cfif isdefined("Url.fFCid") and not isdefined("Form.fFCid")>
				<cfset Form.fFCid = Url.fFCid>
			</cfif>
			<!--- <cfif modo NEQ "ALTA"> --->
			<cfquery datasource="#Session.Edu.DSN#" name="rsFacturaConceptos">
				Select convert(varchar,FCid) as FCid, FCcodigo, 
				substring(FCdescripcion,1,35) as FCdescripcion,	 FCmonto
				from FacturaConceptos 
			</cfquery>
			
			<cfif modo NEQ "ALTA">
				<cfquery datasource="#Session.Edu.DSN#" name="rsFactConceptosAlumno">
					Select convert(varchar,a.FCid) as FCid, convert(varchar,a.Ecodigo) as Ecodigo, 
					convert(varchar,a.CEcodigo) as CEcodigo,
					a.FCAmontobase,
					(c.Papellido1 + ' ' + c.Papellido2 + ',' + c.Pnombre) as Nombre,
					a.FCAdescuento, a.FCAmontores, a.FCAmontobase, a.FCAperiodicidad, convert(varchar,FCfechainicio,103) as FCfechainicio, 
							convert(varchar,FCfechafin,103) as FCfechafin, FCmesinicio,FCmesfin
					from FactConceptosAlumno a, Alumnos b, PersonaEducativo c
					where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
					and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
					and a.Ecodigo = b.Ecodigo 
					and b.persona = c.persona  
				</cfquery>
				
				<cfquery dbtype="query" name="rsFactConc">
					select FCdescripcion
					from rsFacturaConceptos						
					where FCid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FCid#">
				</cfquery>				
			</cfif>
			<!-- Hecho por: Rodolfo Jimenez Jara, 10/06/2003 ,Soluciones Integrales S.A. -->
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
			
				function doConlis() {
					popUpWindow("../consultas/conlisAlumnos.cfm?form=formfactAl"
								+"&Ecodigo=Ecodigo"
								+"&NombreAl=NombreAl",250,200,650,350);
				} 
				function crearNuevoConcepto(c) {				
					if (c.value == "0") {
						c.selectedIndex = 0;
						location.href='Facturacion.cfm?RegresarURL=factConAl.cfm';
					}
					else{ 
						if (c.value == "") {
							c.selectedIndex = 0;
						}
					}
				}
				
			</script>
			<cfinclude template="../../portlets/pNavegacionCED.cfm">
			<form name="formfactAl" method="post" action="SQLFactConAl.cfm" onSubmit="javascript: return validaForm(this);">
			<div id="verDiaEstud">&nbsp;</div>
              <!--- <input name="FCid" id="FCid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsFactConceptosAlumno.FCid#</cfoutput></cfif>" type="hidden">  --->
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="subTitulo">Concepto</td>
                  <td class="subTitulo">Alumno</td>
                  <td class="subTitulo">Monto</td>
                  <td class="subTitulo">Descuento</td>
                  <td class="subTitulo">Resultado</td>
                </tr>
                <tr>
                  <td>
				  	<cfif modo NEQ "CAMBIO">
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
					</cfif>
				  </td>
                  <td nowrap>
					<input name="NombreAl" type="text" id="NombreAl" size="50" maxlength="180" readonly="true" value="<cfif modo NEQ "ALTA"><cfoutput>#rsFactConceptosAlumno.Nombre#</cfoutput></cfif>"> 
                    <a href="#"><img src="../../Imagenes/Description.gif" alt="Lista de Alumnos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis();" ></a>				  
				  </td>
                  <td>				  
					<input name="FCAmontobase" align="left" type="text" id="FCAmontobase" size="22" maxlength="22" style="text-align: right;" value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsFactConceptosAlumno.FCAmontobase,'none')#</cfoutput></cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2);calculaDescuento();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
					
				  </td>
                  <td>
					<input name="FCAdescuento" align="left" type="text" id="FCAdescuento" size="10" maxlength="3" style="text-align: right;" value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsFactConceptosAlumno.FCAdescuento,'none')#</cfoutput></cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0); calculaDescuento();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
				  </td>
                  <td>
					<input name="FCAmontores" align="left" type="text" readonly="true" id="FCAmontores" size="22" maxlength="22" style="text-align: right;" value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsFactConceptosAlumno.FCAmontores,'none')#</cfoutput></cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2);"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
				  </td>
                </tr>
                <tr>
                  <td class="subTitulo">Periodicidad</td>
                  <td class="subTitulo">Fecha de inicio</td>
                  <td class="subTitulo">Fecha final</td>
                  <td class="subTitulo">Mes inicio</td>
                  <td class="subTitulo">Mes final</td>
                </tr>
                <tr>
                  <td>
					<select name="FCAperiodicidad" id="FCAperiodicidad">
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
				  </td>
                  <td>
					<a href="#"> 
						<input name="FCfechainicio" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfoutput><cfif isdefined('rsFactConceptosAlumno.FCfechainicio') and rsFactConceptosAlumno.FCfechainicio NEQ ''>#rsFactConceptosAlumno.FCfechainicio#<cfelse>#DateFormat(Now(),'DD/MM/YYYY')#</cfif></cfoutput>" size="12" maxlength="10" >
						<img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.formfactAl.FCfechainicio');"> 
                    </a>				  
				  </td>
                  <td>
					<a href="#"> 
						<input name="FCfechafin" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfoutput><cfif isdefined('rsFactConceptosAlumno.FCfechafin') and rsFactConceptosAlumno.FCfechafin NEQ ''>#rsFactConceptosAlumno.FCfechafin#<cfelse>#DateFormat(Now(),'DD/MM/YYYY')#</cfif></cfoutput>" size="12" maxlength="10" >
						<img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.formfactAl.FCfechafin');"> 
                    </a>				  
				  </td>
                  <td><select name="FCmesinicio" id="FCmesinicio">
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
                    </select></td>
                  <td>
					<select name="FCmesfin" id="FCmesfin">
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
				  </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td colspan="5" align="center">
					<input name="Ecodigo" type="hidden" value="<cfif modo NEQ "ALTA"><cfoutput>#rsFactConceptosAlumno.Ecodigo#</cfoutput></cfif>"> 
                    <cfinclude template="../../portlets/pBotones.cfm">					  
				  </td>
                </tr>				
              </table>
              </form>
		<form action="factConAl.cfm" name="filtrofactConAl" method="post">
		      <table width="100%" border="0" class="areaFiltro">
                <tr> 
                  <td  align="right" >&nbsp;</td>
                  <td  align="left" ><strong>Concepto 
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
                  <td  align="left" ><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar1','','/cfmx/edu/Imagenes/date_d.gif',1)"> 
                    </a><strong>Alumno</strong> 
                    <input name="fNombreAl" type="text" id="fNombreAl" size="50" onFocus="this.select()" maxlength="180" value="<cfif isdefined("Form.fNombreAl") AND #Form.fNombreAl# NEQ "" ><cfoutput>#Form.fNombreAl#</cfoutput></cfif>">
                  </td>
                  <td  align="left" ><strong>Periodicidad</strong> 
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
                  <td align="center" > 
                    <input name="btnFiltrar" type="submit" id="btnFiltrar" value="Buscar" ></td>
                </tr>
              </table>
		</form>

		<cfinclude template="../facturacion/formFactConAl.cfm">
		<script language="JavaScript">
			function deshabilitarValidacion() {
				objForm.FCid.required = false;
				objForm.FCAmontobase.required = false;
				objForm.FCAdescuento.required = false;
				objForm.FCAmontores.required = false;		
				objForm.FCAperiodicidad.required = false;
				objForm.Ecodigo.required = false;
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
				objForm.Ecodigo.required = true;
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
				objForm.Ecodigo.required = true;
				objForm.Ecodigo.description = "alumno";
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
				objForm.Ecodigo.required = true;
				objForm.Ecodigo.description = "alumno";
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
		  <!-- InstanceEndEditable -->
				  </td>
				  <td class="contenido-brborder">&nbsp;</td>
				</tr>
			  </table>
			 </td>
		  </tr>
		</table>

	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->
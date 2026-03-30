<!-- Rodolfo Jimenez Jara, Soluciones Integrales S.A., Costa Rica, America Central, 21/04/2003 -->
 <cfif isdefined("Url.Ecodigo") and not isdefined("Form.Ecodigo")>
	<cfset Form.Ecodigo = Url.Ecodigo>
</cfif>
<cfif isdefined("Form.CEcontrato")>
	<cfset Form.CEcontrato = Form.CEcontrato>
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

<cfif not isdefined("Form.modoDet")>
	<cfset modoDet = "ALTA">
</cfif>

<!-- modo para el detalle -->
<cfif isdefined("Form.CEcontrato")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
	<cfset modoDet="ALTA">
</cfif>

<cfif isdefined("Form.Ecodigo2")>
	<cfset modoDet="CAMBIO">
<cfelse>
	<cfset modoDet="ALTA">
</cfif>  

<cfif isdefined("Form.btnNuevo")>
	<cfset modo="ALTA">
	<cfset modoDet="ALTA">
</cfif>
<!--- Consultas --->
<cfif modo NEQ 'ALTA' and isdefined("Form.CEcontrato") and Form.CEcontrato NEQ "">
	<cfquery datasource="#Session.Edu.DSN#" name="rsContratoEdu">
		select CEcontrato, CEdescripcion, CEcuenta, CEtitular
		from ContratoEdu
		where CEcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
		  and CEcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CEcontrato#">
	</cfquery>
</cfif>	
<cfif modoDet NEQ 'ALTA' and isdefined("Form.Ecodigo2") and Form.Ecodigo2 NEQ "">
	<cfquery datasource="#Session.Edu.DSN#" name="rsAlumnos">
		select convert(varchar,b.Ecodigo) as Ecodigo, substring(c.Papellido1 + ' ' + c.Papellido2 + ', ' + c.Pnombre ,1,80) as nombre
		from Alumnos b, PersonaEducativo c
		where b.CEcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
		  and b.CEcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CEcontrato#">
		  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo2#"> 
		  and b.persona = c.persona
		  and b.CEcodigo = c.CEcodigo 
	</cfquery>
</cfif>	

	
<!---------------------------------------------------------------------------------- --->

<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">

	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function irALista() {
		location.href = "listaContratos.cfm";
	}
	function doConlis(f, opc) {
		if(opc == 1){	// Alumnos
			popUpWindow("../facturacion/conlisAlumnosCont.cfm?form=form1"
					+"&NombreAl=Alumno"
					+"&Ecodigo=Ecodigo",250,200,650,350);
		}
	} 
</script>
<link href="../../css/estilos.css" rel="stylesheet" type="text/css">
<form name="form1" method="post" action="SQLContratos.cfm">
  <!--- <input name="CEcontrato" id="CEcontrato" value="<cfif modo NEQ "ALTA"><cfoutput>#Form.CEcontrato#</cfoutput></cfif>" type="hidden"> --->
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="50%" <cfif modo NEQ "ALTA">colspan="2" </cfif>class="tituloMantenimiento"><cfif modo EQ "ALTA">
          Nuevo 
          <cfelse>
          Modificar 
        </cfif>
        Contrato</td>
    </tr>
    <tr> 
      <td><table width="100%" border="0" dwcopytype="CopyTableCell">
          <cfoutput> 
            <tr> 
              <td <cfif modo NEQ "ALTA">colspan="2" </cfif>valign="top"> <table width="100%" cellpadding="2" cellspacing="2" border="0">
                  <tr> 
                    <td align="left" nowrap><strong>Contrato</strong></td>
                    <td width="70%" nowrap ><input name="CEcontrato" type="text" id="CEcontrato" size="20" tabindex="1" maxlength="20" onFocus="javascript:this.select();" <cfif modo NEQ 'ALTA'>readonly</cfif>  value="<cfif modo NEQ 'ALTA'>#rsContratoEdu.CEcontrato#</cfif>" ></td>
                  </tr>
                  <tr> 
                    <td align="left" nowrap><strong>Descripci&oacute;n</strong></td>
                    <td width="70%" nowrap><input name="CEdescripcion" type="text" id="CEdescripcion" size="80" tabindex="1" maxlength="100" onFocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'>#rsContratoEdu.CEdescripcion#</cfif>"></td>
                  </tr>
                  <tr> 
                    <td align="left" nowrap><strong>Cuenta</strong></td>
                    <td width="70%" nowrap><input name="CEcuenta" type="text" id="CEcuenta" size="20" tabindex="1" maxlength="20" onFocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'>#rsContratoEdu.CEcuenta#</cfif>"></td>
                  </tr>
                  <tr> 
                    <td align="left" nowrap><strong>Titular</strong></td>
                    <td width="70%" nowrap><input name="CEtitular" type="text" id="CEtitular" size="80" tabindex="1" maxlength="100" onFocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'>#rsContratoEdu.CEtitular#</cfif>"></td>
                  </tr>
                </table>
               </td>
            </tr>  
          </cfoutput> 
          <tr> 
            <td nowrap <cfif modo NEQ "ALTA">colspan="2" </cfif>align="center"> 
              <cfif modo EQ "ALTA">
                <input type="submit" name="btnAgregarE" tabindex="1" value="Agregar" onClick="javascript: setBtn(this);">
                <cfelseif modo NEQ "ALTA">
                <input type="submit" name="btnCambiarE" tabindex="1" value="Modificar Contrato" onClick="javascript: setBtn(this); deshabilitarDetalle(); habilitarValidacion();" >
                <input type="submit" name="btnBorrarE" tabindex="1" value="Borrar Contrato" onClick="javascript: setBtn(this); deshabilitarValidacion(); deshabilitarDetalle(); return confirm('¿Esta seguro(a) que desea borrar este Contrato?');" >
                <input type="submit" name="btnNuevoE" tabindex="1" value="Nuevo Contrato" onClick="javascript: setBtn(this); deshabilitarDetalle(); deshabilitarValidacion();" >
              </cfif> <input type="button" name="btnLista" tabindex="1" value="Lista de Contratos" onClick="javascript: irALista();"> 
            </td>
          </tr>
          <cfif modo NEQ "ALTA">
            <tr> 
              <td colspan="2"><hr></td>
            </tr>
            <tr> 
              <td width="50%" valign="top"> 
                <cfinvoke 
			 component="edu.Componentes.pListas"
			 method="pListaEdu"
			 returnvariable="pListaContratoAlum">
                  <cfinvokeargument name="tabla" value="ContratoEdu a,  Alumnos b, PersonaEducativo c"/>
                  <cfinvokeargument name="columnas" value=" convert(varchar,b.Ecodigo) as Ecodigo2, substring(c.Papellido1 + ' ' + c.Papellido2 + ', ' + c.Pnombre ,1,80) as nombre, convert(varchar,b.Aingreso,103) as Aingreso "/>
                  <cfinvokeargument name="desplegar" value="nombre, Aingreso"/>
                  <cfinvokeargument name="etiquetas" value="Nombre del Alumno, Fecha de Ingreso"/>
                  <cfinvokeargument name="formatos" value=""/>
                  <cfinvokeargument name="filtro" value=" b.CEcodigo = #Session.Edu.CEcodigo# 
												    and a.CEcontrato = '#form.CEcontrato#' 
													and a.CEcontrato = b.CEcontrato 
													and a.CEcodigo = b.CEcodigo
													and b.persona = c.persona
													order by nombre, Pid "/>
                  <cfinvokeargument name="align" value="left,right"/>
                  <cfinvokeargument name="ajustar" value="N,N"/>
                  , 
                  <cfinvokeargument name="irA" value="Contratos.cfm"/>
                  <cfinvokeargument name="incluyeForm" value="false"/>
                  <cfinvokeargument name="formName" value="form1"/>
				  
                </cfinvoke> </td>
              <td width="50%" valign="top" style="padding-left: 10px"> 
              <!---   <cfif modoDet NEQ "ALTA"> --->
                  <input type="hidden" name="Ecodigo" id="Ecodigo" value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsAlumnos.Ecodigo#</cfoutput><cfelseif isdefined("form.Ecodigo")><cfoutput>#Form.Ecodigo#</cfoutput></cfif>">
				  <div style="display: ;" id="verDiaEstud">&nbsp;</div>
                <!--- </cfif>  ---><table border="0" width="100%" cellpadding="2" cellspacing="2">
                  <tr> 
                    <td width="37%" align="right" nowrap><strong>Nombre</strong></td>
                    <td width="63%" nowrap>
						<cfif modoDet eq "ALTA">
							<input name="Alumno" type="text"  readonly="true" id="Alumno" size="40" maxlength="80" value="<cfif isdefined('form.Alumno') ><cfoutput>#form.Alumno#</cfoutput></cfif>">
							<a href="#"> <img src="../../Imagenes/Description.gif" alt="Lista de Alumnos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis(document.form1, 1);"> </a>
						<cfelse>
<!--- 							<input name="Alumno2" type="text" class="cajasinborde" readonly="true" id="Alumno2" size="40" maxlength="80" value="<cfif modoDet neq "ALTA"><cfoutput>#rsAlumnos.nombre#</cfoutput> <cfelseif isdefined('form.Alumno') ><cfoutput>#form.Alumno#</cfoutput></cfif>"> --->
							<input name="Alumno2" style="text-align:left" type="text" class="cajasinborde" tabindex="-1" value="<cfif modoDet neq "ALTA"><cfoutput>#rsAlumnos.nombre#</cfoutput> <cfelseif isdefined('form.Alumno') ><cfoutput>#form.Alumno#</cfoutput></cfif>"  size="60" readonly="">
						</cfif>					
                      </td>
                  </tr>
                  <tr> 
                    <td align="right" nowrap>&nbsp;</td>
                    <td nowrap></td>
                  </tr>
                  <tr align="center"> 
                    <td colspan="2"> </td>
                  </tr>
                  <tr> 
                    <td colspan="2" align="center"> <cfif modoDet EQ "ALTA">
                        <input type="submit" name="btnAgregarD" tabindex="4" value="Agregar Alumno" onClick="javascript: setBtn(this); habilitarDetalle(); habilitarValidacion(); " >
                        <cfelseif modoDet NEQ "ALTA">
                        <input type="submit" name="btnBorrarD" tabindex="4" value="Borrar Alumno" onClick="javascript: setBtn(this); deshabilitarValidacion(); deshabilitarDetalle(); return confirm('¿Esta seguro(a) que desea borrar este alumno?')" >
                        <input type="submit" name="btnNuevoD" tabindex="4" value="Nuevo Alumno" onClick="javascript: setBtn(this); deshabilitarValidacion(); deshabilitarDetalle();" >
                      </cfif> </td>
                  </tr>
                </table></td>
            </tr>
          </cfif>
        </table></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
  </table>

</form>  
<script language="JavaScript">
	function deshabilitarValidacion() {
		objForm.CEdescripcion.required = false;
		objForm.CEcontrato.required = false;		
	}
	
	function habilitarValidacion() {
		objForm.CEdescripcion.required = true;
		objForm.CEdescripcion.description = "Descripción";
		objForm.CEcontrato.required = true;
		objForm.CEcontrato.description = "Contrato";
	}	
	
	function deshabilitarDetalle() {
		objForm.Ecodigo.required = false;
	}

	function habilitarDetalle() {
		objForm.Ecodigo.required = true;
		objForm.Ecodigo.description = "Alumno";
	}

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	

	<cfif modoDet EQ "ALTA">
		objForm.CEdescripcion.required = true;
		objForm.CEdescripcion.description = "Descripción";	
		objForm.CEcontrato.required = true;
		objForm.CEcontrato.description = "Contrato";	
	<cfelse>
		objForm.CEdescripcion.required = true;
		objForm.CEdescripcion.description = "Descripción";	
		objForm.CEcontrato.required = true;
		objForm.CEcontrato.description = "Contrato";	
		<cfif modoDet EQ "ALTA">
			objForm.Ecodigo.required = true;
			objForm.Ecodigo.description = "Nombre del Alumno";
		<cfelse>
			objForm.Ecodigo.required = true;
			objForm.Ecodigo.description = "Nombre del Alumno";
			//objForm.Ecodigo.validateValida();			
		</cfif>
	</cfif>	
			
</script>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="MSG_DebeDigitarUnPorcentajeEntre0Y100" Default="Debe digitar un porcentaje entre 0 y 100%" returnvariable="MSG_DebeDigitarUnPorcentajeEntre0Y100" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Administracion_de_Personas"
Default="Administraci&oacute;n de Personas"
returnvariable="LB_Administracion_de_Personas"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined('Form.Cambio') or isdefined('form.DEid')>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined('Form.modo')>
		<cfset modo="ALTA">
<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>



<cfif modo EQ "CAMBIO" and isdefined('form.DEid')> 
	<cfquery datasource="#Session.DSN#" name="rsEmpleado">
		select 	DEid,			NTIcodigo, 		DEidentificacion, 
				DEnombre, 	DEapellido1, 		DEapellido2,		DEsexo,
				CBcc, 		DEdireccion, 		DEcivil,			DEtelefono1,	
				DEtelefono2,	DEemail,			DEfechanac,		DEobs1, 
				DEobs2,		DEobs3,			DEobs4,			DEobs5,
				DEdato1,		DEdato2,			DEdato3,			DEdato4, 
				DEdato5,		DEdato6,			DEdato7,			DEinfo1, 
			   	DEinfo2, 		DEinfo3, 			DEinfo4,			DEinfo5,
			   		DEtarjeta, 			ts_rversion,		Bid,
			   	Ppais, 		CBTcodigo,		DEcuenta, rutafoto 
				
		from EDPersonas
		  
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		
	</cfquery>
</cfif>
<cfquery name="rsTipoIdent" datasource="#Session.DSN#">
	select NTIcodigo, NTIdescripcion, NTImascara
	from NTipoIdentificacion
	order by NTIdescripcion
</cfquery>
<script language="javascript1.2" type="text/javascript">
	var validarIdentificacion = true;
	var id_mascaras = new Object();
	<cfoutput query="rsTipoIdent">
		id_mascaras['#trim(rsTipoIdent.NTIcodigo)#'] = '#trim(rsTipoIdent.NTImascara)#';
	</cfoutput>
</script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	
	function funcGuardarContinuar() {
		if (objForm.validate()) {
			document.formDatosEmpleado.ACCION.value = "1";
			document.formDatosEmpleado.submit();
		}	
	}

	function funcGuardarNuevo() {
		if (objForm.validate()){
			document.formDatosEmpleado.ACCION.value = "2";
			document.formDatosEmpleado.submit();
		}
	}

	function funcEliminar() {
		<!--- Validar que la empresa puede ser eliminada --->
		
		if (objForm.validate()) {
			deshabilitarValidacion();
			document.formDatosEmpleado.ACCION.value = "3";
			document.formDatosEmpleado.submit();
		}
	}

	function funcCancelar() {
		location.href = '/cfmx/rh/ExpDeportivo/usuarios/expediente-lista.cfm';
	}
	


	
	
</script>
<cfquery name="rsPais" datasource="asp">
select Ppais, Pnombre
from Pais
</cfquery>
<cf_templateheader title="#LB_Administracion_de_Personas#">
<cf_web_portlet_start titulo="#LB_Administracion_de_Personas#">

<form method="post" enctype="multipart/form-data" name="formDatosEmpleado" action="SQLdatosEmpleado.cfm" onsubmit="javascript: return validar_mascara( this.DEidentificacion.value, this.NTIcodigo.value );">
<input name="ACCION" type="hidden" value="0">
<input name="modo" type="hidden" value="<cfoutput>#modo#</cfoutput>">
  <table width="100%" border="0" cellpadding="0" cellspacing="0">   
 
  	
  	<td colspan="2" bgcolor="#0033FF">
		<cfinclude template="/rh/ExpDeportivo/Proyecto/frame-botones.cfm">
	
	</td>
  </tr>
  <tr>
  <td>&nbsp;</td>
  </tr>
     
      </td>
      <td valign="top" nowrap>    
	  	<cfif modo EQ 'CAMBIO' and isdefined('form.DEid')>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td align="center">
				  <cfinclude template="/rh/expediente/catalogos/frame-foto.cfm">
				</td>
			  </tr>
			</table>
		</cfif>
      </td>
      <td valign="top" nowrap>   
			
				<input type="hidden" name="DEid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEid#</cfoutput></cfif>">
				<cfset ts = "">
				<cfif modo NEQ "ALTA">
					<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsEmpleado.ts_rversion#" returnvariable="ts"></cfinvoke>
					<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
				</cfif>				
			  <table width="100%" border="0" cellspacing="0" cellpadding="2">
			  					
                <tr>  
                	<td colspan="3">   
                    	<fieldset><legend> Identificaci&oacute;n</legend>
                         	<table width="100%" border="0" cellspacing="0" cellpadding="2">
								<!--- ******************************** --->
									<tr> 
				  <td class="fileLabel"><cf_translate key="LB_Nombre" xmlfile="/rh/generales.xml">Nombre</cf_translate></td>
				  <td class="fileLabel"><cf_translate key="LB_Primer_Apellido" xmlfile="/rh/generales.xml">Primer Apellido</cf_translate></td>
				  <td class="fileLabel"><cf_translate key="LB_Segundo_Apellido" xmlfile="/rh/generales.xml">Segundo Apellido</cf_translate></td>
				</tr>
				<tr> 
				  <td><input name="DEnombre" type="text" id="DEnombre2" size="40" maxlength="100" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEnombre#</cfoutput></cfif>"></td>
				  <td><input name="DEapellido1" type="text" id="DEapellido12" size="40" maxlength="80" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEapellido1#</cfoutput></cfif>"></td>
				  <td><input name="DEapellido2" type="text" id="DEapellido22" size="40" maxlength="80" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEapellido2#</cfoutput></cfif>"></td>
				</tr>
                                <tr> 
                                  <td class="fileLabel"><cf_translate key="LB_Tipo_de_Identificacion" xmlfile="/rh/generales.xml">Tipo de Identificaci&oacute;n</cf_translate></td>
                                  <td class="fileLabel"><cf_translate key="LB_Identificacion" xmlfile="/rh/generales.xml">Identificaci&oacute;n</cf_translate></td>
                                 <td class="fileLabel"><cf_translate key="LB_Vencimiento" xmlfile="/rh/generales.xml">Vencimiento</cf_translate></td> 
                                </td>     
                                </tr>                                      
                               
                                <tr>
                                     <td>
                                         <select name="NTIcodigo" id="select" onchange="javascript:cambiar_mascara(this, true);" >
                                            <cfoutput query="rsTipoIdent">
                                              <option value="#rsTipoIdent.NTIcodigo#" <cfif modo NEQ 'ALTA' and rsEmpleado.NTIcodigo EQ rsTipoIdent.NTIcodigo> selected</cfif>>#rsTipoIdent.NTIdescripcion#</option>
                                            </cfoutput>
                                          </select>
                                      </td>
	                                  <td>
                                   		 <input name="DEidentificacion" type="text" id="DEidentificacion" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEidentificacion#</cfoutput></cfif>">
                                   	  </td>
                                      	
                                     <td> 
										<cfif modo NEQ 'ALTA'>
                                            <cfset fecha = LSDateFormat(rsEmpleado.DEdato1, "DD/MM/YYYY")>
                                        <cfelse>
                                            <cfset fecha = "">
                                        </cfif>
                                        <cf_sifcalendario form="formDatosEmpleado" value="#fecha#" name="DEdato1">				   
                                  	</td>
                                </tr>
                                 <tr>
                                  <td class="fileLabel"><cf_translate key="LB_Pasaporte" xmlfile="/rh/generales.xml">Pasaporte</cf_translate></td> 
                                  <td>
                                    <input name="DEdato2" type="text" id="DEdato2" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEdato2#</cfoutput></cfif>">
                                  </td>
                                  <td> 
                                    <cfif modo NEQ 'ALTA'>
                                        <cfset fecha = LSDateFormat(rsEmpleado.DEdato3, "DD/MM/YYYY")>
                                    <cfelse>
                                       <cfset fecha = "">
                                    </cfif>
                                    <cf_sifcalendario form="formDatosEmpleado" value="#fecha#" name="DEdato3">				   
                                  </td>
                                </tr>
                                 <tr>
                                  <td class="fileLabel"><cf_translate key="LB_Seguro_Social" xmlfile="/rh/generales.xml">Seguro Social</cf_translate></td> 
                                  <td>
                                    <input name="DEdato4" type="text" id="DEdato4" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEdato4#</cfoutput></cfif>">
                                  </td>
                                   <td> 
                                    <cfif modo NEQ 'ALTA'>
                                        <cfset fecha = LSDateFormat(rsEmpleado.DEdato5, "DD/MM/YYYY")>
                                    <cfelse>
                                        <cfset fecha = "">
                                    </cfif>
                                    <cf_sifcalendario form="formDatosEmpleado" value="#fecha#" name="DEdato5">				   
                                  </td>
                                </tr>
                                
								<!--- ******************************** --->
                            </table>
                        </fieldset>
                
                

				
				<tr> 
				  <td class="fileLabel"><cf_translate key="LB_Estado_Civil" xmlfile="/rh/generales.xml">Estado Civil</cf_translate></td>
				  <td class="fileLabel"><cf_translate key="LB_Fecha_de_Nacimiento" >Fecha de Nacimiento</cf_translate></td>
				  <td class="fileLabel"><cf_translate key="LB_Sexo" xmlfile="/rh/generales.xml">Sexo</cf_translate></td>
				</tr>
				
				
				<tr> 
				  <td><select name="DEcivil" id="DEcivil">
					  <option value="0" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 0> selected</cfif>><cf_translate key="LB_Soltero">Soltero(a)</cf_translate></option>
					  <option value="1" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 1> selected</cfif>><cf_translate key="LB_Casado">Casado(a)</cf_translate></option>
					  <option value="2" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 2> selected</cfif>><cf_translate key="LB_Divorciado">Divorciado(a)</cf_translate></option>
					  <option value="3" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 3> selected</cfif>><cf_translate key="LB_Viudo">Viudo(a)</cf_translate></option>
					  <option value="4" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 4> selected</cfif>><cf_translate key="LB_UnionLibre">Union Libre</cf_translate></option>
					  <option value="5" <cfif modo NEQ 'ALTA' and rsEmpleado.DEcivil EQ 5> selected</cfif>><cf_translate key="LB_Separado">Separado(a)</cf_translate></option>
					</select></td>
				  <td> 
					<cfif modo NEQ 'ALTA'>
						<cfset fecha = LSDateFormat(rsEmpleado.DEfechanac, "DD/MM/YYYY")>
					<cfelse>
						<cfset fecha = LSDateFormat(Now(), "DD/MM/YYYY")>
					</cfif>
 				    <cf_sifcalendario form="formDatosEmpleado" value="#fecha#" name="DEfechanac">				   
				  </td>
				  <td><select name="DEsexo" id="select2">
                    <option value="M" <cfif modo NEQ 'ALTA' and rsEmpleado.DEsexo EQ 'M'> selected</cfif>><cf_translate key="LB_Masculino">Masculino</cf_translate></option>
                    <option value="F" <cfif modo NEQ 'ALTA' and rsEmpleado.DEsexo EQ 'F'> selected</cfif>><cf_translate key="LB_Femenino">Femenino</cf_translate></option>
                  </select></td>
				</tr>
				<tr>
				  <td class="fileLabel"><cf_translate key="LB_Direccion" xmlfile="/rh/generales.xml">Direcci&oacute;n</cf_translate></td>
				  <td class="fileLabel">&nbsp;</td>
			      <td>&nbsp;</td>
				</tr>
				<tr>
				  <td colspan="3" class="fileLabel">
				  	<textarea name="DEdireccion" id="DEdireccion" rows="2" style="width: 100%;"><cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEdireccion#</cfoutput></cfif></textarea>
				  </td>
		        </tr>
				<tr> 
				  <td class="fileLabel"><cf_translate key="LB_Telefono_de_Residencia">Tel&eacute;fono de Residencia</cf_translate></td>
				  <td class="fileLabel"><cf_translate key="LB_Telefono_Celular">Tel&eacute;fono Celular</cf_translate></td>
				  <td class="fileLabel"><cf_translate key="LB_Direccion_Electronica">Direcci&oacute;n electr&oacute;nica</cf_translate></td>
				</tr>
				<tr> 
				  <td><input name="DEtelefono1" type="text" id="DEtelefono13"  value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEtelefono1#</cfoutput></cfif>" size="30" maxlength="30"></td>
				  <td><input name="DEtelefono2" type="text" id="DEtelefono2"  value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEtelefono2#</cfoutput></cfif>" size="30" maxlength="30"></td>
				  <td><input name="DEemail" type="text" id="DEemail"  value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEemail#</cfoutput></cfif>" size="40" maxlength="120"></td>
				</tr>
                
				<tr>
					<td class="fileLabel"><cf_translate key="LB_Pais_de_Nacimiento">Pa&iacute;s de Nacimiento</cf_translate></td>
					 <td class="fileLabel">
			
					  <cf_translate key="LB_Ruta_De_La_Foto"  xmlfile="/rh/generales.xml">Ruta de la foto</cf_translate>
					
				</tr>
				<tr>
					<td class="fileLabel">
						<select name="Ppais">
							<option value="">(<cf_translate key="CMB_Seleccione_un_Pais">Seleccione un Pa&iacute;s</cf_translate>)</option>
							<cfoutput query="rsPais">
								<option value="#Ppais#"<cfif modo NEQ 'ALTA' and rsPais.Ppais EQ rsEmpleado.Ppais> selected</cfif>>#Pnombre#</option>
							</cfoutput>
						</select>
					</td>
					 <td>
					
				  	<input name="rutaFoto" type="file" id="rutaFoto2">
				
				  </td>
                  <td>&nbsp;</td>
				</tr>
                <tr> 
                	<td  colspan="3">
                    	<fieldset><legend><cf_translate key="LB_Educacion">Educaci&oacute;n</cf_translate></legend>
                        	<table width="100%" border="0" cellspacing="0" cellpadding="2">
                                <tr> 
                                   <td class="fileLabel" width="15%"><cf_translate key="LB_Nivel">Nivel</cf_translate></td>
                                   <td class="fileLabel" width="20%"><cf_translate key="LB_Annos_Aprobados">&Uacute;timo A&ntilde;o Aprobado</cf_translate></td>
                                   <td class="fileLabel"><cf_translate key="Nombre_Escuela">Instituci&oacute;n</cf_translate></td>
                                </tr>
                                <tr>
                                  <td class="fileLabel"><cf_translate key="LB_primaria">Primaria</cf_translate></td>
                                  <td ><select name="DEinfo1" id="DEinfo1">
                                      <option value=""><cf_translate key="LB_ninguno">NINGUNO</cf_translate></option>
                                      <option value="1" <cfif modo NEQ 'ALTA' and rsEmpleado.DEinfo1 EQ 1> selected</cfif>><cf_translate key="LB_1">1</cf_translate></option>
                                      <option value="2" <cfif modo NEQ 'ALTA' and rsEmpleado.DEinfo1 EQ 2> selected</cfif>><cf_translate key="LB_2">2</cf_translate></option>
                                      <option value="3" <cfif modo NEQ 'ALTA' and rsEmpleado.DEinfo1 EQ 3> selected</cfif>><cf_translate key="LB_3">3</cf_translate></option>
                                      <option value="4" <cfif modo NEQ 'ALTA' and rsEmpleado.DEinfo1 EQ 4> selected</cfif>><cf_translate key="LB_4">4</cf_translate></option>
                                      <option value="5" <cfif modo NEQ 'ALTA' and rsEmpleado.DEinfo1 EQ 5> selected</cfif>><cf_translate key="LB_5">5</cf_translate></option>
                                      <option value="6" <cfif modo NEQ 'ALTA' and rsEmpleado.DEinfo1 EQ 6> selected</cfif>><cf_translate key="LB_6">6</cf_translate></option>
                                    </select>
                                  </td>
                                  <td ><input name="DEinfo2" type="text" id="DEinfo2" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEinfo2#</cfoutput></cfif>" size="50" maxlength="50"></td>
                                </tr>
                                <tr>
                                   <td class="fileLabel"><cf_translate key="LB_secundaria">Secundaria</cf_translate></td>
                                  <td><select name="DEinfo3" id="DEinfo3">
                                      <option value=""><cf_translate key="LB_ninguno">NINGUNO</cf_translate></option>
                                      <option value="1" <cfif modo NEQ 'ALTA' and rsEmpleado.DEinfo3 EQ 1> selected</cfif>><cf_translate key="LB_1">1</cf_translate></option>
                                      <option value="2" <cfif modo NEQ 'ALTA' and rsEmpleado.DEinfo3 EQ 2> selected</cfif>><cf_translate key="LB_2">2</cf_translate></option>
                                      <option value="3" <cfif modo NEQ 'ALTA' and rsEmpleado.DEinfo3 EQ 3> selected</cfif>><cf_translate key="LB_3">3</cf_translate></option>
                                      <option value="4" <cfif modo NEQ 'ALTA' and rsEmpleado.DEinfo3 EQ 4> selected</cfif>><cf_translate key="LB_4">4</cf_translate></option>
                                      <option value="5" <cfif modo NEQ 'ALTA' and rsEmpleado.DEinfo3 EQ 5> selected </cfif>><cf_translate key="LB_5">5</cf_translate></option>
                                      <option value="6" <cfif modo NEQ 'ALTA' and rsEmpleado.DEinfo3 EQ 6> selected</cfif>><cf_translate key="LB_6">6</cf_translate></option>
                                    </select>
                                   </td>
                                   <td ><input name="DEinfox" type="text" id="DEinfox" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEmpleado.DEinfo2#</cfoutput></cfif>" size="50" maxlength="50"></td>

                                </tr>
                            </table>
                        </fieldset>
                    </td>
                </tr>    
				
                
                
				<tr> 
				  <td colspan="3" align="center">&nbsp;</td>
				</tr>

			  </table>
			</form>
      	
</table>

<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/calendar.js">//</script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>

<script language="JavaScript" type="text/javascript">
//------------------------------------------------------------------------------------------
	function deshabilitarValidacion(){
		validarIdentificacion = false;
	
		objForm.NTIcodigo.required = false;
		objForm.DEidentificacion.required = false;
		objForm.DEnombre.required = false;
		objForm.DEcivil.required = false;
		objForm.DEfechanac.required = false;
		objForm.DEsexo.required = false;
	}
//------------------------------------------------------------------------------------------
	function habilitarValidacion(){
		validarIdentificacion = true;

		objForm.NTIcodigo.required = true;
		objForm.DEidentificacion.required = true;
		objForm.DEnombre.required = true;
		objForm.DEcivil.required = true;
		objForm.DEfechanac.required = true;
		objForm.DEsexo.required = true;	
		//Validacion de los datos variables por empresa
	}
	
	function validar_mascara( _v, _m ){
		
		if ( !validarIdentificacion ) return true;
		
		var LvarValor = _v; 
		
		var LvarMascara = '';
		if (id_mascaras[_m]){
			LvarMascara = id_mascaras[_m];
		}
		
		var r = "x#*", rx = {"x": new RegExp("[A-Za-z]"), "#": new RegExp("[0-9]"), "*": new RegExp("[A-Za-z0-9]") };
	
		if (LvarMascara.length == 0)
			return true;
	
		var v = 0, u = -1, pf=true, m = 0, nv = "", sv = "";
		if (LvarValor.length > 0)
		{
			while (m <= LvarMascara.length)
			{
				c = LvarValor.charAt(v);
				p = LvarMascara.charAt(m);
				if ( (p!="") && (r.indexOf(p) > -1) ) 
				{
					if (v >= LvarValor.length)
					{
						pf = false;
						break;
					}
	
					if (rx[p].test(c))
					{
						nv = nv + c;
						sv = sv + c;
						m++;
						u = nv.length;
					}
					v++;
				}
				else
				{
					if (p == "!")
						p = LvarMascara.charAt(m++);
					nv = nv + p;
					m++;
					if (p == c) v++;
				}
			}
		}
		nv = nv.substring(0, u);


		
		return true
	}	
	
	function cambiar_mascara(obj, borrar){
		if ( borrar ) document.formDatosEmpleado.DEidentificacion.value = '';

	}
	cambiar_mascara(document.formDatosEmpleado.NTIcodigo, <cfif modo neq 'ALTA'>false<cfelse>true</cfif>  );
	
//------------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");			
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formDatosEmpleado");
		
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tipo_de_Identificacion"
	Default="Tipo de Identificación"
	xmlfile="/rh/generales.xml"
	returnvariable="MSG_TipoDeIdentificacion"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificación"
	xmlfile="/rh/generales.xml"
	returnvariable="MSG_Identificacion"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	xmlfile="/rh/generales.xml"
	returnvariable="MSG_Nombre"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Cuenta_Cliente"
	Default="Cuenta Cliente"
	returnvariable="MSG_CuentaCliente"/>		

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estado_Civil"
	Default="Estado Civil"
	xmlfile="/rh/generales.xml"
	returnvariable="MSG_EstadoCivil"/>	

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_de_Nacimiento"
	Default="Fecha de Nacimiento"
	returnvariable="MSG_FechaDeNacimieto"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Moneda"
	xmlfile="/rh/generales.xml"
	Default="Moneda"
	returnvariable="MSG_Moneda"/>	

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Sexo"
	Default="Sexo"
	xmlfile="/rh/generales.xml"
	returnvariable="MSG_Sexo"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tipo_de_Empleado"
	Default="Tipo de Empleado"
	returnvariable="MSG_TipoDeEmpleado"/>	

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Numero_de_Concesiones"
	Default="Número de Concesiones"
	returnvariable="MSG_NUmeroDeConcesiones"/>	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_PorcentajeDeAnticipoDeSalario"
	Default="Porcentaje de Anticipo de Salario"
	returnvariable="MSG_PorcentajeDeAnticipoDeSalario"/>	
	objForm.NTIcodigo.required = true;
	objForm.NTIcodigo.description = "<cfoutput>#MSG_TipoDeIdentificacion#</cfoutput>";	

	objForm.DEidentificacion.required = true;
	objForm.DEidentificacion.description = "<cfoutput>#MSG_Identificacion#</cfoutput>";
	
	objForm.DEnombre.required = true;
	objForm.DEnombre.description = "<cfoutput>#MSG_Nombre#</cfoutput>";	
	objForm.DEcivil.required = true;
	objForm.DEcivil.description = "<cfoutput>#MSG_EstadoCivil#</cfoutput>";			
	objForm.DEfechanac.required = true;
	objForm.DEfechanac.description = "<cfoutput>#MSG_FechaDeNacimieto#</cfoutput>";				
	objForm.DEsexo.required = true;
	objForm.DEsexo.description = "<cfoutput>#MSG_Sexo#</cfoutput>";
	
	
</script>
<cf_web_portlet_end>
<cf_templatefooter>
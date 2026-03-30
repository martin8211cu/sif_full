<cfquery datasource="sdc" name="familia">
	select Pid, Pnombre + ' ' + Papellido1 + ' ' + Papellido2 as Nombre
	from Familiares
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#session.Usucodigo#">
	  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
	  and Ppais = 'CR'
	  and dependiente = 1
</cfquery>
<cfinclude template="../../../Utiles/general.cfm">
<cfif isDefined("url.TPID")><cflocation url="../index.cfm?TPID=#url.TPID#"></cfif>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
Trámites
</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">

<cf_web_portlet titulo="Iniciar tramite">

<SCRIPT SRC="../../../js/qForms/qforms.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">
<!--//
// specify the path where the "/qforms/" subfolder is located
qFormAPI.setLibraryPath("../../../js/qForms/");
// loads all default libraries
qFormAPI.include("*");
//qFormAPI.include("validation");
//qFormAPI.include("functions", null, "12");
//-->
</SCRIPT>

    <form name="form1" action="trpass01-apply.cfm" method="post">

<table width="100%" border="0" cellspacing="2" cellpadding="4">
                <!--DWLayoutTable-->
                <tr> 
                  <td width="17">&nbsp;<input type="hidden" name="paso"></td>
                  <td width="418" >&nbsp;</td>
                  <td width="448" align="right" ><cfinclude template="nav.cfm"></td>
                  <td width="1">&nbsp;</td>
                </tr>
                <tr> 
                  <td></td>
                  <td valign="top"><p><strong>
                    <cfinclude template="logo.cfm">
                  Introducci&oacute;n:</strong> <br>
                      Mediante esta opci&oacute;n, usted puede solicitar un permiso para iniciar una construcci&oacute;n nueva o realizar una remodelaci&oacute;n de un local existente, agilizando 
                      este proceso as&iacute; como los pagos de derechos correspondientes.</p>
                      <p><strong>Requisitos:</strong>
                    <ol>
                      <li>C&eacute;dula de identidad vigente y en buen estado.</li>
                      <li>Fotocopia de Cédula de identidad (anotar por el frente 
                        direcci&oacute;n exacta y tel&eacute;fono).</li>
                      <li>N&uacute;mero de c&eacute;dula registral (tomo, folio y asiento) de su propiedad.</li>
                      <li>Fecha y n&uacute;mero de licencia profesional del m&eacute;dico que expide su certificado m&eacute;dico.<br>
                      </li>
                    </ol> 
                    </p>
                    <font size="3"><strong>Paso 1 de 5:</strong></font> <span class="subTitulo">Solicitud 
                    del Tr&aacute;mite<br>
                    </span>
                    <table border="0" cellpadding="6">
                          <cfif #familia.RecordCount# GT 0>
                      <tr> 
                        <td><strong>Solicitar permiso para:</strong></td>
                        <td>
                          <select name="select" onChange="document.form1.cedula.value=this.value">
						  	<option value="">[ Seleccionar ]</option>
                            <cfoutput query="familia">
                              <option value="#familia.Pid#">#familia.Nombre#</option>
                            </cfoutput> 
                            <option value="">Otro...</option>
                          </select>
                        </td>
                      </tr>
                          </cfif>
                      <tr> 
                        <td><strong>N&uacute;mero de C&eacute;dula:</strong></td>
                        <td><input type="text" name="cedula" title="Ej: 9-1234-5678">
                          <strong>X-XXXX-XXXX</strong></td>
                      </tr>
                      <tr>
                        <td align="center" >N&uacute;mero de c&eacute;dula registral </td>
                        <td align="left" ><table border="0">
                          <tr>
                            <td>Tomo</td>
                            <td>Folio</td>
                            <td>Asiento</td>
                          </tr>
                          <tr>
                            <td><input name="textfield" type="text" size="8"></td>
                            <td><input name="textfield4" type="text" size="8"></td>
                            <td><input name="textfield5" type="text" size="8"></td>
                          </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td align="center" >Fecha de inicio de construcci&oacute;n </td>
                        <td align="left" ><input type="text" name="textfield3">
                          <strong>                          dd/mm/aaaa</strong> </td>
                      </tr>
                      <tr>
                        <td align="center" >Ingeniero responsable: </td>
                        <td align="left" ><input type="text" name="textfield22"></td>
                      </tr>
                      <tr>
                        <td align="center" >N&uacute;mero de carnet de colegio de Ingenieros y Arquitectos: </td>
                        <td align="left" ><input type="text" name="textfield2"></td>
                      </tr>
                      <tr> 
                        <td colspan="2" align="center" ><span class="subTitulo"> 
                          <input type="submit" name="Solicitar" value="Solicitar">
                          </span></td></tr>
                      <tr>
                        <td colspan="2" align="center" >&nbsp;</td>
                      </tr>
                    </table>
                    <span class="subTitulo"><br>
                    <br>
                    </span> </td>
                  <td valign="top" bgcolor="#eeeeee" style="border:1px solid black" ><div align="left"> 
                      <strong>Pasos:</strong><br>
                      Los pasos para solicitud de permiso de construcci&oacute;n por medio del portal 
                      son: 
                      <ol>
                        <li>Ingreso de solicitud de permiso de construcci&oacute;n
                          a trav&eacute;s de el n&uacute;mero de c&eacute;dula del propietario y de el lote en que se va a realizar la construcci&oacute;n o ampliaci&oacute;n.</li>
                        <li> Una vez validada su solicitud, usted podr&aacute; 
                          solicitar: 
                            <ol type="a">
                            <li>Permiso de construcci&oacute;n nueva (C 4,300.00) </li>
                            <li>Permiso de remodelaci&oacute;n (C 2,100.00)</li>
                          </ol>
                        </li>
                        <li>Realizar el pago en l&iacute;nea de la solicitud deseada. 
                          (Puede realizarse mediante el portal)</li>
                        <li>Imprimir la confirmaci&oacute;n del pago.</li>
                        <li>Presentarse el due&ntilde;o de la licencia en las oficinas de la municipalidad:                          
                          <ol type="a">
                            <li>Revisi&oacute;n de planos. </li>
                            <li>Entrega del permiso. </li>
                          </ol>
                        </li>
                      </ol>
                    </div></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
              
            </form>		    <SCRIPT LANGUAGE="JavaScript">
<!--//
qFormAPI.errorColor = "#FFFFCC";
objForm = new qForm("form1");
objForm.cedula.toUpperCase();
objForm.cedula.description="Cédula";
objForm.cedula.required=true;
objForm.required("cedula", true);
objForm.cedula.validate=true;
var strErrorMsg="El valor de la cédula digitada no concuerda con el formato X-XXXX-XXXX";
objForm.cedula.validateFormat(' x-xxxx-xxxx', "numeric"); 
//-->
            </SCRIPT>

</cf_web_portlet>
</cf_templatearea>
</cf_template>



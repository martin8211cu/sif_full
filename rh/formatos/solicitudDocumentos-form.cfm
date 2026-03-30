<cfquery name="rsLista" datasource="#session.dsn#">
	select a.EFid, a.EFcodigo, a.EFdescripcion, a.EFdescalterna 
	from EFormato a
	
	left join DFormato b
	on b.EFid=a.EFid
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and a.EFpautogestion = 1 
	order by a.EFcodigo
</cfquery>

<cfset Session.Params.ModoDespliegue = 0>
<cfinclude template="/rh/expediente/consultas/consultas-frame-header.cfm">
<cfquery name="rsSolicitudes" datasource="#session.dsn#">
	select CSEid, 
		{fn concat(rtrim(EFcodigo),{fn concat(' ',EFdescripcion)})} as doc,
		CSEfrecoge as fec
	From CertificacionesEmpleado a
	inner join EFormato b
		on a.EFid = b.EFid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
	  and a.CSEatendida = 0
	order by fec
</cfquery>
<cfoutput>
<form action="solicitudDocumentos-sql.cfm" method="post" name="form1" style="margin:0">
  <table width="100%" border="0" cellspacing="2" cellpadding="2">
    <tr>
      <td width="1%">&nbsp;</td>
      <td width="48%" valign="top"><fieldset>
        <legend>
          <cf_translate key="LB_DocumentosDisponibles">Documentos Disponibles</cf_translate>
          </legend>
        <table width="95%" align="center" border="0" cellpadding="2" cellspacing="2">
          <tr>
            <td class="fileLabel"><cf_translate key="LB_SeleccioneUnDocumentoDeLaSiguienteLista">Seleccione un documento de la siguiente lista</cf_translate>
              : </td>
          </tr>
          <tr>
            <td><!--- Lista de Documentos que el usuario puede solicitar --->
                <div id="divDocumentos" style="overflow:auto; height: 140; margin:0;">
                  <!--- Variables de Traduccion --->
                  <cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								key="LB_Codigo"
								default="C&oacute;digo"
								xmlfile="/rh/generales.xml"
								returnvariable="LB_Codigo"/>    
                  <cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								key="LB_Descripcion"
								default="Descripci&oacute;n"
								xmlfile="/rh/generales.xml"
								returnvariable="LB_Descripcion"/>    
                  <cfquery name="rsCantidad" datasource="#session.DSN#">
                    select count(1) as total
                    from EFormato
                    where Ecodigo = #Session.Ecodigo# 
                    and EFpautogestion = 1
                    <cfif isdefined("form.filtro_EFcodigo") and len(trim(form.filtro_EFcodigo))>
                      and upper(EFcodigo) like '%#ucase(form.filtro_EFcodigo)#%'
                    </cfif>
                    <cfif isdefined("form.filtro_EFdescripcion") and len(trim(form.filtro_EFdescripcion))>
                      and upper(EFdescripcion) like '%#ucase(form.filtro_EFdescripcion)#%'
                    </cfif>
                  </cfquery>
                  <cfinvoke component="rh.Componentes.pListas" 
								method="pListaRH" 
								returnvariable="Lista"
								columnas="EFid, EFcodigo, substring(EFdescripcion,1,40) as EFdescripcion"
								tabla="EFormato"
								filtro="Ecodigo = #Session.Ecodigo# and EFpautogestion = 1 order by EFcodigo"
								mostrar_filtro="true"
								filtrar_automatico="true"
								desplegar="EFcodigo, EFdescripcion"
								filtrar_por="EFcodigo, EFdescripcion"
								etiquetas="#LB_Codigo#, #LB_Descripcion#"
								formatos="S, S"
								align="leftl, left"
								ira="solicitudDocumentos.cfm"
								showlink="false"
								checkbox_function="setValues(this.value)"
								funcion="setValues"
								fparams="EFid"
								radios="S"
								keys="EFid"
								incluyeform="false"
								formname="form1"  
								/>    
                </div></td>
          </tr>
          <tr>
            <td class="fileLabel"><cf_translate key="LB_SeleccioneLaFechaEnQueSeDeseaRetirarElDocumento">Seleccione la fecha en que desea retirar el documento</cf_translate>
              : </td>
          </tr>
          <tr>
            <td><!--- Fecha en que puede solicitarlo --->
                <cf_sifcalendario name="CSEfrecoge" tabindex="1">
            </td>
          </tr>
        </table>
        <!--- Botón Solicitar --->
        <cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="BTN_Solicitar"
					default="Solicitar"
					returnvariable="BTN_Solicitar"/>  
        <cf_botones values="#BTN_Solicitar#" onBlur="setFecha" tabindex="1">
        <!--- El OnBlur así no sirvió por este motivo se hace con los metódos documentados en la sección de código de javascript --->
        <br />
      </fieldset></td>
      <td width="2%">&nbsp;</td>
      <td width="48%" valign="top"><fieldset class="ayuda">
        <legend>
          <cf_translate key="LB_Resumen">Resumen</cf_translate>
          </legend>
        <table width="95%" align="center" border="0" cellpadding="2" cellspacing="2">
          <tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="fileLabel" colspan="2"><cf_translate key="LB_SeleccioneUnDocumentoDeLaListaDeDocumentosDisponiblesLaCualPuedeEncontrarEnLaSeccionDerechaDeEstaPagina"> Seleccione un documento de la lista de documentos disponibles, 
                    la cual puede encontrar en la sección derecha de esta página. </cf_translate>
                  </td>
                </tr>
                <tr>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                  <td class="fileLabel" colspan="2"><cf_translate key="LB_DocumentoASolicitar">Documento a Solicitar</cf_translate>
                  </td>
                </tr>
                <tr>
                  <td colspan="2"><hr /></td>
                </tr>
                <tr>
                  <td width="30%" class="fileLabel" valign="top"><cf_translate key="LB_Codigo"  XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>
                    :&nbsp;</td>
                  <td width="70%"  valign="top"><input type="text" class="cajasinbordeb" style="background:inherit" name="c" id="c" size="10" />
                  </td>
                </tr>
                <tr>
                  <td width="30%" class="fileLabel" valign="top" nowrap="nowrap"><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>
                    :&nbsp;</td>
                  <td width="70%" valign="top"><textarea class="cajasinbordeb"  style="background:inherit" name="d" id="d" cols="40" rows="5"></textarea>
                  </td>
                </tr>
                <tr>
                  <td width="30%" class="fileLabel" valign="top" ><cf_translate key="LB_Texto" XmlFile="/rh/generales.xml">Texto</cf_translate>
                    :&nbsp;</td>
                </tr>
                <tr>
                  <td valign="top" colspan="2"><div style="width:100%; height:150; overflow:auto; border:solid 1px gray;" id="observaciones"> </div></td>
                </tr>
                <tr>
                  <td width="30%" class="fileLabel" valign="top"><cf_translate key="LB_Fecha">Fecha</cf_translate>
                    :&nbsp;</td>
                  <td width="70%" valign="top"><input type="text" class="cajasinbordeb" style="background:inherit" name="f" id="f" size="20" />
                  </td>
                </tr>
                <tr>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                  <td class="fileLabel" colspan="2"><cf_translate key="LB_DocumentosSolicitadosAnteriormente">Documentos Solicitados Anteriormente</cf_translate>
                  </td>
                </tr>
                <tr>
                  <td colspan="2"><hr /></td>
                </tr>
                <tr>
                  <td colspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr class="tituloListas">
                        <td><cf_translate key="Documento">Documento</cf_translate></td>
                        <td><cf_translate key="LB_FechaParaLaQueSeSolicito">Fecha para la que se solicitó</cf_translate></td>
                        <td>&nbsp;</td>
                      </tr>
                      <cfloop	query="rsSolicitudes">
                        <tr>
                          <td nowrap="nowrap">#doc#&nbsp;</td>
                          <td>#LSDateFormat(fec,"dd/mm/yyyy")#</td>
                          <td><a href="##" onclick="deleteByCSEid(#CSEid#)" style="border:0;"><img src="/cfmx/rh/imagenes/w-recycle_black.gif" border="0" /></a></td>
                        </tr>
                      </cfloop>
                  </table></td>
                </tr>
                <tr>
                  <td colspan="2" align="center"><cfif rsSolicitudes.recordcount>
                    ---
                    <cf_translate key="LB_FinDelosDocumentosSinAtender">Fin de los documentos sin atender</cf_translate>
                    ---
                    <cfelse>
                    ---
                    <cf_translate key="LB_NaHaySolicitudesRegistradasSinAtender">No hay solicitudes registradas sin atender</cf_translate>
                    ---
                  </cfif>
                  </td>
                </tr>
            </table></td>
          </tr>
        </table>
        <br />
      </fieldset></td>
      <td width="1%">&nbsp;</td>
    </tr>
  </table>
</form>
<!--- Variables de Traduccion --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DocumentoASolicitar"
	Default="Documento a Solicitar"
	returnvariable="MSG_DocumentoASolicitar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechaEnQueDeseaRetirarElDocumento"
	Default="Fecha en que desea retirar el Documento"
	returnvariable="MSG_FechaEnQueDeseaRetirarElDocumento"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ConfirmaBorrarElElemento"
	Default="Confirma Borrar el Elemento"
	returnvariable="MSG_ConfirmaBorrarElElemento"/>


<cf_qforms>
<script language="javascript">
	//Descripciones de los objetos requeridos
	objForm.chk.description = "<cfoutput>#MSG_DocumentoASolicitar#</cfoutput>";
	objForm.CSEfrecoge.description = "<cfoutput>#MSG_FechaEnQueDeseaRetirarElDocumento#</cfoutput>";
	//Definición de objetos requeridos
	objForm.chk.required = true;
	objForm.CSEfrecoge.required = true;
	//Función para definir el documento en el cuadro de resumen
	function setValues(v){
		objForm.c.obj.value="";
		objForm.d.obj.value="";
		document.getElementById("observaciones").innerHTML = ''

		<cfloop query="rsLista">
			if (#rsLista.EFid#==v){
				objForm.c.obj.value="#rsLista.EFcodigo#";
				objForm.d.obj.value="#rsLista.EFdescripcion#";
				document.getElementById("observaciones").innerHTML = '#JSStringFormat(rsLista.EFdescalterna)#'
				<cfif rsCantidad.total gt 1 >
					document.form1.chk[#rsLista.CurrentRow-1#].checked = true;
				<cfelseif rsCantidad.total eq 1>
					document.form1.chk.checked = true;
				</cfif>

			} else {
				<cfif rsCantidad.total gt 1 >
					document.form1.chk[#rsLista.CurrentRow-1#].checked = false;
				<cfelseif rsCantidad.total eq 1>
					document.form1.chk.checked = false;
				</cfif>
			}
		</cfloop>
		setFecha();
	}

	function desHabilitarValidacion(){
		objForm.chk.required = false;
		objForm.CSEfrecoge.required = false;
	}

	//Función llamada desde el Tag de Fechas en el click del conlis
	function funcFecha(){
		setFecha();
	}
	
	
	//Función para definir la fecha en el cuadro de resumen
	function setFecha(){
		v = objForm.CSEfrecoge.getValue();
		if (v.length>0){
			objForm.f.obj.value=v;
		}
	}



	function deleteByCSEid(CSEid){
		if (CSEid>0&&confirm("<cfoutput>#MSG_ConfirmaBorrarElElemento#</cfoutput>?"))
			window.location.href="solicitudDocumentos-sql.cfm?Baja=1&CSEid="+CSEid;
		else
			return false;
	}
	//Asigna al evento onblur de la Fecha la función setFecha
	objForm.CSEfrecoge.addEvent('onBlur', 'setFecha();', true);
</script>
</cfoutput>
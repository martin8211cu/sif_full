<!--- 
	Modificado por: Ana Villavicencio
		Fecha: 22 de setiembre del 2005
		Motivo: Eliminar del filtro la fecha inicial  y la final, cambiar la etiqueta de Asiento por Póliza, 
			corregir error del tipo de archivo excel, estaban poniendo como formato xls.
			Agregar funciones de javascript para la llamada del un pop up q pide el nombre de la persona autorizada para firmar 
			el reporte, esto para el reporte con corte de pagina por documento. 
			Se modifica le boton btnGenerar de submit a button, esto para llamar el pop up, y el submit se hace en el pop up.
			
	Modificado por: Ana Villavicencio
		Fecha: 29 de setiembre del 2005
		Motivo: Eliminar el pop up q toma el dato de la persona autorizada a firmar el documento.
			Se cambia la forma de tomar ese dato,  se agrega un input en la forma 
			y se indica si se quiere modificar el parametro, esto por medio de un checkbox.
			Cuando se indica si se quiere modificar se modifica el parámetro 752
			
	Modificado por: Rodolfo Jimenez Jara, ROJIJA
		Fecha: 30 de ENERO del 2006
		Motivo: Se hace mas grande el tamaño del número del asiento

	Modificado por Gustavo Fonseca H.
		Fecha: 3-3-2006.
		Motivo: Se utiliza la tabla CGPeriodosProcesados para sacar el combo de los periodos y así mejorar el 
			rendimiento de la pantalla.
			
	Modificado por: Steve Vado Rodríguez
		Fecha: 3 de mayo del 2006
		Motivo: Se cambió el formulario de post a get ya que el reporte da problemas cuando se pinta en
			internet explorer.
 --->
 <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="Consulta  de Documentos Contables Aplicados" 
returnvariable="LB_Titulo" xmlfile = "DocumentosProcesados.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Limpiar" Default="Limpiar" 
returnvariable="BTN_Limpiar" xmlfile = "/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Generar" Default="Generar" 
returnvariable="BTN_Generar" xmlfile = "/sif/generales.xml"/>
 
<cf_templateheader title="#LB_Titulo#">
<cfinclude template="Funciones.cfm">
<cfset periodo="#get_val(30).Pvalor#">
<cfset mes="#get_val(40).Pvalor#">

<!---
	FILTRO DE DOCUMENTOS CONTABLES
--->
	<cfquery name="rsLotes" datasource="#Session.DSN#">
		select  a.Cconcepto, Cdescripcion as Cdescripcion
		from ConceptoContableE a
		where a.Ecodigo =  #Session.Ecodigo# 
			and (select count(1)
					from UsuarioConceptoContableE b 
					where a.Ecodigo =  #Session.Ecodigo# 
					and a.Cconcepto = b.Cconcepto
					and a.Ecodigo = b.Ecodigo )  <= 0
		UNION
		select a.Cconcepto, Cdescripcion as Cdescripcion
		from ConceptoContableE a
			inner join UsuarioConceptoContableE b
				on a.Cconcepto = b.Cconcepto
			   and a.Ecodigo   = b.Ecodigo
		where a.Ecodigo =  #Session.Ecodigo# 
			and b.Usucodigo  =  #Session.Usucodigo# 
		order by 1
	</cfquery>

	<cfquery name="rsPer" datasource="#Session.DSN#">
		select distinct Speriodo as Eperiodo
		  from CGPeriodosProcesados
		where Ecodigo =  #Session.Ecodigo# 
		order by Speriodo desc
	</cfquery>
	<cfquery name="rsMeses" datasource="sifControl">
		select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
		from Idiomas a
			inner join VSidioma b 
				on a.Iid = b.Iid
		where a.Icodigo = '#Session.Idioma#'
			and b.VSgrupo = 1
		order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
	</cfquery>
	   
	<!--- OJO. Esto no se vale consultar. Puede tener miles de registros --->
	<cfquery name="rsUsuarios" datasource="#Session.DSN#">
		select  '<cf_translate key = LB_Todos>Todos</cf_translate>' as ECusuario, '<cf_translate key = LB_Todos>Todos</cf_translate>' as ECusuarioDESC , 0 as orden from dual
		union 
		select distinct ECusuario, ECusuario as ECusuarioDESC, 1 as orden
		  from HEContables
		  where Ecodigo =  #Session.Ecodigo# 
         	<cfif isdefined("form.EPeriodo") and isdefined("form.EMes") and form.Eperiodo GT 0 and form.Emes GT 0>
               and Eperiodo = #form.EPeriodo#
               and Emes = #form.Emes#
            <cfelse>
               and Eperiodo = #Periodo#
               and Emes = #Mes#
            </cfif>
	</cfquery>

	<cfif isdefined("url.txtref") and not isdefined("form.txtref")>
        <cfset form.txtref = url.txtref>
    </cfif>
    
    <cfif isdefined("url.txtdoc") and not isdefined("form.txtdoc")>
        <cfset form.txtdoc = url.txtdoc>
    </cfif>
    
	<cfif not isdefined("form.Usucodigo")>
		<cfset form.Usucodigo = "">
	</cfif>
	<cfif isdefined("url.ver") and not isdefined("form.ver")>
		<cfset form.ver = url.ver>
	</cfif>
	<cfif isdefined("url.origen") and not isdefined("form.origen")>
		<cfset form.origen = url.origen>
	</cfif>
	<cfif not isdefined("form.ver")>
		<cfset form.ver = 15>
	</cfif>
	<cfset firmaAutoPoliza = ''>
	<cfquery name="rsAutoP" datasource="#session.DSN#">
		select Pvalor
		from Parametros 
		where Ecodigo =  #Session.Ecodigo# 
		  and Pcodigo = 752
	</cfquery>
	
	<cfset hayAutoP = 0 >
	<cfif rsAutoP.RecordCount GT 0 >
		<cfset hayAutoP = 1 >
		<cfset firmaAutoPoliza = rsAutoP.Pvalor>
	</cfif>
		<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		
		
		<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
		<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
		<cfset PolizaNum = t.Translate('PolizaNum','La p&oacute;liza debe ser num&eacute;rica.')>
		
		
		<cf_web_portlet_start  border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
						
			<form action="DocumentosProcesados-SQL.cfm" method="url" name="formfiltro" style="margin:0;" onsubmit="return bloqueo()">
			<cfoutput>
				<table width="100%"  border="0" cellspacing="1" cellpadding="1" class="AreaFiltro" style="margin:0;">
					<tr>
						<td width="23%"><b><cf_translate key=LB_ConceptoIni>Concepto Inicial</cf_translate> </b></td>
						<td width="18%"><b><cf_translate Key=LB_AsientoIni>Asiento Inicial </cf_translate> </b></td>
						<td width="16%"><b><cf_translate key=LB_PeriodoIni>Período Inicial </cf_translate> </b></td>
						<td width="13%"><b><cf_translate key=LB_MesIni>Mes Inicial   </cf_translate>   </b></td>
						<td width="16%"><b><cf_translate key=LB_FechaIni>Fecha Inicial </cf_translate>   </b></td>
					</tr>
					<tr> 
						<td> 
							<select name="loteini">
								<option value=""><cf_translate key = LB_Todos>Todos</cf_translate></option>
								<cfloop query="rsLotes"> 
									<option value="#Cconcepto#"<cfif isdefined("form.loteini") and form.loteini eq Cconcepto>selected</cfif>>#Cdescripcion#</option>
								</cfloop> 
							</select>
						</td> 
						<td>
							<input tabindex="1" type="text" name="EdocumentoI" value=""  size="10" maxlength="10" style="text-align: right;" onblur="javascript:fm(this);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event)){ if(Key(event)=='13') {this.blur();}}" >
						</td>
						<td>
                          <select name="periodoini">
                            <cfloop query="rsPer">
                              <option value="#Eperiodo#" <cfif isdefined("periodo") and periodo eq Eperiodo>selected</cfif>>#Eperiodo#</option>
                            </cfloop>
                          </select>
                        </td>
						<td>
                          <select name="mesini">
                           <cfloop query="rsMeses">
                              <option value="#VSvalor#"<cfif  isdefined("mes") and  mes eq VSvalor>selected</cfif>>#VSdesc#</option>
                            </cfloop>
                          </select>
                        </td>
						<td>
                          <cfif isdefined("form.fechaIni")>
                            <cf_sifcalendario name="fechaIni" value="#LSDateFormat(form.fechaIni,'dd/mm/yyyy')#" form="formfiltro">
                          <cfelse>
                            <cf_sifcalendario name="fechaIni" value="" form="formfiltro">
                          </cfif>
                        </td>
					  <td width="14%"><input type="reset" name="bLimpiar" value="#BTN_Limpiar#"></td>
					</tr>
					<tr>
					  	<td><b><cf_translate key = LB_ConceptoFin>Concepto Final</cf_translate> </b></td>
						<td><b><cf_translate key = LB_AsientoFin>Asiento Final</cf_translate></b></td>
						<td><b><cf_translate key = LB_PeriodoFin>Período Final</cf_translate> </b></td>
					  	<td><b><cf_translate key = LB_MesFin>Mes Final</cf_translate> </b></td>
						<td><b>Fecha Final</b></td>
					  	<td><input type="submit" name="bGenerar" value="#BTN_Generar#" ></td>
				  	</tr>
					<tr>
					  	<td>
                        	<select name="lotefin"  >
                          	<option value=""><cf_translate key=LB_Todos>Todos</cf_translate></option>
                          	<cfloop query="rsLotes">
                            	<option value="#Cconcepto#"<cfif isdefined("form.lotefin") and  form.lotefin eq Cconcepto>selected</cfif>>#Cdescripcion#</option>
                          	</cfloop>
                        	</select>
                      	</td>
						<td>
							<input tabindex="1" type="text" name="EdocumentoF" value=""  size="10" maxlength="10" style="text-align: right;" onblur="javascript:fm(this);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event)){ if(Key(event)=='13') {this.blur();}}" >
						</td>
						<td>
                        	<select name="periodofin">
                          		<cfloop query="rsPer">
                           	 		<option value="#Eperiodo#" <cfif isdefined("periodo") and  periodo eq Eperiodo>selected</cfif>>#Eperiodo#</option>
                          		</cfloop>
                        	</select>
                      	</td>
					  <td>
                        <select name="mesfin">
                          <cfloop query="rsMeses">
                            <option value="#VSvalor#"<cfif isdefined("mes") and  mes  eq VSvalor>selected</cfif>>#VSdesc#</option>
                          </cfloop>
                        </select>
                      </td>
					   <td>
                        <cfif isdefined("form.fechaFin")>
                          <cf_sifcalendario name="fechaFin" value="#LSDateFormat(form.fechaFin,'dd/mm/yyyy')#" form="formfiltro">
                        <cfelse>
                          <cf_sifcalendario name="fechaFin" value="" form="formfiltro">
                        </cfif>
                      </td>
					
				  </tr>
				  <tr>
					  <td nowrap><strong><cf_translate key=LB_Formato>Formato</cf_translate></strong></td>
					  <td nowrap><b><cf_translate key = LB_Usuario>Usuario que Gener&oacute; </cf_translate></b></td>
			  	 </tr>
				 <tr>
					  <td nowrap>
					    <select name="formato">
						  <option value="HTML">HTML</option>
                          <option value="FlashPaper">FlashPaper</option>
                          <option value="pdf">Adobe PDF</option>
						  <option value="tab">Excel tabular</option>                          
                        </select>
					  </td>
					  <td>
 						 <select name="Usuario">
							<cfloop query="rsUsuarios">
								<option value="#rsUsuarios.ECusuario#" >#rsUsuarios.ECusuarioDESC#</option>
							</cfloop>
						 </select>
                      </td>
 					  <td nowrap colspan="4">
					  	<input type="checkbox" name="chkCorteDocumento" id="chkCorteDocumento" style="background:background-color">
						<label for="chkCorteDocumento"><strong><cf_translate key=LB_CortePagina>Con Corte de P&aacute;gina por Documento</cf_translate></strong></label>
					  </td>
				  </tr>  
				  <tr>
						<td nowrap><strong><cf_translate key = LB_Persona>Persona Autorizada para Firmar</cf_translate></strong></td>
						<td><b><cf_translate key=LB_Orden>Orden</cf_translate>:</b></td>
				  </tr>
				  <tr>
						<td><input name="firmaAutorizada" type="text" value="#firmaAutoPoliza#" size="20"></td> 
						<td>
							<select name="ordenamiento">
								<option value="0" selected><cf_translate key=LB_Linea>Linea</cf_translate></option>
								<option value="1"><cf_translate key = LB_Documento>Documento</cf_translate></option>
							</select>
						</td>
						<td colspan="4">
							<input name="actulizarp" type="checkbox" style="background:background-color " id="actulizarp">
							<label for="actulizarp"><strong><cf_translate key=LB_ActualizaParametro>Actualizar par&aacute;metro</cf_translate></strong></label>
						</td> 
					</tr>
                    <tr>
                        <td><b><cf_translate key=LB_Referencia>Referencia</cf_translate>:</b></td>
                        <td><b><cf_translate key=LB_Documento>Documento</cf_translate>:</b></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                     <tr>
                        <td><input type="text" name="txtref" id="txtref" value="<cfif isdefined("Form.txtref")><cfoutput>#Form.txtref#</cfoutput></cfif>"/></td>
                        <td><input type="text" name="txtdoc" id="txtdoc" value="<cfif isdefined("Form.txtdoc")><cfoutput>#Form.txtdoc#</cfoutput></cfif>"/></td>
                        <td valign="middle"> 
                            <input name="intercompany" type="checkbox" value="1" <cfif isdefined("Form.intercompany")><cfoutput>checked</cfoutput></cfif> id="intercompany">
                            <label for="intercompany"><strong><cf_translate key=LB_Intercompania>Intercompa&ntilde;&iacute;a</cf_translate></strong></label>
                        </td>
                        <td valign="middle" colspan="2" > 
                            <input name="excluirAnulados" type="checkbox" value="1" <cfif isdefined("Form.excluirAnulados")><cfoutput>checked</cfoutput></cfif> id="excluirAnulados">
                            <label for="excluirAnulados"><strong><cf_translate key=LB_AsientosAnulados>Quitar Asientos Anulados</cf_translate></strong></label>
                        </td>
                    </tr>
					<tr><td>&nbsp;<input name="hayAutoP" type="hidden" value="#hayAutoP#"></td></tr>
			</table>
			</cfoutput>
				<script language="JavaScript"> 
				 function bloqueo(){
				 	if(document.formfiltro.formato.value == 'tab'){
					 return true;
					}
					else{
					 sinbotones();
					}
				 }
				 
				 function RangoFechas(){
				 
				 	var mesinicial = document.formfiltro.mesini.value;
					var mesfinal = document.formfiltro.mesfin.value;
									 
				 	var fecha_ini = new Date(parseInt(document.formfiltro.periodoini.value, 10) , parseInt(mesinicial, 10)-1 , parseInt(01, 10));
					var periodo = 0;
					
					var  mes = (parseInt(mesfinal, 10) + 1) % 12;
					if (mes == 1)
					   { periodo = document.formfiltro.periodofin.value + 1;
					} else {
						periodo = document.formfiltro.periodofin.value ;
					}

					fechatemp =  new Date(parseInt(periodo,10), parseInt(mes,10)-1, parseInt(1,10));
					var fecha_fin = new Date(fechatemp.getTime() - 86400000.0);
					
					
					var a = document.formfiltro.fechaIni.value.split("/");
					var ini = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
					var b = document.formfiltro.fechaFin.value.split("/");
					var fin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
					
					if (ini < fecha_ini ){
						alert("La fecha inicial no debe ser menor al periodo y mes inicial solicitados.");
						return false;						
					}
	
					if (fin < fecha_ini ){
						alert("La fecha final  no debe ser menor al periodo y mes inicial solicitados.");
						return false;						
					}
				
					if (ini > fecha_fin ){
						alert("La fecha inicial no debe ser mayor al periodo y mes final solicitados.");
						return false;						
					}
					
					if (fin > fecha_fin ){
						alert("La fecha final no debe ser mayor al periodo y mes final solicitados.");
						return false;						
					}
				}
				 
				function cambioIni(cb){
					var _divAsiento = document.getElementById("idAsiento");
			
					if(cb.value == '' && document.formfiltro.lotefin.value == '')
						_divAsiento.style.display = '';
					else
						_divAsiento.style.display = 'none';
				}

				function cambioFin(cb){
					var _divAsiento = document.getElementById("idAsiento");
			
					if(cb.value == '' && document.formfiltro.loteini.value == '')
						_divAsiento.style.display = '';
					else
						_divAsiento.style.display = 'none';
				}				 
				 
				 var popUpWin = 0;
				function popUpWindow(URLStr, left, top, width, height){
					if(popUpWin){
						if(!popUpWin.closed) popUpWin.close();
					}
					popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
			
				function confirmacion(){
					if (document.formfiltro.chkCorteDocumento.checked){
					popUpWindow("/cfmx/sif/cg/consultas/datosReporte.cfm",300,200,400,150);
					}else{
						document.formfiltro.submit();
					}
				}
			</script> 
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>
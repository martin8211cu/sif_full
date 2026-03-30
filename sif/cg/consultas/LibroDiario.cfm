<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_TituloRLG" 	default="Libro Diario General" 
returnvariable="LB_TituloRLG" xmlfile="LibroDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_ConceptoInicial" default="Concepto Inicial" 
returnvariable="LB_ConceptoInicial" xmlfile="LibroDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_ConceptoFinal" default="Concepto Final" 
returnvariable="LB_ConceptoFinal" xmlfile="LibroDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Formato" default="Formato" returnvariable="LB_Formato" xmlfile="LibroDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Todos" default="Todos" returnvariable="LB_Todos" xmlfile="LibroDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_PolizaInicial" default="P&oacute;liza Inicial" 
returnvariable="LB_PolizaInicial" xmlfile="LibroDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_PolizaFinal" default="P&oacute;liza Final" 
returnvariable="LB_PolizaFinal" xmlfile="LibroDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_FirmaAutorizada" default="Persona Autorizada para Firmar" 
returnvariable="LB_FirmaAutorizada" xmlfile="LibroDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Usuario" default="Usuario que Gener&oacute;" returnvariable="LB_Usuario" xmlfile="LibroDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Orden" default="Orden"  returnvariable="LB_Orden" xmlfile="LibroDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_PeriodoInicial" default="Per&iacute;odo Inicial" 
returnvariable="LB_PeriodoInicial" xmlfile="LibroDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_PeriodoFinal" default="Per&iacute;odo Final" 
returnvariable="LB_PeriodoFinal" xmlfile="LibroDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_MesInicial" default="Mes Inicial" 
returnvariable="LB_MesInicial" xmlfile="LibroDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_MesFinal" default="Mes Final" 
returnvariable="LB_MesFinal" xmlfile="LibroDiario.xml" />
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="CHK_ActParam" default="Actualizar Par&aacute;metro" 
returnvariable="CHK_ActParam" xmlfile="LibroDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="BTN_Limpiar" default="Limpiar" 
returnvariable="BTN_Limpiar" xmlfile="LibroDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="BTN_Generar" default="Generar" 
returnvariable="BTN_Generar" xmlfile="LibroDiario.xml"/>
<cf_templateheader title="#LB_TituloRLG#">
	<!--- FILTRO DE DOCUMENTOS CONTABLES --->
	<cfquery name="rsLotes" datasource="#Session.DSN#">
		select  a.Cconcepto, Cdescripcion as Cdescripcion
		from ConceptoContableE a
		where a.Ecodigo = #Session.Ecodigo#
			and not exists ( 	select 1 
							 	from UsuarioConceptoContableE b 
								where a.Ecodigo = #Session.Ecodigo#
									and a.Cconcepto = b.Cconcepto
									and a.Ecodigo = b.Ecodigo )  
		UNION
		select a.Cconcepto, Cdescripcion as Cdescripcion
		from ConceptoContableE a,UsuarioConceptoContableE b
		where a.Ecodigo = #Session.Ecodigo#
			and a.Cconcepto = b.Cconcepto
			and a.Ecodigo = b.Ecodigo
			and b.Usucodigo  = #Session.Usucodigo#
		
		order by 1
	</cfquery>


	<cfquery name="rsPer" datasource="#Session.DSN#">
		select distinct Speriodo as Eperiodo
		from CGPeriodosProcesados
		where Ecodigo = #session.Ecodigo#
		order by Speriodo desc
	</cfquery>
	<cfquery name="rsMeses" datasource="sifControl">
		select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
		from Idiomas a, VSidioma b 
		where a.Icodigo = '#Session.Idioma#'
			and a.Iid = b.Iid
			and b.VSgrupo = 1
		order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
	</cfquery>
	   
	<!--- OJO. Esto no se vale consultar. Puede tener miles de registros --->
	<cfquery name="rsUsuarios" datasource="#Session.DSN#">
		select distinct ECusuario as ECusuario, ECusuario as ECusuarioDESC, 1 as orden
		  from HEContables
		  where Ecodigo = #Session.Ecodigo#
	</cfquery>

	<!--- OJO. Esto no se vale consultar. Puede tener miles de registros --->
	<cfquery name="rsOrigen" datasource="#Session.DSN#">
        select distinct Oorigen, Oorigen as OorigenDESC, 1 as orden
        from HEContables
        where Ecodigo = #Session.Ecodigo#
	</cfquery>
	
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
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = 752
	</cfquery>
	
	<cfset hayAutoP = 0 >
	<cfif rsAutoP.RecordCount GT 0 >
		<cfset hayAutoP = 1 >
		<cfset firmaAutoPoliza = rsAutoP.Pvalor>
	</cfif>
		<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		<cfinclude template="Funciones.cfm">
		
		
		<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
		<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
		<cfset PolizaNum = t.Translate('PolizaNum','La p&oacute;liza debe ser num&eacute;rica.')>
		<cfset periodo="#get_val(30).Pvalor#">
	   	<cfset mes="#get_val(40).Pvalor#">
		
		<cf_web_portlet_start  border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_TituloRLG#'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
						
			<form action="LibroDiario_SQL.cfm" method="get" name="formfiltro" style="margin:0;" onsubmit="return bloqueo()">
			<cfoutput>
				<table width="100%"  border="0" cellspacing="1" cellpadding="1" class="AreaFiltro" style="margin:0;">
					<tr>
						<td>&nbsp;</td> 
						<td><b>#LB_ConceptoInicial#</b></td>
						<td nowrap><strong>#LB_PolizaInicial#</strong></td>
						<td><b>#LB_PeriodoInicial#</b></td>
						<td><b>#LB_MesInicial#</b></td>
						<td>&nbsp;</td>
						<td><b>&nbsp;</b></td>
					</tr>
					<tr> 
						<td>&nbsp;</td>
						<td> 
							<select name="loteini">
								<option value="">#LB_Todos#</option>
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
						<td><input type="reset" name="bLimpiar" value="#BTN_Limpiar#"></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					  	<td><b>#LB_ConceptoFinal#</b></td>
						<td nowrap><strong>#LB_PolizaFinal#</strong></td>
						<td><b>#LB_PeriodoFinal#</b></td>
					  	<td><b>#LB_MesFinal#</b></td>
					  	<td><input type="submit" name="bGenerar" value="#BTN_Generar#" ></td>
					  	<td>&nbsp;</td>
				  	</tr>
					<tr>
						<td>&nbsp;</td>
					  	<td>
                        	<select name="lotefin"  >
                          	<option value="">#LB_Todos#</option>
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

					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
				  </tr>
					<tr>
					  <td>&nbsp;</td>
					  <td nowrap><strong>#LB_Formato#</strong></td>
					  <td nowrap><b>#LB_Usuario#</b></td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
			  		</tr>
					<tr>
						<td>&nbsp;</td>
					  <td nowrap><select name="formato">
                         <option value="FlashPaper">FlashPaper</option>
                          <option value="pdf">Adobe PDF</option>
						  <option value="tab">Excel tabular</option>
                      </select></td>
					  <td colspan="5">
 							<select name="Usuario">
								<option value="Todos" >#LB_Todos#</option>
								<cfloop query="rsUsuarios">
									<option value="#rsUsuarios.ECusuario#" >#rsUsuarios.ECusuarioDESC#</option>
								</cfloop>
							</select>
                      </td>
				    </tr>  
					<tr>
						<td>&nbsp;</td>
						<td nowrap><strong>#LB_FirmaAutorizada#</strong></td>
						<td><b>#LB_Orden#:</b></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td><input name="firmaAutorizada" type="text" value="#firmaAutoPoliza#" size="40"></td> 
						
						<td>
							<select name="ordenamiento">
								<option value="0" selected>Linea</option>
								<option value="1">Documento</option>
							</select>
						</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							<input name="actulizarp" type="checkbox" style="background:background-color " id="actulizarp">
							<label for="actulizarp"><strong>#CHK_ActParam#</strong></label>
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
			</script> 
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>
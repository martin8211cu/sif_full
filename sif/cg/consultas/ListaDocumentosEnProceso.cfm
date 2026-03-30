<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
		<cfset Titulo = t.Translate('LB_Titulo','P&oacute;lizas No Aplicadas')>
		<cfset ConceptoIni = t.Translate('LB_ConceptoIni','Concepto Inicial')>
        <cfset ConceptoFin = t.Translate('LB_ConceptoFin','Concepto Final')>
        <cfset FechaIni = t.Translate('LB_FechaIni','Fecha Inicial')>
        <cfset FechaFin = t.Translate('LB_FechaFin','Fecha Final')>
        <cfset Formato = t.Translate('LB_Formato','Formato')>
        <cfset Referencia = t.Translate('LB_Referencia','Referencia')>
        <cfset AsientoIni = t.Translate('LB_AsientoIni','Asiento Inicial')>
        <cfset AsientoFin = t.Translate('LB_AsientoFin','Asiento Final')>
        <cfset Documento = t.Translate('LB_Documento','Documento')>
        <cfset Usuario = t.Translate('LB_Usuario','Usuario que Gener&oacute;')>
        <cfset Orden = t.Translate('LB_Orden','Orden')>
        <cfset PeriodoIni = t.Translate('LB_PeriodoIni','Per&iacute;odo Inicial')>
        <cfset PeriodoFin = t.Translate('LB_PeriodoFin','Per&iacute;odo Final')>
        <cfset MesIni = t.Translate('LB_MesIni','Mes Inicial')>
        <cfset MesFin = t.Translate('LB_MesFin','Mes Final')>
        <cfset Todos = t.Translate('LB_Todos','Todos')>
        <cfset OrigenAsiento = t.Translate('LB_OrigenAsiento','Origen Asiento')>
        <cfset Linea = t.Translate('LB_Linea','Linea')>
        <cfset Generar = t.Translate('BTN_Generar','Generar')>
        <cfset Limpiar = t.Translate('BTN_Limpiar','Limpiar')>

<cf_templateheader title="#Titulo#"> 
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
		select distinct Eperiodo
		from EContables
		where Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfquery name="rsMeses" datasource="sifControl">
		select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
		from Idiomas a, VSidioma b 
		where a.Icodigo = '#Session.Idioma#'
			and a.Iid = b.Iid
			and b.VSgrupo = 1
		order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
	</cfquery>
	
	<cfquery name="rsUsuarios" datasource="#Session.DSN#">
		select  '#Todos#' as ECusuario, '#Todos#' as ECusuarioDESC , 0 as orden from dual
		union 
		select distinct ECusuario, ECusuario as ECusuarioDESC, 1 as orden
		  from EContables
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
    
	<cfif isdefined("url.txtref") and not isdefined("form.txtref")>
        <cfset form.txtref = url.txtref>
    </cfif>
    
    <cfif isdefined("url.txtdoc") and not isdefined("form.txtdoc")>
        <cfset form.txtdoc = url.txtdoc>
    </cfif>

		<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		<cfinclude template="Funciones.cfm">
		
		<cfset periodo="#get_val(30).Pvalor#">
	   	<cfset mes="#get_val(40).Pvalor#">
		
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#Titulo#'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfform action="DocumentosNoAplicados.cfm" method="get" name="formfiltro" style="margin:0;" onsubmit="return sinbotones()">
			<cfoutput>
				<table width="100%"  border="0" cellspacing="1" cellpadding="1" class="AreaFiltro" style="margin:0;">
					<tr> 
						<td width="22%"><b>#ConceptoIni#</b></td>
						<td width="18%" rowspan="4" valign="top">
							<div id="idAsiento">
								<table width="45%"  border="0" cellspacing="0" cellpadding="0">
								  <tr>
									<td nowrap><strong>#AsientoIni#</strong></td>
								  </tr>
								  <tr>
									<td>
										 <input tabindex="1" type="text" name="EdocumentoI" value=""  size="9" maxlength="10" style="text-align: right;" onblur="javascript:fm(this);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event)){ if(Key(event)=='13') {this.blur();}}" > 
									</td>
								  </tr>
								  <tr>
								  	<td>&nbsp;
									</td>
								  </tr>
								  <tr>
									<td nowrap><strong>#AsientoFin#</strong></td>
								  </tr>
								  <tr>
									<td>
										<input tabindex="1" type="text" name="EdocumentoF" value=""  size="9" maxlength="10" style="text-align: right;" onblur="javascript:fm(this);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event)){ if(Key(event)=='13') {this.blur();}}" >
									</td>
								  </tr>
								</table>
							</div>
						</td>
						<td width="11%"><b>#PeriodoIni# </b></td>
						<td width="16%"><b>#MesIni#</b></td>
						<td width="19%" nowrap><b>#FechaIni#</b></td>
						<td width="9%">&nbsp;</td>
						<td width="5%"><b>&nbsp;</b></td>
					</tr>
					
					<tr> 
						<td> <!---onChange="javascript: cambioIni(this);"--->
							<select name="loteini">
								<option value="">#Todos#</option>
								<cfloop query="rsLotes"> 
									<option value="#Cconcepto#"<cfif isdefined("form.loteini") and form.loteini eq Cconcepto>selected</cfif>>#Cdescripcion#</option>
								</cfloop> 
							</select>
						</td>
						<td><!---  <option value="-1">Todos</option> --->
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
                            <cf_sifcalendario name="fechaIni" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" form="formfiltro">
                          </cfif>
                        </td>
						<td><input type="reset" name="bLimpiar" value="#Limpiar#"></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
					  <td><b>#ConceptoFin# </b></td>
					  <td><b>#PeriodoFin# </b></td>
					  <td><b>#MesFin# </b></td>
					  <td nowrap><b>#FechaFin#</b></td>
					  <td><input type="submit" name="bGenerar" value="#Generar#" onclick="return RangoFechas();"></td>
					  <td>&nbsp;</td>
				  </tr>
					<tr>
					  <td><!---onChange="javascript: cambioFin(this);"--->
                        <select name="lotefin">
                          <option value="">#Todos#</option>
                          <cfloop query="rsLotes">
                            <option value="#Cconcepto#"<cfif isdefined("form.lotefin") and  form.lotefin eq Cconcepto>selected</cfif>>#Cdescripcion#</option>
                          </cfloop>
                        </select>
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
                            <option value="#VSvalor#"<cfif isdefined("mes") and  mes eq VSvalor>selected</cfif>>#VSdesc#</option>
                          </cfloop>
                        </select>
                      </td>
					  <td>
                        <cfif isdefined("form.fechaFin")>
                          <cf_sifcalendario name="fechaFin" value="#LSDateFormat(form.fechaFin,'dd/mm/yyyy')#" form="formfiltro">
                        <cfelse>
                          <cf_sifcalendario name="fechaFin" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" form="formfiltro">
                        </cfif>
                      </td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
				  </tr>
					<tr>
					  <td nowrap><strong>#Formato#:</strong></td>
					  <td nowrap>&nbsp;</td>
					  <td ><b>#Usuario#</b></td>
					  <td><b>#Orden#:</b></td>
					  <td><b>#OrigenAsiento#</b></td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
			  		</tr>
					<tr>
					  <td nowrap><select name="formato">
                          <option value="FlashPaper">FlashPaper</option>
                          <option value="pdf">Adobe PDF</option>
                          <option value="excel">Microsoft Excel</option>
                      </select></td>

					  <td>
                          <!--- <cf_sifusuarioE form="formfiltro" idusuario="#form.Usucodigo#" size="40"  frame="frame1"> --->
                      </td>
					  <td ><select name="Usuario">
                        <cfloop query="rsUsuarios">
                          <option value="#rsUsuarios.ECusuario#" >#rsUsuarios.ECusuarioDESC#</option>
                        </cfloop>
                      </select></td>
					  <td>
					  	<select name="ordenamiento">
							<option value="0" selected>#Linea#</option>
                             <option value="1">#Documento#</option>
                        </select>
						</td>
					  <td><input name="origen" type="text" size="9" maxlength="9" value="<cfif isdefined("form.origen")>#form.origen#</cfif>"></td>
					   <td>&nbsp;</td>
					  <td>&nbsp;</td>
				    </tr>  
                    
                    <tr>
                        <td><b>#Referencia#:</b></td>
                        <td><b>#Documento#:</b></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                     <tr>
                        <td><input type="text" name="txtref" id="txtref" value="<cfif isdefined("Form.txtref")><cfoutput>#Form.txtref#</cfoutput></cfif>"/></td>
                        <td><input type="text" name="txtdoc" id="txtdoc" value="<cfif isdefined("Form.txtdoc")><cfoutput>#Form.txtdoc#</cfoutput></cfif>"/></td>
                        <td> </td>
                        <td></td>
                        <td></td>
            </tr>
					
			</table>
			</cfoutput>
		</cfform>
	<cf_web_portlet_end>
<cf_templatefooter> 		
		
<script language="JavaScript"> 
	 
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
</script> 

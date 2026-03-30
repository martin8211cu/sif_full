<!--- <cfdump var="#form#"> --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Corte" default="Cortes por:" 
returnvariable="LB_Corte" xmlfile="CtrlEventosLibroMayor-Form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Ninguno" default="- Ninguno -" 
returnvariable="LB_Ninguno" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Pagina" default="P&aacute;gina" 
returnvariable="LB_Pagina" xmlfile="CtrlEventosLibroDeDiario.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mayor" default="Mayor" 
returnvariable="LB_Mayor" xmlfile="CtrlEventosLibroDeDiario.xml"/>

<cfinvoke key="MSG_Cuenta_Inicial"		
default="Cuenta Inicial"					
returnvariable="MSG_Cuenta_Inicial"			
component="sif.Componentes.Translate" 
method="Translate"/>

<cfinvoke key="MSG_Cuenta_Final" 		
default="Cuenta Final"						
returnvariable="MSG_Cuenta_Final"			
component="sif.Componentes.Translate" 
method="Translate"/>

<!---Valor Conlis--->
<!---<cfif isdefined("url.conlisnew") and url.conlisnew EQ 1>
	<cfset Session.Conlises.Identity = Session.Conlises.Identity + 1>
</cfif>--->
<cfif isdefined("url.ID_Evento") and not isdefined("form.ID_Evento")>
	<cfset form.ID_Evento = url.ID_Evento>
</cfif>

<!--- Queries necesarios para la pantalla de filtros --->
<!--- Consulta las Oficinas --->
<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion
	from Oficinas 
	where Ecodigo = #Session.Ecodigo#
	order by Odescripcion
</cfquery>

<!--- Consulta los Grupos de Empresas --->
<cfquery name="rsGEmpresas" datasource="#session.DSN#">			
	select ge.GEid, ge.GEnombre
	from AnexoGEmpresa ge
		join AnexoGEmpresaDet gd
			on ge.GEid = gd.GEid
	where ge.CEcodigo = #session.CEcodigo#
		and gd.Ecodigo = #session.Ecodigo#
	order by ge.GEnombre
</cfquery>

<!--- Consulta los Grupos de Oficinas --->
<cfquery name="rsGOficinas" datasource="#session.DSN#">
	select GOid, GOnombre
	from AnexoGOficina
	where Ecodigo = #session.Ecodigo#
	order by GOnombre
</cfquery>

<!--- Consulta los Periodos --->
<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select distinct Speriodo
	from CGPeriodosProcesados
	where Ecodigo = #session.Ecodigo#
	order by Speriodo desc
</cfquery>

<!--- Consulta del Mes --->
<cfquery name="rsMes" datasource="sifControl">
	select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
		and a.Iid = b.Iid
		and b.VSgrupo = 1
	order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
</cfquery>

<!--- Consulta de Monedas --->
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select Mcodigo as Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion 
	from Monedas
	where Ecodigo = #Session.Ecodigo#
</cfquery>

<!--- Consulta de la Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
	from Empresas a, Monedas b
	where a.Ecodigo = #Session.Ecodigo#
		and a.Ecodigo = b.Ecodigo
		and a.Mcodigo = b.Mcodigo
</cfquery>

<cf_templateheader title="Libro Mayor Eventos"> 
		<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		<cfinclude template="Funciones.cfm">
		
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Libro Mayor Eventos'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfset periodo = "#get_val(30).Pvalor#">
			<cfset mes = "#get_val(40).Pvalor#">

    <form action="CtrlEventosLibroMayor-sql.cfm" method="post" name="form1" style="margin:0;" >
		<cfoutput>
            <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
				<!--- Lnea No. 1 --->
                <tr>
                  <td colspan="5">&nbsp;</td>
                </tr>
				<!--- Lnea No. 2 --->
                <tr>
                    <td nowrap align="right">Periodo:&nbsp;</td>
                    <td nowrap>
						<cfif isdefined ("url.periodoIni")>
                            <cfset Speriodo = url.periodoIni>
                        </cfif>
                        <select name="periodoini">
                            <cfloop query="rsPeriodos">
                              <option value="#Speriodo#" <cfif isdefined("periodoini") and periodoini eq Speriodo>selected</cfif>>#Speriodo#</option>
                            </cfloop>
                        </select>
                    </td>
                    <td nowrap align="right">Fecha Inicial:&nbsp;</td>
                    <td nowrap>
						<cfif isdefined ("form.fechaini")>
							<cfset varFecha = #form.fechaini#>
                        <cfelse>
                            <cfset varFecha = "">
                        </cfif>
                        <cf_sifcalendario name="fechaini" tabindex="3" value =#varFecha# >
                    </td>
                </tr>
                <tr>
                    <td nowrap align="right">Mes:&nbsp;</td>
                    <td nowrap>
						<cfif isdefined ("url.mesini")>
                            <cfset VSvalor = url.mesini>
                        </cfif>
                        <select name="mesini">
                           <cfloop query="rsMes">
                              <option value="#VSvalor#"<cfif  isdefined("mesini") and  mesini eq VSvalor>selected</cfif>>#VSdesc#</option>
                            </cfloop>
                        </select>
                    </td>
                    <td nowrap align="right">Fecha Final:&nbsp;</td>
                    <td nowrap>
						<cfif isdefined ("form.fechafin")>
                        	<cfset varFecha = #form.fechafin#>
                        <cfelse>
                        	<cfset varFecha = "">                            
                        </cfif>
                        <cf_sifcalendario name="fechafin" tabindex="4" value =#varFecha# >
                    </td>
                </tr>
                <tr><td>&nbsp; </td></tr>
                <!--- Lnea No. 3 --->
                <tr>
					<td nowrap align="right">Moneda:&nbsp;</td>
              		<td rowspan="2" valign="top">
                    	<table border="0" cellspacing="0" cellpadding="2">
                            <tr>
                              <td nowrap><input name="mcodigoopt" type="radio" value="-2" checked /></td>
                              <td nowrap align="right">Local:</td>
                              <td><strong>#rsMonedaLocal.Mnombre#</strong></td>
                            </tr>
                            <tr>
                              <td nowrap>
                                <input name="mcodigoopt" type="radio" value="0" />
                              </td>
                              <td nowrap align="right">Origen:</td>
                              <td>
                                <select name="Mcodigo" >
                                    <cfloop query="rsMonedas">
                                      <option value="#rsMonedas.Mcodigo#"
                                                            <cfif isdefined('rsMonedas') and isdefined('rsMonedaLocal')>
                                                            <cfif rsMonedas.Mcodigo EQ rsMonedaLocal.Mcodigo >selected</cfif>
                                                            </cfif>
                                                            >#rsMonedas.Mnombre#</option>
                                    </cfloop>
                                </select>
                                </td>   
                            </tr>
                        </table>
                    </td>
                    <td nowrap> <div align="right"><cfoutput>#MSG_Cuenta_Inicial#</cfoutput>:&nbsp;</div></td>
                    <td nowrap> 
                    	<cf_sifCuentasMayor form="form1" Cmayor="cmayor_ccuenta1" Cdescripcion="Cdescripcion1" size="50" tabindex="9">
                    </td>
    			</tr>
                <tr>
                	<td>&nbsp;</td>
                    <td nowrap> <div align="right"><cfoutput>#MSG_Cuenta_Final#:</cfoutput>&nbsp;</div></td>
                    <td nowrap> 
	                    <cf_sifCuentasMayor form="form1" Cmayor="cmayor_ccuenta2" Cdescripcion="Cdescripcion2" size="50" tabindex="10">					
                    </td>						        	
                </tr>
                <tr><td>&nbsp; </td></tr>
                <!---Filtro Evento--->
                <tr>
                	<td colspan="2">&nbsp;</td>
                    <td nowrap align ="right">Tipo Evento:&nbsp;</td>
                    <td nowrap>
                        <cfquery name="idEvento" datasource="#session.dsn#">
                            select  ID_Evento,EVcodigo, EVdescripcion from EEvento
                            where Ecodigo = #session.Ecodigo#
                        </cfquery>
                        
                        <select name="ID_Evento" id="ID_Evento" <!---onchange="javascript:asignar(this.value);"---> >
                        <option value="-1">(Evento)</option>
                        <cfloop query="idEvento">
                            <option value="#ID_Evento# " <cfif isdefined("form.ID_Evento") and  form.ID_Evento EQ idEvento.ID_Evento >selected  </cfif>> #EVcodigo# - #EVdescripcion#</option>
                        </cfloop>
                        </select>
                    </td>
            	</tr>
            
            <!--- Lnea No. 7 --->
            
              <!---<td nowrap>&nbsp; </td><td nowrap>&nbsp; </td>--->
                <tr>
                	<td colspan="2" nowrap>&nbsp;</td>
                    <td nowrap align ="right">Numero Evento:&nbsp;</td>
                    <td nowrap>
                        <cfset varFiltroEvento = "Ecodigo = #Session.Ecodigo#">
                        <cfif isdefined("form.ID_Evento") and form.ID_Evento GT 0>
                            <cfset varFiltroEvento = varFiltroEvento&" and ID_Evento=#form.ID_Evento#">
                        </cfif>
                        
                            <cf_conlis
                              Campos="Evento,ID_NEvento, Oorigen, Documento, Transaccion"
                              Desplegables="S,N,N,N,N"
                              Modificables="S,N,N,N,N"
                              Size="25,10,10,10,10"
                              tabindex="7" 
                              Values="" 
                              Title="Lista de Eventos"
                              Tabla="EventosControl"
                              Columnas="ID_NEvento, Evento, Oorigen, Documento, Transaccion"
                              Filtro="#varFiltroEvento#"
                              Desplegar="Evento, Oorigen, Documento, Transaccion"
                              Etiquetas="Evento, Auxiliar, Documento, Transaccion"
                              filtrar_por="Evento, Oorigen, Documento, Transaccion"
                              Formatos="S,S,S,S,S"
                              Align="left,left,left,left,left"
                              form="form1" 
                              Asignar="Evento,ID_NEvento"
                              Asignarformatos="S,N"
                              EmptyListMsg="No existen Eventos por mostrar"
                              showEmptyListMsg="true"
                              permiteNuevo="false"/>
                    </td>
                </tr>
				<!--- Lnea No. 8 --->
                <tr>
                      <td align="right" nowrap>
                        <input type="checkbox" id="Cortes" name="Cortes" tabindex="13" onClick="javascript: OP_AGRP();">
                      </td>
                      <td align="left">Agrupar por Cuenta de Mayor y Evento</td>
                      <td nowrap align="right">
                    		<input type="checkbox" id="IncluirOperaciones" name="IncluirOperaciones" tabindex="12" onClick="javascript: OP_REL();">
                      </td>
                      <td>Incluir Operaciones relacionadas al Evento</td>
                </tr>
                <tr>
                	<td nowrap colspan="2">&nbsp;</td>
                    <td align="right">#LB_Corte#</td>
                    <td colspan="2" align="left">
                        <select id="corte" name="corte" tabindex="15">
                            <option value="0" selected>#LB_Ninguno#</option>
                            <option value="1">#LB_Pagina#</option>
                            <option value="2">#LB_Mayor#</option>
                        </select>
                    </td>
                </tr>
				<!--- Lnea No. 9 --->
                <tr>
                  <td nowrap colspan="5">&nbsp;</td>
                </tr>											
                <tr>
                  <td colspan="5" align="center"><input type="submit" name="Submit" value="Consultar" onclick="javascript: return validar();" /></td>
                </tr>
                <!--- Lnea No. 11 --->
                <tr>
                  <td nowrap colspan="5">&nbsp;</td>
                </tr>
            </table>
        </cfoutput>
    </form>

 		<cf_web_portlet_end>
	<cf_templatefooter> 

<cfoutput>
	<script language="javascript">
		function asignar(value){
			if (value != ''){
				document.form1.action='';						
				document.form1.submit();	}
		}
		function validar() 
		{
			var grupo = document.form1.ubicacion.value.substring(0,2);
			var oficina = document.form1.IncluirOficina.checked;
			
			if (grupo == 'ge' && oficina == true) {
				alert("No puede seleccionar un Grupo de Empresas con Saldos por Oficina");
				return false;
			}
			return true;
		}
		function habilitar()
		{
			if (document.form1.toExcel.checked == true) {
				document.form1.chkCeros.checked = false;
				document.form1.chkCeros.disabled = true;
			} else {
				document.form1.chkCeros.disabled = false;
			}
		}
		function habilitarExcel()
		{
			if (document.form1.chkCeros.checked == true) {
				document.form1.toExcel.checked = false;
				document.form1.toExcel.disabled = true;
			} else {
				document.form1.toExcel.disabled = false;
			}
		}
		function OP_REL() {
			if (document.getElementById("ID_NEvento").value <=  0 ){
				document.getElementById("IncluirOperaciones").checked=0;
				alert("Debe seleccionar un Evento");
			return 0;
		}
		else
			if (document.getElementById("IncluirOperaciones").checked ==  1 ) {
				alert("Se incluiran los Eventos relacionados al Evento que ha seleccionado");
			}
			return 1;
		}
		function OP_AGRP() {
			if (document.getElementById("Cortes").checked == 1 ){
				document.getElementById("corte").disabled=true;
			}
			else {
				document.getElementById("corte").disabled=false;
			}
		}
	</script>
</cfoutput>





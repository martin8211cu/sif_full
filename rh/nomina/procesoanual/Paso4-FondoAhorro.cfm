<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoNomina" Default="Tipo de N&oacute;mina" returnvariable="LB_TipoNomina"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CalendarioPago" Default="Calendario de Pago" returnvariable="LB_CalendarioPago"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaDesde" Default="Fecha Desde" returnvariable="LB_FechaDesde"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaHasta" Default="Fecha Hasta" returnvariable="LB_FechaHasta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_No_quedan_calendarios_de_pago_para_el_tipo_de_Nomina_seleccionado" Default="No quedan calendarios de pago para el tipo de Nómina seleccionado" returnvariable="MSG_NoHayCalendariosPago"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Tipo_de_nomina" Default="Tipo de n&oacute;mina"	returnvariable="LB_Tipo_de_nomina"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo_Calendario" Default="C&oacute;digo Calendario" returnvariable="LB_Codigo_Calendario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Relacion_de_Calculo" Default="Relaci&oacute;n de C&aacute;lculo" returnvariable="LB_Relacion_de_Calculo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_Inicio" Default="Fecha Inicio"	XmlFile="/rh/generales.xml"returnvariable="LB_Fecha_Inicio"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_Hasta" Default="Fecha Hasta" XmlFile="/rh/generales.xml" returnvariable="LB_Fecha_Hasta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estado" Default="Estado"	returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_No_registros_de_Fondo_Ahorro" Default="No registros de Fondo Ahorro" returnvariable="MSG_No_registros_de_Fondo_Ahorro"/>
<!---Boton Eliminar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Eliminar"
	Default="Eliminar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Eliminar"/>
<!----Boton Nuevo ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Nuevo"
	Default="Nuevo"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Nuevo"/>

<cfif isdefined('url.RHCFOAid') and len(trim(url.RHCFOAid)) GT 0>
	<cfset RHCFOAid = #url.RHCFOAid#>
<cfelseif isdefined('form.RHCFOAid') and len(trim(form.RHCFOAid)) GT 0>
	<cfset RHCFOAid = #form.RHCFOAid#>
</cfif>

<cfquery name="rsFOA" datasource = "#session.DSN#">
	select *
	from RHCierreFOA 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCFOAid#">
</cfquery>

<!---Nominas de Fondo de Ahorro en CalendarioPagos --->
<!--- Calendarios --->
<cfquery name="PaySchedAfterRestrict" datasource="#Session.DSN#">
	select 
		a.CPcodigo, 
		a.CPid, 
		rtrim(a.Tcodigo) as Tcodigo, 
		a.CPdesde, 
		a.CPhasta
	from CalendarioPagos a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.CPfenvio is null
	and a.CPtipo = 5
	and not exists (
		select 1
		from RCalculoNomina h
		where a.Ecodigo = h.Ecodigo
		and a.Tcodigo = h.Tcodigo
		and a.CPdesde = h.RCdesde
		and a.CPhasta = h.RChasta
		and a.CPid = h.RCNid
	)
	and not exists (
		select 1
		from HERNomina i
		where a.Tcodigo = i.Tcodigo
		and a.Ecodigo = i.Ecodigo
		and a.CPdesde = i.HERNfinicio
		and a.CPhasta = i.HERNffin
		and a.CPid = i.RCNid
	)
</cfquery>

<cfquery name="MinFechasNomina" dbtype="query">
	select Tcodigo, min(CPdesde) as CPdesde
	from PaySchedAfterRestrict
	group by Tcodigo
</cfquery>

<cfquery name="rsRCNcount" datasource="#Session.DSN#">
	select 1 
	from RCalculoNomina 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and RCestado in (0,1,2)
</cfquery>

<cfquery name="rsNominasFOA" datasource="#session.DSN#">
	select a.RCNid, a.Ecodigo, rtrim(a.Tcodigo) as Tcodigo, c.CPcodigo,a.RCDescripcion, a.RCdesde, a.RChasta,
	(case a.RCestado 
	when 0 then 'Proceso'
	when 1 then 'Cálculo'
	when 2 then 'Terminado'
	when 3 then 'Pagado'
	else ''
	end) as RCestado,a.Usucodigo, a.Ulocalizacion, b.Tdescripcion
	from RCalculoNomina a, TiposNomina b, CalendarioPagos c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> and RCestado in (0,1,2,3) 
	and a.Tcodigo = b.Tcodigo
	and a.Ecodigo = b.Ecodigo	
	and a.RCNid = c.CPid
	and c.CPtipo = 5
</cfquery>

<!---<cf_dump var = "#form#">---> 
<!---<cf_dump var = "#rsNominasFOA#">--->

<!---Para saber que lista se va a pintar--->
<cfif isdefined('url.Primera') and trim(url.Primera) EQ 1 and not isdefined('form.btnEliminar')>
	<cfset primeraLista = #url.Primera#>
</cfif>

<cfif isdefined('url.Segunda') and trim(url.Segunda) EQ 2 and not isdefined('form.btnEliminar')>
	<cfset segundaLista = #url.Segunda#>
</cfif>

<!---<cf_throw message = "#segundaLista#">--->
<cfoutput>
    <table width="90%" border="0" cellspacing="0" cellpadding="1"  align="center">
        <tr>
            <td colspan="2">
                <table width="55%" border="0" cellspacing="0" cellpadding="1" align="center">
                    <tr>
                        <td width="19%" nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Detalle_Accion">Detalle de Fondo de Ahorro</cf_translate>:</div></td>
                        <td width="81%" nowrap>#rsFOA.RHCFOAcodigo# - #rsFOA.RHCFOAdesc#</td>
                    </tr>
                    <tr>
                        <td nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Fecha_Desde">Fecha Desde</cf_translate>:</div></td>
                        <td nowrap>#LSDateFormat(rsFOA.RHCFOAfechaInicio,'dd-MM-yyyy')#</td>
                    </tr>
                    <tr>
                        <td nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Fecha_Hasta">Fecha Hasta</cf_translate>:</div></td>
                        <td nowrap>#LSDateFormat(rsFOA.RHCFOAfechaFinal,'dd-MM-yyyy')#</td>
                    </tr>
                </table>			
            </td>		
        </tr>
        <cfif isdefined('primeraLista') and primeraLista EQ 1>
        <tr>
        	<td colspan="2">
        	<cfinclude template="Paso4-FondoAhorro-listaForm.cfm">
            </td>
        </tr>
        <cfelseif isdefined('segundaLista') and segundaLista EQ 2>
        <tr>
        	<td colspan="2">
        	<cfinclude template="/rh/portlets/pEmpleado.cfm">
        	<cfinclude template="Paso4-FondoAhorro-form.cfm">
            </td>
        </tr>
        <cfelse>
		<tr height="80%">
        	<td width="50%" valign="top">
            <fieldset style="background-color:##CCCCCC; border: 1px solid ##AAAAAA; height: 15;">
            	<table width="100%">
                	<tr>
                    	<td width="100%">
                        &nbsp;Lista de Relaciones de c&aacute;lculo
                        </td>
                    </tr>
  					<tr>
    				<td width="100%">
						<cfif rsRCNcount.RecordCount gt 0>
							<cfset botones = "Eliminar">
						<cfelse>
							<cfset botones = "">
						</cfif>

                    	<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsNominasFOA#"/>
							<cfinvokeargument name="desplegar" value="Tdescripcion, CPcodigo, RCDescripcion, RCdesde, RChasta, RCestado"/>
							<cfinvokeargument name="etiquetas" value="#LB_Tipo_de_nomina#, #LB_Codigo_Calendario#,#LB_Relacion_de_Calculo#, #LB_Fecha_Inicio#,#LB_Fecha_Hasta#, #LB_Estado#"/>
							<cfinvokeargument name="formatos" value="S,S,S,D,D,S"/>
							<cfinvokeargument name="align" value="left, left, left, center, center, center"/>
                        	<cfinvokeargument name="ajustar" value="S,S,S,S,S,S"/>
                			<cfinvokeargument name="checkboxes" value="S"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="emptylistmsg" value=" --- #MSG_No_registros_de_Fondo_Ahorro# ---"/>
							<cfinvokeargument name="keys" value="RCNid"/>
							<cfinvokeargument name="ira" value="Paso4-FondoAhorro-sql.cfm?RHCFOAid=#RHCFOAid#&tab=4&Primera=1"/>
                            <cfinvokeargument name="botones" value="#botones#"/>
                       </cfinvoke>
               		</td>
              	 	</tr>
                </table>
            </fieldset>
			</td>
		  <form name="form4" method="post" action="Paso4-FondoAhorro-sql.cfm">
          <input type="hidden" name="RHCFOAid" value="#RHCFOAid#">
          <input type="hidden" name="tab" value="4">
		  <input type="hidden" name="RCNid" value="">
            <td width="50%">
            	<table width="100%">
                	<tr>
                    	<td width="30%" nowrap>
                        <strong>#LB_TipoNomina#:</strong>
                        </td>
                        <td width="70%">
                        	<cf_rhtiponominaCombo onChange="changeCalculo" combo="true" todas="true">
                        </td>
                    </tr>
                    <tr>
                    	<td width="30%" nowrap>
                        <strong>#LB_CalendarioPago#:</strong>
                        </td>
                        <td width="70%">
                        <input tabindex="1" type="text" name="CPcodigo" id="CPcodigo2" value="" size="20" maxlength="11" readonly=""> 
                        </td>
                    </tr>
                    <tr>
                    	<td width="30%" nowrap>
                        <strong>#LB_FechaDesde#:</strong>
                        </td>
                        <td width="70%">
                        <input tabindex="1" type="text" name="RCdesde" id="RCdesde" value="" size="15" maxlength="10" readonly="">
                        </td>
                    </tr>
                    <tr>
                    	<td width="30%" nowrap>
                        <strong>#LB_FechaHasta#:</strong>
                        </td>
                        <td width="70%">
                        <input tabindex="1" type="text" name="RChasta" id="RChasta" value="" size="15" maxlength="10" readonly="">
                        </td>
                    </tr>
                    <tr>
                    	<td width="30%" nowrap>
                        <strong>#LB_Descripcion#:</strong>
                        </td>
                        <td width="70%">
                        <input tabindex="1" name="RCDescripcion" type="text" id="RCDescripcion2" size="40" maxlength="80">
                        </td>
                    </tr>
                    <tr>
                    	<td colspan = "2" align="center">
                        	<input name="btnAgregarCP" type="submit" value="Agregar">
                        </td>
                    </tr>
                </table>
            </td>
           </form>
		</tr>
        </cfif>
</table>
</cfoutput>

<SCRIPT src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	var calCPcodgo = new Object();
	var calRCdesde = new Object();
	var calRChasta = new Object();
	var calRCid = new Object();	
	
	<cfoutput>
	<cfloop query="MinFechasNomina">
		<cfquery name="rsCalendarios" dbtype="query">
			select *
			from PaySchedAfterRestrict
			where Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MinFechasNomina.Tcodigo#">
			and CPdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#MinFechasNomina.CPdesde#">
		</cfquery>
		calCPcodgo['#rsCalendarios.Tcodigo#'] = '#rsCalendarios.CPcodigo#';
		calRCdesde['#rsCalendarios.Tcodigo#'] = '#LSDateFormat(rsCalendarios.CPdesde, 'DD/MM/YYYY')#';
		calRChasta['#rsCalendarios.Tcodigo#'] = '#LSDateFormat(rsCalendarios.CPhasta, 'DD/MM/YYYY')#';
		calRCid['#rsCalendarios.Tcodigo#'] = '#rsCalendarios.CPid#';
	</cfloop>
	</cfoutput>
	
	function changeCalculo() {
		changeCal(document.form4.Tcodigo);
	}
	

	function changeCal(ctl) {
		var name = ctl.value;
		if (ctl.form.Tcodigo == '') {
			return false;
		}
		if (calRCdesde[name] && calRChasta[name]) {
			ctl.form.CPcodigo.value = calCPcodgo[name];
			ctl.form.RCdesde.value = calRCdesde[name];
			ctl.form.RChasta.value = calRChasta[name];
			ctl.form.RCNid.value = calRCid[name];
		} else {
			ctl.form.CPcodigo.value = '';
			ctl.form.RCdesde.value = '';
			ctl.form.RChasta.value = '';
			ctl.form.RCNid.value = '';
			<cfoutput>alert('#MSG_NoHayCalendariosPago#')</cfoutput>;
		}
	}
	//-->
</SCRIPT>
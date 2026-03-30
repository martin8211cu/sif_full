<cfif isdefined("Form.RHCconcurso") and LEN(Form.RHCconcurso) GT 0>
	<cfquery name="rsConsulta" datasource="#Session.DSN#">
		select Usucodigo
		from RHConcursos
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
	</cfquery>
</cfif>

<!--- Busca nombre del Solicitante del Concurso --->
<cfif modoAdmConcursos EQ "CAMBIO">
	<cfquery name="rsBuscaUsuario" datasource="#session.DSN#">
		select a.Usucodigo,
				{fn concat(b.Pnombre,{fn concat(' ',{fn concat(b.Papellido1,{fn concat(' ',b.Papellido2)})})})}  as Nombre
		from RHConcursos r

			inner join Usuario a
				on a.Usucodigo = r.Usucodigo

			inner join DatosPersonales b
				on b.datos_personales = a.datos_personales

		where r.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
<cfelse>
	<cfquery name="rsBuscaUsuario" datasource="#session.DSN#">
		select a.Usucodigo,
			{fn concat(b.Pnombre,{fn concat(' ',{fn concat(b.Papellido1,{fn concat(' ',b.Papellido2)})})})} as Nombre
		from Usuario a

			inner join DatosPersonales b
				on b.datos_personales = a.datos_personales

		where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	</cfquery>
</cfif>

<cfoutput>
  <form action="ConcursosMng-sql.cfm" method="post" name="form1">
	<cfinclude template="ConcursosMng-hiddens.cfm">
    <table width="95%" align="center" border="0" cellpadding="2" cellspacing="0">
      <tr>
        <td colspan="4">&nbsp;</td>
      </tr>
      <tr>

	  <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2112" default="" returnvariable="LvarIni"/>

	  <cfif LvarIni gt 0>
	  		  <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2113" default="" returnvariable="LvarCont"/>
			  	<cfif LvarCont gt 0>
					<cfquery name="rsCod" datasource="#session.dsn#">
						select <cf_dbfunction name="date_part"	args="YYYY,#now()#"> as ano,
						max(RHCconcurso) as Concurso
						from RHConcursos
					</cfquery>
					<cfquery name="rsC" datasource="#session.dsn#">
						select RHCcodigo from RHConcursos where RHCconcurso=#rsCod.Concurso#
					</cfquery>
					<cfset LvarCod=0>
					<cfset LvarNum=0>

					<cfloop list="#rsC.RHCcodigo#" delimiters="-" index="x">
							<cfset LvarNum=LvarNum+1>
					</cfloop>
					<cfif rsC.recordcount gt 0 and rsC.RHCcodigo gt 0 and LvarNum gt 1>
						<cfquery name="rs" datasource="#session.dsn#">
							select #listgetat(rsC.RHCcodigo, 1, '-')# as numero,
							#listgetat(rsC.RHCcodigo, 2, '-')# as ano
							from dual
						</cfquery>
						<cfset LvarCod=LvarCod+#rs.numero#+1&'-'&'#rs.ano#'>
					<cfelse>
						<cfset LvarCod='#LvarCont#'&'-'&'#rsCod.ano#'>
					</cfif>
				</cfif>
	  </cfif>
        <td align="right" nowrap><strong><cf_translate key="LB_CodigoDeConcurso">C&oacute;digo de Concurso</cf_translate>:&nbsp;</strong></td>
        <td>
		  <input name="RHCcodigo" type="text"
		  <cfif modoAdmConcursos eq 'Alta' and isdefined('LvarCod') and len(trim(LvarCod)) gt 0>disabled="disabled"<cfelse> </cfif> value="<cfif modoAdmConcursos neq "ALTA">#trim(rsRHConcursos.RHCcodigo)#</cfif><cfif modoAdmConcursos eq 'Alta'
		  and isdefined('LvarCod') and len(trim(LvarCod)) gt 0>#LvarCod#</cfif>" size="10" maxlength="5">
        </td>
        <td align="right"><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</strong></td>
        <td>
          <input name="RHCdescripcion" type="text"
						value="<cfif modoAdmConcursos neq "ALTA">#rsRHConcursos.RHCdescripcion#</cfif>"
						style="width: 100%" maxlength="150" onFocus="this.select();">
        </td>
      </tr>
      <tr>
        <td align="right" nowrap><strong><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</strong></td>
        <td align="left">
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_SeleccioneElCentroFuncionalResponsable"
				Default="Seleccione el Centro Funcional Responsable"
				returnvariable="LB_SeleccioneElCentroFuncionalResponsable"/>

          <cfif modoAdmConcursos neq 'ALTA'>
            <cf_rhcfuncional size="30" name="CFcodigoresp" desc="CFdescripcionresp" titulo="#LB_SeleccioneElCentroFuncionalResponsable#" query="#rsRHConcursos#" >
            <!--- Analizar cuando modoAdmConcursos != alta--->
          <cfelse>
            <cf_rhcfuncional size="30"  name="CFcodigoresp" desc="CFdescripcionresp" titulo="#LB_SeleccioneElCentroFuncionalResponsable#" excluir="-1" >
          </cfif>
        </td>
        <td align="right" nowrap><strong><cf_translate key="LB_Puesto" XmlFile="/rh/generales.xml">Puesto</cf_translate>:&nbsp;</strong></td>
        <td align="left">
          <cfif modoAdmConcursos eq 'ALTA'>
            <cf_rhpuesto name="RHPcodigo">
          <cfelse>
            <cf_rhpuesto name="RHPcodigo" query="#rsRHConcursos#">
          </cfif>
        </td>
      </tr>
      <cfif not isdefined("form.flag")>
        <tr>
          <td align="right" nowrap><strong>&nbsp; &nbsp;<cf_translate key="FechaAperdura">Fecha Apertura</cf_translate>:&nbsp;</strong></td>
          <td align="left">
            <cfif modoAdmConcursos neq "ALTA">
              <cfset fechaI = #rsRHConcursos.RHCfapertura# >
              <cfelse>
              <cfset fechaI = '' >
            </cfif>
            <cf_sifcalendario name="FechaA" value="#LSDateFormat(fechaI,'dd/mm/yyyy')#"> </td>
          <td align="right" nowrap="nowrap" colspan="2">
		  	<table border="0" width="100%">
				<tr>
					<td nowrap="nowrap"> <strong><cf_translate key="LB_FechaCierre">Fecha Cierre</cf_translate>:</strong>&nbsp;</td>
					  <td align="left" >
						<cfif modoAdmConcursos neq "ALTA">
						  <cfset fechaF = #rsRHConcursos.RHCfcierre# >
						  <cfelse>
						  <cfset fechaF = '' >
						</cfif>
						<cf_sifcalendario name="FechaC" value="#LSDateFormat(fechaF,'dd/mm/yyyy')#">
					</td>
					<td nowrap="nowrap"> <strong><cf_translate key="LB_HoraCierre">Hora Cierre</cf_translate>:</strong>&nbsp;</td>
					<!--- Fecha Final --->
					<cfif modoAdmConcursos neq 'ALTA' and len(trim(rsRHConcursos.horafin)) gt 0>
						<cfset HORAF   = Hour(rsRHConcursos.horafin)>
						<cfset MINUTOF = Minute(rsRHConcursos.horafin)>
						<cfset AMPMF   = 'AM'>
						<cfif HORAF gt 12>
							<cfset HORAF = (HORAF - 12)>
						<cfelseif  HORAF eq 0>
							<cfset HORAF = 12>
						</cfif>
						<cfif Hour(rsRHConcursos.horafin) gte 12>
							<cfset AMPMF = 'PM'>
						</cfif>
					<cfelse>
						<cfset HORAF   = 1>
						<cfset MINUTOF = 00>
						<cfset AMPMF   = 'AM'>
					</cfif>
					<td valign="top" nowrap="nowrap">
								<select id="HORAFIN" name="HORAFIN" tabindex="1">
									<cfloop from="1" to="12" index="H">
										<cfif H LT 10>
											<option value="#H#" <cfif H EQ HORAF>selected</cfif>>0#H#</option>
										<cfelse>
											<option value="#H#" <cfif H EQ HORAF>selected</cfif>>#H#</option>
										</cfif>
									</cfloop>
									</select>

									<select id="MINUTOSFIN"  name="MINUTOSFIN" tabindex="1">
									<cfloop from="0" to="59" index="M">
										<cfif M LT 10>
											<option value="#M#" <cfif M EQ MINUTOF>selected</cfif>>0#M#</option>
										<cfelse>
											<option value="#M#" <cfif M EQ MINUTOF>selected</cfif>>#M#</option>
										</cfif>
									</cfloop>
									</select>

									<select  id="PMAMFIN" name="PMAMFIN" tabindex="1">
										<option value="AM" <cfif "AM" EQ AMPMF>selected</cfif> >AM</option>
										<option value="PM" <cfif "PM" EQ AMPMF>selected</cfif>>PM</option>
									</select>

									<input type="hidden" id="_HORAFIN" 		name="_HORAFIN" 	value="#HORAF#">
									<input type="hidden" id="_MINUTOSFIN" 	name="_MINUTOSFIN" 	value="#MINUTOF#">
									<input type="hidden" id="_PMAMFIN" 		name="_PMAMFIN" 	value="#AMPMF#">
					</td>
				</tr>
			</table>
        </tr>
      </cfif>
      <tr>
        <td align="right" nowrap><strong><cf_translate key="LB_Motivo">Motivo</cf_translate>:&nbsp;</strong></td>
		<td>
			<cfquery name="rsMot" datasource="#session.dsn#">
				select RHMid,RHMcodigo, RHMdescripcion from RHMotivos
				where Ecodigo=#session.Ecodigo#
			</cfquery>
			<select name="mot" id="mot">
					<cfloop query="rsMot">
						<option value="#rsMot.RHMid#" <cfif modoAdmConcursos neq "ALTA" and rsMot.RHMid  eq rsRHConcursos.RHCmotivo>selected="selected"</cfif>>#rsMot.RHMcodigo#-#rsMot.RHMdescripcion#</option>
					</cfloop>
			</select>
		</td>
		<td align="right" nowrap><strong>&nbsp; <cf_translate key="LB_NPlazas">N&deg; Plazas</cf_translate>:&nbsp;</strong></td>
        <td align="left">
			<cfif modoAdmConcursos EQ "ALTA">
				  <input name="RHCcantplazas" type="text" size="3" maxlength="3" onFocus="this.select();"
					onChange = "javascript: validaPlaza(this);" onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};">
			<cfelse>
				<input type="hidden" name="RHCcantplazas" value="#rsRHConcursos.RHCcantplazas#">
				#rsRHConcursos.RHCcantplazas#
			</cfif>
		</td>
       <!--- <td align="left">
          <select name="LAMotivo" id="LAMotivo">
            <option value="1" <cfif modoAdmConcursos NEQ 'ALTA' and rsRHConcursos.RHCmotivo EQ 1>selected</cfif>><cf_translate key="LB_Despido">Despido</cf_translate></option>
            <option value="2" <cfif modoAdmConcursos NEQ 'ALTA' and rsRHConcursos.RHCmotivo EQ 2>selected</cfif>><cf_translate key="LB_Renuncia">Renuncia</cf_translate></option>
            <option value="3" <cfif modoAdmConcursos NEQ 'ALTA' and rsRHConcursos.RHCmotivo EQ 3>selected</cfif>><cf_translate key="LB_Traslado">Traslado</cf_translate></option>
            <option value="4" <cfif modoAdmConcursos NEQ 'ALTA' and rsRHConcursos.RHCmotivo EQ 4>selected</cfif>><cf_translate key="LB_Temporal">Temporal</cf_translate></option>
            <option value="5" <cfif modoAdmConcursos NEQ 'ALTA' and rsRHConcursos.RHCmotivo EQ 5>selected</cfif>><cf_translate key="LB_Otro">Otro</cf_translate></option>          </select>
        </td>--->
      </tr>
      <tr>
        <td align="right" nowrap valign="top"><strong><cf_translate key="LB_Justificacion">Justificaci&oacute;n</cf_translate>:</strong>&nbsp;</td>
        <td colspan="3">
          <textarea name="RHCotrosdatos" id="RHCotrosdatos" rows="2" style="width: 100%"><cfif modoAdmConcursos EQ "CAMBIO">#HtmlEditFormat(rsRHConcursos.RHCotrosdatos)#</cfif></textarea>
        </td>
      </tr>
      <tr>
        <td align="right" nowrap><strong><cf_translate key="LB_Fecha">Fecha</cf_translate>:&nbsp;</strong></td>
        <td align="left" nowrap>
          <cfif modoAdmConcursos neq "ALTA">
            #lsdateformat(rsRHConcursos.RHCfecha,'dd/mm/yyyy')#
          <cfelse>
            #lsdateformat(now(),'dd/mm/yyyy')#
          </cfif>
          <input type="hidden" name="INFecha" value="<cfif modoAdmConcursos neq "ALTA">#lsdateformat(rsRHConcursos.RHCfecha,'dd/mm/yyyy')#<cfelse>#lsdateformat(now(),'dd/mm/yyyy')#</cfif>">
        </td>
        <td align="right" nowrap><strong><cf_translate key="LB_Solicitante">Solicitante</cf_translate>:&nbsp;</strong></td>
        <td align="left" nowrap>
            #rsBuscaUsuario.Nombre#
          <input type="hidden" name="INUsuario" value="#rsBuscaUsuario.Nombre#">
        </td>
      </tr>
	
	<cfif modoAdmConcursos eq "ALTA">
		<tr>
			<td align="right" nowrap><strong><cf_translate key="LB_Solicitante">Concurso Externo</cf_translate>:&nbsp;</strong></td>
			<td colspan="3"><input type="checkbox" name="RHCexterno" id="RHCexterno"></td>
		</tr>

	</cfif>
      <cfif modoAdmConcursos neq "ALTA">
        <tr>
          <td align="right"><strong><cf_translate key="LB_Estado">Estado</cf_translate>:</strong>&nbsp;</td>
          <td align="left" colspan="1">
            <cfswitch expression="#rsRHConcursos.RHCestado#">
              <cfcase value="0">
				  <strong><cf_translate key="LB_EnProceso">En Proceso</cf_translate></strong>
              </cfcase>
              <cfcase value="10">
				  <strong><cf_translate key="LB_Solicitado">Solicitado</cf_translate></strong>
              </cfcase>
              <cfcase value="15">
				  <strong><cf_translate key="LB_Verificado">Verificado</cf_translate></strong>
              </cfcase>
              <cfcase value="20">
				  <strong><cf_translate key="LB_Desierto">Desierto</cf_translate></strong>
              </cfcase>
              <cfcase value="30">
				  <strong><cf_translate key="LB_Cerrado">Cerrado</cf_translate></strong>
              </cfcase>
              <cfcase value="40">
				  <strong><cf_translate key="LB_Revision">Revisi&oacute;n</cf_translate></strong>
              </cfcase>
              <cfcase value="50">
				  <strong><cf_translate key="LB_Publicado">Publicado</cf_translate></strong>
              </cfcase>
              <cfcase value="60">
				  <strong><cf_translate key="LB_Evaluado">Evaluado</cf_translate></strong>
              </cfcase>
              <cfcase value="70">
				  <strong><cf_translate key="LB_Terminado">Terminado</cf_translate></strong>
              </cfcase>
            </cfswitch>
          </td>
			<td align="right" nowrap><strong><cf_translate key="LB_Solicitante">Concurso Externo</cf_translate>:&nbsp;</strong></td>
			<td><input type="checkbox" name="RHCexterno" id="RHCexterno"></td>
        </tr>
      </cfif>
      <tr>
        <td colspan="4" align="center" nowrap>&nbsp;</td>
      </tr>
      <tr>
        <td colspan="4" align="center" nowrap>
			<cfif modoAdmConcursos EQ "CAMBIO">
				<cfset publicar = "">
				<cfif rsRHConcursos.RHCestado LT 50>
					<cfset publicar = "Publicar,">
				</cfif>
				<cf_botones modo="#modoAdmConcursos#" include="#publicar#Aplicar">
			<cfelse>
				<cf_botones modo="#modoAdmConcursos#">
			</cfif>
		</td>
      </tr>
    </table>

	<cfset ts = "">
	<cfif modoAdmConcursos NEQ "ALTA">
	  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsRHConcursos.ts_rversion#"/>
	  </cfinvoke>
	  <input type="hidden" name="ts_rversion" value="<cfif modoAdmConcursos NEQ "ALTA">#ts#</cfif>" size="32">
	</cfif>
    <cfif isdefined("form.flag")>
      <input type="hidden" name="flag" value="00<cfif isdefined("Form.flag")>#form.flag#</cfif>">
    </cfif>
  </form>
</cfoutput>
<!---VARIABLES DE TRADUCCION--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Puesto"
	Default="Puesto"
	returnvariable="LB_Puesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CantidadDePlazasRequeridas"
	Default="Cantidad de Plazas requeridas"
	returnvariable="LB_CantidadDePlazasRequeridas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="Código"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripción"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncional"
	XmlFile="/rh/generales.xml"
	Default="Centro Funcional"
	returnvariable="LB_CentroFuncional"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaApertura"
	Default="Fecha Apertura"
	returnvariable="LB_FechaApertura"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaCierre"
	Default="Fecha Cierre"
	returnvariable="LB_FechaCierre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeIngresarAlMenosUnaPlaza"
	Default="Debe ingresar al menos una plaza."
	returnvariable="MSG_DebeIngresarAlMenosUnaPlaza"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EstaSeguroDeQueDeseaPublicarElConcurso"
	Default="¿Esta seguro de que desea publicar el concurso?"
	returnvariable="MSG_EstaSeguroDeQueDeseaPublicarElConcurso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EstaSeguroDeQueDeseaAplicarElConcurso"
	Default="¿Esta seguro de que desea aplicar el concurso?"
	returnvariable="MSG_EstaSeguroDeQueDeseaAplicarElConcurso"/>

<cf_qforms>
<script language="javascript" type="text/javascript">
<!--

	function funcNuevo() {
		NuevoConcurso();
		return false;
	}

	function deshabilitar(){
		document.form1.RHPcodigo.required = false;
		document.form1.RHCcantplazas.required = false;
		document.form1.RHCcodigo.required = false;
		document.form1.RHCdescripcion.required= false;
		<cfif not isdefined("Form.flag")>
			document.form1.FechaA.required= false;
			document.form1.FechaC.required= false;
		</cfif>
		document.form1.CFcodigoresp.required= false;
	}
	<cfoutput>
	document.form1.RHPcodigo.required = true;
	document.form1.RHPcodigo.description="#LB_Puesto#";
	document.form1.RHCcantplazas.required = true;
	document.form1.RHCcantplazas.description="#LB_CantidadDePlazasRequeridas#";
	document.form1.RHCcodigo.required = true;
	document.form1.RHCcodigo.description="#LB_Codigo#";
	document.form1.RHCdescripcion.required= true;
	document.form1.RHCdescripcion.description="#LB_Descripcion#";
	document.form1.CFcodigoresp.required= true;
	document.form1.CFcodigoresp.description="#LB_CentroFuncional#";
	<cfif not isdefined("Form.flag")>
	document.form1.FechaA.required= true;
	document.form1.FechaA.description="#LB_FechaApertura#";
	document.form1.FechaC.required= true;
	document.form1.FechaC.description="#LB_FechaCierre#";
	</cfif>
	</cfoutput>
	function validaPlaza(plaza){
		if (plaza.name){
			p = plaza.value;
		}else{
			p = plaza;
		}
		if (p == 0){
			alert('<cfoutput>#MSG_DebeIngresarAlMenosUnaPlaza#</cfoutput>');
			eval("document.form1.RHCcantplazas.value = '1'");
		}
	}

	function funcPublicar(){
		if (confirm('<cfoutput>#MSG_EstaSeguroDeQueDeseaPublicarElConcurso#</cfoutput>')) {
			return true;
		} else {
			return false;
		}
	}

	function funcAplicar(){
		if (confirm('<cfoutput>#MSG_EstaSeguroDeQueDeseaAplicarElConcurso#</cfoutput>')) {
			return true;
		} else {
			return false;
		}
	}
	function funcAlta(){
	document.form1.RHCcodigo.disabled=false;
	}

	function funcCambio(){
	document.form1.RHCcodigo.disabled=false;
	}

//-->
</script>

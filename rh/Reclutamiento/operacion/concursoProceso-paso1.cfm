<cfif isdefined("url.flag")>
	<cfset Form.flag = url.flag>
</cfif>

<cfif Gconcurso GT 0>
	<cfset form.RHCconcurso = Gconcurso>
</cfif>

<cfset modo = "ALTA">

<cfif isdefined("Form.RHCconcurso") and LEN(Form.RHCconcurso) GT 0>
	<cfquery name="rsConsulta" datasource="#Session.DSN#">
		select Usucodigo
		from RHConcursos
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
	</cfquery>
</cfif>

<!--- Busca usuario para poner nombre en el text Usuario cuando viene RHCconcurso --->
<cfquery name="rsBuscaUsuario" datasource="#session.DSN#">
	select distinct 
			c.Usucodigo,
			'00' as Ulocalizacion,
			c.Usulogin, 

			{fn concat(d.Pnombre,{fn concat(' ',{fn concat(d.Papellido1,{fn concat(' ', d.Papellido2)})})})} as Usunombre
		from UsuarioProceso a inner join Empresa b
		  on a.Ecodigo = b.Ecodigo,
			 Usuario c inner join DatosPersonales d
		  on c.datos_personales = d.datos_personales
		where c.Usucodigo = <cfif isdefined("rsConsulta") and rsConsulta.RecordCount GT 0>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.Usucodigo#">
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							</cfif>
		and b.Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#" >
		and c.Utemporal = 0
		and c.Uestado = 1
		order by c.Usulogin 
</cfquery>

<cfif isDefined("session.Ecodigo") and isDefined("Form.RHCconcurso") and len(trim(#Form.RHCconcurso#)) NEQ 0>
	<cf_translatedata name="get" tabla="CFuncional" col="CFdescripcion" returnvariable="LvarCFdescripcion">
    <cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
    
    <cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
	<cf_dbfunction name="spart" args="#LvarRHCdescripcion#°1°55" delimiters="°" returnvariable="LvarRHCdescripcion">
	<cfquery name="rsRHConcursos" datasource="#Session.DSN#" >
		Select RHCconcurso, RHCcodigo, #LvarRHCdescripcion# as RHCdescripcion, 
			a.CFid, CFcodigo as CFcodigoresp, #LvarCFdescripcion# as CFdescripcionresp, 
			b.RHPcodigo,coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext, #LvarRHPdescpuesto# as RHPdescpuesto, RHCcantplazas, a.RHCfecha,
			RHCfapertura, RHCfcierre, a.RHCmotivo, a.RHCotrosdatos, RHCestado, a.Usucodigo, a.ts_rversion
        from RHConcursos a
			left outer join RHPuestos b
				on a.RHPcodigo = b.RHPcodigo
				and a.Ecodigo = b.Ecodigo
			left outer join CFuncional c
				on a.CFid = c.CFid
				and a.Ecodigo = c.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#" >
		order by RHCdescripcion asc
	</cfquery>
	<cfif rsRHConcursos.recordcount>
		<cfset modo = "CAMBIO">
	</cfif>
</cfif>

<!--- Busca usuario para poner nombre en el text Usuario si no viene RHCconcurso --->
<cfquery name="rsBuscaUsuarioS" datasource="#session.DSN#">
	select distinct 
		c.Usucodigo,
		'00' as Ulocalizacion,
		c.Usulogin, 
		{fn concat(d.Pnombre,{fn concat(' ',{fn concat(d.Papellido1,{fn concat(' ', d.Papellido2)})})})} as Usunombre
	from UsuarioProceso a inner join  Empresa b
	  on a.Ecodigo = b.Ecodigo, Usuario c inner join DatosPersonales d
	  on c.datos_personales = d.datos_personales inner join RHConcursos f
	  on c.Usucodigo = f.Usucodigo
	where b.Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and c.Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#">
	and c.Utemporal = 0
	and c.Uestado = 1
	order by c.Usulogin 
</cfquery>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Despido"
	Default="Despido"
	returnvariable="LB_Despido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Renuncia"
	Default="Renuncia"
	returnvariable="LB_Renuncia"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Traslado"
	Default="Traslado"
	returnvariable="LB_Traslado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Temporal"
	Default="Temporal"
	returnvariable="LB_Temporal"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Otro"
	Default="Otro"
	returnvariable="LB_Otro"/>
	
<cfif (modo neq "ALTA")>
	<cfif rsRHConcursos.RHCmotivo eq 1>
		<cfset bMotivo = LB_Despido>
	<cfelseif rsRHConcursos.RHCmotivo eq 2>
		<cfset bMotivo = LB_Renuncia>
	<cfelseif rsRHConcursos.RHCmotivo eq 3>
		<cfset bMotivo = LB_Traslado>
	<cfelseif rsRHConcursos.RHCmotivo eq 4>
		<cfset bMotivo = LB_Temporal>
	<cfelseif (rsRHConcursos.RHCmotivo eq 5)>
		<cfset bMotivo = LB_Otro>
	</cfif>
</cfif>

<script language="JavaScript" type="text/JavaScript">
<!--
	function funcNuevo(){
		document.form1.RHCconcurso.value='';
	}
	function funcAnterior(){
		deshabilitar();
		funcNuevo();
	}
//-->
</script>
<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js"></script>

<cfoutput>
  <form action="#currentPage#" method="post" name="form1">
    <input type="hidden" name="paso" value="<cfif isdefined("Gpaso")>#Gpaso#<cfelse>0</cfif>">
    <table width="95%" align="center" border="0" cellpadding="2" cellspacing="0">
      <tr>
        <td colspan="4">&nbsp;</td>
      </tr>
      <tr>
      	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2112" default="" returnvariable="LvarIni"/>	  

	  <cfif LvarIni gt 0>
	  		  <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2113" default="0" returnvariable="LvarCont"/>
				<cfif LvarCont gt 0>	
					<cfquery name="rsCod" datasource="#session.dsn#">
						select <cf_dbfunction name="date_part"	args="YYYY,#now()#"> as ano,
						coalesce(max(RHCconcurso),0) as Concurso 
						from RHConcursos
						where RHCcodigo like '%-%'
					</cfquery>
                                
                    <cfquery name="rsC" datasource="#session.dsn#">
						select RHCcodigo from RHConcursos where RHCconcurso=#rsCod.Concurso# 
					</cfquery>	
					                      
					<cfset LvarCod=0>
                  
					<cfif rsC.recordcount gt 0 and rsC.RHCcodigo gt 0 >
						<cfquery name="rs" datasource="#session.dsn#">
							select '#listgetat(rsC.RHCcodigo, 1, '-')#' as numero,
							'#listgetat(rsC.RHCcodigo, 2, '-')#' as ano
							from dual
						</cfquery>

						<cfif not IsNumeric(rs.numero) and IsNumeric(rs.ano) and len(rs.ano) NEQ 4>
							<cfset LvarCod = #LvarCont# >
						<cfelse>
							<cfset LvarCod = rs.numero>
						</cfif>
						
                         <cfif #rsCod.ano# EQ #rs.ano# >
                         	<cfset LvarCod=LvarCod+1&'-'&'#rs.ano#'>
                         <cfelse>
                         	<cfset LvarCod=LvarCont&'-'&'#rsCod.ano#'>
                         </cfif>
					<cfelse>	
                        <cfset LvarCod=LvarCod+1&'-'&'#rsCod.ano#'>
					</cfif>
				</cfif>		  
	    </cfif> 
        <td align="right" nowrap><strong><cf_translate key="LB_CodigoDeConcurso">Código de Concurso</cf_translate>:&nbsp;</strong></td>
         <td>
		  <input name="RHCcodigo" type="text" 
		  <cfif modo eq 'Alta' and isdefined('LvarCod') and len(trim(LvarCod)) gt 0>disabled="disabled"<cfelse> </cfif> value="<cfif modo neq "ALTA">#trim(rsRHConcursos.RHCcodigo)#</cfif><cfif modo eq 'Alta'
		  and isdefined('LvarCod') and len(trim(LvarCod)) gt 0>#LvarCod#</cfif>" size="10" maxlength="10">
        </td>
        <td align="right"><strong><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate>:&nbsp;</strong></td>
        <td>
          <input name="RHCdescripcion" type="text"   tabindex="1"
						value="<cfif modo neq "ALTA">#rsRHConcursos.RHCdescripcion#</cfif>"  
						style="width: 100%" maxlength="150" onFocus="this.select();">
        </td>
      </tr>
      <tr>
        <td align="right" nowrap><strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</strong></td>
        <td align="left">
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_SeleccioneElCentroFuncionalResponsable"
				Default="Seleccione el Centro Funcional Responsable"
				returnvariable="MSG_SeleccioneElCentroFuncionalResponsable"/>

          <cfif modo neq 'ALTA'>
            <cf_rhcfuncional size="30" name="CFcodigoresp" desc="CFdescripcionresp" 
				titulo="#MSG_SeleccioneElCentroFuncionalResponsable#" query="#rsRHConcursos#" tabindex="1">
            <!--- Analizar cuando modo != alta--->
          <cfelse>
            <cf_rhcfuncional size="30"  name="CFcodigoresp" desc="CFdescripcionresp" 
				titulo="#MSG_SeleccioneElCentroFuncionalResponsable#" excluir="-1"  tabindex="1">
          </cfif>
        </td>
        <td align="right" nowrap><strong><cf_translate key="LB_Puesto">Puesto</cf_translate>:&nbsp;</strong></td>
        <td align="left">
          <cfif modo eq 'ALTA'>
            <cf_rhpuesto name="RHPcodigo" tabindex="1">
          <cfelse>
            <cf_rhpuesto  name="RHPcodigo" query="#rsRHConcursos#" tabindex="1">
          </cfif>
        </td>
      </tr>
      <cfif not isdefined("form.flag")>
        <tr>
          <td align="right" nowrap><strong>&nbsp; &nbsp;<cf_translate key="LB_FechaApertura">Fecha Apertura</cf_translate>:&nbsp;</strong></td>
          <td align="left">
            <cfif modo neq "ALTA">
              <cfset fechaI = #rsRHConcursos.RHCfapertura# >
              <cfelse>
              <cfset fechaI = '' >
            </cfif>
            <cf_sifcalendario name="FechaA" value="#LSDateFormat(fechaI,'dd/mm/yyyy')#" tabindex="1"> </td>
          <td align="right"><strong><cf_translate key="LB_FechaCierre">Fecha Cierre</cf_translate>:</strong>&nbsp;</td>
          <td align="left" >
            <cfif modo neq "ALTA">
              <cfset fechaF = #rsRHConcursos.RHCfcierre# >
              <cfelse>
              <cfset fechaF = '' >
            </cfif>
            <cf_sifcalendario name="FechaC" value="#LSDateFormat(fechaF,'dd/mm/yyyy')#" tabindex="1"> </td>
        </tr>
      </cfif>
      <tr>
        <td align="right" nowrap><strong><cf_translate key="LB_Motivo">Motivo</cf_translate>:&nbsp;</strong></td>
        <td align="left">
          <select name="LAMotivo" id="LAMotivo" tabindex="1">
            <option value="1" <cfif modo NEQ 'ALTA' and rsRHConcursos.RHCmotivo EQ 1>selected</cfif>><cf_translate key="LB_Despido">Despido</cf_translate></option>
            <option value="2" <cfif modo NEQ 'ALTA' and rsRHConcursos.RHCmotivo EQ 2>selected</cfif>><cf_translate key="LB_Renuncia">Renuncia</cf_translate></option>
            <option value="3" <cfif modo NEQ 'ALTA' and rsRHConcursos.RHCmotivo EQ 3>selected</cfif>><cf_translate key="LB_Traslado">Traslado</cf_translate></option>
            <option value="4" <cfif modo NEQ 'ALTA' and rsRHConcursos.RHCmotivo EQ 4>selected</cfif>><cf_translate key="LB_Temporal">Temporal</cf_translate></option>
            <option value="5" <cfif modo NEQ 'ALTA' and rsRHConcursos.RHCmotivo EQ 5>selected</cfif>><cf_translate key="LB_Otro">Otro</cf_translate></option>
          </select>
        </td>
        <td align="right" nowrap><strong>&nbsp; <cf_translate key="LB_NoPlazas">N&deg; Plazas</cf_translate>:&nbsp;</strong></td>
        <td align="left">
          <input name="RHCcantplazas" type="text" tabindex="1"  value="<cfif modo neq "ALTA">#rsRHConcursos.RHCcantplazas#</cfif>" 
			  		size="3" maxlength="3" onFocus="this.select();" 
					onChange = "javascript: validaPlaza(this);"
					onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};">
        </td>
      </tr>
      <tr>
        <td align="right" nowrap valign="top"><strong><cf_translate key="LB_Justificacion">Justificaci&oacute;n</cf_translate>:</strong>&nbsp;</td>
        <td colspan="3">
          <cfif modo eq "ALTA">
            <cfset bHTML = "">
            <cfelse>
            <cfset bHTML = rsRHConcursos.RHCotrosdatos>
          </cfif>
          <textarea name="RHCotrosdatos" id="RHCotrosdatos" rows="2" style="width: 100%" tabindex="1">#bHTML#</textarea>
        </td>
      </tr>
      <tr>
        <td align="right" nowrap><strong><cf_translate key="LB_Fecha">Fecha</cf_translate>:&nbsp;</strong></td>
        <td align="left" nowrap>
          <cfif modo neq "ALTA">
            #lsdateformat(rsRHConcursos.RHCfecha,'dd/mm/yyyy')#
          <cfelse>
            #lsdateformat(now(),'dd/mm/yyyy')#
          </cfif>
          <input type="hidden" name="INFecha" tabindex="1" value="<cfif modo neq "ALTA">#lsdateformat(rsRHConcursos.RHCfecha,'dd/mm/yyyy')#<cfelse>#lsdateformat(now(),'dd/mm/yyyy')#</cfif>">
        </td>
        <td align="right" nowrap><strong><cf_translate key="LB_Usuario">Usuario</cf_translate>:&nbsp;</strong></td>
        <td align="left" nowrap>
          <cfif modo neq "ALTA">
            #rsBuscaUsuario.Usunombre#
          <cfelse>
            #rsBuscaUsuarioS.Usunombre#
          </cfif>
          <input type="hidden" name="INUsuario" tabindex="1"
		  	value="<cfif modo neq "ALTA">#rsBuscaUsuario.Usunombre#<cfelse>#rsBuscaUsuarioS.Usunombre#</cfif>">
        </td>
      </tr>
      <cfif modo neq "ALTA">
        <tr>
          <td align="right"><strong><cf_translate key="LB_Estado">Estado</cf_translate>:</strong>&nbsp;</td>
          <td align="left" colspan="3">
            <cfswitch expression="#rsRHConcursos.RHCestado#">
              <cfcase value="0">
				  <strong><cf_translate key="LB_EnProceso">En Proceso</cf_translate></strong>
              </cfcase>
              <cfcase value="10">
				  <strong><cf_translate key="LB_Solicitado">Solicitado</cf_translate></strong>
              </cfcase>
              <cfcase value="20">
				  <strong><cf_translate key="LB_Desierto">Desierto</cf_translate></strong>
              </cfcase>
              <cfcase value="30">
				  <strong><cf_translate key="LB_Cerrado">Cerrado</cf_translate></strong>
              </cfcase>
              <cfcase value="15">
				  <strong><cf_translate key="LB_Verificado">Verificado</cf_translate></strong>
              </cfcase>
              <cfcase value="40">
				  <strong><cf_translate key="LB_Revision">Revisi&oacute;n</cf_translate></strong>
              </cfcase>
              <cfcase value="50">
				  <strong><cf_translate key="LB_Aplicado">Aplicado</cf_translate></strong>
              </cfcase>
            </cfswitch>
          </td>
        </tr>
      </cfif>
      <tr><td colspan="4">&nbsp;</td></tr>
    </table>
	<!--- Variables de Traduccion --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Anterior"
		Default="Anterior"
		returnvariable="BTN_Anterior"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Siguiente"
		Default="Siguiente"
		returnvariable="BTN_Siguiente"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Aplicar"
		Default="Aplicar"
		returnvariable="BTN_Aplicar"/>
	
	<cfif modo NEQ "ALTA">
	  <cfif not isdefined("form.flag") and not isdefined("Aplicar")>
		<cf_botones modo=#modo# includebefore="Anterior" includebeforevalues="<< #BTN_Anterior#" include="Siguiente" includevalues="#BTN_Siguiente# >>" tabindex="1">
	  <cfelse>
		<cf_botones modo=#modo# include="Aplicar" includevalues="#BTN_Aplicar#" includebefore="Anterior" includebeforevalues="<< #BTN_Anterior#" tabindex="1">
	  </cfif>
	<cfelse>
	  <cf_botones modo=#modo# includebefore="Anterior" includebeforevalues="<< #BTN_Anterior#" tabindex="1">
	</cfif>
	
	<cfset ts = "">
	<cfif modo NEQ "ALTA">
	  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsRHConcursos.ts_rversion#"/>
	  </cfinvoke>
	  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" size="32">
	</cfif>
	
    <input type="hidden" name="RHCconcurso" value="<cfif modo NEQ "ALTA">#rsRHConcursos.RHCconcurso#</cfif>">
    <cfif isdefined("form.flag")>
      <input type="hidden" name="flag" value="<cfif isdefined("Form.flag")>#form.flag#</cfif>">
    </cfif>
    <input name="pasoante" type="hidden" value="1">
  </form>
</cfoutput> 

<!--- Variables de Traduccion --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Puesto"
	Default="Puesto"
	returnvariable="MSG_Puesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_CantidadDePlazasRequeridas"
	Default="Cantidad de Plazas requeridas"
	returnvariable="MSG_CantidadDePlazasRequeridas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	returnvariable="MSG_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_CentroFuncional"
	Default="Centro Funcional"
	returnvariable="MSG_CentroFuncional"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechaApertura"
	Default="Fecha Apertura"
	returnvariable="MSG_FechaApertura"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechaCierre"
	Default="Fecha Cierre"
	returnvariable="MSG_FechaCierre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Modificar"
	Default="Modificar"
	returnvariable="MSG_Modificar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeIngresarAlMenosUnaPlaza"
	Default="Debe ingresar al menos una plaza"
	returnvariable="MSG_DebeIngresarAlMenosUnaPlaza"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaAplicarElConcurso"
	Default="¿Desea aplicar el concurso?"
	returnvariable="MSG_DeseaAplicarElConcurso"/>

<cf_qforms>
<script language="javascript" type="text/javascript">
<!-- 

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
	
	document.form1.RHPcodigo.required = true;
	document.form1.RHPcodigo.description="<cfoutput>#MSG_Puesto#</cfoutput>";
	document.form1.RHCcantplazas.required = true;
	document.form1.RHCcantplazas.description="<cfoutput>#MSG_CantidadDePlazasRequeridas#</cfoutput>";
	document.form1.RHCcodigo.required = true;
	document.form1.RHCcodigo.description="<cfoutput>#MSG_Codigo#</cfoutput>";		
	document.form1.RHCdescripcion.required= true;
	document.form1.RHCdescripcion.description="<cfoutput>#MSG_Descripcion#</cfoutput>";
	document.form1.CFcodigoresp.required= true;
	document.form1.CFcodigoresp.description="<cfoutput>#MSG_CentroFuncional#</cfoutput>";			
	<cfif not isdefined("Form.flag")>
	document.form1.FechaA.required= true;
	document.form1.FechaA.description="<cfoutput>#MSG_FechaApertura#</cfoutput>";		
	document.form1.FechaC.required= true;
	document.form1.FechaC.description="<cfoutput>#MSG_FechaCierre#</cfoutput>";			
	</cfif>
	
	
	function funcSiguiente(){
		document.form1.cambio = "<cfoutput>#MSG_Modificar#</cfoutput>";
		return true;
	}

	function validaPlaza(plaza){
		if (plaza.name){
			p = plaza.value;
		}else{
			p = plaza;
		}
		if (p == 0){
			alert('<cfoutput>#MSG_DebeIngresarAlMenosUnaPlaza#</cfoutput>.');
			eval("document.form1.RHCcantplazas.value = '1'");
		}
	}
	
	function funcAplicar(){
		if (confirm('<cfoutput>#MSG_DeseaAplicarElConcurso#</cfoutput>')){
			return true;
		}else{
			return false;
		}
	}
	
//-->
</script>

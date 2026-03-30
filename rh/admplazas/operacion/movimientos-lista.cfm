<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfset navegacion = '' >
<cfif isdefined("url.fRHMPcodigo") and not isdefined("form.fRHMPcodigo") >
	<cfset form.fRHMPcodigo = url.fRHMPcodigo >
	<cfset navegacion =  navegacion & '&fRHMPcodigo=#form.fRHMPcodigo#' >
</cfif>
<cfif isdefined("url.fRHTMid") and not isdefined("form.fRHTMid") >
	<cfset form.fRHTMid = url.fRHTMid >
	<cfset navegacion =  navegacion & '&fRHTMid=#form.fRHTMid#' >
</cfif>
<cfif isdefined("url.fRHMPfdesde") and not isdefined("form.fRHMPfdesde") >
	<cfset form.fRHMPfdesde = url.fRHMPfdesde >
	<cfset navegacion =  navegacion & '&fRHMPfdesde=#form.fRHMPfdesde#' >
</cfif>
<cfif isdefined("url.fRHMPfhasta") and not isdefined("form.fRHMPfhasta") >
	<cfset form.fRHMPfhasta = url.fRHMPfhasta >
	<cfset navegacion =  navegacion & '&fRHMPfhasta=#form.fRHMPfhasta#' >
</cfif>
<cfif isdefined("url.usuario") and not isdefined("form.usuario") >
	<cfset form.usuario = url.usuario >
	<cfset navegacion =  navegacion & '&usuario=#form.usuario#' >
</cfif>

<!--- manejo de fechas --->
<cfset finicio = createdate(1900, 01, 01)>
<cfset ffin = createdate(6100, 01, 01)>
<cfif isdefined("form.fRHMPfdesde") and len(trim(form.fRHMPfdesde))>
	<cfset finicio = LSParseDateTime( form.fRHMPfdesde ) >
</cfif>
<cfif isdefined("form.fRHMPfhasta") and len(trim(form.fRHMPfhasta))>
	<cfset ffin = LSParseDateTime( form.fRHMPfhasta ) >
</cfif>
<!---
<cfif datecompare(finicio, ffin) eq 1 >
	<cfset tmp = finicio>
	<cfset finicio = ffin >
	<cfset ffin = tmp >
</cfif>
--->

<!--- tipos de movimiento --->
<cfquery name="tipo" datasource="#session.DSN#">
	select tm.RHTMid, tm.RHTMcodigo, tm.RHTMdescripcion 
	from RHTipoMovimiento tm
	where tm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by tm.RHTMcodigo
</cfquery>

<cfoutput>
<form name="filtro" method="post" action="" style="margin:0;" >
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
	<tr> 
		<td class="fileLabel">Tipo de Movimiento</td>
		<td class="fileLabel">Plaza Presupuestaria</td>
		<td class="fileLabel">Fecha Rige</td>
		<td class="fileLabel">Fecha Vence</td>
		<td class="fileLabel">Usuario</td>
		<td class="fileLabel">&nbsp;</td>
	</tr>

	<tr>
		<td>
			<select name="fRHTMid">
				<option value="">-Todos -</option> 
				<cfloop query="tipo">
					<option value="#tipo.RHTMid#" <cfif isdefined("form.fRHTMid") and form.fRHTMid eq tipo.RHTMid >selected</cfif>  >#tipo.RHTMcodigo# - #tipo.RHTMdescripcion#</option> 
				</cfloop>
			</select>
		</td>
		<td>
			<input type="text" name="fRHPPcodigo" value="<cfif isdefined("form.fRHPPcodigo") and len(trim(form.fRHPPcodigo))>#form.fRHPPcodigo#</cfif>" size="10" maxlength="10" />
		</td>
		<td>
			<cfif isdefined("Form.fRHMPfdesde")>
				<cfset fecha = Form.fRHMPfdesde>
				<cfelse>
				<cfset fecha = "">
			</cfif>
			<cf_sifcalendario form="filtro" value="#fecha#" name="fRHMPfdesde">	
		</td>
		
		<td>
			<cfif isdefined("Form.fRHMPfdesde")>
				<cfset fecha = Form.fRHMPfhasta>
				<cfelse>
				<cfset fecha = "">
			</cfif>
			<cf_sifcalendario form="filtro" value="#fecha#" name="fRHMPfhasta">	
		</td>

		<cfquery name="usuario" datasource="#session.DSN#">
			select distinct mp.BMUsucodigo, dp.Pnombre, dp.Papellido1, dp.Papellido2, u.Usulogin
			from RHMovPlaza mp
			
			inner join Usuario u
			on u.Usucodigo = mp.BMUsucodigo
			
			inner join DatosPersonales dp
			on dp.datos_personales = u.datos_personales
			
			where RHMPestado = 'P'
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>	
		<td>
			<select name="usuario">
				<option value="">- Todos -</option>
				<cfloop query="usuario">
					<option value="#usuario.BMusucodigo#"  <cfif isdefined("form.usuario") and form.usuario eq usuario.BMUsucodigo>selected</cfif> >#usuario.Usulogin#</option>
				</cfloop>
			</select>
		</td>

	  	<td align="center">
			<input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
			<input name="btnNuevo" type="submit" id="btnNuevo" value="Nuevo" onclick="javascript:this.form.action='registro-movimientos.cfm'">
			<!---<input name="btnBuscar" type="button" id="btnAplicar" value="Aplicar" onclick="javascript: funcAplicarFiltro();">--->
			<!---<input name="btnBuscar" type="button" id="btnEliminar" value="Eliminar" onclick="javascript: funcEliminarFiltro();">--->

			<!--- OJO ver si se hacen dos forms o uno solo--->
			<!---
			<input name="btnBuscar" type="submit" id="btnAplicar" value="Aplicar">
			--->
	  	</td>
	</tr>
</table>
</form>
</cfoutput>

<script language="JavaScript" type="text/javascript">
	function funcAplicar() {
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				return (document.lista.chk.checked);
			} else {
				for (var i=0; i<document.lista.chk.length; i++) {
					if (document.lista.chk[i].checked) return true;
				}
			}
		}
		return false;
	}
	
	function marcados(){
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				return (document.lista.chk.checked);
			} else {
				for (var i=0; i<document.lista.chk.length; i++) {
					if (document.lista.chk[i].checked) return true;
				}
			}
		}
		return false;
	}

	function funcEliminar(){
		if ( marcados() ){
			if ( confirm('Desea eliminar los registros seleccionados?') ) {
				document.lista.ELIMINAINPUT.value = 'ok';
				document.lista.action = 'registro-movimientos-sql.cfm';
				return true;
			}
			return false;
		}
		else{
			alert('Debe seleccionar al menos un registro.');
			return false;
		}
	}

	function funcEliminarFiltro(){
		if ( marcados() ){
			if ( confirm('Desea eliminar los registros seleccionados?') ){
				document.lista.ELIMINAINPUT.value = 'ok';
				document.lista.action = 'registro-movimientos-sql.cfm';
				document.lista.submit();
			}	
		}
		else{
			alert('Debe seleccionar al menos un registro.');
		}
	}


	function funcAplicar(){
		if ( marcados() ){
			if ( confirm('Desea aplicar los registros seleccionados?') ) {
				document.lista.APLICARINPUT.value = 'ok';
				document.lista.action = 'registro-movimientos-sql.cfm';
				return true;
			}
			return false;
		}
		else{
			alert('Debe seleccionar al menos un registro.');
			return false;
		}
	}

	function funcAplicarFiltro(){
		if ( marcados() ){
			if ( confirm('Desea aplicar los registros seleccionados?') ){
				document.lista.APLICARINPUT.value = 'ok';
				document.lista.action = 'registro-movimientos-sql.cfm';
				document.lista.submit();
			}	
		}
		else{
			alert('Debe seleccionar al menos un registro.');
		}
	}
</script>

<cfquery name="lista" datasource="#session.DSN#">
	select mp.RHMPid,   		<!--- llave --->
		   mp.RHPPid,    		<!--- id plaza presupuestaria --->
   		   rtrim(  coalesce(pp.RHPPcodigo, mp.RHPPcodigo)  ) #LvarCNCT# ' - '#LvarCNCT# coalesce(pp.RHPPdescripcion, mp.RHPPdescripcion) as descripcion,
		   mp.RHTMid, 			<!--- tipo de movimiento --->
		   mp.RHMPfdesde, 
		   mp.RHMPfhasta, 
		   coalesce(mp.RHPPcodigo, pp.RHPPcodigo) as RHPPcodigo,	
		   coalesce(mp.RHPPdescripcion, pp.RHPPdescripcion) as RHPPdescripcion,
		   tm.RHTMcodigo #LvarCNCT# ' - ' #LvarCNCT# tm.RHTMdescripcion as RHTMdescripcion,
		   'Eliminar' as EliminaInput,
		   'Aplicar' as AplicarInput
	
	from RHMovPlaza mp
	
    <!--- tipo de movimiento --->
	inner join RHTipoMovimiento tm
	on tm.RHTMid=mp.RHTMid
	<cfif isdefined("form.fRHTMid") and len(trim(form.fRHTMid))>
		and tm.RHTMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fRHTMid#" >
	</cfif>
	
    <!--- plaza presupuestaria --->
	left join RHPlazaPresupuestaria pp
	on pp.RHPPid=mp.RHPPid
	<cfif isdefined("form.fRHPPcodigo") and len(trim(form.fRHPPcodigo))>
		and upper(pp.RHPPcodigo) like '%#ucase(form.fRHPPcodigo)#%'
	</cfif>
	<cfif isdefined("form.fRHPPdescripcion") and len(trim(form.fRHPPdescripcion))>
		and upper(pp.fRHPPdescripcion) like '%#ucase(form.fRHPPdescripcion)#%'
	</cfif>

	where mp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and mp.RHMPestado = 'P'
	
	<cfif isdefined("form.fRHMPfdesde") and len(trim(form.fRHMPfdesde))>
		and mp.RHMPfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finicio#">
	</cfif>

	<cfif isdefined("form.fRHMPfhasta") and len(trim(form.fRHMPfhasta))>
		and mp.RHMPfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ffin#">
	</cfif>

	<cfif isdefined("form.usuario") and len(trim(form.usuario))>
		and mp.BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.usuario#">
	</cfif>
	
	order by mp.RHPPcodigo, mp.RHMPfdesde, mp.RHMPfhasta 
</cfquery>

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
	<td>
	
		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#lista#"/>
			<cfinvokeargument name="desplegar" value="RHMPid, RHTMdescripcion, descripcion, RHMPfdesde, RHMPfhasta"/>
			<cfinvokeargument name="etiquetas" value="Número, Tipo de Movimiento,Plaza Presupuestaria,Fecha Rige, Fecha Vence"/>
			<cfinvokeargument name="formatos" value="V,V,V,D,D"/>
			<cfinvokeargument name="align" value="left,left,left, center, center"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="checkboxes" value="S"/>
			<cfinvokeargument name="botones" value="Aplicar,Nuevo,Eliminar"/>
			<cfinvokeargument name="irA" value="/cfmx/rh/admplazas/operacion/registro-movimientos.cfm"/>
			<cfinvokeargument name="keys" value="RHMPid"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="formName" value="lista"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="yes"/>
		</cfinvoke>
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
</table>

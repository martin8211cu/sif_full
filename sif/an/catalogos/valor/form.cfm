<!---
    modificado por danim,2005-09-06, para 
    incluir los parametros de Grupo de Empresas
    y Grupo de Oficinas
	Tanto en AnexoCalculo como en AnexoVarValor,
		Ecodigo debe ser -1 cuando GEcodigo != -1,
		es decir, la información para grupos de
		empresas se guarda sin indicar una empresa
		específica, esto permite realizar las búsquedas
		con la empresa -1
--->


<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Mensaje" 	default="Seleccione la ubicación o variable con la que desea trabajar." returnvariable="LB_Mensaje" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Mes" 	default="Mes" returnvariable="LB_Mes" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Ubicacion" 	default="Ubicaci&oacute;" 
returnvariable="LB_Ubicacion" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_VariablesEmpresa" 	default="Variables de Empresa" 
returnvariable="LB_VariablesEmpresa" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Seleccion" 	default="Todas" 
returnvariable="LB_Seleccion" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_GruposEmpresas" 	default="Todos los grupos de empresas" 
returnvariable="LB_GruposEmpresas" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_GruposOficinas" 	default="Todos los grupos de oficinas" 
returnvariable="LB_GruposOficinas" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Oficinas" 	default="Todas las oficinas" 
returnvariable="LB_Oficinas" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_OficinaCentral" 	default="Oficina Central" 
returnvariable="LB_OficinaCentral" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Valor" 	default="Valor" 
returnvariable="LB_Valor" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_ValorAnual" 	default="Valor Anual para el  Año" 
returnvariable="LB_ValorAnual" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="BTN_Filtrar" 	default="Filtrar" 
returnvariable="BTN_Filtrar" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="BTN_Lista" 	default="Listado" 
returnvariable="BTN_Lista" xmlfile="form.xml"/>


<cfif isdefined("url.AVano") and not isdefined("form.AVano")>
  <cfset form.AVano = url.AVano>
</cfif>
<cfif isdefined("url.AVmes") and not isdefined("form.AVmes")>
  <cfset form.AVmes = url.AVmes>
</cfif>
<cfif isdefined("url.ubicacion") and not isdefined("form.ubicacion")>
  <cfset form.ubicacion = url.ubicacion>
</cfif>
<cfif isdefined("url.AVid") and not isdefined("form.AVid")>
  <cfset form.AVid = url.AVid>
</cfif>
<cf_dbfunction name="to_char" args="AVdescripcion" returnvariable="AVdescripcion">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfif not isdefined("form.AVmes")>
	<cfquery name="rsMesCont" datasource="#session.dsn#">
		select Pvalor 
		from Parametros 
		where Pcodigo = 40 
		  and Ecodigo = #session.ecodigo#
	</cfquery>
	<cfset form.AVmes = rsMesCont.Pvalor>
</cfif>

<cfset form.Ocodigo = "">
<cfset form.GOid = "">
<cfset form.GEid = "">
<cfset TituloUbicacion = "Oficina/Grupo">
<cfparam name="form.ubicacion" default="">
<cfif ListFirst(form.ubicacion) EQ 'of'>
	<cfset TituloUbicacion = "Oficina">
	<cfset form.Ocodigo = ListRest(form.ubicacion)>
<cfelseif ListFirst(form.ubicacion) EQ 'go'>
	<cfset TituloUbicacion = "Grupo de Oficinas">
	<cfset form.GOid = ListRest(form.ubicacion)>
<cfelseif ListFirst(form.ubicacion) EQ 'ge'>
	<cfset TituloUbicacion = "Grupo de Empresas">
	<cfset form.GEid = ListRest(form.ubicacion)>
<cfelseif form.ubicacion EQ '-1'>
	<cfset TituloUbicacion = "Variables de Empresa">
</cfif>
<cfif ListLen(form.ubicacion) EQ 2>
	<cfset form.AVid = ''>
</cfif>

<cfparam name="form.Ocodigo" default="">
<cfparam name="form.GOid"    default="">
<cfparam name="form.GEid"    default="">
<cfparam name="form.AVid"    default="">

<!---
	Valores de Variables, esta pantalla tiene 2 sabores, uno cuando el usuario selecciona una oficina, otro cuando el usuario selecciona una variable, 
	y podra haber un tercero si el usuario selecciona las 2 pero no es la idea para que pueda calcular mas rpido.
	Primero: Cuando el usuario selecciona una Oficina. Se pinta una lista con todas las variables, y todos los valores afectan la Oficina seleccionado.
	Segundo: Cuando el usuario selecciona una Variable. Se pinta una lista con todas las oficinas, y todos los valores afectan la Variable seleccionada.
 --->
<!--- Consultas --->
<!--- Ao de Auxiliares --->
<cfquery name="rsAnoActual" datasource="#session.dsn#">
	select Pvalor 
	from Parametros
	where Pcodigo = 50
	and Ecodigo = #session.ecodigo#
</cfquery>
<!--- Mes de Auxiliares --->
<cfquery name="rsMesActual" datasource="#session.dsn#">
	select Pvalor 
	from Parametros
	where Pcodigo = 60
	and Ecodigo = #session.ecodigo#
</cfquery>
<!--- Meses en Idioma Local --->
<cfquery name="rsMeses" datasource="sifcontrol">
	select VSvalor, VSdesc
	from Idiomas a
	inner join VSidioma b
	on a.Iid = b.Iid
	where Icodigo = '#session.idioma#'
	and VSgrupo = 1
	order by <cf_dbfunction name="to_number" args="VSvalor">
</cfquery>
<!--- Descripcion del Mes de Auxiliares --->
<cfquery name="rsMesDesc" dbtype="query">
	select VSdesc
	from rsMeses
	where VSvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.AVmes#">
</cfquery>
<!--- Oficinas de la Empresa --->
<cfquery name="rsOficinas" datasource="#session.DSN#">
	select Ocodigo, Odescripcion
	from Oficinas
	where Ecodigo = #session.ecodigo#
	order by Odescripcion
</cfquery>
<!--- Grupos de Empresas --->
<cfquery name="rsGE" datasource="#session.DSN#">
	select ge.GEid, ge.GEnombre
	from AnexoGEmpresa ge
		join AnexoGEmpresaDet gd
			on ge.GEid = gd.GEid
	where ge.CEcodigo = #session.CEcodigo#
	  and gd.Ecodigo = #session.ecodigo#
	order by ge.GEnombre
</cfquery>
<!--- Grupos de Oficinas  --->
<cfquery name="rsGO" datasource="#session.DSN#">
	select g.GOid, g.GOnombre
	from AnexoGOficina g
	where g.Ecodigo = #session.ecodigo#
	order by g.GOnombre
</cfquery>
<!--- Variables de la Corporacin --->
<cfquery name="rsVariables" datasource="#session.dsn#">
	select 
		case 
			when AVusar_oficina = 0
			then 'EMP'
			else 'OFI'
		end as TipoValor,
		AVid, AVnombre, rtrim(#PreserveSingleQuotes(AVdescripcion)#) AVdescripcion, AVtipo, 
		upper(AVnombre) as AVnombreUpper,
		case 
			when <cf_dbfunction name="length" args="AVdescripcion"> > 30 
			then <cf_dbfunction name="sPart" args="rtrim(#PreserveSingleQuotes(AVdescripcion)#);1;50" delimiters=";"> #_Cat# '...'
			else rtrim(#PreserveSingleQuotes(AVdescripcion)#)
		end as AVdescripcioncorta
	from AnexoVar
	where CEcodigo = #session.CEcodigo#
	order by TipoValor, upper(AVnombre)
</cfquery>
<!--- Define Comportamiento de la Pantalla --->
<cfset Lvar_formFiltrado = false>
<cfset Lvar_formAno = rsAnoActual.Pvalor>
<cfset Lvar_formMes = rsMesActual.Pvalor>
<cfset Lvar_formMesDesc = rsMesDesc.VSdesc>
<!--- 1. Identifica si el usuario realiz el filtro inicial --->
<cfif Len(form.AVid) OR form.ubicacion EQ '-1' OR ListLen(form.ubicacion) GT 1>
  <cfset Lvar_formFiltrado = true>
  <cfset Lvar_formAno = form.AVano>
  <cfset Lvar_formMes = form.AVmes>
  <!--- 2. Indentifica si se filtr por Oficina y Variable --->
  <!--- Consulta los valores de las variables --->
  
  <!---
  	combinaciones permitidas:
		- ubicacion=oficina, todas las variables AVusaroficina=0
		- ubicacion=grupo empresas, todas las variables AVusaroficina=0
		- ubicacion=grupo oficinas, todas las variables AVusaroficina=0
		- ubicacion=variables de empresa, todas las variables AVusaroficina=1
		- ubicacion=Todas, selecciona Variable
  --->
	<cfquery name="rsLista" datasource="#session.dsn#">
		select 
			av.AVnombre,
			rtrim(#PreserveSingleQuotes(AVdescripcion)#) AVdescripcion,
			av.AVvalor_anual, av.AVvalor_arrastrar,
			(select avv.AVvalor from AnexoVarValor avv
				where avv.AVid = av.AVid
				<cfif ListFirst(form.ubicacion) EQ 'of'>
				  and avv.Ecodigo = o.Ecodigo
				  and avv.Ocodigo = o.Ocodigo
				  and avv.GEid = -1
				  and avv.GOid = -1
				<cfelseif ListFirst(form.ubicacion) EQ 'ge'>
				  <!--- and avv.Ecodigo = -1 --->
				  and avv.Ocodigo = -1
				  and avv.GEid = o.GEid
				  and avv.GOid = -1
				<cfelseif ListFirst(form.ubicacion) EQ 'go'>
				  and avv.Ecodigo = o.Ecodigo
				  and avv.Ocodigo = -1
				  and avv.GEid = -1
				  and avv.GOid = o.GOid
				<cfelse><!--- vars de empresa  --->
				  and avv.Ocodigo = -1
				  and avv.GEid = -1
				  and avv.GOid = -1
				  and avv.Ecodigo = #session.Ecodigo#
				</cfif>
				  and avv.AVano = #Lvar_formAno#
				  and avv.AVmes = 
						case 
							when av.AVvalor_anual = 1 then 1
							else #Lvar_formMes#
						end
			) as AVvalor,
			av.AVusar_oficina, av.AVvalor_anual, 
			<cfif ListFirst(form.ubicacion) EQ 'ge'>
			case when av.AVusar_oficina=0 AND av.AVtipo in ('F','M') then 1 else 0 end as calcularGE,
			<cfelse>
			0 as calcularGE,
			</cfif>
			<cfif ListFirst(form.ubicacion) EQ 'go'>
			case when av.AVusar_oficina=1 AND av.AVtipo in ('F','M') then 1 else 0 end as calcularGO,
			<cfelse>
			0 as calcularGO,
			</cfif>
			av.AVtipo,
			av.AVid,
			<cfif ListFirst(form.ubicacion) EQ 'of'>
			o.Ocodigo as UbicaID,
			o.Odescripcion as UbicaNombre
			<cfelseif ListFirst(form.ubicacion) EQ 'ge'>
			o.GEid as UbicaID,
			o.GEnombre as UbicaNombre
			<cfelseif ListFirst(form.ubicacion) EQ 'go'>
			o.GOid as UbicaID,
			o.GOnombre as UbicaNombre
			<cfelse>
			-1 as UbicaID,
			'Variables de Empresa' as UbicaNombre
			</cfif>
		from AnexoVar av
			<cfif ListFirst(form.ubicacion) EQ 'of'>
			, Oficinas o
			<cfelseif ListFirst(form.ubicacion) EQ 'ge'>
			, AnexoGEmpresa o
			<cfelseif ListFirst(form.ubicacion) EQ 'go'>
			, AnexoGOficina o
			</cfif>
		where av.CEcodigo = #session.CEcodigo#
		  <cfif ListFind('of,go', ListFirst(form.ubicacion))>
		  and o.Ecodigo = #session.Ecodigo#
		  </cfif>
		<cfif Len(form.AVid)>
		  and av.AVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AVid#">
		</cfif>
		<cfif isdefined('form.Ocodigo') and Len(trim(form.Ocodigo))>
		  and o.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
		<cfelseif Len(form.GEid)>
		  and o.GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEid#">
		<cfelseif Len(form.GOid)>
		  and o.GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GOid#">
		</cfif>
		<cfif ListFirst(form.ubicacion) EQ 'of'>
		  and av.AVusar_oficina = 1
		<cfelseif ListFirst(form.ubicacion) EQ 'go'>
		  and av.AVusar_oficina = 1
		<cfelseif ListFirst(form.ubicacion) EQ 'ge'>
		  and av.AVusar_oficina = 0
		<cfelse>
		  and av.AVusar_oficina = 0
		</cfif>
		order by av.AVnombre
			<cfif ListFind('of,ge,go', ListFirst(form.ubicacion))>
				, UbicaNombre
			</cfif>
	</cfquery>
</cfif>

<cfoutput>
  <form action="" method="post" name="form1" >
    <table width="100%" border="0" cellspacing="2" cellpadding="2" class="AreaFiltro">
      <tr>
        <td nowrap><strong>#LB_Mes#: </strong></td>
        <td nowrap><select name="AVmes">
            <cfloop query="rsMeses">
              <option value="#Trim(VSvalor)#" 
					<cfif (not isdefined("Lvar_formMes") and rsMeses.VSvalor eq rsMesActual.Pvalor) or (isdefined("Lvar_formMes") and rsMeses.VSvalor eq Lvar_formMes)>
						selected
					</cfif>
				>#Trim(VSdesc)#</option>
            </cfloop>
          </select>
        </td>
        <td nowrap><select name="AVano">
            <cfloop from="#rsAnoActual.Pvalor-3#" to="#rsAnoActual.Pvalor+3#" index="value">
              <option value="#value#" 
						<cfif (not isdefined("Lvar_formAno") and value eq rsAnoActual.Pvalor) or (isdefined("Lvar_formAno") and value eq Lvar_formAno)>
							selected
						</cfif>
				>#value#</option>
            </cfloop>
          </select>
        </td>
        <td nowrap><strong>#LB_Ubicacion#: </strong></td>
        <td nowrap><select name="ubicacion" onChange="onchange_ocodigo(this)">
            <option value="-1" <cfif -1 eq form.Ocodigo> selected</cfif>> - #LB_VariablesEmpresa# - </option>
            <cfif rsGE.RecordCount>
              <optgroup label="Grupos de Empresas">
              <option value="ge," <cfif form.ubicacion eq 'ge,'>selected</cfif> >(#LB_GruposEmpresas#)</option>
              <cfloop query="rsGE">
                <option value="ge,#rsGE.GEid#" <cfif rsGE.GEid EQ form.GEid> selected</cfif>> #rsGE.GEnombre#</option>
              </cfloop>
              </optgroup>
            </cfif>
            <cfif rsGO.RecordCount>
              <optgroup label="Grupos de Oficinas">
              <option value="go," <cfif form.ubicacion eq 'go,'>selected</cfif> >(#LB_GruposOficinas#)</option>
              <cfloop query="rsGO">
                <option value="go,#rsGO.GOid#" <cfif rsGO.GOid EQ form.GOid> selected</cfif>> #rsGO.GOnombre#</option>
              </cfloop>
              </optgroup>
            </cfif>
            <optgroup label="Oficinas">
            <option value="of," <cfif form.ubicacion eq 'of,'>selected</cfif> >(#LB_Oficinas#)</option>
            <cfloop query="rsOficinas">
              <option value="of,#rsOficinas.Ocodigo#" <cfif rsOficinas.Ocodigo EQ form.Ocodigo> selected</cfif>> #rsOficinas.Odescripcion#</option>
            </cfloop>
            </optgroup>
          </select>
        </td>
        <td nowrap id="td_var1" style="visibility:<cfif form.Ocodigo NEQ -1>visible<cfelse>hidden</cfif>;"><strong>Variable: </strong></td>
        <td nowrap id="td_var2" style="visibility:<cfif form.Ocodigo NEQ -1>visible<cfelse>hidden</cfif>;">
</cfoutput>
			<select name="AVid">
	            <option value="" >- <cfoutput>#LB_Seleccion# </cfoutput>-</option>
				<cfset LvarIdxPorOficina = 1000>
				<cfoutput query="rsVariables" group="TipoValor">
					<cfif rsVariables.TipoValor EQ "EMP">
						<optgroup label="Valores Empresariales" id="AVidVE" <cfif ListFind('of,go', ListFirst(form.ubicacion))> disabled</cfif>>
						<cfset LvarTT = "(E)">
					<cfelse>
						<optgroup label="Valores por Oficina" id="AVidVO" <cfif NOT ListFind('of,go', ListFirst(form.ubicacion))> disabled</cfif>>
						<cfset LvarTT = "(0)">
					</cfif>
					<cfoutput>
							<cfif rsVariables.TipoValor NEQ "EMP" AND LvarIdxPorOficina EQ 1000>
								<cfset LvarIdxPorOficina = rsVariables.currentRow>
							</cfif>
							<option value="#rsVariables.AVid#" 
								<cfif rsVariables.AVid EQ form.AVid>
									selected
								</cfif>
							>#rsVariables.AVnombre# - #rsVariables.AVdescripcioncorta# #rsVariables.currentRow#</option>
					</cfoutput>
					</optgroup>
				</cfoutput>
        	</select>
<cfoutput>
        </td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
        <td nowrap>
		<input type="submit" name="btnFiltrar" value="#BTN_Filtrar#">
		<input type="button" name="btnListado" value="#BTN_Lista#" onclick="funcListado(this.form);">
		</td>
      </tr>
    </table>
  </form>
  <cf_qforms>
  <script language="javascript" type="text/javascript">
<!--//
	objForm.AVano.description = "#JSStringFormat('Año')#";
	objForm.AVmes.description = "#JSStringFormat('Mes')#";
	objForm.ubicacion.description = "#JSStringFormat('Ubicación')#";
	objForm.AVid.description = "#JSStringFormat('Variable')#";
	function habilitarValidacion(){
		objForm.AVano.required = true;
		objForm.AVmes.required = true;
		objForm.ubicacion.validateExp("_validateOfiVar()",
			"Se requiere que seleccione o bien una ubicación específica o una variable.");
	}
	function desahabilitarValidacion(){
		objForm.AVano.required = false;
		objForm.AVmes.required = false;
		objForm.ubicacion.validateExp("");
	}
	function _validateOfiVar(){
		if (  (objForm.ubicacion.getValue().match(/^..,$/) )
			  &&
			  (objForm.AVid.getValue() == '')
			)
		{
			<!---
				error si:
				ubicacion es '**,' y AVid es ''
			--->
			return true;
		}		
		return false;
	}
	function onchange_ocodigo(t){
		var x = t.value.split(",");

		if (x[0] == 'of' || x[0] == 'go')
		{
			if (document.getElementById("AVid").selectedIndex != 0 && document.getElementById("AVid").selectedIndex < #LvarIdxPorOficina#)
				document.getElementById("AVid").selectedIndex = 0;
			document.getElementById("AVidVE").disabled = true;
			document.getElementById("AVidVO").disabled = false;
		}
		else
		{
			if (document.getElementById("AVid").selectedIndex != 0 && document.getElementById("AVid").selectedIndex >= #LvarIdxPorOficina#)
				document.getElementById("AVid").selectedIndex = 0;
			document.getElementById("AVidVE").disabled = false;
			document.getElementById("AVidVO").disabled = true;
		}
	}
	function funcListado(f){
		location.href='listado.cfr?AVmes='
			+ escape(f.AVmes.value) + '&AVano=' + f.AVano.value;
	}
	habilitarValidacion();
	objForm.AVmes.obj.focus();
//-->
</script>
  <cfif not Lvar_formFiltrado>
    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td align="center" class="TituloListas">
		<br>
		<br>
		#LB_Mensaje#
		<br>
		<br>
		<br>
		</td>
      </tr>
    </table>
    <cfelse>
    <form action="sql.cfm" method="post" name="form2">
      <input type="hidden" name="AVano" value="#Lvar_formAno#">
      <input type="hidden" name="AVmes" value="#Lvar_formMes#">
      <input type="hidden" name="AVid" value="#HTMLEditFormat(form.AVid)#">
	  <input type="hidden" name="ubicacion" value="#HTMLEditFormat(form.ubicacion)#">
      <table width="1%" align="center"  border="0" cellspacing="0" cellpadding="2">
        <cfif Len(form.AVid) EQ 0>
          <tr>
            <td colspan="2" align="center" class="TituloListas"><strong>
			<cfif Len(ListRest(form.ubicacion))>#TituloUbicacion#:
			#rsLista.UbicaNombre#
			<cfelse>Por #TituloUbicacion#
			</cfif></strong></td>
          </tr>
          <cfelse>
          <tr>
            <td colspan="2" align="center" class="TituloListas"><strong>Variable: #rsLista.AVnombre#</strong></td>
          </tr>
          <tr>
            <td colspan="2" align="center" class="TituloListas">#rsLista.AVdescripcion# </td>
          </tr>
        </cfif>
        <tr>
  		<cfif rsLista.AVvalor_anual EQ "1">
			<td colspan="2" align="center" class="TituloListas"><strong>#LB_ValorAnual#: #Lvar_formAno#</strong></td>
		<cfelse>
			<td colspan="2" align="center" class="TituloListas"><strong>#LB_Mes#: #Lvar_formMesDesc#, #Lvar_formAno#</strong></td>
		</cfif>
        </tr>
        <tr>
          <td nowrap class="TituloCorte"><strong>
            <cfif Len(form.AVid) EQ 0>
              Variable
              <cfelse>
              #TituloUbicacion#
            </cfif>
            </strong></td>
          <td nowrap class="TituloCorte"><strong>#LB_Valor#</strong></td>
        </tr>
		<cfset LvarCalcularValores = false>
        <cfloop query="rsLista">
          <cfset LvarListaNon = (CurrentRow MOD 2)>
          <tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onMouseOver="this.className='listaParSel';" onMouseOut="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
            <td nowrap><strong>
              <cfif Len(form.AVid) EQ 0>
                #HTMLEditFormat(rsLista.AVnombre)#:
                <cfelse>
                #HTMLEditFormat(rsLista.UbicaNombre)#:
              </cfif>
              </strong></td>
			<td nowrap>
				<cfset input_name = "valor_" & rsLista.AVid & "_" & rsLista.UbicaID>
				<cfset input_value = rsLista.AVvalor>
				<cfset input_valueArrastrado = "">
				<cfset valorArrastrado = false>
				<cfif Len(rsLista.AVid) AND rsLista.AVvalor_arrastrar EQ "1">
					<!--- 
						Si es arrastrable busca el ultimo valor registrado 
					--->
					<cfquery name="rsSQL" datasource="#session.dsn#">
						select max(avv.AVano*100+avv.AVmes) as ultimo
						  from AnexoVarValor avv
						 where avv.AVid = #rsLista.AVid#
						<cfif ListFirst(form.ubicacion) EQ 'of'>
						   and avv.Ecodigo = #session.Ecodigo#
						   and avv.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.UbicaID#">
						   and avv.GEid = -1
						   and avv.GOid = -1
						<cfelseif ListFirst(form.ubicacion) EQ 'ge'>
						   <!--- and avv.Ecodigo = -1 --->
						   and avv.Ocodigo = -1
						   and avv.GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.UbicaID#">
						   and avv.GOid = -1
						<cfelseif ListFirst(form.ubicacion) EQ 'go'>
						   and avv.Ecodigo = #session.Ecodigo#
						   and avv.Ocodigo = -1
						   and avv.GEid = -1
						   and avv.GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.UbicaID#">
						<cfelse>
						   and avv.Ocodigo = -1
						   and avv.GEid = -1
						   and avv.GOid = -1
						   and avv.Ecodigo = #session.Ecodigo#
						</cfif>
						   and (	avv.AVano = #Lvar_formAno#
								and avv.AVmes < #Lvar_formMes#
								 OR avv.AVano < #Lvar_formAno#
								)
					</cfquery>

					<cfif rsSQL.ultimo NEQ "">
						<cfset Lvar_UltimoAno = int(rsSQL.ultimo / 100)>
						<cfset Lvar_UltimoMes = int(rsSQL.ultimo mod 100)>
						<cfquery name="rsSQL" datasource="#session.dsn#">
							select avv.AVvalor from AnexoVarValor avv
							 where avv.AVid = #rsLista.AVid#
							<cfif ListFirst(form.ubicacion) EQ 'of'>
							   and avv.Ecodigo = #session.Ecodigo#
							   and avv.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.UbicaID#">
							   and avv.GEid = -1
							   and avv.GOid = -1
							<cfelseif ListFirst(form.ubicacion) EQ 'ge'>
							   <!--- and avv.Ecodigo = -1 --->
							   and avv.Ocodigo = -1
							   and avv.GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.UbicaID#">
							   and avv.GOid = -1
							<cfelseif ListFirst(form.ubicacion) EQ 'go'>
							   and avv.Ecodigo = #session.Ecodigo#
							   and avv.Ocodigo = -1
							   and avv.GEid = -1
							   and avv.GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.UbicaID#">
							<cfelse><!--- vars de empresa  --->
							   and avv.Ocodigo = -1
							   and avv.GEid = -1
							   and avv.GOid = -1
							   and avv.Ecodigo = #session.Ecodigo#
							</cfif>
							  and avv.AVano = #Lvar_UltimoAno#
							  and avv.AVmes = #Lvar_UltimoMes#
						</cfquery>
						<cfset input_valueArrastrado = rsSQL.AVvalor>
					</cfif>
					<!--- 
						Si no existe valor registrado en el mes, asigna el valor arrastrado
					--->
					<cfif input_value EQ "" AND input_valueArrastrado NEQ "">
						<cfset input_value = input_valueArrastrado>
						<cfset valorArrastrado = true>
					</cfif>
				</cfif>
				<input type="hidden" name="campos" value="#rsLista.AVid#_#rsLista.UbicaID#">
				<cfif rsLista.AVtipo eq 'M'>
					<cfif len(trim(input_value)) and IsNumeric(input_value)>
					  <cf_monto name="#input_name#" value="#input_value#" size="40" negativos="true">
					  <cfelse>
					  <cf_monto name="#input_name#" size="40" negativos="true">
					</cfif>
                <cfelseif rsLista.AVtipo eq 'F'>
					<cfif len(trim(input_value)) and IsNumeric(input_value)>
					  <cf_monto name="#input_name#" value="#input_value#" decimales="10" size="40" negativos="true">
					  <cfelse>
					  <cf_monto name="#input_name#" decimales="10" size="40" negativos="true">
					</cfif>
                <cfelse>
	                <input type="text" name="#input_name#" value="#HTMLEditFormat(input_value)#" maxlength="255" size="40" onFocus="this.select()">
				</cfif>
			</td>
			<td nowrap="nowrap">
			<cfif rsLista.calcularGE EQ 1>
				<cfset LvarCalcularValores = true>
				<img 	src="/cfmx/sif/imagenes/w-max.gif" 
						style="cursor:pointer; background-color:inherit;" 
						title="Calcular valor"
						onclick="if (confirm('¿Desea calcular el valor?')) sbCalcularValorGE(#rsLista.UbicaID#,#rsLista.AVid#);"
				/>
			</cfif>
			<cfif rsLista.calcularGO EQ 1>
				<cfset LvarCalcularValores = true>
				<img 	src="/cfmx/sif/imagenes/w-max.gif" 
						style="cursor:pointer; background-color:inherit;" 
						title="Calcular valor"
						onclick="if (confirm('¿Desea calcular el valor?')) sbCalcularValorGO(#rsLista.UbicaID#,#rsLista.AVid#);"
				/>
			</cfif>
		<cfif Len(rsLista.AVid) AND rsLista.AVvalor_arrastrar EQ "1">
			<cfif valorArrastrado>
				<img 	src="/cfmx/sif/imagenes/checked.gif" 
						style="background-color:inherit;" 
						title="Se arrastró el último valor anterior registrado"
				/>
			<cfelseif input_valueArrastrado EQ "">
				<img 	src="/cfmx/sif/imagenes/checked_none.gif" 
						style="background-color:inherit;" 
						title="No se encontró ningún valor registrado anteriormente"
				/>
			<cfelse>
				<img 	src="/cfmx/sif/imagenes/refresh.gif" 
						style="cursor:pointer; background-color:inherit;" 
						title="Forzar arrastre de último valor anterior registrado"

						onclick="
							if (document.form2.#input_name#.value == '#input_valueArrastrado#')
								alert('El valor es el último registrado');
							else if (confirm('¿Desea asignar el último valor anterior registrado?'))
							{
								document.form2.#input_name#.value = '#input_valueArrastrado#';
								alert('Debe presionar <Guardar> para almacenar los cambios');
							}
						"
				/>
			</cfif>
		</cfif>
			</td>
			<td>
			<cfif rsLista.AVvalor_anual EQ 1>
				Valor Anual
			</cfif>
			</td>
          </tr>
          <cfif Len(form.AVid) EQ 0
		  	 And Len(Trim(rsLista.AVdescripcion))>
			 
            <tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onMouseOver="this.className='listaParSel';" onMouseOut="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
              <td colspan="2">#HTMLEditFormat(rsLista.AVdescripcion)# </td>
            </tr>
          </cfif>
        </cfloop>
      </table>
      <br>
		<cfif LvarCalcularValores>
			<cf_botones values="Guardar,Limpiar,Calcular_Valores">
		<cfelse>
			<cf_botones values="Guardar,Limpiar">
		</cfif>
    </form>
    <cf_qforms objForm="objForm2" form="form2">
    <script language="javascript" type="text/javascript">
	function funcLimpiar(){
		/*deshabilitarValidacion();*/
		objForm2.obj.reset();
		return false;
	}
	function sbCalcularValorGE(geid,avid)
	{
		location.href = "sql.cfm?CVGE&AVano=#form.AVano#&AVmes=#form.AVmes#&U=#form.ubicacion#&V=#form.AVid#&GEid=" + geid + "&AVid=" + avid;
	}
	function sbCalcularValorGO(goid,avid)
	{
		location.href = "sql.cfm?CVGO&AVano=#form.AVano#&AVmes=#form.AVmes#&U=#form.ubicacion#&V=#form.AVid#&GOid=" + goid + "&AVid=" + avid;
	}
//-->
</script>
  </cfif>
</cfoutput>
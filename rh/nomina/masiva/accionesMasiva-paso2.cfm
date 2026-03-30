<!----===================== TRADUCCION ====================----->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Esta_seguro_de_que_desea_eliminar_este_componente_salarial"
	Default="Está seguro de que desea eliminar este componente salarial?"	
	returnvariable="MSG_Esta_seguro_de_que_desea_eliminar_este_componente_salarial"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Componente_Salarial"
	Default="Componente Salarial"	
	returnvariable="LB_Componente_Salarial"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Accion"
	Default="Acci&oacute;n"	
	returnvariable="LB_Accion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Negativo"
	Default="Negativo"	
	returnvariable="LB_Negativo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Puntos"
	Default="Puntos"	
	returnvariable="LB_Puntos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_No_se_han_registrado_cambios_en_componentes_salariales"
	Default="MSG_No_se_han_registrado_cambios_en_componentes_salariales"
	returnvariable="MSG_No_se_han_registrado_cambios_en_componentes_salariales"/>
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

	
<!--- Si se modifican componentes --->
<cfif isdefined("rsDatosAccion") and rsDatosAccion.RHTAccomp EQ 1>

	<cfquery name="comboComponentes" datasource="#Session.DSN#">
		select 	a.RHTCAMid, a.CSid, a.RHTCAMagregam, a.RHTCAMelimina, 
				{fn concat(b.CScodigo,{fn concat(' - ',b.CSdescripcion)})} as CSdescripcion
		from RHComponentesTAccionM a
			inner join ComponentesSalariales b
				on a.CSid = b.CSid
				and a.Ecodigo = b.Ecodigo
		where a.RHTAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosAccion.RHTAid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by b.CScodigo, b.CSdescripcion
	</cfquery>

	<script src="/cfmx/rh/js/utilesMonto.js"></script>
	
	<script language="javascript" type="text/javascript">
		var k = new Object();
		<cfoutput query="comboComponentes">
			k['#CSid#'] = '#RHTCAMagregam#';
		</cfoutput>
		
		function showAction(id) {
			var a = document.getElementById("tdAccion1");
			var b = document.getElementById("tdAccion2");
			document.form1.tipoaccion.value = k[id];
			if (k[id] == '1') {
				if (a) a.style.display = '';
				if (b) b.style.display = 'none';
				document.form1.negativo.disabled = false;
				document.form1.puntos.disabled = false;
			} else {
				if (a) a.style.display = 'none';
				if (b) b.style.display = '';
				document.form1.negativo.disabled = true;
				document.form1.puntos.disabled = true;
			}
		}
		
		function eliminarComp(id) {
			<cfoutput>
			if (confirm('#MSG_Esta_seguro_de_que_desea_eliminar_este_componente_salarial#')) {
				document.form1.RHCAMid_del.value = id;
				document.form1.submit();
			}
			</cfoutput>
			return false;
		}
	</script>
	
	<cfoutput>
	<form name="form1" method="post" style="margin: 0;" action="accionesMasiva-sql.cfm" onsubmit="javascript: return validar();">
		<cfinclude template="accionesMasiva-hiddens.cfm">
		<input type="hidden" name="tipoaccion" value="" />
		<input type="hidden" name="RHCAMid_del" value="" />
		<table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
		  <tr>
			<td class="tituloListas" width="28%" height="22">#LB_Componente_Salarial#</td>
			<td class="tituloListas" width="34%">#LB_Accion#</td>
			<td class="tituloListas" width="12%" align="right">#LB_Negativo#</td>
			<td class="tituloListas" width="16%" align="right">#LB_Puntos#</td>
			<td class="tituloListas" width="10%">&nbsp;</td>
		  </tr>
		  <tr>
			<td height="22">
				<select name="CSid" onchange="javascript: showAction(this.value); ">
					<cfloop query="comboComponentes">
						<option value="#comboComponentes.CSid#">#comboComponentes.CSdescripcion#</option>
					</cfloop>
				</select>
			</td>
			<td>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td id="tdAccion1" style="display: none;">
							<select name="accion">
								<option value="1"><cf_translate key="LB_Agregar_Componente">Agregar Componente</cf_translate></option>
								<option value="2"><cf_translate key="LB_Modificar_Sumando/Restando_al_Componente">Modificar Sumando/Restando al Componente</cf_translate></option>
								<option value="3"><cf_translate key="LB_Modifica_Sustituyendo_en_el_Componente">Modificar Sustituyendo en el Componente</cf_translate></option>
							</select>
						</td>
						<td id="tdAccion2" style="display: none;">
							<cf_translate key="LB_Eliminar_Componente">Eliminar Componente</cf_translate>
						</td>
					</tr>
				</table>
			</td>
			<td align="right">
				<input type="checkbox" name="negativo" value="1"/>
			</td>
			<td align="right">
				<input type="text" name="puntos" size="18" maxlength="15"  onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="0.00">
			</td>
			<td align="right">
				<input type="submit" name="btnAgregar" value="#BTN_Agregar#">
			</td>
		  </tr>
		</table>
	</form>

	<table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
	  <tr>
	  	<td>
		<cfquery name="rsLista" datasource="#session.DSN#">
		 	select a.RHCAMid, b.CSid, 
					{fn concat(b.CScodigo,{fn concat(' - ',b.CSdescripcion)})} as CSdescripcion,
				   case 
						when a.RHCAMtagregar = 1 then 'Agregar Componente'
						when a.RHCAMtmodificar = 1 and a.RHCAMmodificars = 0 then 'Modificar Sumando/Restando al Componente'
						when a.RHCAMtmodificar = 1 and a.RHCAMmodificars = 1 then 'Modificar Sustituyendo en el Componente'
						when a.RHCAMteliminar = 1 then 'Eliminar Componente'
						else '&nbsp;'
				   end as accion,
				   case 
						when a.RHCAMtagregar = 1 and a.RHCAMvagregar >= 0 then '<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>'
						when a.RHCAMtagregar = 1 and a.RHCAMvagregar < 0 then '<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>'
						when a.RHCAMtmodificar = 1 and a.RHCAMvmodificar >= 0 then '<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>'
						when a.RHCAMtmodificar = 1 and a.RHCAMvmodificar < 0 then '<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>'
						else '&nbsp;'
				   end as negativo,
				   case 
						when a.RHCAMtagregar = 1 then abs(a.RHCAMvagregar)
						when a.RHCAMtmodificar = 1 then abs(a.RHCAMvmodificar)
						else 0.00
				   end as puntos,
				   {fn concat({fn concat({fn concat('<img border=''0'' src=''/cfmx/rh/imagenes/Borrar01_S.gif'' onClick="javascript:return eliminarComp(', '''')}, <cf_dbfunction name="to_char" args="a.RHCAMid"> )}, ''');">') } as borrar
			from RHComponentesAccionM a
				inner join ComponentesSalariales b
					on b.Ecodigo = a.Ecodigo
					and b.CSid = a.CSid
			where a.RHAid = #rsDatosAccion.RHAid#
					and a.Ecodigo = #Session.Ecodigo#
					order by b.CScodigo, b.CSdescripcion
		</cfquery>
		<cfinvoke 
			component="rh.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="CSdescripcion, accion, negativo, puntos, borrar"/>
				<cfinvokeargument name="etiquetas" value="#LB_Componente_Salarial#, #LB_Accion#, #LB_Negativo#, #LB_Puntos#, &nbsp;"/>
				<cfinvokeargument name="formatos" value="S,S,S,M,S"/>
				<cfinvokeargument name="align" value="left,left,center,right,center"/>
				<cfinvokeargument name="ajustar" value="S,S,S,S,S"/>
				<cfinvokeargument name="checkboxes" value="N"/>				
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="RHCAMid"/>
				<cfinvokeargument name="ira" value="#CurrentPage#"/>
				<cfinvokeargument name="emptylistmsg" value=" --- #MSG_No_se_han_registrado_cambios_en_componentes_salariales# ---"/>
				<cfinvokeargument name="maxrows" value="0"/>
		</cfinvoke>
		<!-----
		<cfinvoke 
			component="rh.Componentes.pListas" 
			method="pListaRH" 
			returnvariable="Lvar_Lista" 
			columnas=" 	a.RHCAMid, b.CSid, 
						{fn concat(b.CScodigo,{fn concat(' - ',b.CSdescripcion)})} as CSdescripcion,
					   case 
							when a.RHCAMtagregar = 1 then 'Agregar Componente'
							when a.RHCAMtmodificar = 1 and a.RHCAMmodificars = 0 then 'Modificar Sumando/Restando al Componente'
							when a.RHCAMtmodificar = 1 and a.RHCAMmodificars = 1 then 'Modificar Sustituyendo en el Componente'
							when a.RHCAMteliminar = 1 then 'Eliminar Componente'
							else '&nbsp;'
					   end as accion,
					   case 
							when a.RHCAMtagregar = 1 and a.RHCAMvagregar >= 0 then '<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>'
							when a.RHCAMtagregar = 1 and a.RHCAMvagregar < 0 then '<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>'
							when a.RHCAMtmodificar = 1 and a.RHCAMvmodificar >= 0 then '<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif''>'
							when a.RHCAMtmodificar = 1 and a.RHCAMvmodificar < 0 then '<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''>'
							else '&nbsp;'
					   end as negativo,
					   case 
							when a.RHCAMtagregar = 1 then abs(a.RHCAMvagregar)
							when a.RHCAMtmodificar = 1 then abs(a.RHCAMvmodificar)
							else 0.00
					   end as puntos,
					  '#vAnlo#' as borrar
					   <!----'<a href=''##'' onclick=''javascript: return eliminarComp(""' || convert(varchar, a.RHCAMid) || '"");''><img border=''0'' src=''/cfmx/rh/imagenes/Borrar01_S.gif''></a>' as borrar"---->
			tabla=" RHComponentesAccionM a
					inner join ComponentesSalariales b
						on b.Ecodigo = a.Ecodigo
						and b.CSid = a.CSid"
			filtro="a.RHAid = #rsDatosAccion.RHAid#
					and a.Ecodigo = #Session.Ecodigo#
					order by b.CScodigo, b.CSdescripcion"
			desplegar="CSdescripcion, accion, negativo, puntos, borrar"
			etiquetas="#LB_Componente_Salarial#, #LB_Accion#, #LB_Negativo#, #LB_Puntos#, &nbsp;"
			maxrows="0"
			formatos="S,S,S,M,S"
			align="left,left,center,right,center"
			ajustar="S,S,S,S,S"
			showemptylistmsg="true"
			emptylistmsg=" --- No se han registrado cambios en componentes salariales --- "
			ira="#CurrentPage#"
			showLink="false"
			checkboxes="N"
			keys="RHCAMid" />
			----->
		</td>
	  </tr>
	</table>

	<table width="90%" border="0" cellspacing="0" cellpadding="2" align="center">
		  <tr>
			<td colspan="4">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="4">
				<form name="form2" action="#CurrentPage#" method="post" style="margin: 0;">
					<cfinclude template="accionesMasiva-hiddens.cfm">
					<cf_botones names="Anterior,Siguiente" values="<< #BTN_Anterior#,#BTN_Siguiente# >>">
				</form>
			</td>
		  </tr>
		  <tr>
			<td colspan="4">&nbsp;</td>
		  </tr>
	</table>
	</cfoutput>
	
	<script language="javascript" type="text/javascript">
		showAction(document.form1.CSid.value);
	</script>
<cfelse>

	<table width="90%" border="0" cellspacing="0" cellpadding="2" align="center">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center" style="color:#FF0000; font-size:14px; " class="fileLabel">-- <cf_translate key="LB_El_Tipo_de_Accion_Masiva_no_permite_Modificar_Componentes_Salariales">El Tipo de Acci&oacute;n Masiva no permite Modificar Componentes Salariales </cf_translate>--</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>		
		<tr>
			<td>
				<form name="form2" action="#CurrentPage#" method="post" style="margin: 0;">
					<cfinclude template="accionesMasiva-hiddens.cfm">
					<cf_botones names="Anterior,Siguiente" values="<< #BTN_Anterior#,#BTN_Siguiente# >>">
				</form>			
			</td>
		</tr>		
		<tr><td>&nbsp;</td></tr>		
	</table>
</cfif>

<script language="javascript" type="text/javascript">
	function funcAnterior() {
		document.form2.paso.value = "1";
	}
	
	function funcSiguiente() {
		document.form2.paso.value = "3";
	}
	
	function validar() {
		document.form1.puntos.value = qf(document.form1.puntos.value);
		return true;
	}
</script>
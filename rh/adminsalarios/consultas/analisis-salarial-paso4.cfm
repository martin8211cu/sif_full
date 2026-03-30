<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_Oficina" Default="Oficina" returnvariable="LB_Oficina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Departamento" Default="Departamento" returnvariable="LB_Departamento" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="MSG_DeseaEliminarLosRegistrosSeleccionados" Default="Desea eliminar los registros seleccionados?" returnvariable="MSG_DeseaEliminarLosRegistrosSeleccionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" Default="Debe seleccionar al menos un registro para relizar esta acción."	 returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<!--- 
	Averiguar el tipo por defecto de las unidades de negocio
	Por Defecto el Tipo de Unidad de Negocio es por Centro Funcional
--->
<cfquery name="rsTipoCF" datasource="#Session.DSN#">
	select count(1) as cantidad
	from RHASalarialUbicaciones
	where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
	and CFid is not null
</cfquery>
<cfset ExisteUbicXCF = rsTipoCF.cantidad>		<!--- Variable para indicar si ya existen unidades de negocio por Centro Funcional guardadas --->

<cfquery name="rsTipoOD" datasource="#Session.DSN#">
	select count(1) as cantidad
	from RHASalarialUbicaciones
	where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
	and Ocodigo is not null
	and Dcodigo is not null
</cfquery>
<cfset ExisteUbicXOD = rsTipoOD.cantidad>		<!--- Variable para indicar si ya existen unidades de negocio por Oficina/Depto guardadas --->

<cfif ExisteUbicXCF>
	<cfset TipoUbicacion = 1>	<!--- Unidades de Negocio por Centro Funcional --->
<cfelseif ExisteUbicXOD>
	<cfset TipoUbicacion = 2>	<!--- Unidades de Negocio por Oficina / Departamento --->
<cfelse>
	<cfset TipoUbicacion = 3>	<!--- Unidades de Negocio por Definir --->
</cfif>

<cfif ExisteUbicXCF>
	<cfquery name="rsLista" datasource="#Session.DSN#">
		select a.RHASid, a.CFid, rtrim(b.CFcodigo) as CFcodigo, b.CFdescripcion, a.RHASUdependecias
		from RHASalarialUbicaciones a
			inner join CFuncional b
				on b.CFid = a.CFid
		where a.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
		order by b.CFcodigo, b.CFdescripcion
	</cfquery>
<cfelseif ExisteUbicXOD>
	<cfquery name="rsLista" datasource="#Session.DSN#">
		select a.RHASid, b.Ocodigo, rtrim(b.Oficodigo) as Oficodigo, b.Odescripcion, c.Dcodigo, 
			rtrim(b.Oficodigo)|| ' - ' || b.Odescripcion as Oficina,
			rtrim(c.Deptocodigo)|| ' - ' || c.Ddescripcion as Depto,
			rtrim(c.Deptocodigo) as Deptocodigo, c.Ddescripcion, a.RHASUdependecias
		from RHASalarialUbicaciones a
			inner join Oficinas b
				on b.Ecodigo = a.Ecodigo
				and b.Ocodigo = a.Ocodigo
			inner join Departamentos c
				on c.Ecodigo = a.Ecodigo
				and c.Dcodigo = a.Dcodigo
		where a.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
		order by b.Ocodigo, b.Odescripcion, c.Dcodigo, c.Ddescripcion
	</cfquery>
</cfif>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, substring(rtrim(Oficodigo) || ' - ' || Odescripcion,1,25) as OficinaDesc,rtrim(Oficodigo) || ' - ' || Odescripcion,1,25 as DescL
	from Oficinas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Oficodigo
</cfquery>

<cfquery name="rsDepartamentos" datasource="#Session.DSN#">
	select Dcodigo, substring(rtrim(Deptocodigo) || ' - ' || Ddescripcion,1,30) as DeptoDesc, rtrim(Deptocodigo) || ' - ' || Ddescripcion as DescL
	from Departamentos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Deptocodigo
</cfquery>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	<cfif ExisteUbicXCF>
		function Eliminar(c, v) {
			if (confirm("Esta seguro de que desea eliminar el centro funcional " + v + " de este reporte?")) {
				document.listaUbicaciones.CFid_Del.value = c;
				document.listaUbicaciones.submit();
			}
		}
	<cfelseif ExisteUbicXOD>
		function Eliminar(c1, c2, v1, v2) {
			if (confirm("Esta seguro de que desea eliminar la oficina " + v1 + " y departamento " + v2 + " de este reporte?")) {
				document.listaUbicaciones.Ocodigo_Del.value = c1;
				document.listaUbicaciones.Dcodigo_Del.value = c2;
				document.listaUbicaciones.submit();
			}
		}
	</cfif>

	function changeUbicacion(f) {
		var a = document.getElementById("trCFuncional");
		var b = document.getElementById("trOficDepto");
		if (f.rdTipo[0].checked) {
			if (a) a.style.display = '';
			if (b) b.style.display = 'none';
			objForm.CFcodigo.required = true;
			objForm.Ocodigo.required = false;
			objForm.Dcodigo.required = false;
		} else if (f.rdTipo[1].checked) {
			if (a) a.style.display = 'none';
			if (b) b.style.display = '';
			objForm.CFcodigo.required = false;
			objForm.Ocodigo.required = true;
			objForm.Dcodigo.required = true;
		}
	}
</script>

<cfoutput>
	<form name="form1" method="post" action="analisis-salarial-sql.cfm" style="margin: 0;">
		<cfinclude template="analisis-salarial-hiddens.cfm">
		<table border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td colspan="2">
					<input name="rdTipo" type="radio" value="1" onClick="javascript: changeUbicacion(this.form);"<cfif TipoUbicacion EQ 1> checked<cfelseif TipoUbicacion EQ 3> checked<cfelse> disabled</cfif>><strong>CENTRO FUNCIONAL</strong>
				</td>
				<td colspan="3">
					<input name="rdTipo" type="radio" value="2" onClick="javascript: changeUbicacion(this.form);"<cfif TipoUbicacion EQ 2> checked<cfelseif TipoUbicacion NEQ 3> disabled</cfif>>
					<strong>OFICINA/DEPARTAMENTO</strong>
				</td>
			</tr>
			<tr id="trCFuncional" height="25">
				<td align="right" class="fileLabel" nowrap="nowrap"><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</td>
				<td><cf_rhcfuncional size="25"></td>
				<td nowrap="nowrap">
					<input name="chkDependencias" type="checkbox" id="chkDependencias" value="1">
					<strong><cf_translate key="LB_IncluirDependencias">Incluir dependencias</cf_translate></strong>
				</td>
				<td align="right" colspan="2">
					<input type="submit" name="btnAgregarCF"  value="Agregar" class="btnGuardar">
				</td>
		  	</tr>
			<tr id="trOficDepto" style="display: none;" height="25">
				<td align="right" class="fileLabel"><cf_translate key="LB_Oficina">Oficina</cf_translate>:&nbsp;</td>
				<td>
					<select name="Ocodigo" style="size:175px">
					<cfloop query="rsOficinas">
						<option value="#rsOficinas.Ocodigo#" title="#rsOficinas.DescL#">#rsOficinas.OficinaDesc#</option>
					</cfloop>
					</select>
				</td>
				<td align="right" class="fileLabel"><cf_translate key="LB_Departamento">Departamento</cf_translate>:&nbsp;</td>
				<td>
					<select name="Dcodigo" style="size:175px">
					<cfloop query="rsDepartamentos">
						<option value="#rsDepartamentos.Dcodigo#" title="#rsDepartamentos.DescL#">#rsDepartamentos.DeptoDesc#</option>
					</cfloop>
					</select>
				</td>
				<td align="center">
					<input type="submit" name="btnAgregarOD"  value="Agregar">
				</td>
		  	</tr>
<!--- 			<tr>
				<td>&nbsp;</td>
				<td colspan="4" align="center">
					<table  border="0" cellspacing="0" cellpadding="5" align="center">
					  <tr>
						<td align="right" nowrap>
							<input name="rdTipo" type="radio" value="1" onClick="javascript: changeUbicacion(this.form);"<cfif TipoUbicacion EQ 1> checked<cfelseif TipoUbicacion EQ 3> checked<cfelse> disabled</cfif>>
						</td>
						<td nowrap><strong>CENTRO FUNCIONAL</strong></td>
						<td align="right" nowrap>
							<input name="rdTipo" type="radio" value="2" onClick="javascript: changeUbicacion(this.form);"<cfif TipoUbicacion EQ 2> checked<cfelseif TipoUbicacion NEQ 3> disabled</cfif>>
						</td>
						<td nowrap><strong>OFICINA/DEPARTAMENTO</strong></td>
					  </tr>
					</table>
				</td>
				<td align="center">&nbsp;</td>
			</tr>
			<tr id="trCFuncional" height="25">
				<td>&nbsp;</td>
				<td align="right" class="fileLabel">Centro Funcional:</td>
				<td>
					<cf_rhcfuncional size="30">
				</td>
				<td align="right">
					<input name="chkDependencias" type="checkbox" id="chkDependencias" value="1">
				</td>
				<td><strong>Incluir dependencias</strong></td>
				<td align="center">
					<input type="submit" name="btnAgregarCF"  value="Agregar">
				</td>
		  	</tr>
		  	<tr id="trOficDepto" style="display: none;" height="25">
				<td>&nbsp;</td>
				<td align="right" class="fileLabel">Oficina:</td>
				<td>
					<select name="Ocodigo">
					<cfloop query="rsOficinas">
						<option value="#rsOficinas.Ocodigo#">#rsOficinas.OficinaDesc#</option>
					</cfloop>
					</select>
				</td>
				<td align="right" class="fileLabel">Departamento:</td>
				<td>
					<select name="Dcodigo">
					<cfloop query="rsDepartamentos">
						<option value="#rsDepartamentos.Dcodigo#">#rsDepartamentos.DeptoDesc#</option>
					</cfloop>
					</select>
				</td>
				<td align="center">
					<input type="submit" name="btnAgregarOD"  value="Agregar">
				</td>
		  	</tr>
 --->		  	<tr><td colspan="5">&nbsp;</td></tr>
		</table>
	</form>

	<form name="listaUbicaciones" method="post" action="analisis-salarial-sql.cfm" style="margin: 0;">
		<cfinclude template="analisis-salarial-hiddens.cfm">
		<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td align="right">
					<label><strong><cf_translate key="LB_SeleccionarTodos">Seleccionar Todos</cf_translate></strong></label>
					<input type="checkbox" name="chkTodos" value="" onClick="javascript: funcChequeaTodos();" <cfif isdefined("form.Todos") and form.Todos EQ 1>checked</cfif>>
				</td>
			</tr>
		  <tr>
			<td>
				<cfset filtro = ''>
				<cfset navegacion = ''>
				<cfset filtro = filtro & ' and RHASid =' & Form.RHASid>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "paso=4">
				<cfif isdefined("Form.RHASid") and Len(Trim(Form.RHASid)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHASid=" & Form.RHASid>
				</cfif>
				<cfif isdefined("Form.EEid") and Len(Trim(Form.EEid)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EEid=" & Form.EEid>
				</cfif>
				<cfif isdefined("modo") and Len(Trim(modo)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "modo=" & modo>
				</cfif>
				<cfif ExisteUbicXCF>
					<input name="CentroF" type="hidden" value="">
					<cfinvoke 
					 component="rh.Componentes.pListas"
					 method="pListaQuery"
					 returnvariable="pListaEduRet">
					 	<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="CFcodigo, CFdescripcion"/>
						<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
						<cfinvokeargument name="formatos" value="S,S"/>
						<cfinvokeargument name="align" value="left, left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="analisis-salarial-sqlpaso2.cfm"/>
						<cfinvokeargument name="formName" value="listaUbicaciones"/>
						<cfinvokeargument name="MaxRows" value="15"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="formName" value="form1"/>
						<cfinvokeargument name="checkboxes" value="D"/>
						<cfinvokeargument name="keys" value="CFid"/>
						<cfinvokeargument name="showlink" value="no"/>
						<cfinvokeargument name="PageIndex" value="1"/>
					</cfinvoke>
				<cfelseif ExisteUbicXOD>
					<input name="Depto" type="hidden" value="">
					<cfinvoke 
					 component="rh.Componentes.pListas"
					 method="pListaQuery"
					 returnvariable="pListaEduRet">
					 	<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="Oficina, Depto"/>
						<cfinvokeargument name="etiquetas" value="#LB_Oficina#,#LB_Departamento#"/>
						<cfinvokeargument name="formatos" value="S,S"/>
						<cfinvokeargument name="align" value="left, left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="analisis-salarial-sqlpaso2.cfm"/>
						<cfinvokeargument name="formName" value="listaUbicaciones"/>
						<cfinvokeargument name="MaxRows" value="15"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="formName" value="form1"/>
						<cfinvokeargument name="checkboxes" value="D"/>
						<cfinvokeargument name="keys" value="Ocodigo,Dcodigo"/>
						<cfinvokeargument name="showlink" value="no"/>
						<cfinvokeargument name="PageIndex" value="2"/>
					</cfinvoke>
				</cfif>
				<!--- <fieldset style="background-color:##F3F4F8; border-top: 1px solid ##CCCCCC; border-left: 1px solid ##CCCCCC; border-right: 1px solid ##CCCCCC; border-bottom: 1px solid ##CCCCCC; ">
					<cfif ExisteUbicXCF>
						<table width="575" border="0" cellspacing="0" cellpadding="2" style="border-bottom: 1px solid black;">
						  <tr style="height: 25;">
							<td class="tituloListas" width="150" nowrap>C&Oacute;DIGO</td>
							<td class="tituloListas" width="400" nowrap>CENTRO FUNCIONAL</td>
							<td class="tituloListas" width="25" nowrap>&nbsp;</td>
						  </tr>
						</table>
					<cfelseif ExisteUbicXOD>
						<table width="575" border="0" cellspacing="0" cellpadding="2" style="border-bottom: 1px solid black;">
						  <tr style="height: 25;">
							<td class="tituloListas" width="275" nowrap>OFICINA</td>
							<td class="tituloListas" width="275" nowrap>DEPARTAMENTO</td>
							<td class="tituloListas" width="25" nowrap>&nbsp;</td>
						  </tr>
						</table>
					</cfif>
					<div id="divUbicaciones" style="overflow:auto; height: 100; margin:0;" >
						<cfinclude template="analisis-salarial-hiddens.cfm">
						<input type="hidden" name="CFid_Del" value="">
						<input type="hidden" name="Ocodigo_Del" value="">
						<input type="hidden" name="Dcodigo_Del" value="">
						<table width="575" border="0" cellspacing="0" cellpadding="2">
						  	<cfif ExisteUbicXCF>
							  <cfloop query="rsLista">
							  <tr <cfif currentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onMouseOver="javascript: this.className='listaParSel';" onMouseOut="this.className='<cfif currentRow MOD 2>listaNon<cfelse>listaPar</cfif>';" style="height: 25;">
								<td width="150" nowrap>
									#rsLista.CFcodigo#
								</td>
								<td width="400" nowrap>
									#rsLista.CFdescripcion#
								</td>
								<td width="25" align="center" onMouseOver="javascript: this.style.cursor = 'pointer';" onClick="javascript: Eliminar('#rsLista.CFid#', '#JSStringFormat(rsLista.CFcodigo)# #JSStringFormat(rsLista.CFdescripcion)#');" nowrap>
									<img src="/cfmx/rh/imagenes/Borrar01_S.gif" border="0" title="Eliminar Centro Funcional">
								</td>
							  </tr>
							  </cfloop>
							<cfelseif ExisteUbicXOD>
							  <cfloop query="rsLista">
							  <tr <cfif currentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onMouseOver="javascript: this.className='listaParSel';" onMouseOut="this.className='<cfif currentRow MOD 2>listaNon<cfelse>listaPar</cfif>';" style="height: 25;">
								<td width="275" nowrap>
									#rsLista.Oficodigo# - #rsLista.Odescripcion#
								</td>
								<td width="275" nowrap>
									#rsLista.Deptocodigo# - #rsLista.Ddescripcion#
								</td>
								<td width="25" align="center" onMouseOver="javascript: this.style.cursor = 'pointer';" onClick="javascript: Eliminar('#rsLista.Ocodigo#', '#rsLista.Dcodigo#', '#JSStringFormat(rsLista.Oficodigo)# #JSStringFormat(rsLista.Odescripcion)#', '#JSStringFormat(rsLista.Deptocodigo)# #JSStringFormat(rsLista.Ddescripcion)#');" nowrap>
									<img src="/cfmx/rh/imagenes/Borrar01_S.gif" border="0" title="Eliminar Oficina / Departamento">
								</td>
							  </tr>
							  </cfloop>
							<cfelse>
							  <tr class="listaPar" onMouseOver="javascript: this.className='listaParSel';" onMouseOut="this.className='listaPar';" style="height: 25;">
								<td width="575" align="center" nowrap>
									<font color="##FF0000"><strong>NO EXISTEN UNIDADES DE NEGOCIO ASOCIADAS AL REPORTE</strong></font>
								</td>
							  </tr>
							</cfif>
						</table>
					</div>
				</fieldset> --->
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td align="center">
 				<input type="submit" name="btnAnterior" class="btnAnterior"
					value="Anterior" onClick="javascript: funcAnterior4(this.form,#Form.paso#); ">
				<input type="submit" name="btnEliminar" class="btnEliminar"
					value="Eliminar" onClick="javascript: funcEliminar4(this.form, #Form.paso#); ">
				<input type="submit" name="btnSiguiente" class="btnSiguiente"
					value="Siguiente" onClick="javascript: funcSiguiente4(this.form, #Form.paso#); ">
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		</table>
	</form>

</cfoutput>

<script language="javascript" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	<cfif ExisteUbicXCF>
		objForm.CFcodigo.required = true;
		objForm.CFcodigo.description = "Centro Funcional";
	<cfelseif ExisteUbicXOD>
		objForm.Ocodigo.required = true;
		objForm.Ocodigo.description = "Oficina";
		objForm.Dcodigo.required = true;
		objForm.Dcodigo.description = "Departamento";
	<cfelse>
		objForm.CFcodigo.required = true;
		objForm.CFcodigo.description = "Centro Funcional";
		objForm.Ocodigo.required = true;
		objForm.Ocodigo.description = "Oficina";
		objForm.Dcodigo.required = true;
		objForm.Dcodigo.description = "Departamento";
	</cfif>
	
	changeUbicacion(document.form1);
	
	function funcAnterior4(){
		document.listaUbicaciones.paso.value = 3;
		document.listaUbicaciones.submit();
	}
	function funcSiguiente4(){
		document.listaUbicaciones.paso.value = 5;
		document.listaUbicaciones.submit();
	}
	function funcEliminar4(){
		if (hayMarcados() && confirm('<cfoutput>#MSG_DeseaEliminarLosRegistrosSeleccionados#</cfoutput>')){
			document.listaUbicaciones.submit();
		}else{
			return false;
		}
	}
	function hayMarcados(){
		var form = document.listaUbicaciones;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked)
						result = true;
				}
			}
			else{
				if (form.chk.checked)
					result = true;
			}
		}
		if (!result) alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion#</cfoutput>');
		return result;
	}
	function funcChequeaTodos(){
		var c = document.listaUbicaciones.chkTodos;
		if (document.listaUbicaciones.chk) {
			if (document.listaUbicaciones.chk.value) {
				if (!document.listaUbicaciones.chk.disabled) { 
					document.listaUbicaciones.chk.checked = c.checked;
				}
			} else {
				for (var counter = 0; counter < document.listaUbicaciones.chk.length; counter++) {
					if (!document.listaUbicaciones.chk[counter].disabled) {
						document.listaUbicaciones.chk[counter].checked = c.checked;
					}
				}
			}
		}
	}
	
</script>

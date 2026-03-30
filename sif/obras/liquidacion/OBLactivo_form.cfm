<cf_dbfunction name="now" returnvariable="now">
<cfquery name="rsGAT" datasource="#session.dsn#">
	select a.ID as GATid, 
	a.GATfecha, a.GATdescripcion, a.Ocodigo, a.ACid, a.ACcodigo, a.AFMid, a.AFMMid, a.GATserie, 
	a.GATplaca, a.GATfechainidep, a.GATfechainirev, a.CFid, coalesce(a.GATmonto,0.00) as GATmonto, 
	a.fechaalta, a.BMUsucodigo, a.ts_rversion, a.Referencia1, a.Referencia2, a.Referencia3, a.CFcuenta, 
	a.AFCcodigo, a.AFRmotivo, a.GATReferencia, a.CRTDid, a.CRCCid, a.DEid, a.GATvutil
	,b.CFcodigo, b.CFdescripcion <!--- para el tag de centros funcionales --->
	,c.ACcodigo, c.ACcodigodesc, c.ACdescripcion, c.ACmascara <!--- para el tag de categorias --->
	,d.ACid, d.ACcodigodesc as ACcodigodesc_clas, d.ACdescripcion as ACdescripcion_clas<!--- para el tag de clases --->
	,e.AFMcodigo, e.AFMdescripcion <!--- para el tag de marcas --->
	,f.AFMMcodigo, f.AFMMdescripcion <!--- para el tag de modelos --->
	,g.AFCcodigoclas, g.AFCdescripcion <!--- para el tag de tipos --->
	,h.Cmayor, h.CFformato, h.Ccuenta <!--- para el tag de cuentas --->
	,i.DEidentificacion
	,{fn concat(i.DEapellido1,{fn concat(' ',{fn concat(i.DEapellido2,{fn concat(' ',i.DEnombre)})})})} as DEnombrecompleto
	,j.CRTDcodigo,j.CRTDdescripcion
	from GATransacciones a
		left outer join CFuncional b
			on b.CFid = a.CFid
		left outer join ACategoria c
			on c.Ecodigo = a.Ecodigo
			and c.ACcodigo = a.ACcodigo
		left outer join AClasificacion d
			on d.Ecodigo = a.Ecodigo
			and d.ACid = a.ACid
			and d.ACcodigo = a.ACcodigo
		left outer join AFMarcas e
			on e.AFMid = a.AFMid
		left outer join AFMModelos f
			on f.AFMMid = a.AFMMid
		left outer join AFClasificaciones g
			on g.Ecodigo = a.Ecodigo
			and g.AFCcodigo = a.AFCcodigo
		left outer join CFinanciera h
			on h.CFcuenta = a.CFcuenta
		left outer join DatosEmpleado i
			on i.DEid = a.DEid
		left outer join CRTipoDocumento j
			on j.CRTDid = a.CRTDid
	where a.Ecodigo = #Session.Ecodigo#
			and a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOBL.GATid#" null="#rsOBL.GATid EQ ""#">
</cfquery>
<cfif len(trim(rsGAT.GATplaca)) gt 0>
	<cfquery name="rsActivo" datasource="#session.dsn#">
		select Aid, Aplaca, Adescripcion
		from Activos
		where Ecodigo = #Session.Ecodigo#
		and rtrim(ltrim(Aplaca)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(rsGAT.GATplaca)#">
	</cfquery>
</cfif>

<!--- CONSULTAS --->

<cfquery name="rsAFRmotivo" datasource="#session.dsn#">
	select AFRmotivo,AFRdescripcion from AFRetiroCuentas
	where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and AFResventa <> 'S'
	order by AFRmotivo
</cfquery>
<cfquery name="rsGACMayor" datasource="#session.dsn#">
	select Cmayor
	  from CtasMayor
	 where Ecodigo = #Session.Ecodigo#
	   and Ctipo = 'A'
</cfquery>

<cffunction name="getSelectedTipoTran" returntype="string">
	<cfargument name="tipoTran" default="0">
	<cfset selected = "">
	<cfif isdefined("rsActivo.Aid") and len(trim(rsActivo.Aid)) and rsActivo.Aid gt 0>
		<cfif Arguments.tipoTran eq 1 and rsGAT.GAtmonto gte 0>
			<cfset selected = "selected">
		<cfelseif Arguments.tipoTran eq 2 and rsGAT.GAtmonto lt 0>
			<cfset selected = "selected">
		</cfif>
	</cfif>
	<cfreturn selected>
</cffunction>
<!--- PINTA MANTENIMIENTO --->
<cfoutput>
<!--- CODIGO REQUERIDO PARA EL MANEJO DE LA PLACA --->
<iframe frameborder="0" name="fr" height="0" width="0" style="visibility:hidden"></iframe>
<script language="JavaScript" src="/cfmx/sif/js/MaskApi/masks.js"></script>
	<input type="hidden" id="GATid" name="GATid" value="#rsGAT.GATid#">
	<table width="100%" align="center" border="0" cellspacing="1" cellpadding="1" style="margin:0">	  
		<tr>
			<td colspan="5" class="subTitulo">
				Datos del Activo a generar:
			</td>
		</tr>
	  <tr><td colspan="5">&nbsp;</td></tr>
	  <tr>
  		<td width="10%" nowrap="nowrap"  class="fileLabel" align="right"><strong>Tipo Transaccion:</strong>&nbsp;</td>				
		<td colspan="4">
			<table><tr><td>
			<select name="tipoTransaccion" onchange="javascript:fnOnChangeTipoTransaccion(true);" tabindex="1">
				<option value="0" #getSelectedTipoTran(0)#>Activo Nuevo</option>
				<option value="1" #getSelectedTipoTran(1)#>Mejora</option>
			</select>
			</td><td>
			<div id="div_activo">
			<table>
				<tr>
					<td nowrap="nowrap">
						<strong>&nbsp;Buscar Placa:&nbsp;</strong>
					</td>
					<td>			
						<cfif isdefined("rsActivo.Aid") and len(trim(rsActivo.Aid)) gt 0>
							<cf_sifactivo form="form1" funcion="CargarPlaca" tabindex="1" craf=true query="#rsActivo#">
						<cfelse>
							<cf_sifactivo form="form1" funcion="CargarPlaca" tabindex="1" craf=true>
						</cfif>
					</td>
				</tr>
			</table>
			</div>
			</td></tr></table>
		</td>
	  </tr>

		<tr>
			<td align="right" nowrap="nowrap" class="fileLabel"><strong>Descripcion:</strong></td>
			<td>
				<input type="text" id="GATdescripcion" name="GATdescripcion" 
						<cfif isdefined("rsGAT.GATdescripcion") and len(trim(rsGAT.GATdescripcion)) gt 0 and rsGAT.GATdescripcion gt 0>
							value="#rsGAT.GATdescripcion#"
						</cfif> 
						size="50" maxlength="80" tabindex="2"
				/>
			</td>
			<td>&nbsp;</td>
		<cfif LvarPrimerDato>
			<td valign="top" nowrap>
				<strong>Tipo valor a asignar:</strong>
			</td>
			<td>
				<table cellpadding="0" cellspacing="0" border="0" style="margin:none;">
					<tr>
						<td valign="top">
							<select name="OBOtipoValorLiq" onchange="sbTipoValorLiq(this);">
								<option value="P">Porcentaje:</option>
								<option value="M">Monto Absoluto:</option>
							</select>
						</td>
						<td id="tdPorcentaje">
							<cf_inputNumber	name="OBOLporcentaje" 
										value="100"
										enteros="3" decimales="2" comas="no" negativos="false"
										readonly="yes"
							>%
							<font color="##0000CC">
								(Dato default)
							</font>
						</td>
						<td id="tdMonto" style="display:none;">
							<cf_inputNumber	name="OBOLmonto" 
										value="0"
										enteros="15" decimales="2" comas="yes" negativos="false"
							>
						</td>
					</tr>
				</table>
				<script language="javascript">
					function sbTipoValorLiq(obj)
					{
						document.getElementById("tdPorcentaje").style.display = (obj.value == "P") ? "" : "none";
						document.getElementById("tdMonto").style.display = (obj.value == "P") ? "none" : "";
					}
				</script>
			</td>
		<cfelseif rsOBL.OBOtipoValorLiq EQ "P">
			<td valign="top" nowrap>
				<strong>Porcent. asignado:</strong>
			</td>
			<td valign="top">
				<cfif rsOBL.OBOLporcentaje NEQ "">
					<cfset LvarPorc = rsOBL.OBOLporcentaje*100>
				<cfelse>
					<cfset LvarPorc = "">
				</cfif>
				<cf_inputNumber	name="OBOLporcentaje" 
							value="#HTMLEditFormat(LvarPorc)#"
							enteros="3" decimales="2" comas="no" negativos="false" default="0"
							modificable="#rsOBL.Ldefault NEQ 1#"
				>%
				<input type="hidden" name="OBOLmonto" value="0">
			<cfif rsOBL.Ldefault EQ 1>
				<font color="##0000CC">
					(Automático por ser dato default)
				</font>
			</cfif>
			</td>
		<cfelse>
			<td valign="top" nowrap>
				<strong>Monto asignado:</strong>
			</td>
			<td valign="top">
				<cf_inputNumber	name="OBOLmonto" 
							value="#rsOBL.OBOLmonto#"
							enteros="15" decimales="2" comas="yes" negativos="false" default="0"
				>
				<input type="hidden" name="OBOLporcentaje" value="0">
			</td>
		</cfif>
		</tr>
	  <tr>
	  	<td align="right" nowrap="nowrap" class="fileLabel"><strong>Cuenta Activo:</strong>&nbsp;</td>
		<td colspan="4">
			<cfif isdefined("rsGAT.CFcuenta") and len(trim(rsGAT.CFcuenta)) gt 0>
				<cf_cuentas form="form1" conexion="#Session.DSN#" conlis="S" query="#rsGAT#" auxiliares="N" movimiento="S" tabindex="1" cmayores="#ValueList(rsGACmayor.Cmayor)#">
			<cfelse>
				<cf_cuentas form="form1" conexion="#Session.DSN#" conlis="S" auxiliares="N" movimiento="S" tabindex="1" cmayores="#ValueList(rsGACmayor.Cmayor)#">
			</cfif>
		</td>
	  </tr>
	  <tr>
  		<td width="10%" nowrap="nowrap"  class="fileLabel" align="right">Centro Custodia:</td>				
		<td width="40%"  class="fileLabel">
			<cfset valuesArray = ArrayNew(1)>
			<cfif isdefined("rsGAT.CRCCid") and len(trim(rsGAT.CRCCid)) gt 0 and rsGAT.CRCCid gt 0> 
				<cfquery datasource="#session.dsn#" name="RSCentros">
					select CRCCid, CRCCcodigo, CRCCdescripcion
					from CRCentroCustodia
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGAT.CRCCid#">
				</cfquery>
				<cfset ArrayAppend(ValuesArray,RSCentros.CRCCid)>
				<cfset ArrayAppend(ValuesArray,RSCentros.CRCCcodigo)>
				<cfset ArrayAppend(ValuesArray,RSCentros.CRCCdescripcion)>
			</cfif>			
			<cf_conlis 
				form="form1" 
				campos="CRCCid, CRCCcodigo, CRCCdescripcion" 
				ValuesArray = "#ValuesArray#"
				desplegables="N,S,S"
				modificables="N,S,N"
				size="0,10,40"
				title="Lista de Centros de Custodia"
				tabla="CRCentroCustodia"
				columnas="CRCCid, CRCCcodigo, CRCCdescripcion"
				filtro="Ecodigo = #session.Ecodigo# order by CRCCcodigo"
				desplegar="CRCCcodigo,CRCCdescripcion"
				etiquetas="Código, Descripción"
				formatos="S,S"
				align="left,left"
				asignar="CRCCid,CRCCcodigo,CRCCdescripcion"
				asignarformatos="I,S,S"
				maxrowsquery="250"
				funcion="resetCFuncional" 
				tabindex="2">
		</td>
		<td>&nbsp;</td>
		<td align="right" nowrap="nowrap" class="fileLabel"><strong>Centro Funcional:</strong></td>
		<td>
			<cfset ValuesArray = ArrayNew(1)>
			<cfif isdefined("rsGAT.CFid") and len(trim(rsGAT.CFid)) gt 0 and rsGAT.CFid gt 0>
				<cfquery name="rsQryCentroF" datasource="#session.dsn#">
					select CFid , CFcodigo, CFdescripcion
					from CFuncional
					where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGAT.CFid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfset ArrayAppend(ValuesArray,rsQryCentroF.CFid)>
				<cfset ArrayAppend(ValuesArray,rsQryCentroF.CFcodigo)>
				<cfset ArrayAppend(ValuesArray,rsQryCentroF.CFdescripcion)>
			</cfif>
			<cf_conlis 
					form="form1" 
					campos="CFid,CFcodigo,CFdescripcion" 
					ValuesArray = "#ValuesArray#"
					desplegables="N,S,S"
					modificables="N,S,N"
					size="0,10,40"
					title="Lista de Centros Funcionales"
					tabla="CFuncional
						inner join CRCCCFuncionales
							on CRCCCFuncionales.CFid = CFuncional.CFid
							and CRCCCFuncionales.CRCCid = $CRCCid,numeric$"						
					columnas="distinct CFpath,CFnivel,CFuncional.CFid,CFuncional.CFcodigo,CFuncional.CFdescripcion"
					filtro="CFuncional.Ecodigo = #session.Ecodigo# order by CFuncional.CFpath, CFuncional.CFcodigo, CFuncional.CFnivel"
					desplegar="CFcodigo,CFdescripcion"
					filtrar_por="CFuncional.CFcodigo,CFuncional.CFdescripcion"
					etiquetas="Código, Descripción"
					formatos="S,S"
					align="left,left"
					asignar="CFid,CFcodigo,CFdescripcion"
					asignarformatos="I,S,S"
					maxrowsquery="250"
					funcion="resetEmpleado" 
					tabindex="2">
			</td>
	  </tr>
	  <tr>
	    <td align="right" nowrap="nowrap" class="fileLabel">Responsable:</td>
		<td>
			<cfset ValuesArray=ArrayNew(1)>
			<cfif isdefined("rsGAT.DEid") and len(trim(rsGAT.DEid)) gt 0 and rsGAT.DEid gt 0>
				<cfset ArrayAppend(ValuesArray,rsGAT.DEid)>
				<cfset ArrayAppend(ValuesArray,rsGAT.DEidentificacion)>
				<cfset ArrayAppend(ValuesArray,rsGAT.DEnombrecompleto)>
			</cfif>
			<cf_conlis
				form="form1" 
				Campos="DEid,DEidentificacion,DEnombrecompleto"
				ValuesArray="#ValuesArray#"
				Desplegables="N,S,S"
				Modificables="N,S,N"
				Size="0,10,40"
				tabindex="2"
				Title="Lista De Empleados"
				Tabla=" DatosEmpleado de"
				Columnas="de.DEid,de.DEidentificacion,
						{fn concat(de.DEapellido1,{fn concat(' ',{fn concat(de.DEapellido2,{fn concat(' ',de.DEnombre)})})})} as DEnombrecompleto"
				Filtro="de.Ecodigo = #session.Ecodigo# 
							and 
							( exists (
								select 1
								from EmpleadoCFuncional decf
									inner join CRCCCFuncionales cr
									on decf.CFid = cr.CFid
									and cr.CRCCid = $CRCCid,numeric$
								where decf.DEid = de.DEid
								and decf.CFid = $CFid,numeric$
								and #now# between decf.ECFdesde and decf.ECFhasta
							) or exists (
								select 1
								from LineaTiempo lt
									inner join RHPlazas rhp
										inner join CRCCCFuncionales cr
										on rhp.CFid = cr.CFid
										and cr.CRCCid = $CRCCid,numeric$
									on rhp.RHPid = lt.RHPid
									and rhp.CFid = $CFid,numeric$
								where lt.DEid = de.DEid
								and #now# between lt.LTdesde and lt.LThasta
							) ) order by DEidentificacion"
				Desplegar="DEidentificacion,DEnombrecompleto"
				Etiquetas="Identificaci&oacute;n,Nombre"

				filtrar_por="de.DEidentificacion|{fn concat(de.DEapellido1,{fn concat(' ',{fn concat(de.DEapellido2,{fn concat(' ',de.DEnombre)})})})}"
				filtrar_por_delimiters="|"
				Formatos="S,S"
				Align="left,left"
				Asignar="DEid,DEidentificacion,DEnombrecompleto"
				Asignarformatos="S,S,S"
				MaxRowsQuery="200"/>
		</td>
		<td>&nbsp;</td>
	    <td align="right" nowrap="nowrap" class="fileLabel">Tipo Documento:</td>
		<td>
			<cfset ValuesArray=ArrayNew(1)>
			<cfif isdefined("rsGAT.CRTDid") and len(trim(rsGAT.CRTDid)) gt 0 and rsGAT.CRTDid gt 0>
				<cfset ArrayAppend(ValuesArray,rsGAT.CRTDid)>
				<cfset ArrayAppend(ValuesArray,rsGAT.CRTDcodigo)>
				<cfset ArrayAppend(ValuesArray,rsGAT.CRTDdescripcion)>
			</cfif>
			<cf_conlis
				form="form1" 
				Campos="CRTDid,CRTDcodigo,CRTDdescripcion"
				Desplegables="N,S,S"
				Modificables="N,S,N"
				Size="0,10,40"
				tabindex="2"
				ValuesArray="#ValuesArray#"
				Title="Lista De Tipos De Documentos"
				Tabla="CRTipoDocumento"
				Columnas="CRTDid,CRTDcodigo,CRTDdescripcion"
				Filtro="Ecodigo = #Session.Ecodigo# order by CRTDcodigo,CRTDdescripcion"
				Desplegar="CRTDcodigo,CRTDdescripcion"
				Etiquetas="C&oacute;digo,Descripci&oacute;n"
				Formatos="S,S"
				Align="left,left"
				Asignar="CRTDid,CRTDcodigo,CRTDdescripcion"
				Asignarformatos="S,S,S"/>
		</td>
	  </tr>
	  <tr>
        <td align="right" nowrap="nowrap" class="fileLabel">Categoría:</td>
	    <td><cfset ValuesArray=ArrayNew(1)>
			<cfif isdefined("rsGAT.ACcodigo") and len(trim(rsGAT.ACcodigo)) gt 0 and rsGAT.ACcodigo gt 0>
				<cfset ArrayAppend(ValuesArray,rsGAT.ACcodigo)>
				<cfset ArrayAppend(ValuesArray,rsGAT.ACcodigodesc)>
				<cfset ArrayAppend(ValuesArray,rsGAT.ACdescripcion)>
				<cfset ArrayAppend(ValuesArray,rsGAT.ACmascara)>
            </cfif>
            <cf_conlis
				form="form1" 
				Campos="ACcodigo, ACcodigodesc, ACdescripcion, ACmascara"
				Desplegables="N,S,S,N"
				Modificables="N,S,N,N"
				Size="0,10,40,0"
				ValuesArray="#ValuesArray#"
				Title="Lista de Categorías"
				Tabla="ACategoria a"
				Columnas="ACcodigo, ACcodigodesc, ACdescripcion, ACmascara"
				Filtro="Ecodigo = #Session.Ecodigo# 
				order by ACcodigodesc, ACdescripcion"
				Desplegar="ACcodigodesc, ACdescripcion"
				Etiquetas="Código,Descripción"
				filtrar_por="ACcodigodesc, ACdescripcion"
				Formatos="S,S"
				Align="left,left"
				Asignar="ACcodigo, ACcodigodesc, ACdescripcion, ACmascara"
				Asignarformatos="I,S,S,S"
				funcion="resetClase"
				tabindex="2"/>        
		</td>
	    <td>&nbsp;</td>
	    <td align="right" nowrap="nowrap" class="fileLabel">Clase:</td>
	    <td><cfset ValuesArray=ArrayNew(1)>
			<cfif isdefined("rsGAT.ACid") and len(trim(rsGAT.ACid)) gt 0 and rsGAT.ACid gt 0>
              <cfset ArrayAppend(ValuesArray,rsGAT.ACid)>
              <cfset ArrayAppend(ValuesArray,rsGAT.ACcodigodesc_clas)>
              <cfset ArrayAppend(ValuesArray,rsGAT.ACdescripcion_clas)>
            </cfif>
            <cf_conlis
				form="form1" 
				Campos="ACid, ACcodigodesc_clas, ACdescripcion_clas"
				Desplegables="N,S,S"
				Modificables="N,S,N"
				Size="0,10,40"
				ValuesArray="#ValuesArray#"
				Title="Lista de Clases"
				Tabla="AClasificacion a"
				Columnas="ACid, ACcodigodesc as ACcodigodesc_clas, ACdescripcion as ACdescripcion_clas, ACdescripcion as GATdescripcion"
				Filtro="Ecodigo = #Session.Ecodigo# 
				and ACcodigo = $ACcodigo,numeric$ 
				order by ACcodigodesc_clas, ACdescripcion_clas"
				Desplegar="ACcodigodesc_clas, ACdescripcion_clas"
				Etiquetas="Código,Descripción"
				filtrar_por="ACcodigodesc, ACdescripcion"
				Formatos="S,S"
				Align="left,left"
				Asignar="ACid, ACcodigodesc_clas,ACdescripcion_clas,GATdescripcion"
				Asignarformatos="I,S,S,S"
				debug="false"
				left="100"
				top="100"
				width="800"
				height="600"
				tabindex="2"/>
		</td>
      </tr>
	  <tr>
        <td align="right" nowrap="nowrap" class="fileLabel">Placa:</td>
	    <td>
			<input type="text" name="GATplaca" size="20" maxlength="20" style="text-transform:uppercase" onblur="javascript:if (window.ValidarPlaca) {ValidarPlaca(this.value);}" tabindex="2"/>
			<input type="text" name="GATplaca_text" size="20" readonly class="cajasinbordeb" tabindex="-1"/>
		</td>
	    <td>&nbsp;</td>
      </tr>
	  <tr>
        <td align="right" nowrap="nowrap" class="fileLabel">Marca:</td>
	    <td><cfset ValuesArray=ArrayNew(1)>
			<cfif isdefined("rsGAT.AFMid") and len(trim(rsGAT.AFMid)) gt 0 and rsGAT.AFMid gt 0>
              <cfset ArrayAppend(ValuesArray,rsGAT.AFMid)>
              <cfset ArrayAppend(ValuesArray,rsGAT.AFMcodigo)>
              <cfset ArrayAppend(ValuesArray,rsGAT.AFMdescripcion)>
            </cfif>
            <cf_conlis
				form="form1" 
				Campos="AFMid,AFMcodigo,AFMdescripcion"
				Desplegables="N,S,S"
				Modificables="N,S,N"
				Size="0,10,40"
				ValuesArray="#ValuesArray#"
				Title="Lista de Marcas"
				Tabla="AFMarcas"
				Columnas="AFMid,AFMcodigo,AFMdescripcion"
				Filtro="Ecodigo = #Session.Ecodigo# order by AFMcodigo,AFMdescripcion"
				Desplegar="AFMcodigo,AFMdescripcion"
				Etiquetas="Código,Descripción"
				filtrar_por="AFMcodigo,AFMdescripcion"
				Formatos="S,S"
				Align="left,left"
				Asignar="AFMid,AFMcodigo,AFMdescripcion"
				Asignarformatos="I,S,S"
				funcion="resetModelo"
				tabindex="2"/>        
		</td>
	    <td>&nbsp;</td>
	    <td align="right" nowrap="nowrap" class="fileLabel">Modelo:</td>
	    <td><cfset ValuesArray=ArrayNew(1)>
			<cfif isdefined("rsGAT.AFMMid") and len(trim(rsGAT.AFMMid)) gt 0 and rsGAT.AFMMid gt 0>
              <cfset ArrayAppend(ValuesArray,rsGAT.AFMMid)>
              <cfset ArrayAppend(ValuesArray,rsGAT.AFMMcodigo)>
              <cfset ArrayAppend(ValuesArray,rsGAT.AFMMdescripcion)>
            </cfif>
            <cf_conlis
				form="form1" 
				Campos="AFMMid,AFMMcodigo,AFMMdescripcion"
				Desplegables="N,S,S"
				Modificables="N,S,N"
				Size="0,10,40"
				ValuesArray="#ValuesArray#"
				Title="Lista de Modelos"
				Tabla="AFMModelos"
				Columnas="AFMMid,AFMMcodigo,AFMMdescripcion"
				Filtro="Ecodigo = #Session.Ecodigo# and AFMid = $AFMid,numeric$ order by AFMMcodigo,AFMMdescripcion"
				Desplegar="AFMMcodigo,AFMMdescripcion"
				Etiquetas="Código,Descripción"
				filtrar_por="AFMMcodigo,AFMMdescripcion"
				Formatos="S,S"
				Align="left,left"
				Asignar="AFMMid,AFMMcodigo,AFMMdescripcion"
				Asignarformatos="I,S,S"
				tabindex="2"/>        
		</td>
      </tr>
	  <tr>
        <td align="right" nowrap="nowrap" class="fileLabel">Tipo:</td>
	    <td><cfset ValuesArray=ArrayNew(1)>
			<cfif isdefined("rsGAT.AFCcodigo") and len(trim(rsGAT.AFCcodigo)) gt 0 and rsGAT.AFCcodigo gt 0>
              <cfset ArrayAppend(ValuesArray,rsGAT.AFCcodigo)>
              <cfset ArrayAppend(ValuesArray,rsGAT.AFCcodigoclas)>
              <cfset ArrayAppend(ValuesArray,rsGAT.AFCdescripcion)>
            </cfif>
            <cf_conlis
				form="form1" 
				Campos="AFCcodigo,AFCcodigoclas,AFCdescripcion"
				Desplegables="N,S,S"
				Modificables="N,S,N"
				Size="0,10,40"
				ValuesArray="#ValuesArray#"
				Title="Lista de Clasificaciones"
				Tabla="AFClasificaciones"
				Columnas="AFCcodigo,AFCcodigoclas,AFCdescripcion"
				Filtro="Ecodigo = #Session.Ecodigo# order by AFCcodigoclas,AFCdescripcion"
				Desplegar="AFCcodigoclas,AFCdescripcion"
				Etiquetas="Código,Descripción"
				filtrar_por="AFCcodigoclas,AFCdescripcion"
				Formatos="S,S"
				Align="left,left"
				Asignar="AFCcodigo,AFCcodigoclas,AFCdescripcion"
				Asignarformatos="I,S,S"
				tabindex="2"/>        
		</td>
	    <td>&nbsp;</td>
	    <td align="right" nowrap="nowrap" class="fileLabel">Serie:</td>
	    <td>
			<input type="text" id="GATserie" name="GATserie" 
					<cfif isdefined("rsGAT.GATserie") and len(trim(rsGAT.GATserie)) gt 0 and rsGAT.GATserie gt 0>
						value="#rsGAT.GATserie#"
					</cfif>
					size="60" maxlength="50" tabindex="2"
			/>        
		</td>
      </tr>
	  <tr>
        <td align="right" nowrap="nowrap" class="fileLabel" >Inicio Dep.:</td>
		<td>
			<cfif isdefined("rsGAT.GATfechainidep") and len(trim(rsGAT.GATfechainidep)) gt 0 and rsGAT.GATfechainidep gt 0>
				<cfset fecha = rsGAT.GATfechainidep>
			<cfelse>
				<cfset fecha = Now()>
			</cfif>
			<cf_sifcalendario form="form1" name="GATfechainidep" value="#LSDateFormat(fecha,'dd/mm/yyyy')#" tabindex="2">		</td>
		<td>&nbsp;</td>
		<td align="right" nowrap="nowrap" class="fileLabel" >Inicio Rev.:</td>
		<td>
			<cfif isdefined("rsGAT.GATfechainirev") and len(trim(rsGAT.GATfechainirev)) gt 0 and rsGAT.GATfechainirev gt 0>
				<cfset fecha = rsGAT.GATfechainirev>
			<cfelse>
				<cfset fecha = Now()>
			</cfif>
			<cf_sifcalendario form="form1" name="GATfechainirev" value="#LSDateFormat(fecha,'dd/mm/yyyy')#" tabindex="2">		</td>
	  </tr>
	  <tr>
	  	<td align="right" nowrap="nowrap" class="fileLabel">Fecha:</td>
		<td>
			<cfif isdefined("rsGAT.GATfecha") and len(trim(rsGAT.GATfecha)) gt 0 and rsGAT.GATfecha gt 0>
				<cf_sifcalendario form="form1" id="GATfecha" name="GATfecha" value="#LSDateFormat(rsGAT.GATfecha,'dd/mm/yyyy')#" tabindex="2">
			<cfelse>
				<cf_sifcalendario form="form1" id="GATfecha" name="GATfecha" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="2">
			</cfif>		</td>
		<td>&nbsp;</td>
		<td align="right" nowrap="nowrap" class="fileLabel">Referencia.:</td>
		<td>
			<input type="text" id="GATreferencia" name="GATreferencia" 
					<cfif isdefined("rsGAT.GATreferencia") and len(trim(rsGAT.GATreferencia)) gt 0 and rsGAT.GATreferencia gt 0>
						value="#rsGAT.GATreferencia#"
					</cfif> 
					size="60" maxlength="50" tabindex="2"
			/>
		</td>		
	  </tr>
	  <tr>
        <td align="right" nowrap="nowrap" class="fileLabel">&nbsp;</td>
		<td>
			<input type="hidden" name="GATmonto" id="GATmonto" value="0">
		</td>
		<td>&nbsp;</td>
		<td align="right" nowrap="nowrap" class="fileLabel"><div id="div_retiro_label">Motivo Retiro:</div><div id="div_mejora_label">Vida &uacute;til:</div></td>
		<td>
		<div id="div_retiro">
			<select name="AFRmotivo" tabindex="2">
				<option value="">-- Seleccione uno --</option>
				<cfloop query="rsAFRmotivo">
					<option value="#rsAFRmotivo.AFRmotivo#" 
							<cfif isdefined("rsGAT.AFRmotivo") and len(trim(rsGAT.AFRmotivo)) gt 0 and rsGAT.AFRmotivo gt 0 and rsGAT.AFRmotivo eq rsAFRmotivo.AFRmotivo>selected</cfif>>
						#rsAFRmotivo.AFRmotivo#-#rsAFRmotivo.AFRdescripcion#
					</option>
				</cfloop>
			</select>
		</div>
		<div id="div_mejora">
			<cfif isdefined("rsGAT.GATvutil") and len(trim(rsGAT.GATvutil)) gt 0>
				<cf_inputNumber name="GATvutil" value="#rsGAT.GATvutil#" tabindex="2" decimales="0">
			<cfelse>
				<cf_inputNumber name="GATvutil" tabindex="2" decimales="0">
			</cfif>
		</div></td>
	  </tr>
		<tr>
			<td colspan="5" align="center">
			<cfif rsOBL.OBOid NEQ "">
				<cf_botones  regresar='OBobra.cfm?OP=L&OBOid=#form.OBOid#' modo='CAMBIO'>
			<cfelse>
				<cf_botones  regresar='OBobra.cfm?OP=L&OBOid=#form.OBOid#' modo='ALTA'>
			</cfif>
			</td>
		</tr>
	</table>
<script language="javascript" type="text/javascript">
	<!--//
		//funcion onValidate
		function fnX(){
			if (!LvarQform1._allowSubmitOnError) {
				LvarQform1.AFRmotivo.description = "Motivo de Retiro";
				LvarQform1.GATvutil.description = "Vida útil";
				if (parseFloat(qf(LvarQform1.GATmonto.getValue()))<0 && LvarQform1.tipoTransaccion.getValue()<2)
					LvarQform1.GATmonto.throwError('El campo ' + LvarQform1.GATmonto.description + ' no puede ser negativo cuando realiza una adquisición o una mejora.');
				if (parseFloat(qf(LvarQform1.GATmonto.getValue()))>0 && LvarQform1.tipoTransaccion.getValue()==2)
					LvarQform1.GATmonto.throwError('El campo ' + LvarQform1.GATmonto.description + ' no puede ser positivo cuando realiza un retiro.');
				if (parseFloat(qf(LvarQform1.GATmonto.getValue()))<0 && LvarQform1.Aid.getValue()!="" && LvarQform1.AFRmotivo.getValue()=="")
					LvarQform1.AFRmotivo.throwError('El campo ' + LvarQform1.AFRmotivo.description + ' es requerido cuando está realizando un retiro.');
				if (parseFloat(qf(LvarQform1.GATmonto.getValue()))>0 && LvarQform1.Aid.getValue()!="" && LvarQform1.GATvutil.getValue()=="")
					LvarQform1.GATvutil.throwError('El campo ' + LvarQform1.GATvutil.description + ' es requerido cuando está realizando una mejora.');
			}
		}
		//funciones setReadOnly
		function setReadOnly_form1_GATplaca(pReadOnly){
			if (pReadOnly)
			{
				document.form1.GATplaca.tabIndex 				= -1;
				document.form1.GATplaca.readOnly				= true;
				document.form1.GATplaca.style.border			= "solid 1px ##CCCCCC";
				document.form1.GATplaca.style.backGround	= "inherit";
			}
			else
			{
				document.form1.GATplaca.tabIndex 				= 2;
				document.form1.GATplaca.readOnly				= false;
				document.form1.GATplaca.style.border			= window.Event ? "" : "inset 2px";
				document.form1.GATplaca.style.backGround	= "";
			}
		
			return;
		}
		function setReadOnly_form1_GATdescripcion(pReadOnly){
			if (pReadOnly)
			{
				document.form1.GATdescripcion.tabIndex 				= -1;
				document.form1.GATdescripcion.readOnly				= true;
				document.form1.GATdescripcion.style.border			= "solid 1px ##CCCCCC";
				document.form1.GATdescripcion.style.backGround	= "inherit";
			}
			else
			{
				document.form1.GATdescripcion.tabIndex 				= 2;
				document.form1.GATdescripcion.readOnly				= false;
				document.form1.GATdescripcion.style.border			= window.Event ? "" : "inset 2px";
				document.form1.GATdescripcion.style.backGround	= "";
			}
		
			return;
		}
		function setReadOnly_form1_GATserie(pReadOnly){
			if (pReadOnly)
			{
				document.form1.GATserie.tabIndex 				= -1;
				document.form1.GATserie.readOnly				= true;
				document.form1.GATserie.style.border			= "solid 1px ##CCCCCC";
				document.form1.GATserie.style.backGround	= "inherit";
			}
			else
			{
				document.form1.GATserie.tabIndex 				= 2;
				document.form1.GATserie.readOnly				= false;
				document.form1.GATserie.style.border			= window.Event ? "" : "inset 2px";
				document.form1.GATserie.style.backGround	= "";
			}
		
			return;
		}
		function setReadOnly_form1_GATfechainidep(pReadOnly){
			if (pReadOnly)
			{
				document.form1.GATfechainidep.tabIndex 				= -1;
				document.form1.GATfechainidep.readOnly				= true;
				document.form1.GATfechainidep.style.border			= "solid 1px ##CCCCCC";
				document.form1.GATfechainidep.style.backGround	= "inherit";
				document.getElementById("img_form1_GATfechainidep").style.display = "none";
			}
			else
			{
				document.form1.GATfechainidep.tabIndex 				= 2;
				document.form1.GATfechainidep.readOnly				= false;
				document.form1.GATfechainidep.style.border			= window.Event ? "" : "inset 2px";
				document.form1.GATfechainidep.style.backGround	= "";
				document.getElementById("img_form1_GATfechainidep").style.display = "";
			}
		
			return;
		}
		function setReadOnly_form1_GATfechainirev(pReadOnly){
			if (pReadOnly)
			{
				document.form1.GATfechainirev.tabIndex 				= -1;
				document.form1.GATfechainirev.readOnly				= true;
				document.form1.GATfechainirev.style.border			= "solid 1px ##CCCCCC";
				document.form1.GATfechainirev.style.backGround	= "inherit";
				document.getElementById("img_form1_GATfechainirev").style.display = "none";
			}
			else
			{
				document.form1.GATfechainirev.tabIndex 				= 2;
				document.form1.GATfechainirev.readOnly				= false;
				document.form1.GATfechainirev.style.border			= window.Event ? "" : "inset 2px";
				document.form1.GATfechainirev.style.backGround	= "";
				document.getElementById("img_form1_GATfechainirev").style.display = "";
			}
		
			return;
		}
		function setReadOnly_form1_GATfecha(pReadOnly){
			if (pReadOnly)
			{
				document.form1.GATfecha.tabIndex 				= -1;
				document.form1.GATfecha.readOnly				= true;
				document.form1.GATfecha.style.border			= "solid 1px ##CCCCCC";
				document.form1.GATfecha.style.backGround	= "inherit";
				document.getElementById("img_form1_GATfecha").style.display = "none";
			}
			else
			{
				document.form1.GATfecha.tabIndex 				= 2;
				document.form1.GATfecha.readOnly				= false;
				document.form1.GATfecha.style.border			= window.Event ? "" : "inset 2px";
				document.form1.GATfecha.style.backGround		= "";
				document.getElementById("img_form1_GATfecha").style.display = "";
			}
			
			return;
		}
		function setReadOnly(pReadOnly){
			setReadOnly_form1_CRCCid(pReadOnly);
			setReadOnly_form1_CFid(pReadOnly);
			setReadOnly_form1_DEid(pReadOnly);
			setReadOnly_form1_CRTDid(pReadOnly);
			setReadOnly_form1_ACcodigo(pReadOnly);
			setReadOnly_form1_ACid(pReadOnly);
			
			setReadOnly_form1_GATplaca(pReadOnly);
			setReadOnly_form1_GATdescripcion(pReadOnly);
			
			setReadOnly_form1_AFMid(pReadOnly);
			setReadOnly_form1_AFMMid(pReadOnly);
			setReadOnly_form1_AFCcodigo(pReadOnly);
			
			setReadOnly_form1_GATserie(pReadOnly);
			setReadOnly_form1_GATfechainidep(pReadOnly);
			setReadOnly_form1_GATfechainirev(pReadOnly);
			setReadOnly_form1_GATfecha(pReadOnly);
		}
		//funcion onSubmit
		function fnY(){
			setReadOnly(false);
		}
	//-->
</script>
</cfoutput>
<cf_qforms form="form1" objForm="LvarQform1">
<cfif LvarCuentaLiquidacion>
	<cf_qformsRequiredField args="CFformatoLiquidacion,Cuenta Financiera de Liquidación">
</cfif>
	<cf_qformsRequiredField args="GATdescripcion,Descripcion del Activo">
	<cf_qformsRequiredField args="CFcuenta,Cuenta del Activo">
	<cf_qformsRequiredField args="CFid,Centro Funcional del Activo">
</cf_qforms>

<cfoutput>
	<script language="javascript" type="text/javascript">
		<!--//
		// Variables Generales
		oStringMask = new Mask("");
		oStringMask.attach(document.form1.GATplaca,oStringMask.mask,"string","if (window.ValidarPlaca) {ValidarPlaca(document.form1.GATplaca.value);}");
		/*var tabOnGATmonto = false;*/
		//Funciones de Validación
		function resetClase(){
			LvarQform1.ACid.obj.value=''; LvarQform1.ACcodigodesc_clas.obj.value=''; LvarQform1.ACdescripcion_clas.obj.value='';
			CambiarMascara();
		}
		function resetModelo(){
			LvarQform1.AFMMid.obj.value=''; LvarQform1.AFMMcodigo.obj.value=''; LvarQform1.AFMMdescripcion.obj.value='';
		}
		function resetCFuncional(){
			LvarQform1.CFid.obj.value=''; LvarQform1.CFcodigo.obj.value=''; LvarQform1.CFdescripcion.obj.value='';
			resetEmpleado();
		}
		function resetEmpleado(){
			LvarQform1.DEid.obj.value=''; LvarQform1.DEidentificacion.obj.value=''; LvarQform1.DEnombrecompleto.obj.value='';
		}
		function CambiarMascara(){
			var mascara = "";
			LvarQform1.GATplaca.obj.value="";
			LvarQform1.GATplaca_text.obj.value="";
			lastReadOnly = LvarQform1.GATplaca.obj.readOnly;
			mascara = LvarQform1.ACmascara.getValue();
			if (mascara.length> 0) {
				var strErrorMsg="El valor de la placa no concuerda con el formato "+mascara;
				oStringMask.mask = mascara.replace(/X/g,"*");
				LvarQform1.GATplaca.obj.readOnly=lastReadOnly;
				LvarQform1.GATplaca_text.obj.value=mascara.replace(/X/g,"X");
				return true;
			}
			LvarQform1.GATplaca.obj.readOnly=true;
			LvarQform1.GATplaca.obj.value='';
		}
		function ValidarPlaca(placa) {
			
			if (placa==''){
				document.form1.GATplaca.value="";
				document.form1.GATplaca_text.value="";
				document.form1.GATdescripcion.value="";
				document.form1.Aid.value="";
				document.form1.Aplaca.value="";
				document.form1.Adescripcion.value="";
				return;
			}
			
			if (!LvarQform1.GATplaca.obj.readOnly) {
				document.all["fr"].src="/cfmx/sif/af/gestion/operacion/valida_placa.cfm?placa="+placa;
				return;
			}
		}
		function CargarPlaca() {
			var aid = LvarQform1.Aid.getValue();
			if (aid!=''){
				document.all["fr"].src="/cfmx/sif/af/gestion/operacion/valida_placa.cfm?aid="+aid;
			}
		}
		function funcGATmonto(){
			/*Ahora la funcionalidad la realiza ChangeTipoTransaccion*/
		}
		function funcCompletar(){
			deshabilitarValidacion();
		}
		function funcLista(){
			deshabilitarValidacion();
		}
		function funcLimpiar(){
			setReadOnly(false);
		}
		function fnOnChangeTipoTransaccion(validar){
			//obtiene los divs
			_div_activo = document.getElementById("div_activo");
			_div_mejora = document.getElementById("div_mejora");
			_div_mejora_label = document.getElementById("div_mejora_label");
			_div_retiro = document.getElementById("div_retiro");
			_div_retiro_label = document.getElementById("div_retiro_label");
			//pone todos ocultos
			_div_activo.style.display='none';
			_div_mejora.style.display='none';
			_div_mejora_label.style.display='none';
			_div_retiro.style.display='none';
			_div_retiro_label.style.display='none';
			//pone visibles los que corresponde
			if (LvarQform1.tipoTransaccion.getValue()==0) {
				setReadOnly(false);
			} else {
				_div_activo.style.display='';
				if (LvarQform1.tipoTransaccion.getValue()==1) {
					_div_mejora.style.display='';
					_div_mejora_label.style.display='';
				} else {
					_div_retiro.style.display='';
					_div_retiro_label.style.display='';				
				}
				setReadOnly(true);
			}
			//Limpia la placa cuando viene validar en true
			if (validar) ValidarPlaca("");
		}
		function funcGATmontoOnKeyDown(e) {
			 /*e = (e) ? e : event
			 var tecla = (e.which) ? e.which : e.keyCode
			 if (tecla==9){
			 	tabOnGATmonto = true;
			 }*/
		}
		//Inicio
		CambiarMascara();
		funcGATmonto();
		fnOnChangeTipoTransaccion(false);
		<cfif isdefined("rsGAT.GATplaca") and len(trim(rsGAT.GATplaca))>
			LvarQform1.GATplaca.obj.value="#Trim(rsGAT.GATplaca)#";
			<cfif isdefined("rsActivo.Aid") and len(trim(rsActivo.Aid)) gt 0 and rsActivo.Aid gt 0>
				setReadOnly(true);
			</cfif>
		</cfif> 
		LvarQform1.GATdescripcion.obj.focus();
		//-->
	</script>
</cfoutput>

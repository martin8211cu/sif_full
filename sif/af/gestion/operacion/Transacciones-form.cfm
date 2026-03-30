<cfinclude template="Transacciones-encab.cfm">
<cf_dbfunction name="concat" args="i.DEapellido1,' ',i.DEapellido2,' ',i.DEnombre" returnvariable="DEnombrecompleto">
<cf_dbfunction name="now" returnvariable="hoy">

<!--- DEFINE EL MODO DE LA PANTALLA POR DEFECTO EN MODO ALTA --->
<cfset modo = "ALTA">
<cfif (isdefined("form.GATid") and len(trim(form.GATid)))>
	<!--- DEFINE EL MODO DE LA PANTALLA CUANDO VIENE LA LLAVE DE LA TABLA EN CAMBIO --->
	<cfset modo = "CAMBIO">
</cfif>
<cfif (modo neq "ALTA")
		or 
		(isdefined("form.Completar"))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select a.ID as GATid, a.Ecodigo, a.Cconcepto, a.GATperiodo, a.GATmes, a.Edocumento, 
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
		,#PreserveSingleQuotes(DEnombrecompleto)# as DEnombrecompleto
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
		where a.Ecodigo =  #Session.Ecodigo# 
			<cfif (modo neq "ALTA")>
				<!--- CONSULTA EN MODO CAMBIO LA TABLA CON LA LLAVE INDICADA --->
				and a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GATid#">
			<cfelse>
				<!--- CONSULTA EN MODO CAMBIO LA TABLA CON EL ULTIMO DATO DIGITADO POR EL USUARIO --->
				and a.BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				and a.ts_rversion = (select max(ts_rversion) from GATransacciones where Ecodigo = a.Ecodigo)		  
			</cfif>
	</cfquery>
	<cfif len(trim(rsForm.GATplaca)) gt 0>
		<cfquery name="rsActivo" datasource="#session.dsn#">
			select Aid, Aplaca, Adescripcion
			from Activos
			where Ecodigo =  #Session.Ecodigo# 
			and rtrim(ltrim(Aplaca)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(rsForm.GATplaca)#">
		</cfquery>
	</cfif>
</cfif>
<!--- CONSULTAS --->
<cfquery name="rsPeriodoAux" datasource="#session.dsn#">
	select Pvalor, Pdescripcion 
	from Parametros 
	where Ecodigo =  #Session.Ecodigo#  
	  and Pcodigo = 50 
</cfquery>
<cfquery name="rsMesAux" datasource="#session.dsn#">
	select Pvalor, Pdescripcion 
	from Parametros 
	where Ecodigo =  #Session.Ecodigo#  
	  and Pcodigo = 60 
</cfquery>
<cfset rsGATperiodo = querynew("GATperiodo")>
<cfloop from="#rsPeriodoAux.Pvalor-10#" to="#rsPeriodoAux.Pvalor+10#" index="value">
	<cfset QueryAddRow(rsGATperiodo,1)>
	<cfset QuerySetCell(rsGATperiodo, "GATperiodo", value, rsGATperiodo.recordcount)>
</cfloop>
<cfquery name="rsGATmes" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="VSvalor"> as GATmes, VSdesc as GATmesdesc
	from VSidioma vs
		inner join Idiomas id
		on id.Iid = vs.Iid
		and id.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Idioma#"/>
	where VSgrupo = 1
	order by 1
</cfquery>
<cfquery name="rsCconcepto" datasource="#session.dsn#">
	select Cconcepto, Cdescripcion
	from ConceptoContableE
	where Ecodigo =  #Session.Ecodigo# 
</cfquery>
<cfquery name="rsAFRmotivo" datasource="#session.dsn#">
	select AFRmotivo,AFRdescripcion from AFRetiroCuentas
	where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and AFResventa <> 'S'
	order by AFRmotivo
</cfquery>
<cfquery name="rsGACMayor" datasource="#session.dsn#">
	select Cmayor
	from GACMayor
	where Ecodigo =  #Session.Ecodigo# 
</cfquery>
<cfquery name="rsMonLoc" datasource="#session.dsn#">
	select Mnombre
	from Empresas a, Monedas b
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.Mcodigo = b.Mcodigo
</cfquery>
<cfset Lvar_MonedaLocalName = rsMonLoc.Mnombre>
<cffunction name="getSelectedTipoTran" returntype="string">
	<cfargument name="tipoTran" default="0">
	<cfset selected = "">
	<cfif isdefined("rsActivo.Aid") and len(trim(rsActivo.Aid)) and rsActivo.Aid gt 0>
		<cfif Arguments.tipoTran eq 1 and rsForm.GAtmonto gte 0>
			<cfset selected = "selected">
		<cfelseif Arguments.tipoTran eq 2 and rsForm.GAtmonto lt 0>
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
<form action="Transacciones-sql.cfm" method="post" name="form1" style="margin:0">
	<input name="GATperiodo" type="hidden" value="#form.GATperiodo#">
	<input name="GATmes" type="hidden" value="#form.GATmes#">
	<input name="Cconcepto" type="hidden" value="#form.Cconcepto#">
	<input name="Edocumento" type="hidden" value="#form.Edocumento#">
	<cfif modo neq "ALTA">
	<input type="hidden" id="GATid" name="GATid" value="#rsForm.GATid#">
	</cfif>
	<br />
	<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<td width="45%">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin:0">
				  <tr>
					<td nowrap="nowrap">&nbsp;Tipo de Transacci&oacute;n:&nbsp;</td>
					<td >
						
						<select name="tipoTransaccion" onchange="javascript:fnOnChangeTipoTransaccion(true);" tabindex="1">
							<option value="0" #getSelectedTipoTran(0)#>Adquisici&oacute;n</option>
							<option value="1" #getSelectedTipoTran(1)#>Mejora</option>
							<option value="2" #getSelectedTipoTran(2)#>Retiro</option>
						</select>
					</td>
				  </tr>
			 </table>
		</td>
		<td width="45%">
			<div id="div_activo">
			<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0" style="margin:0">
			  <tr>
					<td nowrap="nowrap">&nbsp;Buscar Placa:&nbsp;</td>
					<td>
						<cfif isdefined("rsActivo.Aid") and len(trim(rsActivo.Aid)) gt 0>
							<cf_sifactivo funcion="CargarPlaca" tabindex="1" craf=true query="#rsActivo#">
						<cfelse>
							<cf_sifactivo funcion="CargarPlaca" tabindex="1" craf=true>
						</cfif>
					</td>
				</tr>
			</table>
			</div>
		</td>
		<td width="10%">
			<cf_sifayuda text="xyz">
		</td>
	  </tr>
	</table>
	<table width="100%" align="center" border="0" cellspacing="1" cellpadding="1" style="margin:0">	  
	  <tr><td colspan="5">&nbsp;</td></tr>
	  <tr>
	  	<td align="right" nowrap="nowrap" class="fileLabel">Cuenta:&nbsp;</td>
		<td>
			<cfif isdefined("rsForm.CFcuenta") and len(trim(rsForm.CFcuenta)) gt 0>
				<cf_cuentas  conexion="#Session.DSN#" conlis="S" query="#rsForm#" auxiliares="N" movimiento="S" tabindex="1" cmayores="#ValueList(rsGACmayor.Cmayor)#">
			<cfelse>
				<cf_cuentas  conexion="#Session.DSN#" conlis="S" auxiliares="N" movimiento="S" tabindex="1" cmayores="#ValueList(rsGACmayor.Cmayor)#">
			</cfif>
		</td>
	  </tr>
	  <tr>
  		<td width="10%" nowrap="nowrap"  class="fileLabel" align="right">Centro Custodia:</td>				
		<td width="40%"  class="fileLabel">
			<cfset valuesArray = ArrayNew(1)>
			<cfif isdefined("rsForm.CRCCid") and len(trim(rsForm.CRCCid)) gt 0 and rsForm.CRCCid gt 0> 
				<cfquery datasource="#session.dsn#" name="RSCentros">
					select CRCCid, CRCCcodigo, CRCCdescripcion
					from CRCentroCustodia
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CRCCid#">
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
		<td align="right" nowrap="nowrap" class="fileLabel">Centro Funcional:</td>
		<td>
			<cfset ValuesArray = ArrayNew(1)>
			<cfif isdefined("rsForm.CFid") and len(trim(rsForm.CFid)) gt 0 and rsForm.CFid gt 0>
				<cfquery name="rsQryCentroF" datasource="#session.dsn#">
					select CFid , CFcodigo, CFdescripcion
					from CFuncional
					where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFid#">
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
					tabla="HEContables e
                                inner join HDContables d
                                on d.IDcontable = e.IDcontable
                            
                                inner join CFuncional cf
                                on  cf.Ecodigo = d.Ecodigo
                                and cf.Ocodigo = d.Ocodigo 
                            
                                inner join CRCCCFuncionales cfcc
                                on cfcc.CFid =  cf.CFid"
					columnas="distinct cf.CFpath, cf.CFid, cf.CFcodigo, cf.CFdescripcion, cf.CFnivel"
					filtro=" e.Ecodigo   = #session.Ecodigo#
                    	and e.Eperiodo 	 = #form.GATperiodo#
						and e.Emes 		 = #form.GATmes#
						and e.Cconcepto  = #form.Cconcepto#
						and e.Edocumento = #form.Edocumento#
                        and cfcc.CRCCid  = $CRCCid,numeric$
                        order by cf.CFpath, cf.CFcodigo, cf.CFnivel"
					desplegar="CFcodigo,CFdescripcion"
					filtrar_por="cf.CFcodigo,cf.CFdescripcion"
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
			<cfif isdefined("rsForm.DEid") and len(trim(rsForm.DEid)) gt 0 and rsForm.DEid gt 0>
				<cfset ArrayAppend(ValuesArray,rsForm.DEid)>
				<cfset ArrayAppend(ValuesArray,rsForm.DEidentificacion)>
				<cfset ArrayAppend(ValuesArray,rsForm.DEnombrecompleto)>
			</cfif>
			<cf_dbfunction name="concat" args="de.DEapellido1,' ',de.DEapellido2,' ',de.DEnombre" returnvariable="DEnombrecompleto2">
			<cf_conlis
				Campos="DEid,DEidentificacion,DEnombrecompleto"
				ValuesArray="#ValuesArray#"
				Desplegables="N,S,S"
				Modificables="N,S,N"
				Size="0,10,40"
				form="form1"
				tabindex="2"
				Title="Lista De Empleados"
				Tabla=" DatosEmpleado de"
				Columnas="de.DEid,de.DEidentificacion,#DEnombrecompleto2# as DEnombrecompleto"
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
								and #hoy# between decf.ECFdesde and decf.ECFhasta
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
								and #hoy# between lt.LTdesde and lt.LThasta
							) ) order by DEidentificacion"
				Desplegar="DEidentificacion,DEnombrecompleto"
				Etiquetas="Identificaci&oacute;n,Nombre"

				filtrar_por="de.DEidentificacion|#DEnombrecompleto2#"
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
			<cfif isdefined("rsForm.CRTDid") and len(trim(rsForm.CRTDid)) gt 0 and rsForm.CRTDid gt 0>
				<cfset ArrayAppend(ValuesArray,rsForm.CRTDid)>
				<cfset ArrayAppend(ValuesArray,rsForm.CRTDcodigo)>
				<cfset ArrayAppend(ValuesArray,rsForm.CRTDdescripcion)>
			</cfif>
			<cf_conlis
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
			<cfif isdefined("rsForm.ACcodigo") and len(trim(rsForm.ACcodigo)) gt 0 and rsForm.ACcodigo gt 0>
				<cfset ArrayAppend(ValuesArray,rsForm.ACcodigo)>
				<cfset ArrayAppend(ValuesArray,rsForm.ACcodigodesc)>
				<cfset ArrayAppend(ValuesArray,rsForm.ACdescripcion)>
				<cfset ArrayAppend(ValuesArray,rsForm.ACmascara)>
            </cfif>
            <cf_conlis
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
						tabindex="2"/>        </td>
	    <td>&nbsp;</td>
	    <td align="right" nowrap="nowrap" class="fileLabel">Clase:</td>
	    <td><cfset ValuesArray=ArrayNew(1)>
			<cfif isdefined("rsForm.ACid") and len(trim(rsForm.ACid)) gt 0 and rsForm.ACid gt 0>
              <cfset ArrayAppend(ValuesArray,rsForm.ACid)>
              <cfset ArrayAppend(ValuesArray,rsForm.ACcodigodesc_clas)>
              <cfset ArrayAppend(ValuesArray,rsForm.ACdescripcion_clas)>
            </cfif>
            <cf_conlis
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
	    <td align="right" nowrap="nowrap" class="fileLabel">Descripción:</td>
	    <td>
			<input type="text" id="GATdescripcion" name="GATdescripcion" 
					<cfif isdefined("rsForm.GATdescripcion") and len(trim(rsForm.GATdescripcion)) gt 0 and rsForm.GATdescripcion gt 0>
						value="#rsForm.GATdescripcion#"
					</cfif> 
					size="60" maxlength="80" tabindex="2"
			/>
		</td>
      </tr>
	  <tr>
        <td align="right" nowrap="nowrap" class="fileLabel">Marca:</td>
	    <td><cfset ValuesArray=ArrayNew(1)>
			<cfif isdefined("rsForm.AFMid") and len(trim(rsForm.AFMid)) gt 0 and rsForm.AFMid gt 0>
              <cfset ArrayAppend(ValuesArray,rsForm.AFMid)>
              <cfset ArrayAppend(ValuesArray,rsForm.AFMcodigo)>
              <cfset ArrayAppend(ValuesArray,rsForm.AFMdescripcion)>
            </cfif>
            <cf_conlis
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
						tabindex="2"/>        </td>
	    <td>&nbsp;</td>
	    <td align="right" nowrap="nowrap" class="fileLabel">Modelo:</td>
	    <td><cfset ValuesArray=ArrayNew(1)>
			<cfif isdefined("rsForm.AFMMid") and len(trim(rsForm.AFMMid)) gt 0 and rsForm.AFMMid gt 0>
              <cfset ArrayAppend(ValuesArray,rsForm.AFMMid)>
              <cfset ArrayAppend(ValuesArray,rsForm.AFMMcodigo)>
              <cfset ArrayAppend(ValuesArray,rsForm.AFMMdescripcion)>
            </cfif>
            <cf_conlis
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
						tabindex="2"/>        </td>
      </tr>
	  <tr>
        <td align="right" nowrap="nowrap" class="fileLabel">Tipo:</td>
	    <td><cfset ValuesArray=ArrayNew(1)>
			<cfif isdefined("rsForm.AFCcodigo") and len(trim(rsForm.AFCcodigo)) gt 0 and rsForm.AFCcodigo gt 0>
              <cfset ArrayAppend(ValuesArray,rsForm.AFCcodigo)>
              <cfset ArrayAppend(ValuesArray,rsForm.AFCcodigoclas)>
              <cfset ArrayAppend(ValuesArray,rsForm.AFCdescripcion)>
            </cfif>
            <cf_conlis
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
						tabindex="2"/>        </td>
	    <td>&nbsp;</td>
	    <td align="right" nowrap="nowrap" class="fileLabel">Serie:</td>
	    <td>
			<input type="text" id="GATserie" name="GATserie" 
					<cfif isdefined("rsForm.GATserie") and len(trim(rsForm.GATserie)) gt 0 and rsForm.GATserie gt 0>
						value="#rsForm.GATserie#"
					</cfif>
					size="60" maxlength="50" tabindex="2"
			/>        
		</td>
      </tr>
	  <tr>
        <td align="right" nowrap="nowrap" class="fileLabel" >Inicio Dep.:</td>
		<td>
			<cfif isdefined("rsForm.GATfechainidep") and len(trim(rsForm.GATfechainidep)) gt 0 and rsForm.GATfechainidep gt 0>
				<cfset fecha = rsForm.GATfechainidep>
			<cfelse>
				<cfset fecha = Now()>
			</cfif>
			<cf_sifcalendario name="GATfechainidep" value="#LSDateFormat(fecha,'dd/mm/yyyy')#" tabindex="2">		</td>
		<td>&nbsp;</td>
		<td align="right" nowrap="nowrap" class="fileLabel" >Inicio Rev.:</td>
		<td>
			<cfif isdefined("rsForm.GATfechainirev") and len(trim(rsForm.GATfechainirev)) gt 0 and rsForm.GATfechainirev gt 0>
				<cfset fecha = rsForm.GATfechainirev>
			<cfelse>
				<cfset fecha = Now()>
			</cfif>
			<cf_sifcalendario name="GATfechainirev" value="#LSDateFormat(fecha,'dd/mm/yyyy')#" tabindex="2">		</td>
	  </tr>
	  <tr>
	  	<td align="right" nowrap="nowrap" class="fileLabel">Fecha:</td>
		<td>
			<cfif isdefined("rsForm.GATfecha") and len(trim(rsForm.GATfecha)) gt 0 and rsForm.GATfecha gt 0>
				<cf_sifcalendario id="GATfecha" name="GATfecha" value="#LSDateFormat(rsForm.GATfecha,'dd/mm/yyyy')#" tabindex="2">
			<cfelse>
				<cf_sifcalendario id="GATfecha" name="GATfecha" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="2">
			</cfif>		</td>
		<td>&nbsp;</td>
		<td align="right" nowrap="nowrap" class="fileLabel">Referencia.:</td>
		<td>
			<input type="text" id="GATreferencia" name="GATreferencia" 
					<cfif isdefined("rsForm.GATreferencia") and len(trim(rsForm.GATreferencia)) gt 0 and rsForm.GATreferencia gt 0>
						value="#rsForm.GATreferencia#"
					</cfif> 
					size="60" maxlength="50" tabindex="2"
			/>
		</td>		
	  </tr>
	  <tr>
        <td align="right" nowrap="nowrap" class="fileLabel">Monto:</td>
		<td>
			<cfif isdefined("rsForm.GATmonto") and len(trim(rsForm.GATmonto)) gt 0>
				<cf_inputNumber decimales="2" name="GATmonto" value="#rsForm.GATmonto#" tabindex="2" negativos="true" onChange="funcGATmonto()" onKeydown="funcGATmontoOnKeyDown(event);"> 
			<cfelse>
				<cf_inputNumber decimales="2" name="GATmonto" value="0.00" tabindex="2" negativos="true" onChange="funcGATmonto()" onKeydown="funcGATmontoOnKeyDown(event);">
			</cfif>		</td>
		<td>&nbsp;</td>
		<td align="right" nowrap="nowrap" class="fileLabel"><div id="div_retiro_label">Motivo Retiro:</div><div id="div_mejora_label">Vida &uacute;til:</div></td>
		<td>
		<div id="div_retiro">
			<select name="AFRmotivo" tabindex="2">
				<option value="">-- Seleccione uno --</option>
				<cfloop query="rsAFRmotivo">
					<option value="#rsAFRmotivo.AFRmotivo#" 
							<cfif isdefined("rsForm.AFRmotivo") and len(trim(rsForm.AFRmotivo)) gt 0 and rsForm.AFRmotivo gt 0 and rsForm.AFRmotivo eq rsAFRmotivo.AFRmotivo>selected</cfif>>
						#rsAFRmotivo.AFRmotivo#-#rsAFRmotivo.AFRdescripcion#
					</option>
				</cfloop>
			</select>
		</div>
		<div id="div_mejora">
			<cfif isdefined("rsForm.GATvutil") and len(trim(rsForm.GATvutil)) gt 0>
				<cf_inputNumber name="GATvutil" value="#rsForm.GATvutil#" tabindex="2" decimales="0">
			<cfelse>
				<cf_inputNumber name="GATvutil" tabindex="2" decimales="0">
			</cfif>
		</div></td>
	  </tr>
	  <tr><td colspan="5">&nbsp;</td></tr>
	</table>
	<cfif modo NEQ "ALTA">
		<cfset include_MasBotones = ", Ir a Conciliar, Siguiente">
		<cfset includevalues_MasBotones = ",Conciliar,Siguiente">
	<cfelse>
		<cfset include_MasBotones = "">
		<cfset includevalues_MasBotones = "">
	</cfif>
	<cf_botones modo="#modo#" include="Completar,Lista,Limpiar#includevalues_MasBotones#" includevalues="Completar,Lista,Limpiar#include_MasBotones#" tabindex="2">
	<br />
</form>
<script language="javascript" type="text/javascript">
	<!--//
		//funcion onValidate
		function fnX(){
			if (!objForm._allowSubmitOnError) {
				objForm.AFRmotivo.description = "Motivo de Retiro";
				objForm.GATvutil.description = "Vida útil";
				if (parseFloat(qf(objForm.GATmonto.getValue()))<0 && objForm.tipoTransaccion.getValue()<2)
					objForm.GATmonto.throwError('El campo ' + objForm.GATmonto.description + ' no puede ser negativo cuando realiza una adquisición o una mejora.');
				if (parseFloat(qf(objForm.GATmonto.getValue()))>0 && objForm.tipoTransaccion.getValue()==2)
					objForm.GATmonto.throwError('El campo ' + objForm.GATmonto.description + ' no puede ser positivo cuando realiza un retiro.');
				if (parseFloat(qf(objForm.GATmonto.getValue()))<0 && objForm.Aid.getValue()!="" && objForm.AFRmotivo.getValue()=="")
					objForm.AFRmotivo.throwError('El campo ' + objForm.AFRmotivo.description + ' es requerido cuando está realizando un retiro.');
				if (parseFloat(qf(objForm.GATmonto.getValue()))>0 && objForm.Aid.getValue()!="" && objForm.GATvutil.getValue()=="")
					objForm.GATvutil.throwError('El campo ' + objForm.GATvutil.description + ' es requerido cuando está realizando una mejora.');
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
<cf_qforms form="form1" onValidate="fnX" onsubmit="fnY">
	<cf_qformsRequiredField args="GATperiodo,Periodo">
	<cf_qformsRequiredField args="GATmes,Mes">
	<cf_qformsRequiredField args="Cconcepto,Concepto">
	<cf_qformsRequiredField args="Edocumento,Documento">
	
	<cf_qformsRequiredField args="CFcuenta,Cuenta">
	
	<cf_qformsRequiredField args="ACcodigo,Categoria">
	<cf_qformsRequiredField args="ACid,Clase">
	<cf_qformsRequiredField args="GATplaca,Placa">
	<cf_qformsRequiredField args="GATdescripcion,Descripcion">
	
	<cf_qformsRequiredField args="AFMid,Marca">
	<cf_qformsRequiredField args="AFMMid,Modelo">
	<cf_qformsRequiredField args="AFCcodigo,Tipo">
	
	<cf_qformsRequiredField args="GATfechainidep,Fecha de Inicio de Depreciacion">
	<cf_qformsRequiredField args="GATfechainirev,Fecha de Inicio de Revaluacion">
	<cf_qformsRequiredField args="GATmonto,Monto">
	
	<cf_qformsRequiredField args="CRCCid,Centro Custodia">
	<cf_qformsRequiredField args="GATfecha,Fecha">
	<cf_qformsRequiredField args="CFid,Centro Funcional">
	<cf_qformsRequiredField args="DEid,Responsable">
	<cf_qformsRequiredField args="CRTDid,Tipo de Documento">
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
			objForm.ACid.obj.value=''; objForm.ACcodigodesc_clas.obj.value=''; objForm.ACdescripcion_clas.obj.value='';
			CambiarMascara();
		}
		function resetModelo(){
			objForm.AFMMid.obj.value=''; objForm.AFMMcodigo.obj.value=''; objForm.AFMMdescripcion.obj.value='';
		}
		function resetCFuncional(){
			objForm.CFid.obj.value=''; objForm.CFcodigo.obj.value=''; objForm.CFdescripcion.obj.value='';
			resetEmpleado();
		}
		function resetEmpleado(){
			objForm.DEid.obj.value=''; objForm.DEidentificacion.obj.value=''; objForm.DEnombrecompleto.obj.value='';
		}
		function CambiarMascara(){
			var mascara = "";
			objForm.GATplaca.obj.value="";
			objForm.GATplaca_text.obj.value="";
			lastReadOnly = objForm.GATplaca.obj.readOnly;
			mascara = objForm.ACmascara.getValue();
			if (mascara.length> 0) {
				var strErrorMsg="El valor de la placa no concuerda con el formato "+mascara;
				oStringMask.mask = mascara.replace(/X/g,"*");
				objForm.GATplaca.obj.readOnly=lastReadOnly;
				objForm.GATplaca_text.obj.value=mascara.replace(/X/g,"X");
				return true;
			}
			objForm.GATplaca.obj.readOnly=true;
			objForm.GATplaca.obj.value='';
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
			
			if (!objForm.GATplaca.obj.readOnly) {
				document.all["fr"].src="valida_placa.cfm?placa="+placa;
				return;
			}
			
		}
		function CargarPlaca() {
			var aid = objForm.Aid.getValue();
			if (aid!=''){
				document.all["fr"].src="valida_placa.cfm?aid="+aid;
			}
		}
		<cfif (modo neq "ALTA")>
		function funcConciliar(){
			document.location.href="Conciliacion.cfm?GATPeriodo=#Form.GATPeriodo#&GATmes=#Form.GATMes#&Cconcepto=#Form.Cconcepto#&Edocumento=#Form.Edocumento#&Ocodigo=#rsform.Ocodigo#&CFcuenta=#rsForm.CFcuenta#";
			return false;
		}
		</cfif>
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
			if (objForm.tipoTransaccion.getValue()==0) {
				setReadOnly(false);
			} else {
				_div_activo.style.display='';
				if (objForm.tipoTransaccion.getValue()==1) {
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
		<cfif MODO neq "ALTA" and isdefined("rsForm.GATplaca") and len(trim(rsForm.GATplaca))>
			objForm.GATplaca.obj.value="#Trim(rsForm.GATplaca)#";
			<cfif isdefined("rsActivo.Aid") and len(trim(rsActivo.Aid)) gt 0 and rsActivo.Aid gt 0>
				setReadOnly(true);
			</cfif>
		</cfif> 
		objForm.tipoTransaccion.obj.focus();
		//-->
	</script>
</cfoutput>
<cfparam name="Attributes.prefix"  default="">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Almacen" default="Almac&eacute;n" returnvariable="LB_Almacen" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tipo" default="Tipo" returnvariable="LB_Tipo" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tax" default="Impuesto" returnvariable="LB_Tax" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CentroFuncional" default="Centro Funcional" returnvariable="LB_CentroFuncional" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Articulo" default="Articulo" returnvariable="LB_Articulo" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Servicio" default="Servicio" returnvariable="LB_Servicio" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DescripcionAlterna" default="Descripcion Alterna" returnvariable="LB_DescripcionAlterna" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cantidad" default="Cantidad" returnvariable="LB_Cantidad" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PrecioUnitario" default="Precio Unitario" returnvariable="LB_PrecioUnitario" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Exportacion" default="Exportación" returnvariable="LB_Exportacion" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ObjImp" default="Objeto Impuesto" returnvariable="LB_ObjImp" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descuento" default="Descuento" returnvariable="LB_Descuento" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Total" default="Total" returnvariable="LB_Total" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DeseaEliminarEstaLineaDeDetalleDeCotizacion" default="¿Desea eliminar esta l&iacute;nea de detalle de cotizaci&oacute;n?" returnvariable="MSG_DeseaEliminarEstaLineaDeDetalleDeCotizacion" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_ElCampoNoPuedeSerMayorACienNiMenorQueCero" default="El campo no puede ser mayor a 100 ni menor que cero" returnvariable="MSG_ElCampoNoPuedeSerMayorACienNiMenorQueCero" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_NoPuedeHaberCantidadPrecioUnitarioTotalDeLineaEnCero" default="No puede haber Cantidad, Precio Unitario o Total de Linea en 0" returnvariable="MSG_NoPuedeHaberCantidadPrecioUnitarioTotalDeLineaEnCero" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Error_Cantidad" default="Falta ingresar la Cantidad" returnvariable="Error_Cantidad" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Error_PrecioUnitario" default="Falta ingresar el Precio Unitario" returnvariable="Error_PrecioUnitario" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Error_Total" default="Falta ingresar el Total" returnvariable="Error_Total" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Error_CF" default="Falta ingresar el Centro Funcional" returnvariable="Error_CF" xmlfile="FAprefacturaDet-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Error_Cuenta" default="Falta ingresar la Cuenta" returnvariable="Error_Cuenta" xmlfile="FAprefacturaDet-form.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Retenciones" default="Retenciones" returnvariable="LB_Retenciones" xmlfile="FAprefacturaDet-form.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MRetenciones" default="Retenciones" returnvariable="LB_MRetenciones" xmlfile="FAprefacturaDet-form.xml">
<cfquery name="rsImpuestos1" datasource="#Session.DSN#">
	select ltrim(rtrim(Icodigo)) as Icodigo, Idescripcion, Iporcentaje, ieps, IEscalonado, TipoCalculo, ValorCalculo,Icreditofiscal
	from Impuestos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<!---<cfquery name="rsRetenciones1" datasource="#Session.DSN#">
	select * from Retenciones
	where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>--->
<!-- Querys AFGM CONTROL DE VERSIONES-->
<cfquery name="rsPCodigoOBJImp" datasource = "#Session.DSN#">
	select Pvalor 
	from Parametros
	where Pcodigo = '17200'
		and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset value = "#rsPCodigoOBJImp.Pvalor#">

<cfquery name="rsNumDecimales" datasource = "#Session.DSN#">
	select Pvalor
	from Parametros
	where Pcodigo = '17300'
		and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset valordecimal = "#rsNumDecimales.Pvalor#">

<cfif value eq '4.0'>
	<cfquery name="rslistaObjImp" datasource = "#Session.DSN#">
		select IdObjImp,CSATcodigo,
				CSATdescripcion,
				CSATfechaVigencia,
				CSATestatus
		from CSATObjImpuesto 
	</cfquery>
</cfif>


<cfset numRemplazables = "">
<cfset valorValue = "">

<cfif valordecimal eq 1>
<cfset numRemplazables = "_._">
<cfset valorValue = "0.0">
<cfelseif valordecimal eq 2>
<cfset numRemplazables = "_.__">
<cfset valorValue = "0.00">
<cfelseif valordecimal eq 3>
<cfset numRemplazables = "_.___">
<cfset valorValue = "0.000">
<cfelseif valordecimal eq 4>
<cfset numRemplazables = "_.____">
<cfset valorValue = "0.0000">
<cfelseif valordecimal eq 5>
<cfset numRemplazables = "_._____">
<cfset valorValue = "0.00000">
<cfelseif valordecimal eq 6>
<cfset numRemplazables = "_.______">
<cfset valorValue = "0.000000">
<cfelseif valordecimal eq ''>
<cfset numRemplazables = "_.__">
<cfset valorValue = "0.00">
</cfif>
<!-- Fin Querys AFGM -->


<cfquery name="rsRetenciones1" datasource="#Session.DSN#">
	select rtrim(ltrim(Icodigo)) as Rcodigo, IDescripcion as RDescripcion, Iporcentaje as Rporcentaje from Impuestos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and IRetencion = 1
</cfquery>

<cfif isdefined('url.Linea') and not isdefined('form.Linea')>
	<cfparam name="form.Linea" default="#url.Linea#">
</cfif>

<cfset modoDet = 'ALTA'>
<cfif  isdefined('form.Linea') and len(trim(form.Linea))>
	<cfset modoDet = 'CAMBIO'>
</cfif>

<cfif modoDet NEQ 'ALTA'>
	<cfquery name="rsPintaCuentaParametro" datasource="#session.DSN#">
		select Pcodigo, Pvalor, Pdescripcion
		from  Parametros
		where Ecodigo =  #Session.Ecodigo#
		and Pcodigo =2
	</cfquery>

    <cfquery name="rsFormDet" datasource="#session.DSN#">
		Select
			IDpreFactura,
			Linea,
			Cantidad,
			TipoLinea,
			Cantidad * PrecioUnitario as SubTotal,
			Aid,
			Alm_Aid,
			Cid,
            Ccuenta,
            fd.CFid,
            CFcodigo as CFcodigoresp, 
			CFdescripcion as CFdescripcionresp,
			ltrim(rtrim(Icodigo)) as Icodigo,
			Descripcion,
            Descripcion_Alt,
			PrecioUnitario,
			DescuentoLinea,
			TotalLinea,
			fd.BMUsucodigo,
			fechaalta,
			fd.ts_rversion,
			fd.codIEPS,
			fd.FAMontoIEPSLinea,
			fd.afectaIVA,
			fd.Rcodigo,
			fd.IdImpuesto as IdObjetoImp
		from FAPreFacturaD fd
        	inner join CFuncional cf
            on fd.Ecodigo = cf.Ecodigo and fd.CFid = cf.CFid
		where Linea = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Linea#">
		and IDpreFactura = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDpreFactura#">
	</cfquery>


	<cfif isdefined('rsFormDet') and rsFormDet.Icodigo NEQ ''>
		<cfquery name="rsImpuestos" datasource="#Session.DSN#">
			select Icodigo,Idescripcion,Iporcentaje, ieps, IEscalonado, TipoCalculo, ValorCalculo
			from Impuestos
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Icodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#rsFormDet.Icodigo#">
		</cfquery>
	</cfif>
	<cfif isdefined('rsFormDet') and rsFormDet.Rcodigo NEQ ''>
		<cfquery name="rsRetenciones" datasource="#Session.DSN#">
			select * from Retenciones
			where Ecodigo =  #Session.Ecodigo#
			and Rcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#rsFormDet.Rcodigo#">
		</cfquery>
	</cfif>


</cfif>

<cfquery name="rsAlmacenes" datasource="#Session.DSN#">
	select Ocodigo, convert(varchar,Aid) as Aid, Bdescripcion
	from Almacen
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		<cfif isdefined('rsForm.Ocodigo') and rsForm.Ocodigo NEQ ''>
			and Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.Ocodigo#">
		</cfif>
</cfquery>

<cfquery name="rsverCalsificaCC" datasource="#Session.DSN#">
	select Pvalor as verClasificaCC
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Pcodigo = 680
</cfquery>

<cfif isdefined("rsverCalsificaCC") and  rsverCalsificaCC.Recordcount NEQ 0>
	<cfset verClasCC = rsverCalsificaCC.verClasificaCC>
<cfelse>
	<cfset verClasCC = 0>
</cfif>

<!---<cf_dump var="#rsForm#">--->
<cfoutput>
<form name="formDetCoti" id="formDetCoti" method="post" action="FAprefactura-sql.cfm" onSubmit="enableIieps(); javascript: return valida();">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
   	   <td align="right">
			<div id="idArt_2L" <cfif modoDet NEQ 'ALTA' AND rsFormDet.TipoLinea EQ 'S'> style="display:none" </cfif>>
				<strong>#LB_Almacen#:&nbsp;</strong>
			</div>
		</td>
	    <td>
			<div id="idArt_2" <cfif modoDet NEQ 'ALTA' AND rsFormDet.TipoLinea EQ 'S'> style="display:none" </cfif>>
	            <cfif modoDet neq 'ALTA'>
					<cf_sifalmacen form="formDetCoti" id="#rsFormDet.Alm_Aid#" size="30" aid="Almacen" tabindex="18" Acodigo="Acodigo">
				<cfelse>
					<cf_sifalmacen form="formDetCoti" size="30" aid="Almacen" tabindex="18" Acodigo="Acodigo">
			    </cfif>
			</div>
		</td>
    </tr>
    <tr>
        <td align="right"><strong>#LB_Tipo#:&nbsp;</strong></td>
        <td><select name="TipoLinea" onChange="javascript: cambioTipoL(this);" tabindex="17" style="width: 146px">
          <option value="A" <cfif modoDet NEQ 'ALTA' and rsFormDet.TipoLinea EQ 'A'> selected</cfif>>#LB_Articulo#</option>
          <option value="S" <cfif modoDet NEQ 'ALTA' and rsFormDet.TipoLinea EQ 'S'> selected</cfif>>#LB_Servicio#</option>
        </select>
        </td>
        <td align="right">
			<div id="idArt_1L" <cfif modoDet NEQ 'ALTA' AND rsFormDet.TipoLinea EQ 'S'> style="display:none" </cfif>>
				<strong>#LB_Articulo#:&nbsp;</strong>
			</div>
			<div id="idServL" <cfif (modoDet NEQ 'ALTA' AND rsFormDet.TipoLinea EQ 'A') OR modoDet EQ 'ALTA'> style="display:none" </cfif>>
				<strong>#LB_Servicio#:&nbsp;</strong>
			</div>
		</td>
        <td>
			<div id="idArt_1" <cfif modoDet NEQ 'ALTA' AND rsFormDet.TipoLinea EQ 'S'> style="display:none" </cfif>>
				<cfif modoDet neq 'ALTA' and rsFormDet.TipoLinea EQ 'A'>
					<cfquery name="rsArticulo" datasource="#session.DSN#">
						select Aid, Acodigo, Adescripcion
						from Articulos
						where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDet.Aid#">
					</cfquery>
					<cf_sifarticulos tabindex="19" form="formDetCoti" query=#rsArticulo# validarExistencia="1" size="22">
				<cfelse>
					<cf_sifarticulos tabindex="19" form="formDetCoti" validarExistencia="1" size="22">
				</cfif>
			</div>
			<div id="idServ" <cfif (modoDet NEQ 'ALTA' AND rsFormDet.TipoLinea EQ 'A') OR modoDet EQ 'ALTA'> style="display:none" </cfif>>
				<cfif modoDet neq 'ALTA' and rsFormDet.TipoLinea EQ 'S'>
					<cfquery name="rsConcepto" datasource="#session.DSN#">
						select Cid, Ccodigo, Cdescripcion
						from Conceptos
						where Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDet.Cid#">
					</cfquery>
					<cf_sifconceptos tabindex="18" form="formDetCoti" query=#rsConcepto# size="22" verClasificacion=#verClasCC# validarExistencia="1">
				<cfelse>
					<cf_sifconceptos tabindex="18" form="formDetCoti" size="22" verClasificacion=#verClasCC# validarExistencia="1">
				</cfif>
			</div>
		</td>
      </tr>

      <tr>
        <td align="right"><strong>#LB_Descripcion#:&nbsp;</strong></td>
        <td><input name="Descripcion" tabindex="20" type="text" id="Descripcion" onFocus="javascript: this.select();" value="<cfif modoDet NEQ 'Alta'>#rsFormDet.Descripcion#</cfif>" size="44" maxlength="80" <cfif mododet neq 'alta'> readonly="true"</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;</td>

        <td align="right" nowrap><strong>&nbsp;&nbsp;#LB_DescripcionAlterna#:&nbsp;</strong></td>
        <td><input name="Descripcion_Alt" tabindex="21" type="text" id="Descripcion_Alt" onFocus="javascript: this.select();" value="<cfif modoDet NEQ 'Alta'>#rsFormDet.Descripcion_Alt#</cfif>" size="36" maxlength="80" ></td>

		<td align="right"><strong>#LB_Cantidad#:&nbsp;</strong></td>
        <td><input name="Cantidad" type="text" id="Cantidad" <cfif modoDet NEQ 'Alta'> value="#LSNumberFormat(rsFormDet.Cantidad,',9.00')#"<cfelse> value="1"</cfif> style="text-align: right" size="20" maxlength="18" tabindex="25" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();} calcTotal();}; calculaIEPS();"></td>
     </tr>

     <tr>
		<td align="right"><strong>#LB_Cuenta#:&nbsp;</strong></td>
        <td colspan="3">
				<cfif modo NEQ "ALTA" AND isdefined('rsFormDet') AND rsFormDet.Ccuenta NEQ ''>
                	<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#rsFormDet#" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="Ccuenta" cdescripcion="CdescripcionD"  cmayor="CmayorD" cformato="CformatoD" form="formDetCoti"
					tabindex="22">
				<cfelse>
                    <cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="Ccuenta" cdescripcion="CdescripcionD"  cmayor="CmayorD" cformato="CformatoD" form="formDetCoti"
					tabindex="22">
				</cfif>
		</td>
        <td align="right" nowrap><strong>#LB_PrecioUnitario#:&nbsp;</strong></td>
        <td><input name="PrecioUnitario" type="text" id="PrecioUnitario" <cfif modoDet NEQ 'Alta'> value="#LSNumberFormat(rsFormDet.PrecioUnitario,',#numRemplazables#')#"<cfelse> value="#valorValue#"</cfif> style="text-align: right" size="20" maxlength="18" tabindex="26" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,#valordecimal#);"  onKeyUp="if(snumber(this,event,#valordecimal#)){ if(Key(event)=='13') {this.blur();}calcTotal();}; calculaIEPS();"></td>
      </tr>

			<!---Versión 4.0 CoinList que muestra Objeto Impuesto --->
			<cfif value eq "4.0">		
				<td align="right"><strong>#LB_ObjImp#:&nbsp;</strong></td>
				<td nowrap>
					<cfset valuesArray = ArrayNew(1)>
					<cfif isDefined("rsFormDet.IDpreFactura") AND LEN(TRIM(rsFormDet.IDpreFactura)) GT 0>	   
						<cfquery name="rsObjetoImp" datasource="#session.DSN#">
							select facd.IdImpuesto,CSATdescripcion,CSATcodigo 
							from FAPreFacturaD facd
							inner join CSATObjImpuesto obp
							on facd.IdImpuesto=obp.IdObjImp
							where facd.IDpreFactura=#rsFormDet.IDpreFactura#
							and linea=#rsFormDet.linea#
							and facd.Ecodigo=#Session.Ecodigo#
							</cfquery>
						<cfif rsObjetoImp.RecordCount GT 0>

							<cfset ArrayAppend(valuesArray, '#trim(rsObjetoImp.IdImpuesto)#')>
							<cfset ArrayAppend(valuesArray, '#trim(rsObjetoImp.CSATcodigo)#')>
							<cfset ArrayAppend(valuesArray, '#trim(rsObjetoImp.CSATdescripcion)#')>
							</cfif>
					</cfif>				
							
						<cf_conlis title="Objeto Impuesto"
							alt = "El campo Objeto Impuesto" 
					     	campos = "#Attributes.prefix#idImp,#Attributes.prefix#codImp,#Attributes.prefix#descImp"
							desplegables = "N,S,S"
							modificables = "N,N,N"
							filtro = "CSATestatus = 1"
							size = "4,5,32"
							tabla="CSATObjImpuesto"
							columnas="IdObjImp as #Attributes.prefix#idImp, CSATcodigo as #Attributes.prefix#codImp, CSATdescripcion as #Attributes.prefix#descImp "
							desplegar="#Attributes.prefix#codImp,#Attributes.prefix#descImp"
							etiquetas="Codigo,Estado"
							formatos="S,S"
							align="left,left"
							asignar="#Attributes.prefix#idImp,#Attributes.prefix#codImp, #Attributes.prefix#descImp"
							asignarformatos="S,S"
							showEmptyListMsg="true"
							debug="false"
							tabindex="1"
							form="formDetCoti"
							conexion="#session.dsn#"
							filtrar_por="#Attributes.prefix#codImp,#Attributes.prefix#descImp"
							valuesArray="#valuesArray#"
							readonly
							>
				</td>
			</tr>
			<!---Si la version es 3.3 hace esto, no muestra  --->
			<cfelseif value eq "3.3">
			
			</cfif>
			<tr>
      <tr>
        <td align="right"><strong>#LB_Impuesto#:&nbsp;</strong></td>
        <td nowrap>
			<select name="Icodigo" id="Icodigo" onclick="rslistmod()" tabindex="23" style="width: 146px">
				<cfloop query="rsImpuestos1">
					<cfif #rsImpuestos1.ieps# NEQ 1>
						<option value="#rsImpuestos1.Icodigo#" <cfif modoDet NEQ 'ALTA' and rsImpuestos1.Icodigo EQ rsFormDet.Icodigo>selected</cfif>>#rsImpuestos1.Icodigo# - #rsImpuestos1.Idescripcion#</option>
					</cfif>
				</cfloop>
						
			</select>
			<!--- <input type="hidden" formDetCoti name="Icodigo" value="<cfif modoDet NEQ 'Alta'>#rsFormDet.Icodigo#</cfif>"> 
			<input class="form-control" name="prueba" id="prueba" type="text" value="IVA0" readonly>--->
			<input type="hidden" name="Iporcen" value="<cfif modoDet NEQ 'Alta' and isdefined('rsImpuestos') and rsImpuestos.recordCount GT 0>#rsImpuestos.Iporcentaje#</cfif>">
		</td> 
		
		<td colspan="2">
        <td align="right" nowrap><strong>#LB_Descuento#:&nbsp;</strong> </td>
        <td><input name="DescuentoLinea" type="text" id="DescuentoLinea" style="text-align: right" size="20" maxlength="18" tabindex="27" <cfif modoDet NEQ 'Alta'> value="#LSNumberFormat(rsFormDet.DescuentoLinea,',9.00')#"<cfelse> value="0.00"</cfif>  onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();} calcTotal();}; calculaIEPS();">
        </td>
		
				
    </tr>
		<tr><!--- JARR revisar Retenciones --->
        <td align="right"><strong>#LB_Retenciones#:&nbsp;</strong></td>
        <td nowrap>

        	<!--- <cfdump var="#rsRetenciones1#">
        	<cfdump var="#rsFormDet#"> --->
        	<cfset RPorD=0>
			<select name="RcodigoD" id="RcodigoD" tabindex="23" style="width: 146px">
			  <option value = "-1">--Sin Retenci&oacute;n--</option>
				<cfloop query="rsRetenciones1">
					<!----<cfif #rsRetenciones1.Rcodigo# NEQ 1>--->
						<option value="#rsRetenciones1.Rcodigo#" <cfif modoDet NEQ 'ALTA' and rsRetenciones1.Rcodigo EQ rsFormDet.Rcodigo>  <cfset RPorD=rsRetenciones1.Rporcentaje>selected</cfif>>#rsRetenciones1.Rcodigo# - #rsRetenciones1.Rdescripcion#</option>
					<!---</cfif>--->
				</cfloop>
			</select>
			<!--- <input type="hidden" name="Icodigo" value="<cfif modoDet NEQ 'Alta'>#rsFormDet.Icodigo#</cfif>"> --->
			
		</td>
		<td colspan="2">
        <td align="right" nowrap><strong>#LB_MRetenciones#:&nbsp;</strong></td>
        <td><input type="text" name="Rmonto" 
        style="text-align: right; font-weight:normal; background-color: ##D8D8D8; border-style: solid; border-color: ##585858; color: ##585858; border-width: 1px; width: 146px;"
        value="<cfif modoDet NEQ 'Alta' and rsFormDet.Rcodigo gt 1>#LSNumberFormat(rsFormDet.TotalLinea* (RPorD/100),',9.00')#  </cfif>" readOnly>
        </td>
       <!---  <td><input name="Rmonto" type="text" id="Rmonto" style="text-align: right" size="20" maxlength="18" tabindex="27" <cfif modoDet NEQ 'Alta'> value="#LSNumberFormat(rsFormDet.Rmonto,',9.00')#"<cfelse> value="0.00"</cfif>  onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();} calcTotal();}; calculaIEPS();">
        </td> --->
    </tr>
	<tr>
	<td align="right"><strong>#LB_Ieps#:&nbsp;</strong></td>
        <td nowrap>
			<select name="Iieps" id="Iieps" tabindex="23" style="width: 146px" onChange="calculaIEPS(); calcTotal(); asignaAfectaIVA();">
				<option value=-1>--Sin IEPS--</option>
				<cfloop query="rsImpuestos1">
					<cfif #rsImpuestos1.ieps# EQ 1>
						<option value="#trim(rsImpuestos1.Icodigo)#" <cfif modoDet NEQ 'ALTA' and rsImpuestos1.Icodigo EQ rsFormDet.CodIEPS>selected</cfif>>#rsImpuestos1.Icodigo# - #rsImpuestos1.Idescripcion#</option>
					</cfif>
				</cfloop>
			</select>
			<input name="IEscalonado" id="IEscalonado" type="hidden" value="<cfif modoDet NEQ 'ALTA' and rsFormDet.afectaIVA NEQ ''>#rsFormDet.afectaIVA#<cfelse>0</cfif>">
		</td>
	<td colspan="2">
        <td align="right" nowrap><strong>#LB_Ieps#:&nbsp;</strong> </td>
        <td><input name="IepsLinea" type="text" id="IepsLinea" <cfif modoDet NEQ 'Alta'> value="#LSNumberFormat(rsFormDet.FAMontoIEPSLinea,',999999999.00')#"<cfelse> value="0.00"</cfif> style="text-align: right; font-weight:normal; background-color: ##D8D8D8; border-style: solid; border-color: ##585858; color: ##585858; border-width: 1px; width: 146px;" maxlength="18" tabindex="27" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();} calcTotal();}" readOnly>
        </td>
	</tr>
      <tr>
        <td nowrap="nowrap" style="text-align: right"><strong>#LB_CentroFuncional#:&nbsp;</strong></td>
        <td colspan="3">
	    	<cfif modoDet neq 'ALTA'>
				<cf_rhcfuncional size="30" name="CFcodigoresp" desc="CFdescripcionresp" titulo="Seleccione el Centro Funcional Responsable" query="#rsFormDet#" tabindex="24" form="formDetCoti">
		  	<cfelse>
				<cf_rhcfuncional size="30"  name="CFcodigoresp" desc="CFdescripcionresp" titulo="Seleccione el Centro Funcional Responsable" excluir="-1" tabindex="24" form="formDetCoti">
			</cfif>
        </td>
        <td align="right"><strong>#LB_Total#:&nbsp;</strong></td>
        <td><input name="TotalLinea" readonly="true" type="text" id="TotalLinea2" <cfif modoDet NEQ 'Alta'> value="#LSNumberFormat(rsFormDet.TotalLinea,',9.00')#"<cfelse> value="0.00"</cfif> style="text-align: right" size="20" maxlength="18" tabindex="28" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" onchange="{this.blur();}}"></td>
      </tr>
      <tr>
        <td colspan="6" align="center">
			<input type="hidden" name="IDpreFactura" id="IDpreFactura" value="#form.IDpreFactura#">

			<input type="hidden" name="ts_rversion" value="#ts#">
			<cfif modoDet neq 'ALTA'  >
				<cfset tsDet = "">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
					artimestamp="#rsFormDet.ts_rversion#" returnvariable="tsDet">
				</cfinvoke>
				<input type="hidden" name="ts_rversionDet" value="#tsDet#">

				<input type="hidden" name="Linea" value="#form.Linea#">

				<cfif rsForm.Estatus EQ 'P'>
					<cf_botones tabindex="29" modo='CAMBIO' sufijo="Det">
				</cfif>
			<cfelse>
				<cfif rsForm.Estatus EQ 'P'>
					<cf_botones tabindex="29" modo='ALTA' sufijo="Det">
				</cfif>
			</cfif>
		</td>
      </tr>
    </table>
</form>
<iframe name="frSP" id="frSP" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: ;"></iframe>
</cfoutput>
<cfif value eq "4.0">
<script>
function rslistmod(){
	var varIcodigo =document.getElementById('Icodigo').value;
	//console.log(varIcodigo);
	//document.getElementById('prueba').value = varIcodigo;	
	//var valortxt = posicion
	if(varIcodigo !== ''){
		$.ajax({
			method: "post",
			url: "../Componentes/FA_Facturacion.cfc",
			async:false,
			data: {
				method: "fnValidaObjImpuesto",
				Icodigo: varIcodigo,
				returnFormat: "JSON"
			},
			success: function(data) {
				// Parse the returned json data
				var opts = $.parseJSON(data);
				//console.log(opts);
				$.each(opts, function(i, d) {
					console.log(d.IDOBJIMP);
					console.log(d.CSATCODIGO);
					console.log(d.CSATDESCRIPCION);
					document.getElementById('idImp').value = d.IDOBJIMP;
					document.getElementById('codImp').value = d.CSATCODIGO;
					document.getElementById('descImp').value = d.CSATDESCRIPCION;
					
				});
			}
		});
	}
}
</script>
</cfif>

<cf_qforms form="formDetCoti" objForm="objFormDet">
<!--- <script type="text/javascript" src="/jquery/librerias/jquery-1.11.1.min.js"></script> --->
<script language="javascript" type="text/javascript">
	function cambioAlmacen(cb){
		if(document.formDetCoti.Almacen.value != ''){

		}
	}

	function funcAcodigo(){
		if(document.formDetCoti.Aid.value != ''){
			if(document.formDetCoti.Adescripcion.value != '')
				document.formDetCoti.Descripcion.value = document.formDetCoti.Adescripcion.value;
		}else{
			funcExtraAcodigo();
		}
	}

	function funcExtraCcodigo(){
		funcExtraAcodigo();
	}

	function funcExtraAcodigo(){
		document.formDetCoti.PrecioUnitario.value = '0.00';
		document.formDetCoti.Icodigo.value = '';
		document.formDetCoti.Descripcion.value = '';
		document.formDetCoti.DescuentoLinea.value = '0.00';
		document.formDetCoti.TotalLinea.value = '0.00';
	}


	function funcCcodigo(){
		//<!---funcCcodigo2();--->//Lo comenté dado que por el momento no se usa en Clear Channel
		if(document.formDetCoti.Cid.value != ''){
			if(document.formDetCoti.Cdescripcion.value != '')
				document.formDetCoti.Descripcion.value = document.formDetCoti.Cdescripcion.value;
			$.ajax({
		   		type: "POST",
				url: "/cfmx/sif/fa/operacion/FAprefactura-sql.cfm",
				async:false,  
				data: {validCuentaConcepto:document.formDetCoti.Cid.value},
		   		success: function(result){
					var objError = JSON.parse(result);
					if(objError == 'OLD' || objError == 'NEW'){
						$.ajax({
		   	  					type: "POST",
			                    url: "/cfmx/sif/fa/operacion/FAprefactura-sql.cfm",
								async:false,  
								data: {getCuentaConcepto:document.formDetCoti.Cid.value},
		   						success: function(result){
		   						var obj = JSON.parse(result);
									$('#CmayorD').val(obj.CMAYOR);
									$('#CformatoD').val(trim(obj.CFORMATO.substring(5, obj.CFORMATO.length)));
									$('#Ccuenta').val(obj.CCUENTA);
		   							$('#CdescripcionD').val(obj.CDESCRIPCION);
              					}
		   				});	
					}
					else{
						alert(objError);
					}
               }
		   	});
				
			
		}else{
			funcExtraCcodigo();
		}
	}

	function valida(){
		document.formDetCoti.Cantidad.value = qf(document.formDetCoti.Cantidad.value);
		document.formDetCoti.PrecioUnitario.value = qf(document.formDetCoti.PrecioUnitario.value);
		document.formDetCoti.DescuentoLinea.value = qf(document.formDetCoti.DescuentoLinea.value);
		document.formDetCoti.TotalLinea.value = qf(document.formDetCoti.TotalLinea.value);
		return true;
	}

	function calcTotal(){
		if(document.formDetCoti.Cantidad.value == "") document.formDetCoti.Cantidad.value = "0.00"
		if(document.formDetCoti.PrecioUnitario.value == "") document.formDetCoti.PrecioUnitario.value = "0.00"
		if(document.formDetCoti.DescuentoLinea.value == "") document.formDetCoti.DescuentoLinea.value = "0.00"
		if (document.formDetCoti.Cantidad.value=="-" ){
			document.formDetCoti.Cantidad.value = "0.00"
			document.formDetCoti.TotalLinea.value = "0.00"
		}
		if (document.formDetCoti.PrecioUnitario.value=="-" ){
			document.formDetCoti.PrecioUnitario.value = "0.00"
			document.formDetCoti.TotalLinea.value = "0.00"
		}
		if (document.formDetCoti.DescuentoLinea.value=="-" ){
			document.formDetCoti.Descuento.value = "0.00"
			document.formDetCoti.TotalLinea.value = "0.00"
		}

		var cantidad = new Number(qf(document.formDetCoti.Cantidad.value))
		var precio = new Number(qf(document.formDetCoti.PrecioUnitario.value))
		var descuento = new Number(qf(document.formDetCoti.DescuentoLinea.value))
		var seguir = "si"

		if(cantidad < 0){
			document.formDetCoti.Cantidad.value="0.00"
			seguir = "no"
		}

		if(precio < 0){
			document.formDetCoti.PrecioUnitario.value="0.00"
			seguir = "no"
		}

		if(descuento < 0){
			document.formDetCoti.DescuentoLinea.value="0.00"
			seguir = "no"
		}

		if(descuento > cantidad*precio){
			ieps();
			document.formDetCoti.DescuentoLinea.value="0.00"
			if(varTipoIEPS == 1 && varIEPSValCal > 0){
				document.formDetCoti.TotalLinea.value = (cantidad * precio) * (varIEPSValCal/100);
			}else if(varTipoIEPS == 2 && varIEPSValCal > 0){
				document.formDetCoti.TotalLinea.value = (cantidad * precio) + (varIEPSValCal);
			}else{
				document.formDetCoti.TotalLinea.value = cantidad * precio;
			}
		}
		else {
			varIEPSValCal = 0;
			varTipoIEPS = 0;
			varIEscalonado = 0;

			ieps();
			if(varTipoIEPS == 1 && varIEPSValCal > 0){
				document.formDetCoti.TotalLinea.value = redondear((((cantidad * precio) - descuento) * (1+(varIEPSValCal/100))) ,2);
				document.formDetCoti.TotalLinea.value = fm(document.formDetCoti.TotalLinea.value,2);
			}else if(varTipoIEPS == 2 && varIEPSValCal > 0){
				document.formDetCoti.TotalLinea.value = redondear(((cantidad * precio) - descuento) + (varIEPSValCal),2);
				document.formDetCoti.TotalLinea.value = fm(document.formDetCoti.TotalLinea.value,2);
			}else{
				document.formDetCoti.TotalLinea.value = redondear(((cantidad * precio) - descuento),2);
				document.formDetCoti.TotalLinea.value = fm(document.formDetCoti.TotalLinea.value,2);
			}
		}

	}

	function cambioTipoL(valor){
		if(valor.value=="A"){
			$('#idArt_1L').show('slow');
			$('#idArt_1').show('slow');
			$('#idArt_2L').show('slow');
			$('#idArt_2').show('slow');
			$('#idServL').hide('slow');
			$('#idServ').hide('slow');
			document.formDetCoti.Cantidad.value = '0.00';
			document.formDetCoti.DescuentoLinea.value = '0.00';
			document.formDetCoti.TotalLinea.value = '0.00';
			document.formDetCoti.PrecioUnitario.value = '0.00';
			document.formDetCoti.Cid.value = '';
			document.formDetCoti.Ccodigo.value = '';
			document.formDetCoti.Cdescripcion.value = '';
			document.formDetCoti.Icodigo.value = '';
			document.formDetCoti.Descripcion.value = '';
			objFormDet.Aid.required = true;
			objFormDet.Almacen.required = true;
			objFormDet.Cid.required = false;
		}
		if(valor.value=="S") {
			$('#idServL').show('slow');
			$('#idServ').show('slow');
			$('#idArt_1L').hide('slow');
			$('#idArt_1').hide('slow');
			$('#idArt_2L').hide('slow');
			$('#idArt_2').hide('slow');
			document.formDetCoti.Cantidad.value = '0.00';
			document.formDetCoti.DescuentoLinea.value = '0.00';
			document.formDetCoti.TotalLinea.value = '0.00';
			document.formDetCoti.PrecioUnitario.value = '0.00';
			document.formDetCoti.Aid.value = '';
			document.formDetCoti.Acodigo.value = '';
			document.formDetCoti.Adescripcion.value = '';
			document.formDetCoti.Almcodigo.value = '';
			document.formDetCoti.Bdescripcion.value = '';
			document.formDetCoti.Descripcion.value = '';
			objFormDet.Almacen.required = false;
			objFormDet.Aid.required = false;
			objFormDet.Cid.required = true;
		}
		<cfif modoDet EQ 'ALTA'>
			//Limpiado de objetos
			document.formDetCoti.Cid.value = '';
			document.formDetCoti.Icodigo.value = '';
			document.formDetCoti.Descripcion.value = '';
			//document.formDetCoti.Idescripcion.value = '';
			document.formDetCoti.Aid.value = '';
			document.formDetCoti.Acodigo.value = '';
			document.formDetCoti.Adescripcion.value = '';
			document.formDetCoti.Almcodigo.value = '';
			document.formDetCoti.Bdescripcion.value = '';
			document.formDetCoti.Cid.value = '';
			document.formDetCoti.Ccodigo.value = '';
			document.formDetCoti.Cdescripcion.value = '';
			document.formDetCoti.Cantidad.value = '0.00'
			document.formDetCoti.DescuentoLinea.value = '0.00'
			document.formDetCoti.TotalLinea.value = '0.00'
			document.formDetCoti.PrecioUnitario.value = '0.00'
		</cfif>
	}

    function deshabilitaValidacionDet() {
		objFormDet.Aid.required = false;
		objFormDet.Almacen.required = false;
		objFormDet.Cid.required = false;
		objFormDet.Cantidad.required = false;
		objFormDet.TipoLinea.required = false;
		objFormDet.Icodigo.required = false;
		objFormDet.PrecioUnitario.required = false;
		objFormDet.DescuentoLinea.required = false;
		objFormDet.TotalLinea.required = false;
		objFormDet.CFcodigoresp.required = false;
	}

    function funcBajaDet() {
		if(!confirm('<cfoutput>#MSG_DeseaEliminarEstaLineaDeDetalleDeCotizacion#</cfoutput>')){
			return false;
		}
		deshabilitaValidacionDet();
		return true;
	}

	// Funcion para validar que el porcentaje digitado no sea mayor a100
	function _mayor(){
		if ( (new Number(qf(this.value)) > 100) || (new Number(qf(this.value)) < 0 )){
			this.error = '<cfoutput>#MSG_ElCampoNoPuedeSerMayorACienNiMenorQueCero#</cfoutput>';
			this.value = '';
		}
	}

	function funcCambioDet() {
		if (ValidaCantidades())
		{
			var dataString = $('#formDetCoti#').serialize();
			$.ajax({
				type: "POST",
				url: "FAprefactura-sql.cfm",
				data: dataString,
				success: function(result)
				{
					$.ajax({
			            type: "POST",
			            url: "../Componentes/FA_Facturacion.cfc?method=getDetallesPrefactura",
			            async:false, 
			            data: { 'IDpreFactura': <cfoutput>#form.IDpreFactura#</cfoutput>  },
			            success: function(result){
			            	$.ajax({
						            type: "POST",
						            url: "../Componentes/FA_Facturacion.cfc?method=getDetallesPrefactura",
						            data: { 'IDpreFactura': <cfoutput>#form.IDpreFactura#</cfoutput>  },
						            success: function(result){
						            	$("#divDetalles").html(result);

						            	$.ajax({
								     		type: "POST",
								     		url: "../Componentes/FA_Facturacion.cfc?method=getTotalesGen",
								     		data: { 'IDpreFactura': <cfoutput>#form.IDpreFactura#</cfoutput>  },
								            success: function(obj){
								            	$("#div_totales").html(obj);
								            },
								            error: function(XMLHttpRequest, textStatus, errorThrown) {
							                    alert("Status: " + textStatus); alert("Error: " + errorThrown);
							                }
								    	});
						            }
						     });
			            }
			    	});

				},
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    alert("Status: " + textStatus); alert("Error: " + errorThrown);
                }
			});

			return false;
		}
		else
		{
			return false;
		}
	}

	function funcAltaDet()
	{
		if (ValidaCantidades())
		{
			<!---  //var form = $('#formDetCoti'); --->
			var dataString = $('#formDetCoti').serialize();
			$.ajax({
				type: "POST",
				url: "FAprefactura-sql.cfm",
				data: dataString,
				success: function(result)
				{
					$.ajax({
			            type: "POST",
			            url: "../Componentes/FA_Facturacion.cfc?method=getDetallesPrefactura",
			            data: { 'IDpreFactura': <cfoutput>#form.IDpreFactura#</cfoutput>  },
			            success: function(result){
			            	$.ajax({
						            type: "POST",
						            url: "../Componentes/FA_Facturacion.cfc?method=getDetallesPrefactura",
						            data: { 'IDpreFactura': <cfoutput>#form.IDpreFactura#</cfoutput>  },
						            success: function(result){
						            	$("#divDetalles").html(result);
						            	document.formDetCoti.reset();

						            	$.ajax({
								     		type: "POST",
								     		url: "../Componentes/FA_Facturacion.cfc?method=getTotalesGen",
								     		data: { 'IDpreFactura': <cfoutput>#form.IDpreFactura#</cfoutput>  },
								            success: function(obj){
								            	$("#div_totales").html(obj);
								            },
								            error: function(XMLHttpRequest, textStatus, errorThrown) {
							                    alert("Status: " + textStatus); alert("Error: " + errorThrown);
							                }
								    	});
						            }
						     });
			            }
			    	});

				},
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    alert("Status: " + textStatus); alert("Error: " + errorThrown);
                }
			});
			return false;
		}
		else
		{
			return false;
		}
	}

	function ValidaCantidades() {
		if (document.formDetCoti.CmayorD.value == '')
		{
			alert ('<cfoutput>#Error_Cuenta#</cfoutput>')
			return false;
		}
		
		if (document.formDetCoti.Cantidad.value <= 0)
		{

			alert ('<cfoutput>#Error_Cantidad#</cfoutput>')
			return false;
		}
		if (document.formDetCoti.PrecioUnitario.value <= 0)
		{

			alert ('<cfoutput>#Error_PrecioUnitario#</cfoutput>')
			return false;
		}
		if (document.formDetCoti.TotalLinea2.value <= 0)
		{

			alert ('<cfoutput>#Error_Total#</cfoutput>')
			return false;
		}
		if (document.formDetCoti.CFcodigoresp.value == '')
		{

			alert ('<cfoutput>#Error_CF#</cfoutput>')
			return false;
		}
		else
		{
			return true;
		}
	}


	// Validaciones para los campos de % no sean mayores a 100

	<cfif (modoDet NEQ 'ALTA' AND rsFormDet.TipoLinea EQ 'A') OR modoDet EQ 'ALTA'>
		objFormDet.Aid.required = true;

		objFormDet.Almacen.required = true;
	</cfif>

	objFormDet.Aid.description = "Articulo";
	objFormDet.Almacen.description = "Almacén";

	<cfif (modoDet NEQ 'ALTA' AND rsFormDet.TipoLinea EQ 'S')>
		objFormDet.Cid.required = true;
	</cfif>

	objFormDet.Cid.description = "Servicio";
	objFormDet.Cantidad.required = true;
	objFormDet.Cantidad.description = "Cantidad";

	objFormDet.TipoLinea.required = true;
	objFormDet.TipoLinea.description = "Tipo de Línea";

	objFormDet.Icodigo.required = true;
	objFormDet.Icodigo.description = "impuesto";

	objFormDet.PrecioUnitario.required = true;
	objFormDet.PrecioUnitario.description = "Precio Unitario";

	objFormDet.DescuentoLinea.required = false;
	objFormDet.DescuentoLinea.description = "Monto de Descuento";

	objFormDet.TotalLinea.required = true;
	objFormDet.TotalLinea.description = "Total de Línea";

	objFormDet.CFcodigoresp.required = true;
	objFormDet.CFcodigoresp.description = "Centro Funcional";

var varIEPSValCal = 0;
var varTipoIEPS = 0;
var varIEscalonado = 0;

<cfoutput>
<cfif isDefined('rslinea.codIEPS')>
	document.formDetCoti.codIEPSC.value = '#rslinea.codIEPS#';
</cfif>
</cfoutput>

function ieps(){
  var iI = document.formDetCoti.Iieps.value;
  <cfwddx action="cfml2js" input="#rsImpuestos1#" topLevelVariable="rsjImpuestos">
  var nRows = rsjImpuestos.getRowCount();
  if (nRows > 0) {
    for (row = 0; row < nRows; ++row) {
      if (rsjImpuestos.getField(row, "Icodigo") == iI){
        varTipoIEPS = rsjImpuestos.getField(row, "TipoCalculo");
        varIEscalonado = rsjImpuestos.getField(row, "IEscalonado");
        varIEPSValCal = rsjImpuestos.getField(row, "ValorCalculo");
      }
    }
  }
}

function calculaIEPS(){
	var cantidad = new Number(qf(document.formDetCoti.Cantidad.value));
	var precio = new Number(qf(document.formDetCoti.PrecioUnitario.value));
	var descuento = new Number(qf(document.formDetCoti.DescuentoLinea.value));
	if (document.formDetCoti.Iieps.value == -1){
		document.formDetCoti.IepsLinea.value = 0;
	}else{
		ieps();
		if (varTipoIEPS == 1){
			document.formDetCoti.IepsLinea.value = Math.round(((cantidad * precio - descuento) * (varIEPSValCal/100))*100)/100;
		}else if(varTipoIEPS == 2){
			document.formDetCoti.IepsLinea.value = varIEPSValCal;
		}
	}
}

function funcCcodigo2(){
	if (document.formDetCoti.codIEPSC.value != ''){
		document.formDetCoti.Iieps.value = document.formDetCoti.codIEPSC.value;
		if (document.formDetCoti.codIEPSC.value != ''){
			document.formDetCoti.Iieps.disabled = true;
		}
		calculaIEPS();
		calcTotal();
		if (document.getElementById('afectaIVAC').value != ''){
			document.formDetCoti.IEscalonado.value = document.getElementById('afectaIVAC').value;
		}
	}else{
		document.formDetCoti.Iieps.value = -1;
		document.formDetCoti.Iieps.disabled = false;
		calculaIEPS();
		calcTotal();
	}
}
function enableIieps() {
	if (document.formDetCoti.Iieps != null){
    	document.formDetCoti.Iieps.disabled= false;
	}
}
function asignaAfectaIVA(){
	ieps();
	document.formDetCoti.IEscalonado.value = varIEscalonado;
}

function obtieneSelectIva(){

	/* Para obtener el valor */
	var cod = document.getElementById("Icodigo").value;
	alert(cod);
	
	return cod;
}





</script>
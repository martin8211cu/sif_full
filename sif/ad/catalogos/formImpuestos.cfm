<!--- MODO: Definición del modo de acuerdo con la variable Icodigo (Compone junto con Ecodigo la Llave Única de la Tabla Impuestos)--->
<cfif isdefined("form.Icodigo") and len(trim(form.Icodigo)) >
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA' >
</cfif>
<cfquery name="rsIUnidad" datasource="#session.dsn#">
	SELECT 	Ucodigo
	FROM	Unidades
	WHERE	Ecodigo=#session.Ecodigo#
</cfquery>

<cfquery name="rsImpDiot" datasource="#session.dsn#">
	SELECT 	DIOTivacodigo,DIOTivadesc
	FROM	DIOTiva
</cfquery>

<cfif modo NEQ 'ALTA'>
	<!--- Resultados en Modo Cambio de la Tabla Impuestos --->
	<cfquery name="rsdataDiot" datasource="#session.DSN#">
		select DIOTivacodigo
		from ImpuestoDIOT
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
	</cfquery>

	<cfquery name="rsdata" datasource="#session.DSN#">
		select Icodigo,Idescripcion, Iporcentaje,
		coalesce(Ccuenta,-1) as Ccuenta,
		coalesce(CcuentaCxC,-1) as CcuentaCxC,
		coalesce(CcuentaCxCAcred,-1) as CcuentaCxCAcred,
		coalesce(CcuentaCxPAcred,-1) as CcuentaCxPAcred,
		coalesce(CcuentaTraRemision,-1) as CcuentaTraRemision,
		CFcuenta, CFcuentaCxC, CFcuentaCxCAcred, CFcuentaCxPAcred,
		CFcuentaTraRemision,
		Icompuesto, Icreditofiscal,IActdefault,IServdefault,
		InoRetencion, ts_rversion, IcodigoExt, ieps, TipoCalculo, Ucodigo, 
		Factor, ValorCalculo, IEscalonado,ClaveSAT,TipoFactor,TasaOCuota,IRetencion		
		from Impuestos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
	</cfquery>
	<cfif rsdata.Icompuesto neq 0>
		<cfquery name="rsComponentes" datasource="#session.DSN#">
			select Ecodigo, Icodigo, DIcodigo, DIporcentaje, DIdescripcion,
				case DIcreditofiscal when 0 then '<img border=''0'' src=''/cfmx/sif/imagenes/unchecked.gif''>'
				else '<img border=''0'' src=''/cfmx/sif/imagenes/checked.gif''>' end as DIcreditofiscal,
				Ccuenta, CFcuenta, Usucodigo, DIfecha
			from DImpuestos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
			order by DIcodigo, DIdescripcion
		</cfquery>
	</cfif>
	<!--- Cuenta Contable --->
	<cfif rsdata.recordcount and rsdata.Ccuenta neq -1>
		<cfquery name="rsCuentas" datasource="#Session.DSN#">
			select Cmayor, CFformato, CFdescripcion, CFcuenta, Ccuenta
			  from CFinanciera
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif rsdata.CFcuenta NEQ "">
			   and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.CFcuenta#">
			<cfelse>
			   and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.Ccuenta#">
			 order by CFcuenta
			</cfif>
		</cfquery>
	</cfif>
	<!--- Cuenta Contable CcuentaCxC --->
	<cfif rsdata.recordcount and rsdata.CcuentaCxC neq -1>
		<cfquery name="rsCuentasCXC" datasource="#Session.DSN#">
			select Cmayor, CFformato, CFdescripcion, CFcuenta as CFcuentaCxC, Ccuenta as CcuentaCxC
			  from CFinanciera
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif rsdata.CFcuentaCxC NEQ "">
			   and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.CFcuentaCxC#">
			<cfelse>
			   and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.CcuentaCxC#">
			 order by CFcuenta
			</cfif>
		</cfquery>
	</cfif>
	<!--- Cuenta Contable CcuentaCxCAcred--->
	<cfif rsdata.recordcount and rsdata.CcuentaCxCAcred neq -1>
		<cfquery name="rsCuentasCxCAcred" datasource="#Session.DSN#">
			select Cmayor, CFformato, CFdescripcion, CFcuenta as CFcuentaCxCAcred, Ccuenta as CcuentaCxCAcred
			  from CFinanciera
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif rsdata.CFcuentaCxCAcred NEQ "">
			   and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.CFcuentaCxCAcred#">
			<cfelse>
			   and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.CcuentaCxCAcred#">
			 order by CFcuenta
			</cfif>
		</cfquery>
	</cfif>
	<!--- Cuenta Contable CcuentaCxPAcred--->
	<cfif rsdata.recordcount and rsdata.CcuentaCxPAcred neq -1>
		<cfquery name="rsCuentasCxPAcred" datasource="#Session.DSN#">
			select Cmayor, CFformato, CFdescripcion, CFcuenta as CFcuentaCxPAcred, Ccuenta as CcuentaCxPAcred
			  from CFinanciera
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif rsdata.CFcuentaCxPAcred NEQ "">
			   and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.CFcuentaCxPAcred#">
			<cfelse>
			   and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.CcuentaCxPAcred#">
			 order by CFcuenta
			</cfif>
		</cfquery>
	</cfif>
	<!--- Cuenta Contable Transitoria de Remisiones 150222--->
	<cfif rsdata.recordcount and rsdata.CcuentaTraRemision neq -1>
		<cfquery name="rsCuentasTraRemision" datasource="#Session.DSN#">
			select Cmayor, CFformato, CFdescripcion, CFcuenta as CFcuentaTraRemision, Ccuenta as CcuentaTraRemision
			  from CFinanciera
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif rsdata.CFcuentaTraRemision NEQ "">
			   and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.CFcuentaTraRemision#">
			<cfelse>
			   and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.CcuentaTraRemision#">
			 order by CFcuenta
			</cfif>
		</cfquery>
	</cfif>
</cfif>

<cfoutput>

<form style="margin:0;" name="form1" action="SQLImpuestos.cfm" method="post" onSubmit="javascript:habilitarCampos();">
 	<table width="100%" cellpadding="2" cellspacing="0" border="0" >
    	<tr>
    		<td align="right" width="20%" nowrap="nowrap"><strong>C&oacute;digo:</strong>&nbsp;</td>
      		<td colspan="2">
        		<input required type="text" name="Icodigo" id="Icodigo" size="5" maxlength="5" <cfif modo neq 'ALTA'>readonly="readonly"</cfif> value="<cfif modo neq 'ALTA'>#rsdata.Icodigo#</cfif>" onFocus="this.select();">
      		</td>
      		<td align="left" nowrap="nowrap">
        		<input type="checkbox" name="ieps" id="ieps" value="<cfif modo NEQ 'ALTA'>#rsdata.ieps#<cfelse>0</cfif>"
				<cfif modo NEQ "ALTA" and rsdata.ieps EQ "1">checked</cfif>><label for="ieps"><strong>IEPS</strong></label>
      		</td>
     		<td align="center" nowrap="nowrap" colspan="2">
        		<input type="checkbox" name="Icompuesto" onClick="javascript:validaCheck(this.checked);" value="<cfif modo NEQ "ALTA">#rsdata.Icompuesto#</cfif>">
				<cfif modo NEQ "ALTA" and rsdata.Icompuesto EQ "1">checked</cfif><label for="Icompuesto"><strong>Compuesto</strong></label>
        		<cfif modo neq 'ALTA'>
         			<input type="hidden" name="IcompuestoX" value="#rsdata.Icompuesto#">
        		</cfif>
      		</td>
      		<td align="left" nowrap="nowrap" colspan="2">
        		<input type="checkbox" name="IEscalonado" value="<cfif modo NEQ "ALTA">#rsdata.IEscalonado#<cfelse>checked</cfif>"
				<cfif modo NEQ "ALTA" and rsdata.IEscalonado EQ "1">checked<cfelseif modo EQ "ALTA">checked</cfif>><label for="IEscalonado"><strong>Escalonado</strong></label>
      		</td>
    	</tr>
		<tr>
      		<td align="right" width="20%" nowrap="nowrap"><strong>&nbsp;&nbsp;C&oacute;digo Externo:</strong>&nbsp;</td>
      		<td colspan="2"><input type="text" name="IcodigoExt" size="5" maxlength="5" value="<cfif modo neq 'ALTA'>#rsdata.IcodigoExt#</cfif>" onFocus="this.select();">
      		</td>
		</tr>
    	<tr>
      		<td align="right" nowrap="nowrap"><strong>Descripci&oacute;n:</strong></td>
      		<td colspan="6"><input required type="text" name="Idescripcion" size="60" maxlength="80" value="<cfif modo neq 'ALTA'>#rsdata.Idescripcion#</cfif>" onFocus="this.select();"></td>
    	</tr>
    	<tr id="porcTr" style="position: relative;<cfif modo NEQ 'ALTA'><cfif #rsdata.ieps# EQ 1>display:none</cfif></cfif>">
			<td align="right"><strong>Porcentaje:</strong>&nbsp;</td>
      		<td colspan="2">
        		<input type="text" name="Iporcentaje" size="8" maxlength="8" readonly="readonly" value="<cfif modo neq 'ALTA'>#LSNumberFormat(rsdata.Iporcentaje,'9.00')#<cfelse>0.00</cfif>" style="text-align:right;" onBlur="javascript:fm(this,2);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
      		</td>
			<td align="right"><strong>Tasa:</strong>&nbsp;</td>
			<td colspan="3">
				<cfset filtroExtra = ''>
				<cfset valuesArray = ArrayNew(1)>
				<cfif  modo neq 'ALTA' and len(trim(rsdata.TasaOCuota)) gt 0>
					<cfset filtroExtra = "and a.TCImpuesto = 'IVA' and a.TCValMax = #rsdata.TasaOCuota#">
					<cfset ArrayAppend(valuesArray, 'IVA')>
					<cfset ArrayAppend(valuesArray, rsdata.TasaOCuota)>
					<cfset ArrayAppend(valuesArray, rsdata.TipoFactor)>
				</cfif>

				<cf_conlis title="Cat&aacute;logo Tasa o Cuota"
					campos = "TCImpuesto,TCValMax,TCFactor"
					desplegables = "S,S,N"
					modificables = "S,N"
					size = "5,20"
					tabla="CSATTasaCuota a"
					columnas="a.TCRangoFijo,a.TCValMin,format(a.TCValMax,'0.000000') as TCValMax,a.TCImpuesto,a.TCFactor"
					desplegar="TCRangoFijo,TCValMin,TCValMax,TCImpuesto,TCFactor"
					etiquetas="Tipo,ValorMin,ValorMax,Impuesto,Factor"
					formatos="S,S,S,S,S"
					align="left,left,left,left,left"
		            asignar="TCRangoFijo,TCValMin,TCValMax,TCImpuesto,TCFactor"
					asignarformatos="S,S,S,S,S"
					showEmptyListMsg="true"
					debug="false"
					tabindex="1"
					conexion="#session.dsn#"
					funcion="funcionIVA"
					fparams="TCValMax"
					filtrar_por="TCImpuesto,TCValMax"
					valuesArray="#valuesArray#"
					filtro="a.TCImpuesto = 'IVA'"
					> 
					
					<!--- traerInicial="True"
					traerFiltro="1=1 #filtroExtra#" --->
			</td>
      	</tr>
      	<tr id="diotIva" style="position: relative; <cfif modo NEQ 'ALTA'><cfif #rsdata.ieps# EQ 1>display:none</cfif></cfif>">
      		<td align="right" nowrap="nowrap"><strong>Categoria DIOT:</strong>&nbsp;</td>
      		<td colspan="2"> <select name="DIOTcodigo" tabindex="2" >
               			<option value="" selected>--- Selecciona ---</option>
               <cfloop query="rsImpDiot">

                     <option value="#rsImpDiot.DIOTivacodigo#" <cfif modo neq 'ALTA'>
                     <cfif #rsdataDiot.DIOTivacodigo# EQ #rsImpDiot.DIOTivacodigo#>selected</cfif></cfif>>#rsImpDiot.DIOTivadesc#</option>
               </cfloop>
             </select><td>
      	</tr>

    	<tr id="iepsTr" style="position:relative; <cfif modo NEQ 'ALTA'><cfif #rsdata.ieps# NEQ 1>visibility:hidden</cfif><cfelseif modo EQ 'ALTA'>visibility:hidden</cfif>">
    		<td align="right" nowrap="nowrap"><strong>Tipo de c&aacute;lculo:</strong>&nbsp;</td>
      		<td colspan="2">
      			<select id="ITCalculo" name="ITCalculo" onFocus="this.select();">
      				<option value="1"<cfif modo neq 'ALTA'><cfif #rsdata.TipoCalculo# EQ 1>selected</cfif></cfif>>Porcentaje</option>
      				<option value="2"<cfif modo neq 'ALTA'><cfif #rsdata.TipoCalculo# EQ 2>selected</cfif></cfif>>Valor Fijo</option>
	   			</select>
      		</td>
      		<td id="unidadTd" style="<cfif modo NEQ 'ALTA'><cfif #rsdata.TipoCalculo# NEQ 2>visibility:hidden;</cfif><cfelseif modo EQ 'ALTA'>visibility:hidden;</cfif> text-align: right;"><strong>Unidad:</strong>&nbsp;</td>
      		<td id="unidadTd2" style="<cfif modo NEQ 'ALTA'><cfif #rsdata.TipoCalculo# NEQ 2>visibility:hidden;</cfif><cfelseif modo EQ 'ALTA'>visibility:hidden;</cfif> text-align: left;">
      			<select id="IUnidades" name="IUnidades" onFocus="this.select();" onChange="conlisIEPS(this);">
      				<cfloop query="rsIUnidad">
      					<option>#Ucodigo#</option>
      				</cfloop>
      			</select>
      		</td>
      		<td id="factorTd" style="<cfif modo NEQ 'ALTA'><cfif #rsdata.TipoCalculo# NEQ 2>visibility:hidden;</cfif><cfelseif modo EQ 'ALTA'>visibility:hidden;</cfif> text-align: right;"><strong>Factor:</strong>&nbsp;</td>
      		<td id="factorTd2" style="<cfif modo NEQ 'ALTA'><cfif #rsdata.TipoCalculo# NEQ 2>visibility:hidden;</cfif><cfelseif modo EQ 'ALTA'>visibility:hidden;</cfif>text-align: left;">
				<input type="text" name="IFactor" size="10" maxlength="20" value="<cfif modo neq 'ALTA'>#rsdata.Factor#</cfif>" onFocus="this.select();" style="text-align:right;" >
			</td>
    	</tr>
    	<tr id="valorC" style="position: relative;<cfif modo NEQ 'ALTA'><cfif #rsdata.ieps# NEQ 1>display:none</cfif><cfelseif modo EQ 'ALTA'>display:none</cfif>">
      		<td align="right" nowrap="nowrap"><strong>Valor de C&aacute;lculo:</strong>&nbsp;</td>
      		<td colspan="2">
        		<input type="text" name="IvalorC" size="8" maxlength="8" readOnly="readonly" value="<cfif modo neq 'ALTA'>#LSNumberFormat(rsdata.ValorCalculo,'9.00')#<cfelse>0.00</cfif>" style="text-align:right;" onBlur="javascript:fm(this,2);" <!--- onFocus="javascript:this.value=qf(this); this.select();" --->  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
      		</td>
			<td align="right" id="lblP">
				<strong>Tasa:</strong>&nbsp;
			</td>
			<td align="right" id="lblF">
				<strong>Cuota:</strong>&nbsp;
			</td>
			<td colspan="3" id="conlisP">
				<cfset filtroExtra = ''>
				<cfset valuesArray = ArrayNew(1)>
				<!--- <cfdump var="#rsdata#"> --->
				<cfif  modo neq 'ALTA' and len(trim(rsdata.TasaOCuota)) gt 0>
					<cfset ArrayAppend(valuesArray, 'IEPS')>
					<cfset ArrayAppend(valuesArray, rsdata.TasaOCuota)>
					<cfset filtroExtra = "and a.TCImpuesto = 'IEPS' and a.TCValMax = #rsdata.TasaOCuota#">
				</cfif>
				
				<cf_conlis title="Cat&aacute;logo Tasa o Cuota"
					campos = "TCImpuestoIEPS,TCValMaxIEPS,TCFactorIEPS"
					desplegables = "S,S,N"
					modificables = "N,N"
					size = "5,20"
					tabla="CSATTasaCuota a"
					columnas="a.TCRangoFijo,a.TCValMin,format(a.TCValMax,'0.000000') as TCValMaxIEPS,a.TCImpuesto as TCImpuestoIEPS,a.TCFactor"
					desplegar="TCRangoFijo,TCValMin,TCValMaxIEPS,TCImpuestoIEPS,TCFactor"
					etiquetas="Tipo,ValorMin,ValorMax,Impuesto,Factor"
					formatos="S,S,S,S,S"
					align="left,left,left,left,left"
		            asignar="TCRangoFijo,TCValMin,TCValMaxIEPS,TCImpuestoIEPS,TCFactor"
					asignarformatos="S,S,S,S,S"
					showEmptyListMsg="true"
					debug="false"
					tabindex="1"
					funcion="funcionIEPS"
					fparams="TCValMaxIEPS"
					conexion="#session.dsn#"
					filtrar_por="TCImpuesto,TCValMax"
					valuesArray="#valuesArray#"
					filtro="a.TCImpuesto = 'IEPS' and a.TCFactor = 'Tasa'"
					> 
					<!--- traerInicial="True"
					traerFiltro=" 1=1 #filtroExtra#" --->
			</td>
			<td colspan="3" id="conlisF">
				<input type="text" name="IValorFijoIEPS" id="IValorFijoIEPS"  onKeyUp="funcionIEPSFijo()" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2);" value="<cfif  modo neq 'ALTA' and len(trim(rsdata.TasaOCuota)) gt 0>#rsdata.TasaOCuota#</cfif>">
			</td>
		</tr>
    	<tr id="tr2">
      		<td align="right">
        		<input type="checkbox" name="Icreditofiscal" id="CFiscal"  value="<cfif modo NEQ "ALTA">#rsdata.Icreditofiscal#</cfif>" <cfif modo NEQ "ALTA" and rsdata.Icreditofiscal EQ "1">checked</cfif> >
      		</td>
      		<td colspan="3"><strong>Cr&eacute;dito Fiscal</strong></td>
      		<td align="right">
        		<input type="checkbox" name="InoRetencion" value="1" <cfif modo NEQ "ALTA" and rsdata.InoRetencion EQ "1">checked</cfif> >
      		</td>
      		<td colspan="3"><strong>No aplicar Retención</strong></td>
   		</tr>
   		<tr>
   	  		<td align="right">
        		<input type="checkbox" name="defaultServ" <cfif modo NEQ "ALTA" and rsdata.IServdefault EQ "1">checked</cfif> >
      		</td>
      		<td colspan="3"><strong>Default para Servicios</strong></td>
      		<td align="right">
        		<input type="checkbox" name="defaultAct" <cfif modo NEQ "ALTA" and rsdata.IActdefault EQ "1">checked</cfif> >
      		</td>
      		<td colspan="3"><strong>Default para Articulos</strong></td>
   		</tr>
			<tr>
			    <td align="right">
        		<input type="checkbox" name="retencion" <cfif modo NEQ "ALTA" and rsdata.IRetencion EQ "1">checked</cfif> >
      		</td>
      		<td colspan="3"><strong>Retención</strong></td>
			</tr>
		<tr id="tr1">
			<td colspan="8" nowrap="nowrap" >
				<fieldset><legend>Cuentas Financieras de Impuestos</legend>
				<table width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr>
				  		<td  nowrap="nowrap" align="right">&nbsp;</td>
				  		<td  colspan="4" nowrap="nowrap" align="left"><strong>Facturas Proveedor </strong></td>
					</tr>
					<tr>
				  		<td  nowrap="nowrap" align="right">&nbsp;</td>
				  		<td colspan="3">
							<cfif modo EQ "ALTA" or rsdata.Ccuenta eq -1 or rsCuentas.RecordCount EQ 0>
								<cf_cuentas ccuenta="Ccuenta" CFcuenta="CFcuenta">
							<cfelse>
								<cf_cuentas ccuenta="Ccuenta" CFcuenta="CFcuenta" query="#rsCuentas#">
							</cfif>
				  		</td>
					</tr>
				<!--- ********************************************* --->
				<!--- ***** Se agregar 3 nuevas cuentas    ******** --->
				<!--- ********************************************* --->
				<tr>
				  <td  nowrap="nowrap" align="right">&nbsp;</td>
				  <td  colspan="4" nowrap="nowrap" align="left"><strong>Facturas Proveedor </strong><strong>Acreditadas</strong></td>
				</tr>
				<tr>
				  <td  nowrap="nowrap" align="right">&nbsp;</td>
				  <td colspan="3">
					<cfif modo EQ "ALTA" or rsdata.CcuentaCxPAcred eq -1 or rsCuentasCxPAcred.RecordCount EQ 0>
						<cf_cuentas ccuenta="CcuentaCxPAcred" CFcuenta="CFcuentaCxPAcred">
					<cfelse>
						<cf_cuentas ccuenta="CcuentaCxPAcred" CFcuenta="CFcuentaCxPAcred" query="#rsCuentasCxPAcred#" tabindex="1">
					</cfif>
				  </td>
				</tr>
				<tr>
				  <td  nowrap="nowrap" align="right">&nbsp;</td>
				  <td  colspan="4" nowrap="nowrap" align="left"><strong>Facturas Cliente </strong></td>
				</tr>
				<tr id="tr1C">
				  <td  nowrap="nowrap" align="right">&nbsp;</td>
				  <td colspan="3">
					<cfif modo EQ "ALTA" or rsdata.CcuentaCxC eq -1 or rsCuentasCXC.RecordCount EQ 0>
						<cf_cuentas ccuenta="CcuentaCxC" CFcuenta="CFcuentaCxC">
					<cfelse>
						<cf_cuentas ccuenta="CcuentaCxC" CFcuenta="CFcuentaCxC" query="#rsCuentasCXC#" tabindex="1">
					</cfif>
				  </td>
				</tr>
				<tr>
				  <td  nowrap="nowrap" align="right">&nbsp;</td>
				  <td  colspan="4" nowrap="nowrap" align="left"><strong>Facturas Cliente </strong><strong>Acreditadas</strong></td>
				</tr>
				<tr>
				  <td  nowrap="nowrap" align="right">&nbsp;</td>
				  <td colspan="3">
					<cfif modo EQ "ALTA" or rsdata.CcuentaCxCAcred eq -1 or rsCuentasCxCAcred.RecordCount EQ 0>
						<cf_cuentas ccuenta="CcuentaCxCAcred" CFcuenta="CFcuentaCxCAcred">
					<cfelse>
						<cf_cuentas ccuenta="CcuentaCxCAcred" CFcuenta="CFcuentaCxCAcred" query="#rsCuentasCxCAcred#" tabindex="1">
					</cfif>
				  </td>
				</tr>
				<!---RDF se agrega nueva cuenta de remisión --->
				<tr>
				  <td  nowrap="nowrap" align="right">&nbsp;</td>
				  <td  colspan="4" nowrap="nowrap" align="left"><strong>Cuenta Transitoria </strong><strong>Remisiones</strong></td>
				</tr>
				<tr>
				  <td  nowrap="nowrap" align="right">&nbsp;</td>
				  <td colspan="3">
					<cfif modo EQ "ALTA" or rsdata.CcuentaTraRemision eq -1 or rsCuentasTraRemision.RecordCount EQ 0>
						<cf_cuentas ccuenta="CcuentaTraRemision" CFcuenta="CFcuentaTraRemision">
					<cfelse>
						<cf_cuentas ccuenta="CcuentaTraRemision" CFcuenta="CFcuentaTraRemision" query="#rsCuentasTraRemision#" tabindex="1">
					</cfif>
				  </td>
				</tr>
			</table>
			</fieldset>
		</td>
	</tr>
  	<!--- ********************************************* --->
	<!--- ********************************************* --->

    <tr>
      <td colspan="8">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="8" align="center">
        <cfif modo EQ 'CAMBIO' and rsdata.Icompuesto EQ 1>
          <cf_botones modo="#modo#" include="ImpuestosCompuestos" includevalues="Impuestos Compuestos">
          <cfelse>
          <cf_botones modo="#modo#">
        </cfif>
      </td>
    </tr>
    <cfif modo neq "ALTA">
      <cfset ts = "">
      <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsdata.ts_rversion#" returnvariable="ts">
      </cfinvoke>
      <input type="hidden" name="ts_rversion" value="#ts#">
    </cfif>
    <!---<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">	--->
  </table>
</form>
</cfoutput>
<cf_qforms form='form1'>
<script language="javascript1.2" type="text/javascript">
objForm.Icodigo.description = "Codigo";
objForm.Idescripcion.description = "Descripción";
objForm.Iporcentaje.description = "Porcentaje";
objForm.Ccuenta.description = "Cuentas";
objForm.IFactor.description = "Factor";

	function habilitarValidacion(){
		objForm.Icodigo.required = true;
		objForm.Idescripcion.required = true;
		objForm.Iporcentaje.required = true;
		if (document.form1.Icompuesto.checked == false) {
			objForm.Ccuenta.required = true;
		}
		else {
			objForm.Ccuenta.required = false;
		}
		if (objForm.Icodigo.obj.disabled == false){
			objForm.Icodigo.obj.focus();
		}
		else {
			objForm.Idescripcion.obj.focus();
		}
				if (document.getElementById('ieps').checked){
			objForm.IvalorC.required = true;
			if (document.getElementById('ITCalculo').value == 2){
				objForm.IUnidades.required = true;
				objForm.IFactor.required = true;
			}else if (document.form1.ITCalculo.value == 1){
				objForm.IUnidades.required = false;
				objForm.IFactor.required = false;
			}
		}else{
			objForm.IvalorC.required = false;
		}
	}
	function deshabilitarValidacion(){
		objForm.Icodigo.required = false;
		objForm.Idescripcion.required = false;
		objForm.Iporcentaje.required = false;
		objForm.Ccuenta.required = false;
		objForm.IUnidades.required = false;
		objForm.IFactor.required = false;
		objForm.IvalorC.required = false;

	}

	function mostrarDatos(value){
		document.getElementById("tr1").style.display = ( value ? 'none' : '' );
		document.getElementById("tr2").style.display = ( value ? 'none' : '' );
		document.form1.Iporcentaje.disabled = value;
	}

	<cfif modo neq 'ALTA'>
		mostrarDatos(<cfoutput>#rsdata.Icompuesto#</cfoutput>);
	</cfif>

	<cfif modo neq 'ALTA'>
		function funcImpuestosCompuestos() {
			if ('<cfoutput>#rsdata.Icodigo#</cfoutput>' != "") {
				document.form1.action = 'DetImpuestos.cfm';
				return true;
			}
			return false;
		}
	</cfif>

	function validaCheck(value) {
		if (document.form1.Icreditofiscal.checked == true) {
			alert("Desmarque el Crédito Fiscal para poder crear un Impuesto Compuesto.");
			document.form1.Icompuesto.checked = false;
			return false;
		}
		else {
			mostrarDatos(value);
		}
	}


	function habilitarCampos() {
		//document.form1.Icodigo.disabled = false;
	}

	//habilitarValidacion();
	//-->
</script>
<cfif modo neq "ALTA" and rsdata.Icompuesto neq 0>
  <table width="99%">
	<tr>
		<td align="center" class="SubTitulo">Componentes del Impuesto</td>
	</tr>
	<tr>
		<td>
		  <cfinvoke
			 component="sif.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsComponentes#"/>
			<cfinvokeargument name="desplegar" value="DIcodigo, DIdescripcion, DIporcentaje, DIcreditofiscal"/>
			<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Porcentaje, C.F."/>
			<cfinvokeargument name="formatos" value="S,S,M,S"/>
			<cfinvokeargument name="align" value="left,left,right,right"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="showLink" value="False"/>
			<cfinvokeargument name="totales" value="DIporcentaje"/>
			<cfinvokeargument name="formname" value="lista2"/>
			<cfinvokeargument name="pageindex" value="2"/>
		  </cfinvoke>
		</td>
	</tr>
  </table>
</cfif>
<script type="text/javascript" src="/cfmx/jquery/librerias/jquery-2.0.2.min.js"></script>
<script type="text/javascript">
	function funcionIVA(monto)
	{
		document.form1.Iporcentaje.value = monto*100;
		document.form1.Iporcentaje.focus();
	}

	function funcionIEPS(monto)
	{
		document.form1.IvalorC.value = monto*100;
		document.form1.IvalorC.focus();
	}

	function funcionIEPSFijo()
	{
		var monto = document.form1.IValorFijoIEPS.value;
		document.form1.IvalorC.value = monto*100;
	}

$(document).ready(function(){

if(document.getElementById("ieps").checked)
	{
		<cfif modo NEQ 'ALTA' and #rsdata.TipoCalculo# NEQ 2>
			$('#conlisF').hide();
    		$('#conlisP').show();
    		$('#lblP').show();
    		$('#lblF').hide();

		<cfelse>
    		$('#conlisF').show();
			$('#conlisP').hide();
			$('#lblF').show();
    		$('#lblP').hide();
		</cfif>

	}

$('#ieps').change(function(){
	if($('#iepsTr').css('visibility') == 'visible'){
    	$('#iepsTr').css('visibility','hidden');
    	$('#porcTr').show();
    	$('#valorC').hide();
    	$('#diotIva').show();
    	tipoCalculoHidden();
	}
	else{
     	$('#iepsTr').css('visibility','visible');
     	$('#porcTr').hide();
     	$('#valorC').show();
     	$('#diotIva').hide();
     	tipoCalculoToggle();
	}
});

});

$('#ITCalculo').change(function(){
	tipoCalculoToggle();
});

function tipoCalculoVisible(){
	    $('#unidadTd').css('visibility','visible');
     	$('#factorTd').css('visibility','visible');
     	$('#unidadTd2').css('visibility','visible');
     	$('#factorTd2').css('visibility','visible');
     	$('#conlisP').hide();
    	$('#conlisF').show();
    	$('#lblP').hide();
    	$('#lblF').show();

}
function tipoCalculoHidden(){
    	$('#unidadTd').css('visibility','hidden');
    	$('#factorTd').css('visibility','hidden');
    	$('#unidadTd2').css('visibility','hidden');
    	$('#factorTd2').css('visibility','hidden');
    	$('#conlisP').show();
    	$('#conlisF').hide();
    	$('#lblF').hide();
    	$('#lblP').show();
}
function tipoCalculoToggle(){
	if ($('#ITCalculo').val() == 1){
		tipoCalculoHidden();
	}
	else{
		tipoCalculoVisible();
	}
}

function funcAlta(){
	var tasa = "";
	if(document.getElementById('ieps').checked){
		tasa = document.getElementsByName('TCValMaxIEPS')[0].value;
	}else{
		tasa = document.getElementsByName('TCValMax')[0].value;
	}
	
	var codigo = document.getElementsByName('Icodigo')[0].value;
	var descrip = document.getElementsByName('Idescripcion')[0].value;
	
	var facProveedor = document.getElementsByName('Cformato')[0].value;
	var facAcredit = document.getElementsByName('Cformato_CcuentaCxPAcred')[0].value;
	
	var funcResult = true; 
	var errorMsg = 'Se encontraron los siguientes problemas:'
	
	if(tasa == ''){ errorMsg += '\n- Selecciones una TASA'; funcResult = false;}
	if(codigo == ''){ errorMsg += '\n- Especifique un CÓDIGO'; funcResult = false;}
	if(descrip == ''){ errorMsg += '\n- Escriba una DESCRIPCIÓN'; funcResult = false;}
	if(facProveedor == ''){ errorMsg += '\n- Se requiere asignar FACTURAS PROVEEDOR'; funcResult = false;}
	if(facAcredit == ''){ errorMsg += '\n- Se requiere asignar FACTURAS PROVEEDOR ACREDITADAS'; funcResult = false;}

	if(!funcResult){alert(errorMsg);}
	
	return funcResult;
}

</script>
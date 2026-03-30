<cfif modo neq 'ALTA' and isdefined('url.PDTDid') and len(trim(url.PDTDid))>
	<cfset form.PDTDid = #url.PDTDid#>
</cfif>

<cfquery datasource="#Session.DSN#" name="rsBancos">
	select Bid as id, Bdescripcion 
	from Bancos 
	where Ecodigo	=	<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by Bdescripcion
</cfquery>
<cfquery datasource="#Session.DSN#" name="rsForm">
	select a.EMid, a.ts_rversion, a.EMdocumento, a.EMdescripcion, a.EMfecha, a.BTid, b.Bid, b.Ocodigo, b.CBid, 
		b.CBcodigo, b.CBdescripcion, c.Mcodigo, c.Mnombre, a.EMtipocambio, a.EMreferencia, a.EMtotal,a.SNid,a.SNcodigo,
		a.id_direccion,coalesce(a.TpoSocio,0) as TpoSocio,a.TpoTransaccion,a.Documento,d.BTtipo,a.CDCcodigo	
	from EMovimientos a
		inner join CuentasBancos b
			on b.Ecodigo	=	a.Ecodigo
			and b.CBid		=	a.CBid
		inner join  Monedas c
			on c.Ecodigo 	= 	b.Ecodigo
			and c.Mcodigo 	=	b.Mcodigo
		inner join  BTransacciones d
			on a.Ecodigo 	= 	d.Ecodigo
			and a.BTid   	=	d.BTid	
	where a.Ecodigo			=	<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
    	and b.CBesTCE       = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
</cfquery>
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select '-1' as value, '-- todos --' as description, 0 as ord from dual
	union
	select Mnombre as value, Mnombre as description, 1 as ord
	from Monedas
	where Ecodigo = #Session.Ecodigo#
	order by ord,description
</cfquery>
<cfquery datasource="#Session.DSN#" name="rsPDTDeposito">
	select PDTDid, PDTDmonto, PDTDdocumento, PDTDdescripcion, Mnombre
	from PDTDeposito pdtd
		inner join Monedas m
			on m.Mcodigo = pdtd.Mcodigo
	where PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PETid#"> and PDTDestado = 1
	<cfif isdefined('form.filtro_PDTDdocumento') and len(trim(form.filtro_PDTDdocumento))>
	and lower(PDTDdocumento) like lower(<cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.filtro_PDTDdocumento#%">)
	</cfif>
	<cfif isdefined('form.filtro_PDTDdescripcion') and len(trim(form.filtro_PDTDdescripcion))>
	and lower(PDTDdescripcion) like lower(<cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.filtro_PDTDdescripcion#%">)
	</cfif>
	<cfif isdefined('form.filtro_PDTDmonto') and len(trim(form.filtro_PDTDmonto))>
	and PDTDmonto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.filtro_PDTDmonto,',','','ALL')#">
	</cfif>
	<cfif isdefined('form.filtro_Mnombre') and len(trim(form.filtro_Mnombre))>
	and lower(Mnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(form.filtro_Mnombre)#%">
	</cfif>
</cfquery>

<cfif modo neq 'ALTA' and isdefined('form.PDTDid') and len(trim(form.PDTDid))>
	<cfquery name="rsSelectDatosDepositos" datasource="#session.dsn#">
		select pdtd.PDTDid, pdtd.PETid, cb.CBid, m.Mcodigo, m.Mnombre, cb.CBcodigo, cb.CBdescripcion, pdtd.Mcodigo, pdtd.BTid, pdtd.PDTDmonto,
			pdtd.PDTDdocumento, pdtd.PDTDdescripcion, pdtd.PDTDtipocambio, b.Bid, pdtd.ts_rversion  
		from PDTDeposito pdtd
			inner join CuentasBancos cb
				inner join Bancos b
					on cb.Bid = b.Bid and cb.Ecodigo = b.Ecodigo
				inner join Monedas m 
					on m.Mcodigo = cb.Mcodigo
				on cb.CBid = pdtd.CBid
		where pdtd.PDTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PDTDid#">
        	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		order by pdtd.PDTDid
	</cfquery>
	<cfset CBid=rsSelectDatosDepositos.CBid>
	<cfset Mcodigo=rsSelectDatosDepositos.Mcodigo>
	<cfset BTid=rsSelectDatosDepositos.BTid>
	<cfset PDTDmonto=rsSelectDatosDepositos.PDTDmonto>
	<cfset PDTDdocumento=rsSelectDatosDepositos.PDTDdocumento>
	<cfset PDTDdescripcion=rsSelectDatosDepositos.PDTDdescripcion>
	<cfset PDTDtipocambio=rsSelectDatosDepositos.PDTDtipocambio>
	<cfset CBcodigo=rsSelectDatosDepositos.CBcodigo>
	<cfset CBdescripcion=rsSelectDatosDepositos.CBdescripcion>
	<cfset Bid=rsSelectDatosDepositos.Bid>
	<cfset Mnombre=rsSelectDatosDepositos.Mnombre>
<cfelse>
	<cfset Mcodigo=''>
	<cfset CBid=''>
	<cfset PDTDmonto='0'>
	<cfset PDTDdocumento=''>
	<cfset PDTDdescripcion=''>
	<cfset PDTDtipocambio='1'>
	<cfset Bid=''>
	<cfset CBcodigo=''>
	<cfset CBdescripcion=''>
	<cfset Mnombre=''>
	<cfquery name="rsParamCuenta" datasource="#session.dsn#">
	   select Pvalor from Parametros  where Pcodigo = 1804
	</cfquery>	
	<cfif rsParamCuenta.recordcount neq 0 and rsParamCuenta.Pvalor neq ''> <!----Si ya existe una cuenta -------> 					
		<cfset CBid= rsParamCuenta.Pvalor> 
		<cfquery name="rsCuentaBanco" datasource="#session.dsn#">
			Select cb.CBid,cb.CBcodigo,cb.CBdescripcion, b.Bid , m.Mnombre,m.Mcodigo
		   from  CuentasBancos cb 
				inner join Bancos b 
					on cb.Bid = b.Bid 
					and cb.Ecodigo = b.Ecodigo 
				inner join Monedas m 
					on m.Mcodigo = cb.Mcodigo
				  where cb.CBid = #CBid#
                  	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		</cfquery>		
			<cfif rsCuentaBanco.recordcount gt 0>		
				<cfset Bid = rsCuentaBanco.Bid>
				<cfset CBcodigo=rsCuentaBanco.CBcodigo>
				<cfset CBdescripcion=rsCuentaBanco.CBdescripcion> 
				<cfset Mnombre=rsCuentaBanco.Mnombre>
				<cfset Mcodigo=rsCuentaBanco.Mcodigo>
			</cfif>
	</cfif>
	
</cfif>
<cfif not isdefined('BTid')>
	<cfquery name="rsTipoTransaccion" datasource="#session.dsn#">
		select Pvalor
		from Parametros
		where Pcodigo = 1800 and Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfset BTid = rsTipoTransaccion.Pvalor>
</cfif>
<cfoutput>
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<table width="100%"  border="0" cellspacing="0" cellpadding="0"><tr>
	<td width="50%" valign="top">
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
			query="#rsPDTDeposito#" 
			conexion="#session.dsn#"
			desplegar="PDTDdocumento, PDTDdescripcion, PDTDmonto, Mnombre"
			etiquetas="Documento , Descripción, Monto, Moneda"
			formatos="S,S,M,S"
			mostrar_filtro="true"
			align="left,left,left,left"
			checkboxes="n"
			formName="listaDepositos"
			ira="registroMovimientos.cfm?PETid=#form.PETid#&tab=3"
			rsMnombre="#rsMonedas#"
			keys="PDTDid">
		</cfinvoke>
	</td>
	<td>
		<cfform action="registroMovimientos_SQL.cfm" method="post" name="formDepositos">
		<table border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td><strong>Documento:</strong></td>
				<td>
					<input type="text" name="documento" maxlength="20" value="#PDTDdocumento#">
				</td>
			</tr>
				<td><strong>Descripci&oacute;n:</strong></td>
				<td>
				<input type="text" tabindex="1" name="descripcion" maxlength="120" size="40" value="#PDTDdescripcion#">
				</td>
			</tr>
			<tr>
				<td><strong>Banco:</strong></td>
				<td>
					<cfset selected="selected">
					<select name="Bid" tabindex="1" onchange="javascript:limpiarCuenta();">
					<option value="">-- Seleccione un Banco --</option>
					<cfloop query="rsBancos">
					<option value="#id#" <cfif #rsBancos.id# eq #Bid#> selected="selected"</cfif>> #Bdescripcion#</option>
					</cfloop>						
					</select>
				</td>
			</tr>
			<tr>
				<td><strong>Cuenta Bancaria: </strong></td>
				<td>
					<cf_conlis title="Lista de Cuentas Bancarias"
					form="formDepositos"
					campos = "CBid, CBcodigo, CBdescripcion, Mcodigo" 
					values="#CBid#,#CBcodigo#,#CBdescripcion#,#Mcodigo#"
					desplegables = "N,S,S,N" 
					modificables = "N,S,N,N" 
					size = "0,0,40,0"
					tabla="CuentasBancos cb
					inner join Monedas m 
					on cb.Mcodigo = m.Mcodigo
					inner join Empresas e
					on e.Ecodigo = cb.Ecodigo
					left outer join Htipocambio tc
					on 	tc.Ecodigo = cb.Ecodigo
					and tc.Mcodigo = cb.Mcodigo
					and tc.Hfecha  <= $fecha,date$
					and tc.Hfechah >  $fecha,date$ "
					columnas="cb.CBid, cb.CBcodigo, cb.CBdescripcion, cb.Mcodigo, 
					m.Mnombre,
					round(
					coalesce(
					(	case 
					when cb.Mcodigo = e.Mcodigo then 1.00 
					else tc.TCcompra 
					end
					)
					, 1.00)
					,2) as EMtipocambio"
					filtro="cb.Ecodigo = #Session.Ecodigo# and cb.CBesTCE = 0 and cb.Bid = $Bid,numeric$ order by Mnombre, Hfecha"
					desplegar="CBcodigo, CBdescripcion"
					etiquetas="C&oacute;digo, Descripci&oacute;n"
					formatos="S,S"
					align="left,left"
					asignar="CBid, CBcodigo, CBdescripcion, Mcodigo, Mnombre, EMtipocambio"
					asignarformatos="S,S,S,S,S,M"
					showEmptyListMsg="true"
					debug="false"
					tabindex="1">
				</td><br />
			</tr>
				<td><strong>Moneda:</strong></td>
				<td><input type="text" name="Mnombre" value="#Mnombre#" readonly tabindex="-1"><br />
				</td>
			</tr>
			<tr>
				<td><strong>Tipo de Cambio:</strong></td>
				<td>
					<cf_monto name="EMtipocambio" value="#PDTDtipocambio#" tabindex="-1">
				</td>	
			</tr>
			<tr>
				<td><strong>Monto:</strong></td>
				<td>
					<cf_monto name="monto" tabindex="-1" value="#PDTDmonto#">
				</td>	
			</tr>
			<tr>
				<td colspan="2">
					<cfif modo neq 'ALTA' and isdefined('form.PDTDid') and len(trim(form.PDTDid))>
						<cf_botones modo="CAMBIO" names="CAMBIODEPOSITO,BAJADEPOSITO,NUEVODEPOSITO">
						<input type="hidden" id="PDTDid" name="PDTDid" value="#form.PDTDid#" />
						<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsSelectDatosDepositos.ts_rversion#" returnvariable="ts2"></cfinvoke>
						<input type="hidden" id="ts_rversion" name="ts_rversion" value="#ts2#" />
					<cfelse>
						<cf_botones modo="ALTA" names="ALTADEPOSITO,LIMPIARDEPOSITO">
					</cfif>
					<input type="hidden" tabindex="1" name="fecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
					<input type="hidden" name="PETid" value="#form.PETid#">
					<input type="hidden" id="Ecodigo" name="Ecodigo" value="#session.Ecodigo#" />
					<input type="hidden" id="MBUsucodigo" name="MBUsucodigo" value="#session.usucodigo#" />
					<input type="hidden" id="BTid" name="BTid" value="#BTid#" />
				</td>	
			</tr>
		</table>
			</td>
</tr>
<tr>
	<td width="50%">
		<fieldset>
		<table>
		<tr>
			<td>Total Dep&oacute;sitos:
			</td>
			<td><cf_monto name="tdepositos" readonly="true" value="#rsTotalDepositos.Total#"/>
			</td>
		</tr>
		<tr>
			<td>Total Seg&uacute;n Veh&iacute;culos:
			</td>
			<td><cf_monto name="tvehiculos" readonly="true" value="#rsTotalVehiculos.Total#"/>
			</td>
		</tr>
		<tr>
			<td>Diferencia :
			</td>
			<cfset dif=rsTotalDepositos.Total-rsTotalVehiculos.Total>
			<td><cf_monto name="tdiferiencia" readonly="true" value="#dif#"/>
			</td>
		</tr>
		</table>
		</fieldset>
	</td>
</tr></table>
</cfform>


<cf_qforms form="formDepositos" objForm="objFormDepositos">

<script language="javascript" type="text/javascript">
	objFormDepositos.CBcodigo.description = "#JSStringFormat('Cuenta Bancaria Código')#";
	objFormDepositos.Mnombre.description = "#JSStringFormat('Moneda')#";
	objFormDepositos.documento.description = "#JSStringFormat('Documento')#";
	objFormDepositos.Bid.description = "#JSStringFormat('Documento')#";
	objFormDepositos.monto.description = "#JSStringFormat('Monto')#";
	objFormDepositos.EMtipocambio.description = "#JSStringFormat('Tipo Cambio')#";
	objFormDepositos.BTid.description = "#JSStringFormat('Tipo de Transacción')#";
	
	objFormDepositos.monto.required=true;
	objFormDepositos.Bid.required=true;
	objFormDepositos.documento.required=true;
	objFormDepositos.Mnombre.required=true;
	objFormDepositos.CBcodigo.required=true;
	objFormDepositos.EMtipocambio.required=true;
	objFormDepositos.BTid.required=true;
	
	function limpiarCuenta(){
		objFormDepositos.CBid.obj.value="";
		objFormDepositos.CBcodigo.obj.value="";
		objFormDepositos.CBdescripcion.obj.value="";
		objFormDepositos.Mcodigo.obj.value="";
		objFormDepositos.Mnombre.obj.value="";
		objFormDepositos.EMtipocambio.obj.value="";
		
	}
	
	function funcNUEVODEPOSITO(){
		location.href="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&tab=3";
		return false;
	}
	
		function filtrar_Plista(){ 
		document.listaDepositos.action='registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&tab=3'; 
		if (window.funcFiltrar) { 
			if (funcFiltrar()) { return true; } }
			else { return true; }
		 return false; 
	}
</script>
</cfoutput>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default ="Fecha" returnvariable="LB_Fecha" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Desde" default ="desde" returnvariable="LB_Desde" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Hasta" default ="hasta" returnvariable="LB_Hasta" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MotivoCancelación" default ="Motivo de la Cancelación" returnvariable="LB_MotivoCancelación" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_PorFavorReviseLosSiguientesDatos" default ="Por favor revise los siguiente datos" returnvariable="MSG_PorFavorReviseLosSiguientesDatos" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DeseaCancelarRecepEfec" default ="Desea CANCELAR la recepción de efectivo" returnvariable="MSG_DeseaCancelarRecepEfec" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DebeDigitarUnaRazonCancelacion" default ="Debe digitar una razón de la cancelación" returnvariable="MSG_DebeDigitarUnaRazonCancelacion" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CajaChica" default = "Caja Chica" returnvariable="LB_CajaChica" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NComprobante" default = "Num. Comprobante" returnvariable="LB_NComprobante" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_DepPor" default = "Depositado por" returnvariable="LB_DepPor" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MostrarCanlLiq" default = "Mostrar Canceladas/En Liquidación" returnvariable="LB_MostrarCanlLiq" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Comprobante" default = "Comprobante" returnvariable="LB_Comprobante" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fecha" default = "Fecha" returnvariable="LB_Fecha" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Moneda" default = "Moneda" returnvariable="LB_Moneda" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoOrigen" default = "MontoOrigen" returnvariable="LB_MontoOrigen" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descripcion" default = "Descripción" returnvariable="LB_Descripcion" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Depositante" default = "Depositante" returnvariable="LB_Depositante" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MotCancelacion" default = "MotivoCancelación" returnvariable="LB_MotCancelacion" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Liquidacion" default = "Liquidación" returnvariable="LB_Liquidacion" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_RegistroACancelar" default = "Debe seleccionar el registro que desea cancelar" returnvariable="MSG_RegistroACancelar" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Filtrar" default = "Filtrar" returnvariable="BTN_Filtrar" xmlfile = "CancelarEntregasEfectivo.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Cancelar" default = "Cancelar" returnvariable="BTN_Cancelar" xmlfile = "CancelarEntregasEfectivo.xml">

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfparam name="url.tab" default="1">

<cfset FechaI = ''>
<cfset FechaF = ''>
<cfquery name="rsCustodio" datasource="#session.dsn#">
	select llave as DEid
	  from UsuarioReferencia
	 where Usucodigo= #session.Usucodigo#
	   and Ecodigo	= #session.EcodigoSDC#
	   and STabla	= 'DatosEmpleado'
</cfquery>

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select m.Mcodigo, m.Miso4217
	  from Empresas e
		inner join Monedas m on m.Mcodigo = e.Mcodigo
	  where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
</cfquery>

<cfquery name="rsCajaEspecial" datasource="#session.dsn#">
	select ch.CCHid, ch.CCHcodigo, ch.CCHdescripcion, ch.Mcodigo, mo.Mnombre, mo.Miso4217,
		coalesce((
			select tc.TCventa
			from Htipocambio tc
			where tc.Ecodigo = #session.Ecodigo#
			  and tc.Mcodigo = ch.Mcodigo
			  and tc.Hfecha  <= <cf_dbfunction name="today" >
			  and tc.Hfechah > <cf_dbfunction name="today" >
		),1) as TipoCambio
	  from CCHica ch
		inner join Monedas mo on mo.Mcodigo = ch.Mcodigo
		where	ch.Ecodigo=#session.Ecodigo#
			--and ch.CCHresponsable=#rsCustodio.DEid#
 			and ch.CCHtipo = 2
</cfquery>


<cfset LvarTipoDocumento = 7>
<cfoutput>
<form action="CancelarEntregasEfectivo.cfm" name="form1" method="post" onsubmit="return validar(this);" id="form1">
	<input type="hidden" name="msgRechazo" value=""/>
	<table align="center" summary="Tabla de entrada"  width="90%" border="0">
			<tr><td>&nbsp;</td></tr>
			<tr>
			<td><strong><cfoutput>#LB_CajaChica#</cfoutput>:</strong></td>
			<td><select name="cboCajaEfectivo" tabindex="1" onchange="javascript:cargarDatos(this);">
				<cfif rsCajaEspecial.RecordCount GT 0 >
					<cfloop query="rsCajaEspecial">
					<option value=#rsCajaEspecial.CCHid#>
								<cfoutput>#rsCajaEspecial.Miso4217# - #rsCajaEspecial.CCHcodigo# - #rsCajaEspecial.CCHdescripcion#</cfoutput>
					</option>
					</cfloop>
				</cfif>
				</select>
			</td>
					</td>			
				<td align="right"><cfoutput><strong>#LB_Fecha#&nbsp;#LB_Desde#:</strong></cfoutput></td>
				<td >
				<cfif isdefined("form.FechaI") and len(trim(form.FechaI))>
					<cf_sifcalendario form="form1" value="#form.FechaI#" name="FechaI" tabindex="1"> 
				<cfelse>	
					<cfset LvarFechaI = createdate (year(now()), month(now()), 1)>
					<cf_sifcalendario form="form1" value="#DateFormat(LvarFechaI, 'dd/mm/yyyy')#" name="FechaI" tabindex="1"> 
				</cfif>
			</td>
			<td align="right"><cfoutput><strong>#LB_Fecha#&nbsp;#LB_Hasta#:</strong></cfoutput></td>
				<td >
				<cfif isdefined("form.FechaF") and len(trim(form.FechaF))>
					<cf_sifcalendario form="form1" value="#form.FechaF#" name="FechaF" tabindex="1"> 
				<cfelse>	
					<cfset LvarFechaF = createdate(year(now()),month(now()),day(now()))>
					<cf_sifcalendario form="form1" value="#DateFormat(LvarFechaF, 'dd/mm/yyyy')#" name="FechaF" tabindex="1"> 
				</cfif>
			</td>
			</tr>
			<tr>
			<td align="left">
				<strong><cf_translate key = LB_NumComision xmlfile = "AprobarTrans_formLiq.xml"><cfoutput>#LB_NComprobante#</cfoutput></cf_translate>:&nbsp;</strong>
			</td>
				<td align="left"> <input type="text" tabindex="1" name="Comprobante" id="Comprobante" maxlength="4" size="20" value="<cfif isdefined("form.Comprobante") and form.Comprobante NEQ ''>#form.Comprobante#</cfif>"></td>
			<td>
			
	
		</tr>	
		<tr>
			<td nowrap align="left"><strong><cf_translate key = LB_Moneda xmlfile = "TransaccionCustodiaP_Recepcion.xml"><cfoutput>#LB_DepPor#</cfoutput></cf_translate></strong>:&nbsp;</td>
			<td align="left"> <input type="text" tabindex="1" name="DepositadoPor" id="DepositadoPor" maxlength="255" size="60" value="<cfif isdefined("form.DepositadoPor") and form.DepositadoPor NEQ ''>#form.DepositadoPor#</cfif>"/></td>
		</tr>
		<tr>
			<td align="rigth">
			<input type="checkbox" name="chkEnLiqOCancelados"  <cfif isdefined ('form.chkEnLiqOCancelados') and form.chkEnLiqOCancelados eq 'on'>checked="checked" </cfif> />
			</td>
			<td align="left"><cfoutput><strong>#LB_MostrarCanlLiq# </strong></cfoutput></td>
		</tr>
	</table>
	<table align="center">
		<tr><td>&nbsp;</td>
		<tr>
		<td colspan="2" align="center"><cf_botones values="#BTN_Filtrar#" names="Filtrar" tabindex="6"></td>
		</tr>	
		<td>&nbsp;</td></tr>
	</table>
 </form>
</cfoutput>	

<cfif isdefined("form.chkEnLiqOCancelados") and form.chkEnLiqOCancelados EQ 'on'>
	<cfquery datasource="#session.dsn#" name="rsFormACancelar">
		Select me.CCHEMid, me.CCHid, CCHEMtipo, CCHEMnumero, CCHEMfecha, me.Mcodigo, CCHEMmontoOri, CCHEMtipoCambio, CCHEMfalta,  
		CCHEMfuso, CCHEMdescripcion, CCHEMdepositadoPor, CCHEMCancelado, MSG_CCHEMCancelacion, m.Mnombre, de.GELid, GELDreferencia, 			        coalesce(GELnumero,'')  GELnumero
		from CCHespecialMovs me 
		inner join CCHica cc on me.CCHid = cc.CCHid 
		inner join Monedas m on m.Mcodigo = me.Mcodigo 
		left join GEliquidacionDepsEfectivo de on de.GELDreferencia = me.CCHEMnumero 
		left join GEliquidacion l on l.GELid = de.GELid
		where cc.CCHid = 
		<cfif isdefined("cboCajaEfectivo") and cboCajaEfectivo NEQ ''>
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#cboCajaEfectivo#">
		<cfelse>
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCajaEspecial.CCHid#">
		</cfif>
		and me.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CCHEMtipo = 'E'	
		<cfif isdefined("form.Comprobante") and  form.Comprobante NEQ ''>
			and CCHEMnumero = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Comprobante#">
		</cfif>
		<cfif isdefined("form.FechaI") and isdefined("form.FechaF")>			
			and convert(date,CCHEMfecha,103) between <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaI, 'dd/mm/yyyy')#">
							 and <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaF, 'dd/mm/yyyy')#">
		</cfif>
		<cfif isdefined("form.DepositadoPor") and form.DepositadoPor NEQ ''>			
			and <cf_dbfunction name="LIKE" args="upper(CCHEMdepositadoPor),upper('%#form.DepositadoPor#%')">
		</cfif>	
		and(de.GELDreferencia is not null or CCHEMCancelado = 1)		
	</cfquery>
<cfelse>
<!---<cfthrow message="no entra al if :(">--->
	<cfquery datasource="#session.dsn#" name="rsFormACancelar">
		Select 
			CCHEMid, me.CCHid, CCHEMtipo, CCHEMnumero, convert(date,CCHEMfecha,103) as CCHEMfecha, me.Mcodigo, CCHEMmontoOri, CCHEMtipoCambio, 					            CCHEMfalta, GELid, CCHEMfuso, CCHEMdescripcion, CCHEMdepositadoPor, m.Mnombre
		from CCHespecialMovs me
		inner join CCHica cc on me.CCHid = cc.CCHid
		inner join Monedas m on m.Mcodigo = me.Mcodigo
		where cc.CCHid = 
		<cfif isdefined("cboCajaEfectivo") and cboCajaEfectivo NEQ ''>
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#cboCajaEfectivo#">
		<cfelse>
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCajaEspecial.CCHid#">
		</cfif>
		and me.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CCHEMtipo = 'E'	
		and CCHEMCancelado = 0		
		and CCHEMnumero not in (select distinct(GELDreferencia) 
								from GEliquidacionDepsEfectivo 
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)	
		<cfif isdefined("form.Comprobante") and  form.Comprobante NEQ ''>
			and CCHEMnumero = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Comprobante#">
		</cfif>
		<cfif isdefined("form.FechaI") and isdefined("form.FechaF")>			
			and convert(date,CCHEMfecha,103) between <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaI, 'dd/mm/yyyy')#">
							 and <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.FechaF, 'dd/mm/yyyy')#">
		</cfif>
		<cfif isdefined("form.DepositadoPor") and form.DepositadoPor NEQ ''>			
			and <cf_dbfunction name="LIKE" args="upper(CCHEMdepositadoPor),upper('%#form.DepositadoPor#%')">
		</cfif>		
	</cfquery>
</cfif>
		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery">
			<cfinvokeargument name="query" value="#rsFormACancelar#"/>
			<cfif isdefined("form.chkEnLiqOCancelados") and form.chkEnLiqOCancelados EQ 'on'>
				<cfinvokeargument name="desplegar" value="CCHEMnumero, CCHEMfecha, Mnombre, CCHEMmontoOri, CCHEMtipoCambio, CCHEMdescripcion, CCHEMdepositadoPor ,MSG_CCHEMCancelacion, GELnumero"/>
				<cfinvokeargument name="etiquetas" value="#LB_Comprobante#, #LB_Fecha#, #LB_Moneda#, #LB_MontoOrigen#, TC, #LB_Descripcion#, #LB_Depositante#,#LB_MotCancelacion#, #LB_Liquidacion#"/>
				<cfinvokeargument name="formatos" value="S,D,S,S,S,S,S,S,S"/>
				<cfinvokeargument name="ajustar" value="N,N,N,N,N,S,N,S,N"/>
				<cfinvokeargument name="align" value="center,center,center,right,right,center,center,center,center"/>
			<cfelse>
				<cfinvokeargument name="desplegar" value="CCHEMnumero, CCHEMfecha, Mnombre, CCHEMmontoOri, CCHEMtipoCambio, CCHEMdescripcion, CCHEMdepositadoPor"/>
				<cfinvokeargument name="etiquetas" value="#LB_Comprobante#, #LB_Fecha#, #LB_Moneda#, #LB_MontoOrigen#, TC, #LB_Descripcion#, #LB_Depositante#"/>
				<cfinvokeargument name="formatos" value="S,D,S,S,S,S,S"/>
				<cfinvokeargument name="ajustar" value="N,N,N,N,N,S,N,"/>
				<cfinvokeargument name="align" value="center,center,center,right,right,center,center"/>
				<cfinvokeargument name="botones" value="#BTN_Cancelar#"/>
			</cfif>
			<cfinvokeargument name="checkboxes" value="S"/>
			<cfinvokeargument name="irA" value=""/>
          	<cfinvokeargument name="MaxRows" value="10"/>
			<cfinvokeargument name="showLink" value="false"/>
			<cfinvokeargument name="keys" value="CCHEMnumero"/>			
         </cfinvoke>			
	</table>
 
<cfset session.ListaReg = #rsFormACancelar#>
<cfoutput>
<script type="text/javascript">
	function algunoMarcado(){
		var aplica = false;
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				aplica = document.lista.chk.checked;
			}else{
				for (var i=0; i<document.lista.chk.length; i++) {
					if (document.lista.chk[i].checked) { 
						var Documento = document.lista.chk[i].value;	
						aplica = true;
						break;
					}
				}
			}
		}
		
		if (aplica) {
			return (confirm("¿<cfoutput>#MSG_DeseaCancelarRecepEfec#</cfoutput>?"));
		} else {
			alert('#MSG_RegistroACancelar#');
			return false;
		}
	}


	function funcCancelar(){
			if (algunoMarcado()){
			var vReason = prompt('<cfoutput>#MSG_DebeDigitarUnaRazonCancelacion#</cfoutput>!','');
			if (document.lista.chk.value) {
				var Documento = document.lista.chk.value;
			}else{
				for (var i=0; i<document.lista.chk.length; i++) {
					if (document.lista.chk[i].checked) { 
						var Documento = document.lista.chk[i].value;		
						break;				
					}
				}
			}
			if (vReason != null )
			{
				if(vReason != '')
				{
				document.form1.msgRechazo.value = vReason;
				document.lista.action = "CancelarEntregasEfectivo_sql.cfm?Mensaje="+vReason+"&NumDocumento="+Documento;
				return true;
				}
				else
				{
				alert('<cfoutput>#MSG_DebeDigitarUnaRazonCancelacion#</cfoutput>!');
				return false;
				}
			}
			else
			{
				return false;
			}
			}
			return false;
		}
		
</script>
</cfoutput>

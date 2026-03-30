<cfinclude template="../../Utiles/sifConcat.cfm">

<cfset meses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">

<cfif isdefined("Form.CPDEid") and Len(Trim(Form.CPDEid))>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfif modo EQ "CAMBIO" and isdefined("Form.CPDDid") and Len(Trim(Form.CPDDid))>
	<cfset modoDet = "CAMBIO">
<cfelse>
	<cfset modoDet = "ALTA">
</cfif>

<cfquery name="rsDistribuciones" datasource="#session.DSN#">
	select CPDCid, <cf_dbfunction name="concat" args="rtrim(CPDCcodigo),' - ',CPDCdescripcion"> as Descripcion
	  from CPDistribucionCostos
	 where Ecodigo=#session.Ecodigo#
	   and CPDCactivo=1
       and Validada = 1
</cfquery>

<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
	select a.Pvalor as Ano, m.Pvalor as Mes
	  from Parametros m, Parametros a
	 where a.Ecodigo = #Session.Ecodigo#
	   and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="50">
	   and m.Ecodigo = #Session.Ecodigo#
	   and m.Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="60">
</cfquery>

<cfif isdefined('form.Ccodigoclas') and Len(trim('form.Cclas'))>
 	<cfquery name="rsClasificaciones" datasource="#session.DSN#">
		select Ccodigo as Ccodigo2, Ccodigoclas, Cdescripcion as DescArt, Cnivel as Nnivel
		from Clasificaciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Ccodigoclas = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ccodigoclas#">
	</cfquery>

</cfif>

<cfquery name="rsCPPeriodos" datasource="#Session.DSN#">
	select 	CPPid,
			CPPtipoPeriodo,
			CPPfechaDesde,
			CPPfechaHasta,
			CPPestado,
			'Presupuesto ' #_Cat#
				case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
				#_Cat# ' de ' #_Cat#
				case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
				#_Cat# ' a ' #_Cat#
				case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
			as Descripcion
	 from CPresupuestoPeriodo
	where Ecodigo = #Session.Ecodigo#
	  and CPPestado = 1
</cfquery>

<cfquery name="rsLocal" datasource="#Session.DSN#">
	select e.Mcodigo, Miso4217
	from Empresas e
		inner join Monedas m
			on m.Mcodigo = e.Mcodigo
	where e.Ecodigo = #Session.Ecodigo#
</cfquery>
<!--- Suficiencia para Activo Fíjo INICIA --->
<!--- Combo Categorias --->
<cfquery name="rsCategorias" datasource="#session.DSN#" >
	select ACcodigo, ACdescripcion
	from ACategoria
	where Ecodigo =  #session.Ecodigo#
</cfquery>
<!--- Combo Clasificacion --->

<cfquery name="rsClasificacion" datasource="#Session.DSN#">
	select ACid, ACdescripcion, ACcodigo
	from AClasificacion
	where Ecodigo= #session.Ecodigo#
	order by ACcodigo, ACdescripcion
</cfquery>

<!--- Suficiencia para Activo Fíjo FIN --->
<cfif modo EQ 'CAMBIO'>
	<cfquery name="rsProvision" datasource="#Session.DSN#">
		select a.CPPid,
			   a.CPDEfecha,
			   a.CPDEfechaDocumento,
			   rtrim(a.CPDEnumeroDocumento) as CPDEnumeroDocumento,
			   a.CPDEdescripcion,
			   a.Usucodigo,
			   ((case b.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end) #_Cat# ': ' #_Cat#
			   <cf_dbfunction name="to_char" args="b.CPPfechaDesde" datasource="#session.dsn#"> #_Cat# ' - ' #_Cat#
			   <cf_dbfunction name="to_char" args="b.CPPfechaHasta" datasource="#session.dsn#"> ) as DescripcionPeriodo,
			   a.ts_rversion,
			   c.CFid,
			   rtrim(c.CFcodigo) as CFcodigo,
			   c.CFdescripcion,
			   d.Odescripcion,
			   a.CPDEsuficiencia,
               a.CPDEcontrato,
			   a.Mcodigo, a.CPDEtc, a.CPDEreferencia, m.Miso4217,
			   CPDEjustificacion
		from CPDocumentoE a, CPresupuestoPeriodo b, CFuncional c, Oficinas d, Monedas m
		where a.Ecodigo = #Session.Ecodigo#
		and a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
		and a.CPDEtipoDocumento = 'R'
		and a.Ecodigo = b.Ecodigo
		and a.CPPid = b.CPPid
		and a.Ecodigo = c.Ecodigo
		and a.CFidOrigen = c.CFid
		and c.Ecodigo = d.Ecodigo
		and c.Ocodigo = d.Ocodigo
		and m.Mcodigo = a.Mcodigo
	</cfquery>

	<cfif rsProvision.Mcodigo EQ "">
		<cfquery datasource="#Session.DSN#">
			update CPDocumentoD
			   set  CPDDmontoOri = CPDDmonto
			 where (
			 		select count(1)
					  from CPDocumentoE
					 where CPDEid = CPDEid
					   and CPDEtipoDocumento = 'R'
					   and Mcodigo is null
					) > 0
			   and CPDDmontoOri is null
		</cfquery>
		<cfquery datasource="#Session.DSN#">
			update CPDocumentoE
			   set  Mcodigo = #rsLocal.Mcodigo#,
			   		CPDEtc  = 1.00
			 where CPDEtipoDocumento = 'R'
			   and Mcodigo is null
		</cfquery>
	</cfif>
	<cfquery name="rsMeses" datasource="#Session.DSN#">
		select CPCmes, CPCano
		from CPmeses
		where Ecodigo = #Session.Ecodigo#
		and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProvision.CPPid#">
		and CPCano*100+CPCmes >= #rsMesAuxiliar.Ano*100+rsMesAuxiliar.Mes#
		order by CPCano, CPCmes
	</cfquery>
	<cfset MesesDisponibles = ValueList(rsMeses.CPCmes, ',')>

	<cfquery name="rsCountDetalle" datasource="#Session.DSN#">
		select count(1) as cant
		from CPDocumentoD
		where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
	</cfquery>

	<cfif modoDet EQ "CAMBIO">
		<cfquery name="rsDetProvision" datasource="#Session.DSN#">
			select a.CPDEid,
				   a.CPPid,
				   a.CPDDlinea,
				   a.CPDDid,
				   a.CPDDtipo,
				   a.CPCano,
				   a.CPCmes,
				    case when CPDDtipoItem = 'S' and CPDCid IS NOT NULL then 'D'
				    when CPDDtipoItem = 'C' and CPDCid IS NOT NULL then 'D' else CPDDtipoItem end as CPDDtipoItem,
				    case when CPDDtipoItem = 'S' and CPDCid IS NOT NULL then null else a.CPcuenta end as CPcuenta,
				    case when CPDDtipoItem = 'S' and CPDCid IS NOT NULL then null else b.CPformato end as CPformato,
				    case when CPDDtipoItem = 'S' and CPDCid IS NOT NULL then null else coalesce(b.CPdescripcionF,b.CPdescripcion) end as CPdescripcion,
					case
						when a.CPDDtipoItem ='S' and CPDClinea IS NOT NULL then
							(
								select sum(CPDDmonto)
								  from CPDocumentoD
								 where CPDEid=a.CPDEid
								   and CPDClinea=a.CPDClinea
							)
						else a.CPDDmonto
					end as CPDDmonto,
				   a.CPDDmontoOri, a.CPDDmonto,
				   a.Ocodigo,
				   c.Cid,
                   f.CFid as CFidDet, f.CFcodigo as CFcodigoDet, f.CFdescripcion,
<!--- Suficiencia para Activo Fíjo INICIA --->
                   a.ACcodigo, a.ACid, cl.ACdescripcion,
<!--- Suficiencia para Activo Fíjo FIN    --->
				   CPDCid, CPDClinea,Ccodigoclas,
				   a.ts_rversion
			from CPDocumentoD a
				inner join CPresupuesto b on b.Ecodigo = #Session.Ecodigo# and b.CPcuenta = a.CPcuenta
				left join Conceptos c on c.Cid = a.Cid
				left join CFuncional f on f.CFid = a.CFid
				left join ACategoria ca on ca.ACcodigo = a.ACcodigo
				left join AClasificacion cl on cl.ACid = a.ACid
				where a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
			and a.CPDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDDid#">
		</cfquery>

		<cfif rsDetProvision.CPDDtipoItem NEQ "D">
			<cfinvoke component="sif.Componentes.PRES_Presupuesto"
				method="CalculoDisponible"
				returnvariable="LstrDisponible">

				<cfinvokeargument name="CPPid" value="#rsDetProvision.CPPid#">
				<cfinvokeargument name="CPCano" value="#rsDetProvision.CPCano#">
				<cfinvokeargument name="CPCmes" value="#rsDetProvision.CPCmes#">
				<cfinvokeargument name="CPcuenta" value="#rsDetProvision.CPcuenta#">
				<cfinvokeargument name="Ocodigo" value="#rsDetProvision.Ocodigo#">
				<cfinvokeargument name="TipoMovimiento" value="RP">

				<cfinvokeargument name="Conexion" value="#Session.DSN#">
				<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">

			</cfinvoke>
		</cfif>
	</cfif>

</cfif>

<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	var popUpWin=0;

	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	<cfif modo EQ "CAMBIO">
	<cfoutput>
	function doConlisCuentas() {
		if (document.form1.CPCanoMes.value != '') {
			var LvarAno = document.form1.CPCanoMes.value.substring(0,4);
			var LvarMes = document.form1.CPCanoMes.value.substring(4,6);
			var w = 600;
			var h = 300;
			var l = (screen.width-w)/2;
			var t = (screen.height-h)/2;
			popUpWindow("/cfmx/sif/Utiles/ConlisPresupuestoControlCtas.cfm?CPPid="+document.form1.CPPid.value+"&CPCano="+LvarAno+"&CPCmes="+LvarMes+"&CFidTipo=R&CFid="+document.form1.CFid.value+"&p1=form1&p2=CPcuenta&p3=CPformato&p4=CPdescripcion",l,t,w,h);
		} else {
			alert('No hay Cuentas de Presupuesto disponibles para el periodo presupuestario seleccionado');
		}
	}
	</cfoutput>

	function LimpiarCuenta() {
		document.form1.CPcuenta.value = "";
		document.form1.CPformato.value = "";
		document.form1.CPdescripcion.value = "";
	}
	</cfif>

</script>

<cfoutput>
<form method="post" name="form1" action="reserva-sql.cfm" onSubmit="javascript: validar(this);">
  <cfif modo EQ "CAMBIO">
	<input type="hidden" name="CPDEid" value="#Form.CPDEid#">
  </cfif>
  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
	<tr>
		<cfif modo EQ "ALTA">
			<cfset LvarTipoProvision = "Provisión Presupuestaria">
		<cfelseif rsProvision.CPDEsuficiencia EQ 1>
			<cfset LvarTipoProvision = "Provisión de Suficiencias para Compras">
		<cfelse>
			<cfset LvarTipoProvision = "Provisión para Presupuesto">
		</cfif>
		<td colspan="6" align="center" nowrap class="tituloAlterno">Encabezado de Documento de #LvarTipoProvision#</td>
	</tr>
	<tr>
	  <td align="right" class="fileLabel" nowrap>Per&iacute;odo:</td>
	  <td>
	  	<cfif modo EQ 'CAMBIO' and rsCountDetalle.cant NEQ 0>
			<input type="hidden" name="CPPid" value="#rsProvision.CPPid#">
			#rsProvision.DescripcionPeriodo#
		<cfelseif modo EQ 'CAMBIO'>
			<cf_cboCPPid IncluirTodos="false" value="#rsProvision.CPPid#" CPPestado="1">
		<cfelse>
			<cf_cboCPPid IncluirTodos="false" CPPestado="1">
		</cfif>
	  </td>
	  <td align="right" nowrap class="fileLabel">No. Documento:</td>
	  <td>
	  	<cfif modo EQ "CAMBIO">
	  	<!--- <input type="text" name="CPDEnumeroDocumento" size="20" maxlength="20" value="<cfif modo EQ 'CAMBIO'>#rsProvision.CPDEnumeroDocumento#</cfif>"> --->
		#rsProvision.CPDEnumeroDocumento#
		</cfif>
	  </td>
	  <td align="right" nowrap class="fileLabel">Fecha Documento:</td>
	  <td>
        <cfif modo EQ "CAMBIO">
          <cfset fecha = LSDateFormat(rsProvision.CPDEfechaDocumento, 'dd/mm/yyyy')>
          <cfelse>
          <cfset fecha = LSDateFormat(Now(), 'dd/mm/yyyy')>
        </cfif>
        <cf_sifcalendario name="CPDEfechaDocumento" form="form1" value="#fecha#">
	  </td>
	</tr>
	<tr>
	  <td align="right" class="fileLabel" nowrap>Descripci&oacute;n:</td>
	  <td><input type="text" name="CPDEdescripcion" size="70" maxlength="80" value="<cfif modo EQ 'CAMBIO'>#rsProvision.CPDEdescripcion#</cfif>"></td>
	  <td align="right" nowrap class="fileLabel">Centro Funcional: </td>
	  <td colspan="3">
		<input type="hidden" name="CFidTipo" value="R">
	  	<cfif modo EQ "CAMBIO" and rsCountDetalle.cant NEQ 0>
			#rsProvision.CFcodigo# - #rsProvision.CFdescripcion#
			<input type="hidden" id="CFid" name="CFid" value="<cfoutput>#rsProvision.CFid#</cfoutput>">
		<cfelseif modo EQ "CAMBIO">
			<cf_CPSegUsu_cboCFid name="CFid" value="#rsProvision.CFid#" onChange="return (this.form.CFidReadonly.value == '');">
			<input type="hidden" name="CFidReadonly" value="" />
		<cfelse>
			<cf_CPSegUsu_cboCFid name="CFid">
		</cfif>
	  </td>
	  </tr>
	<tr>
	<tr>
		<td align="right" class="fileLabel" nowrap>Referencia:</td>
		<td>
			<input name="CPDEreferencia" size="22" maxlength="20" value="<cfif MODO EQ "CAMBIO">#rsProvision.CPDEreferencia#</cfif>" />
			<cfif modo EQ "ALTA" or rsCountDetalle.cant EQ 0>
            	<cfset LvarSuficiencia = 0>
				<cfparam name="rsProvision.CPDEsuficiencia" default="0">
				<INPUT type="checkbox" name="CPDEsuficiencia" id="CPDEsuficiencia" value="1" <cfif rsProvision.CPDEsuficiencia EQ 1>checked</cfif>
                	onclick="sbCFuncionalDisplay()"
                />
				Provisión de Suficiencias para Compras
			<cfelseif rsProvision.CPDEsuficiencia EQ 1>
            	<cfset LvarSuficiencia = 1>
				<INPUT type="hidden" name="CPDEsuficiencia" id="CPDEsuficiencia"  value="1"/>
				<strong>Suficiencia para Compras</strong>
			<cfelse>
            	<cfset LvarSuficiencia = 2>
				<strong>Provisión para Presupuesto</strong>
			</cfif>
		</td>
		<td align="right" nowrap class="fileLabel">Oficina:</td>
		<cfif modo NEQ "ALTA">
		<td nowrap>#rsProvision.Odescripcion#</td>
		</cfif>
    </tr>
	<tr>
		<td align="right" class="fileLabel" nowrap>Moneda:</td>
		<td>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<cfif MODO EQ "ALTA">
							<cf_sifmonedas onChange="sbMonedas()" FechaSugTC="#LSdateFormat(now())#">
						<cfelse>
							<cf_sifmonedas onChange="sbMonedas()" FechaSugTC="#LSdateFormat(now())#" value="#rsProvision.Mcodigo#">
						</cfif>
					</td>
					<td>
						&nbsp;&nbsp;Tipo Cambio:
						<input type="text" name="CPDEtc" id="CPDEtc" size="20" maxlength="18"
							onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,5);" onKeyUp="if(snumber(this,event,5)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;"
							<cfif Modo EQ "ALTA">
								value="1.00" disabled
							<cfelse>
								value="#numberFormat(rsProvision.CPDEtc,",9.99999")#"
								<cfif rsProvision.Mcodigo EQ rsLocal.Mcodigo>disabled</cfif>
							</cfif>
						 />
					<script language="javascript">
						function sbMonedas()
						{
							document.form1.CPDEtc.value 	= fm(document.form1.TC.value,5);
							document.form1.CPDEtc.disabled 	= document.form1.Mcodigo.value == #rsLocal.Mcodigo#;
						}
					</script>
					</td>
				</tr>
			</table>
		</td>
	<cfif modo NEQ "ALTA">
		<cfquery name="rsTot" datasource="#Session.DSN#">
			select sum(CPDDmontoOri) as CPDDmontoOri, sum(CPDDmonto) as CPDDmonto
			  from CPDocumentoD
			 where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
		</cfquery>
		<cfif rsProvision.Mcodigo EQ rsLocal.Mcodigo>
			<td align="right" class="fileLabel" nowrap><strong>Total:</strong></td>
			<td>
				<strong>
					#rsLocal.Miso4217#
					#numberFormat(rsTot.CPDDmonto,",9.99")#
				</strong>
			</td>
		<cfelse>
			<td align="right" class="fileLabel" nowrap><strong>Totales:</strong></td>
			<td colspan="3">
				<strong>
					#rsProvision.Miso4217#
					#numberFormat(rsTot.CPDDmontoOri,",9.99")#
				</strong>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<strong>
					#rsLocal.Miso4217#
					#numberFormat(rsTot.CPDDmonto,",9.99")#
				</strong>
			</td>
		</cfif>
	</cfif>
	</tr>
    <tr>
		<td align="right" class="fileLabel" nowrap></td>
  		<td nowrap>
        <cfif modo EQ "ALTA" or  modo EQ "CAMBIO">

				<cfparam name="rsProvision.CPDEcontrato" default="0">
        <INPUT type="checkbox" name="CPDEcontrato" id="CPDEcontrato" value="1" <cfif rsProvision.CPDEcontrato EQ 1>checked</cfif>
                	onclick="sbCFuncionalDisplay()"
                />
        Provisión con Contrato
        </cfif>

		</td>
	</tr>





	<tr>
		<td align="right" class="fileLabel" nowrap>Observaciones:</td>
		<td style="border:solid 1px" colspan="6">
			<textarea name="CPDEjustificacion" cols="150"><cfif modo EQ "CAMBIO"><cfoutput>#rsProvision.CPDEjustificacion#</cfoutput></cfif></textarea>
		</td>
	</tr>



    <tr>
	  <td colspan="6" align="center" nowrap>
		<cfset ts = "">
		<cfif modo NEQ "ALTA">
		  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsProvision.ts_rversion#" returnvariable="ts">
		  </cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="<cfif modo EQ "CAMBIO"><cfoutput>#ts#</cfoutput></cfif>">
		<cfif modo EQ "ALTA">
			<input type="submit" name="btnAgregarE" value="Agregar" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion(); ">
		<cfelse>
			<input type="submit" name="btnCambiarE" value="Modificar" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion(); ">
			<input type="submit" name="btnBajaE" value="Eliminar" onclick="javascript: if ( confirm('¿Desea ELIMINAR el Documento de #LvarTipoProvision#?') ){ if (window.inhabilitarValidacion) inhabilitarValidacion(); return true; }else{ return false;}">
			<input type="submit" name="btnNuevoE" value="Nuevo" onClick="javascript: if (window.inhabilitarValidacion) inhabilitarValidacion(); ">
			<input type="button" name="btnImprimir" value="Imprimir" onClick="javascript: if (window.inhabilitarValidacion) inhabilitarValidacion(); if (window.funcImprimir) return funcImprimir();">
			<input type="submit" name="btnAplicar" value="Aplicar" onclick="javascript: if ( confirm('¿Desea aplicar este documento de #LvarTipoProvision#?') ){ if (window.inhabilitarValidacionD) inhabilitarValidacionD(); return true; }else{ return false;}">
		</cfif>
		<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: location.href='reserva-lista.cfm';">
	  </td>
	</tr>
	<tr>
	  <td colspan="6">&nbsp;</td>
	</tr>
	<cfif modo EQ "CAMBIO">
	<tr>
	  <td colspan="6" class="tituloAlterno">Detalle de Documento de #LvarTipoProvision#</td>
	</tr>
	<tr>
	  <td colspan="6">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td valign="top"></td>
			<cfif modoDet EQ 'CAMBIO'>
				<input type="hidden" name="CPDDid" value="#form.CPDDid#">
			</cfif>
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
				<tr>
					<td></td>
					<td></td>
 					<td><input style="width:145px;border:none; background-color:##FFFFFF" disabled></td>
					<td><input style="width:275px;border:none; background-color:##FFFFFF" disabled></td>
					<td><input style="width:120px;border:none; background-color:##FFFFFF" disabled></td>
					<td><input style="width:250px;border:none; background-color:##FFFFFF" disabled></td>
				  <tr>
                    <td nowrap align="right" nowrap class="fileLabel">Mes de Presupuesto:</td>
					<td nowrap>
						<select name="CPCanoMes" onChange="javascript: LimpiarCuenta();">
                        <cfloop query="rsMeses">
                        	<option value="#rsMeses.CPCano*100+rsMeses.CPCmes#" <cfif modoDet EQ 'CAMBIO' and rsDetProvision.CPCano*100+rsDetProvision.CPCmes EQ rsMeses.CPCano*100+rsMeses.CPCmes> selected</cfif>>#rsMeses.CPCano# - #ListGetAt(meses, rsMeses.CPCmes, ',')#</option>
                        </cfloop>
                   	    </select>
					</td>
					<td nowrap align="right" nowrap class="fileLabel">
						<INPUT style="width:5px;border:solid 2px ##FFFFFF;background-color:##FFFFFF" disabled>Tipo de Item:
					</td>
					<td nowrap>
						<select name="CPDDtipoItem" id="CPDDtipoItem" onChange="javascript: fnItem();">
						<cfif modoDet EQ 'ALTA' and rsProvision.CPDEsuficiencia EQ 0>
							<cfset LvarDspCuenta		= "">
							<cfset LvarDspConcepto		= "none">
							<cfset LvarDspCF 			= "none">
							<cfset LvarDspDistribucion	= "none">
<!--- Suficiencia para Activo Fíjo INICIA --->
                            <cfset LvarDspCategoria		= "none">
                            <cfset LvarDspClasifica		= "none">
							<cfset LvarDspClasifica2    = "none">
							<cfset LvarChDistribucion   = "none">
							<cfset LvarChDistribucion2   = "none">
                            <cfset tipoItem = ''>
<!--- Suficiencia para Activo Fíjo FIN --->
							<option value="0">Cuenta</option>
							<option value="S">Servicio</option>
							<option value="D">Distribución</option>
<!--- Suficiencia para Activo Fíjo INICIA --->
                            <option value="F">Activo Fijo</option>
							<option value="C">Clasificaci&oacute;n</option>
<!--- Suficiencia para Activo Fíjo FIN --->
						<cfelseif modoDet EQ 'ALTA'>
							<cfset LvarDspCuenta		= "none">
							<cfset LvarDspConcepto		= "">
							<cfset LvarDspCF 			= "none">
							<cfset LvarDspDistribucion	= "none">
<!--- Suficiencia para Activo Fíjo INICIA --->
                            <cfset LvarDspCategoria		= "none">
                            <cfset LvarDspClasifica		= "none">
							<cfset LvarDspClasifica2    = "none">
							<cfset LvarChDistribucion   = "none">
							<cfset LvarChDistribucion2   = "none">
<!--- Suficiencia para Activo Fíjo FIN --->
							<option value="S">Servicio</option>
							<option value="D">Distribución</option>
<!--- Suficiencia para Activo Fíjo INICIA --->
                            <option value="F">Activo Fijo</option>
							<option value="C">Clasificaci&oacute;n Invetario</option>
<!--- Suficiencia para Activo Fíjo FIN --->
						<cfelseif rsDetProvision.CPDDtipoItem EQ "0">
							<cfset LvarDspCuenta		= "">
							<cfset LvarDspConcepto		= "none">
							<cfset LvarDspCF 			= "none">
							<cfset LvarDspDistribucion	= "none">
<!--- Suficiencia para Activo Fíjo INICIA --->
                            <cfset LvarDspCategoria		= "none">
                            <cfset LvarDspClasifica		= "none">
							<cfset LvarDspClasifica2    = "none">
							<cfset LvarChDistribucion   = "none">
							<cfset LvarChDistribucion2   = "none">
<!--- Suficiencia para Activo Fíjo FIN --->
							<option value="0">Cuenta</option>
						<cfelseif  rsDetProvision.CPDDtipoItem EQ "S">
							<cfset LvarDspCuenta		= "none">
							<cfset LvarDspConcepto		= "">
							<cfset LvarDspCF 			= "">
							<cfset LvarDspDistribucion	= "none">
<!--- Suficiencia para Activo Fíjo INICIA --->
                            <cfset LvarDspCategoria		= "none">
                            <cfset LvarDspClasifica		= "none">
							<cfset LvarDspClasifica2    = "none">
							<cfset LvarChDistribucion   = "none">
							<cfset LvarChDistribucion2   = "none">

<!--- Suficiencia para Activo Fíjo FIN --->
							<option value="S">Servicio</option>
						<cfelseif rsDetProvision.CPDDtipoItem EQ "D">
							<cfset LvarDspCuenta		= "none">
							<cfset LvarDspConcepto		= "">
							<cfset LvarDspCF 			= "none">
							<cfset LvarDspDistribucion	= "">
<!--- Suficiencia para Activo Fíjo INICIA --->
                            <cfset LvarDspCategoria		= "none">
                            <cfset LvarDspClasifica		= "none">
						<cfif rsDetProvision.Ccodigoclas EQ "">
							<cfset LvarChDistribucion   = "">
							<cfset LvarChDistribucion2   = "none">
							<cfset LvarDspClasifica2    = "none">
							<cfset LvarDspConcepto		= "">
						<cfelse>
							<cfset LvarChDistribucion   = "none">
							<cfset LvarChDistribucion2   = "">
							<cfset LvarDspClasifica2    = "">
							<cfset LvarDspConcepto		= "none">
						</cfif>
<!--- Suficiencia para Activo Fíjo FIN --->
							<option value="D">Distribución</option>
<!--- Suficiencia para Activo Fíjo INICIA --->
						<cfelseif rsDetProvision.CPDDtipoItem EQ "F">
							<cfset LvarDspCuenta		= "none">
							<cfset LvarDspConcepto		= "none">
							<cfset LvarDspCF 			= "">
							<cfset LvarDspDistribucion	= "none">
                            <cfset LvarDspCategoria		= "">
                            <cfset LvarDspClasifica		= "">
							<cfset LvarDspClasifica2    = "none">
							<cfset LvarChDistribucion   = "none">
							<cfset LvarChDistribucion2   = "none">
							<option value="F">Activo Fijo</option>
						<cfelseif  rsDetProvision.CPDDtipoItem EQ "C">
							<cfset LvarDspCuenta		= "none">
							<cfset LvarDspConcepto		= "none">
							<cfset LvarDspCF 			= "">
							<cfset LvarDspDistribucion	= "none">
<!--- Suficiencia para Activo Fíjo INICIA --->
                            <cfset LvarDspCategoria		= "none">
                            <cfset LvarDspClasifica		= "none">
							<cfset LvarDspClasifica2    = "">
							<cfset LvarChDistribucion   = "none">
							<cfset LvarChDistribucion2   = "none">
<!--- Suficiencia para Activo Fíjo FIN --->
							<option value="C">Clasificaci&oacute;n Invetario</option>
						</cfif>
						</select>
						<script language="javascript">
							function fnItem()
							{
								document.form1.Cid.value = '';
								document.form1.Ccodigo.value = '';
								document.form1.Cdescripcion.value = '';
								document.form1.cuentac.value = '';
								document.form1.ACcodigo.value = '0';
<!--- 							if(document.form1.ACid != undefined) --->
								document.form1.ACid.value = '0';
								document.form1.mensaje.value="";
								var o = document.getElementById("CPDDtipoItem");
								if (o.value == '0')
								{
									document.getElementById("imgCuenta").style.display 			= "";
									document.getElementById("imgCuenta").style.display 			= "";
									document.getElementById("lblConcepto").style.display 		= "none";
									document.getElementById("tdConcepto").style.display 		= "none";
									document.getElementById("lblDistribucion").style.display 	= "none";
									document.getElementById("tdDistribucion").style.display 	= "none";
									document.getElementById("lblCFuncional").style.display   	= "none";
									document.getElementById("tdCFuncional").style.display 	    = "none";
<!--- Suficiencia para Activo Fíjo INICIA --->
									document.getElementById("lblCategoria").style.display   	= "none";
									document.getElementById("tdCategoria").style.display 	    = "none";
									document.getElementById("lblClasif").style.display   		= "none";
									document.getElementById("tdClasif").style.display 	   	 	= "none";
									document.getElementById("tdClasif2").style.display 	    	= "none";
									document.getElementById("lblClasifA").style.display   		= "none";
									document.getElementById("lblChDist").style.display			= "none";
									document.getElementById("lblChDist2").style.display			= "none";

<!--- Suficiencia para Activo Fíjo FIN --->
								}
								else if (o.value == 'S')
								{
									document.getElementById("imgCuenta").style.display 			= "none";
									document.getElementById("imgCuenta").style.display 			= "none";
									document.getElementById("lblConcepto").style.display 		= "";
									document.getElementById("tdConcepto").style.display 		= "";
									document.getElementById("lblDistribucion").style.display 	= "none";
									document.getElementById("tdDistribucion").style.display 	= "none";
<!--- Suficiencia para Activo Fíjo INICIA --->
									document.getElementById("lblCategoria").style.display   	= "none";
									document.getElementById("tdCategoria").style.display 	    = "none";
									document.getElementById("lblClasif").style.display   		= "none";
									document.getElementById("tdClasif").style.display 	    	= "none";
									document.getElementById("tdClasif2").style.display 	    	= "none";
									document.getElementById("lblClasifA").style.display   		= "none";
									document.getElementById("lblChDist").style.display			= "none";
									document.getElementById("lblChDist2").style.display			= "none";

<!--- Suficiencia para Activo Fíjo FIN --->
									sbCFuncionalDisplay();
								}
								else if (o.value == 'D')
								{
									document.getElementById("imgCuenta").style.display 			= "none";
									document.getElementById("imgCuenta").style.display 			= "none";
									document.getElementById("lblConcepto").style.display 		= "";
									document.getElementById("tdConcepto").style.display 		= "";
									document.getElementById("lblDistribucion").style.display 	= "";
									document.getElementById("tdDistribucion").style.display 	= "";
									document.getElementById("lblCFuncional").style.display   	= "none";
									document.getElementById("tdCFuncional").style.display 	    = "none";
<!--- Suficiencia para Activo Fíjo INICIA --->
									document.getElementById("lblCategoria").style.display   	= "none";
									document.getElementById("tdCategoria").style.display 	    = "none";
									document.getElementById("lblClasif").style.display   		= "none";
									document.getElementById("tdClasif").style.display 	    	= "none";
									document.getElementById("tdClasif2").style.display 	    	= "none";
									document.getElementById("lblClasifA").style.display   		= "none";
									document.getElementById("lblChDist").style.display			= "";
									document.getElementById("lblChDist2").style.display			= "";
									document.form1.TD[0].checked =  true;

<!--- Suficiencia para Activo Fíjo FIN --->
								}
<!--- Suficiencia para Activo Fíjo INICIA --->
								else if (o.value == 'F')
								{
									document.getElementById("imgCuenta").style.display 			= "none";
									document.getElementById("imgCuenta").style.display 			= "none";
									document.getElementById("lblConcepto").style.display 		= "none";
									document.getElementById("tdConcepto").style.display 		= "none";
									document.getElementById("lblDistribucion").style.display 	= "none";
									document.getElementById("tdDistribucion").style.display 	= "none";
<!--- Suficiencia para Activo Fíjo INICIA --->
									document.getElementById("lblCategoria").style.display   	= "";
									document.getElementById("tdCategoria").style.display 	    = "";
									document.getElementById("lblClasif").style.display   		= "";
									document.getElementById("tdClasif").style.display 	    	= "";
									document.getElementById("lblClasifA").style.display   		= "none";
									document.getElementById("tdClasif2").style.display 	    	= "none";
									document.getElementById("lblChDist").style.display			= "none";
									document.getElementById("lblChDist2").style.display			= "none";

<!--- Suficiencia para Activo Fíjo FIN --->
									sbCFuncionalDisplay();
								}
<!--- Suficiencia para Clasificaciones --->
								else if (o.value == 'C')
								{
									document.getElementById("imgCuenta").style.display 			= "none";
									document.getElementById("imgCuenta").style.display 			= "none";
									document.getElementById("lblConcepto").style.display 		= "none";
									document.getElementById("tdConcepto").style.display 		= "none";
									document.getElementById("lblDistribucion").style.display 	= "none";
									document.getElementById("tdDistribucion").style.display 	= "none";
<!--- Suficiencia para Activo Fíjo INICIA --->
									document.getElementById("lblCategoria").style.display   	= "none";
									document.getElementById("tdCategoria").style.display 	    = "none";
									document.getElementById("lblClasif").style.display   		= "none";
									document.getElementById("lblClasifA").style.display   		= "";
									document.getElementById("tdClasif").style.display 	    	= "none";
									document.getElementById("tdClasif2").style.display 	    	= "";
									document.getElementById("lblChDist").style.display			= "none";
									document.getElementById("lblChDist2").style.display			= "none";

<!--- Suficiencia para Clasificación Fíjo FIN --->
									sbCFuncionalDisplay();
								}
							}

							function sbCFuncionalDisplay()
							{
								if (document.getElementById("CPDDtipoItem").value != "S" && document.getElementById("CPDDtipoItem").value != "F" && document.getElementById("CPDDtipoItem").value != "C")
								{
									document.getElementById("lblCFuncional").style.display   	= "none";
									document.getElementById("tdCFuncional").style.display 	    = "none";
									return;
								}
								<cfif LvarSuficiencia EQ 1>
										document.getElementById("lblCFuncional").style.display   	= "";
										document.getElementById("tdCFuncional").style.display 	    = "";
								<cfelseif LvarSuficiencia EQ 2>
										document.getElementById("lblCFuncional").style.display   	= "none";
										document.getElementById("tdCFuncional").style.display 	    = "none";
								<cfelse>
								 if (document.form1.CPDEsuficiencia.checked)
									{
										document.getElementById("lblCFuncional").style.display   	= "";
										document.getElementById("tdCFuncional").style.display 	    = "";
									}
									else
									{
										document.getElementById("lblCFuncional").style.display   	= "none";
										document.getElementById("tdCFuncional").style.display 	    = "none";
									}
								</cfif>
							}
						</script>
					</td>

					<td align="right" id="lblChDist" style="display:#LvarChDistribucion#">Concepto&nbsp;
						<input type ="radio" <cfif isdefined('rsDetProvision') and rsDetProvision.CPDDtipoItem EQ "D" && rsDetProvision.Ccodigoclas EQ "">checked</cfif>
						name="TD" value="1" onclick="validaDist();"></td>

					<td align="left" id="lblChDist2" style="display:#LvarChDistribucion2#">Clasificaci&oacute;n&nbsp;
						<input type ="radio" <cfif isdefined('rsDetProvision') and rsDetProvision.CPDDtipoItem EQ "D" && rsDetProvision.Ccodigoclas NEQ "">checked</cfif>
						 name="TD" value="2" onclick="validaDist();"></td>

<!--- Suficiencia para Activo Fíjo INICIA --->
                   	<td align="right" id="lblCategoria" style="display:#LvarDspCategoria#">
                    	Categor&iacute;a:
                    </td>

                    <td align="left" id="tdCategoria" style="display:#LvarDspCategoria#">
                        <select tabindex="1" name="ACcodigo"  onChange="javascript:cambiar_categoria(this.value,'');" >
                        	<option value="0" selected>"Seleccionar Categoría" </option>
                            <cfloop query="rsCategorias">
                                <cfif modoDet EQ 'ALTA'>
                                    <option value="#rsCategorias.ACcodigo#">#rsCategorias.ACdescripcion#</option>
                                <cfelse>
                                    <option disabled="disabled" value="#rsCategorias.ACcodigo#" <cfif #rsDetProvision.ACcodigo# eq #rsCategorias.ACcodigo# >selected</cfif> >#rsCategorias.ACdescripcion#</option>
                                </cfif>
                       	 	</cfloop>
                        </select>
					  </td>
				<!--- Suficiencia para Activo Fíjo FIN --->
				</tr>
				<tr>
					<cfif modo EQ "CAMBIO">
                    <td nowrap align="right" nowrap class="fileLabel">Monto en #rsProvision.Miso4217#:</td>
					<cfelse>
                    <td nowrap align="right" nowrap class="fileLabel">Monto en #rsLocal.Miso4217#:</td>
					</cfif>
					<td nowrap>
						<input type="text" name="CPDDmontoOri" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2); document.form1.CPDDmonto.value = fm(qf(this.value)*#rsProvision.CPDEtc#,2)" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modoDet EQ 'CAMBIO'>#LSNumberFormat(rsDetProvision.CPDDmontoOri,',9.00')#<cfelse>0.00</cfif>">
					</td>
					<!--- CONCEPTO --->
					<td align="right" id="lblConcepto" style="display:#LvarDspConcepto#">
						Concepto:&nbsp;
					</td>
					<td id="tdConcepto" style="display:#LvarDspConcepto#">
						<cfif modoDet neq 'ALTA'>
							<cfquery name="rsConcepto" datasource="#session.dsn#">
								select Cid, Ccodigo, Cdescripcion from Conceptos where Cid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDetProvision.Cid#" voidnull>
							</cfquery>
							<cf_sifconceptos query=#rsConcepto# size="35" verclasificacion="1">
						<cfelse>
							<cf_sifconceptos size="25" verclasificacion="1" tabindex="0">
						</cfif>
						<script language="javascript">
							function funcCcodigo()
							{
								fnTraerCtaServicio();
							}

							function funcCFcodigoDet()
							{
								fnTraerCtaServicio();
							}

							function fnTraerCtaServicio()
							{
								if (document.form1.CPDDtipoItem.value != 'S')
									return;

								var varMyCFcodigo = '';
								var varMyCFid     = '';
							<cfif LvarSuficiencia EQ 1>
								var CFdet = true;
							<cfelseif LvarSuficiencia EQ 2>
								var CFdet = false;
							<cfelse>
								var CFdet = (document.form1.CPDEsuficiencia.checked);
							</cfif>
								if (CFdet)
								{
								  	varMyCFcodigo = document.form1.CFcodigoDet.value;
								}
								else
								{
									varMyCFid = document.form1.CFid.value;
									if (document.form1.CFid.options)
									{
										var LvarCFid = document.form1.CFid.options[document.form1.CFid.selectedIndex];
										document.form1.CFid.options.length = 0;
										document.form1.CFid.options.add (LvarCFid);
									}
								}
								fnSetCuenta("","","");
								document.form1.mensaje.value = "";
								if (document.form1.Cid.value != '' && (varMyCFid != '' || varMyCFcodigo != '') )
								{
									document.getElementById("ifrGenCuenta").src="reserva-sql.cfm?OP=GEN&CPDDtipoItem=S&CPPid=#rsProvision.CPPid#&CPCanoMes=" + document.form1.CPCanoMes.value + "&Cid=" + document.form1.Cid.value + "&CFid=" + varMyCFid + "&CFcodigo= " + varMyCFcodigo + "&CPDEid= " + document.form1.CPDEid.value;

								}

							}

							function fnSetCuenta(c,f,d,m)
							{
								document.form1.CPcuenta.value = c;
								document.form1.CPformato.value = f;
								document.form1.CPdescripcion.value = d;
							}
						</script>
						<iframe id="ifrGenCuenta" style="display:none"></iframe>
					</td>
<!--- Suficiencia para Activo Fíjo INICIA --->
                    <td align="right" id="lblClasif" style="display:#LvarDspClasifica#">
                    	Clasificaci&oacute;n:
                    </td>

                    <td align="left" id="tdClasif" style="display:#LvarDspClasifica#">
						<cfif modoDet EQ "CAMBIO">
							<input type="text" name="Clasificacion" style="width:240px;" value="<cfif modoDet EQ 'CAMBIO'>#rsDetProvision.ACdescripcion#</cfif>" readonly>

						<cfelseif modoDet EQ "ALTA">
                    		<select name="ACid" tabindex="1"></select>
						</cfif>
                    </td>


<!--- Clasificaciones para Articulos--->
					<td align="right" id="lblClasifA" style="display:#LvarDspClasifica2#">
                    	Clasificaci&oacute;n:
                    </td>

					<td align="left" id="tdClasif2" style="display:#LvarDspClasifica2#">
		                	<cfset LvarC = "no">
						<cfif modo neq 'ALTA' and isdefined('rsClasificaciones')>
							<cf_sifclasificacionarticulo tabindex="1" query="#rsClasificaciones#" desc="DescArt" id="Ccodigo2">
						<cfelse>
							<cf_sifclasificacionarticulo tabindex="1"  Cconsecutivo="#LvarC#" desc="DescArt" id="Ccodigo2">
						</cfif>

					<script language="javascript">

							function funcCcodigoclas()
							{
								var varMyCFcodigo = '';
								var varMyCFid     = '';

								<cfif LvarSuficiencia EQ 1>
								var CFdet = true;
							<cfelseif LvarSuficiencia EQ 2>
								var CFdet = false;
							<cfelse>
								var CFdet = (document.form1.CPDEsuficiencia.checked);
							</cfif>
								if (CFdet)
								{
								  	varMyCFcodigo = document.form1.CFcodigoDet.value;
								}
								else
								{
									varMyCFid = document.form1.CFid.value;
									if (document.form1.CFid.options)
									{
										var LvarCFid = document.form1.CFid.options[document.form1.CFid.selectedIndex];
										document.form1.CFid.options.length = 0;
										document.form1.CFid.options.add (LvarCFid);
									}
								}

								fnSetCuenta("","","","");

								if (document.form1.CPDDtipoItem.value == 'C' && (varMyCFid != '' || varMyCFcodigo != '') )
								{
								document.getElementById("ifrGenCuenta").src="reserva-sql.cfm?OP=GEN&CPPid=#rsProvision.CPPid#&CPCanoMes="
								  + document.form1.CPCanoMes.value + "&CFid=" + varMyCFid + "&CFcodigo= " + varMyCFcodigo +
								   "&CPDDtipoItem= "+ document.form1.CPDDtipoItem.value + "&CPDEid= " + document.form1.CPDEid.value +
								   "&Ccodigoclas=" +document.form1.Ccodigoclas.value;
								}
							}

							function fnSetCuenta(c,f,d,m)
							{
								document.form1.CPcuenta.value = c;
								document.form1.CPformato.value = f;
								document.form1.CPdescripcion.value = d;
								document.form1.mensaje.value = m;
							}

						</script>
					</td>

                     <!----- Centro Funcional (Solo para Servicio y cuando es provision para compras)--->
                   	<td align="right" id="lblCFuncional" style="display:#LvarDspCF#">
						Centro Funcional:&nbsp;
					</td>
					<td id="tdCFuncional" style="display:#LvarDspCF#">
						<cfif mododet NEQ "ALTA" and isdefined('rsDetProvision') and rsDetProvision.recordCount GT 0>
							<cf_rhcfuncionalCxP name="CFcodigoDet" id="CFidDet" form="form1" size="30" query="#rsDetProvision#"
								titulo="Seleccione el Centro Funcional Responsable" tabindex="0"
								>
						<cfelse>
							<cf_rhcfuncionalCxP name="CFcodigoDet" id="CFidDet" form="form1" size="30"
								titulo="Seleccione el Centro Funcional Responsable" tabindex="0"
								>
						</cfif>

							<script language="javascript">
							function validaDist(){

								if(document.form1.TD[1].checked){
									document.getElementById("lblConcepto").style.display 		= "none";
									document.getElementById("tdConcepto").style.display 		= "none";
									document.getElementById("lblClasifA").style.display   		= "";
									document.getElementById("tdClasif2").style.display 	    	= "";
									document.form1.Ccodigo.value = "";
								}else{
									document.getElementById("lblConcepto").style.display 		= "";
									document.getElementById("tdConcepto").style.display 		= "";
									document.getElementById("lblClasifA").style.display   		= "none";
									document.getElementById("tdClasif2").style.display 	    	= "none";
									document.form1.Ccodigoclas.value = "";

								}

							}

							function funcCcodigo()
							{
								fnTraerCtaPpto();
							}

							function funcCFcodigoDet()
							{
								fnTraerCtaPpto();
							}

							function fnTraerCtaPpto()
							{
								if (document.form1.CPDDtipoItem.value == 'C')
								{
								funcCcodigoclas();
								}

								if (document.form1.CPDDtipoItem.value != 'F' && document.form1.CPDDtipoItem.value != 'S')
									return;

								if (document.form1.CPDDtipoItem.value != 'F' && document.form1.CPDDtipoItem.value == 'S')
								{
								fnTraerCtaServicio();
								}

								var varMyCFcodigo = '';
								var varMyCFid     = '';
							<cfif LvarSuficiencia EQ 1>
								var CFdet = true;
							<cfelseif LvarSuficiencia EQ 2>
								var CFdet = false;
							<cfelse>
								var CFdet = (document.form1.CPDEsuficiencia.checked);
							</cfif>
								if (CFdet)
								{
								  	varMyCFcodigo = document.form1.CFcodigoDet.value;
								}
								else
								{
									varMyCFid = document.form1.CFid.value;
									if (document.form1.CFid.options)
									{
										var LvarCFid = document.form1.CFid.options[document.form1.CFid.selectedIndex];
										document.form1.CFid.options.length = 0;
										document.form1.CFid.options.add (LvarCFid);
									}
								}

								fnSetCuenta("","","");
								document.form1.mensaje.value = "";

								if (document.form1.CPDDtipoItem.value == 'F' && (varMyCFid != '' || varMyCFcodigo != '') )
								{

								document.getElementById("ifrGenCuenta").src="reserva-sql.cfm?OP=GEN&CPPid=#rsProvision.CPPid#&CPCanoMes=" + document.form1.CPCanoMes.value + "&CFid=" + varMyCFcodigo + "&CFcodigo= " + varMyCFcodigo + "&ACid= " + document.form1.ACid.value  + "&CPDDtipoItem= "+ document.form1.CPDDtipoItem.value + "&CPDEid= " + document.form1.CPDEid.value + "&Cid=" + 0;

								}
							}
								function fnSetCuenta(c,f,d,m)
							{
								document.form1.CPcuenta.value = c;
								document.form1.CPformato.value = f;
								document.form1.CPdescripcion.value = d;
							}
						</script>
						<iframe id="ifrGenCuenta" style="display:none"></iframe>
		            </td>
					<!--- Distribución --->
					<td  align="right" id="lblDistribucion" style="display:#LvarDspDistribucion#">
						Distribucion:&nbsp;
					</td>
					<td id="tdDistribucion" style="display:#LvarDspDistribucion#">
						<select name="CPDCid">
						<cfloop query="rsDistribuciones">
							<option value="#rsDistribuciones.CPDCid#" <cfif mododet EQ 'CAMBIO' AND rsDistribuciones.CPDCid EQ rsDetProvision.CPDCid>selected</cfif>>#rsDistribuciones.Descripcion#</option>
						</cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<!--- CUENTA --->
					 <td class="fileLabel" colspan="1" align="right" nowrap style="width:200px">Monto Local:</td>
				    <td nowrap>
						<cfif modoDet EQ "CAMBIO" and rsDetProvision.CPDDtipoItem NEQ "D">
							<cfset LvarDisponible = LstrDisponible.Disponible>
						<cfelse>
							<cfset LvarDisponible = ''>
						</cfif>
						<input type="hidden" name="disponible" id="disponible" value="#LvarDisponible#">
						<input type="text" name="CPDDmonto" size="20" maxlength="18" style="text-align: right; border:1px solid ##CCCCCC;" readonly tabindex="-1" value="<cfif modoDet EQ 'CAMBIO'>#LSNumberFormat(rsDetProvision.CPDDmonto,',9.00')#<cfelse>0.00</cfif>">
					</td>
				    <td align="right" id="lblCuenta">Cuenta Presupuesto:</td>
				    <td  id="tdCuenta"  nowrap="nowrap" colspan="4">

						<input type="hidden" name="CPcuenta" value="<cfif modoDet EQ 'CAMBIO'>#rsDetProvision.CPcuenta#</cfif>">
						<input type="text" name="CPformato" style="width:240px;" value="<cfif modoDet EQ 'CAMBIO'>#rsDetProvision.CPformato#</cfif>" readonly>
						<input type="text" name="CPdescripcion" size="50" value="<cfif modoDet EQ 'CAMBIO'>#rsDetProvision.CPdescripcion#</cfif>" readonly style="border:solid 1px ##CCCCCC" tabindex="-1">
				   		<a href="##"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Cuentas de Presupuesto" id="imgCuenta" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisCuentas();"  style="display:#LvarDspCuenta#"></a>

					</td>
				</tr>
				<tr>
                    <td></td>
                    <td></td>

					<td colspan="10">
						&nbsp;&nbsp;
						<cfif modoDet EQ "CAMBIO">
							<cfif rsDetProvision.CPDDtipoItem EQ "D">
								<cfset mensaje = "">
								<input type="hidden" name="validarDisponible" value="0">
							<cfelseif LstrDisponible.CPCPtipoControl EQ "0">
								<cfset mensaje = 'Control Abierto Disponible: ' & LSNumberFormat(LvarDisponible, ',9.00')>
								<input type="hidden" name="validarDisponible" value="0">
							<cfelseif LvarDisponible LTE 0>
								<cfset mensaje = 'No tiene Presupuesto Disponible: ' & LSNumberFormat(LvarDisponible, ',9.00')>
								<input type="hidden" name="validarDisponible" value="1">
							<cfelse>
								<cfset mensaje = 'Máximo Disponible: ' & LSNumberFormat(LvarDisponible, ',9.00')>
								<input type="hidden" name="validarDisponible" value="1">
							</cfif>
						<cfelse>
							<cfset mensaje = ''>
							<input type="hidden" name="validarDisponible" value="0">
						</cfif>
						<input name="mensaje" type="text" style="font-weight: bold; border: none; color:##FF0000; width: 750px" value="#mensaje#" readonly>
					</td>
				    </tr>
				  <tr>
				    <td colspan="8" align="center">
						<cfset ts = "">
						<cfif modoDet NEQ "ALTA">
						  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsDetProvision.ts_rversion#" returnvariable="ts">
						  </cfinvoke>
						</cfif>
						<input type="hidden" name="ts_rversionDet" value="<cfif modo EQ "CAMBIO"><cfoutput>#ts#</cfoutput></cfif>">
						<cfif modoDet EQ "ALTA">
							<input type="submit" name="btnAgregarD" value="Agregar Detalle" onClick="javascript: if (window.habilitarValidacionD) habilitarValidacionD(); ">
						<cfelse>
							<cfif rsDetProvision.CPDDtipoItem EQ "D">
								<input type="submit" name="btnCambiarD" value="Regenerar Distribución" onClick="javascript: if (window.habilitarValidacionD) habilitarValidacionD(); ">
								<input type="submit" name="btnBajaD" 	value="Eliminar Distribución" onclick="javascript: if ( confirm('¿Desea eliminar TODOS los detalles de esta Distribución del Documento de #LvarTipoProvision#?') ){ if (window.inhabilitarValidacionD) inhabilitarValidacionD(); return true; }else{ return false;}">
							<cfelse>
								<input type="submit" name="btnCambiarD" value="Modificar Detalle" onClick="javascript: if (window.habilitarValidacionD) habilitarValidacionD(); ">
								<input type="submit" name="btnBajaD" 	value="Eliminar Detalle" onclick="javascript: if ( confirm('¿Desea eliminar el detalle del Documento de #LvarTipoProvision#?') ){ if (window.inhabilitarValidacionD) inhabilitarValidacionD(); return true; }else{ return false;}">
							</cfif>
							<input type="submit" name="btnNuevoD" value="Nuevo Detalle" onClick="javascript: if (window.inhabilitarValidacionD) inhabilitarValidacionD(); ">
						</cfif>
					</td>
				  </tr>
				</table>
			</td>
		  </tr>
		</table>
	  </td>
	</tr>
	</cfif>
  </table>
</form>
</cfoutput>
<cfif modo EQ "CAMBIO">
	<table width="98%"  border="0" cellspacing="0" cellpadding="2" align="center">
	  <tr>
		<td>
			<cfset LvarMontosD = "CPDDmonto">
			<cfset LvarMontosE = "Monto #rsLocal.Miso4217#">
			<cfif rsProvision.Mcodigo NEQ rsLocal.Mcodigo>
				<cfset LvarMontosD = "CPDDmontoOri,CPDDmonto">
				<cfset LvarMontosE = "Monto #rsProvision.Miso4217#,Monto #rsLocal.Miso4217#">
			</cfif>
			<cfinvoke
			 component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
			  <cfinvokeargument name="tabla" value="CPDocumentoD a
			  											inner join CPresupuesto c 	 on c.Ecodigo = #Session.Ecodigo# and c.CPcuenta = a.CPcuenta
			  											 left join Conceptos cc 	 on cc.Cid = a.Cid
			  											 left join CFuncional ff 	 on ff.CFid = a.CFid
														 left join ACategoria ca  	 on ca.ACcodigo = a.ACcodigo
														 left join AClasificacion cl on cl.ACid = a.ACid
														 left join Clasificaciones cf 	on  a.Ccodigoclas = cf.Ccodigoclas
														"/>
			  <cfinvokeargument name="columnas" value="a.CPDEid, a.CPDDid, a.CPCano, cc.Cdescripcion, ca.ACdescripcion as Categoria,case when cl.ACdescripcion is not NULL then cl.ACdescripcion when cf.Cdescripcion is not NULL then cf.Cdescripcion  end as Clasificacion, coalesce(ff.CFcodigo,'#rsProvision.CFcodigo#') as CFcodigo,
			  										   case a.CPCmes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end as MesDescripcion,
			  										   c.CPformato as Cuenta, coalesce(c.CPdescripcionF,c.CPdescripcion) as DescCuenta, a.CPDDmonto,a.CPDDmontoOri,
													   case when CPDCid is not NULL then 'D' end as Dist, cf.Ccodigoclas
													   "/>
			  <cfinvokeargument name="desplegar" value="CPCano, MesDescripcion, Dist, Cdescripcion, Categoria, Clasificacion, CFcodigo, Cuenta, DescCuenta,#LvarMontosD#"/>
			  <cfinvokeargument name="etiquetas" value="A&ntilde;o, Mes, Dist, Concepto, Categoria, Clasificación, CF, Cuenta, Descripci&oacute;n Cuenta,#LvarMontosE#"/>
			  <cfinvokeargument name="formatos" value="V,V,V,V,V,V,V,V,V,M,M"/>
			  <cfinvokeargument name="filtro" value="a.CPDEid = #Form.CPDEid#
													and a.Ecodigo = #Session.Ecodigo#
													order by a.CPDDlinea
													"/>
			  <cfinvokeargument name="align" value="center, left, left, left, left, left, left, left, left, right, right"/>
			  <cfinvokeargument name="ajustar" value="N"/>
			  <cfinvokeargument name="checkboxes" value="N"/>
			  <cfinvokeargument name="keys" value="CPDEid, CPDDid"/>
			  <cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
			  <cfinvokeargument name="PageIndex" value="2"/>
			</cfinvoke>
		</td>
	  </tr>
	</table>
</cfif>

<script language="JavaScript">
	var inicioPeriodo = new Object("");
	var finPeriodo = new Object("");

	<cfoutput>
	<cfloop query="rsCPPeriodos">
		inicioPeriodo['#rsCPPeriodos.CPPid#'] = "#LSDateFormat(CPPfechaDesde, 'dd/mm/yyyy')#";
		finPeriodo['#rsCPPeriodos.CPPid#'] = "#LSDateFormat(CPPfechaHasta, 'dd/mm/yyyy')#";
	</cfloop>
	</cfoutput>

	function validar(f) {
		<cfif modo EQ "CAMBIO">
		f.obj.CPDDmonto.value = qf(f.obj.CPDDmonto.value);
		</cfif>
		return true;
	}

	function habilitarValidacion() {
		objForm.CPPid.required = true;
		objForm.CPDEfechaDocumento.required = true;
		objForm.CPDEdescripcion.required = true;
	  	<cfif not (modo EQ "CAMBIO" and rsCountDetalle.cant NEQ 0)>
			objForm.CFid.required = true;
		</cfif>
		<cfif modo EQ "CAMBIO">
			inhabilitarValidacionD();
		</cfif>
	}

	function inhabilitarValidacion() {
		objForm.CPPid.required = false;
		objForm.CPDEfechaDocumento.required = false;
		objForm.CPDEdescripcion.required = false;
	  	<cfif not (modo EQ "CAMBIO" and rsCountDetalle.cant NEQ 0)>
		objForm.CFid.required = false;
		</cfif>
		<cfif modo EQ "CAMBIO">
			inhabilitarValidacionD();
		</cfif>
	}

	<cfif modo EQ "CAMBIO">
	function habilitarValidacionD() {
		objForm.CPCanoMes.required = true;

		objForm.Cid.required		= (document.form1.CPDDtipoItem.value == 'S') || (document.form1.CPDDtipoItem.value == 'D' && document.form1.TD[0].checked);
		objForm.Ccodigo2.required = (document.form1.CPDDtipoItem.value == 'C') || (document.form1.CPDDtipoItem.value == 'D' && document.form1.TD[1].checked);
		objForm.CPformato.required	= document.form1.CPDDtipoItem.value != 'D';
		objForm.CPDDmonto.required = true;
		objForm.ACcodigo.required = (document.form1.CPDDtipoItem.value == 'F') && (document.form1.ACcodigo.value == 0);
		objForm.ACid.required = (document.form1.CPDDtipoItem.value == 'F');
	<cfif LvarSuficiencia EQ 2>
		objForm.CFcodigoDet.required = false;
	<cfelse>
		objForm.CFcodigoDet.required = document.getElementById("lblCFuncional").style.display == "";
	</cfif>
	}

	function doConlisCFuncional() {

		var params ="";
		params = params + "?";
		//params = "?CMCid=<cfoutput>#session.compras.comprador#</cfoutput>&form=form1&id=CFid&name=CFcodigo&desc=CFdescripcion";
		params = params + "&form=form1&id=CFidDet&name=CFcodigoDet&desc=CFdescripcionDet";
		popUpWindow("/cfmx/sif/presupuesto/operacion/ConlisCFuncional.cfm"+params,250,200,650,400);
	}

	function inhabilitarValidacionD() {
		objForm.CPCanoMes.required = false;
		objForm.Cid.required	   = false;
		objForm.CPformato.required = false;
		objForm.CPDDmonto.required = false;
		objForm.CFcodigoDet.required = false;
		objForm.ACcodigo.required = false;
		objForm.ACid.required = false;
	}
	</cfif>

	function __isNotCero() {
		if (this.required && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
			this.error = "El campo " + this.description + " no puede ser cero!";
		}
	}

	// Valida que la fecha del documento se encuentra en el rango de un periodo
	function __isFechaDoc() {
		if (this.required) {
			var a = inicioPeriodo[this.obj.form.CPPid.value].split("/");
			var ini = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
			var b = finPeriodo[this.obj.form.CPPid.value].split("/");
			var fin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
			var c = this.value.split("/");
			var fechadoc = new Date(parseInt(c[2], 10), parseInt(c[1], 10)-1, parseInt(c[0], 10));
			if (!(fechadoc >= ini && fechadoc <= fin)) {
				this.error = "La Fecha del Documento debe caer dentro del Rango de Fechas del Periodo de Presupuesto seleccionado";
			}
		}
	}

	// Valida que el monto no sobrepase al disponible
	function __isDisponible() {
		if (this.required && this.obj.form.validarDisponible && this.obj.form.validarDisponible.value == '1') {
			<cfif isdefined("rsProvision.CPDEtc") AND rsProvision.CPDEtc NEQ "">
				<cfset LvarTC = rsProvision.CPDEtc>
			<cfelse>
				<cfset LvarTC = "1">
			</cfif>
<!---			if (parseFloat(qf(this.obj.form.disponible.value)) < parseFloat(qf(this.value))*<cfoutput>#LvarTC#</cfoutput>) {--->
			if (parseFloat(qf(this.obj.form.disponible.value)) < parseFloat(qf(this.value))) {
				this.error = "El monto sobrepasa el máximo disponible";
			}
		}
	}

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_addValidator("isNotCero", __isNotCero);
	_addValidator("isFechaDoc", __isFechaDoc);
	_addValidator("isDisponible", __isDisponible);

	objForm.CPPid.required = true;
	objForm.CPPid.description = "Período para Presupuesto";
	objForm.CPDEfechaDocumento.required = true;
	objForm.CPDEfechaDocumento.description = "Fecha";
	objForm.CPDEfechaDocumento.validateFechaDoc();
	objForm.CPDEdescripcion.required = true;
	objForm.CPDEdescripcion.description = "Descripción";
	objForm.CPDEtc.required = true;
	objForm.CPDEtc.description = "Tipo Cambio";
	objForm.CPDEtc.validateNotCero();
	<cfif not (modo EQ "CAMBIO" and rsCountDetalle.cant NEQ 0)>
	objForm.CFid.required = true;
	objForm.CFid.description = "Centro Funcional";
	objForm.Ccodigo2.description = "Clasificación";
	</cfif>

	<cfif modo EQ "CAMBIO">
		objForm.CPCanoMes.required = true;
		objForm.CPCanoMes.description = "Mes de Presupuesto";
		objForm.Cid.required	  		= true;
		objForm.Cid.description			= "Concepto de Servicio";
		objForm.CPformato.required		= true;
		objForm.CPformato.description	= "Cuenta de Presupuesto";
		objForm.CFcodigoDet.required = false;
		objForm.CFcodigoDet.description = "Centro Funcional Detalle";
		objForm.CPDDmonto.required = true;
		objForm.CPDDmonto.description = "Monto";
		objForm.ACcodigo.description = "Clasificación";
		objForm.ACid.description = "Categoría";

		objForm.CPDDmonto.validateNotCero();
		objForm.CPDDmonto.validateDisponible();
	</cfif>
	<cfif modo EQ "CAMBIO">
		fnItem();

		function funcImprimir()
		{

	 	<cfoutput>
		  var url = '/cfmx/sif/Utiles/genImpr.cfm?archivo=/sif/presupuesto/operacion/reserva-print.cfm&imprime=1&CPDEid=#Form.CPDEid#';
	 	</cfoutput>

		  if (window.print && window.frames && window.frames.printerIframe) {
			var html = '';
			html += '<html>';
			html += '<body onload="parent.printFrame(window.frames.urlToPrint);">';
			html += '<iframe name="urlToPrint" src="' + url + '"><\/iframe>';
			html += '<\/body><\/html>';

			var ifd = window.frames.printerIframe.document;
			ifd.open();
			ifd.write(html);
			ifd.close();
		  }
		  else
		  {
			var win = window.open('', 'printerWindow', 'width=600,height=300,resizable,scrollbars,toolbar,menubar');
			var html = '';
			html += '<html>';
			html += '<frameset rows="100%, *" '
				 +  'onload="opener.printFrame(window.urlToPrint);window.close();">';
			html += '<frame name="urlToPrint" src="' + url + '" \/>';
			html += '<frame src="about:blank" \/>';
			html += '<\/frameset><\/html>';
			win.document.open();
			win.document.write(html);
			win.document.close();
		  }
		  return false;
		}

		function printFrame (frame)
		{
		  if (frame.print)
		  {
			frame.focus();
			frame.print();
			frame.src = "about:blank"
		  }
		}
	</cfif>
<!--- Suficiencia para Activo Fíjo INICIA --->
function cambiar_categoria(valor, selected) {
		if ( valor!= "0" ) {
			// clasificacion
			document.form1.ACid.length = 0;
			i = 0;
			document.form1.ACid.length = i+1;
			document.form1.ACid.options[i].value = '0';
			document.form1.ACid.options[i].text  = 'Seleccionar Clasificación';

			document.form1.ACid.options[i].selected=true;

			i++;
			<cfoutput query="rsClasificacion">
				if ( #Trim(rsClasificacion.ACcodigo)# == valor ){
					document.form1.ACid.length = i+1;
					document.form1.ACid.options[i].value = '#rsClasificacion.ACid#';
					document.form1.ACid.options[i].text  = '#rsClasificacion.ACdescripcion#';
					if ( selected == #Trim(rsClasificacion.ACid)# ){
						document.form1.ACid.options[i].selected=true;
					}
					i++;
				};
			</cfoutput>
			document.getElementById("lblClasif").style.display = "";
			document.getElementById("tdClasif").style.display  = "";
		}
		else
		{
			document.getElementById("lblClasif").style.display = "none";
			document.getElementById("tdClasif").style.display  = "none";
		}
		return;
	}
	<cfoutput>
		<cfif modo neq 'ALTA' and isdefined('rsDetProvision.ACid') and rsDetProvision.ACid neq ''>
			id_clasificacion = '';
			<cfif modoDet neq 'ALTA' and rsDetProvision.ACid neq ''>
				id_clasificacion = #rsDetProvision.ACid#;
			</cfif>
			cambiar_categoria( document.form1.ACcodigo.value, id_clasificacion );
		</cfif>
	</cfoutput>
<!--- Suficiencia para Activo Fíjo FIN --->

</script>

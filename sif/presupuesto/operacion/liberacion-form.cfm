<cfset meses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">

<cfif isdefined("Form.CPDEid") and Len(Trim(Form.CPDEid))>
	<cfset modo="CAMBIO">
<cfelse>  
	<cfset modo="ALTA">
</cfif>

<cfif modo EQ 'CAMBIO'>
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsLiberacion" datasource="#Session.DSN#">
		select a.CPPid, 
			   a.CPDEfecha, 
			   a.CPDEfechaDocumento,
			   rtrim(a.CPDEnumeroDocumento) as CPDEnumeroDocumento, 
			   a.CPDEdescripcion, 
			   a.Usucodigo,
				'Presupuesto ' #_Cat#
					case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
					#_Cat# ' de ' #_Cat# 
					case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
					#_Cat# ' a ' #_Cat# 
					case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
			   as DescripcionPeriodo,		   		   
			   a.ts_rversion,
			   c.CFid,
			   rtrim(c.CFcodigo) as CFcodigo,
			   c.CFdescripcion,
			   d.Odescripcion,
			   CPDEsuficiencia
		from CPDocumentoE a, CPresupuestoPeriodo b, CFuncional c, Oficinas d
		where a.Ecodigo = #Session.Ecodigo#
		and a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
		and a.CPDEtipoDocumento = 'L'
		and a.Ecodigo = b.Ecodigo
		and a.CPPid = b.CPPid
		and a.Ecodigo = c.Ecodigo
		and a.CFidOrigen = c.CFid
		and c.Ecodigo = d.Ecodigo
		and c.Ocodigo = d.Ocodigo
	</cfquery>
	
	<cfquery name="rsDetDocsProvision" datasource="#Session.DSN#">
		select 	RD.CPDEid, 
				RD.CPDDlinea, 
				RD.CPDDid,
				RD.CPCano, 
				case RD.CPCmes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end as MesDescripcion,
				c.CPformato as Cuenta, 
				coalesce(c.CPdescripcionF,c.CPdescripcion) as DescCuenta, 
				RD.CPDDmonto,
				RD.CPDDsaldo,
				coalesce(LD.CPDDmonto, 0.00) as MontoLiberacion,
			    cc.Cid, cc.Cdescripcion,
				ff.CFid, ff.CFcodigo
		  from CPDocumentoE LE
			join  CPDocumentoD RD
				 on RD.Ecodigo = LE.Ecodigo
				and RD.CPDEid  = LE.CPDEidRef
			join CPresupuesto c
				 on c.Ecodigo = RD.Ecodigo
				and c.CPcuenta = RD.CPcuenta
			left outer join CPDocumentoD LD
				 on LD.Ecodigo 	= LE.Ecodigo
				and LD.CPDEid	= LE.CPDEid
				and LD.CPDDidRef= RD.CPDDid
			left join Conceptos cc on cc.Cid = RD.Cid
			left join CFuncional ff on ff.CFid = RD.CFid
		 where LE.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
		   and LE.Ecodigo = #Session.Ecodigo#
		 order by RD.CPDDlinea
	</cfquery>
	
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
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	<cfif modo EQ "ALTA">
	<cfoutput>
	function doConlisDocsReserva() {
		var w = 700;
		var h = 400;
		var l = (screen.width-w)/2;
		var t = (screen.height-h)/2;
		popUpWindow("conlisDocsReserva.cfm?p1=form1&p2=CPDEnumeroDocumento&p3=descripcion",l,t,w,h);
	}
	</cfoutput>
	</cfif>
	
</script>

<cfoutput>
<form method="post" name="form1" action="liberacion-sql.cfm" onSubmit="javascript: validar(this);" style="margin: 0;">
  <cfif modo EQ "CAMBIO">
	<input type="hidden" name="CPDEid" value="#Form.CPDEid#">
  </cfif>
  <cfif modo EQ "ALTA">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td class="fileLabel" align="right">&nbsp;</td>
	    <td>&nbsp;</td>
	    </tr>
	  <tr>
		<td width="50%" align="right" nowrap class="fileLabel">SELECCIONE EL DOCUMENTO DE PROVISIÓN PRESUPUESTARIA A LIBERAR:</td>
		<td nowrap>
			<input name="CPDEnumeroDocumento" type="text" size="10" maxlength="10" readonly>
			<input name="descripcion" type="text" size="40" readonly>
		    <a href="##"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Documentos de Provisión Presupuestaria" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisDocsReserva();"></a>
		</td>
	  </tr>
	  <tr>
	    <td class="fileLabel" align="right">&nbsp;</td>
	    <td>&nbsp;</td>
	    </tr>
	  <tr>
	    <td colspan="2" align="center">
		  <input type="submit" name="btnAgregarE" value="Agregar" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion(); ">		</td>
	    </tr>
	  <tr>
	    <td class="fileLabel" align="right">&nbsp;</td>
	    <td>&nbsp;</td>
	    </tr>
	</table>
  <cfelse>
	  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
		<tr>
		  <td colspan="6" align="center" nowrap class="tituloAlterno">Encabezado de Documento de Provisión Presupuestaria</td>
		  </tr>
		<tr>
		  <td align="right" class="fileLabel" nowrap>Per&iacute;odo:</td>
		  <td>
				<input type="hidden" name="CPPid" value="#rsLiberacion.CPPid#">
				#rsLiberacion.DescripcionPeriodo#
		  </td>
		  <td align="right" nowrap class="fileLabel">No. Documento:</td>
		  <td>
			<cfif modo EQ "CAMBIO">
				#rsLiberacion.CPDEnumeroDocumento#
			</cfif>
		  </td>
		  <td align="right" nowrap class="fileLabel">Fecha Documento:</td>
		  <td>
			<cfif modo EQ "CAMBIO">
			  <cfset fecha = LSDateFormat(rsLiberacion.CPDEfechaDocumento, 'dd/mm/yyyy')>
			  <cfelse>
			  <cfset fecha = LSDateFormat(Now(), 'dd/mm/yyyy')>
			</cfif>
			<cf_sifcalendario name="CPDEfechaDocumento" form="form1" value="#fecha#"> 
		  </td>
		</tr>
		<tr>
		  <td align="right" class="fileLabel" nowrap>Descripci&oacute;n:</td>
		  <td><input type="text" name="CPDEdescripcion" size="70" maxlength="80" value="<cfif modo EQ 'CAMBIO'>#rsLiberacion.CPDEdescripcion#</cfif>"></td>
		  <td align="right" nowrap class="fileLabel">Centro Funcional: </td>
		  <td>
				#rsLiberacion.CFcodigo# - #rsLiberacion.CFdescripcion#
				<input type="hidden" id="CFid" name="CFid" value="<cfoutput>#rsLiberacion.CFid#</cfoutput>">
		  </td>
		  <td align="right" nowrap class="fileLabel">Oficina:</td>
		  <td nowrap>#rsLiberacion.Odescripcion#</td>
		</tr>
		<tr>
		  <td colspan="6" align="center" nowrap>
		  	<cfset puedeAplicar = false>
		  	<cfloop query="rsDetDocsProvision">
				<cfif rsDetDocsProvision.MontoLiberacion GT 0>
				  	<cfset puedeAplicar = true>
					<cfbreak>
				</cfif>
			</cfloop>

			<cfset ts = "">
			<cfif modo NEQ "ALTA">
			  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsLiberacion.ts_rversion#" returnvariable="ts">
			  </cfinvoke>
			</cfif>
			<input type="hidden" name="ts_rversion" value="<cfif modo EQ "CAMBIO"><cfoutput>#ts#</cfoutput></cfif>">
			<cfif modo EQ "ALTA">
				<input type="submit" name="btnAgregarE" value="Agregar" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion(); ">
			<cfelse>	
				<input type="submit" name="btnCambiarE" value="Modificar" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion(); ">
				<input type="submit" name="btnBajaE" value="Eliminar" onclick="javascript: if ( confirm('¿Está seguro(a) de que desea eliminar el Documento de Provisión Presupuestaria?') ){ if (window.inhabilitarValidacion) inhabilitarValidacion(); return true; }else{ return false;}">
				<input type="submit" name="btnNuevoE" value="Nuevo" onClick="javascript: if (window.inhabilitarValidacion) inhabilitarValidacion(); ">
				<cfif puedeAplicar>
					<input type="submit" name="btnAplicar" value="Aplicar" onclick="javascript: if ( confirm('Se va a proceder a guardar todos los cambios. ¿Está seguro(a) de que desea aplicar este documento de Liberación de Provisión Presupuestaria?') ){ if (window.inhabilitarValidacionD) inhabilitarValidacionD(); return true; }else{ return false;}">
				</cfif>
			</cfif>
			<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: location.href='liberacion-lista.cfm';">
		  </td>
		</tr>
		<tr>
		  <td colspan="6">&nbsp;</td>
		</tr>
		<!--- Lista de Lineas de Detalle para el Documento de Liberación --->
		<cfif modo EQ "CAMBIO">
		<tr>
		  <td colspan="6">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td align="right" nowrap class="tituloListas" style="padding-right: 5px;">A&ntilde;o</td>
					<td nowrap class="tituloListas" style="padding-right: 5px;">Mes</td>
					<td nowrap class="tituloListas" style="padding-right: 5px;">Concepto</td>
					<td nowrap class="tituloListas" style="padding-right: 5px;">CF</td>
					<td nowrap class="tituloListas" style="padding-right: 5px;">Cuenta</td>
					<td nowrap class="tituloListas" style="padding-right: 5px;">Descripci&oacute;n Cuenta</td>
					<td align="right" nowrap class="tituloListas" style="padding-right: 5px;">Monto Inicial</td>
					<td align="right" nowrap class="tituloListas" style="padding-right: 5px;">Saldo</td>
				    <td align="right" nowrap class="tituloListas" style="padding-right: 5px;">Monto a Liberar</td>
				  </tr>
				  <cfloop query="rsDetDocsProvision">
					  <tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
						<td align="right"  style="padding-right: 5px;"nowrap>#rsDetDocsProvision.CPCano#</td>
						<td style="padding-right: 5px;">#rsDetDocsProvision.MesDescripcion#</td>
						<td style="padding-right: 5px;" nowrap>#rsDetDocsProvision.Cdescripcion#</td>
						<td style="padding-right: 5px;" nowrap>#rsDetDocsProvision.CFcodigo#</td>
						<td style="padding-right: 5px;" nowrap>#rsDetDocsProvision.Cuenta#</td>
						<td style="padding-right: 5px;" nowrap>#rsDetDocsProvision.DescCuenta#</td>
						<td align="right" nowrap style="padding-right: 5px;">#LSNumberFormat(rsDetDocsProvision.CPDDmonto, ',9.00')#</td>
						<td align="right" nowrap style="padding-right: 5px;">
							<input type="hidden" name="CPDDsaldo_#rsDetDocsProvision.CPDDid#" value="#rsDetDocsProvision.CPDDsaldo#">
							#LSNumberFormat(rsDetDocsProvision.CPDDsaldo, ',9.00')#
						</td>
						<td align="right" nowrap style="padding-right: 5px;">
							<input type="text" name="CPDDmonto_#rsDetDocsProvision.CPDDid#" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="#LSNumberFormat(rsDetDocsProvision.MontoLiberacion, ',9.00')#">
						</td>
					  </tr>
				  </cfloop>
			  </table>
		  </td>
		</tr>
		<tr>
		  <td colspan="6">&nbsp;</td>
		  </tr>
		<tr align="center">
		  <td colspan="6">
			<input type="submit" name="btnGuardarD" value="Guardar" onClick="javascript: if (window.habilitarValidacionD) habilitarValidacionD(); ">
			<input type="reset" name="btnResetD" value="Reset">
		  </td>
		</tr>
		<tr>
		  <td colspan="6">&nbsp;</td>
		  </tr>
		</cfif>
	  </table>
  </cfif>
</form>
</cfoutput>

<script language="JavaScript">
	function validar(f) {
		<cfif modo EQ "CAMBIO">
		<cfoutput query="rsDetDocsProvision">
		f.obj.CPDDmonto_#rsDetDocsProvision.CPDDid#.value = qf(f.obj.CPDDmonto_#rsDetDocsProvision.CPDDid#.value);
		</cfoutput>
		</cfif>
		return true;
	}

	function habilitarValidacion() {
		<cfif modo EQ "CAMBIO">
			objForm.CPDEfechaDocumento.required = true;
			objForm.CPDEdescripcion.required = true;
			inhabilitarValidacionD();
		<cfelse>
			objForm.CPDEnumeroDocumento.required = true;
		</cfif>
	}
	
	function inhabilitarValidacion() {
		<cfif modo EQ "CAMBIO">
			objForm.CPDEfechaDocumento.required = false;
			objForm.CPDEdescripcion.required = false;
			inhabilitarValidacionD();
		<cfelse>
			objForm.CPDEnumeroDocumento.required = false;
		</cfif>
	}

	<cfif modo EQ "CAMBIO">
	function habilitarValidacionD() {
		<cfoutput query="rsDetDocsProvision">
		objForm.CPDDmonto_#rsDetDocsProvision.CPDDid#.required = true;
		</cfoutput>
	}

	function inhabilitarValidacionD() {
		<cfoutput query="rsDetDocsProvision">
		objForm.CPDDmonto_#rsDetDocsProvision.CPDDid#.required = false;
		</cfoutput>
	}
	</cfif>

	function __isMenorAlSaldo() {
		if (this.required) {
			var id = this.name.split('_')[1];
			var saldoname = 'CPDDsaldo_'+id;
			var saldo = this.obj.form[saldoname].value;
			if (parseFloat(qf(this.value)) > parseFloat(saldo)) {
				this.error = "El campo "+this.description+" no puede ser mayor al saldo de " +fm(saldo, 2);
			}
		}
	}

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_addValidator("isMenorAlSaldo", __isMenorAlSaldo);

	<cfif modo EQ "CAMBIO">
		objForm.CPDEfechaDocumento.required = true;
		objForm.CPDEfechaDocumento.description = "Fecha";
		objForm.CPDEdescripcion.required = true;
		objForm.CPDEdescripcion.description = "Descripción";
		
		<cfoutput query="rsDetDocsProvision">
		objForm.CPDDmonto_#rsDetDocsProvision.CPDDid#.required = true;
		objForm.CPDDmonto_#rsDetDocsProvision.CPDDid#.description = "Monto Liberación";
		objForm.CPDDmonto_#rsDetDocsProvision.CPDDid#.validateMenorAlSaldo();
		</cfoutput>
	<cfelse>
		objForm.CPDEnumeroDocumento.required = true;
		objForm.CPDEnumeroDocumento.description = "Número de Documento de Provisión Presupuestaria";
	</cfif>
	
</script>

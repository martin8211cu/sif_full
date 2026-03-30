<cfset meses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ENDLC" Default= "Encabezado de Documento de Liberaci&oacute;n de Contratos"  XmlFile="liberacionContratos.xml" returnvariable="LB_ENDLC"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PDO" Default= "Per&iacute;odo:"  XmlFile="liberacionContratos.xml" returnvariable="LB_PDO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CTO" Default= "Contrato:"  XmlFile="liberacionContratos.xml" returnvariable="LB_CTO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FDO" Default= "Fecha Documento:"  XmlFile="liberacionContratos.xml" returnvariable="LB_FDO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DCPN" Default= "Descripci&oacute;n:"  XmlFile="liberacionContratos.xml" returnvariable="LB_DCPN"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_LBA" Default= "Liberar a:"  XmlFile="liberacionContratos.xml" returnvariable="LB_LBA"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SFC" Default= "Suficiencia"  XmlFile="liberacionContratos.xml" returnvariable="LB_SFC"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PresD" Default= "Presupuesto disponible"  XmlFile="liberacionContratos.xml" returnvariable="LB_PresD"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ANIO" Default= "A&ntilde;o"  XmlFile="liberacionContratos.xml" returnvariable="LB_ANIO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Ms" Default= "Mes"  XmlFile="liberacionContratos.xml" returnvariable="LB_Ms"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ITM" Default= "Item"  XmlFile="liberacionContratos.xml" returnvariable="LB_ITM"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CPTO" Default= "Concepto"  XmlFile="liberacionContratos.xml" returnvariable="LB_CPTO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CF" Default= "CF"  XmlFile="liberacionContratos.xml" returnvariable="LB_CF"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CTA" Default= "Cuenta"  XmlFile="liberacionContratos.xml" returnvariable="LB_CTA"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DCTA" Default= "Descripci&oacute;n Cuenta"  XmlFile="liberacionContratos.xml" returnvariable="LB_DCTA"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MTI" Default= "Monto Inicial"  XmlFile="liberacionContratos.xml" returnvariable="LB_MTI"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SDO" Default= "Saldo"  XmlFile="liberacionContratos.xml" returnvariable="LB_SDO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MTL" Default= "Monto a Liberar"  XmlFile="liberacionContratos.xml" returnvariable="LB_MTL"/>


<cfif isdefined("Form.CTContid") and Len(Trim(Form.CTContid))>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfif modo EQ 'CAMBIO'>
	<cfinclude template="../../../Utiles/sifConcat.cfm">

<!--- QUERY SUSTITUTO  --->

	<cfquery name="rsLiberacion" datasource="#Session.DSN#">
			select
				   a.CPPid,
				   b.CTDCont,
				   a.CTContid,
				   a.CTCnumContrato,
				   a.CTCdescripcion,
				   a.CTfecha,a.ts_rversion,
					'Presupuesto ' #_Cat#
						case cp.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
						#_Cat# ' de ' #_Cat#
						case {fn month(cp.CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
						#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(cp.CPPfechaDesde)}">
						#_Cat# ' a ' #_Cat#
						case {fn month(cp.CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
						#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(cp.CPPfechaHasta)}">
				  as PeriodoPres
			from CTContrato  a
				inner join CTDetContrato b
				on a.CTContid = b.CTContid
				inner join CPresupuestoPeriodo cp
				on cp.CPPid = a.CPPid
			where a.Ecodigo = #Session.Ecodigo#
			and a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTContid#">
			order by a.CTfecha desc, a.CTCnumContrato
		</cfquery>

<!--- FIN DEL QUERY SUSTITUTO --->

<cfquery name="rsDetDocsProvision" datasource="#Session.DSN#">
		select 	b.CTContid,
				a.CTCnumContrato,
			 	b.CPDDid,
				b.CPCano,
				b.CTDCont,
				b.CPDCid,dist.CPDCdescripcion,
				case b.CPCmes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end as MesDescripcion,
				c.CPformato as Cuenta,
				coalesce(c.CPdescripcionF,c.CPdescripcion) as DescCuenta,
				b.CTDCmontoTotal,
				round(b.CTDCmontoTotal - b.CTDCmontoConsumido,2) as saldo,
				coalesce(b.CTDCmontoTotal, 0.00) as MontoLiberacion,
			    cc.Cid, cc.Cdescripcion,
				ff.CFid, ff.CFcodigo,
				case
								when b.CMtipo = 'S' then 'Servicio'
								when b.CMtipo = 'F' then 'Activo Fijo'
								when b.CMtipo = 'C' then 'Clasificacion Inventario'
								else 'Otro'
							end as Item,
                            b.CPDEid
		  from CTContrato a
			left join  CTDetContrato b
				 on b.Ecodigo = a.Ecodigo
				and b.CTContid  = a.CTContid
			left join CPresupuesto c
				 on c.Ecodigo = b.Ecodigo
				 and c.CPcuenta = b.CPcuenta
			left join Conceptos cc on cc.Cid = b.Cid
			left join CFuncional ff on ff.CFid = b.CFid
			left join CPDistribucionCostos dist
				on b.CPDCid = dist.CPDCid
		 where a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTContid#">
		   and a.Ecodigo = #Session.Ecodigo#
		 order by a.CTCnumContrato
	</cfquery>

</cfif>

<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script type="text/javascript" language="JavaScript" >
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<cfoutput>
<form method="post" name="form1" action="liberacionContratos-sql.cfm" style="margin: 0;">
  <cfif modo EQ "CAMBIO">
	<input type="hidden" name="CTContid" value="#Form.CTContid#">
	<input type="hidden" name="CTDCont" value="#rsDetDocsProvision.CTDCont#">
  </cfif>
  <cfif modo EQ "ALTA">

  <cfelse>
	  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
		<tr>
		  <td colspan="6" align="center" nowrap class="tituloAlterno"><cfoutput>#LB_ENDLC#</cfoutput></td>
		</tr>

		<tr>
		  <td align="right" class="fileLabel" nowrap>#LB_PDO#</td>
		  <td>
				<input type="hidden" name="CPPid" value="#rsLiberacion.CPPid#">
				#rsLiberacion.PeriodoPres#
		  </td>
		  <td align="right" nowrap class="fileLabel">&nbsp;</td>
		  <td>&nbsp;

		  </td>
		</tr>

		<tr>
			<td align="right" class="fileLabel" nowrap>#LB_CTO#</td>
		  <td>
				<input type="hidden" name="CPPid" value="#rsLiberacion.CPPid#">
				#rsLiberacion.CTCnumContrato#
		  </td>
		  <td align="right" nowrap class="fileLabel">&nbsp;</td>
		  <td>&nbsp;

		  </td>
		  <td align="right" nowrap class="fileLabel">#LB_FDO#</td>
		  <td>
			<cfif modo EQ "CAMBIO">
			  <cfset fecha = LSDateFormat(rsLiberacion.CTfecha, 'dd/mm/yyyy')>
			  <cfelse>
			  <cfset fecha = LSDateFormat(Now(), 'dd/mm/yyyy')>
			</cfif>
			  <cf_sifcalendario name="CTfecha" form="form1" value="#fecha#">
		  </td>
		</tr>

		  	<cfset puedeAplicar = false>

		<cfquery name="rsDetDocsProvision2" datasource="#Session.DSN#">
				select cl.Monto,cl.TipoLiberacion
				from CTContrato  a
					left join CTDetContrato b
					on a.CTContid = b.CTContid
					left join CTDetLiberacion cl
					on b.CTDCont = cl.CTDCont
					inner join CPresupuestoPeriodo cp
					on cp.CPPid = a.CPPid
				where a.Ecodigo = #Session.Ecodigo#
				and cl.Estatus = 0
				and a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTContid#">
				order by a.CTfecha desc, a.CTCnumContrato
		</cfquery>
<!--- <cf_dump var="#rsDetDocsProvision2#"> --->
		<tr>
		  <td align="right" class="fileLabel" nowrap>#LB_DCPN#</td>
		  <td><input type="hidden" name="CTCdescripcion" value="#rsLiberacion.CTCdescripcion#">
		  	  #rsLiberacion.CTCdescripcion#
		  </td>
		  <td align="right" nowrap class="fileLabel">#LB_LBA#</td>
		  <td>
				<input type="radio" name="tipoLibera" value="S" onclick="javascript: DeshabilitaMonto('S');" <cfif rsDetDocsProvision2.TipoLiberacion eq 'S'>checked</cfif>>#LB_SFC#
		  </td>
		  <td align="left" nowrap class="fileLabel">
			    <input type="radio" name="tipoLibera" value="D" onclick="javascript: DeshabilitaMonto('D');" <cfif rsDetDocsProvision2.TipoLiberacion eq 'D'>checked</cfif>>#LB_PresD#
		  </td>
		  <td nowrap>&nbsp;</td>
		</tr>

		<tr>
		  <td colspan="6" align="center" nowrap>

			<cfloop query="rsDetDocsProvision2">
				<cfif rsDetDocsProvision2.Monto GT 0>
				  	<cfset puedeAplicar = true>
				  	<cfbreak>
				</cfif>
			</cfloop>

				<cfif puedeAplicar>
					<input type="submit" name="btnAplicar" value="Aplicar" onclick="javascript: if ( confirm('Se va a proceder a guardar todos los cambios. ¿Est&aacute; seguro(a) de que desea aplicar este documento de Liberaci&oacute;n de Provisi&oacute;n Presupuestaria?') ){ return validChk();}else{ return false;}">
				</cfif>

			<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: location.href='LiberacionContratos.cfm';">
		  </td>
		</tr>
		<tr>
		  <td colspan="6">&nbsp;</td>
		</tr>
		<!--- Lista de Lineas de Detalle para el Documento de LiberaciÃ³n --->
		<cfif modo EQ "CAMBIO">
		<tr>
		  <td colspan="6">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td align="right" nowrap class="tituloListas" style="padding-right: 5px;">#LB_ANIO#</td>
					<td nowrap class="tituloListas" style="padding-right: 5px;">#LB_Ms#</td>
					<td nowrap class="tituloListas" style="padding-right: 5px;">#LB_ITM#</td>
					<td nowrap class="tituloListas" style="padding-right: 5px;">#LB_CPTO#</td>
					<td nowrap class="tituloListas" style="padding-right: 5px;">#LB_CF#</td>
					<td nowrap class="tituloListas" style="padding-right: 5px;">#LB_CTA#</td>
					<td nowrap class="tituloListas" style="padding-right: 5px;">#LB_DCTA#</td>
					<td align="right" nowrap class="tituloListas" style="padding-right: 5px;">#LB_MTI#</td>
					<td align="right" nowrap class="tituloListas" style="padding-right: 5px;">#LB_SDO#</td>

				    <td align="right" nowrap class="tituloListas" style="padding-right: 5px;">#LB_MTL#</td>
				  </tr>
 				  <cfloop query="rsDetDocsProvision">
					  <tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
						<td align="right"  style="padding-right: 5px;"nowrap>#rsDetDocsProvision.CPCano#</td>
						<td style="padding-right: 5px;">#rsDetDocsProvision.MesDescripcion#</td>
						<td style="padding-right: 5px;">#rsDetDocsProvision.Item#</td>
					<cfif  rsDetDocsProvision.Cdescripcion neq ''>
						<td style="padding-right: 5px;" nowrap>#rsDetDocsProvision.Cdescripcion#</td>
			 		<cfelse>
						<td style="padding-right: 5px;" nowrap>#rsDetDocsProvision.CPDCdescripcion#</td>
					</cfif>
						<td style="padding-right: 5px;" nowrap>#rsDetDocsProvision.CFcodigo#</td>
						<td style="padding-right: 5px;" nowrap>#rsDetDocsProvision.Cuenta#</td>
						<td style="padding-right: 5px;" nowrap>#rsDetDocsProvision.DescCuenta#</td>
						<td align="right" nowrap style="padding-right: 5px;">#LSNumberFormat(rsDetDocsProvision.CTDCmontoTotal, ',9.00')#</td>
						<td align="right" nowrap style="padding-right: 5px;">

							<input type="hidden" name="Saldo_#rsDetDocsProvision.CTDCont#" value="#rsDetDocsProvision.saldo#" >

							#LSNumberFormat(rsDetDocsProvision.saldo, ',9.00')#

						</td>

						<cfquery name="rsMliberado" datasource="#session.dsn#">
							select a.CTDContL,a.CTDCont,a.Monto,a.Estatus
							from CTDetLiberacion a
								left join CTDetContrato b
								on a.CTDCont = b.CTDCont
							where a.Estatus = 0
							and a.CTDCont = #rsDetDocsProvision.CTDCont#
						</cfquery>

						<td align="right" nowrap style="padding-right: 5px;">
							<input type="text" <cfif rsDetDocsProvision.CPDEid EQ -1 and rsDetDocsProvision2.TipoLiberacion eq 'S'>disabled="disabled"</cfif>  name="montLib_#rsDetDocsProvision.CTDCont#" id="montLib_#rsDetDocsProvision.CTDCont#" size="20" maxlength="18" onBlur="fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" <cfif puedeAplicar and rsMliberado.CTDCont eq rsDetDocsProvision.CTDCont>value="#LSNumberFormat(rsMliberado.Monto, ',9.00')#"<cfelse>value="#LSNumberFormat(0,',9.00')#"</cfif>>
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
			<input type="submit" name="btnGuardarD" value="Guardar" onClick="return validar();">
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

<script type="text/javascript" language="javascript">

	function validChk(){

		if(document.form1.tipoLibera[1].checked== false && document.form1.tipoLibera[0].checked == false){
			alert('Es necesario indicar el Tipo de Liberacion!');
			return false;
		}else{
		return true;
				}

	}

	function validar() {

		var z=0;
<cfoutput>
		<cfloop query="rsDetDocsProvision">

		var x = document.form1.montLib_#rsDetDocsProvision.CTDCont#.value;
			x = parseFloat(x.replace(/,/g ,""));
		var y = (document.form1.Saldo_#rsDetDocsProvision.CTDCont#.value);
			y = parseFloat(y.replace(/,/g,""));

			if(x>y){
			   z=1;
			}
		</cfloop>
</cfoutput>

	if(z == 1){
		alert('El monto a liberar no puede ser mayor al Saldo!');
		return false;
	 }else{
	 return true;
	 }

	}

	function DeshabilitaMonto(TipoLibera) {
		if(TipoLibera == 'S'){
	<cfoutput>
			<cfloop query="rsDetDocsProvision">
				<cfif rsDetDocsProvision.CPDEid EQ -1>
					document.form1.montLib_#rsDetDocsProvision.CTDCont#.value=0;
					document.form1.montLib_#rsDetDocsProvision.CTDCont#.disabled=true;
				</cfif>
			</cfloop>
	</cfoutput>
			}
		else if(TipoLibera == 'D'){
	<cfoutput>
			<cfloop query="rsDetDocsProvision">
				document.form1.montLib_#rsDetDocsProvision.CTDCont#.disabled=false;
			</cfloop>
	</cfoutput>
			}
		else alert('Error: No se especifico un Tipo de Liberacion Valido ' + TipoLibera);
	}

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

</script>

<cfquery name="rsRHLiqIngresos" datasource="#session.DSN#">
	select	a.DLlinea, a.DEid, a.RHLPfecha, a.fechaalta,
	b.RHLPid, b.RHLPdescripcion as nombre, b.fechaalta,
	c.CIcodigo, c.CIdescripcion,
	case when d.DDCcant is null or d.DDCcant = 0 then b.importe else d.DDCimporte end as importe,
	coalesce(d.DDCres,0) as Resultado, 
	coalesce(d.DDCcant,0) as Cantidad,
	coalesce(b.RHLIexento,0) as exento,
	coalesce(b.RHLIgrabado,0) as grabado
	
	from RHLiquidacionPersonal a

	  inner join RHLiqIngresos b
		on  a.Ecodigo = b.Ecodigo
		and a.DEid = b.DEid
		and a.DLlinea = b.DLlinea

	  inner join CIncidentes c
		on  b.CIid = c.CIid
		and b.Ecodigo = c.Ecodigo
	
	  left outer join DDConceptosEmpleado d
		on d.CIid = c.CIid
		and d.DLlinea = a.DLlinea
		
	where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
	  and b.RHLPautomatico = 1

	order by 2
</cfquery>
<cfquery name="rsDetalleRHLiquidacionPersonal" datasource="#session.DSN#">
	select    rhta.RHTdesc,	 dle.DLfvigencia as DLfechaaplic, eve.EVfantig, dle.DEid
	 from DLaboralesEmpleado  dle
	  inner join RHTipoAccion rhta
		on  dle.Ecodigo = rhta.Ecodigo
		and dle.RHTid = rhta.RHTid
	  inner join EVacacionesEmpleado eve
	    on  dle.DEid = eve.DEid 
	where dle.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and dle.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
</cfquery>
<cfquery name="rsSumRHLiqIngresosAutom" datasource="#session.DSN#">
	select sum(importe) as totIngresos 
	from RHLiqIngresos
	where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#"> 
	  and RHLPautomatico = 1
  </cfquery> 

<cfquery name="rsValidacionCausa" datasource="#session.DSN#">  <!---SML.Validacion para la Causa del Finiquito--->
 	select RHLPCausa 
	from RHLiquidacionPersonal 
	where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#"> 
</cfquery>

  
<script language="javascript" type="text/javascript">
	<!--//
		function funcSiguiente(){
			if (document.form1.paso){
				var vpaso = parseInt(document.form1.paso.value) + 1;
				document.form1.paso.value = vpaso;
				if (window.deshabilitarValidacion) deshabilitarValidacion();
			}
		}
		function funcAnterior(){
			if (document.form1.paso)
				var vpaso = parseInt(document.form1.paso.value) - 1;
				document.form1.paso.value = vpaso;
				if (window.deshabilitarValidacion) deshabilitarValidacion();
		}
	//-->
</script>


<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr>
	<td width="1%" align="right">
		<img src="/cfmx/rh/imagenes/number#Gpaso#_64.gif" border="0">
	</td>
	<td style="padding-left: 10px;" valign="top">
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td style="border-bottom: 1px solid black " nowrap><strong style="font-family:'Times New Roman', Times, serif; font-size:14pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#Gdescpasos[Gpaso+1]#</strong></td>
		  </tr>
		  <cfif isdefined("rsRHLiquidacionPersonal")>
		  <tr>
			<td class="ayuda" align="left" nowrap><strong><cf_translate key="LB_Liquidando">Liquidando</cf_translate>:</strong> <font color="##003399"><strong>#rsRHLiquidacionPersonal.DEidentificacion# &nbsp;- &nbsp;#rsRHLiquidacionPersonal.nombre#</strong></font></td>
		  </tr>
		  </cfif>
		</table>
	</td>
  </tr>
  <cfif Gpaso GT 0>
  <tr>
    <td colspan="2">
		<cfinclude template="/rh/portlets/pEmpleado.cfm">
	</td>
  </tr>
  <tr>
    <td colspan="2" align="center">
		<table align="center" width="100%"  style="border :1px solid gray" cellpadding="0" cellspacing="5">
			<tr>
				<td>
					<cfloop query="rsDetalleRHLiquidacionPersonal">
					<table align="center" width="100%" border="0">
						<tr>
						  	<td align="right" ><strong><cf_translate key="LB_Tipo_de_Accion" xmlfile="/rh/generales.xml">Tipo de Acci&oacute;n</cf_translate>:</strong></td>
							<td colspan="3" >&nbsp;#rsDetalleRHLiquidacionPersonal.RHTdesc#</td>
						</tr>
						<tr>
						  	<td width="35%" align="right"><strong><cf_translate key="LB_Fecha_de_Accion" >Fecha de Acción</cf_translate>:</strong></td>
							<td width="15%">&nbsp;#LSDateFormat(rsDetalleRHLiquidacionPersonal.DLfechaaplic,'dd/mm/yyyy')#</td>
							<td width="15%" align="right" nowrap="nowrap"><strong><cf_translate key="LB_Fecha_de_Ingreso" xmlfile="/rh/generales.xml" >Fecha de Ingreso</cf_translate>:</strong></td>	
							<td width="35%">&nbsp;#LSDateFormat(rsDetalleRHLiquidacionPersonal.EVfantig,'dd/mm/yyyy')#</td>
						</tr>
						<tr>
							<td colspan="4" align="center">
								<table align="center" width="75%" border="0">
									<tr>
										<cfset ylaborados = DateDiff('yyyy',rsDetalleRHLiquidacionPersonal.EVfantig,rsDetalleRHLiquidacionPersonal.DLfechaaplic)>
										<cfset mlaborados = DateDiff('m',DateAdd('yyyy',ylaborados,rsDetalleRHLiquidacionPersonal.EVfantig),rsDetalleRHLiquidacionPersonal.DLfechaaplic)>
										<cfset dlaborados = DateDiff('d',DateAdd('m',mlaborados,DateAdd('yyyy',ylaborados,rsDetalleRHLiquidacionPersonal.EVfantig)),rsDetalleRHLiquidacionPersonal.DLfechaaplic)>
										<td width="20%" align="right" nowrap="nowrap"><strong><cf_translate key="LB_Anos" xmlfile="/rh/generales.xml">Años</cf_translate>:</strong></td>
										<td width="10%">#ylaborados#</td>
									    <td width="20%" align="right" nowrap="nowrap"><strong><cf_translate key="LB_Meses" xmlfile="/rh/generales.xml">Meses</cf_translate>:</strong></td>
									    <td width="10%">#mlaborados#</td>
									    <td width="15%" align="right" nowrap="nowrap"><strong><cf_translate key="LB_Dias" xmlfile="/rh/generales.xml">D&iacute;as</cf_translate>:</strong></td>
									    <td width="25%">#dlaborados#</td>
									</tr>
								</table>
						   	</td>
						</tr>
					</table>
					</cfloop>
				</td>
			</tr>
			<tr>
				<td>
					<table align="center" width="75%" border="0" cellpadding="0" cellspacing="2">
						<!--- ENCABEZADO --->
						<tr class="TituloListas">
							<td><cf_translate key="LB_Concepto">Concepto</cf_translate></td>
							<td align="right"><cf_translate key="LB_Cantidad">Cantidad</cf_translate></td>
							<td align="right"><cf_translate key="LB_Monto">Monto</cf_translate></td>
							<td align="right"><cf_translate key="LB_Total">Total</cf_translate></td>
							<td align="right"><cf_translate key="LB_Excento">Exento</cf_translate></td>
							<td align="right"><cf_translate key="LB_Grabado">Grabado</cf_translate></td>
							<td align="center"><cf_translate key="LB_Es_Finiquito">Es Finiquito</cf_translate></td>
						</tr>
						<cfset lvarIsMod = false>
						<cfloop query="rsRHLiqIngresos">
							<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnIndicaModEG" returnvariable="isMod">
								<cfinvokeargument name="RHLPid" value="#rsRHLiqIngresos.RHLPid#">
							</cfinvoke>
						
							<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnEsFiniquito" returnvariable="esFiniquito">
								<cfinvokeargument name="RHLPid" value="#rsRHLiqIngresos.RHLPid#">
							</cfinvoke>
							<tr <cfif isMod>style="color:##FF0000"<cfset lvarIsMod = true></cfif>>
								<td>#rsRHLiqIngresos.nombre#</td>
								<td align="right"><cfif cantidad EQ 0><div align="center">-</div><cfelse>#LsCurrencyFormat(rsRHLiqIngresos.cantidad,'none')#</cfif></td>
								<td align="right"><cfif cantidad EQ 0><div align="center">-</div><cfelse>#LsCurrencyFormat(rsRHLiqIngresos.importe,'none')#</cfif></td>
								<td align="right"><cfif cantidad EQ 0>#LsCurrencyFormat(rsRHLiqIngresos.importe,'none')#<cfelse>#LsCurrencyFormat(rsRHLiqIngresos.resultado,'none')#</cfif></td>
								<td align="right">#LsCurrencyFormat(rsRHLiqIngresos.exento,'none')#</td>
								<td align="right">#LsCurrencyFormat(rsRHLiqIngresos.grabado,'none')#</td>
								<td align="right" onclick="fnFiniquito(#rsRHLiqIngresos.RHLPid#)"><cfif esFiniquito><img border="0" src="/cfmx/rh/imagenes/checked.gif"/><cfelse><img border="0" src="/cfmx/rh/imagenes/unchecked.gif"/></cfif></td>
							</tr>
						</cfloop>
						<cfset v_hayrenta = false >
						<cfif isdefined("rsRHLiquidacionPersonal") and len(trim(rsRHLiquidacionPersonal.renta)) and rsRHLiquidacionPersonal.renta gt 0 >
							<tr>
								<td><cf_translate key="LB_Renta">Renta</cf_translate></td>
								<td align="right">0.00</td>
								<td align="right">#LsCurrencyFormat(rsRHLiquidacionPersonal.renta,'none')#</td>
								<td align="right">#LsCurrencyFormat(rsRHLiquidacionPersonal.renta,'none')#</td>
								<td mcolspan="3">&nbsp;</td>
							</tr>
							<cfset v_hayrenta = true >
						</cfif>
						
						<cfif rsRHLiqIngresos.RecordCount EQ 0 and not v_hayrenta >
							<tr><td colspan="6" align="center"><cf_translate key="LB_NoHayConceptosRelacionados">No hay conceptos relacionados.</cf_translate></td></tr>
						</cfif>
					</table>
				</td>
			</tr>
			<tr><td><table width="100%" border="0"><tr>
				<td colspan = "3"><cfif lvarIsMod><label style="color:##FF0000">* Se han modificado datos, para actualizar datos presionar el bot&oacute;n "Actualizar".</label><cfelse>&nbsp;</cfif></td></tr>
              <tr>
                
                 <!---SML. Inicio Modificacion para que se agregue el motivo por el que fue la baja--->
        		<td width="28%" align="right" nowrap class="fileLabel" <cfif isdefined('rsValidacionCausa') and rsValidacionCausa.RHLPCausa EQ 0 or rsValidacionCausa.RHLPCausa EQ ''> style="color:##FF0000" </cfif>><strong><cf_translate key="LB_Causa_Baja">Causa de Baja</cf_translate></strong>:</td>
                <form style="margin:0;" action="#CurrentPage#" method="post" onsubmit="return fnValidarAccion();">
        		<td nowrap>
                	<!---<cf_dump var = "#rsValidacionCausa.RHLPCausa#">--->
					<select name="CausaBaja" id="CausaBaja" <cfif isdefined('rsValidacionCausa') and rsValidacionCausa.RHLPCausa EQ 0 or rsValidacionCausa.RHLPCausa EQ ''> style="color:##FF0000" </cfif>>
						<option value="0" <cfif isdefined('rsValidacionCausa') and rsValidacionCausa.RHLPCausa EQ 0>selected</cfif>> -- Seleccione Causa de Baja -- </option>
					  	<option value="1" <cfif isdefined('rsValidacionCausa') and rsValidacionCausa.RHLPCausa EQ 1>selected</cfif>>Termino de contrato</option>
					  	<option value="2" <cfif isdefined('rsValidacionCausa') and rsValidacionCausa.RHLPCausa EQ 2>selected</cfif>>Separaci&oacute;n voluntaria</option>
					  	<option value="3" <cfif isdefined('rsValidacionCausa') and rsValidacionCausa.RHLPCausa EQ 3>selected</cfif>>Abandono de empleo</option>
                      	<option value="4" <cfif isdefined('rsValidacionCausa') and rsValidacionCausa.RHLPCausa EQ 4>selected</cfif>>Defunci&oacute;n</option>
                      	<option value="5" <cfif isdefined('rsValidacionCausa') and rsValidacionCausa.RHLPCausa EQ 5>selected</cfif>>Clausura</option>
                      	<option value="6" <cfif isdefined('rsValidacionCausa') and rsValidacionCausa.RHLPCausa EQ 6>selected</cfif>>Otra</option>
					</select>
				</td>
				<!---SML. Fin Modificacion para que se agregue el motivo por el que fue la baja--->
				<td align="right">
						<input type="submit" class="btnFiltrar" name="btnActulizar" value="Actualizar" />
						<input type="hidden" name="DLlinea" value="#DLlinea#" />
						<input type="hidden" name="paso" value="#paso#">
				</td></form>
			</tr></table></td></tr>
		</table>
	</td>
  </tr>
	<tr>
		<td align="center" colspan="2">
			<table style="background-color:##f5f5f5;" class="areaFiltro" align="center" width="100%" cellspacing="0" cellpadding="3">
				<tr><td bgcolor="##E8E8E8"><strong><cf_translate key="MSG_Recalculo_de_Liquidacion_de_Personal">Recalculo de Liquidaci&oacute;n de Personal</cf_translate></strong></td></tr>
				<tr><td><cf_translate key="MSG_MensajeRecalculo">El bot&oacute;n de Recalcular, le permite volver a realizar los c&aacute;lculos para un Concepto espec&iacute;fico, el cual debe ser definido  en Par&aacute;metros del Sistema. Este Concepto debe ser de tipo C&aacute;lculo  y debe estar incluido en esta liquidaci&oacute;n.</cf_translate></td></tr>

				<cfinvoke component="sif.Componentes.Translate"
						  method="Translate"
						  Key="BTN_Recalcular"
						  Default="Recalcular"
						  XmlFile="/rh/generales.xml"
						  returnvariable="vRecalcular"/>
				<cfif isdefined("url.DLlinea") and len(trim(url.DLlinea)) and not isdefined("form.DLlinea")>
					<cfset form.DLlinea = url.DLlinea >
				</cfif>
				<cfif not isdefined("form.DLlinea")>
					<cfset form.DLlinea = 0 >
				</cfif>
				<cfquery name="rs_empleado" datasource="#session.DSN#">
					select DEid
					from RHLiquidacionPersonal
					where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
				</cfquery>
				
				<tr>
					<td align="center">
						<form style="margin:0;" action="#CurrentPage#" method="post">
							<input type="submit" class="btnFiltrar" name="btnRecalcular" value="#vRecalcular#" alt="Actualizar" title="Actualiza el exento y grabado de cada concepto."/>
							<input type="hidden" name="DLlinea" value="#form.DLlinea#" />
							<input type="hidden" name="DEid" value="#rs_empleado.DEid#" />
							<input type="hidden" name="paso" value="1">
						</form>
						<form name="formFiniquito"style="margin:0;" action="#CurrentPage#" method="post">
							<input type="hidden" name="btnFiniquito" value="Finiquito" />
							<input type="hidden" name="DLlinea" value="#DLlinea#" />
							<input type="hidden" name="RHLPid" 	value="" />
							<input type="hidden" name="paso" value="#paso#">
						</form>
					</td>
				</tr>
			</table>
		</td>
	</tr> 
	<script language="javascript1.2" type="text/javascript">
		
		function fnValidarAccion(){
			if(confirm("Esta seguro de realizar esta acción?"))
				return true;
			return false;
		}
		
		function fnFiniquito(RHLPid){
			document.formFiniquito.RHLPid.value = RHLPid;
			document.formFiniquito.submit();
		}
		
	</script>
  </cfif>
</table>
</cfoutput>
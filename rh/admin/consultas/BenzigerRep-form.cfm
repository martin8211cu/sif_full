<cfif isdefined("Url.RHPcodigo") and Len(Trim(Url.RHPcodigo)) and not (isdefined("Form.RHPcodigo") and Len(Trim(Form.RHPcodigo)))>
	<cfparam name="Form.RHPcodigo" default="#Url.RHPcodigo#">
</cfif>

<cfif isdefined("Url.RHPcodigoext") and Len(Trim(Url.RHPcodigoext)) and not (isdefined("Form.RHPcodigoext") and Len(Trim(Form.RHPcodigoext)))>
	<cfparam name="Form.RHPcodigoext" default="#Url.RHPcodigoext#">
</cfif>

<cfquery name="rsBenziger" datasource="#Session.DSN#">
	select 
		lt.DEid, 
		b.RHPcodigo,
		coalesce(ltrim(rtrim(b.RHPcodigoext)),ltrim(rtrim(b.RHPcodigo))) as RHPcodigoext,
		de.DEnombre, 
		de.DEapellido1, 
		de.DEapellido2, 
		de.DEidentificacion, 
		b.FLval as FLRequerido, 
		b.FRval as FRRequerido, 
		b.BLval as BLRequerido, 
		b.BRval as BRRequerido, 
		b.introvertido as introp, 
		b.extravertido as extrop, 
		b.balanceado as balanceadop,
		b.FLtol as FLTolerancia,
		b.FRtol as FRTolerancia, 
		b.BLtol as BLTolerancia,
		b.BRtol as BRTolerancia,
		pu.FLval as FLObtenido, 
		pu.FRval as FRObtenido, 
		pu.BLval as BLObtenido, 
		pu.BRval as BRObtenido, 
		pu.introvertido as introe, 
		pu.extravertido as extroe, 
		pu.balanceado as balanceadoe,

		(b.FRtol*b.FRval/100.0) + pu.FRval as FRTolCal,
		(b.FLtol*b.FLval/100.0) + pu.FLval as FLTolCal,
		(b.BRtol*b.BRval/100.0) + pu.BRval as BRTolCal,
		(b.BLtol*b.BLval/100.0) + pu.BLval as BLTolCal,
		{fn concat(de.DEapellido1,{fn concat(' ',{fn concat(de.DEapellido2,{fn concat(', ', de.DEnombre)})})})} as NombreEmp,
		b.RHPdescpuesto as DescPuesto
	
	from RHPuestos b, LineaTiempo lt, PerfilUsuarioB pu, DatosEmpleado de
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isdefined("Form.RHPcodigo") and Len(Trim(Form.RHPcodigo))>
	  and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
	</cfif>
	  and b.FRval is not null
	  and b.Ecodigo = lt.Ecodigo
	  and lt.RHPcodigo = b.RHPcodigo
	  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between lt.LTdesde and lt.LThasta
	  and lt.Ecodigo = pu.Ecodigo
	  and lt.DEid = pu.DEid
	  and lt.RHPcodigo = pu.RHPcodigo
	  and lt.DEid = de.DEid
	  and lt.Ecodigo = de.Ecodigo
	  and (
	  		(b.FRtol*b.FRval/100.0)+ pu.FRval < b.FRval
	  	 or (b.FLtol*b.FLval/100.0)+ pu.FLval < b.FLval
	  	 or (b.BRtol*b.BRval/100.0)+ pu.BRval < b.BRval
	  	 or (b.BLtol*b.BLval/100.0)+ pu.BLval < b.BLval 
	  )
	  order by b.RHPcodigo, NombreEmp
</cfquery>

<cfset HoraReporte = Now()>
<cfset lineas = 30>
<cfset contador = 1>

<script language="javascript" type="text/javascript">
	function doConlisBezinger(emp) {
		var width = 900;
		var height = 600;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var params = "";
		params = "?DEid="+emp;
		var nuevo = window.open('/cfmx/rh/admin/consultas/conlisBezinger.cfm'+params,'ListaBeneficioEmpleado','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();
	}
</script>

<style type="text/css">
.seleccionado {
	cursor: pointer;
}
</style>

<cfsavecontent variable="encabezado">
	<cfoutput>
		<!----- Pintado Encabezado ----->
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="14" align="center" class="tituloAlterno"><strong><font size="3">#Session.Enombre#</font></strong></td>
			</tr>
			<tr>
				<td nowrap colspan="14">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="14" align="center">
					<strong>
						<font size="3">
							<cf_translate key="LB_ConsultaDeDesviacionBenziger">Consulta de Desviaci&oacute;n Benziger</cf_translate>
						</font>
					</strong>
				</td>
			</tr>
			<cfif isdefined("Form.RHPcodigoext") and Len(Trim(Form.RHPcodigoext))>
				<tr>
					<td colspan="14" align="center">
						<font size="2">	
							<strong>
								<cf_translate key="LB_Puesto">Puesto</cf_translate>:&nbsp;
							</strong>#Form.RHPcodigoext#
						</font>
					</td>
				</tr>
			</cfif>
			<tr>
				<td colspan="14" align="center">
					<font size="2">
						<strong>
							<cf_translate key="LB_FechaDeLaConsulta">Fecha de la Consulta</cf_translate>:&nbsp;
						</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;
						<strong>
							<cf_translate key="LB_Hora">Hora</cf_translate>:&nbsp;
						</strong>#TimeFormat(HoraReporte,'medium')#
					</font>
				</td>
			</tr>
			<tr><td colspan="14" nowrap>&nbsp;</td></tr>
		</table>
	</cfoutput>
</cfsavecontent>

<cfif rsBenziger.recordCount GT 0>
	<cf_sifHTML2Word>
	<cfoutput>
		#encabezado#
		<table width="98%" align="center" border="0" cellspacing="0" cellpadding="2">
		  	<cfset codpuesto = "">
		  	<cfloop query="rsBenziger">
			<cfif isdefined('Url.imprimir') and contador mod lineas EQ 0 and contador NEQ 1>
				<cfset codpuesto = "">
				<tr><td colspan="14">&nbsp;</td></tr>
				<tr>
					<td colspan="14" align="right">
						<strong>
							<cf_translate key="LB_Pagina">P&aacute;gina</cf_translate>: #contador / lineas#
						</strong>
					</td>
				</tr>
				<tr class="pageEnd"><td colspan="14">&nbsp;</td></tr>
				<tr><td colspan="14">#encabezado#</td></tr>
			</cfif>
			<cfif rsBenziger.RHPcodigo NEQ codpuesto>
				<cfset codpuesto = rsBenziger.RHPcodigo>
				  <tr>
					<td class="listaCorte" colspan="14">#rsBenziger.DescPuesto#</td>
				  </tr>
				  <tr class="tituloListas">
					<td rowspan="2" style="border-top: 1px solid gray; border-left: 1px solid gray; border-bottom: 1px solid gray; border-right: 1px solid gray;"><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate></td>
					<td rowspan="2" style="border-top: 1px solid gray; border-bottom: 1px solid gray;"><cf_translate key="LB_NombreCompleto">Nombre Completo</cf_translate> </td>
					<td colspan="3" align="center" style="border-top: 1px solid gray; border-left: 1px solid gray; border-bottom: 1px solid gray; border-right: 1px solid gray;"><cf_translate key="LB_FR">FR</cf_translate></td>
					<td colspan="3" align="center" style="border-top: 1px solid gray; border-bottom: 1px solid gray; border-right: 1px solid gray;"><cf_translate key="LB_FL">FL</cf_translate></td>
					<td colspan="3" align="center" style="border-top: 1px solid gray; border-bottom: 1px solid gray; border-right: 1px solid gray;"><cf_translate key="LB_BR">BR</cf_translate></td>
					<td colspan="3" align="center" style="border-top: 1px solid gray; border-bottom: 1px solid gray; border-right: 1px solid gray;"><cf_translate key="LB_BL">BL</cf_translate></td>
				  </tr>
				  <tr class="tituloListas" align="center"  >
					<td style="border-left: 1px solid gray; border-right: 1px solid gray; border-bottom: 1px solid gray;"><cf_translate key="LB_Req">Req.</cf_translate></td>
					<td style="border-right: 1px solid gray; border-bottom: 1px solid gray;"><cf_translate key="LB_Tol">% Tol.</cf_translate></td>
					<td style="border-right: 1px solid gray; border-bottom: 1px solid gray;"><cf_translate key="LB_ObtTol">Obt.+Tol.</cf_translate></td>
					<td style="border-right: 1px solid gray; border-bottom: 1px solid gray;"><cf_translate key="LB_Req">Req.</cf_translate></td>
					<td style="border-right: 1px solid gray; border-bottom: 1px solid gray;"><cf_translate key="LB_Tol">% Tol.</cf_translate></td>
					<td style="border-right: 1px solid gray; border-bottom: 1px solid gray;"><cf_translate key="LB_ObtTol">Obt.+Tol.</cf_translate></td>
					<td style="border-right: 1px solid gray; border-bottom: 1px solid gray;"><cf_translate key="LB_Req">Req.</cf_translate></td>
					<td style="border-right: 1px solid gray; border-bottom: 1px solid gray;"><cf_translate key="LB_Tol">% Tol.</cf_translate></td>
					<td style="border-right: 1px solid gray; border-bottom: 1px solid gray;"><cf_translate key="LB_ObtTol">Obt.+Tol.</cf_translate></td>
					<td style="border-right: 1px solid gray; border-bottom: 1px solid gray;"><cf_translate key="LB_Req">Req.</cf_translate></td>
					<td style="border-right: 1px solid gray; border-bottom: 1px solid gray;"><cf_translate key="LB_Tol">% Tol.</cf_translate></td>
					<td style="border-right: 1px solid gray; border-bottom: 1px solid gray;"><cf_translate key="LB_ObtTol">Obt.+Tol.</cf_translate></td>
				  </tr>
				  <cfset contador = contador + 3>
			  </cfif>
			  <tr onClick="javascript: doConlisBezinger('#rsBenziger.DEid#');" onMouseOver="javascript: this.className='seleccionado';" >
				<td style="border-bottom: 1px solid gray;">#rsBenziger.DEidentificacion#</td>
				<td style="border-bottom: 1px solid gray;">#rsBenziger.NombreEmp#</td>
				<td align="center" style="border-bottom: 1px solid gray;">#rsBenziger.FRRequerido#</td>
				<td align="center" style="border-bottom: 1px solid gray;">#rsBenziger.FRTolerancia#</td>
				<td align="right" style="border-bottom: 1px solid gray;">
					<cfif Int(rsBenziger.FRTolCal) LT rsBenziger.FRRequerido>
						<font color="##FF0000">
					</cfif>
						#Int(rsBenziger.FRTolCal)#
					<cfif Int(rsBenziger.FRTolCal) LT rsBenziger.FRRequerido>
						</font>
						<img src="/cfmx/rh/imagenes/abajo.gif" border="0">
					</cfif>
				</td>
				<td align="center" style="border-bottom: 1px solid gray;">#rsBenziger.FLRequerido#</td>
				<td align="center" style="border-bottom: 1px solid gray;">#rsBenziger.FLTolerancia#</td>
				<td align="right" style="border-bottom: 1px solid gray;">
					<cfif Int(rsBenziger.FLTolCal) LT rsBenziger.FLRequerido>
						<font color="##FF0000">
					</cfif>
						#Int(rsBenziger.FLTolCal)#
					<cfif Int(rsBenziger.FLTolCal) LT rsBenziger.FLRequerido>
						</font>
						<img src="/cfmx/rh/imagenes/abajo.gif" border="0">
					</cfif>
				</td>
				<td align="center" style="border-bottom: 1px solid gray;">#rsBenziger.BRRequerido#</td>
				<td align="center" style="border-bottom: 1px solid gray;">#rsBenziger.BRTolerancia#</td>
				<td align="center" style="border-bottom: 1px solid gray;">
					<cfif Int(rsBenziger.BRTolCal) LT rsBenziger.BRRequerido>
						<font color="##FF0000">
					</cfif>
						#Int(rsBenziger.BRTolCal)#
					<cfif Int(rsBenziger.BRTolCal) LT rsBenziger.BRRequerido>
						</font>
						<img src="/cfmx/rh/imagenes/abajo.gif" border="0">
					</cfif>
				</td>
				<td align="center" style="border-bottom: 1px solid gray;">#rsBenziger.BLRequerido#</td>
				<td align="center" style="border-bottom: 1px solid gray;">#rsBenziger.BLTolerancia#</td>
				<td align="right" style="border-bottom: 1px solid gray;">
					<cfif Int(rsBenziger.BLTolCal) LT rsBenziger.BLRequerido>
						<font color="##FF0000">
					</cfif>
						#Int(rsBenziger.BLTolCal)#
					<cfif Int(rsBenziger.BLTolCal) LT rsBenziger.BLRequerido>
						</font>
						<img src="/cfmx/rh/imagenes/abajo.gif" border="0">
					</cfif>
				</td>
			  </tr>
			  <cfset contador = contador + 1>
		  </cfloop>

		  <cfif isdefined('Url.imprimir')>
			  <tr><td colspan="14">&nbsp;</td></tr>
			  <tr><td colspan="14" align="right"><strong><cf_translate key="LB_Pagina">P&aacute;gina</cf_translate>: #Ceiling(contador / lineas)#</strong></td></tr>
			  <tr>
				<td colspan="14" align="center">------------------------ <cf_translate key="LB_UltimaPagina">Ultima P&aacute;gina</cf_translate> ------------------------</td>
			  </tr>
		  <cfelse>
			  <tr>
				<td colspan="14" align="center">------------------------ <cf_translate key="LB_FinDeLaConsulta">Fin de la Consulta</cf_translate> ------------------------</td>
			  </tr>
		  </cfif>
		</table>
	</cfoutput>
	</cf_sifHTML2Word>
</cfif>

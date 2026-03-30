
<cfsetting requesttimeout="8600">

<cfquery name="data" datasource="#session.DSN#">
	select a.RHVEgrupo, a.DVElinea, a.RHVEdescripcion, a.DEid, de.DEidentificacion, de.DEnombre, de.DEapellido1, de.DEapellido2, a.DVEdisfrutados as dias, a.DVEfinicio, a.DVEffin
	from RHVacacionesEmpleado a
	
	inner join DatosEmpleado de
	on de.DEid=a.DEid
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.RHVEestado = 'P'
		  <!---and not exists ( select 1 
						from RHVacacionesEmpleado
						where RHVEgrupo=a.RHVEgrupo
					  	  and RHVEestado='A' )
		  and a.RHVEestado != 'R'--->
		  
	order by a.RHVEgrupo, de.DEidentificacion		  
</cfquery>	 

<cfset contador = 0 >
<cfset color = 1 >

<cfoutput>
<table width="100%" align="center" cellpadding="4" cellspacing="0">
	<tr>
		<td align="center"><strong style="font-size:15px;">#LB_nav__SPdescripcion#</strong></td>
	</tr>

	<cfif isdefined("url.aplicar")>
	<tr>
		<td align="center"><strong style="font-size:12px;">#LB_exito#</strong></td>
	</tr>
	</cfif>

</table>
</cfoutput>

<cfif data.recordcount gt 0>
	<form name="form1" method="post" action="ajusteAplicar-sql.cfm" onsubmit="javascript:return validar();">
		<br />
		<table width="95%" align="center" cellpadding="3" cellspacing="0" >
			<tr >
				<td width="1%"><input type="checkbox" name="chk_all" id="chk_all" checked="checked" onclick="javascript:check_all(this.checked);" /></td>
				<td colspan="3"><label for="chk_all"><cfoutput>#LB_Todos#</cfoutput></label></td>
			</tr>	
			<cfoutput query="data" group="RHVEgrupo">
				<tr>
					<td colspan="4" bgcolor="##CCCCCC"><strong>#data.RHVEdescripcion#</strong></td>
					<!---
					<cfif data.currentrow eq 1 >
						<td rowspan="6" width="25%" valign="top">
							<table width="100%" class="areaFiltro" >
								<tr><td valign="top">kjkjj</td></tr>
							</table>
						</td>
					</cfif>
					--->
				</tr>
				<tr>
					<td colspan="4" bgcolor="##E1E1E1" style="padding-left:10px;">
						<strong style="font-size:11px;">
						<cfif data.DVEfinicio neq data.DVEffin>
							#LB_desde# #LSDateFormat(data.DVEfinicio, 'dd/mm/yyyy')# #LB_Hasta# #LSDateFormat(data.DVEffin, 'dd/mm/yyyy')#
						<cfelse>
						</cfif>
						</strong>
					</td>
				</tr>			
				<input type="hidden" name="RHVEgrupo" value="#data.RHVEgrupo#" />
				<cfoutput>
					<tr class="<cfif color mod 2>listaPar<cfelse>listaNon</cfif>">
						<td width="1%"><input type="checkbox" name="chk_#contador#" checked="checked" onclick="javascript:controlador(this.checked);" /></td>
						<td width="1%">#data.DEidentificacion#</td>
						<td>#data.DEapellido1# #data.DEapellido2# #data.DEnombre#</td>
						<td>
							<cf_inputnumber name="dias_#contador#" value="#data.dias#" decimales="2" enteros="4">
							<input type="hidden" name="DVElinea_#contador#" value="#data.DVElinea#" />
						</td>
					</tr>
					<cfset contador = contador + 1 >
					<cfset color = color+1 >
				</cfoutput>
				<cfset color = 1 >
			</cfoutput>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<cfoutput>
				<td colspan="4" align="center">
					<input type="submit" name="btnGuardar" class="btnGuardar" value="#BTN_GUARDAR#" />
					<input type="submit" name="btnAplicar" class="btnAplicar" value="#BTN_Aplicar#" onclick="javascript:return confirm('<cfoutput>#LB_ConfirmaAplicar#</cfoutput>?');" />
					<input type="submit" name="btnEliminar" class="btnEliminar" value="#BTN_Eliminar#" onclick="javascript:return confirm('<cfoutput>#LB_ConfirmaEliminar#</cfoutput>?');" />
				</td>
				</cfoutput>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
		<cfoutput>
		<input type="hidden" name="contador" value="#contador#" />
		</cfoutput>
	</form>
	
	<script language="javascript1.2">
		var checks_marcados = <cfoutput>#contador#</cfoutput>;
		function controlador(valor){
			if (valor){
				checks_marcados++
			}	
			else{
				checks_marcados--
			}
			
			if ( checks_marcados < 0 ) { checks_marcados = 0 }
			<cfif contador gt 0 >
				<cfoutput>
				if ( checks_marcados > #contador# ) { checks_marcados = #contador# }
				</cfoutput>
			</cfif>
			
			/* check de todos */
			if (!valor){
				document.form1.chk_all.checked = false;
			}
			if (valor && checks_marcados>=<cfoutput>#contador#</cfoutput> ){
				document.form1.chk_all.checked = true;
			}
			
		}
		
		function validar(){
			if ( checks_marcados <= 0  ){
				alert('<cfoutput>#LB_Seleccionar#</cfoutput>.')
				return false;
			}
			return true;
		}
		
		function check_all(value){
			//if (value){
				checks_marcados = <cfoutput>#contador#</cfoutput>;
				for (i=0;i<<cfoutput>#contador#</cfoutput>;i++){
					document.form1['chk_'+i].checked = value;
				}
			//}
		}
	</script>
<cfelse>
	<table align="center" width="95%" cellpadding="4" cellspacing="0" >
		<tr><td align="center"><cfoutput>#LB_Mensaje#</cfoutput></td></tr>
	</table>
</cfif>
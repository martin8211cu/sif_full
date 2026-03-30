<cfif isdefined("url.tipo") and not isdefined("form.tipo")>
	<cfset form.tipo = url.tipo >
</cfif>
<cfquery name="rsProyectos" datasource="#session.DSN#">
	select MEDproyecto, MEDnombre
	from MEDProyecto
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<!---and getdate() between MEDinicio and MEDfinal--->
</cfquery>

<cfoutput>
<form name="filtro" action="" method="post" style="margin:0;">
	<cfif isdefined("form.tipo")>
		<input type="hidden" value="#form.tipo#" >
	</cfif>
	
	<table width="100%" border="0" cellpadding="3" cellspacing="0" align="center" class="areaFiltro">
		<tr>
			<td align="right">Proyecto:&nbsp;</td>
			<td>
				<select name="fMEDproyecto">
					<option value="" >Todos</option> 						
					<cfloop query="rsProyectos">
						<option value="#rsProyectos.MEDproyecto#" <cfif isdefined("form.fMEDproyecto") and form.fMEDproyecto eq rsProyectos.MEDproyecto >selected</cfif>>#rsProyectos.MEDnombre#</option> 
					</cfloop>
				</select> 
			</td>		
			
			<cfif isdefined("form.fecha1") and len(trim(form.fecha1)) gt 0 >
				<cfset vfecha1 = form.fecha1 >
			<cfelse>
				<cfset vfecha1 = LSDateFormat(DateAdd('m', -1, Now()),'dd/mm/yyyy')>
			</cfif>

			<cfif isdefined("form.fecha2") and len(trim(form.fecha2)) gt 0 >
				<cfset vfecha2 = form.fecha2 >
			<cfelse>
				<cfset vfecha2 = LSDateFormat(Now(),'dd/mm/yyyy')>
			</cfif>

			<td nowrap>Fecha Desde:&nbsp;</td>
			<td><cf_sifcalendario form="filtro" name="fecha1" value="#vfecha1#"></td>
			<td nowrap>Fecha Hasta:&nbsp;</td>
			<td><cf_sifcalendario form="filtro" name="fecha2"  value="#vfecha2#"></td>

			<cfif isdefined("form.tipo") and form.tipo eq 3>
				<td nowrap align="right">Ver por:&nbsp;</td>
				<td>
					<select name="fTipo" onChange="javascript:semana();" >
						<option value="mm" <cfif isdefined("form.fTipo") and form.fTipo eq 'mm' >selected</cfif> >Mes</option>
						<option value="wk" <cfif isdefined("form.fTipo") and form.fTipo eq 'wk' >selected</cfif> >Semana</option>
					</select>
				</td>
			</cfif>
		</tr>
		
		<tr>
			<td nowrap align="right">Moneda:&nbsp;</td>
			<td>
				<select name="fMoneda" >
					<option value="" >Todas</option>
					<option value="USD" <cfif isdefined("form.fMoneda") and form.fMoneda eq 'USD' >selected</cfif> >USD</option>
					<option value="CRC" <cfif isdefined("form.fMoneda") and form.fMoneda eq 'CRC' >selected</cfif> >CRC</option>
				</select>
			</td>

			<cfif isdefined("form.tipo") and form.tipo eq 1>
				<td nowrap align="right">Cantidad:&nbsp;</td>
				<td>
					<select name="fCantidad" >
					 <option value="10" <cfif isdefined("form.fCantidad") and fCantidad eq 10 >selected</cfif> >10</option>
					 <option value="20" <cfif isdefined("form.fCantidad") and fCantidad eq 20 >selected</cfif> >20</option>
					</select>
				</td>
			<cfelseif isdefined("form.tipo") and form.tipo eq 2>
				<td nowrap align="right">Ver:&nbsp;</td>
				<td>
					<select name="fVer" >
						 <option value="R" <cfif isdefined("form.fVer") and fVer eq 'R' >selected</cfif> >Resumido</option>
						 <option value="D" <cfif isdefined("form.fVer") and fVer eq 'D' >selected</cfif> >Detallado</option>
					</select>
				</td>
			</cfif>

			<td align="center" colspan="2" >
				<input type="submit" name="btnFiltrar" value="Filtrar">
				<input type="reset" name="btnLimpiar" value="Limpiar">
			</td>
		</tr>
	</table>
</form>
</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function semana(){
		if ( document.filtro.fMes.value != '' ){
			document.filtro.fTipo.value = 'wk';
		}
	}
</script>
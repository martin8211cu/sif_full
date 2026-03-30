<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}" returnvariable="CPPfechaDesde">
<cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}" returnvariable="CPPfechaHasta">
<cfquery name="Periodos" datasource="#session.dsn#">
	select CPPid, case a.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
			#_Cat# ' de ' #_Cat# 
		case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
			#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaDesde)#
			#_Cat# ' a ' #_Cat# 
		case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
			#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaHasta)#
		as Pdescripcion
	from CPresupuestoPeriodo a
	where Ecodigo = #Session.Ecodigo#
	and (select count(1) from FPPreciosArticulo pre where pre.Ecodigo = a.Ecodigo and pre.CPPid = a.CPPid ) = 0
	order by CPPanoMesDesde,CPPfechaDesde,CPPfechaHasta
</cfquery>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Nueva Estimación de Egresos e Ingresos">
	<cf_templatecss>
		<form name="nuevosPrecios">
			<table width="100%">
				<tr><td align="center"><em><strong>Elija el Periodo Presupuestal</strong></em></td></tr>
				<tr align="center">
					<td>
						<select name="CPPid">
						  <cfloop query="Periodos">
							  <cfoutput><option value="#Periodos.CPPid#">#Periodos.Pdescripcion#</option></cfoutput>
						  </cfloop>
						</select>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td align="center">
					<input name="btnAgregar" value="Agregar Articulos" class="btnGuardar" type="submit" onclick="funcCargar_Articulos()" />
					<input name="btnClose" value="Cerrar" class="btnNormal"   type="submit" onclick="window.close();" />
				</td></tr>
			</table>
		</form>
<cf_web_portlet_end>
<script language="javascript">
	function funcCargar_Articulos()
		{
			
			var CPPid = document.nuevosPrecios.CPPid.value;
			 <cfoutput>document.location.href = 'EstimacionPrecio-sql.cfm?CPPid='+CPPid+'&btnCargar_Articulos=true'</cfoutput>;
			window.opener.location.href = 'EstimacionPrecio.cfm?CPPid='+CPPid;
			window.close();
		}
</script>
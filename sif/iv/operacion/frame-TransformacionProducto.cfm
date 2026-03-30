<cfquery name="rsTransformacion" datasource="#Session.DSN#">
select 

		a.ETid,              
		a.ETdocumento,     
		a.Ecodigo,         
		a.Usucodigo,     
		a.Ulocalizacion, 
		a.ETfecha,         
		a.ETfechaProc, 
		a.ETcostoProd, 
		a.ETobservacion, 
		a.ts_rversion,     
		a.BMUsucodigo,
		c.Acodigo, 
		c.Adescripcion, 
		b.descripcion, 
		b.TPid,
		b.cant, 
		case when b.cant <> 0 then coalesce(b.costolin, 0.00) / b.cant else b.costou end as costou, 
		coalesce(b.costolin, 0.00) as costolin, 
		b.TipoES
			from ETransformacion a
				inner join TransformacionProducto b
				on a.ETid = b.ETid
					inner join Articulos c
					on b.Ecodigo = c.Ecodigo
					and b.Aid = c.Aid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.ETfechaProc is null
	and b.Tipmov = 'P'
	order by c.Acodigo, c.Adescripcion
</cfquery>


<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="javascript" type="text/javascript">
	function validar(f) {
	  <cfoutput query="rsTransformacion">
	  	f.costou_#rsTransformacion.TPid#.value = qf(f.costou_#rsTransformacion.TPid#.value);
	  </cfoutput>
	}
</script>

<cfoutput>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Transformacion de Producto">
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td class="tituloListas">Cod. Art&iacute;culo</td>
			<td class="tituloListas">Art&iacute;culo</td>
			<td class="tituloListas">Movimiento</td>
			<td class="tituloListas" align="right">Cantidad</td>
			<td class="tituloListas" align="right">Costo Unidad</td>
			<td class="tituloListas" align="right">Costo L&iacute;nea</td>
			<td class="tituloListas" align="center">E/S</td>
		  </tr>
		  <cfloop query="rsTransformacion">
		  <tr class="lista<cfif currentRow MOD 2 EQ 0>Par<cfelse>Non</cfif>">
			<td>#rsTransformacion.Acodigo#</td>
			<td>#rsTransformacion.Adescripcion#</td>
			<td>#rsTransformacion.descripcion#</td>
			<td align="right">
				<cfif Len(Trim(rsTransformacion.cant))>
					#LSNumberFormat(rsTransformacion.cant, ',9.0000')#
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			<td align="right">
				<input name="costou_#rsTransformacion.TPid#" type="text" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,5);"  onKeyUp="if(snumber(this,event,5)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif Len(Trim(rsTransformacion.costou))>#LSNumberFormat(rsTransformacion.costou, ',9.00000')#<cfelse>0.00000</cfif>">
			</td>
			<td align="right">
				<cfif Len(Trim(rsTransformacion.costolin))>
					#LSNumberFormat(rsTransformacion.costolin, ',9.0000')#
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			<td align="center">
				#rsTransformacion.TipoES#
			</td>
		  </tr>
		  </cfloop>
		</table>
	<cf_web_portlet_end>
</cfoutput>

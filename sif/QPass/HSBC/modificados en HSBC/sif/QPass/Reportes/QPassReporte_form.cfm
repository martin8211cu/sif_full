<cf_htmlReportsHeaders 
	irA="QPassReporte.cfm"
	FileName="TagsExistentes.xls"
	title="Reporte Tags">
<cfif not isdefined("form.btnDownload")>  
<cf_templatecss>
</cfif>

<style type="text/css">
<!--
.style5 {font-size: 18px; font-weight: bold; }
-->
</style>

<cfset Fecha=LSDateFormat(now(),'dd/mm/yyyy')>

<cfquery name="rsEmpresa" datasource="#session.dsn#">
        select Enombre
        from Empresa
	where CEcodigo = #session.CEcodigo#
</cfquery>
<cfquery datasource="#session.DSN#" name="rsTags">
		select 
			o.Odescripcion,
			b.QPLcodigo,
			<cf_dbfunction name="concat" args="p.Pnombre + ' ' + p.Papellido1 + ' ' + p.Papellido2 " delimiters = "+"> as usuario,
			u.Usulogin,
			a.QPTidTag, 
			a.QPTNumParte, 
			a.QPTFechaProduccion, 
			a.QPTNumSerie, 
			a.QPTPAN, 
			a.QPTNumLote,
			a.QPTNumPall,
			case a.QPTEstadoActivacion when 90 then 'Eliminado' when 1 then 'Disponible'  when 2 then 'Recuperado' else '' end as QPTEstadoActivacion,			
			a.QPidLote, 
			a.QPidEstado,
			a.BMFecha, 
			a.BMusucodigo,
			a.Ecodigo, 
			a.Ocodigo 
		from QPassTag a
			inner join QPassLote b
				on a.QPidLote=b.QPidLote
			inner join Oficinas o
				on a.Ocodigo = o.Ocodigo
				and a.Ecodigo = o.Ecodigo
			inner join Usuario u
					on a.BMusucodigo = u.Usucodigo
				inner join DatosPersonales p 
						on p.datos_personales = u.datos_personales 
		where  a.Ecodigo =#session.Ecodigo#
		and QPTEstadoActivacion  in (1,2,7,90)
		order by o.Odescripcion
</cfquery>

		
<style type="text/css">
	 .RLTtopline {
	  border-bottom-width: 1px;
	  border-bottom-style: solid;
	  border-bottom-color:#000000;
	  border-top-color: #000000;
	  border-top-width: 1px;
	  border-top-style: solid;
	 } 
</style>
<cfif isdefined('form.corte')>
	<cfset LvarColSpan = 6>
<cfelse>
	<cfset LvarColSpan = 7>
</cfif>


<table width="100%" cellpadding="0" cellspacing="1" border="0">	
<cfoutput>
	<tr align="center" bgcolor="E3EDEF">
		<td style="font-size:18px" colspan="#LvarColSpan#">
		#rsEmpresa.Enombre#
		</td>
	</tr>
	
	<tr align="center" bgcolor="E3EDEF">
		<td style="font-size:18px" colspan="#LvarColSpan#">
		<strong>Reporte de TAGs</strong>
		</td>
	</tr>
	
	<tr align="center" bgcolor="E3EDEF">
		<td align="right" style="width:1%" colspan="#LvarColSpan#">
			<strong>Usuario:#session.usulogin#</strong>
		</td>
	</tr>
	
	<tr align="center" bgcolor="E3EDEF">
		<td align="right" colspan="#LvarColSpan#">
			<strong>Fecha:#Fecha#</strong>
		</td>
	</tr>
</cfoutput>
	<cfif isdefined('form.corte')>
    	
		<cfoutput query="rsTags"  group="Odescripcion">
			<tr><td colspan="#LvarColSpan#">&nbsp;</td></tr>
            <tr bgcolor="E3EDEF" nowrap="nowrap" style="background-color:E3EDEF" align="center" class="tituloListas">
                <td colspan="6" align="left">
                    Sucursal:&nbsp;#rsTags.Odescripcion#
                </td>
            </tr>
            
            <tr bgcolor="E3EDEF" nowrap="nowrap" style="background-color:E3EDEF" align="center" class="tituloListas">
                <td align="left" nowrap="nowrap">TAG</td>
                <td align="left" nowrap="nowrap">PALL</td>
                <td align="left" nowrap="nowrap">Lote</td>
                <td align="left" nowrap="nowrap">Fecha</td>
                <td align="left" nowrap="nowrap">Usuario</td>
                <td align="left" nowrap="nowrap">Estado</td>

            </tr>
	    
            <cfoutput>
            <tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
				<td align="left">#rsTags.QPTPAN#</td>
				<td align="left">#rsTags.QPTNumPall#</td>
				<td align="left">#rsTags.QPLcodigo#</td>	
				<td align="left">#LSDateFormat(rsTags.BMFecha,'dd/mm/yyyy')#</td>
				<td align="left">#rsTags.Usulogin#</td>	
				<td align="left">#rsTags.QPTEstadoActivacion#</td>	
            </tr>
			</cfoutput>
		</cfoutput>
	<cfelse>		
		<cfoutput>
		<tr bgcolor="E3EDEF" nowrap="nowrap" style="background-color:E3EDEF" align="center" class="tituloListas">
			<td nowrap="nowrap" colspan="0" align="left">Sucursal</td>
			<td colspan="0" align="left" nowrap="nowrap">TAG</td>
			<td colspan="0" align="left" nowrap="nowrap">PALL</td>
			<td colspan="0" align="left" nowrap="nowrap">Lote</td>
            <td align="left" nowrap="nowrap">Fecha</td>
            <td align="left" nowrap="nowrap">Usuario</td>
                <td align="left" nowrap="nowrap">Estado</td>
		<cfloop query="rsTags">
		</tr>
		<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td align="left">#rsTags.Odescripcion#</td>
			<td align="left">#rsTags.QPTPAN#</td>
			<td align="left">#rsTags.QPTNumPall#</td>
			<td align="left">#rsTags.QPLcodigo#</td>	
			<td align="left">#LSDateFormat(rsTags.BMFecha,'dd/mm/yyyy')#</td>	
			<td align="left">#rsTags.Usulogin#</td>	
			<td align="left">#rsTags.QPTEstadoActivacion#</td>	
		</tr>
		</cfloop>
		</cfoutput>
	</cfif>		
		<tr><td align="center" nowrap="nowrap" colspan="5">***Fin de Linea***</td></tr>
</table>






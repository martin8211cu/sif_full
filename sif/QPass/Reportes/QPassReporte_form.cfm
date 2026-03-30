<cf_htmlReportsHeaders 
	irA="QPassReporte.cfm"
	FileName="TagsExistentes.xls"
	title="Reporte Tags">
<cfif not isdefined("form.btnDownload")>  
<cf_templatecss>
</cfif>

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
			case a.QPTEstadoActivacion 
            	when 90 then 'Eliminado' 
                when 1 then 'Disponible'  
                when 2 then 'Recuperado'
                when 9 then 'Diponible (Promotor)' 
					 when 7 then 'Robado/Extraviado'
                else '' 
            end as QPTEstadoActivacion,			
			a.QPidLote, 
			a.QPidEstado,
			a.BMFecha, 
			a.BMusucodigo,
			a.Ecodigo, 
			a.Ocodigo 
		from QPassTag a
			inner join QPassLote b
				on b.QPidLote=a.QPidLote
			inner join Oficinas o
				on o.Ocodigo = a.Ocodigo
				and o.Ecodigo = a.Ecodigo
			inner join Usuario u
					on u.Usucodigo = a.BMusucodigo  
				inner join DatosPersonales p 
						on p.datos_personales = u.datos_personales 
		where  a.Ecodigo =#session.Ecodigo#
		and a.QPTEstadoActivacion  in (1,2,7,9,90)
		order by o.Odescripcion
</cfquery>

<cfif isdefined('form.corte')>
	<cfset LvarColSpan = 6>
<cfelse>
	<cfset LvarColSpan = 7>
</cfif>


<table width="100%" cellpadding="0" cellspacing="1" border="0">	
<cfoutput>
	<tr align="center">
		<td style="font-size:18px" colspan="#LvarColSpan#" class="tituloListas">
		#rsEmpresa.Enombre#
		</td>
	</tr>
	
	<tr align="center">
		<td style="font-size:18px" colspan="#LvarColSpan#" class="tituloListas">
		<strong>Reporte de TAGs</strong>
		</td>
	</tr>
	
	<tr align="center">
		<td align="right" style="width:1%" colspan="#LvarColSpan#" class="tituloListas">
			<strong>Usuario:#session.usulogin#</strong>
		</td>
	</tr>
	
	<tr align="center">
		<td align="right" colspan="#LvarColSpan#" class="tituloListas">
			<strong>Fecha:#Fecha#</strong>
		</td>
	</tr>
	
</cfoutput>
	<cfif isdefined('form.corte')>
    	
		<cfoutput query="rsTags"  group="Odescripcion">
            <tr>
                <td colspan="#LvarColSpan#" class="tituloAlterno"></td>
            </tr>			
            <tr nowrap="nowrap" align="center" class="tituloListas">
                <td colspan="6" align="left">
                    Sucursal:&nbsp;#rsTags.Odescripcion#
                </td>
            </tr>
            
            <tr nowrap="nowrap" align="center" class="tituloListas">
                <td align="left" nowrap="nowrap">TAG</td>
                <td align="left" nowrap="nowrap">PALL</td>
                <td align="left" nowrap="nowrap">Lote</td>
                <td align="left" nowrap="nowrap">Fecha</td>
                <td align="left" nowrap="nowrap">Usuario</td>
                <td align="left" nowrap="nowrap">Estado</td>
            </tr>
	    
            <cfoutput>
            <tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
				<td align="left">&nbsp;#rsTags.QPTPAN#</td>
				<td align="left">&nbsp;#rsTags.QPTNumPall#</td>
				<td align="left">&nbsp;#rsTags.QPLcodigo#</td>	
				<td align="left">#LSDateFormat(rsTags.BMFecha,'dd/mm/yyyy')#</td>
				<td align="left">#rsTags.Usulogin#</td>	
				<td align="left">#rsTags.QPTEstadoActivacion#</td>	
            </tr>
			</cfoutput>
			<tr>
                <td colspan="#LvarColSpan#">&nbsp;</td>
            </tr>			
		</cfoutput>
	<cfelse>		
		<cfoutput>
		<tr>
			<td colspan="#LvarColSpan#" class="tituloAlterno"></td>
		</tr>			
		<tr nowrap="nowrap" align="center" class="tituloListas">
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
			<td align="left">&nbsp;#rsTags.QPTPAN#</td>
			<td align="left">&nbsp;#rsTags.QPTNumPall#</td>
			<td align="left">&nbsp;#rsTags.QPLcodigo#</td>	
			<td align="left">#LSDateFormat(rsTags.BMFecha,'dd/mm/yyyy')#</td>	
			<td align="left">#rsTags.Usulogin#</td>	
			<td align="left">#rsTags.QPTEstadoActivacion#</td>	
		</tr>
		</cfloop>
		</cfoutput>
	</cfif>		
		<tr><td align="center" nowrap="nowrap" colspan="5">***Fin de Linea***</td></tr>
</table>






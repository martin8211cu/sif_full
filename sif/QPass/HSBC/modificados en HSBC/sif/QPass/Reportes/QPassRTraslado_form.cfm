<cf_htmlReportsHeaders 
	irA="QPassRTraslado.cfm"
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

<cfset Fecha=DateFormat(now(),'dd/mm/yyyy')>


<cfquery name="rsEmpresa" datasource="#session.dsn#">
        select Enombre
        from Empresa
	where CEcodigo = #session.CEcodigo#
</cfquery>
<cfquery datasource="#session.DSN#" name="rsTags">
	select 
		t.Usucodigo,
		t.BMFecha,	
		t.QPTtrasDocumento,
		o.Odescripcion,
		b.QPLcodigo,
		u.Usulogin,
		a.QPTidTag, 
		a.QPTPAN, 
		a.QPTNumLote,
		a.QPTNumPall,
		case a.QPTEstadoActivacion when 8 then 'En Traslado' else '' end as QPTEstadoActivacion			
		from QPassTag a
			inner join QPassLote b
				on a.QPidLote=b.QPidLote
			inner join Oficinas o
				on a.Ocodigo = o.Ocodigo
				and a.Ecodigo = o.Ecodigo
			inner join QPassTrasladoOfi x
				on a.QPTidTag = x.QPTidTag
			inner join QPassTraslado t
				on x.QPTid = t.QPTid
			inner join Usuario u
				on t.Usucodigo= u.Usucodigo
		where  a.Ecodigo =#session.Ecodigo#
		and QPTEstadoActivacion  in (8)
		and x.QPTOEstado = 0
		order by o.Odescripcion,t.QPTtrasDocumento
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
	<cfset LvarColSpan = 7>
<cfelse>
	<cfset LvarColSpan = 8>
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
    	
		<cfoutput query="rsTags"  group="QPTtrasDocumento">
			<tr><td colspan="#LvarColSpan#">&nbsp;</td></tr>
            <tr bgcolor="E3EDEF" nowrap="nowrap" style="background-color:E3EDEF" align="center" class="tituloListas">
                <td colspan="7" align="left">
                    Sucursal:&nbsp;#rsTags.Odescripcion#
                </td>
            </tr>
            
            <tr bgcolor="E3EDEF" nowrap="nowrap" style="background-color:E3EDEF" align="center" class="tituloListas">
                <td align="left" nowrap="nowrap">Documento</td>
                <td align="left" nowrap="nowrap">TAG</td>
                <td align="left" nowrap="nowrap">PALL</td>
                <td align="left" nowrap="nowrap">Lote</td>
                <td align="left" nowrap="nowrap">Fecha</td>
                <td align="left" nowrap="nowrap">Usuario</td>
                <td align="left" nowrap="nowrap">Estado</td>

            </tr>
            <cfoutput>
            <tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
				<td align="left">#rsTags.QPTtrasDocumento#</td>
				<td align="left">&nbsp;#rsTags.QPTPAN#</td>
				<td align="left">&nbsp;#rsTags.QPTNumPall#</td>
				<td align="left">&nbsp;#rsTags.QPLcodigo#</td>	
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
			<td colspan="0" align="left" nowrap="nowrap">Documento</td>
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
			<td align="left">#rsTags.QPTtrasDocumento#</td>
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






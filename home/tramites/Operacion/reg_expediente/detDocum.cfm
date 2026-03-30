<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Detalle del documento</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<cf_templatecss>
</head>

<body>
	<cfquery name="rsDocumentosDet" datasource="#session.tramites.dsn#">
		select
				r.id_registro,
				d.BMfechamod as fecha, 
				d.nombre_documento,
				tc.nombre_campo,
				c.valor,
				d.id_tipo
		from DDRegistro r
		
		inner join DDCampo c
		on c.id_registro=r.id_registro
		
		inner join DDTipo t
		on t.id_tipo=r.id_tipo
		
		inner join DDTipoCampo tc
		on tc.id_tipo=t.id_tipo
		and tc.id_campo=c.id_campo
		
		inner join TPDocumento d
		on d.id_tipo=t.id_tipo
		
		where r.id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.persona#">
			and r.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.tipo#">	
			and r.id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.regis#">	
		order by fecha
	</cfquery>	
	
	<cfquery name="data" datasource="#session.tramites.dsn#">
		select 	p.id_persona,
			   	p.id_direccion, 
				p.identificacion_persona, 
				p.nombre, 
				p.apellido1, 
				p.apellido2, 
				p.foto, 
				p.ts_rversion
		from TPPersona p
		left join TPDirecciones d
		on p.id_direccion = d.id_direccion		
		where identificacion_persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.identif_per)#">
		and p.id_tipoident = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tipoident#">
	</cfquery>	
	
	<table width="100%"  border="0" cellspacing="0" cellpadding="3">
		  <tr>
			<td colspan="2">
			<cfif isdefined('data') and data.recordCount GT 0>
				<table align="center" width="520" cellpadding="2" cellspacing="0">
					<tr>
						<td valign="top">
							<cfoutput>
								<cfif Len(data.foto) GT 1>
									<cfinvoke component="sif.Componentes.DButils"
									method="toTimeStamp"
									returnvariable="tsurl">
									<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
									</cfinvoke>							
									<img align="middle" width="78" height="90" src="/cfmx/home/tramites/Operacion/gestion/foto_persona.cfm?s=#URLEncodedFormat(data.id_persona)#&amp;ts=#tsurl#" border="0" >
								<cfelse>
									<img align="middle"  width="78" height="90" src="/cfmx/home/public/not_avail.gif" border="0" >
								</cfif>
							</cfoutput>	
						</td>
						<td valign="top">
							<cfoutput>
								<table width="100%" cellpadding="2" cellspacing="0" border="0">
									<tr>
										<td valign="middle">
										#url.nombTipoIdentif# #data.identificacion_persona#</td>
									</tr>
	
									<tr>
										<td valign="top">
										#data.nombre# #data.apellido1# #data.apellido2#</td>
									</tr>
						
									<tr>
										<td valign="top">  
											<cfif len(trim(data.id_direccion))>
												<cf_tr_direccion key="#data.id_direccion#" action="display">
											</cfif>
										</td>
									</tr>
	
								</table>
							</cfoutput>								
						</td>
					</tr>
				</table>			
			</cfif>
			</td>
		  </tr>			
	
		<cfif isdefined('rsDocumentosDet') and rsDocumentosDet.recordCount GT 0>
			  <tr>
				<td colspan="2" align="center" class="tituloMantenimiento"><cfoutput>#rsDocumentosDet.nombre_documento#</cfoutput></td>
			  </tr>				
			  <tr>
				<td colspan="2">&nbsp;</td>
			  </tr>						  
			<cfoutput query="rsDocumentosDet">
				<tr <cfif rsDocumentosDet.currentrow mod 2>bgcolor="##EEEEEE"</cfif>>
					<td width="243" align="right" nowrap><strong>#rsDocumentosDet.nombre_campo#:</strong></td>
					<td width="302" nowrap>&nbsp;&nbsp;&nbsp;#rsDocumentosDet.valor#</td>		
				</tr>			
			</cfoutput>	
		<cfelse>
		  <tr>
			<td>&nbsp;</td>
		  </tr>				
		  <tr>
			<td>&nbsp;</td>
		  </tr>				
		  <tr>
			<td>-- No se encontraron registros --</td>
		  </tr>		
		  <tr>
			<td>&nbsp;</td>
		  </tr>				
		  <tr>
			<td>&nbsp;</td>
		  </tr>				
		</cfif>
	</table>
	
</body>
</html>

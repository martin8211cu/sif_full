<cfif isdefined("Url.tab") and not isdefined("Form.tab")>
	<cfparam name="Form.tab" default="#Url.tab#">
</cfif>
<cfif isdefined("Url.persona") and not isdefined("Form.persona")>
	<cfset Form.persona = Url.persona>
</cfif>
<cfif isdefined("form.persona")>
	<cfparam name="Form.persona" default="#form.persona#">
</cfif> 

<cfif  isdefined("form.persona") and len(trim(form.persona)) neq 0 >
	<cfquery datasource="#Session.Edu.DSN#" name="rsDatosEstud">
	select c.Ndescripcion, d.Gdescripcion, e.SPEdescripcion, f.GRnombre,
	convert(varchar,f.GRcodigo) as GRcodigo, 
	convert(varchar,e.SPEcodigo) as SPEcodigo,
	convert(varchar,e.PEcodigo) as PEcodigo
	from Alumnos  a 
	inner join PersonaEducativo pe
	   on pe.CEcodigo = a.CEcodigo
	  and pe.persona = a.persona
	inner join Promocion b
	   on b.PRcodigo = a.PRcodigo
	inner join Grado d
	   on d.Ncodigo = b.Ncodigo
	  and d.Gcodigo = b.Gcodigo
	inner join Nivel c
	   on c.Ncodigo = d.Ncodigo
	inner join SubPeriodoEscolar e
	   on e.PEcodigo = b.PEcodigo
	  and e.SPEcodigo = b.SPEcodigo
	inner join Grupo f
	   on f.Ncodigo = b.Ncodigo
	  and f.Gcodigo = b.Gcodigo
	  and f.PEcodigo = b.PEcodigo
	  and f.SPEcodigo = b.SPEcodigo
	inner join PeriodoVigente pv
	   on pv.PEcodigo = b.PEcodigo
	  and pv.SPEcodigo = b.SPEcodigo
	where  a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	   and a.persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.persona#">
	</cfquery>

	<cfquery datasource="#Session.Edu.DSN#" name="rsAlumnoCED">
		Select convert(varchar,a.persona) as persona, 
		       convert(varchar,a.CEcodigo) as CEcodigo, 
			   Papellido1 + ' ' + Papellido2 + ',' + a.Pnombre as nombre,
			   a.Ppais, 
			   Papellido1,
			   Papellido2,
			   b.Pnombre, 
			   a.TIcodigo, 
			   TInombre, 
			   Pid, 
			   convert(varchar,Pnacimiento,103) as Pnacimiento, 
			   Psexo, 
			   Pemail1, 
			   Pemail2, 
			   Pdireccion, 
			   Pcasa, 
			   Pfoto, 
			   PfotoType, 
			   PfotoName, 
			   Pemail1validado, 
			   convert(varchar,d.PRcodigo) as PRcodigo, 
			   Aretirado,
			   d.CEcontrato,
			   isnull(Gdescripcion,'sin grado asociado') as Gdescripcion,
			   e.autorizado
		from PersonaEducativo a
		inner join Alumnos d
		   on d.CEcodigo = a.CEcodigo
		  and d.persona = a.persona
		inner join Estudiante e
		   on e.Ecodigo = d.Ecodigo
		inner join Promocion f
		   on f.PRcodigo = d.PRcodigo
		inner join Grado g
		   on g.Gcodigo = f.Gcodigo
		inner join Pais b
		   on b.Ppais = a.Ppais
		inner join TipoIdentificacion c
		   on c.TIcodigo = a.TIcodigo
		where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and a.CEcodigo=d.CEcodigo
			and a.persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			and a.Ppais=b.Ppais
			and a.TIcodigo=c.TIcodigo
			and a.persona=d.persona
			and d.Ecodigo=e.Ecodigo
			and d.PRcodigo=f.PRcodigo
			and f.Gcodigo=g.Gcodigo		
	</cfquery>
</cfif>

<cfoutput>
<table width="100%" border="0" cellpadding="4" cellspacing="0" >
  <tr align="right">

		<td width="15%" align="center">
			<table width="54" height="79" border="1">
				<tr> 
					<td width="51" align="center" valign="middle">
						<cfif rsAlumnoCED.RecordCount neq 0>
							<cfif Len(rsAlumnoCED.Pfoto) EQ 0>
								Fotograf&iacute;a no disponible 
							<cfelse>
								<cf_LoadImage tabla="PersonaEducativo" columnas="Pfoto as contenido, persona as codigo" condicion="persona=#Form.persona#" imgname="Foto" width="54" height="77" alt="#rsAlumnoCED.Pnombre#  #rsAlumnoCED.Papellido1#  #rsAlumnoCED.Papellido2#">
							</cfif>
						<cfelse>
							Fotograf&iacute;a 
						</cfif> 
					</td>
				</tr>
			</table>
		</td>
	<td width="85%" align="left">
		<table width="100%" border="0">
        <tr>
			<td align="left" nowrap> <strong>Nombre:</strong>&nbsp; <cfoutput>#rsAlumnoCED.nombre#</cfoutput>
			</td>
		</tr>
		<cfif rsDatosEstud.RecordCount NEQ 0>
			<tr>
				<td width="40%"> 
					<input type="hidden" name="GRcodigo" value="<cfoutput>#rsDatosEstud.GRcodigo#</cfoutput>"> 
				</td>
				<td width="68%">&nbsp;</td>
			</tr>
			<tr>
				<td nowrap><strong>Nivel:</strong><cfoutput>#rsDatosEstud.Ndescripcion#</cfoutput></td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td nowrap><strong>Grado:</strong><cfoutput>#rsDatosEstud.Gdescripcion#</cfoutput></td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td nowrap><strong>Grupo:</strong><cfoutput> #rsDatosEstud.GRnombre# 
				</cfoutput></td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td nowrap>
					<strong>
						Curso Lectivo:
					</strong>
					<cfoutput> 
						#rsDatosEstud.SPEdescripcion# 
					</cfoutput>
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
		</cfif>
     </table>
	
	</td> 
</table>
</cfoutput>

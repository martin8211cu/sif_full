<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfquery name="rsCur" datasource="#session.dsn#">
	select RHCid,RHCnombre,RHCcodigo,RHCfdesde,RHCfhasta,horaini,horafin,duracion,lugar,
	case RHCtipo 
	when 'A' then 'Aprovechamiento'
	when 'P' then 'Participación'
	end as RHCtipo,c.RHIid,m.Mdescripcion
	,coalesce(i.RHInombre,'') #LvarCNCT# ' ' #LvarCNCT# coalesce(i.RHIapellido1,'')#LvarCNCT# ' '#LvarCNCT# coalesce(i.RHIapellido2,'') as Nombre
		from RHCursos c
		inner join RHInstructores i
		on i.RHIid=c.RHIid
		
		inner join RHMateria m
		on m.Mcodigo=c.Mcodigo
		
		and i.Ecodigo=#session.Ecodigo#
	where RHCid=#url.RHCid#
</cfquery>

<cfoutput>
	<table width="100%" bgcolor="e6eef5">
		<tr bordercolor="add5f8">
			<td align="center" bgcolor="add5f8">
				<strong>Curso:</strong>#rsCur.RHCcodigo#-#rsCur.RHCnombre#
			</td>
		</tr>	
		<tr align="center">
			<td>
				<strong>Fecha de inicio:</strong><cf_locale name="date" value="#rsCur.RHCfdesde#"/>
			</td>
		</tr>	
		<tr align="center">
			<td>
				<strong>Fecha de termino:</strong><cf_locale name="date" value="#rsCur.RHCfhasta#"/>
			</td>
		</tr>	
		<tr align="center">
			<td>
				<strong>Lugar:</strong>#rsCur.lugar#
			</td>
		</tr>	
		<tr align="center">
			<td>
				<strong>Instructor:</strong>#rsCur.Nombre#
			</td>
		</tr>
		<tr align="center">
			<td>
				<strong>Hora de inicio:</strong>#LSTimeFormat(rsCur.horaini,'HH:mm tt')#
			</td>
		</tr>	
		<tr align="center">
			<td>
				<strong>Hora de fin:</strong>#LSTimeFormat(rsCur.horafin,'HH:mm tt')#
			</td>
		</tr>	
		<tr align="center">
			<td>
				<strong>Duración:</strong>#rsCur.duracion#
			</td>
		</tr>	
		<tr align="center">
			<td>
				<strong>Modalidad:</strong>#rsCur.RHCtipo#
			</td>
		</tr>
		<tr align="center">
			<td valign="top">
				<strong>Generalidades del curso:</strong>
			</td>
		</tr>	
		<tr>
			<td align="center"><textarea name="Mdescripcion" rows="6" cols="40" style="font-family:Arial, Helvetica, sans-serif">#HTMLEditFormat(rsCur.Mdescripcion)#</textarea></td></td>
		</tr>	
	</table>
</cfoutput>


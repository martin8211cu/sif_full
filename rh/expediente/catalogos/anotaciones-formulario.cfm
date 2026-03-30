<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Registro de Acontecimientos Cr&iacute;ticos</title>
</head>

<body>

<cfif isdefined("Url.DEid") and Len(Trim(Url.DEid)) and isdefined("Url.RHAid") and Len(Trim(Url.RHAid))>
	
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css">
	<cfquery name="rsColaborador" datasource="#Session.DSN#">
		select a.DEidentificacion, rtrim(a.DEnombre || ' ' || a.DEapellido1 || ' ' || a.DEapellido2) as NombreCompleto,
			   c.CFcodigo || ' - ' || c.CFdescripcion as Centro,
			   rp.RHPdescpuesto as Puesto,
			   d.Ddescripcion as Depto,
			   (select min(x.DEid) from LineaTiempo x where x.Ecodigo = a.Ecodigo and x.RHPid = c.RHPid) as Jefe1,
			   (select min(y.DEid) from LineaTiempo y where y.Ecodigo = a.Ecodigo and y.RHPid = c2.RHPid) as Jefe2
		from DatosEmpleado a
			 inner join LineaTiempo lt
				on lt.DEid = a.DEid
				and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between lt.LTdesde and lt.LThasta
			 inner join RHPlazas p
				on p.RHPid = lt.RHPid
			 inner join CFuncional c
				on c.CFid = p.CFid
			 inner join RHPuestos rp
				on rp.Ecodigo = lt.Ecodigo
				and rp.RHPcodigo = lt.RHPcodigo
			 inner join Departamentos d
				on d.Ecodigo = lt.Ecodigo
				and d.Dcodigo = lt.Dcodigo
			 left outer join CFuncional c2
				on c2.CFid = c.CFidresp
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.DEid#">
	</cfquery>
	
	<cfquery name="rsAnotacion" datasource="#Session.DSN#">
		select a.EFid, a.RHAfecha, a.RHAfsistema, a.RHAdescripcion, 
			   a.Usucodigo, a.Ulocalizacion, a.BMUsucodigo,
			   case when a.RHAtipo = 1 then 'Positivo' else 'Negativo' end as impacto
		from RHAnotaciones a
		where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.RHAid#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.DEid#">
	</cfquery>
	
	<cfif Len(Trim(rsColaborador.Jefe1))>
		<cfquery name="rsJefe" datasource="#Session.DSN#">
			select a.DEidentificacion, rtrim(a.DEnombre || ' ' || a.DEapellido1 || ' ' || a.DEapellido2) as NombreCompleto
			from DatosEmpleado a
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsColaborador.Jefe1#">
		</cfquery>
	<cfelseif Len(Trim(rsColaborador.Jefe2))>
		<cfquery name="rsJefe" datasource="#Session.DSN#">
			select a.DEidentificacion, rtrim(a.DEnombre || ' ' || a.DEapellido1 || ' ' || a.DEapellido2) as NombreCompleto
			from DatosEmpleado a
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsColaborador.Jefe2#">
		</cfquery>
	</cfif>
	
	<cfoutput>
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr align="center">
		    <td colspan="4" class="tituloAlterno">Registro de Acontencimientos Cr&iacute;ticos </td>
	      </tr>
		  <tr align="right">
		    <td colspan="4"><strong>Fecha:&nbsp;</strong>#LSDateFormat(Now(), 'dd/mm/yyyy')#</td>
	      </tr>
		  <tr>
		    <td colspan="4">&nbsp;</td>
	      </tr>
		  <tr>
			<td align="right" width="25%"><strong>Nombre del Colaborador:&nbsp;</strong></td>
			<td>
				#rsColaborador.NombreCompleto#
			</td>
			<td align="right"><strong>Unidad de Negocio:&nbsp;</strong></td>
			<td>
				#rsColaborador.Centro#
			</td>
		  </tr>
		  <tr>
			<td align="right"><strong>Puesto:&nbsp;</strong></td>
			<td>
				#rsColaborador.Puesto#
			</td>
			<td align="right"><strong>Departamento:&nbsp;</strong></td>
			<td>
				#rsColaborador.Depto#
			</td>
		  </tr>
		  <tr>
			<td align="right"><strong>Jefe Inmediato:&nbsp;</strong></td>
			<td>
				<cfif isdefined("rsJefe") and rsJefe.recordCount>
					#rsJefe.NombreCompleto#
				</cfif>
			</td>
			<td align="right"><strong>Secci&oacute;n:&nbsp;</strong></td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td align="right"><strong>Periodo Evaluado:&nbsp;</strong></td>
			<td colspan="3">&nbsp;</td>
		  </tr>
		  <tr>
		  	<td align="right"><strong>Fecha del Acontecimiento:&nbsp;</strong></td>
		    <td colspan="3">#LSDateFormat(rsAnotacion.RHAfecha, 'dd/mm/yyyy')#</td>
	      </tr>
		  <tr>
		    <td colspan="4" align="right">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="4" align="right">&nbsp;</td>
	      </tr>
		  <tr>
		    <td align="right" style="font-size:12px; color:##0000CC"><strong>IMPACTO:&nbsp;</strong></td>
		    <td><strong>#rsAnotacion.impacto#</strong></td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="4" align="center">
			
				<table width="90%"  border="0" cellspacing="0" cellpadding="2" align="center" style="border: 1px solid black;">
				  <tr>
					<td class="tituloAlterno" align="center">Detalle del Acontecimiento</td>
				  </tr>
				  <tr>
				    <td style="border-top: 1px solid black;">&nbsp;</td>
			      </tr>
				  <tr>
				    <td>
						#rsAnotacion.RHAdescripcion#
					</td>
			      </tr>
				  <tr>
					<td>&nbsp;</td>
				  </tr>
				</table>
			</td>
	      </tr>
		  <tr>
		    <td colspan="4" align="right">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="4" align="right">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="4" align="right">&nbsp;</td>
	      </tr>
		  <tr align="center">
		    <td colspan="4">
				<table width="90%"  border="0" cellspacing="0" cellpadding="2">
              		<tr>
                <td style="border-bottom: 1px solid black;" width="30%">&nbsp;</td>
                <td width="15">&nbsp;</td>
                <td style="border-bottom: 1px solid black;" width="30%">&nbsp;</td>
                <td width="15">&nbsp;</td>
                <td style="border-bottom: 1px solid black;" width="30%">&nbsp;</td>
              </tr>
              <tr>
                <td align="center">Hecho por </td>
                <td width="15">&nbsp;</td>
                <td align="center">Jefe</td>
                <td width="15">&nbsp;</td>
                <td align="center">Empleado</td>
              </tr>
            </table></td>
	      </tr>
		  <tr><td colspan="4">&nbsp;</td></tr>
		 <tr align="center">
		    <td colspan="4">
				<table width="90%"  border="0" cellspacing="0" cellpadding="2">
              		<tr>
					<td style="border-bottom: 1px solid black;" width="30%">&nbsp;</td>
					<td width="15">&nbsp;</td><td width="30%">&nbsp;</td>
					<td width="15">&nbsp;</td><td width="30%">&nbsp;</td>
				  </tr>
				  <tr>
					<td align="center">Fecha de aceptaci&oacute;n </td>
					<td width="15">&nbsp;</td><td align="center">&nbsp;</td>
					<td width="15">&nbsp;</td><td align="center">&nbsp;</td>
				  </tr>
            	</table>
			</td>
	      </tr>
		  <tr>
		    <td colspan="4" align="right">&nbsp;</td>
	      </tr>
		</table>
	</cfoutput>
	
	<script language="javascript" type="text/javascript">
		window.print();
	</script>
<cfelse>
	<br>
	<p align="center">
		<strong>NO SE HA ESPECIFICADO UN EMPLEADO<br> O LA ANOTACION PARA EL EMPLEADO SELECCIONADO NO EXISTE</strong>
		<br>
		<br>
		<input type="button" name="btnCerrar" value="Cerrar" onClick="javascript: window.close();">
	</p>
</cfif>

</body>
</html>

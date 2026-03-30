<!---*********************************
	Módulo    : Control de Reponsables
	Nombre   : Reporte de Activos en Tránsito
	***********************************
	Hecho por: NA
	Creado    : NA
	***********************************
	Modificado por: Dorian Abarca Gómez
	Modificado: 18 Julio 2006
	Moficaciones:
	1. Se modifica para que se imprima y 
	baje a excel con el cf_htmlreportsheaders.
	2.	Se modifica para que se pinte con 
	el jdbcquery.
	3. Se verifica uso de cf_templateheader y 
	cf_templatefooter.
	4. Se verifica uso de cf_web_portlet_start
	y cf_web_portlet_end.
	5. Se agrega cfsetting y cfflush.
	6. Se envían estilos al head por medio 
	del cfhtmlhead.
	7. Se mantienen filtros de la consulta.
	***************************** --->
<cfsetting enablecfoutputonly="yes" showdebugoutput="no" requesttimeout="36000">
<!--- Pintado de los botones de regresar, impresión y exportar a excel. --->
<cf_htmlreportsheaders
	title="Historia Transacciones" 
	filename="HistoriaTransacciones#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls" 
	ira="HistoricoTransac.cfm">
<!--- Empieza a pintar el reporte en el usuario cada 512 bytes los bytes que toma en cuenta son de aquí en adelante omitiendo lo que hay antes, y la informació de los headers de la cantidad de bytes --->
<cfflush interval="512">
<!--- Consultas --->
<cfquery name="rsEncabezado" datasource="#session.DSN#">
	select distinct Adescripcion as descripcion,     
	<cf_dbfunction name="concat" args="DEidentificacion , '-' , DEnombre ,'-' , DEapellido1 , '-' , DEapellido2"> as empleado 
	from CRBitacoraTran a
	inner join AFResponsables b  
		on 	a.Ecodigo =b.Ecodigo 
		and a.AFRid = b.AFRid 
	inner join Activos c  
		on 	c.Ecodigo =b.Ecodigo 
		and c.Aid = b.Aid 
	inner join DatosEmpleado d  
		on 	d.Ecodigo =b.Ecodigo 
		and d.DEid =b.DEid
	where a.CRBPlaca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.AplacaINI#">
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfif isdefined("rsEncabezado") and rsEncabezado.recordcount gt 0 >
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select CRBfecha ,Usulogin,
		case CRBmotivo 
			when 1 then 'Inclusión' 
			when 2 then 'Retiro' 
			when 3 then 'Traslado de responsable' 
			when 4 then 'Traslado de centro de custodia' 
			when 5 then 'Mejora' 
			when 6 then 'Pendiente de inclusión por activos fijos' 
		end as motivo,
		DEidentificacion, 
		<cf_dbfunction name="concat" args="DEnombre ,'-' ,DEapellido1 ,'-' , DEapellido2">  as responsable,
		CRTDdescripcion
		from CRBitacoraTran  a
		inner join Usuario b  
			on a.Usucodigo  =b.Usucodigo 
		inner join AFResponsables c  
			on a.AFRid   = c.AFRid 
		inner join Activos d  
			on d.Aid  =  c.Aid 
			and d.Ecodigo = c.Ecodigo 
		inner join DatosEmpleado e  
			on e.DEid    = c.DEid
		inner join CRTipoDocumento f
			on f.CRTDid  = c.CRTDid
		where a.CRBPlaca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.AplacaINI#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		order by CRBid
	</cfquery>
</cfif>

<cfhtmlhead text="
<style>
			H1.Corte_Pagina
			{
			PAGE-BREAK-AFTER: always
			}
			<!--table
			{mso-displayed-decimal-separator:""\."";
			mso-displayed-thousand-separator:""\,"";}
			@page
			{margin:1.0in .75in 1.0in .75in;
			mso-header-margin:.5in;
			mso-footer-margin:.5in;}
			tr
			{mso-height-source:auto;}
			col
			{mso-width-source:auto;}
			br
			{mso-data-placement:same-cell;}
			.style0
			{mso-number-format:General;
			text-align:general;
			vertical-align:bottom;
			mso-rotate:0;
			mso-background-source:auto;
			mso-pattern:auto;
			color:windowtext;
			font-size:10.0pt;
			font-weight:400;
			font-style:normal;
			text-decoration:none;
			font-family:Arial;
			mso-generic-font-family:auto;
			mso-font-charset:0;
			border:none;
			mso-protection:locked visible;
			mso-style-name:Normal;
			mso-style-id:0;}
			.xl24
			{mso-style-parent:style0;
			mso-number-format:Standard;}
			.xl25
			{mso-style-parent:style0;
			font-size:8.0pt;
			font-weight:700;
			text-align:center;
			background:silver;
			mso-pattern:auto none;
			white-space:normal;}
			.xl25L
			{mso-style-parent:style0;
			font-size:7.0pt;
			font-weight:700;
			text-align:left;
			background:silver;
			mso-pattern:auto none;
			white-space:normal;}
			.xl25R
			{mso-style-parent:style0;
			font-size:7.0pt;
			font-weight:700;
			text-align:right;
			background:silver;
			mso-pattern:auto none;
			mso-number-format:Fixed;
			white-space:normal;} 
			.xl26
			{mso-style-parent:style0;
			font-size:8.0pt;
			font-weight:700;
			text-align: center;
			font-family:Arial, sans-serif;
			mso-font-charset:0;}
			.xl27
			{mso-style-parent:style0;
			font-size:7.5pt;
			font-weight:bold;
			text-align:right;
			font-family:Arial, sans-serif;
			mso-font-charset:0;}
			.xl28_R
			{mso-style-parent:style0;
			font-size:7.5pt;
			text-align:right;
			font-family:Arial, sans-serif;
			mso-font-charset:0;}
			.xl28R
			{mso-style-parent:style0;
			font-size:7.0pt;
			font-family:Arial, sans-serif;
			mso-font-charset:0;
			mso-number-format:Fixed;
			text-align:right;}
			.xl28LX
			{mso-style-parent:style0;
			font-size:8.0pt;
			text-align: left;
			font-weight:700;
			font-family:Arial, sans-serif;
			mso-number-format:""\@"";}		
			.xl28L
			{mso-style-parent:style0;
			font-size:7.5pt;
			text-align: left;
			font-family:Arial, sans-serif;
			mso-number-format:""\@"";}
			.xl28LS
			{mso-style-parent:style0;
			font-size:7.5pt;
			text-align: left;
			font-family:Arial, sans-serif;
			mso-number-format:""\@"";}	
			.xl29
			{mso-style-parent:style0;
			font-size:7.5pt;
			font-family:Arial, sans-serif;
			mso-number-format:""\@"";}
			.xl30
			{mso-style-parent:style0;
			font-size:8.0pt;
			font-weight:bold;
			text-align:left;
			mso-pattern:auto none;
			white-space:normal;}
			-->
		</style>">

<cfset CORTE1 = "">
<cfset CORTE2 = "">
<cfset Contadorlineas = 1>
<!--- Reporte--->
<cfoutput>
<table  width="100%" align="center"  border="0" cellspacing="0" cellpadding="2">
		<tr><td align="center" colspan="7"><cfinclude template="RetUsuario.cfm"></td></tr>
		<tr><td align="center" colspan="7"><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
		<tr><td align="center" colspan="7"><font size="2"><strong>Histórico para la placa #form.AplacaINI#</strong></font></td>
		</tr>
		<cfif  isdefined("rsEncabezado") and rsEncabezado.recordcount gt 0 >
			<tr><td align="center" colspan="7"><strong>#rsEncabezado.descripcion#</strong></td></tr>
			<!---
			<tr>
				<td  align="center" class="xl25" colspan="4" >Pertenece a : #rsEncabezado.Empleado#</td>
			</tr>
			--->
			<tr><td colspan="7"><hr></td></tr>
			<tr>
			<td width="10%" class="xl25L"><strong>Fecha</strong></td>
			<td width="10%" class="xl25L"><strong>Hora</strong></td>
			<td width="10%" class="xl25L"><strong>Usuario</strong></td>
			<td width="20%" class="xl25L"><strong>Transacción realizada</strong></td>
			<td width="10%" class="xl25L"><strong>Identificaci&oacute;n</strong></td>
			<td width="20%" class="xl25L"><strong>Responsable</strong></td>
			<td width="20%" class="xl25L"><strong>Tipo de Documento</strong></td>			
			</tr>			
		<cfelse>
			<tr>
				<td  align="center" class="xl25" colspan="7" >--- No se encontraron resgistros ---</td>
			</tr>
		</cfif>
		<cfif  isdefined("rsReporte") and rsReporte.recordcount gt 0 >
			<cfloop query="rsReporte">
				<cfif Contadorlineas gte 70>
					<!--- hace un corte de página y pinta los encabezados --->
					<tr><td  align="center" colspan="7" ><H1 class=Corte_Pagina></H1></td></tr>
					<tr><td align="center" colspan="7"><cfinclude template="RetUsuario.cfm"></td></tr>
					<tr>
						<td  align="center" class="xl25" colspan="7" >#session.Enombre#</td>
					</tr>
					<tr>
						<td  align="center" class="xl25" colspan="7" >Historico de transacciones para la placa #form.AplacaINI#</td>
					</tr>
					<tr>
						<td  align="center" class="xl25" colspan="7" >#rsEncabezado.descripcion#</td>
					</tr>
					<tr>
						<td  align="center" class="xl25" colspan="7" >#rsEncabezado.Empleado#</td>
					</tr>
					<tr><td colspan="7"><hr></td></tr>
					<tr>
						<td width="10%" class="xl25L"><strong>Fecha</strong></td>
						<td width="10%" class="xl25L"><strong>Hora</strong></td>
						<td width="10%" class="xl25L"><strong>Usuario</strong></td>
						<td width="20%" class="xl25L"><strong>Transacción realizada</strong></td>
						<td width="10%" class="xl25L"><strong>Identificacion</strong></td>
						<td width="20%" class="xl25L"><strong>Responsable</strong></td>
						<td width="20%" class="xl25L"><strong>Tipo de Documento</strong></td>												
					</tr>
					<cfset Contadorlineas = 1>
				</cfif>
				<tr>
					<td valign="top" class="xl28L">#LSDateFormat(rsReporte.CRBfecha,'dd/mm/yyyy')# </td>
					<td valign="top" class="xl28L">#LSTimeFormat(rsReporte.CRBfecha,'hh:mm:sstt')#</td>
					<td valign="top" class="xl28L">#trim(Usulogin)#  </td>
					<td valign="top" class="xl28L">#trim(motivo)# </td>
					<td valign="top" class="xl28L">#DEidentificacion#</td>
					<td valign="top" class="xl28L">#responsable#</td>
					<td valign="top" class="xl28L">#CRTDdescripcion#</td>
				</tr>
				<cfset Contadorlineas = Contadorlineas+1>		
			</cfloop>
		</cfif>
		<tr><td align="center"  colspan="7">&nbsp;</td></tr>
		<tr><td colspan="7" align="center"><strong> --- Fin del Reporte --- </strong></td></tr>
	</table>
</body>
</html>
</cfoutput>